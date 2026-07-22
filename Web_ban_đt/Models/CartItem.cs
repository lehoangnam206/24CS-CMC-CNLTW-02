using System;

namespace TechStoreWeb.Models
{
    public class CartItem
    {
        /// <summary>Khóa dòng giỏ hàng: "{ProductId}" hoặc "{ProductId}-v{VariantId}".</summary>
        public string Id { get; set; }

        public int ProductId { get; set; }

        /// <summary>Biến thể màu/dung lượng khách chọn, null nếu sản phẩm không có biến thể.</summary>
        public int? VariantId { get; set; }

        /// <summary>Tên hiển thị, luôn do server dựng lại từ DB.</summary>
        public string Name { get; set; }

        /// <summary>Giá tại thời điểm thêm vào giỏ, luôn do server tra từ DB.</summary>
        public decimal Price { get; set; }

        public string Img { get; set; }
        public int Qty { get; set; } = 1;
        public bool Selected { get; set; } = true;

        public static string BuildId(int productId, int? variantId)
        {
            return variantId.HasValue ? $"{productId}-v{variantId.Value}" : productId.ToString();
        }
    }
}
