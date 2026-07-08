using System;
using System.Collections.Generic;

namespace TechStoreWeb.Models
{
    public class Order
    {
        public int OrderId { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }

        public DateTime OrderDate { get; set; } = DateTime.Now;
        public decimal TotalAmount { get; set; }

        public string Status { get; set; } = "Pending"; // Pending, Shipping, Delivered, Cancelled
        public string PaymentMethod { get; set; }

        public string ShippingAddress { get; set; }

        public List<OrderDetail> OrderDetails { get; set; }
    }
}
