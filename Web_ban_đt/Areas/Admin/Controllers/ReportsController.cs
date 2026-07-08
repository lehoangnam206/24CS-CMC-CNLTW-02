using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;
using TechStoreWeb.Data;
using Microsoft.AspNetCore.Http;
using TechStoreWeb.Models;
using System.Collections.Generic;

namespace TechStoreWeb.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class ReportsController : Controller
    {
        private readonly AppDbContext _context;

        public ReportsController(AppDbContext context)
        {
            _context = context;
        }

        private bool IsAdmin()
        {
            var role = HttpContext.Session.GetString("Role");
            return role == "Admin" || role == "Employee";
        }

        public async Task<IActionResult> Index()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });

            var hasData = await _context.Orders.AnyAsync();
            if (!hasData)
            {
                ViewBag.Message = "Chưa có thông tin để báo cáo.";
                return View(new List<Order>());
            }

            var orders = await _context.Orders
                .Include(o => o.User)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            var activeOrders = orders.Where(o => o.Status != "Cancelled").ToList();

            ViewBag.TotalRevenue = activeOrders.Sum(o => o.TotalAmount);
            ViewBag.TotalOrders = orders.Count;
            ViewBag.SuccessOrders = orders.Count(o => o.Status == "Delivered");

            // Thống kê số đơn hàng theo từng ngày trong tuần
            // DayOfWeek: Sunday=0, Monday=1, ..., Saturday=6
            // Hiển thị: Thứ 2 (Monday) -> CN (Sunday)
            var ordersByDayOfWeek = new int[7]; // index 0=Thứ 2, 1=Thứ 3, ..., 5=Thứ 7, 6=CN
            foreach (var order in activeOrders)
            {
                var dayOfWeek = order.OrderDate.DayOfWeek;
                int index = dayOfWeek switch
                {
                    DayOfWeek.Monday => 0,
                    DayOfWeek.Tuesday => 1,
                    DayOfWeek.Wednesday => 2,
                    DayOfWeek.Thursday => 3,
                    DayOfWeek.Friday => 4,
                    DayOfWeek.Saturday => 5,
                    DayOfWeek.Sunday => 6,
                    _ => 0
                };
                ordersByDayOfWeek[index]++;
            }
            ViewBag.OrdersByDayOfWeek = ordersByDayOfWeek;

            // Thống kê doanh thu theo từng ngày trong tuần
            var revenueByDayOfWeek = new decimal[7];
            foreach (var order in activeOrders)
            {
                var dayOfWeek = order.OrderDate.DayOfWeek;
                int index = dayOfWeek switch
                {
                    DayOfWeek.Monday => 0,
                    DayOfWeek.Tuesday => 1,
                    DayOfWeek.Wednesday => 2,
                    DayOfWeek.Thursday => 3,
                    DayOfWeek.Friday => 4,
                    DayOfWeek.Saturday => 5,
                    DayOfWeek.Sunday => 6,
                    _ => 0
                };
                revenueByDayOfWeek[index] += order.TotalAmount;
            }
            ViewBag.RevenueByDayOfWeek = revenueByDayOfWeek;

            return View(orders);
        }

        public IActionResult Print()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Account", new { area = "" });
            // Tính năng in thực tế được thực hiện bằng JS window.print() ở view
            return RedirectToAction(nameof(Index));
        }
    }
}
