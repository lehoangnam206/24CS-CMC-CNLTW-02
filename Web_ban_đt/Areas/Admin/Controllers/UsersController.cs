using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using TechStoreWeb.Data;
using Microsoft.AspNetCore.Http;
using TechStoreWeb.Models;

namespace TechStoreWeb.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class UsersController : Controller
    {
        private readonly AppDbContext _context;

        public UsersController(AppDbContext context)
        {
            _context = context;
        }

        private bool IsAdmin()
        {
            return HttpContext.Session.GetString("Role") == "Admin";
        }

        // GET: Admin/Users
        public async Task<IActionResult> Index()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });
            var users = await _context.Users.OrderByDescending(u => u.UserId).ToListAsync();
            
            return View(users);
        }

        // GET: Admin/Users/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });
            if (id == null) return NotFound();

            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();

            return View(user);
        }

        // POST: Admin/Users/ToggleLock/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleLock(int id)
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });

            var user = await _context.Users.FindAsync(id);
            if (user != null)
            {
                if (user.Role == "Admin")
                {
                    TempData["ErrorMessage"] = "Không thể khóa tài khoản Admin.";
                    return RedirectToAction(nameof(Index));
                }

                user.IsLocked = !user.IsLocked;
                _context.Update(user);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = user.IsLocked ? "Đã khóa tài khoản." : "Đã mở khóa tài khoản.";
            }
            return RedirectToAction(nameof(Index));
        }

        // POST: Admin/Users/ChangeRole/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangeRole(int id, string role)
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });

            var user = await _context.Users.FindAsync(id);
            if (user != null)
            {
                if (user.Role == "Admin")
                {
                    TempData["ErrorMessage"] = "Không thể thay đổi quyền của Admin hiện tại.";
                    return RedirectToAction(nameof(Index));
                }

                if (role == "Employee" || role == "Customer")
                {
                    user.Role = role;
                    _context.Update(user);
                    await _context.SaveChangesAsync();
                    TempData["SuccessMessage"] = $"Đã thay đổi quyền thành {role}.";
                }
            }
            return RedirectToAction(nameof(Index));
        }

        // Removed Edit actions as users manage their own accounts
    }
}
