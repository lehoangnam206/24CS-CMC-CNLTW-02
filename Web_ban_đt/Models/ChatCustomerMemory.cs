using System.ComponentModel.DataAnnotations;

namespace TechStoreWeb.Models
{
    public class ChatCustomerMemory
    {
        public int ChatCustomerMemoryId { get; set; }

        [MaxLength(120)]
        public string CustomerKey { get; set; } = string.Empty;

        public int? UserId { get; set; }
        public User? User { get; set; }

        [MaxLength(160)]
        public string? CustomerName { get; set; }

        public string PreferredBrands { get; set; } = string.Empty;
        public decimal? BudgetMin { get; set; }
        public decimal? BudgetMax { get; set; }
        public string UseCases { get; set; } = string.Empty;
        public string InterestedProducts { get; set; } = string.Empty;
        public string Notes { get; set; } = string.Empty;
        public DateTime UpdatedAt { get; set; } = DateTime.Now;
    }
}
