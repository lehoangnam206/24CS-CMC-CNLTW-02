using System.ComponentModel.DataAnnotations;

namespace TechStoreWeb.Models
{
    public class User
    {
        public int UserId { get; set; }

        [StringLength(50)]
        [RegularExpression(@"^[a-zA-Z0-9_]*$", ErrorMessage = "Tên đăng nhập không được chứa khoảng trắng hoặc ký tự có dấu")]
        public string? Username { get; set; }

        public string? Password { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập họ tên")]
        public string FullName { get; set; }

        [EmailAddress(ErrorMessage = "Email không đúng định dạng")]
        public string Email { get; set; }

        [Phone(ErrorMessage = "Số điện thoại không đúng định dạng")]
        public string? PhoneNumber { get; set; }

        public string Role { get; set; } = "Customer"; // Admin, Customer

        public bool IsLocked { get; set; } = false;

        // External login support
        public string LoginProvider { get; set; } = "Local"; // "Local", "Facebook"
        public string? ProviderKey { get; set; } // Facebook User ID
    }
}
