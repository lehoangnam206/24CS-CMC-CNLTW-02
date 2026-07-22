using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TechStoreWeb.Models
{
    /// <summary>
    /// Liên kết chương trình khuyến mại với sản phẩm được áp dụng.
    /// Giữ luôn giá gốc trước khi khuyến mại để khôi phục chính xác khi kết thúc.
    /// </summary>
    [Table("PromotionProducts")]
    public class PromotionProduct
    {
        [Key]
        public int Id { get; set; }

        public int PromotionId { get; set; }

        public int ProductId { get; set; }

        /// <summary>Giá niêm yết trước khi chương trình này áp dụng.</summary>
        [Column(TypeName = "decimal(18,2)")]
        public decimal OriginalPrice { get; set; }

        [ForeignKey(nameof(PromotionId))]
        public Promotion Promotion { get; set; }

        [ForeignKey(nameof(ProductId))]
        public Product Product { get; set; }
    }
}
