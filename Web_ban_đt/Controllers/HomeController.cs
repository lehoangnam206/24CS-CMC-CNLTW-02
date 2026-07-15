using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TechStoreWeb.Data;
using TechStoreWeb.Models;

namespace TechStoreWeb.Controllers
{
    public class HomeController : Controller
    {
        private readonly AppDbContext _context;

        public HomeController(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(int? categoryId, string searchString)
        {
            // Lấy danh sách hãng điện thoại kèm sản phẩm để đưa ra Menu bên trái và menu bay
            ViewBag.Categories = await _context.Categories.Include(c => c.Products).ToListAsync();

            // Lấy danh sách sản phẩm
            var productsQuery = _context.Products.Include(p => p.Category).AsQueryable();

            // Nếu người dùng click vào 1 hãng, lọc sản phẩm theo hãng đó
            if (categoryId.HasValue)
            {
                productsQuery = productsQuery.Where(p => p.CategoryId == categoryId);
            }

            // Nếu người dùng tìm kiếm, lọc theo tên sản phẩm (case-insensitive)
            if (!string.IsNullOrWhiteSpace(searchString))
            {
                var s = searchString.Trim();
                productsQuery = productsQuery.Where(p => EF.Functions.Like(p.Name, "%" + s + "%"));
                ViewData["SearchString"] = s;
            }

            var products = await productsQuery.ToListAsync();
            return View(products);
        }

        // GET: /Home/Detail/5
        public async Task<IActionResult> Detail(int? id)
        {
            if (id == null) return NotFound();

            var product = await _context.Products.Include(p => p.Category)
                .FirstOrDefaultAsync(p => p.ProductId == id);

            if (product == null) return NotFound();

            // Tìm thông số kỹ thuật từ bảng ProductDetails theo tên sản phẩm
            var detail = await _context.ProductDetails
                .FirstOrDefaultAsync(d => d.Name == product.Name);

            // Lấy danh sách danh mục cho sidebar
            ViewBag.Categories = await _context.Categories.Include(c => c.Products).ToListAsync();

            // Fetch variants
            var variants = await _context.ProductVariants
                .Where(v => v.ProductId == product.ProductId)
                .ToListAsync();

            // Fetch reviews
            var reviews = await _context.Reviews
                .Include(r => r.User)
                .Where(r => r.ProductId == product.ProductId)
                .OrderByDescending(r => r.CreatedAt)
                .ToListAsync();

            bool canReview = false;
            var username = HttpContext.Session.GetString("Username");
            if (!string.IsNullOrEmpty(username))
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
                if (user != null)
                {
                    // Kiá»ƒm tra xem user Ä‘Ã£ tá»«ng mua sáº£n pháº©m nÃ y chÆ°a
                    canReview = await _context.Orders
                        .AnyAsync(o => o.UserId == user.UserId && o.OrderDetails.Any(od => od.ProductId == product.ProductId));
                }
            }

            var viewModel = new ProductDetailViewModel
            {
                Product = product,
                Detail = detail,
                Variants = variants,
                Reviews = reviews,
                CanReview = canReview
            };

            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddReview(int productId, int rating, string comment)
        {
            var username = HttpContext.Session.GetString("Username");
            if (string.IsNullOrEmpty(username)) return RedirectToAction("Login", "Account", new { returnUrl = $"/Home/Detail/{productId}" });

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            if (user == null) return RedirectToAction("Login", "Account", new { returnUrl = $"/Home/Detail/{productId}" });

            bool canReview = await _context.Orders
                .AnyAsync(o => o.UserId == user.UserId && o.OrderDetails.Any(od => od.ProductId == productId));

            if (canReview)
            {
                var review = new Review
                {
                    ProductId = productId,
                    UserId = user.UserId,
                    Rating = rating,
                    Comment = comment,
                    CreatedAt = System.DateTime.Now
                };
                _context.Reviews.Add(review);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Đánh giá của bạn đã được gửi thành công!";
            }
            
            return RedirectToAction("Detail", new { id = productId });
        }
    }
}