using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using TechStoreWeb.Extensions;
using TechStoreWeb.Models;
using TechStoreWeb.Data;

namespace TechStoreWeb.Controllers
{
    public class CartController : Controller
    {
        private readonly AppDbContext _context;
        private const string SESSION_CART = "Cart";
        private const string SESSION_DISCOUNT = "CartDiscount";
        private const decimal SHIPPING_FEE = 20000m;

        public CartController(AppDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            var cart = GetCart();

            // Giá luôn được làm mới từ DB để giỏ hàng không giữ giá cũ đã đổi.
            RefreshPrices(cart);
            SaveCart(cart);

            ViewBag.Discount = HttpContext.Session.GetObject<decimal>(SESSION_DISCOUNT);
            return View(cart);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Add(int productId, int? variantId, int qty = 1, bool isBuyNow = false)
        {
            if (qty < 1) qty = 1;

            // Tên, giá và ảnh đều tra từ DB — không nhận từ client.
            var product = _context.Products.Find(productId);
            if (product == null)
            {
                return FailAdd("Sản phẩm không tồn tại.");
            }

            ProductVariant? variant = null;
            if (variantId.HasValue)
            {
                variant = _context.ProductVariants.FirstOrDefault(v => v.VariantId == variantId.Value && v.ProductId == productId);
                if (variant == null)
                {
                    return FailAdd("Phiên bản sản phẩm không hợp lệ.");
                }
            }

            var price = variant?.Price ?? product.Price;
            var name = variant == null ? product.Name : $"{product.Name} - {variant.Color} {variant.ROM}";
            var availableStock = variant?.Stock ?? product.Stock;

            var cart = GetCart();
            var cartId = CartItem.BuildId(productId, variantId);
            var existing = cart.FirstOrDefault(c => c.Id == cartId);
            var requestedTotal = (existing?.Qty ?? 0) + qty;

            if (availableStock <= 0)
            {
                return FailAdd($"\"{name}\" đã hết hàng.");
            }

            if (requestedTotal > availableStock)
            {
                return FailAdd($"\"{name}\" chỉ còn {availableStock} sản phẩm.");
            }

            if (isBuyNow)
            {
                foreach (var item in cart)
                {
                    item.Selected = false;
                }
            }

            if (existing != null)
            {
                existing.Qty = requestedTotal;
                existing.Price = price;
                existing.Name = name;
                existing.Selected = true;
            }
            else
            {
                cart.Add(new CartItem
                {
                    Id = cartId,
                    ProductId = productId,
                    VariantId = variantId,
                    Name = name,
                    Price = price,
                    Img = product.ImageUrl,
                    Qty = qty,
                    Selected = true
                });
            }

            SaveCart(cart);

            if (IsAjax())
            {
                return Json(new { success = true, message = "Đã thêm vào giỏ hàng" });
            }

            return Redirect(Request.Headers["Referer"].ToString() ?? "/");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult UpdateQty(string id, int qty)
        {
            var cart = GetCart();
            var item = cart.FirstOrDefault(c => c.Id == id);
            if (item != null)
            {
                qty = Math.Max(1, qty);
                var availableStock = GetAvailableStock(item);

                if (qty > availableStock)
                {
                    qty = Math.Max(1, availableStock);
                    TempData["ErrorMessage"] = $"\"{item.Name}\" chỉ còn {availableStock} sản phẩm.";
                }

                item.Qty = qty;
                SaveCart(cart);
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Remove(string id)
        {
            var cart = GetCart().Where(c => c.Id != id).ToList();
            SaveCart(cart);
            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ToggleSelect(string id, bool selected)
        {
            var cart = GetCart();
            var item = cart.FirstOrDefault(c => c.Id == id);
            if (item != null)
            {
                item.Selected = selected;
                SaveCart(cart);
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ApplyVoucher(string code)
        {
            decimal discount = 0;
            if (!string.IsNullOrEmpty(code) && (code.ToUpper() == "CHUACO" || code == "Chưa có"))
            {
                discount = 100000m;
            }
            HttpContext.Session.SetObject(SESSION_DISCOUNT, discount);
            return RedirectToAction("Index");
        }

        public IActionResult Checkout()
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null) return RedirectToAction("Login", "Account", new { returnUrl = "/Cart/Checkout" });

            var cart = GetCart();
            RefreshPrices(cart);
            SaveCart(cart);

            var selectedItems = cart.Where(c => c.Selected).ToList();
            if (!selectedItems.Any()) return RedirectToAction("Index");

            ViewBag.User = _context.Users.Find(userId);
            ViewBag.Discount = HttpContext.Session.GetObject<decimal>(SESSION_DISCOUNT);

            return View(selectedItems);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Checkout(string shippingAddress, string paymentMethod)
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null) return RedirectToAction("Login", "Account", new { returnUrl = "/Cart/Checkout" });

            if (string.IsNullOrWhiteSpace(shippingAddress))
            {
                TempData["ErrorMessage"] = "Vui lòng nhập địa chỉ giao hàng.";
                return RedirectToAction("Checkout");
            }

            var cart = GetCart();
            var selectedItems = cart.Where(c => c.Selected).ToList();
            if (!selectedItems.Any()) return RedirectToAction("Index");

            using var transaction = _context.Database.BeginTransaction();

            var orderDetails = new List<OrderDetail>();
            decimal subtotal = 0;

            foreach (var item in selectedItems)
            {
                var product = _context.Products.Find(item.ProductId);
                if (product == null)
                {
                    transaction.Rollback();
                    TempData["ErrorMessage"] = $"Sản phẩm \"{item.Name}\" không còn tồn tại.";
                    return RedirectToAction("Index");
                }

                ProductVariant? variant = null;
                if (item.VariantId.HasValue)
                {
                    variant = _context.ProductVariants.FirstOrDefault(v => v.VariantId == item.VariantId.Value);
                    if (variant == null)
                    {
                        transaction.Rollback();
                        TempData["ErrorMessage"] = $"Phiên bản \"{item.Name}\" không còn tồn tại.";
                        return RedirectToAction("Index");
                    }
                }

                // Chốt giá từ DB ngay tại thời điểm đặt hàng.
                var unitPrice = variant?.Price ?? product.Price;
                var availableStock = variant?.Stock ?? product.Stock;

                if (item.Qty > availableStock)
                {
                    transaction.Rollback();
                    TempData["ErrorMessage"] = availableStock <= 0
                        ? $"\"{item.Name}\" đã hết hàng."
                        : $"\"{item.Name}\" chỉ còn {availableStock} sản phẩm, vui lòng giảm số lượng.";
                    return RedirectToAction("Index");
                }

                // Trừ kho
                if (variant != null)
                {
                    variant.Stock -= item.Qty;
                }
                product.Stock -= item.Qty;

                subtotal += unitPrice * item.Qty;
                orderDetails.Add(new OrderDetail
                {
                    ProductId = item.ProductId,
                    Quantity = item.Qty,
                    UnitPrice = unitPrice
                });
            }

            var discount = HttpContext.Session.GetObject<decimal>(SESSION_DISCOUNT);
            var total = Math.Max(subtotal + SHIPPING_FEE - discount, 0m);

            var order = new Order
            {
                UserId = userId.Value,
                OrderDate = DateTime.Now,
                TotalAmount = total,
                Status = "Pending",
                PaymentMethod = paymentMethod,
                ShippingAddress = shippingAddress,
                OrderDetails = orderDetails
            };

            _context.Orders.Add(order);
            _context.SaveChanges();
            transaction.Commit();

            return RedirectToAction("Payment", new { id = order.OrderId });
        }

        public IActionResult Payment(int id)
        {
            var order = GetOwnedOrder(id);
            if (order == null) return RedirectToAction("Index", "Home");

            if (order.PaymentMethod == "COD")
            {
                return RedirectToAction("Confirm", new { id = order.OrderId });
            }

            return View(order);
        }

        public IActionResult Confirm(int id)
        {
            var order = GetOwnedOrder(id);
            if (order == null) return RedirectToAction("Index", "Home");

            // Xóa các món đã đặt khỏi giỏ
            var cart = GetCart();
            if (cart.Any(c => c.Selected))
            {
                SaveCart(cart.Where(c => !c.Selected).ToList());
                HttpContext.Session.Remove(SESSION_DISCOUNT);
            }

            return View(order);
        }

        // ---------- Helpers ----------

        /// <summary>Chỉ trả về đơn hàng thuộc về người đang đăng nhập.</summary>
        private Order? GetOwnedOrder(int orderId)
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null) return null;

            return _context.Orders.FirstOrDefault(o => o.OrderId == orderId && o.UserId == userId.Value);
        }

        private List<CartItem> GetCart()
        {
            var cart = HttpContext.Session.GetObject<List<CartItem>>(SESSION_CART) ?? new List<CartItem>();

            // Bỏ các dòng lưu theo định dạng cũ (chưa có ProductId) còn sót trong session.
            return cart.Where(c => c.ProductId > 0).ToList();
        }

        private void SaveCart(List<CartItem> cart)
        {
            HttpContext.Session.SetObject(SESSION_CART, cart);
        }

        private int GetAvailableStock(CartItem item)
        {
            if (item.VariantId.HasValue)
            {
                return _context.ProductVariants
                    .Where(v => v.VariantId == item.VariantId.Value)
                    .Select(v => (int?)v.Stock)
                    .FirstOrDefault() ?? 0;
            }

            return _context.Products
                .Where(p => p.ProductId == item.ProductId)
                .Select(p => (int?)p.Stock)
                .FirstOrDefault() ?? 0;
        }

        /// <summary>Đồng bộ lại giá và tên từ DB cho mọi dòng trong giỏ.</summary>
        private void RefreshPrices(List<CartItem> cart)
        {
            foreach (var item in cart)
            {
                var product = _context.Products.Find(item.ProductId);
                if (product == null) continue;

                if (item.VariantId.HasValue)
                {
                    var variant = _context.ProductVariants.FirstOrDefault(v => v.VariantId == item.VariantId.Value);
                    if (variant == null) continue;

                    item.Price = variant.Price ?? product.Price;
                    item.Name = $"{product.Name} - {variant.Color} {variant.ROM}";
                }
                else
                {
                    item.Price = product.Price;
                    item.Name = product.Name;
                }

                item.Img = product.ImageUrl;
            }
        }

        private bool IsAjax()
        {
            return Request.Headers["X-Requested-With"] == "XMLHttpRequest";
        }

        private IActionResult FailAdd(string message)
        {
            if (IsAjax())
            {
                return Json(new { success = false, message });
            }

            TempData["ErrorMessage"] = message;
            return Redirect(Request.Headers["Referer"].ToString() ?? "/");
        }
    }
}
