using Microsoft.EntityFrameworkCore;

namespace TechStoreWeb.Data
{
    public static class PromotionDatabaseInitializer
    {
        public static void EnsureCreated(AppDbContext context)
        {
            context.Database.ExecuteSqlRaw("""
                IF OBJECT_ID(N'[dbo].[PromotionProducts]', N'U') IS NULL
                BEGIN
                    CREATE TABLE [dbo].[PromotionProducts](
                        [Id] [int] IDENTITY(1,1) NOT NULL,
                        [PromotionId] [int] NOT NULL,
                        [ProductId] [int] NOT NULL,
                        [OriginalPrice] [decimal](18,2) NOT NULL,
                        CONSTRAINT [PK_PromotionProducts] PRIMARY KEY CLUSTERED ([Id] ASC)
                    );

                    IF OBJECT_ID(N'[dbo].[Promotions]', N'U') IS NOT NULL
                    BEGIN
                        ALTER TABLE [dbo].[PromotionProducts] WITH CHECK ADD CONSTRAINT [FK_PromotionProducts_Promotions_PromotionId]
                        FOREIGN KEY([PromotionId]) REFERENCES [dbo].[Promotions] ([Id]) ON DELETE CASCADE;
                    END

                    IF OBJECT_ID(N'[dbo].[Products]', N'U') IS NOT NULL
                    BEGIN
                        ALTER TABLE [dbo].[PromotionProducts] WITH CHECK ADD CONSTRAINT [FK_PromotionProducts_Products_ProductId]
                        FOREIGN KEY([ProductId]) REFERENCES [dbo].[Products] ([ProductId]) ON DELETE CASCADE;
                    END

                    CREATE UNIQUE INDEX [IX_PromotionProducts_PromotionId_ProductId]
                        ON [dbo].[PromotionProducts] ([PromotionId], [ProductId]);
                END
                """);
        }
    }
}
