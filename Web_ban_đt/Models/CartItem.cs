using System;

namespace TechStoreWeb.Models
{
    public class CartItem
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public string Img { get; set; }
        public int Qty { get; set; } = 1;
        public bool Selected { get; set; } = true;
    }
}
