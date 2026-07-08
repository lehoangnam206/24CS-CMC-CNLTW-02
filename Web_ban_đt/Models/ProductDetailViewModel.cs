namespace TechStoreWeb.Models
{
    public class ProductDetailViewModel
    {
        public Product Product { get; set; }
        public ProductDetail Detail { get; set; }
        public List<ProductVariant> Variants { get; set; }
        public List<Review> Reviews { get; set; }
        public bool CanReview { get; set; }
    }
}
