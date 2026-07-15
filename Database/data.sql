USE [master]
GO
/****** Object:  Database [TechStoreDB]    Script Date: 7/13/2026 8:46:42 PM ******/
CREATE DATABASE [TechStoreDB]
 CONTAINMENT = NONE
 
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [TechStoreDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TechStoreDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TechStoreDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TechStoreDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TechStoreDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TechStoreDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TechStoreDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [TechStoreDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TechStoreDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TechStoreDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TechStoreDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TechStoreDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TechStoreDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TechStoreDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TechStoreDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TechStoreDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TechStoreDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [TechStoreDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TechStoreDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TechStoreDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TechStoreDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TechStoreDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TechStoreDB] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [TechStoreDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TechStoreDB] SET RECOVERY FULL 
GO
ALTER DATABASE [TechStoreDB] SET  MULTI_USER 
GO
ALTER DATABASE [TechStoreDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TechStoreDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TechStoreDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TechStoreDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TechStoreDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TechStoreDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'TechStoreDB', N'ON'
GO
ALTER DATABASE [TechStoreDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [TechStoreDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [TechStoreDB]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 7/13/2026 8:46:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 7/13/2026 8:46:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 7/13/2026 8:46:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[OrderDetailId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[OrderDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 7/13/2026 8:46:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[OrderDate] [datetime2](7) NOT NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL,
	[Status] [nvarchar](max) NOT NULL,
	[PaymentMethod] [nvarchar](max) NOT NULL,
	[ShippingAddress] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductDetails]    Script Date: 7/13/2026 8:46:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductDetails](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[CategoryId] [int] NULL,
	[CPU] [nvarchar](150) NULL,
	[RAM] [nvarchar](50) NULL,
	[ROM] [nvarchar](50) NULL,
	[Screen] [nvarchar](250) NULL,
	[Battery] [nvarchar](100) NULL,
	[Camera] [nvarchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 7/13/2026 8:46:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[ImageUrl] [nvarchar](max) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[OriginalPrice] [decimal](18, 2) NULL,
	[Stock] [int] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductVariants]    Script Date: 7/13/2026 8:46:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductVariants](
	[VariantId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Color] [nvarchar](50) NOT NULL,
	[ROM] [nvarchar](50) NOT NULL,
	[Stock] [int] NULL,
	[Price] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[VariantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Promotions]    Script Date: 7/13/2026 8:46:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Promotions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[DiscountPercentage] [int] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Promotions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 7/13/2026 8:46:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[ReviewId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Rating] [int] NOT NULL,
	[Comment] [nvarchar](max) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED 
(
	[ReviewId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 7/13/2026 8:46:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NULL,
	[Password] [nvarchar](max) NULL,
	[FullName] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[Role] [nvarchar](max) NOT NULL,
	[IsLocked] [bit] NOT NULL,
	[LoginProvider] [nvarchar](max) NOT NULL,
	[ProviderKey] [nvarchar](max) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20260704123644_AddPromotion', N'10.0.9')
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([CategoryId], [CategoryName]) VALUES (1, N'Honor')
INSERT [dbo].[Categories] ([CategoryId], [CategoryName]) VALUES (2, N'Huawei')
INSERT [dbo].[Categories] ([CategoryId], [CategoryName]) VALUES (3, N'Iphone')
INSERT [dbo].[Categories] ([CategoryId], [CategoryName]) VALUES (4, N'Nokia')
INSERT [dbo].[Categories] ([CategoryId], [CategoryName]) VALUES (5, N'Oppo')
INSERT [dbo].[Categories] ([CategoryId], [CategoryName]) VALUES (6, N'Samsung')
INSERT [dbo].[Categories] ([CategoryId], [CategoryName]) VALUES (7, N'Tecno')
INSERT [dbo].[Categories] ([CategoryId], [CategoryName]) VALUES (8, N'Xiaomi')
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderDetails] ON 

INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (1, 1, 3, 2, CAST(5000000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (2, 2, 3, 2, CAST(5000000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (3, 3, 1, 6, CAST(4000000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (4, 4, 4, 1, CAST(5500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (5, 5, 2, 1, CAST(4500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (6, 5, 9, 1, CAST(8000000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (7, 6, 1, 1, CAST(2000000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (8, 7, 2, 1, CAST(4500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (9, 8, 11, 1, CAST(9000000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (10, 8, 8, 1, CAST(7500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (11, 9, 2, 2, CAST(4500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (12, 9, 1, 3, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (13, 9, 10, 3, CAST(8500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (14, 9, 30, 1, CAST(9000000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (15, 9, 26, 1, CAST(6000000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (16, 9, 14, 1, CAST(10500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (17, 10, 2, 1, CAST(4500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (18, 11, 13, 1, CAST(10000000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (19, 11, 5, 1, CAST(6000000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (20, 12, 2, 10, CAST(4500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (21, 12, 10, 13, CAST(8500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (22, 13, 6, 1, CAST(6500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (23, 13, 3, 1, CAST(5000000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (24, 13, 2, 1, CAST(4500000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (25, 14, 84, 1, CAST(4600000.00 AS Decimal(18, 2)))
INSERT [dbo].[OrderDetails] ([OrderDetailId], [OrderId], [ProductId], [Quantity], [UnitPrice]) VALUES (26, 14, 85, 1, CAST(5200000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[OrderDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (1, 2, CAST(N'2026-07-04T13:17:07.1741915' AS DateTime2), CAST(10020000.00 AS Decimal(18, 2)), N'Pending', N'VNPAY', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (2, 2, CAST(N'2026-07-04T18:58:38.5744693' AS DateTime2), CAST(10020000.00 AS Decimal(18, 2)), N'Pending', N'COD', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (3, 3, CAST(N'2026-07-06T20:27:06.3076866' AS DateTime2), CAST(24020000.00 AS Decimal(18, 2)), N'Pending', N'VNPAY', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (4, 3, CAST(N'2026-07-06T20:27:41.9565522' AS DateTime2), CAST(5520000.00 AS Decimal(18, 2)), N'Pending', N'COD', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (5, 2, CAST(N'2026-07-07T07:01:46.2069174' AS DateTime2), CAST(12420000.00 AS Decimal(18, 2)), N'Pending', N'VNPAY', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (6, 1, CAST(N'2026-07-07T07:06:39.5919907' AS DateTime2), CAST(2020000.00 AS Decimal(18, 2)), N'Pending', N'VNPAY', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (7, 2, CAST(N'2026-07-07T07:13:56.1607039' AS DateTime2), CAST(4520000.00 AS Decimal(18, 2)), N'Pending', N'VNPAY', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (8, 2, CAST(N'2026-07-07T07:23:20.0770278' AS DateTime2), CAST(16520000.00 AS Decimal(18, 2)), N'Cancelled', N'VNPAY', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (9, 2, CAST(N'2026-07-07T09:02:07.3256328' AS DateTime2), CAST(59920000.00 AS Decimal(18, 2)), N'Delivered', N'VNPAY', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (10, 2, CAST(N'2026-07-07T09:42:44.0566013' AS DateTime2), CAST(4520000.00 AS Decimal(18, 2)), N'PickedUp', N'VNPAY', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (11, 2, CAST(N'2026-07-07T10:53:13.5329746' AS DateTime2), CAST(16020000.00 AS Decimal(18, 2)), N'Pending', N'VNPAY', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (12, 2, CAST(N'2026-07-07T11:41:59.6466095' AS DateTime2), CAST(155520000.00 AS Decimal(18, 2)), N'Pending', N'VNPAY', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (13, 3, CAST(N'2026-07-08T12:33:38.5867862' AS DateTime2), CAST(16020000.00 AS Decimal(18, 2)), N'PickedUp', N'VNPAY', N'hà nội')
INSERT [dbo].[Orders] ([OrderId], [UserId], [OrderDate], [TotalAmount], [Status], [PaymentMethod], [ShippingAddress]) VALUES (14, 3, CAST(N'2026-07-09T07:14:49.2107358' AS DateTime2), CAST(9820000.00 AS Decimal(18, 2)), N'Delivered', N'VNPAY', N'hà nội')
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[ProductDetails] ON 

INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (1, N'Honor X7b 128GB', 1, N'Snapdragon 680', N'8GB', N'128GB', N'6.8 inch IPS 90Hz', N'6000 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (2, N'Honor X6a', 1, N'Helio G88', N'6GB', N'128GB', N'6.56 inch IPS 90Hz', N'5200 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (3, N'Honor X8b 256GB', 1, N'Snapdragon 685', N'8GB', N'256GB', N'6.7 inch AMOLED', N'4500 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (4, N'Honor 90 Lite', 1, N'Dimensity 6020', N'8GB', N'256GB', N'6.7 inch IPS 90Hz', N'4500 mAh', N'100MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (5, N'Honor 90 5G', 1, N'Snapdragon 7 Gen 1', N'12GB', N'256GB', N'6.7 inch OLED 120Hz', N'5000 mAh', N'200MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (6, N'Honor 200 5G', 1, N'Snapdragon 7 Gen 3', N'12GB', N'512GB', N'6.7 inch OLED 120Hz', N'5200 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (7, N'Honor 200 Pro', 1, N'Snapdragon 8s Gen 3', N'12GB', N'512GB', N'6.78 inch OLED 120Hz', N'5200 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (8, N'Honor 200 Lite', 1, N'Dimensity 6080', N'8GB', N'256GB', N'6.7 inch AMOLED', N'4500 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (9, N'Honor X9b 5G', 1, N'Snapdragon 6 Gen 1', N'12GB', N'256GB', N'6.78 inch AMOLED', N'5800 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (10, N'Honor Magic6 Pro', 1, N'Snapdragon 8 Gen 3', N'16GB', N'512GB', N'6.8 inch LTPO OLED', N'5600 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (11, N'Honor 400 Smart', 1, N'Dimensity 6080', N'8GB', N'256GB', N'6.8 inch IPS 90Hz', N'5330 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (12, N'Honor 600', 1, N'Snapdragon 778G', N'8GB', N'128GB', N'6.67 inch OLED 120Hz', N'4800 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (13, N'Honor 600 Pro Vàng', 1, N'Snapdragon 8+ Gen 1', N'12GB', N'256GB', N'6.78 inch OLED', N'4800 mAh', N'54MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (14, N'Honor 600 Pro Molly', 1, N'Snapdragon 8+ Gen 1', N'12GB', N'512GB', N'6.78 inch OLED', N'4800 mAh', N'54MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (15, N'Honor Power 5G', 1, N'Dimensity 6020', N'8GB', N'256GB', N'6.56 inch IPS LCD', N'6000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (16, N'Honor Win Xanh', 1, N'Snapdragon 6 Gen 1', N'8GB', N'256GB', N'6.78 inch AMOLED', N'5800 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (17, N'Honor X5c Plus', 1, N'Helio G36', N'4GB', N'64GB', N'6.56 inch IPS LCD', N'5200 mAh', N'52MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (18, N'Honor X6c Đen V1', 1, N'Helio G85', N'6GB', N'128GB', N'6.56 inch TFT 90Hz', N'5200 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (19, N'Honor X6c Đen V2', 1, N'Helio G85', N'6GB', N'128GB', N'6.56 inch TFT 90Hz', N'5200 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (20, N'Honor X70 Nâu', 1, N'Snapdragon 782G', N'12GB', N'256GB', N'6.67 inch OLED', N'4800 mAh', N'54MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (21, N'Honor X80 Pro Max', 1, N'Snapdragon 8 Gen 2', N'16GB', N'512GB', N'6.81 inch LTPO OLED', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (22, N'Honor X8d', 1, N'Helio G99', N'8GB', N'256GB', N'6.7 inch IPS 90Hz', N'4500 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (23, N'Honor X9c Titan', 1, N'Snapdragon 6 Gen 1', N'12GB', N'256GB', N'6.78 inch AMOLED', N'6600 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (24, N'Honor X9d Nâu Đỏ', 1, N'Snapdragon 7 Gen 3', N'12GB', N'512GB', N'6.78 inch AMOLED', N'5500 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (25, N'Huawei Model 01', 2, N'Kirin 9000S', N'12GB', N'256GB', N'6.82" LTPO OLED', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (26, N'Huawei Model 02', 2, N'Kirin 9010', N'16GB', N'512GB', N'6.8" LTPO OLED 120Hz', N'5050 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (27, N'Huawei Model 03', 2, N'Kirin 9000E', N'8GB', N'128GB', N'6.5" OLED 90Hz', N'4200 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (28, N'Huawei Model 04', 2, N'Snapdragon 778G 4G', N'8GB', N'256GB', N'6.7" OLED 120Hz', N'4500 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (29, N'Huawei Model 05', 2, N'Snapdragon 680', N'8GB', N'128GB', N'6.7" IPS 90Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (30, N'Huawei Model 06', 2, N'Kirin 820 5G', N'8GB', N'128GB', N'6.5" LTPS IPS', N'4000 mAh', N'64MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (31, N'Huawei Model 07', 2, N'Kirin 985 5G', N'8GB', N'256GB', N'6.57" OLED 90Hz', N'4000 mAh', N'64MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (32, N'Huawei Model 08', 2, N'Snapdragon 888 4G', N'8GB', N'256GB', N'6.6" OLED 120Hz', N'4360 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (33, N'Huawei Model 09', 2, N'Snapdragon 8+ G1 4G', N'8GB', N'256GB', N'6.7" OLED 120Hz', N'4460 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (34, N'Huawei Model 10', 2, N'Snapdragon 8+ G1 4G', N'12GB', N'512GB', N'6.74" OLED 120Hz', N'4700 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (35, N'Huawei Model 11', 2, N'Snapdragon 778G 4G', N'8GB', N'128GB', N'6.57" OLED 120Hz', N'4300 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (36, N'Huawei Model 12', 2, N'Kirin 710A', N'4GB', N'128GB', N'6.75" IPS LCD', N'6000 mAh', N'48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (37, N'Huawei Model 13', 2, N'Snapdragon 680', N'8GB', N'128GB', N'6.8" IPS 90Hz', N'5000 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (38, N'Huawei Model 14', 2, N'Snapdragon 680', N'8GB', N'256GB', N'6.7" OLED 90Hz', N'4500 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (39, N'Huawei Model 15', 2, N'Snapdragon 778G 4G', N'8GB', N'256GB', N'6.78" OLED 120Hz', N'4500 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (40, N'Huawei Model 16', 2, N'Snapdragon 7 Gen 1', N'8GB', N'256GB', N'6.7" OLED 120Hz', N'4500 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (41, N'Huawei Model 17', 2, N'Snapdragon 7 Gen 1', N'12GB', N'512GB', N'6.78" OLED 120Hz', N'4600 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (42, N'Huawei Model 18', 2, N'Kirin 9000S', N'12GB', N'512GB', N'6.69" LTPO OLED', N'4900 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (43, N'Huawei Model 19', 2, N'Kirin 9010', N'12GB', N'256GB', N'6.6" LTPO OLED', N'4900 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (44, N'Huawei Model 20', 2, N'Kirin 9010', N'16GB', N'1TB', N'6.8" LTPO OLED', N'5200 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (45, N'Iphone 11 Pro Midnight Green', 3, N'Apple A13 Bionic', N'4GB', N'256GB', N'5.8 inch OLED', N'3046 mAh', N'3x 12MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (46, N'Iphone 13', 3, N'Apple A15 Bionic', N'4GB', N'128GB', N'6.1 inch OLED', N'3240 mAh', N'Dual 12MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (47, N'Iphone 14', 3, N'Apple A15 Bionic', N'6GB', N'128GB', N'6.1 inch OLED', N'3279 mAh', N'Dual 12MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (48, N'Iphone 15 Plus 256Gb', 3, N'Apple A16 Bionic', N'6GB', N'256GB', N'6.7 inch OLED', N'4383 mAh', N'48MP + 12MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (49, N'Iphone 15 Plus 128Gb', 3, N'Apple A16 Bionic', N'6GB', N'128GB', N'6.7 inch OLED', N'4383 mAh', N'48MP + 12MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (50, N'Iphone 16', 3, N'Apple A18', N'8GB', N'128GB', N'6.1 inch OLED', N'3561 mAh', N'48MP + 12MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (51, N'Iphone 16 Plus', 3, N'Apple A18', N'8GB', N'128GB', N'6.7 inch OLED', N'4674 mAh', N'48MP + 12MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (52, N'Iphone 16 Pro Max', 3, N'Apple A18 Pro', N'8GB', N'256GB', N'6.9 inch ProMotion', N'4685 mAh', N'48MP + 48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (53, N'Iphone 16E 128Gb', 3, N'Apple A18', N'8GB', N'128GB', N'6.1 inch OLED', N'3300 mAh', N'48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (54, N'Iphone 16E 256Gb', 3, N'Apple A18', N'8GB', N'256GB', N'6.1 inch OLED', N'3300 mAh', N'48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (55, N'Iphone 17 Pro 256 Gb', 3, N'Apple A19 Pro', N'12GB', N'256GB', N'6.3 inch 120Hz', N'3800 mAh', N'3x 48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (56, N'Iphone 17 Pro Max', 3, N'Apple A19 Pro', N'12GB', N'256GB', N'6.9 inch 120Hz', N'4900 mAh', N'3x 48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (57, N'Iphone 17E Pink', 3, N'Apple A19', N'8GB', N'128GB', N'6.2 inch OLED', N'3400 mAh', N'48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (58, N'Iphone 17 256Gb', 3, N'Apple A19', N'8GB', N'256GB', N'6.1 inch OLED', N'3600 mAh', N'48MP + 12MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (59, N'Iphone 17 Pro 512Gb', 3, N'Apple A19 Pro', N'12GB', N'512GB', N'6.3 inch 120Hz', N'3800 mAh', N'3x 48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (60, N'Iphone Air', 3, N'Apple A19 Slim', N'8GB', N'128GB', N'6.6 inch Ultra-Thin', N'3100 mAh', N'48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (61, N'Iphone Okia C21 Plus', 3, N'Unisoc SC9863A', N'3GB', N'32GB', N'6.5 inch IPS LCD', N'5000 mAh', N'13MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (62, N'Iphone Model 18', 3, N'Apple A17 Pro', N'8GB', N'256GB', N'6.1 inch OLED', N'3274 mAh', N'48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (63, N'Iphone Model 19', 3, N'Apple A17 Pro', N'8GB', N'512GB', N'6.7 inch OLED', N'4441 mAh', N'48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (64, N'Iphone Model 20', 3, N'Apple A16 Bionic', N'6GB', N'512GB', N'6.7 inch OLED', N'4323 mAh', N'48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (65, N'Nokia Model 01', 4, N'Unisoc T107', N'48MB', N'128MB', N'1.8" QQVGA', N'1020 mAh', N'Không có')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (66, N'Nokia Dgtyi8899', 4, N'Helio P35', N'4GB', N'64GB', N'6.5" IPS LCD', N'5000 mAh', N'13MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (67, N'Nokia 105 4G Den', 4, N'Unisoc T107', N'48MB', N'128MB', N'1.8" QQVGA', N'1450 mAh', N'Không có')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (68, N'Nokia 105 4G Pro', 4, N'Unisoc T107', N'48MB', N'128MB', N'1.8" QQVGA', N'1450 mAh', N'Không có')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (69, N'Nokia 220 4G 6', 4, N'Unisoc T107', N'64MB', N'128MB', N'2.8" QVGA', N'1450 mAh', N'0.3MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (70, N'Nokia 220 4G V2', 4, N'Unisoc T107', N'64MB', N'128MB', N'2.8" QVGA', N'1450 mAh', N'0.3MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (71, N'Nokia 3210 4G', 4, N'Unisoc T107', N'64MB', N'128MB', N'2.4" TFT LCD', N'1450 mAh', N'2MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (72, N'Nokia 34 1', 4, N'Snapdragon 460', N'4GB', N'64GB', N'6.39" HD+', N'4000 mAh', N'13MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (73, N'Nokia 5 4 Xanh 1', 4, N'Snapdragon 662', N'4GB', N'128GB', N'6.39" IPS LCD', N'4000 mAh', N'48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (74, N'Nokia C1 Xam1', 4, N'Unisoc SC7731E', N'1GB', N'16GB', N'5.45" IPS LCD', N'2500 mAh', N'5MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (75, N'Nokia C20 2', 4, N'Unisoc SC9863A', N'2GB', N'32GB', N'6.52" IPS LCD', N'3000 mAh', N'5MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (76, N'Nokia C20 2 4', 4, N'Unisoc SC9863A', N'2GB', N'32GB', N'6.52" IPS LCD', N'3000 mAh', N'5MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (77, N'Nokia C21 Plus 2Gb 32Gb', 4, N'Unisoc SC9863A', N'2GB', N'32GB', N'6.5" IPS LCD', N'5000 mAh', N'13MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (78, N'Nokia C32 1 2', 4, N'Unisoc SC9863A1', N'4GB', N'128GB', N'6.5" IPS LCD', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (79, N'Nokia Hmd 105 4G Pink', 4, N'Unisoc T107', N'48MB', N'128MB', N'1.8" QQVGA', N'1450 mAh', N'Không có')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (80, N'Nokia 7.2 Xanh', 4, N'Snapdragon 660', N'4GB', N'64GB', N'6.3" IPS LCD', N'3500 mAh', N'48MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (81, N'Nokia C12', 4, N'Unisoc 9863A1', N'3GB', N'64GB', N'6.3" IPS LCD', N'3000 mAh', N'8MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (82, N'Nokia Okia C21 Plus', 4, N'Unisoc SC9863A', N'2GB', N'32GB', N'6.5" IPS LCD', N'5000 mAh', N'13MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (83, N'Nokia C31 4G', 4, N'Unisoc SC9863A1', N'4GB', N'128GB', N'6.75" HD+', N'5050 mAh', N'13MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (84, N'Oppo A17k (Bản Thấp)', 5, N'Helio G35', N'3GB', N'64GB', N'6.56" IPS LCD', N'5000 mAh', N'8MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (85, N'Oppo A17k', 5, N'Helio G35', N'4GB', N'64GB', N'6.56" IPS LCD', N'5000 mAh', N'8MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (86, N'Oppo A57 (Bản Thấp)', 5, N'Helio G35', N'4GB', N'64GB', N'6.56" IPS LCD', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (87, N'Oppo A57 128GB', 5, N'Helio G35', N'4GB', N'128GB', N'6.56" IPS LCD', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (88, N'Oppo A78 4G White', 5, N'Snapdragon 680', N'8GB', N'128GB', N'6.43" AMOLED', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (89, N'Oppo A79 5G White', 5, N'Snapdragon 685', N'8GB', N'256GB', N'6.67" AMOLED 120Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (90, N'Oppo A98 5G White', 5, N'Dimensity 6300', N'8GB', N'256GB', N'6.67" LCD 120Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (91, N'Oppo Reno10 5G', 5, N'Dimensity 7050', N'8GB', N'256GB', N'6.7" AMOLED 120Hz', N'5000 mAh', N'64MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (92, N'Oppo A18 Cực Quang', 5, N'Helio G85', N'4GB', N'128GB', N'6.56" IPS LCD', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (93, N'Oppo Reno8 T 5G', 5, N'Snapdragon 695', N'8GB', N'256GB', N'6.7" AMOLED 120Hz', N'4800 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (94, N'Oppo Reno12 5G', 5, N'Dimensity 7300', N'12GB', N'256GB', N'6.7" AMOLED 120Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (95, N'Oppo Reno10 Pro 5G', 5, N'Snapdragon 778G', N'8GB', N'256GB', N'6.7" AMOLED 120Hz', N'4600 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (96, N'Oppo Find N3 Flip', 5, N'Dimensity 9200+', N'12GB', N'256GB', N'6.82" AMOLED', N'4300 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (97, N'Oppo Find X6 Pro', 5, N'Snapdragon 8 Gen 2', N'16GB', N'512GB', N'6.82" AMOLED', N'5000 mAh', N'4x 50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (98, N'Oppo A16k', 5, N'Helio G35', N'4GB', N'64GB', N'6.51" IPS LCD', N'5000 mAh', N'13MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (99, N'Oppo A38 128GB', 5, N'Snapdragon 680', N'4GB', N'128GB', N'6.56" IPS 90Hz', N'5000 mAh', N'13MP')
GO
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (100, N'Oppo Reno8 Pro 5G', 5, N'Dimensity 1300', N'8GB', N'256GB', N'6.4" AMOLED 90Hz', N'4500 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (101, N'Oppo Reno8 Z 5G', 5, N'Snapdragon 695', N'8GB', N'128GB', N'6.43" AMOLED', N'4500 mAh', N'64MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (102, N'Oppo Reno11 F 5G', 5, N'Dimensity 7050', N'8GB', N'256GB', N'6.7" AMOLED 120Hz', N'5000 mAh', N'64MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (103, N'Oppo A58 6GB', 5, N'Snapdragon 680', N'6GB', N'128GB', N'6.4" AMOLED 90Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (104, N'Samsung Model 01', 6, N'Helio G85', N'4GB', N'128GB', N'6.7" PLS LCD', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (105, N'Samsung Model 02', 6, N'Helio G99', N'8GB', N'128GB', N'6.5" AMOLED 90Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (106, N'Samsung Model 03', 6, N'Exynos 1380', N'8GB', N'128GB', N'6.6" AMOLED 120Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (107, N'Samsung Model 04', 6, N'Snapdragon 8 Gen 3', N'12GB', N'256GB', N'6.8" Dyn AMOLED', N'5000 mAh', N'200MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (108, N'Samsung Model 05', 6, N'Exynos 1480', N'8GB', N'128GB', N'6.6" AMOLED 120Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (109, N'Samsung Model 06', 6, N'Exynos 2400e', N'8GB', N'128GB', N'6.7" Dyn AMOLED', N'4700 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (110, N'Samsung Model 07', 6, N'Exynos 850', N'4GB', N'64GB', N'6.6" PLS LCD 90Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (111, N'Samsung Model 08', 6, N'Snapdragon 680', N'6GB', N'128GB', N'6.6" PLS LCD 90Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (112, N'Samsung Model 09', 6, N'Snapdragon 778G', N'8GB', N'256GB', N'6.7" AMOLED Plus', N'5000 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (113, N'Samsung Model 10', 6, N'Snapdragon 8 Gen 2', N'8GB', N'128GB', N'6.1" Dyn AMOLED', N'3900 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (114, N'Samsung Model 11', 6, N'Snapdragon 8 Gen 2', N'8GB', N'256GB', N'6.6" Dyn AMOLED', N'4700 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (115, N'Samsung Model 12', 6, N'Snapdragon 8 Gen 2', N'12GB', N'256GB', N'6.8" Dyn AMOLED', N'5000 mAh', N'200MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (116, N'Samsung Model 13', 6, N'Snapdragon 8 Gen 3', N'12GB', N'256GB', N'6.2" Dyn AMOLED', N'4000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (117, N'Samsung Model 14', 6, N'Snapdragon 8 Gen 3', N'12GB', N'256GB', N'6.7" Dyn AMOLED', N'4900 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (118, N'Samsung Model 15', 6, N'Dimensity 6100+', N'4GB', N'128GB', N'6.5" AMOLED 90Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (119, N'Samsung Model 16', 6, N'Dimensity 7200U', N'8GB', N'256GB', N'6.67" AMOLED 120Hz', N'5000 mAh', N'200MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (120, N'Samsung Model 17', 6, N'Exynos 1280', N'6GB', N'128GB', N'6.5" AMOLED 120Hz', N'5000 mAh', N'64MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (121, N'Samsung Model 18', 6, N'Exynos 1330', N'4GB', N'128GB', N'6.6" PLS LCD 90Hz', N'6000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (122, N'Samsung Model 19', 6, N'Snapdragon 695', N'8GB', N'128GB', N'6.6" PLS LCD 120Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (123, N'Samsung Model 20', 6, N'Exynos 2400', N'12GB', N'512GB', N'6.7" Dyn AMOLED', N'4900 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (124, N'Tecno Model 01', 7, N'Helio G36', N'4GB', N'64GB', N'6.6" IPS 90Hz', N'5000 mAh', N'13MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (125, N'Tecno Model 02', 7, N'Helio G85', N'8GB', N'256GB', N'6.6" IPS 90Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (126, N'Tecno Model 03', 7, N'Helio G99 Ultra', N'8GB', N'256GB', N'6.78" AMOLED', N'6000 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (127, N'Tecno Model 04', 7, N'Helio G37', N'4GB', N'128GB', N'6.6" IPS 90Hz', N'5000 mAh', N'16MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (128, N'Tecno Model 05', 7, N'Helio G99', N'8GB', N'128GB', N'6.82" IPS 90Hz', N'6000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (129, N'Tecno Model 06', 7, N'Helio G88', N'8GB', N'128GB', N'6.8" IPS 90Hz', N'5000 mAh', N'64MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (130, N'Tecno Model 07', 7, N'Dimensity 6080', N'8GB', N'256GB', N'6.78" IPS 120Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (131, N'Tecno Model 08', 7, N'Dimensity 6080', N'12GB', N'256GB', N'6.78" AMOLED', N'5000 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (132, N'Tecno Model 09', 7, N'Dimensity 8050', N'8GB', N'256GB', N'6.67" AMOLED', N'5000 mAh', N'64MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (133, N'Tecno Model 10', 7, N'Dimensity 8050', N'12GB', N'512GB', N'6.67" AMOLED', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (134, N'Tecno Model 11', 7, N'Helio G99', N'8GB', N'256GB', N'6.78" IPS 120Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (135, N'Tecno Model 12', 7, N'Helio G25', N'2GB', N'32GB', N'6.52" IPS LCD', N'5000 mAh', N'8MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (136, N'Tecno Model 13', 7, N'Helio A22', N'4GB', N'64GB', N'6.6" IPS LCD', N'5000 mAh', N'13MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (137, N'Tecno Model 14', 7, N'Helio G36', N'4GB', N'128GB', N'6.6" IPS 90Hz', N'5000 mAh', N'13MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (138, N'Tecno Model 15', 7, N'Helio G85', N'4GB', N'128GB', N'6.6" IPS 90Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (139, N'Tecno Model 16', 7, N'Helio G99 Ultra', N'8GB', N'256GB', N'6.78" AMOLED', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (140, N'Tecno Model 17', 7, N'Dimensity 7020', N'8GB', N'256GB', N'6.78" AMOLED', N'5000 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (141, N'Tecno Model 18', 7, N'Dimensity 7020', N'12GB', N'256GB', N'6.78" AMOLED', N'4600 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (142, N'Tecno Model 19', 7, N'Dimensity 9000', N'12GB', N'512GB', N'6.8" Fold AMOLED', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (143, N'Tecno Model 20', 7, N'Dimensity 9000', N'12GB', N'256GB', N'6.6" Roll AMOLED', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (144, N'Tecno Model 21', 7, N'Helio G100', N'8GB', N'256GB', N'6.78" AMOLED', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (145, N'Xiaomi 17 Ultra Den', 8, N'Snapdragon 8 Gen 4', N'16GB', N'512GB', N'6.73" LTPO AMOLED', N'5500 mAh', N'4x 50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (146, N'Xiaomi Redmi 15C 41 1', 8, N'Helio G81', N'4GB', N'128GB', N'6.88" IPS 120Hz', N'5160 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (147, N'Xiaomi Redmi 15C 41 1 3', 8, N'Helio G81', N'4GB', N'128GB', N'6.88" IPS 120Hz', N'5160 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (148, N'Xiaomi Redmi Note 14 5G.1', 8, N'Dimensity 7025 Ultra', N'8GB', N'128GB', N'6.67" OLED 120Hz', N'5110 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (149, N'Xiaomi Redmi Note 14 3 2', 8, N'Dimensity 7025 Ultra', N'8GB', N'256GB', N'6.67" OLED 120Hz', N'5110 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (150, N'Xiaomi Redmi Note 15 Pro 5G Vang', 8, N'Snapdragon 7s Gen 3', N'12GB', N'256GB', N'6.67" AMOLED 1.5K', N'5500 mAh', N'200MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (151, N'Xiaomi Image 1262703569', 8, N'Snapdragon 685', N'8GB', N'128GB', N'6.67" AMOLED 120Hz', N'5000 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (152, N'Xiaomi Photo 2025 04 16 11 45 37', 8, N'Snapdragon 4 Gen 2', N'6GB', N'128GB', N'6.79" IPS 90Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (153, N'Xiaomi Poco F8 Pro', 8, N'Snapdragon 8s Gen 4', N'12GB', N'512GB', N'6.67" OLED 2K', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (154, N'Xiaomi Redmi Note 15 Series 1 3', 8, N'Dimensity 6080', N'6GB', N'128GB', N'6.67" AMOLED', N'5000 mAh', N'108MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (155, N'Xiaomi Redmi Note 15 Series 4 2', 8, N'Dimensity 7300', N'8GB', N'256GB', N'6.67" OLED 120Hz', N'5110 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (156, N'Xiaomi Redmi Pad 2 9 7 Inch', 8, N'Snapdragon 680', N'4GB', N'128GB', N'9.7" IPS LCD 90Hz', N'8000 mAh', N'8MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (157, N'Xiaomi 17T Pro 1 4', 8, N'Dimensity 9400', N'12GB', N'512GB', N'6.67" AMOLED 144Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (158, N'Xiaomi 17T 2', 8, N'Dimensity 8300 Ultra', N'12GB', N'256GB', N'6.67" AMOLED 144Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (159, N'Xiaomi Pad Mini', 8, N'Helio G99', N'4GB', N'64GB', N'8.7" IPS LCD 90Hz', N'6500 mAh', N'8MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (160, N'Xiaomi Redmi 15 5G 1 1', 8, N'Snapdragon 4 Gen 2', N'4GB', N'128GB', N'6.79" IPS 90Hz', N'5000 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (161, N'Xiaomi Redmi A7 Pro 1', 8, N'MediaTek Helio G36', N'3GB', N'64GB', N'6.52" IPS LCD', N'5000 mAh', N'8MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (162, N'Xiaomi Redmi Note 14 Pro Plus', 8, N'Snapdragon 7s Gen 3', N'12GB', N'512GB', N'6.67" AMOLED Curved', N'6200 mAh', N'50MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (163, N'Xiaomi Redmi Pad 2 Wifi 1', 8, N'Snapdragon 680', N'4GB', N'128GB', N'10.61" IPS 90Hz', N'8000 mAh', N'8MP')
INSERT [dbo].[ProductDetails] ([ProductId], [Name], [CategoryId], [CPU], [RAM], [ROM], [Screen], [Battery], [Camera]) VALUES (164, N'Xiaomi Redmi 14C 5 1 1', 8, N'Helio G81 Ultra', N'6GB', N'128GB', N'6.88" IPS 120Hz', N'5160 mAh', N'50MP')
SET IDENTITY_INSERT [dbo].[ProductDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (1, N'Honor X7b 128GB', CAST(4000000.00 AS Decimal(18, 2)), N'/images/Honor/339245-600x600-2.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (2, N'Honor X6a', CAST(4500000.00 AS Decimal(18, 2)), N'/images/Honor/339638-600x600-2.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (3, N'Honor X8b 256GB', CAST(5000000.00 AS Decimal(18, 2)), N'/images/Honor/340220-600x600-2.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (4, N'Honor 90 Lite', CAST(5500000.00 AS Decimal(18, 2)), N'/images/Honor/344641.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (5, N'Honor 90 5G', CAST(6000000.00 AS Decimal(18, 2)), N'/images/Honor/358683-600x600-2.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (6, N'Honor 200 5G', CAST(6500000.00 AS Decimal(18, 2)), N'/images/Honor/358691-600x600-2.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (7, N'Honor 200 Pro', CAST(7000000.00 AS Decimal(18, 2)), N'/images/Honor/358698-600x600-2.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (8, N'Honor 200 Lite', CAST(7500000.00 AS Decimal(18, 2)), N'/images/Honor/362919.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (9, N'Honor X9b 5G', CAST(8000000.00 AS Decimal(18, 2)), N'/images/Honor/362971.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (10, N'Honor Magic6 Pro', CAST(8500000.00 AS Decimal(18, 2)), N'/images/Honor/363410.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (11, N'Honor 400 Smart', CAST(9000000.00 AS Decimal(18, 2)), N'/images/Honor/honor-400-smart-den.jpg.webp', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (12, N'Honor 600', CAST(9500000.00 AS Decimal(18, 2)), N'/images/Honor/honor-600-1.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (13, N'Honor 600 Pro Vàng', CAST(10000000.00 AS Decimal(18, 2)), N'/images/Honor/honor-600-pro-12gb-256gb-vang-thumb-600x600.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (14, N'Honor 600 Pro Molly', CAST(10500000.00 AS Decimal(18, 2)), N'/images/Honor/honor-600-pro-molly-12gb-512gb-thumb-639165315982574935-600x600.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (15, N'Honor Power 5G', CAST(11000000.00 AS Decimal(18, 2)), N'/images/Honor/honor-power-5g-den.jpg.webp', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (16, N'Honor Win Xanh', CAST(11500000.00 AS Decimal(18, 2)), N'/images/Honor/honor-win-xanh-mobilecity.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (17, N'Honor X5c Plus', CAST(12000000.00 AS Decimal(18, 2)), N'/images/Honor/honor-x5c-plus-xanh.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (18, N'Honor X6c Đen V1', CAST(12500000.00 AS Decimal(18, 2)), N'/images/Honor/honor-x6c-den.jpg (1).webp', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (19, N'Honor X6c Đen V2', CAST(13000000.00 AS Decimal(18, 2)), N'/images/Honor/honor-x6c-den.jpg.webp', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (20, N'Honor X70 Nâu', CAST(13500000.00 AS Decimal(18, 2)), N'/images/Honor/honor-x70-nau.jpg.webp', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (21, N'Honor X80 Pro Max', CAST(14000000.00 AS Decimal(18, 2)), N'/images/Honor/honor-x80-pro-max-vang.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (22, N'Honor X8d', CAST(14500000.00 AS Decimal(18, 2)), N'/images/Honor/honor-x8d-chinh-hang-2.jpg', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (23, N'Honor X9c Titan', CAST(15000000.00 AS Decimal(18, 2)), N'/images/Honor/honor-x9c-5g-mobilecity-den-titan.jpg.webp', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (24, N'Honor X9d Nâu Đỏ', CAST(15500000.00 AS Decimal(18, 2)), N'/images/Honor/honor-x9d-nau-do.jpg.webp', 1, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (25, N'Huawei Model 01', CAST(5250000.00 AS Decimal(18, 2)), N'/images/Huawei/images (1).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (26, N'Huawei Model 02', CAST(6000000.00 AS Decimal(18, 2)), N'/images/Huawei/images (2).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (27, N'Huawei Model 03', CAST(6750000.00 AS Decimal(18, 2)), N'/images/Huawei/images (3).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (28, N'Huawei Model 04', CAST(7500000.00 AS Decimal(18, 2)), N'/images/Huawei/images (4).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (29, N'Huawei Model 05', CAST(8250000.00 AS Decimal(18, 2)), N'/images/Huawei/images (5).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (30, N'Huawei Model 06', CAST(9000000.00 AS Decimal(18, 2)), N'/images/Huawei/images (6).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (31, N'Huawei Model 07', CAST(9750000.00 AS Decimal(18, 2)), N'/images/Huawei/images (7).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (32, N'Huawei Model 08', CAST(10500000.00 AS Decimal(18, 2)), N'/images/Huawei/images (8).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (33, N'Huawei Model 09', CAST(11250000.00 AS Decimal(18, 2)), N'/images/Huawei/images.jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (34, N'Huawei Model 10', CAST(12000000.00 AS Decimal(18, 2)), N'/images/Huawei/tải xuống (1).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (35, N'Huawei Model 11', CAST(12750000.00 AS Decimal(18, 2)), N'/images/Huawei/tải xuống (10).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (36, N'Huawei Model 12', CAST(13500000.00 AS Decimal(18, 2)), N'/images/Huawei/tải xuống (2).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (37, N'Huawei Model 13', CAST(14250000.00 AS Decimal(18, 2)), N'/images/Huawei/tải xuống (3).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (38, N'Huawei Model 14', CAST(15000000.00 AS Decimal(18, 2)), N'/images/Huawei/tải xuống (4).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (39, N'Huawei Model 15', CAST(15750000.00 AS Decimal(18, 2)), N'/images/Huawei/tải xuống (5).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (40, N'Huawei Model 16', CAST(16500000.00 AS Decimal(18, 2)), N'/images/Huawei/tải xuống (6).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (41, N'Huawei Model 17', CAST(17250000.00 AS Decimal(18, 2)), N'/images/Huawei/tải xuống (7).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (42, N'Huawei Model 18', CAST(18000000.00 AS Decimal(18, 2)), N'/images/Huawei/tải xuống (8).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (43, N'Huawei Model 19', CAST(18750000.00 AS Decimal(18, 2)), N'/images/Huawei/tải xuống (9).jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (44, N'Huawei Model 20', CAST(19500000.00 AS Decimal(18, 2)), N'/images/Huawei/tải xuống.jpg', 2, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (45, N'Iphone 11 Pro Midnight Green Select 2019 6 2 1', CAST(13500000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-11-pro-midnight-green-select-2019_6_2_1.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (46, N'Iphone 13 2 2', CAST(15000000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-13_2_2.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (47, N'Iphone 14 2 1', CAST(16500000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-14_2_1.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (48, N'Iphone 15 Plus 256Gb 3', CAST(18000000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-15-plus-256gb_3.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (49, N'Iphone 15 Plus 1 1', CAST(19500000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-15-plus_1__1.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (50, N'Iphone 16 1', CAST(21000000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-16-1.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (51, N'Iphone 16 Plus 1', CAST(22500000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-16-plus-1.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (52, N'Iphone 16 Pro Max 1', CAST(24000000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-16-pro-max_1.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (53, N'Iphone 16E 128Gb', CAST(25500000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-16e-128gb.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (54, N'Iphone 16E 256Gb', CAST(27000000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-16e-256gb.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (55, N'Iphone 17 Pro 256 Gb', CAST(28500000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-17-pro-256-gb.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (56, N'Iphone 17 Pro Max 3', CAST(30000000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone-17-pro-max_3.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (57, N'Iphone 17E Pink 1', CAST(31500000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone_17e_pink_1.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (58, N'Iphone 17 256Gb 3 2', CAST(33000000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone_17_256gb-3_2.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (59, N'Iphone 17 Pro 512Gb', CAST(34500000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone_17_pro_512gb.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (60, N'Iphone Air 3 2', CAST(36000000.00 AS Decimal(18, 2)), N'/images/Iphone/iphone_air-3_2.webp', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (61, N'Iphone Okia C21 Plus', CAST(37500000.00 AS Decimal(18, 2)), N'/images/Iphone/okia-c21-plus.png', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (62, N'Iphone Model 18', CAST(39000000.00 AS Decimal(18, 2)), N'/images/Iphone/tải xuống (1).jpg', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (63, N'Iphone Model 19', CAST(40500000.00 AS Decimal(18, 2)), N'/images/Iphone/tải xuống (2).jpg', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (64, N'Iphone Model 20', CAST(42000000.00 AS Decimal(18, 2)), N'/images/Iphone/tải xuống.jpg', 3, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (65, N'Nokia Model 01', CAST(1500000.00 AS Decimal(18, 2)), N'/images/Nokia/8c1337410477f374e67a1a8f6ce0835e.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (66, N'Nokia Dgtyi8899', CAST(1800000.00 AS Decimal(18, 2)), N'/images/Nokia/dgtyi8899_.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (67, N'Nokia 105 4G Den', CAST(2100000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-105-4g-den-thumb-600x600.jpg', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (68, N'Nokia 105 4G Pro 1 1', CAST(2400000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-105-4g-pro_1__1.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (69, N'Nokia 220 4G 6', CAST(2700000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-220-4g_6_.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (70, N'Nokia 220 4G 6 1 1 1', CAST(3000000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-220-4g_6__1_1_1.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (71, N'Nokia 3210 4G', CAST(3300000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-3210-4g.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (72, N'Nokia 34 1', CAST(3600000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-34_1_.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (73, N'Nokia 5 4 Xanh 1', CAST(3900000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-5-4-xanh_1.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (74, N'Nokia C1 Xam1', CAST(4200000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-c1-xam1.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (75, N'Nokia C20 2', CAST(4500000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-c20-2.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (76, N'Nokia C20 2 4', CAST(4800000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-c20-2_4.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (77, N'Nokia C21 Plus 2Gb 32Gb', CAST(5100000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-c21-plus-2gb-32gb.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (78, N'Nokia C32 1 2', CAST(5400000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-c32_1_2.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (79, N'Nokia Hmd 105 4G Pink', CAST(5700000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia-hmd-105-4g-pink-thumb-600x600.jpg', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (80, N'Nokia 7.2 Xanh', CAST(6000000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia_7.2_xanh.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (81, N'Nokia C12', CAST(6300000.00 AS Decimal(18, 2)), N'/images/Nokia/nokia_c12.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (82, N'Nokia Okia C21 Plus', CAST(6600000.00 AS Decimal(18, 2)), N'/images/Nokia/okia-c21-plus.png', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (83, N'Nokia C31 4G', CAST(6900000.00 AS Decimal(18, 2)), N'/images/Nokia/xcc.webp', 4, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (84, N'Oppo A17k (Bản Thấp)', CAST(4600000.00 AS Decimal(18, 2)), N'/images/Oppo/1B49u6VNBTpJxdQA (1).png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (85, N'Oppo A17k', CAST(5200000.00 AS Decimal(18, 2)), N'/images/Oppo/1B49u6VNBTpJxdQA.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (86, N'Oppo A57 (Bản Thấp)', CAST(5800000.00 AS Decimal(18, 2)), N'/images/Oppo/2WYmeGdFxjfe0FdK (1).png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (87, N'Oppo A57 128GB', CAST(6400000.00 AS Decimal(18, 2)), N'/images/Oppo/2WYmeGdFxjfe0FdK.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (88, N'Oppo A78 4G White', CAST(7000000.00 AS Decimal(18, 2)), N'/images/Oppo/432-600-white.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (89, N'Oppo A79 5G White', CAST(7600000.00 AS Decimal(18, 2)), N'/images/Oppo/436-600-white-v2.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (90, N'Oppo A98 5G White', CAST(8200000.00 AS Decimal(18, 2)), N'/images/Oppo/448-600-white.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (91, N'Oppo Reno10 5G', CAST(8800000.00 AS Decimal(18, 2)), N'/images/Oppo/7bpZlMBKwfQ8WFXc.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (92, N'Oppo A18 Cực Quang', CAST(9400000.00 AS Decimal(18, 2)), N'/images/Oppo/awCws8AK7FEmywh0.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (93, N'Oppo Reno8 T 5G', CAST(10000000.00 AS Decimal(18, 2)), N'/images/Oppo/cSPNUwCZEUxgZoH6.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (94, N'Oppo Reno12 5G', CAST(10600000.00 AS Decimal(18, 2)), N'/images/Oppo/frMwQNX8zQCM4Lwv.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (95, N'Oppo Reno10 Pro 5G', CAST(11200000.00 AS Decimal(18, 2)), N'/images/Oppo/gWFFQLulUxwKjL3M.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (96, N'Oppo Find N3 Flip', CAST(11800000.00 AS Decimal(18, 2)), N'/images/Oppo/mJfycRMhzuaBhwOI.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (97, N'Oppo Find X6 Pro', CAST(12400000.00 AS Decimal(18, 2)), N'/images/Oppo/Q0HKJMsW0mtNustk.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (98, N'Oppo A16k', CAST(13000000.00 AS Decimal(18, 2)), N'/images/Oppo/q9hLp7R4QHt3o4Pn.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (99, N'Oppo A38 128GB', CAST(13600000.00 AS Decimal(18, 2)), N'/images/Oppo/rPTvCJMpwWAivYLl.png', 5, NULL, 100)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (100, N'Oppo Reno8 Pro 5G', CAST(14200000.00 AS Decimal(18, 2)), N'/images/Oppo/TvoHQUMUCdxlxXdt.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (101, N'Oppo Reno8 Z 5G', CAST(14800000.00 AS Decimal(18, 2)), N'/images/Oppo/UmoG900qfdonngrB.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (102, N'Oppo Reno11 F 5G', CAST(15400000.00 AS Decimal(18, 2)), N'/images/Oppo/vbUvVV8XYivlSNHx.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (103, N'Oppo A58 6GB', CAST(16000000.00 AS Decimal(18, 2)), N'/images/Oppo/xrfN6Q4SbFuKfRHT.png', 5, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (104, N'Samsung Model 01', CAST(5800000.00 AS Decimal(18, 2)), N'/images/Samsung/,.jpg', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (105, N'Samsung Model 02', CAST(6600000.00 AS Decimal(18, 2)), N'/images/Samsung/images (1).jpg', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (106, N'Samsung Model 03', CAST(7400000.00 AS Decimal(18, 2)), N'/images/Samsung/images (2).jpg', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (107, N'Samsung Model 04', CAST(8200000.00 AS Decimal(18, 2)), N'/images/Samsung/images (3).jpg', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (108, N'Samsung Model 05', CAST(9000000.00 AS Decimal(18, 2)), N'/images/Samsung/images (4).jpg', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (109, N'Samsung Model 06', CAST(9800000.00 AS Decimal(18, 2)), N'/images/Samsung/images (5).jpg', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (110, N'Samsung Model 07', CAST(10600000.00 AS Decimal(18, 2)), N'/images/Samsung/images (6).jpg', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (111, N'Samsung Model 08', CAST(11400000.00 AS Decimal(18, 2)), N'/images/Samsung/images.jpg', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (112, N'Samsung Model 09', CAST(12200000.00 AS Decimal(18, 2)), N'/images/Samsung/shopping (1).webp', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (113, N'Samsung Model 10', CAST(13000000.00 AS Decimal(18, 2)), N'/images/Samsung/shopping (2).webp', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (114, N'Samsung Model 11', CAST(13800000.00 AS Decimal(18, 2)), N'/images/Samsung/shopping (3).webp', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (115, N'Samsung Model 12', CAST(14600000.00 AS Decimal(18, 2)), N'/images/Samsung/shopping (4).webp', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (116, N'Samsung Model 13', CAST(15400000.00 AS Decimal(18, 2)), N'/images/Samsung/shopping (5).webp', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (117, N'Samsung Model 14', CAST(16200000.00 AS Decimal(18, 2)), N'/images/Samsung/shopping (6).webp', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (118, N'Samsung Model 15', CAST(17000000.00 AS Decimal(18, 2)), N'/images/Samsung/shopping (7).webp', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (119, N'Samsung Model 16', CAST(17800000.00 AS Decimal(18, 2)), N'/images/Samsung/shopping (8).webp', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (120, N'Samsung Model 17', CAST(18600000.00 AS Decimal(18, 2)), N'/images/Samsung/shopping.webp', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (121, N'Samsung Model 18', CAST(19400000.00 AS Decimal(18, 2)), N'/images/Samsung/tải xuống (1).jpg', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (122, N'Samsung Model 19', CAST(20200000.00 AS Decimal(18, 2)), N'/images/Samsung/tải xuống (2).jpg', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (123, N'Samsung Model 20', CAST(21000000.00 AS Decimal(18, 2)), N'/images/Samsung/tải xuống.jpg', 6, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (124, N'Tecno Model 01', CAST(2600000.00 AS Decimal(18, 2)), N'/images/Tecno/images (1).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (125, N'Tecno Model 02', CAST(3000000.00 AS Decimal(18, 2)), N'/images/Tecno/images (2).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (126, N'Tecno Model 03', CAST(3400000.00 AS Decimal(18, 2)), N'/images/Tecno/images (3).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (127, N'Tecno Model 04', CAST(3800000.00 AS Decimal(18, 2)), N'/images/Tecno/images (4).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (128, N'Tecno Model 05', CAST(4200000.00 AS Decimal(18, 2)), N'/images/Tecno/images (5).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (129, N'Tecno Model 06', CAST(4600000.00 AS Decimal(18, 2)), N'/images/Tecno/images (6).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (130, N'Tecno Model 07', CAST(5000000.00 AS Decimal(18, 2)), N'/images/Tecno/images (7).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (131, N'Tecno Model 08', CAST(5400000.00 AS Decimal(18, 2)), N'/images/Tecno/images (8).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (132, N'Tecno Model 09', CAST(5800000.00 AS Decimal(18, 2)), N'/images/Tecno/images (9).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (133, N'Tecno Model 10', CAST(6200000.00 AS Decimal(18, 2)), N'/images/Tecno/images.jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (134, N'Tecno Model 11', CAST(6600000.00 AS Decimal(18, 2)), N'/images/Tecno/tải xuống (1).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (135, N'Tecno Model 12', CAST(7000000.00 AS Decimal(18, 2)), N'/images/Tecno/tải xuống (10).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (136, N'Tecno Model 13', CAST(7400000.00 AS Decimal(18, 2)), N'/images/Tecno/tải xuống (2).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (137, N'Tecno Model 14', CAST(7800000.00 AS Decimal(18, 2)), N'/images/Tecno/tải xuống (3).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (138, N'Tecno Model 15', CAST(8200000.00 AS Decimal(18, 2)), N'/images/Tecno/tải xuống (4).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (139, N'Tecno Model 16', CAST(8600000.00 AS Decimal(18, 2)), N'/images/Tecno/tải xuống (5).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (140, N'Tecno Model 17', CAST(9000000.00 AS Decimal(18, 2)), N'/images/Tecno/tải xuống (6).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (141, N'Tecno Model 18', CAST(9400000.00 AS Decimal(18, 2)), N'/images/Tecno/tải xuống (7).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (142, N'Tecno Model 19', CAST(9800000.00 AS Decimal(18, 2)), N'/images/Tecno/tải xuống (8).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (143, N'Tecno Model 20', CAST(10200000.00 AS Decimal(18, 2)), N'/images/Tecno/tải xuống (9).jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (144, N'Tecno Model 21', CAST(10600000.00 AS Decimal(18, 2)), N'/images/Tecno/tải xuống.jpg', 7, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (145, N'Xiaomi Dien Thoai Xiaomi 17 Ultra Den', CAST(4350000.00 AS Decimal(18, 2)), N'/images/Xiaomi/dien-thoai-xiaomi-17-ultra-den.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (146, N'Xiaomi Dien Thoai Xiaomi Redmi 15C 41 1', CAST(4900000.00 AS Decimal(18, 2)), N'/images/Xiaomi/dien-thoai-xiaomi-redmi-15c-41_1.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (147, N'Xiaomi Dien Thoai Xiaomi Redmi 15C 41 1 3', CAST(5450000.00 AS Decimal(18, 2)), N'/images/Xiaomi/dien-thoai-xiaomi-redmi-15c-41_1_3.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (148, N'Xiaomi Dien Thoai Xiaomi Redmi Note 14 5G.1', CAST(6000000.00 AS Decimal(18, 2)), N'/images/Xiaomi/dien-thoai-xiaomi-redmi-note-14-5g.1.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (149, N'Xiaomi Dien Thoai Xiaomi Redmi Note 14 3 2', CAST(6550000.00 AS Decimal(18, 2)), N'/images/Xiaomi/dien-thoai-xiaomi-redmi-note-14_3__2.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (150, N'Xiaomi Dien Thoai Xiaomi Redmi Note 15 Pro 5G Vang', CAST(7100000.00 AS Decimal(18, 2)), N'/images/Xiaomi/dien-thoai-xiaomi-redmi-note-15-pro-5g-vang.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (151, N'Xiaomi Image 1262703569', CAST(7650000.00 AS Decimal(18, 2)), N'/images/Xiaomi/image_1262703569.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (152, N'Xiaomi Photo 2025 04 16 11 45 37', CAST(8200000.00 AS Decimal(18, 2)), N'/images/Xiaomi/photo_2025-04-16_11-45-37.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (153, N'Xiaomi Poco F8 Pro', CAST(8750000.00 AS Decimal(18, 2)), N'/images/Xiaomi/poco-f8-pro.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (154, N'Xiaomi Redmi Note 15 Series 1 3', CAST(9300000.00 AS Decimal(18, 2)), N'/images/Xiaomi/redmi-note-15-series-1_3.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (155, N'Xiaomi Redmi Note 15 Series 4 2', CAST(9850000.00 AS Decimal(18, 2)), N'/images/Xiaomi/redmi-note-15-series-4_2.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (156, N'Xiaomi Redmi Pad 2 9 7 Inch', CAST(10400000.00 AS Decimal(18, 2)), N'/images/Xiaomi/redmi-pad-2-9-7-inch.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (157, N'Xiaomi 17T Pro 1 4', CAST(10950000.00 AS Decimal(18, 2)), N'/images/Xiaomi/xiaomi-17t-pro-1_4.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (158, N'Xiaomi 17T 2', CAST(11500000.00 AS Decimal(18, 2)), N'/images/Xiaomi/xiaomi-17t_2.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (159, N'Xiaomi Pad Mini', CAST(12050000.00 AS Decimal(18, 2)), N'/images/Xiaomi/xiaomi-pad-mini.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (160, N'Xiaomi Redmi 15 5G 1 1', CAST(12600000.00 AS Decimal(18, 2)), N'/images/Xiaomi/xiaomi-redmi-15-5g-1_1.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (161, N'Xiaomi Redmi A7 Pro 1', CAST(13150000.00 AS Decimal(18, 2)), N'/images/Xiaomi/xiaomi-redmi-a7-pro_1.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (162, N'Xiaomi Redmi Note 14 Pro Plus', CAST(13700000.00 AS Decimal(18, 2)), N'/images/Xiaomi/xiaomi-redmi-note-14-pro-plus.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (163, N'Xiaomi Redmi Pad 2 Wifi 1', CAST(14250000.00 AS Decimal(18, 2)), N'/images/Xiaomi/xiaomi-redmi-pad-2-wifi-1.webp', 8, NULL, 100)
INSERT [dbo].[Products] ([ProductId], [Name], [Price], [ImageUrl], [CategoryId], [OriginalPrice], [Stock]) VALUES (164, N'Xiaomi Redmi 14C 5 1 1', CAST(14800000.00 AS Decimal(18, 2)), N'/images/Xiaomi/xiaomi_redmi_14c_5__1_1.webp', 8, NULL, 100)
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[ProductVariants] ON 

INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (1, 1, N'Đen', N'128GB', 15, CAST(4000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (2, 1, N'Xanh', N'128GB', 10, CAST(4000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (3, 2, N'Bạc', N'128GB', 20, CAST(4500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (4, 2, N'Đen', N'128GB', 15, CAST(4500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (5, 3, N'Xanh', N'256GB', 12, CAST(6000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (6, 3, N'Bạc', N'256GB', 8, CAST(6000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (7, 4, N'Đen', N'256GB', 14, CAST(6500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (8, 4, N'Xanh', N'256GB', 11, CAST(6500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (9, 5, N'Xanh', N'256GB', 10, CAST(7000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (10, 5, N'Đen', N'256GB', 10, CAST(7000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (11, 6, N'Trắng', N'512GB', 15, CAST(9000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (12, 6, N'Đen', N'512GB', 10, CAST(9000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (13, 7, N'Trắng', N'512GB', 8, CAST(9500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (14, 7, N'Xanh', N'512GB', 7, CAST(9500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (15, 8, N'Đen', N'256GB', 12, CAST(8500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (16, 8, N'Xanh', N'256GB', 15, CAST(8500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (17, 9, N'Cam', N'256GB', 20, CAST(9000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (18, 9, N'Đen', N'256GB', 15, CAST(9000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (19, 10, N'Xanh', N'512GB', 5, CAST(11000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (20, 10, N'Đen', N'512GB', 5, CAST(11000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (21, 11, N'Đen', N'256GB', 10, CAST(10000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (22, 11, N'Trắng', N'256GB', 10, CAST(10000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (23, 12, N'Đen', N'128GB', 15, CAST(9500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (24, 12, N'Xanh', N'128GB', 10, CAST(9500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (25, 13, N'Vàng', N'256GB', 12, CAST(11000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (26, 13, N'Hồng', N'256GB', 6, CAST(11000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (27, 14, N'Tím', N'512GB', 10, CAST(13000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (28, 15, N'Đen', N'256GB', 15, CAST(12000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (29, 15, N'Xanh', N'256GB', 12, CAST(12000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (30, 16, N'Xanh', N'256GB', 20, CAST(12500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (31, 17, N'Đen', N'64GB', 25, CAST(12000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (32, 17, N'Trắng', N'64GB', 15, CAST(12000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (33, 18, N'Đen', N'128GB', 22, CAST(12500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (34, 19, N'Đen', N'128GB', 18, CAST(13000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (35, 20, N'Nâu', N'256GB', 14, CAST(14500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (36, 21, N'Đen', N'512GB', 8, CAST(16500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (37, 21, N'Bạc', N'512GB', 7, CAST(16500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (38, 22, N'Đen', N'256GB', 11, CAST(15500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (39, 22, N'Trắng', N'256GB', 9, CAST(15500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (40, 23, N'Xám', N'256GB', 15, CAST(16000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (41, 23, N'Đen', N'256GB', 12, CAST(16000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (42, 24, N'Nâu', N'512GB', 10, CAST(18000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (43, 25, N'Đen', N'256GB', 10, CAST(6250000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (44, 25, N'Xanh', N'256GB', 8, CAST(6250000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (45, 26, N'Trắng', N'512GB', 12, CAST(8500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (46, 26, N'Đen', N'512GB', 10, CAST(8500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (47, 27, N'Bạc', N'128GB', 15, CAST(6750000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (48, 28, N'Đen', N'256GB', 11, CAST(8500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (49, 28, N'Trắng', N'256GB', 9, CAST(8500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (50, 29, N'Vàng', N'128GB', 20, CAST(8250000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (51, 30, N'Bạc', N'128GB', 14, CAST(9000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (52, 31, N'Đen', N'256GB', 12, CAST(10750000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (53, 32, N'Trắng', N'256GB', 8, CAST(11500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (54, 32, N'Đen', N'256GB', 10, CAST(11500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (55, 33, N'Đen', N'256GB', 15, CAST(12250000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (56, 34, N'Vàng', N'512GB', 6, CAST(14500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (57, 35, N'Xanh', N'128GB', 12, CAST(12750000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (58, 36, N'Đen', N'128GB', 30, CAST(13500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (59, 37, N'Bạc', N'128GB', 18, CAST(14250000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (60, 38, N'Trắng', N'256GB', 15, CAST(16000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (61, 39, N'Đen', N'256GB', 12, CAST(16750000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (62, 40, N'Xanh', N'256GB', 10, CAST(17500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (63, 41, N'Vàng', N'512GB', 8, CAST(19750000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (64, 42, N'Đen', N'512GB', 9, CAST(20500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (65, 43, N'Trắng', N'256GB', 14, CAST(19750000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (66, 44, N'Đen', N'1TB', 5, CAST(24500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (67, 44, N'Vàng', N'1TB', 3, CAST(24500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (68, 45, N'Xanh', N'256GB', 8, CAST(14500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (69, 45, N'Vàng', N'256GB', 5, CAST(14500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (70, 45, N'Xám', N'256GB', 6, CAST(14500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (71, 46, N'Xanh', N'128GB', 10, CAST(15000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (72, 46, N'Hồng', N'128GB', 12, CAST(15000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (73, 46, N'Trắng', N'128GB', 15, CAST(15000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (74, 47, N'Tím', N'128GB', 14, CAST(16500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (75, 47, N'Đỏ', N'128GB', 5, CAST(16500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (76, 47, N'Đen', N'128GB', 20, CAST(16500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (77, 48, N'Xanh', N'256GB', 8, CAST(19000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (78, 48, N'Đen', N'256GB', 10, CAST(19000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (79, 48, N'Hồng', N'256GB', 9, CAST(19000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (80, 49, N'Đen', N'128GB', 15, CAST(19500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (81, 49, N'Trắng', N'128GB', 12, CAST(19500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (82, 50, N'Xanh', N'128GB', 25, CAST(21000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (83, 50, N'Hồng', N'128GB', 15, CAST(21000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (84, 50, N'Đen', N'128GB', 30, CAST(21000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (85, 51, N'Trắng', N'128GB', 15, CAST(22500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (86, 51, N'Đen', N'128GB', 18, CAST(22500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (87, 52, N'Vàng', N'256GB', 35, CAST(25000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (88, 52, N'Xám', N'256GB', 20, CAST(25000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (89, 52, N'Trắng', N'256GB', 15, CAST(25000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (90, 53, N'Trắng', N'128GB', 20, CAST(25500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (91, 53, N'Đen', N'128GB', 25, CAST(25500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (92, 54, N'Trắng', N'256GB', 12, CAST(28000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (93, 54, N'Đen', N'256GB', 15, CAST(28000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (94, 55, N'Xanh', N'256GB', 10, CAST(29500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (95, 55, N'Đen', N'256GB', 8, CAST(29500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (96, 56, N'Vàng', N'256GB', 12, CAST(31000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (97, 56, N'Xám', N'256GB', 10, CAST(31000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (98, 57, N'Hồng', N'128GB', 15, CAST(31500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (99, 58, N'Đen', N'256GB', 18, CAST(34000000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (100, 58, N'Trắng', N'256GB', 14, CAST(34000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (101, 59, N'Xám', N'512GB', 8, CAST(37000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (102, 60, N'Bạc', N'128GB', 20, CAST(36000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (103, 61, N'Xanh', N'32GB', 50, CAST(37500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (104, 62, N'Xám', N'256GB', 12, CAST(40000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (105, 63, N'Vàng', N'512GB', 10, CAST(43000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (106, 64, N'Đen', N'512GB', 15, CAST(44500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (107, 65, N'Đen', N'128MB', 40, CAST(1500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (108, 65, N'Xanh', N'128MB', 30, CAST(1500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (109, 66, N'Bạc', N'64GB', 15, CAST(1800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (110, 67, N'Đen', N'128MB', 100, CAST(2100000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (111, 68, N'Xanh', N'128MB', 50, CAST(2400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (112, 68, N'Đen', N'128MB', 50, CAST(2400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (113, 69, N'Đen', N'128MB', 35, CAST(2700000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (114, 70, N'Xanh', N'128MB', 40, CAST(3000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (115, 71, N'Vàng', N'128MB', 60, CAST(3300000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (116, 71, N'Đen', N'128MB', 40, CAST(3300000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (117, 72, N'Xanh', N'64GB', 15, CAST(3600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (118, 73, N'Xanh', N'128GB', 20, CAST(3900000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (119, 74, N'Xám', N'16GB', 25, CAST(4200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (120, 75, N'Vàng', N'32GB', 18, CAST(4500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (121, 76, N'Đen', N'32GB', 15, CAST(4800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (122, 77, N'Xanh', N'32GB', 22, CAST(5100000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (123, 78, N'Xanh', N'128GB', 30, CAST(5400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (124, 78, N'Đen', N'128GB', 20, CAST(5400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (125, 79, N'Hồng', N'128MB', 45, CAST(5700000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (126, 80, N'Xanh', N'64GB', 12, CAST(6000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (127, 81, N'Xám', N'64GB', 18, CAST(6300000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (128, 82, N'Đen', N'32GB', 15, CAST(6600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (129, 83, N'Xanh', N'128GB', 25, CAST(6900000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (130, 84, N'Vàng', N'64GB', 10, CAST(4600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (131, 85, N'Vàng', N'64GB', 15, CAST(5200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (132, 85, N'Xanh', N'64GB', 15, CAST(5200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (133, 86, N'Xanh', N'64GB', 12, CAST(5800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (134, 87, N'Xanh', N'128GB', 20, CAST(6400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (135, 87, N'Đen', N'128GB', 15, CAST(6400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (136, 88, N'Trắng', N'128GB', 25, CAST(7000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (137, 88, N'Xanh', N'128GB', 15, CAST(7000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (138, 89, N'Trắng', N'256GB', 18, CAST(8600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (139, 89, N'Đen', N'256GB', 12, CAST(8600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (140, 90, N'Trắng', N'256GB', 14, CAST(9200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (141, 90, N'Xanh', N'256GB', 10, CAST(9200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (142, 91, N'Xám', N'256GB', 12, CAST(9800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (143, 91, N'Vàng', N'256GB', 14, CAST(9800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (144, 92, N'Xanh', N'128GB', 35, CAST(9400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (145, 92, N'Đen', N'128GB', 25, CAST(9400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (146, 93, N'Vàng', N'256GB', 15, CAST(11000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (147, 93, N'Đen', N'256GB', 15, CAST(11000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (148, 94, N'Bạc', N'256GB', 18, CAST(11600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (149, 94, N'Nâu', N'256GB', 10, CAST(11600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (150, 95, N'Xám', N'256GB', 10, CAST(12200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (151, 96, N'Vàng', N'256GB', 8, CAST(12800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (152, 96, N'Đen', N'256GB', 6, CAST(12800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (153, 97, N'Nâu', N'512GB', 5, CAST(14900000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (154, 97, N'Xanh', N'512GB', 4, CAST(14900000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (155, 98, N'Xanh', N'64GB', 20, CAST(13000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (156, 99, N'Vàng', N'128GB', 22, CAST(13600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (157, 99, N'Đen', N'128GB', 18, CAST(13600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (158, 100, N'Xanh', N'256GB', 8, CAST(15200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (159, 101, N'Vàng', N'128GB', 12, CAST(14800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (160, 102, N'Xanh', N'256GB', 20, CAST(16400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (161, 102, N'Hồng', N'256GB', 10, CAST(16400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (162, 103, N'Xanh', N'128GB', 30, CAST(16000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (163, 103, N'Đen', N'128GB', 20, CAST(16000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (164, 104, N'Đen', N'128GB', 25, CAST(5800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (165, 104, N'Xanh', N'128GB', 20, CAST(5800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (166, 105, N'Xanh', N'128GB', 15, CAST(6600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (167, 105, N'Đen', N'128GB', 15, CAST(6600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (168, 106, N'Trắng', N'128GB', 18, CAST(7400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (169, 106, N'Xám', N'128GB', 12, CAST(7400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (170, 107, N'Xám', N'256GB', 30, CAST(9200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (171, 107, N'Vàng', N'256GB', 15, CAST(9200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (172, 107, N'Tím', N'256GB', 10, CAST(9200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (173, 108, N'Xanh', N'128GB', 22, CAST(9000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (174, 108, N'Đen', N'128GB', 20, CAST(9000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (175, 109, N'Xám', N'128GB', 15, CAST(9800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (176, 109, N'Xanh', N'128GB', 15, CAST(9800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (177, 110, N'Đen', N'64GB', 40, CAST(10600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (178, 111, N'Xanh', N'128GB', 18, CAST(11400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (179, 112, N'Trắng', N'256GB', 12, CAST(13200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (180, 113, N'Đen', N'128GB', 10, CAST(13000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (181, 113, N'Trắng', N'128GB', 10, CAST(13000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (182, 114, N'Xanh', N'256GB', 15, CAST(14800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (183, 115, N'Đen', N'256GB', 20, CAST(15600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (184, 115, N'Vàng', N'256GB', 10, CAST(15600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (185, 116, N'Xám', N'256GB', 15, CAST(16400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (186, 117, N'Vàng', N'256GB', 12, CAST(17200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (187, 118, N'Đen', N'128GB', 35, CAST(17000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (188, 119, N'Trắng', N'256GB', 18, CAST(18800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (189, 120, N'Xanh', N'128GB', 14, CAST(18600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (190, 121, N'Đen', N'128GB', 25, CAST(19400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (191, 122, N'Xám', N'128GB', 20, CAST(20200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (192, 123, N'Vàng', N'512GB', 8, CAST(23500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (193, 123, N'Đen', N'512GB', 8, CAST(23500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (194, 124, N'Đen', N'64GB', 30, CAST(2600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (195, 124, N'Trắng', N'64GB', 20, CAST(2600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (196, 125, N'Xanh', N'256GB', 25, CAST(4000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (197, 125, N'Đen', N'256GB', 20, CAST(4000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (198, 126, N'Bạc', N'256GB', 15, CAST(4400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (199, 126, N'Đen', N'256GB', 15, CAST(4400000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (200, 127, N'Xanh', N'128GB', 18, CAST(3800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (201, 128, N'Đen', N'128GB', 22, CAST(4200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (202, 129, N'Trắng', N'128GB', 14, CAST(4600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (203, 130, N'Đen', N'256GB', 20, CAST(6000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (204, 131, N'Xanh', N'256GB', 15, CAST(6400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (205, 131, N'Vàng', N'256GB', 10, CAST(6400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (206, 132, N'Đen', N'256GB', 12, CAST(6800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (207, 133, N'Trắng', N'512GB', 8, CAST(8700000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (208, 134, N'Xám', N'256GB', 15, CAST(7600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (209, 135, N'Đen', N'32GB', 40, CAST(7000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (210, 136, N'Xanh', N'64GB', 30, CAST(7400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (211, 137, N'Đen', N'128GB', 25, CAST(7800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (212, 138, N'Trắng', N'128GB', 20, CAST(8200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (213, 139, N'Xanh', N'256GB', 18, CAST(9600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (214, 140, N'Đen', N'256GB', 15, CAST(10000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (215, 141, N'Vàng', N'256GB', 12, CAST(10400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (216, 142, N'Đen', N'512GB', 5, CAST(12300000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (217, 142, N'Bạc', N'512GB', 4, CAST(12300000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (218, 143, N'Đen', N'256GB', 6, CAST(11200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (219, 144, N'Trắng', N'256GB', 14, CAST(11600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (220, 145, N'Đen', N'512GB', 10, CAST(6850000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (221, 145, N'Trắng', N'512GB', 8, CAST(6850000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (222, 146, N'Đen', N'128GB', 30, CAST(4900000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (223, 146, N'Xanh', N'128GB', 25, CAST(4900000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (224, 147, N'Xám', N'128GB', 20, CAST(5450000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (225, 148, N'Trắng', N'128GB', 22, CAST(6000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (226, 148, N'Đen', N'128GB', 18, CAST(6000000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (227, 149, N'Xanh', N'256GB', 15, CAST(7550000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (228, 150, N'Vàng', N'256GB', 25, CAST(8100000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (229, 150, N'Đen', N'256GB', 15, CAST(8100000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (230, 151, N'Đen', N'128GB', 40, CAST(7650000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (231, 152, N'Xanh', N'128GB', 35, CAST(8200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (232, 153, N'Đen', N'512GB', 12, CAST(11250000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (233, 153, N'Trắng', N'512GB', 10, CAST(11250000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (234, 154, N'Đen', N'128GB', 20, CAST(9300000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (235, 155, N'Xanh', N'256GB', 18, CAST(10850000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (236, 156, N'Xám', N'128GB', 15, CAST(10400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (237, 156, N'Bạc', N'128GB', 15, CAST(10400000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (238, 157, N'Đen', N'512GB', 12, CAST(13450000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (239, 157, N'Bạc', N'512GB', 8, CAST(13450000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (240, 158, N'Xanh', N'256GB', 20, CAST(12500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (241, 158, N'Trắng', N'256GB', 15, CAST(12500000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (242, 159, N'Xám', N'64GB', 25, CAST(12050000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (243, 160, N'Đen', N'128GB', 18, CAST(12600000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (244, 161, N'Xanh', N'64GB', 30, CAST(13150000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (245, 162, N'Trắng', N'512GB', 15, CAST(16200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (246, 162, N'Đen', N'512GB', 12, CAST(16200000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (247, 163, N'Xám', N'128GB', 15, CAST(14250000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (248, 164, N'Đen', N'128GB', 25, CAST(14800000.00 AS Decimal(18, 2)))
INSERT [dbo].[ProductVariants] ([VariantId], [ProductId], [Color], [ROM], [Stock], [Price]) VALUES (249, 164, N'Xanh', N'128GB', 20, CAST(14800000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[ProductVariants] OFF
GO
SET IDENTITY_INSERT [dbo].[Promotions] ON 

INSERT [dbo].[Promotions] ([Id], [Name], [DiscountPercentage], [StartDate], [EndDate], [IsActive]) VALUES (1, N'Tết', 38, CAST(N'2026-07-16T21:56:00.0000000' AS DateTime2), CAST(N'2026-07-05T21:56:00.0000000' AS DateTime2), 1)
INSERT [dbo].[Promotions] ([Id], [Name], [DiscountPercentage], [StartDate], [EndDate], [IsActive]) VALUES (2, N'HoanThanh', 50, CAST(N'2026-07-07T20:29:00.0000000' AS DateTime2), CAST(N'2026-07-25T20:29:00.0000000' AS DateTime2), 0)
INSERT [dbo].[Promotions] ([Id], [Name], [DiscountPercentage], [StartDate], [EndDate], [IsActive]) VALUES (3, N'Lala', 100, CAST(N'2026-07-07T07:37:00.0000000' AS DateTime2), CAST(N'2026-07-12T07:37:00.0000000' AS DateTime2), 1)
SET IDENTITY_INSERT [dbo].[Promotions] OFF
GO
SET IDENTITY_INSERT [dbo].[Reviews] ON 

INSERT [dbo].[Reviews] ([ReviewId], [ProductId], [UserId], [Rating], [Comment], [CreatedAt]) VALUES (1, 2, 2, 3, N'ok', CAST(N'2026-07-07T09:47:11.1977259' AS DateTime2))
INSERT [dbo].[Reviews] ([ReviewId], [ProductId], [UserId], [Rating], [Comment], [CreatedAt]) VALUES (2, 2, 3, 5, N'quá đẳng cấp', CAST(N'2026-07-08T12:36:30.9093916' AS DateTime2))
INSERT [dbo].[Reviews] ([ReviewId], [ProductId], [UserId], [Rating], [Comment], [CreatedAt]) VALUES (3, 84, 3, 5, N'ok', CAST(N'2026-07-09T07:15:30.6252892' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Reviews] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserId], [Username], [Password], [FullName], [Email], [PhoneNumber], [Role], [IsLocked], [LoginProvider], [ProviderKey]) VALUES (1, N'admin', N'adminpassword', N'Administrator', N'admin@techstore.com', N'0123456789', N'Admin', 0, N'Local', NULL)
INSERT [dbo].[Users] ([UserId], [Username], [Password], [FullName], [Email], [PhoneNumber], [Role], [IsLocked], [LoginProvider], [ProviderKey]) VALUES (2, N'Binh', N'1234', N'Binh', N'aaa@gmail.com', N'999999999', N'Customer', 0, N'Local', NULL)
INSERT [dbo].[Users] ([UserId], [Username], [Password], [FullName], [Email], [PhoneNumber], [Role], [IsLocked], [LoginProvider], [ProviderKey]) VALUES (3, N'Thu', N'1234', N'Thụ', N'abc@gmail.com', N'092929292929', N'Customer', 0, N'Local', NULL)
INSERT [dbo].[Users] ([UserId], [Username], [Password], [FullName], [Email], [PhoneNumber], [Role], [IsLocked], [LoginProvider], [ProviderKey]) VALUES (4, N'Quang', N'3456', N'Quang', N'1111@gmail.com', N'222222222', N'Employee', 0, N'Local', NULL)
INSERT [dbo].[Users] ([UserId], [Username], [Password], [FullName], [Email], [PhoneNumber], [Role], [IsLocked], [LoginProvider], [ProviderKey]) VALUES (6, NULL, NULL, N'Bình Nguyễn', N'fb_1579933013694968@facebook.com', NULL, N'Customer', 0, N'Facebook', N'1579933013694968')
INSERT [dbo].[Users] ([UserId], [Username], [Password], [FullName], [Email], [PhoneNumber], [Role], [IsLocked], [LoginProvider], [ProviderKey]) VALUES (7, NULL, NULL, N'Nguyễn Bình', N'nb241006789@gmail.com', NULL, N'Customer', 0, N'Google', N'104090402503770399240')
INSERT [dbo].[Users] ([UserId], [Username], [Password], [FullName], [Email], [PhoneNumber], [Role], [IsLocked], [LoginProvider], [ProviderKey]) VALUES (8, N'son', N'1234', N'Sơn', N'son@gmail.com', N'099998898', N'Employee', 0, N'Local', NULL)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
/****** Object:  Index [IX_OrderDetails_OrderId]    Script Date: 7/13/2026 8:46:43 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrderDetails_OrderId] ON [dbo].[OrderDetails]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderDetails_ProductId]    Script Date: 7/13/2026 8:46:43 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrderDetails_ProductId] ON [dbo].[OrderDetails]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Orders_UserId]    Script Date: 7/13/2026 8:46:43 PM ******/
CREATE NONCLUSTERED INDEX [IX_Orders_UserId] ON [dbo].[Orders]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Products_CategoryId]    Script Date: 7/13/2026 8:46:43 PM ******/
CREATE NONCLUSTERED INDEX [IX_Products_CategoryId] ON [dbo].[Products]
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reviews_ProductId]    Script Date: 7/13/2026 8:46:43 PM ******/
CREATE NONCLUSTERED INDEX [IX_Reviews_ProductId] ON [dbo].[Reviews]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reviews_UserId]    Script Date: 7/13/2026 8:46:43 PM ******/
CREATE NONCLUSTERED INDEX [IX_Reviews_UserId] ON [dbo].[Reviews]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((100)) FOR [Stock]
GO
ALTER TABLE [dbo].[ProductVariants] ADD  DEFAULT ((10)) FOR [Stock]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ('Local') FOR [LoginProvider]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Orders_OrderId] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([OrderId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Orders_OrderId]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Products_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Products_ProductId]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Users_UserId]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Categories_CategoryId] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([CategoryId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Categories_CategoryId]
GO
ALTER TABLE [dbo].[ProductVariants]  WITH CHECK ADD  CONSTRAINT [FK_ProductVariants_ProductDetails] FOREIGN KEY([ProductId])
REFERENCES [dbo].[ProductDetails] ([ProductId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductVariants] CHECK CONSTRAINT [FK_ProductVariants_ProductDetails]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Products_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Products_ProductId]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Users_UserId]
GO
USE [master]
GO
ALTER DATABASE [TechStoreDB] SET  READ_WRITE 
GO

