using Microsoft.AspNetCore.Mvc;
using System.Linq;
using System.Security.Claims;
using TechStoreWeb.Data;
using TechStoreWeb.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;

namespace TechStoreWeb.Controllers
{
    public class AccountController : Controller
    {
        private readonly AppDbContext _context;

        public AccountController(AppDbContext context)
        {
            _context = context;
        }

        // UC01: Đăng ký
        public IActionResult Register(string? returnUrl = null)
        {
            ViewData["ReturnUrl"] = returnUrl;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Register(User user, string ConfirmPassword, string? returnUrl = null)
        {
            ViewData["ReturnUrl"] = returnUrl;
            
            ModelState.Remove("Role");
            ModelState.Remove("LoginProvider");
            ModelState.Remove("ProviderKey");
            ModelState.Remove("Username");

            if (user.Password != ConfirmPassword)
            {
                ModelState.AddModelError("", "Mật khẩu xác nhận không khớp.");
            }

            if (ModelState.IsValid)
            {
                var exists = _context.Users.Any(u => u.Email == user.Email || 
                    (user.Username != null && u.Username == user.Username));
                if (exists)
                {
                    ModelState.AddModelError("", "Email hoặc tên đăng nhập đã tồn tại.");
                    return View(user);
                }

                user.Role = "Customer";
                user.IsLocked = false;
                user.LoginProvider = "Local";
                _context.Users.Add(user);
                _context.SaveChanges();

                TempData["SuccessMessage"] = "Đăng ký thành công! Vui lòng đăng nhập.";
                return RedirectToAction("Login", new { returnUrl });
            }
            return View(user);
        }

        // UC02: Đăng nhập
        public IActionResult Login(string? returnUrl = null)
        {
            ViewData["ReturnUrl"] = returnUrl;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Login(string username, string password, string? returnUrl = null)
        {
            ViewData["ReturnUrl"] = returnUrl;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ModelState.AddModelError("", "Vui lòng nhập đầy đủ thông tin đăng nhập.");
                return View();
            }

            // Hỗ trợ đăng nhập bằng email hoặc username
            var user = _context.Users.FirstOrDefault(u =>
                (u.Username == username || u.Email == username) && 
                u.Password == password &&
                u.LoginProvider == "Local");

            if (user != null)
            {
                if (user.IsLocked)
                {
                    ModelState.AddModelError("", "Tài khoản của bạn đã bị khóa.");
                    return View();
                }

                // Set session
                HttpContext.Session.SetInt32("UserId", user.UserId);
                HttpContext.Session.SetString("Username", user.FullName);
                HttpContext.Session.SetString("Role", user.Role);

                // Nếu có returnUrl hợp lệ
                if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                {
                    return Redirect(returnUrl);
                }

                if (user.Role == "Admin")
                    return RedirectToAction("Index", "Products", new { area = "Admin" });

                return RedirectToAction("Index", "Home");
            }

            ModelState.AddModelError("", "Email/tên đăng nhập hoặc mật khẩu không chính xác.");
            return View();
        }

        // Đăng nhập bằng Facebook (bắt đầu OAuth flow)
        [HttpGet]
        public IActionResult ExternalLogin(string provider, string returnUrl = "/")
        {
            var redirectUrl = Url.Action("ExternalLoginCallback", "Account", new { returnUrl });
            var properties = new AuthenticationProperties { RedirectUri = redirectUrl };
            return Challenge(properties, provider);
        }

        // Callback từ Facebook/Google sau khi user xác thực
        [HttpGet]
        public async Task<IActionResult> ExternalLoginCallback(string returnUrl = "/")
        {
            var result = await HttpContext.AuthenticateAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            if (!result.Succeeded)
            {
                TempData["ErrorMessage"] = "Đăng nhập thất bại. Vui lòng thử lại.";
                return RedirectToAction("Login");
            }

            var claims = result.Principal?.Identities.FirstOrDefault()?.Claims;
            if (claims == null)
            {
                TempData["ErrorMessage"] = "Không thể lấy thông tin tài khoản.";
                return RedirectToAction("Login");
            }

            var providerId = claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;
            var email = claims.FirstOrDefault(c => c.Type == ClaimTypes.Email)?.Value;
            var name = claims.FirstOrDefault(c => c.Type == ClaimTypes.Name)?.Value;

            // Xác định provider (Facebook hoặc Google)
            var issuer = result.Principal?.Identities.FirstOrDefault()?.AuthenticationType;
            var provider = issuer switch
            {
                "Facebook" => "Facebook",
                "Google" => "Google",
                _ => "External"
            };

            if (string.IsNullOrEmpty(providerId))
            {
                TempData["ErrorMessage"] = $"Không thể lấy ID từ {provider}.";
                return RedirectToAction("Login");
            }

            // Tìm user đã liên kết provider này
            var user = _context.Users.FirstOrDefault(u =>
                u.LoginProvider == provider && u.ProviderKey == providerId);

            // Nếu chưa có → tìm theo email
            if (user == null && !string.IsNullOrEmpty(email))
            {
                user = _context.Users.FirstOrDefault(u => u.Email == email);
                if (user != null)
                {
                    // Liên kết tài khoản hiện có
                    user.LoginProvider = provider;
                    user.ProviderKey = providerId;
                    _context.SaveChanges();
                }
            }

            // Nếu vẫn chưa có → tạo tài khoản mới
            if (user == null)
            {
                user = new User
                {
                    FullName = name ?? $"{provider} User",
                    Email = email ?? $"{provider.ToLower()}_{providerId}@external.com",
                    Username = null,
                    Password = null,
                    PhoneNumber = null,
                    Role = "Customer",
                    IsLocked = false,
                    LoginProvider = provider,
                    ProviderKey = providerId
                };
                _context.Users.Add(user);
                _context.SaveChanges();
            }

            // Kiểm tra tài khoản bị khóa
            if (user.IsLocked)
            {
                // Sign out khỏi cookie authentication
                await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
                TempData["ErrorMessage"] = "Tài khoản của bạn đã bị khóa.";
                return RedirectToAction("Login");
            }

            // Set session
            HttpContext.Session.SetInt32("UserId", user.UserId);
            HttpContext.Session.SetString("Username", user.FullName);
            HttpContext.Session.SetString("Role", user.Role);

            // Sign out khỏi external cookie (đã lưu session rồi)
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);

            if (user.Role == "Admin")
                return RedirectToAction("Index", "Products", new { area = "Admin" });

            return Redirect(returnUrl ?? "/");
        }

