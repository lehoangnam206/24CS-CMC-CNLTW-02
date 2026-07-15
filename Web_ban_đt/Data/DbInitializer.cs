using System;
using System.IO;
using System.Linq;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Hosting;
using TechStoreWeb.Models;

namespace TechStoreWeb.Data
{
    public static class DbInitializer
    {
        public static void Initialize(AppDbContext context, IWebHostEnvironment env)
        {
            // Ensure database and tables exist (does NOT delete existing data)
            context.Database.EnsureCreated();

            // Seed default Admin user if none exists
            if (!context.Users.Any(u => u.Role == "Admin"))
            {
                context.Users.Add(new User
                {
                    Username = "admin",
                    Password = "adminpassword", // In production, this should be hashed
                    FullName = "Administrator",
                    Email = "admin@techstore.com",
                    PhoneNumber = "0123456789",
                    Role = "Admin",
                    IsLocked = false
                });
                context.SaveChanges();
            }

            // Fix usernames to be without diacritics
            var existingUsers = context.Users.Where(u => !string.IsNullOrEmpty(u.Username)).ToList();
            bool usersChanged = false;
            foreach (var user in existingUsers)
            {
                var cleanUsername = RemoveDiacritics(user.Username).Replace(" ", "");
                if (cleanUsername != user.Username)
                {
                    user.Username = cleanUsername;
                    usersChanged = true;
                }
            }
            if (usersChanged)
            {
                context.SaveChanges();
            }

            // Source directory for web images
            string sourceWebPath = Path.GetFullPath(Path.Combine(env.ContentRootPath, "..", "web"));
            // Target directory in wwwroot
            string targetWebPath = Path.Combine(env.WebRootPath, "images");

            if (Directory.Exists(sourceWebPath))
            {
                if (!Directory.Exists(targetWebPath))
                {
                    Directory.CreateDirectory(targetWebPath);
                }

                // Copy all brand folders and images
                foreach (string dirPath in Directory.GetDirectories(sourceWebPath, "*", SearchOption.AllDirectories))
                {
                    string targetDir = dirPath.Replace(sourceWebPath, targetWebPath);
                    if (!Directory.Exists(targetDir))
                    {
                        Directory.CreateDirectory(targetDir);
                    }
                }

                foreach (string newPath in Directory.GetFiles(sourceWebPath, "*.*", SearchOption.AllDirectories))
                {
                    string targetFile = newPath.Replace(sourceWebPath, targetWebPath);
                    if (!File.Exists(targetFile))
                    {
                        File.Copy(newPath, targetFile, true);
                    }
                }
            }

            // Check if there are any products that use placeholder URLs
            bool hasPlaceholders = context.Products.Any(p => p.ImageUrl.Contains("via.placeholder.com") || p.ImageUrl.Contains("placeholder"));

            // Get all directories under targetWebPath (wwwroot/images)
            var brandFolders = Directory.GetDirectories(targetWebPath)
                .Select(Path.GetFileName)
                .Where(name => !name.Equals("Giao diện trang chủ", StringComparison.OrdinalIgnoreCase))
                .ToList();

            var existingCategories = context.Categories.ToList();
            bool needsCategoryUpdate = brandFolders.Any(bf => !existingCategories.Any(ec => ec.CategoryName.Equals(bf, StringComparison.OrdinalIgnoreCase)));

            if (!context.Categories.Any())
            {
                // MOCK DATA GENERATION DISABLED
                // Dữ liệu thật đã được nạp từ data.sql
            }
        }

        private static string CleanProductName(string rawName, string brand, int index)
        {
            // Check if rawName is a random hash or default word like "images", "tải xuống", "shopping"
            string clean = rawName.ToLower();
            bool isGeneric = clean.Contains("images") || 
                             clean.Contains("shopping") || 
                             clean.Contains("tải xuống") || 
                             clean.Contains("download") ||
                             Regex.IsMatch(clean, "^[a-f0-9]{16,32}$") || 
                             clean.Length < 4;

            if (isGeneric)
            {
                return $"{brand} Model {index:D2}";
            }

            // Clean up name
            clean = clean.Replace("-", " ");
            clean = clean.Replace("_", " ");
            clean = Regex.Replace(clean, @"\s+", " ");

            // Remove thumb sizes, resolutions, etc.
            clean = clean.Replace("thumb 600x600", "");
            clean = clean.Replace("600x600 2", "");
            clean = clean.Replace("600x600", "");
            clean = Regex.Replace(clean, @"\(\d+\)", ""); // Remove (1), (2), etc.
            clean = clean.Trim();

            // Title case formatting
            TextInfo textInfo = new CultureInfo("en-US", false).TextInfo;
            string formattedName = textInfo.ToTitleCase(clean);

            // Ensure brand is not duplicated in name
            if (formattedName.StartsWith(brand, StringComparison.OrdinalIgnoreCase))
            {
                return formattedName;
            }

            return $"{brand} {formattedName}";
        }

        private static decimal GeneratePrice(string brand, int index)
        {
            // Give products a varied price based on brand and index
            long basePrice = 2500000;
            switch (brand.ToLower())
            {
                case "iphone":
                    basePrice = 12000000 + (index * 1500000);
                    break;
                case "samsung":
                    basePrice = 5000000 + (index * 800000);
                    break;
                case "huawei":
                    basePrice = 4500000 + (index * 750000);
                    break;
                case "oppo":
                    basePrice = 4000000 + (index * 600000);
                    break;
                case "xiaomi":
                    basePrice = 3800000 + (index * 550000);
                    break;
                case "honor":
                    basePrice = 3500000 + (index * 500000);
                    break;
                case "tecno":
                    basePrice = 2200000 + (index * 400000);
                    break;
                case "nokia":
                    basePrice = 5700000;  // Fixed price for Nokia 105
                    break;
                default:
                    basePrice = 3000000 + (index * 500000);
                    break;
            }

            // Round to nearest 10,000 VND
            basePrice = (basePrice / 10000) * 10000;
            return (decimal)basePrice;
        }

        private static string RemoveDiacritics(string text)
        {
            if (string.IsNullOrWhiteSpace(text)) return text;
            var normalizedString = text.Normalize(NormalizationForm.FormD);
            var stringBuilder = new System.Text.StringBuilder();

            foreach (var c in normalizedString)
            {
                var unicodeCategory = CharUnicodeInfo.GetUnicodeCategory(c);
                if (unicodeCategory != UnicodeCategory.NonSpacingMark)
                {
                    stringBuilder.Append(c);
                }
            }

            return stringBuilder.ToString().Normalize(NormalizationForm.FormC).Replace("đ", "d").Replace("Đ", "D");
        }
    }
}
