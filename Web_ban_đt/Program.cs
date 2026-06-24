using System;
using Microsoft.EntityFrameworkCore;
using TechStoreWeb.Data; // Lưu ý: Nếu tên Project của bạn khác 'TechStoreWeb', hãy sửa lại cho khớp

var builder = WebApplication.CreateBuilder(args);

// 1. Thêm dịch vụ MVC (Model-View-Controller)
builder.Services.AddControllersWithViews();

// Add session support
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromDays(7);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

// 2. Cấu hình kết nối Database bằng Entity Framework Core
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

var app = builder.Build();

// 3. Cấu hình HTTP request pipeline (Luồng xử lý request)
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // HSTS giúp tăng cường bảo mật khi chạy thực tế
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles(); // Cho phép đọc các file css, js, hình ảnh trong thư mục wwwroot

app.UseRouting();

// enable session middleware
app.UseSession();

app.UseAuthorization();

// 4. Cấu hình Route mặc định (Trang chủ sẽ trỏ thẳng vào HomeController và action Index)
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();