        public async Task<IActionResult> Logout()
        {
            HttpContext.Session.Clear();
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Index", "Home");
        }

        // UC06: Chỉnh sửa thông tin cá nhân
        public IActionResult Profile()
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null) return RedirectToAction("Login", new { returnUrl = "/Account/Profile" });

            var user = _context.Users.Find(userId);
            if (user == null) return RedirectToAction("Login", new { returnUrl = "/Account/Profile" });

            return View(user);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Profile(User updatedUser)
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null) return RedirectToAction("Login", new { returnUrl = "/Account/Profile" });

            if (ModelState.IsValid)
            {
                var user = _context.Users.Find(userId);
                if (user != null)
                {
                    user.FullName = updatedUser.FullName;
                    user.Email = updatedUser.Email;
                    user.PhoneNumber = updatedUser.PhoneNumber;

                    // Nếu có đổi mật khẩu
                    if (!string.IsNullOrEmpty(updatedUser.Password))
                    {
                        user.Password = updatedUser.Password;
                    }

                    _context.SaveChanges();

                    HttpContext.Session.SetString("Username", user.FullName);
                    TempData["SuccessMessage"] = "Cập nhật thông tin thành công!";
                    return RedirectToAction("Profile");
                }
            }
            return View(updatedUser);
        }

        // Xem đơn hàng của tôi
        public IActionResult Orders()
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null) return RedirectToAction("Login", new { returnUrl = "/Account/Orders" });

            var orders = _context.Orders
                .Include(o => o.OrderDetails)
                .ThenInclude(od => od.Product)
                .Where(o => o.UserId == userId)
                .OrderByDescending(o => o.OrderDate)
                .ToList();

            return View(orders);
        }
    }
}