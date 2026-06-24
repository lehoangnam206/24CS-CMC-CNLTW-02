using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using TechStoreWeb.Extensions;
using TechStoreWeb.Models;

namespace TechStoreWeb.Controllers
{
    public class CartController : Controller
    {
        private const string SESSION_CART = "Cart";
        private const string SESSION_DISCOUNT = "CartDiscount";

        public IActionResult Index()
        {
            var cart = HttpContext.Session.GetObject<List<CartItem>>(SESSION_CART) ?? new List<CartItem>();
            var disc = HttpContext.Session.GetObject<decimal>(SESSION_DISCOUNT);
            ViewBag.Discount = disc;
            return View(cart);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Add(string id, string name, decimal price, string img)
        {
            if (string.IsNullOrEmpty(id)) return RedirectToAction("Index", "Home");

            var cart = HttpContext.Session.GetObject<List<CartItem>>(SESSION_CART) ?? new List<CartItem>();
            var existing = cart.FirstOrDefault(c => c.Id == id);
            if (existing != null)
            {
                existing.Qty += 1;
            }
            else
            {
                cart.Add(new CartItem { Id = id, Name = name, Price = price, Img = img, Qty = 1, Selected = true });
            }

            HttpContext.Session.SetObject(SESSION_CART, cart);
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

        public IActionResult Checkout() => View();
        public IActionResult Confirm() => View();
    }
}
