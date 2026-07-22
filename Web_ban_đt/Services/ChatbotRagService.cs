using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;
using TechStoreWeb.Data;

namespace TechStoreWeb.Services
{
    public interface IChatbotRagService
    {
        Task<IReadOnlyList<RetrievedChatChunk>> RetrieveAsync(
            string query,
            int limit,
            decimal? budgetMin,
            decimal? budgetMax,
            CancellationToken cancellationToken);
    }

    public class ChatbotRagService : IChatbotRagService
    {
        private readonly AppDbContext _context;
        private readonly ILogger<ChatbotRagService> _logger;

        private IReadOnlyList<ChatDocumentChunk>? _cachedChunks;
        private DateTime _cacheExpiresAt = DateTime.MinValue;

        public ChatbotRagService(AppDbContext context, ILogger<ChatbotRagService> logger)
        {
            _context = context;
            _logger = logger;
        }

        public async Task<IReadOnlyList<RetrievedChatChunk>> RetrieveAsync(
            string query,
            int limit,
            decimal? budgetMin,
            decimal? budgetMax,
            CancellationToken cancellationToken)
        {
            var chunks = await GetChunksAsync(cancellationToken);
            var queryTerms = Tokenize(query).ToList();
            var queryNorm = Normalize(query);

            var results = chunks
                .Select(chunk => new RetrievedChatChunk
                {
                    Chunk = chunk,
                    Score = Score(chunk, queryTerms, queryNorm) + BudgetScore(chunk, budgetMin, budgetMax)
                })
                .Where(result => result.Score > 0)
                .OrderByDescending(result => result.Score)
                .ThenBy(result => result.Chunk.Kind)
                .Take(Math.Max(1, limit))
                .ToList();

            // Khách nêu ngân sách nhưng câu hỏi quá chung chung nên không khớp từ khoá nào:
            // vẫn gợi ý được máy trong tầm giá thay vì trả về rỗng.
            if (results.Count == 0 && (budgetMin.HasValue || budgetMax.HasValue))
            {
                results = chunks
                    .Where(chunk => chunk.Kind == ChatChunkKind.ProductSpecs && IsWithinBudget(chunk.Price, budgetMin, budgetMax))
                    .OrderByDescending(chunk => chunk.Price)
                    .Take(Math.Max(1, limit))
                    .Select(chunk => new RetrievedChatChunk { Chunk = chunk, Score = 1 })
                    .ToList();
            }

            return results;
        }

        private static bool IsWithinBudget(decimal? price, decimal? budgetMin, decimal? budgetMax)
        {
            if (!price.HasValue) return false;
            if (budgetMin.HasValue && price.Value < budgetMin.Value) return false;
            if (budgetMax.HasValue && price.Value > budgetMax.Value) return false;
            return true;
        }

        /// <summary>
        /// Ưu tiên máy nằm trong tầm giá khách nêu, hạ điểm máy vượt ngân sách quá xa.
        /// </summary>
        private static double BudgetScore(ChatDocumentChunk chunk, decimal? budgetMin, decimal? budgetMax)
        {
            if (!chunk.Price.HasValue || (!budgetMin.HasValue && !budgetMax.HasValue))
            {
                return 0;
            }

            if (IsWithinBudget(chunk.Price, budgetMin, budgetMax))
            {
                return 6;
            }

            if (budgetMax.HasValue && chunk.Price.Value > budgetMax.Value)
            {
                var overshoot = (double)((chunk.Price.Value - budgetMax.Value) / budgetMax.Value);
                return overshoot > 0.5 ? -6 : -2;
            }

            return -1;
        }

        private async Task<IReadOnlyList<ChatDocumentChunk>> GetChunksAsync(CancellationToken cancellationToken)
        {
            if (_cachedChunks != null && DateTime.Now < _cacheExpiresAt)
            {
                return _cachedChunks;
            }

            try
            {
                var chunks = new List<ChatDocumentChunk>();
                var products = await _context.Products
                    .Include(p => p.Category)
                    .OrderBy(p => p.ProductId)
                    .ToListAsync(cancellationToken);

                var details = await _context.ProductDetails
                    .ToListAsync(cancellationToken);

                var variants = await _context.ProductVariants
                    .ToListAsync(cancellationToken);

                foreach (var product in products)
                {
                    var detail = details.FirstOrDefault(d => SameName(d.Name, product.Name) || d.ProductId == product.ProductId);
                    var productVariants = variants.Where(v => v.ProductId == product.ProductId).ToList();
                    chunks.Add(CreateProductSpecChunk(product, detail, productVariants));
                }

                chunks.AddRange(CreateSemanticComparisonChunks(products, details));
                chunks.AddRange(CreatePolicyChunks());

                _cachedChunks = chunks;
                _cacheExpiresAt = DateTime.Now.AddMinutes(10);

                return _cachedChunks;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Cannot build chatbot RAG chunks.");
                return Array.Empty<ChatDocumentChunk>();
            }
        }

