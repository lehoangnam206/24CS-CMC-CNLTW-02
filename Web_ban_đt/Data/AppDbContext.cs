using Microsoft.EntityFrameworkCore;
using TechStoreWeb.Models;

namespace TechStoreWeb.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Category> Categories { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderDetail> OrderDetails { get; set; }
        public DbSet<Review> Reviews { get; set; }
        public DbSet<ProductDetail> ProductDetails { get; set; }
        public DbSet<ProductVariant> ProductVariants { get; set; }
        public DbSet<Promotion> Promotions { get; set; }
        public DbSet<PromotionProduct> PromotionProducts { get; set; }
        public DbSet<ChatCustomerMemory> ChatCustomerMemories { get; set; }
        public DbSet<ChatMessageLog> ChatMessageLogs { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<ChatCustomerMemory>()
                .Property(memory => memory.BudgetMin)
                .HasColumnType("decimal(18,2)");

            modelBuilder.Entity<ChatCustomerMemory>()
                .Property(memory => memory.BudgetMax)
                .HasColumnType("decimal(18,2)");

            // Mỗi sản phẩm chỉ xuất hiện một lần trong cùng một chương trình khuyến mại.
            modelBuilder.Entity<PromotionProduct>()
                .HasIndex(pp => new { pp.PromotionId, pp.ProductId })
                .IsUnique();

            modelBuilder.Entity<PromotionProduct>()
                .HasOne(pp => pp.Promotion)
                .WithMany()
                .HasForeignKey(pp => pp.PromotionId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<PromotionProduct>()
                .HasOne(pp => pp.Product)
                .WithMany()
                .HasForeignKey(pp => pp.ProductId)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
