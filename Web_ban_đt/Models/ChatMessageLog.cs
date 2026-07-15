using System.ComponentModel.DataAnnotations;

namespace TechStoreWeb.Models
{
    public class ChatMessageLog
    {
        public int ChatMessageLogId { get; set; }

        [MaxLength(120)]
        public string CustomerKey { get; set; } = string.Empty;

        public int? UserId { get; set; }
        public User? User { get; set; }

        [MaxLength(20)]
        public string Role { get; set; } = "user";

        public string Content { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}