        private static ChatDocumentChunk CreateProductSpecChunk(Models.Product product, Models.ProductDetail? detail, IReadOnlyList<Models.ProductVariant> variants)
        {
            var brand = product.Category?.CategoryName ?? DetectBrand(product.Name);
            var table = new StringBuilder();
            table.AppendLine($"## Toan bo thong so {product.Name}");
            table.AppendLine("| Tinh nang | Thong so |");
            table.AppendLine("| --- | --- |");
            table.AppendLine($"| Model | {product.Name} |");
            table.AppendLine($"| Thuong hieu | {brand} |");
            table.AppendLine($"| Gia niem yet | {FormatVnd(product.Price)} |");
            if (product.OriginalPrice.HasValue) table.AppendLine($"| Gia goc | {FormatVnd(product.OriginalPrice.Value)} |");
            table.AppendLine($"| Ton kho | {product.Stock} |");
            table.AppendLine($"| Man hinh | {ValueOrUpdating(detail?.Screen)} |");
            table.AppendLine($"| CPU / chip | {ValueOrUpdating(detail?.CPU)} |");
            table.AppendLine($"| RAM | {ValueOrUpdating(detail?.RAM)} |");
            table.AppendLine($"| Bo nho | {ValueOrUpdating(detail?.ROM)} |");
            table.AppendLine($"| Camera | {ValueOrUpdating(detail?.Camera)} |");
            table.AppendLine($"| Pin | {ValueOrUpdating(detail?.Battery)} |");
            if (variants.Count > 0)
            {
                table.AppendLine($"| Phien ban mau/bo nho | {string.Join("; ", variants.Select(v => $"{v.Color} {v.ROM} - {FormatVnd(v.Price ?? product.Price)} - ton {v.Stock}"))} |");
            }

            return new ChatDocumentChunk
            {
                Id = $"product-spec-{product.ProductId}",
                ParentId = $"product-{product.ProductId}",
                Kind = ChatChunkKind.ProductSpecs,
                ProductId = product.ProductId,
                ProductName = product.Name,
                Brand = brand,
                Topic = "specs",
                Price = product.Price,
                Title = $"Thong so {product.Name}",
                Content = table.ToString(),
                ParentContent = table.ToString()
            };
        }

