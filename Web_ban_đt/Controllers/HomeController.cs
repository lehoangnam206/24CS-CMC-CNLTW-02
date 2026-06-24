using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TechStoreWeb.Data;

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
            // Lấy danh sách 8 hãng điện thoại để đưa ra Menu bên trái
            ViewBag.Categories = await _context.Categories.ToListAsync();

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
    }
}