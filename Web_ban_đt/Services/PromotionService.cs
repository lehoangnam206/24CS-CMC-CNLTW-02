using Microsoft.EntityFrameworkCore;
using TechStoreWeb.Data;
using TechStoreWeb.Models;

namespace TechStoreWeb.Services
{
    public interface IPromotionService
    {
        /// <summary>Tính lại giá bán của mọi sản phẩm nằm trong chương trình khuyến mại.</summary>
        Task<int> SyncAsync(CancellationToken cancellationToken = default);

        /// <summary>Giá niêm yết gốc của sản phẩm, bỏ qua mọi khuyến mại đang áp.</summary>
        Task<decimal> GetBaselinePriceAsync(int productId, CancellationToken cancellationToken = default);

        bool IsRunningNow(Promotion promotion, DateTime now);
    }

    public class PromotionService : IPromotionService
    {
        private readonly AppDbContext _context;
        private readonly ILogger<PromotionService> _logger;

        public PromotionService(AppDbContext context, ILogger<PromotionService> logger)
        {
            _context = context;
            _logger = logger;
        }

        public bool IsRunningNow(Promotion promotion, DateTime now)
        {
            // EndDate được coi là hết ngày (inclusive).
            return promotion.IsActive
                && promotion.StartDate.Date <= now.Date
                && now.Date <= promotion.EndDate.Date;
        }

        public async Task<decimal> GetBaselinePriceAsync(int productId, CancellationToken cancellationToken = default)
        {
            // Nếu sản phẩm đã nằm trong một CTKM nào đó, giá gốc đã được ghi lại ở dòng liên kết.
            var recorded = await _context.PromotionProducts
                .Where(pp => pp.ProductId == productId)
                .Select(pp => (decimal?)pp.OriginalPrice)
                .FirstOrDefaultAsync(cancellationToken);

            if (recorded.HasValue)
            {
                return recorded.Value;
            }

            var product = await _context.Products.FindAsync(new object[] { productId }, cancellationToken);
            return product?.Price ?? 0m;
        }

        public async Task<int> SyncAsync(CancellationToken cancellationToken = default)
        {
            var now = DateTime.Now;

            var links = await _context.PromotionProducts
                .Include(pp => pp.Promotion)
                .ToListAsync(cancellationToken);

            if (links.Count == 0)
            {
                return 0;
            }

            var productIds = links.Select(l => l.ProductId).Distinct().ToList();
            var products = await _context.Products
                .Where(p => productIds.Contains(p.ProductId))
                .ToListAsync(cancellationToken);

            var changed = 0;

            foreach (var product in products)
            {
                var productLinks = links.Where(l => l.ProductId == product.ProductId).ToList();
                if (productLinks.Count == 0) continue;

                var baseline = productLinks[0].OriginalPrice;

                // Nhiều CTKM cùng phủ một sản phẩm: lấy mức giảm cao nhất trong số đang chạy.
                var bestDiscount = productLinks
                    .Where(l => l.Promotion != null && IsRunningNow(l.Promotion, now))
                    .Select(l => l.Promotion.DiscountPercentage)
                    .DefaultIfEmpty(0)
                    .Max();

                decimal newPrice;
                decimal? newOriginal;

                if (bestDiscount > 0)
                {
                    newPrice = Math.Round(baseline * (100 - bestDiscount) / 100m, 0);
                    newOriginal = baseline;
                }
                else
                {
                    newPrice = baseline;
                    newOriginal = null;
                }

                if (product.Price != newPrice || product.OriginalPrice != newOriginal)
                {
                    product.Price = newPrice;
                    product.OriginalPrice = newOriginal;
                    changed++;
                }
            }

            if (changed > 0)
            {
                await _context.SaveChangesAsync(cancellationToken);
                _logger.LogInformation("Đồng bộ khuyến mại: cập nhật giá {Count} sản phẩm.", changed);
            }

            return changed;
        }
    }
}