        private static IEnumerable<ChatDocumentChunk> CreateSemanticComparisonChunks(IReadOnlyList<Models.Product> products, IReadOnlyList<Models.ProductDetail> details)
        {
            var detailByProduct = products
                .Select(product => new
                {
                    Product = product,
                    Detail = details.FirstOrDefault(d => SameName(d.Name, product.Name) || d.ProductId == product.ProductId)
                })
                .Where(x => x.Detail != null)
                .ToList();

            var topics = new[]
            {
                new { Key = "camera", Name = "camera va chup anh", Selector = new Func<Models.ProductDetail, string?>(d => d.Camera) },
                new { Key = "battery", Name = "pin va thoi luong su dung", Selector = new Func<Models.ProductDetail, string?>(d => d.Battery) },
                new { Key = "performance", Name = "hieu nang, chip va RAM", Selector = new Func<Models.ProductDetail, string?>(d => $"{d.CPU}, RAM {d.RAM}") },
                new { Key = "display", Name = "man hinh", Selector = new Func<Models.ProductDetail, string?>(d => d.Screen) }
            };

            foreach (var brandGroup in detailByProduct.GroupBy(x => x.Product.Category?.CategoryName ?? DetectBrand(x.Product.Name)))
            {
                var representatives = brandGroup
                    .OrderByDescending(x => x.Product.Price)
                    .Take(5)
                    .ToList();

                if (representatives.Count < 2)
                {
                    continue;
                }

                foreach (var topic in topics)
                {
                    var content = new StringBuilder();
                    content.AppendLine($"## So sanh {topic.Name} nhom {brandGroup.Key}");
                    foreach (var item in representatives)
                    {
                        content.AppendLine($"- {item.Product.Name}: {topic.Selector(item.Detail!)}. Gia {FormatVnd(item.Product.Price)}.");
                    }
                    content.AppendLine("Goi y tu van: uu tien may co thong so noi bat trong dung nhu cau, sau do doi chieu ngan sach va ton kho.");

                    yield return new ChatDocumentChunk
                    {
                        Id = $"semantic-{Normalize(brandGroup.Key)}-{topic.Key}",
                        ParentId = $"semantic-{Normalize(brandGroup.Key)}",
                        Kind = ChatChunkKind.SemanticComparison,
                        Brand = brandGroup.Key,
                        Topic = topic.Key,
                        Title = $"So sanh {topic.Name} {brandGroup.Key}",
                        Content = content.ToString(),
                        ParentContent = content.ToString()
                    };
                }
            }

            var flagshipCamera = detailByProduct
                .Where(x => !string.IsNullOrWhiteSpace(x.Detail?.Camera))
                .OrderByDescending(x => CameraScore(x.Detail!.Camera))
                .ThenByDescending(x => x.Product.Price)
                .Take(8)
                .ToList();

            if (flagshipCamera.Count > 1)
            {
                var content = new StringBuilder();
                content.AppendLine("## So sanh camera lien thuong hieu");
                foreach (var item in flagshipCamera)
                {
                    content.AppendLine($"- {item.Product.Name} ({item.Product.Category?.CategoryName}): camera {item.Detail!.Camera}, chip {item.Detail.CPU}, gia {FormatVnd(item.Product.Price)}.");
                }

                yield return new ChatDocumentChunk
                {
                    Id = "semantic-cross-brand-camera",
                    ParentId = "semantic-cross-brand",
                    Kind = ChatChunkKind.SemanticComparison,
                    Topic = "camera",
                    Title = "So sanh camera giua cac hang",
                    Content = content.ToString(),
                    ParentContent = content.ToString()
                };
            }
        }

        private static IEnumerable<ChatDocumentChunk> CreatePolicyChunks()
        {
            var parents = new Dictionary<string, string>
            {
                ["warranty"] = "Chinh sach bao hanh: san pham dien thoai duoc tu van theo mac dinh bao hanh chinh hang 12 thang neu trang san pham khong ghi khac. Khach nen giu hoa don, phieu bao hanh va hop may. Cac truong hop roi vo, vao nuoc, tu y sua chua hoac mat tem co the khong duoc bao hanh mien phi. Nhan vien can huong dan khach kiem tra IMEI, tinh trang may va phu kien khi nhan hang.",
                ["return"] = "Chinh sach doi tra: voi loi phat sinh som, khach can cung cap thong tin don hang, tinh trang may, hinh anh/video loi va phu kien kem theo. Dieu kien doi tra phu thuoc tinh trang san pham, thoi gian mua va ket qua kiem tra ky thuat. Tu van vien khong hua chac doi tra khi chua co ket qua kiem tra.",
                ["shipping"] = "Chinh sach giao hang va thanh toan: khach co the dat hang tren website, kiem tra gio hang va thanh toan theo cac phuong thuc hien co trong trang thanh toan. Khi tu van, can xac nhan dia chi giao, so dien thoai, mau/bo nho san pham va tong tien truoc khi khach chot don."
            };

            foreach (var parent in parents)
            {
                foreach (var child in FixedLengthChildren(parent.Key, parent.Value, 70, 14))
                {
                    yield return child;
                }
            }
        }

        private static IEnumerable<ChatDocumentChunk> FixedLengthChildren(string parentId, string parentContent, int maxWords, int overlapWords)
        {
            var words = parentContent.Split(' ', StringSplitOptions.RemoveEmptyEntries);
            var index = 0;
            var childIndex = 1;
            while (index < words.Length)
            {
                var childWords = words.Skip(index).Take(maxWords).ToArray();
                yield return new ChatDocumentChunk
                {
                    Id = $"policy-{parentId}-{childIndex}",
                    ParentId = $"policy-{parentId}",
                    Kind = ChatChunkKind.PolicyChild,
                    Topic = parentId,
                    Title = $"Chinh sach {parentId}",
                    Content = string.Join(' ', childWords),
                    ParentContent = parentContent
                };

                if (index + maxWords >= words.Length)
                {
                    break;
                }

                index += Math.Max(1, maxWords - overlapWords);
                childIndex++;
            }
        }

