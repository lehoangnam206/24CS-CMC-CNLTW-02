using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TechStoreWeb.Data;
using TechStoreWeb.Models;

namespace TechStoreWeb.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class PromotionsController : Controller
    {
        private readonly AppDbContext _context;

        public PromotionsController(AppDbContext context)
        {
            _context = context;
        }

        // GET: Admin/Promotions
        public async Task<IActionResult> Index()
        {
            return View(await _context.Promotions.ToListAsync());
        }

        // GET: Admin/Promotions/Create
        public async Task<IActionResult> Create()
        {
            ViewBag.Products = await _context.Products.ToListAsync();
            return View();
        }

        // POST: Admin/Promotions/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Name,DiscountPercentage,StartDate,EndDate,IsActive")] Promotion promotion, int[] productIds)
        {
            if (ModelState.IsValid)
            {
                if (productIds == null || productIds.Length == 0)
                {
                    ModelState.AddModelError("", "Vui lòng chọn ít nhất một sản phẩm.");
                    ViewBag.Products = await _context.Products.ToListAsync();
                    return View(promotion);
                }

                _context.Add(promotion);
                
                // Lấy các sản phẩm được chọn
                var products = await _context.Products.Where(p => productIds.Contains(p.ProductId)).ToListAsync();
                
                foreach (var product in products)
                {
                    // Lưu giá gốc nếu chưa có
                    if (product.OriginalPrice == null)
                    {
                        product.OriginalPrice = product.Price;
                    }
                    
                    // Tính giá mới
                    product.Price = product.OriginalPrice.Value - (product.OriginalPrice.Value * promotion.DiscountPercentage / 100);
                    _context.Update(product);
                }

                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Đã lưu chương trình khuyến mại và cập nhật giá sản phẩm!";
                return RedirectToAction(nameof(Index));
            }
            ViewBag.Products = await _context.Products.ToListAsync();
            return View(promotion);
        }
        // GET: Admin/Promotions/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null) return NotFound();

            var promotion = await _context.Promotions.FindAsync(id);
            if (promotion == null) return NotFound();

            return View(promotion);
        }

        // POST: Admin/Promotions/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,Name,DiscountPercentage,StartDate,EndDate,IsActive")] Promotion promotion)
        {
            if (id != promotion.Id) return NotFound();

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(promotion);
                    await _context.SaveChangesAsync();
                    TempData["SuccessMessage"] = "Đã cập nhật chương trình khuyến mại!";
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!PromotionExists(promotion.Id)) return NotFound();
                    else throw;
                }
                return RedirectToAction(nameof(Index));
            }
            return View(promotion);
        }

        // POST: Admin/Promotions/EndPromotion/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EndPromotion(int id)
        {
            var promotion = await _context.Promotions.FindAsync(id);
            if (promotion != null)
            {
                promotion.IsActive = false;
                _context.Update(promotion);

                // Revert prices for all products
                var products = await _context.Products.Where(p => p.OriginalPrice != null).ToListAsync();
                foreach (var p in products)
                {
                    p.Price = p.OriginalPrice.Value;
                    p.OriginalPrice = null;
                    _context.Update(p);
                }

                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = "Đã kết thúc chương trình khuyến mại và khôi phục giá gốc cho các sản phẩm!";
            }
            return RedirectToAction(nameof(Index));
        }

        private bool PromotionExists(int id)
        {
            return _context.Promotions.Any(e => e.Id == id);
        }
    }
}
