using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TechStoreWeb.Data;
using TechStoreWeb.Models;
using TechStoreWeb.Services;

namespace TechStoreWeb.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class PromotionsController : Controller
    {
        private readonly AppDbContext _context;
        private readonly IPromotionService _promotionService;

        public PromotionsController(AppDbContext context, IPromotionService promotionService)
        {
            _context = context;
            _promotionService = promotionService;
        }

        private bool IsAdmin()
        {
            return HttpContext.Session.GetString("Role") == "Admin";
        }

        // GET: Admin/Promotions
        public async Task<IActionResult> Index()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });

            await _promotionService.SyncAsync();

            var promotions = await _context.Promotions.ToListAsync();

            // Số sản phẩm và trạng thái thực tế của từng chương trình.
            var counts = await _context.PromotionProducts
                .GroupBy(pp => pp.PromotionId)
                .Select(g => new { PromotionId = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.PromotionId, x => x.Count);

            var now = DateTime.Now;
            ViewBag.ProductCounts = counts;
            ViewBag.RunningStates = promotions.ToDictionary(p => p.Id, p => _promotionService.IsRunningNow(p, now));

            return View(promotions);
        }

        // GET: Admin/Promotions/Create
        public async Task<IActionResult> Create()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });

            ViewBag.Products = await _context.Products.ToListAsync();
            return View();
        }

        // POST: Admin/Promotions/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Name,DiscountPercentage,StartDate,EndDate,IsActive")] Promotion promotion, int[] productIds)
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });

            if (promotion.EndDate.Date < promotion.StartDate.Date)
            {
                ModelState.AddModelError("", "Ngày kết thúc phải sau ngày bắt đầu.");
            }

            if (productIds == null || productIds.Length == 0)
            {
                ModelState.AddModelError("", "Vui lòng chọn ít nhất một sản phẩm.");
            }

            if (!ModelState.IsValid)
            {
                ViewBag.Products = await _context.Products.ToListAsync();
                return View(promotion);
            }

            _context.Promotions.Add(promotion);
            await _context.SaveChangesAsync();

            // Ghi lại liên kết kèm giá gốc để sau này khôi phục đúng sản phẩm của đúng chương trình.
            foreach (var productId in productIds!.Distinct())
            {
                var baseline = await _promotionService.GetBaselinePriceAsync(productId);
                if (baseline <= 0) continue;

                _context.PromotionProducts.Add(new PromotionProduct
                {
                    PromotionId = promotion.Id,
                    ProductId = productId,
                    OriginalPrice = baseline
                });
            }

            await _context.SaveChangesAsync();
            await _promotionService.SyncAsync();

            TempData["SuccessMessage"] = _promotionService.IsRunningNow(promotion, DateTime.Now)
                ? "Đã tạo chương trình khuyến mại và áp dụng giá mới!"
                : "Đã tạo chương trình khuyến mại. Giá sẽ tự áp dụng khi tới ngày bắt đầu.";

            return RedirectToAction(nameof(Index));
        }

        // GET: Admin/Promotions/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });
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
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });
            if (id != promotion.Id) return NotFound();

            if (promotion.EndDate.Date < promotion.StartDate.Date)
            {
                ModelState.AddModelError("", "Ngày kết thúc phải sau ngày bắt đầu.");
            }

            if (!ModelState.IsValid)
            {
                return View(promotion);
            }

            try
            {
                _context.Update(promotion);
                await _context.SaveChangesAsync();
                await _promotionService.SyncAsync();
                TempData["SuccessMessage"] = "Đã cập nhật chương trình khuyến mại và tính lại giá!";
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PromotionExists(promotion.Id)) return NotFound();
                else throw;
            }

            return RedirectToAction(nameof(Index));
        }

        // POST: Admin/Promotions/EndPromotion/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EndPromotion(int id)
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });

            var promotion = await _context.Promotions.FindAsync(id);
            if (promotion == null)
            {
                TempData["ErrorMessage"] = "Không tìm thấy chương trình khuyến mại.";
                return RedirectToAction(nameof(Index));
            }

            promotion.IsActive = false;
            await _context.SaveChangesAsync();

            // Chỉ sản phẩm của chương trình này bị ảnh hưởng; các CTKM khác giữ nguyên.
            await _promotionService.SyncAsync();

            TempData["SuccessMessage"] = "Đã kết thúc chương trình và khôi phục giá gốc cho các sản phẩm của chương trình này!";
            return RedirectToAction(nameof(Index));
        }

        private bool PromotionExists(int id)
        {
            return _context.Promotions.Any(e => e.Id == id);
        }
    }
}