        private static double Score(ChatDocumentChunk chunk, IReadOnlyList<string> queryTerms, string queryNorm)
        {
            var text = Normalize($"{chunk.Title} {chunk.Content} {chunk.Brand} {chunk.ProductName} {chunk.Topic}");
            var terms = Tokenize(text).ToHashSet();
            var score = queryTerms.Sum(term => terms.Contains(term) ? 1.0 : 0.0);

            if (!string.IsNullOrWhiteSpace(chunk.ProductName) && queryNorm.Contains(Normalize(chunk.ProductName))) score += 8;
            if (!string.IsNullOrWhiteSpace(chunk.Brand) && queryNorm.Contains(Normalize(chunk.Brand))) score += 4;
            if (queryNorm.Contains("camera") || queryNorm.Contains("chup anh")) score += chunk.Topic == "camera" || text.Contains("camera") ? 2.5 : 0;
            if (queryNorm.Contains("pin") || queryNorm.Contains("trâu pin") || queryNorm.Contains("trau pin")) score += chunk.Topic == "battery" || text.Contains("mah") ? 2.5 : 0;
            if (queryNorm.Contains("game") || queryNorm.Contains("choi game") || queryNorm.Contains("chip")) score += chunk.Topic == "performance" || text.Contains("snapdragon") || text.Contains("dimensity") || text.Contains("apple") ? 2 : 0;
            if (queryNorm.Contains("bao hanh") || queryNorm.Contains("doi tra") || queryNorm.Contains("giao hang")) score += chunk.Kind == ChatChunkKind.PolicyChild ? 3 : 0;

            return score;
        }

        private static IEnumerable<string> Tokenize(string text)
        {
            return Regex.Split(Normalize(text), @"[^a-z0-9]+")
                .Where(token => token.Length >= 2 && !StopWords.Contains(token));
        }

        private static string Normalize(string text)
        {
            if (string.IsNullOrWhiteSpace(text)) return string.Empty;
            var normalized = text.ToLowerInvariant().Normalize(NormalizationForm.FormD);
            var builder = new StringBuilder(normalized.Length);

            foreach (var c in normalized)
            {
                if (CharUnicodeInfo.GetUnicodeCategory(c) != UnicodeCategory.NonSpacingMark)
                {
                    builder.Append(c);
                }
            }

            return builder.ToString().Normalize(NormalizationForm.FormC).Replace('đ', 'd');
        }

        private static bool SameName(string? left, string? right)
        {
            return Normalize(left ?? string.Empty) == Normalize(right ?? string.Empty);
        }

        private static string DetectBrand(string name)
        {
            var brands = new[] { "iPhone", "Samsung", "Xiaomi", "Oppo", "Honor", "Huawei", "Nokia", "Tecno" };
            return brands.FirstOrDefault(brand => Normalize(name).Contains(Normalize(brand))) ?? "Khac";
        }

        private static string ValueOrUpdating(string? value)
        {
            return string.IsNullOrWhiteSpace(value) ? "Dang cap nhat" : value;
        }

        private static string FormatVnd(decimal value)
        {
            return value.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + " VND";
        }

        private static int CameraScore(string camera)
        {
            var matches = Regex.Matches(camera, @"\d+");
            return matches.Select(match => int.TryParse(match.Value, out var value) ? value : 0).DefaultIfEmpty(0).Sum();
        }

        /// <summary>
        /// Chỉ loại các hư từ thật sự vô nghĩa. Trước đây danh sách này chứa "gia", "man", "pin"-liên quan
        /// và "tam" nên câu hỏi về giá bị mất luôn từ khoá quan trọng nhất.
        /// </summary>
        private static readonly HashSet<string> StopWords = new()
        {
            "toi", "minh", "ban", "cho", "can", "nen", "mua", "la", "va", "co", "khong",
            "voi", "de", "tu", "giup", "the", "nao", "gi", "duoc", "roi", "nhe", "nha", "vay"
        };
    }
}
