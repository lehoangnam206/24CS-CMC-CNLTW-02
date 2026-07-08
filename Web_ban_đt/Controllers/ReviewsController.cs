using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using TechStoreWeb.Data;
using TechStoreWeb.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;

namespace TechStoreWeb.Controllers
{
    public class ReviewsController : Controller
    {
        private readonly AppDbContext _context;

        public ReviewsController(AppDbContext context)
        {
            _context = context;
        }

        public IActionResult Create(int productId)
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null) return RedirectToAction("Login", "Account");

            // Kiểm tra xem user có mua sản phẩm này và đã nhận hàng chưa
            var hasPurchased = _context.Orders
                .Include(o => o.OrderDetails)
                .Any(o => o.UserId == userId && o.Status == "Delivered" && o.OrderDetails.Any(od => od.ProductId == productId));

            if (!hasPurchased)
            {
                TempData["ErrorMessage"] = "Bạn chưa thể đánh giá sản phẩm này vì chưa hoàn thành đơn hàng.";
                return RedirectToAction("Orders", "Account");
            }

            var product = _context.Products.Find(productId);
            ViewBag.Product = product;

            return View(new Review { ProductId = productId });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(Review review)
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null) return RedirectToAction("Login", "Account");

            var hasPurchased = _context.Orders
                .Include(o => o.OrderDetails)
                .Any(o => o.UserId == userId && o.Status == "Delivered" && o.OrderDetails.Any(od => od.ProductId == review.ProductId));

            if (!hasPurchased)
            {
                TempData["ErrorMessage"] = "Bạn chưa thể đánh giá sản phẩm này vì chưa hoàn thành đơn hàng.";
                return RedirectToAction("Orders", "Account");
            }

            review.UserId = userId.Value;
            review.CreatedAt = DateTime.Now;

            _context.Reviews.Add(review);
            _context.SaveChanges();

            TempData["SuccessMessage"] = "Cảm ơn bạn đã đánh giá sản phẩm!";
            return RedirectToAction("Orders", "Account");
        }
    }
}
