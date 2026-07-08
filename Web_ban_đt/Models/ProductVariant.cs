using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TechStoreWeb.Models
{
    [Table("ProductVariants")]
    public class ProductVariant
    {
        [Key]
        public int VariantId { get; set; }

        public int ProductId { get; set; }

        public string Color { get; set; }

        public string ROM { get; set; }

        public int Stock { get; set; }

        public decimal? Price { get; set; }

        [ForeignKey("ProductId")]
        public ProductDetail ProductDetail { get; set; }
    }
}
