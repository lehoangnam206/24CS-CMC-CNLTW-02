using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TechStoreWeb.Models
{
    [Table("ProductDetails")]
    public class ProductDetail
    {
        [Key]
        public int ProductId { get; set; }
        public string Name { get; set; }
        public int? CategoryId { get; set; }
        public string CPU { get; set; }
        public string RAM { get; set; }
        public string ROM { get; set; }
        public string Screen { get; set; }
        public string Battery { get; set; }
        public string Camera { get; set; }
    }
}
