namespace TechStoreWeb.Models
{
    public class Product
    {
        public int ProductId { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public decimal? OriginalPrice { get; set; }
        public string ImageUrl { get; set; }
        public int Stock { get; set; } = 100;
        public int CategoryId { get; set; }
        public Category Category { get; set; }
    }
}