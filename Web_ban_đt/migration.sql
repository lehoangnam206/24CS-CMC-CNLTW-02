BEGIN TRANSACTION;
ALTER TABLE [Products] ADD [OriginalPrice] decimal(18,2) NULL;

CREATE TABLE [Promotions] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(200) NOT NULL,
    [DiscountPercentage] int NOT NULL,
    [StartDate] datetime2 NOT NULL,
    [EndDate] datetime2 NOT NULL,
    [IsActive] bit NOT NULL,
    CONSTRAINT [PK_Promotions] PRIMARY KEY ([Id])
);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20260704123644_AddPromotion', N'10.0.9');

COMMIT;
GO
