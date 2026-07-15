using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using TechStoreWeb.Data;
using Microsoft.AspNetCore.Http;
using TechStoreWeb.Models;
using System.Collections.Generic;

namespace TechStoreWeb.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class OrdersController : Controller
    {
        private readonly AppDbContext _context;

        public OrdersController(AppDbContext context)
        {
            _context = context;
        }

        private bool IsAdmin()
        {
            return HttpContext.Session.GetString("Role") == "Admin";
        }

        public async Task<IActionResult> Index()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });

            var orders = await _context.Orders
                .Include(o => o.User)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            return View(orders);
        }

        public async Task<IActionResult> Details(int id)
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });

            var order = await _context.Orders
                .Include(o => o.User)
                .Include(o => o.OrderDetails)
                .ThenInclude(od => od.Product)
                .FirstOrDefaultAsync(o => o.OrderId == id);

            if (order == null) return NotFound();

            return View(order);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateStatus(int orderId, string status)
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });

            var order = await _context.Orders.FindAsync(orderId);
            if (order != null)
            {
                var statuses = new List<string> { "Pending", "WaitingForPickup", "PickedUp", "Shipping", "Delivered" };
                int currentIndex = statuses.IndexOf(order.Status);
                int newIndex = statuses.IndexOf(status);

                bool isInvalid = false;
                if (order.Status == "Cancelled" || order.Status == "Delivered") isInvalid = true;
                if (currentIndex >= 0 && newIndex >= 0 && newIndex < currentIndex) isInvalid = true;

                if (isInvalid && order.Status != status)
                {
                    TempData["ErrorMessage"] = "Lỗi: Không thể quay ngược trạng thái hoặc cập nhật đơn hàng đã đóng.";
                }
                else
                {
                    order.Status = status;
                    await _context.SaveChangesAsync();
                    TempData["SuccessMessage"] = $"Cập nhật trạng thái đơn hàng #{orderId} thành công!";
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Không tìm thấy đơn hàng.";
            }

            return RedirectToAction(nameof(Index));
        }
    }
}
