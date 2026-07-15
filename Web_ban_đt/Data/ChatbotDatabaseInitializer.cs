using Microsoft.EntityFrameworkCore;

namespace TechStoreWeb.Data
{
    public static class ChatbotDatabaseInitializer
    {
        public static void EnsureCreated(AppDbContext context)
        {
            context.Database.ExecuteSqlRaw("""
                IF OBJECT_ID(N'[dbo].[ChatCustomerMemories]', N'U') IS NULL
                BEGIN
                    CREATE TABLE [dbo].[ChatCustomerMemories](
                        [ChatCustomerMemoryId] [int] IDENTITY(1,1) NOT NULL,
                        [CustomerKey] [nvarchar](120) NOT NULL,
                        [UserId] [int] NULL,
                        [CustomerName] [nvarchar](160) NULL,
                        [PreferredBrands] [nvarchar](max) NOT NULL DEFAULT(N''),
                        [BudgetMin] [decimal](18,2) NULL,
                        [BudgetMax] [decimal](18,2) NULL,
                        [UseCases] [nvarchar](max) NOT NULL DEFAULT(N''),
                        [InterestedProducts] [nvarchar](max) NOT NULL DEFAULT(N''),
                        [Notes] [nvarchar](max) NOT NULL DEFAULT(N''),
                        [UpdatedAt] [datetime2](7) NOT NULL,
                        CONSTRAINT [PK_ChatCustomerMemories] PRIMARY KEY CLUSTERED ([ChatCustomerMemoryId] ASC)
                    );

                    IF OBJECT_ID(N'[dbo].[Users]', N'U') IS NOT NULL
                    BEGIN
                        ALTER TABLE [dbo].[ChatCustomerMemories] WITH CHECK ADD CONSTRAINT [FK_ChatCustomerMemories_Users_UserId]
                        FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([UserId]);
                    END

                    CREATE INDEX [IX_ChatCustomerMemories_UserId] ON [dbo].[ChatCustomerMemories] ([UserId]);
                    CREATE INDEX [IX_ChatCustomerMemories_CustomerKey] ON [dbo].[ChatCustomerMemories] ([CustomerKey]);
                END
                """);

            context.Database.ExecuteSqlRaw("""
                IF OBJECT_ID(N'[dbo].[ChatMessageLogs]', N'U') IS NULL
                BEGIN
                    CREATE TABLE [dbo].[ChatMessageLogs](
                        [ChatMessageLogId] [int] IDENTITY(1,1) NOT NULL,
                        [CustomerKey] [nvarchar](120) NOT NULL,
                        [UserId] [int] NULL,
                        [Role] [nvarchar](20) NOT NULL,
                        [Content] [nvarchar](max) NOT NULL,
                        [CreatedAt] [datetime2](7) NOT NULL,
                        CONSTRAINT [PK_ChatMessageLogs] PRIMARY KEY CLUSTERED ([ChatMessageLogId] ASC)
                    );

                    IF OBJECT_ID(N'[dbo].[Users]', N'U') IS NOT NULL
                    BEGIN
                        ALTER TABLE [dbo].[ChatMessageLogs] WITH CHECK ADD CONSTRAINT [FK_ChatMessageLogs_Users_UserId]
                        FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([UserId]);
                    END

                    CREATE INDEX [IX_ChatMessageLogs_UserId] ON [dbo].[ChatMessageLogs] ([UserId]);
                    CREATE INDEX [IX_ChatMessageLogs_CustomerKey] ON [dbo].[ChatMessageLogs] ([CustomerKey]);
                    CREATE INDEX [IX_ChatMessageLogs_CreatedAt] ON [dbo].[ChatMessageLogs] ([CreatedAt]);
                END
                """);
        }
    }
}
