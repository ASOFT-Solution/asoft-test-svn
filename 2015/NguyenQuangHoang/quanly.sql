USE [master]
GO
/****** Object:  Database [BT]    Script Date: 8/26/2015 1:08:02 PM ******/
CREATE DATABASE [BT]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BT', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\BT.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'BT_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\BT_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [BT] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BT].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BT] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BT] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BT] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BT] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BT] SET ARITHABORT OFF 
GO
ALTER DATABASE [BT] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BT] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [BT] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BT] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BT] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BT] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BT] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BT] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BT] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BT] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BT] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BT] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BT] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BT] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BT] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BT] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BT] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BT] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BT] SET RECOVERY FULL 
GO
ALTER DATABASE [BT] SET  MULTI_USER 
GO
ALTER DATABASE [BT] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BT] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BT] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BT] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [BT]
GO
/****** Object:  Table [dbo].[HoiVien]    Script Date: 8/26/2015 1:08:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HoiVien](
	[APK] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[DivisionID] [varchar](50) NOT NULL,
	[MemberID] [varchar](50) NOT NULL,
	[MemberName] [nvarchar](250) NULL,
	[ShortName] [nvarchar](250) NULL,
	[Address] [nvarchar](250) NULL,
	[Identify] [nvarchar](250) NULL,
	[Phone] [nvarchar](250) NULL,
	[Tel] [nvarchar](250) NULL,
	[Fax] [nvarchar](250) NULL,
	[Email] [nvarchar](250) NULL,
	[Birthday] [smalldatetime] NULL,
	[Website] [nvarchar](250) NULL,
	[Mailbox] [nvarchar](250) NULL,
	[AreaName] [nvarchar](250) NULL,
	[CityName] [nvarchar](250) NULL,
	[CountryName] [nvarchar](250) NULL,
	[WardName] [nvarchar](250) NULL,
	[CountyName] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [varchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [varchar](50) NULL,
	[Disable] [tinyint] NOT NULL,
 CONSTRAINT [PK_HoiVien] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[MemberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'1bc0dc2e-9405-4836-b26d-8c1a304f991f', N'AS', N'BIGC-O02-O03-002', N'Hoàng Đăng Khoa', NULL, N'30A Tạ Uyên, P.15, Q5', N'302624886', N'0902273166', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'16b5d132-8772-4f9e-8775-e549c8ae4dbc', N'AS', N'BIGC-O02-O03-O03', N'Nguyễn Kim Phong', NULL, N'9X Chu Văn An, P.12m Q.Bình Thạnh', N'302753715', N'0902349567', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'39a95526-cb16-4a4b-9e58-80dc8dd788ca', N'AS', N'BIGC-O02-O03-O04', N'Hoàng Thị Loan', NULL, N'1105 Lạc Long Quân, P.11, Q.Tân Bình', N'304061597', N'0902984651', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'4b435541-ac96-41b2-b704-0a2acb7c7c87', N'AS', N'BIGC-O02-O03-O05', N'Hoàng Thị Quỳ', NULL, N'146B Lê Hồng Phong,  P3, Q. Tân Bình', N'300151994', N'0902774168', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'3135b9dc-faab-496a-95cb-e26a2d044e8a', N'AS', N'BIGC-O02-O03-O06', N'Hoàng Văn Xuân', NULL, N'D9/262B QL50, Xã Đa Phước, Bình Chánh, Tp.HCM', N'302955648', N'0902711157', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'1f740679-7ee5-4f35-ab20-ab8922e022aa', N'AS', N'BIGC-O02-O03-O07', N'Nguyễn Đức Vinh', NULL, N'76C Tổ 3, Tân Lập 2, KP. 6, Hiệp Phú, Q.9', N'300388915', N'0902789777', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
ALTER TABLE [dbo].[HoiVien] ADD  CONSTRAINT [DF_HoiVien_APK]  DEFAULT (newid()) FOR [APK]
GO
USE [master]
GO
ALTER DATABASE [BT] SET  READ_WRITE 
GO
