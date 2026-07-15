using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using TechStoreWeb.Data;
using Microsoft.AspNetCore.Http;

namespace TechStoreWeb.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class CustomersController : Controller
    {
        private readonly AppDbContext _context;

        public CustomersController(AppDbContext context)
        {
            _context = context;
        }

        private bool IsAuthorized()
        {
            var role = HttpContext.Session.GetString("Role");
            return role == "Admin" || role == "Employee";
        }

        // GET: Admin/Customers
        public async Task<IActionResult> Index()
        {
            if (!IsAuthorized()) return RedirectToAction("Login", "Account", new { area = "" });
            
            var customers = await _context.Users
                .Where(u => u.Role == "Customer")
                .OrderByDescending(u => u.UserId)
                .ToListAsync();
            
            return View(customers);
        }

        // GET: Admin/Customers/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (!IsAuthorized()) return RedirectToAction("Login", "Account", new { area = "" });
            if (id == null) return NotFound();

            var customer = await _context.Users.FindAsync(id);
            if (customer == null || customer.Role != "Customer") return NotFound();

            return View(customer);
        }

        // POST: Admin/Customers/ToggleLock/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleLock(int id)
        {
            if (!IsAuthorized()) return RedirectToAction("Login", "Account", new { area = "" });

            var customer = await _context.Users.FindAsync(id);
            if (customer != null && customer.Role == "Customer")
            {
                customer.IsLocked = !customer.IsLocked;
                _context.Update(customer);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = customer.IsLocked ? "Đã khóa tài khoản khách hàng." : "Đã mở khóa tài khoản khách hàng.";
            }
            return RedirectToAction(nameof(Index));
        }
    }
}
