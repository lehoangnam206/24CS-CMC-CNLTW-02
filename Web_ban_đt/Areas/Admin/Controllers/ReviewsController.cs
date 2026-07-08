using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TechStoreWeb.Data;
using Microsoft.AspNetCore.Http;

namespace TechStoreWeb.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class ReviewsController : Controller
    {
        private readonly AppDbContext _context;

        public ReviewsController(AppDbContext context)
        {
            _context = context;
        }

        private bool HasAccess()
        {
            var role = HttpContext.Session.GetString("Role");
            return role == "Admin" || role == "Employee";
        }

        public async Task<IActionResult> Index(int? productId, int? rating)
        {
            if (!HasAccess()) return RedirectToAction("Login", "Account", new { area = "" });

            var query = _context.Reviews
                .Include(r => r.User)
                .Include(r => r.Product)
                .AsQueryable();

            if (productId.HasValue)
            {
                query = query.Where(r => r.ProductId == productId.Value);
                ViewBag.FilterProduct = await _context.Products.FindAsync(productId.Value);
            }

            if (rating.HasValue)
            {
                query = query.Where(r => r.Rating == rating.Value);
                ViewBag.FilterRating = rating.Value;
            }

            var reviews = await query.OrderByDescending(r => r.CreatedAt).ToListAsync();

            // Stats
            var allReviews = await _context.Reviews.ToListAsync();
            ViewBag.TotalReviews = allReviews.Count;
            ViewBag.AvgRating = allReviews.Count > 0 ? allReviews.Average(r => r.Rating) : 0;
            ViewBag.Count5 = allReviews.Count(r => r.Rating == 5);
            ViewBag.Count4 = allReviews.Count(r => r.Rating == 4);
            ViewBag.Count3 = allReviews.Count(r => r.Rating == 3);
            ViewBag.Count2 = allReviews.Count(r => r.Rating == 2);
            ViewBag.Count1 = allReviews.Count(r => r.Rating == 1);

            return View(reviews);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            if (HttpContext.Session.GetString("Role") != "Admin")
                return RedirectToAction("Login", "Account", new { area = "" });

            var review = await _context.Reviews.FindAsync(id);
            if (review != null)
            {
                _context.Reviews.Remove(review);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Đã xóa đánh giá thành công!";
            }

            return RedirectToAction("Index");
        }
    }
}
