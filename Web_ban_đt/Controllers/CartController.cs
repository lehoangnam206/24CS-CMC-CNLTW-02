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

        public CartController(AppDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            var cart = HttpContext.Session.GetObject<List<CartItem>>(SESSION_CART) ?? new List<CartItem>();
            var disc = HttpContext.Session.GetObject<decimal>(SESSION_DISCOUNT);
            ViewBag.Discount = disc;
            return View(cart);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Add(string? id, string? name, decimal price, string? img, int qty = 1)
        {
            if (string.IsNullOrEmpty(id)) return RedirectToAction("Index", "Home");
            if (qty < 1) qty = 1;

            var cart = HttpContext.Session.GetObject<List<CartItem>>(SESSION_CART) ?? new List<CartItem>();
            var existing = cart.FirstOrDefault(c => c.Id == id);
            if (existing != null)
            {
                existing.Qty += qty;
            }
            else
            {
                cart.Add(new CartItem { Id = id, Name = name, Price = price, Img = img, Qty = qty, Selected = true });
            }

            HttpContext.Session.SetObject(SESSION_CART, cart);

            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            {
                return Json(new { success = true, message = "Đã thêm vào giỏ hàng" });
            }

            return Redirect(Request.Headers["Referer"].ToString() ?? "/");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult UpdateQty(string id, int qty)
        {
            var cart = HttpContext.Session.GetObject<List<CartItem>>(SESSION_CART) ?? new List<CartItem>();
            var item = cart.FirstOrDefault(c => c.Id == id);
            if (item != null)
            {
                item.Qty = Math.Max(1, qty);
                HttpContext.Session.SetObject(SESSION_CART, cart);
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Remove(string id)
        {
            var cart = HttpContext.Session.GetObject<List<CartItem>>(SESSION_CART) ?? new List<CartItem>();
            cart = cart.Where(c => c.Id != id).ToList();
            HttpContext.Session.SetObject(SESSION_CART, cart);
            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ToggleSelect(string id, bool selected)
        {
            var cart = HttpContext.Session.GetObject<List<CartItem>>(SESSION_CART) ?? new List<CartItem>();
            var item = cart.FirstOrDefault(c => c.Id == id);
            if (item != null)
            {
                item.Selected = selected;
                HttpContext.Session.SetObject(SESSION_CART, cart);
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
            if (userId == null) return RedirectToAction("Login", "Account");

            var cart = HttpContext.Session.GetObject<List<CartItem>>(SESSION_CART) ?? new List<CartItem>();
            var selectedItems = cart.Where(c => c.Selected).ToList();
            if (!selectedItems.Any()) return RedirectToAction("Index");

            var user = _context.Users.Find(userId);
            ViewBag.User = user;
            ViewBag.Discount = HttpContext.Session.GetObject<decimal>(SESSION_DISCOUNT);

            return View(selectedItems);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Checkout(string shippingAddress, string paymentMethod)
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null) return RedirectToAction("Login", "Account");

            var cart = HttpContext.Session.GetObject<List<CartItem>>(SESSION_CART) ?? new List<CartItem>();
            var selectedItems = cart.Where(c => c.Selected).ToList();
            if (!selectedItems.Any()) return RedirectToAction("Index");

            var discount = HttpContext.Session.GetObject<decimal>(SESSION_DISCOUNT);
            var subtotal = selectedItems.Sum(i => i.Price * i.Qty);
            var shipping = 20000m;
            var total = Math.Max(subtotal + shipping - discount, 0m);

            var order = new Order
            {
                UserId = userId.Value,
                OrderDate = DateTime.Now,
                TotalAmount = total,
                Status = "Pending",
                PaymentMethod = paymentMethod,
                ShippingAddress = shippingAddress,
                OrderDetails = selectedItems.Select(i => new OrderDetail
                {
                    ProductId = int.Parse(i.Id),
                    Quantity = i.Qty,
                    UnitPrice = i.Price
                }).ToList()
            };

            _context.Orders.Add(order);
            _context.SaveChanges();

            return RedirectToAction("Payment", new { id = order.OrderId });
        }

        public IActionResult Payment(int id)
        {
            var order = _context.Orders.Find(id);
            if (order == null) return RedirectToAction("Index", "Home");
            
            if (order.PaymentMethod == "COD")
            {
                return RedirectToAction("Confirm", new { id = order.OrderId });
            }
            
            return View(order);
        }

        public IActionResult Confirm(int id)
        {
            var order = _context.Orders.Find(id);
            if (order == null) return RedirectToAction("Index", "Home");

            // Clear selected items from cart after order is confirmed
            var cart = HttpContext.Session.GetObject<List<CartItem>>(SESSION_CART) ?? new List<CartItem>();
            if (cart.Any(c => c.Selected))
            {
                cart = cart.Where(c => !c.Selected).ToList();
                HttpContext.Session.SetObject(SESSION_CART, cart);
                HttpContext.Session.Remove(SESSION_DISCOUNT);
            }

            return View(order);
        }
    }
}
