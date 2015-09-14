USE [master]
GO
/****** Object:  Database [QuanTriNhanLuc]    Script Date: 9/14/2015 4:20:44 PM ******/
CREATE DATABASE [QuanTriNhanLuc]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QuanTriNhanLuc', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER2012\MSSQL\DATA\QuanTriNhanLuc.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QuanTriNhanLuc_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER2012\MSSQL\DATA\QuanTriNhanLuc_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QuanTriNhanLuc] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuanTriNhanLuc].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuanTriNhanLuc] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [QuanTriNhanLuc] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuanTriNhanLuc] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuanTriNhanLuc] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QuanTriNhanLuc] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuanTriNhanLuc] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET RECOVERY FULL 
GO
ALTER DATABASE [QuanTriNhanLuc] SET  MULTI_USER 
GO
ALTER DATABASE [QuanTriNhanLuc] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuanTriNhanLuc] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QuanTriNhanLuc] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QuanTriNhanLuc] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'QuanTriNhanLuc', N'ON'
GO
USE [QuanTriNhanLuc]
GO
/****** Object:  Table [dbo].[HoiVien]    Script Date: 9/14/2015 4:20:45 PM ******/
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
/****** Object:  Table [dbo].[MenuDaCap]    Script Date: 9/14/2015 4:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuDaCap](
	[MaMenu] [int] IDENTITY(1,1) NOT NULL,
	[Ten] [nvarchar](50) NULL,
	[MaParent] [int] NULL,
 CONSTRAINT [PK_MenuDaCap] PRIMARY KEY CLUSTERED 
(
	[MaMenu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'47ccce3d-7228-4d27-8763-74b27c6a356e', N'a', N'm', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'007b4f11-46db-4798-b05d-4d937a77dbf1', N'a', N'z', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'8245bdbe-30e7-4d18-8c8d-71b429b73ad0', N'a1', N'a1', N'Nguyễn Thiện', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'cb6ba064-01fe-4f86-b67e-c825d25a0edc', N'a2', N'a2', N'thiện', NULL, N'mạng thiện', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'9960db3f-7a17-426b-82cb-a3735002ec00', N'A5', N'BIGC-002-003-008', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'b53c1c1e-7a33-45b7-b19e-55270e476c21', N'A5', N'BIGC-002-003-009', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'9090098d-c5eb-436b-ac8d-ae87c39fbd54', N'A6', N'a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'0756b5b7-ebfc-45e3-85bc-8c41c9f9922f', N'A6', N'A6', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'1a0f6353-75ca-43f7-acb3-57b993c96304', N'A6', N'Bic', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'a78761d0-1ef2-4fc9-82f7-d0f464015b66', N'A6', N'Bic1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'547700c0-0592-4cbc-9225-b4d4b83b6bf9', N'as', N'as1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'e1960e05-f763-41c5-b7cf-99471d9c4f7b', N'as', N'as2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'18c5d11a-37ea-496a-b29e-b67453c33dc3', N'as', N'as3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'70a5bd38-ea47-4c21-b7e7-80d1f19cf9ec', N'as', N'as4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'31b2196b-e2c0-4f0b-aa24-e0c00e41c6a9', N'as', N'as5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'87d6609e-9165-4ba4-add2-eac3e9e3ee4a', N'AS', N'BIG-O02-O03-001', N'Bùi Tuấn Kiệt', NULL, N'277 B Cách Mạng Tháng 8, P12, Q10', N'302746186', N'0902789165', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'1bc0dc2e-9405-4836-b26d-8c1a304f991f', N'AS', N'BIGC-O02-O03-002', N'Hoàng Đăng Khoa', NULL, N'30A Tạ Uyên, P.15, Q5', N'302624886', N'0902273166', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'16b5d132-8772-4f9e-8775-e549c8ae4dbc', N'AS', N'BIGC-O02-O03-O03', N'Nguyễn Kim Phong', NULL, N'9X Chu Văn An, P.12m Q.Bình Thạnh', N'302753715', N'0902349567', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'39a95526-cb16-4a4b-9e58-80dc8dd788ca', N'AS', N'BIGC-O02-O03-O04', N'Hoàng Thị Loan', NULL, N'1105 Lạc Long Quân, P.11, Q.Tân Bình', N'304061597', N'0902984651', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'4b435541-ac96-41b2-b704-0a2acb7c7c87', N'AS', N'BIGC-O02-O03-O05', N'Hoàng Thị Quỳ', NULL, N'146B Lê Hồng Phong,  P3, Q. Tân Bình', N'300151994', N'0902774168', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'3135b9dc-faab-496a-95cb-e26a2d044e8a', N'AS', N'BIGC-O02-O03-O06', N'Hoàng Văn Xuân', NULL, N'D9/262B QL50, Xã Đa Phước, Bình Chánh, Tp.HCM', N'302955648', N'0902711157', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'1f740679-7ee5-4f35-ab20-ab8922e022aa', N'AS', N'BIGC-O02-O03-O07', N'Nguyễn Đức Vinh', NULL, N'76C Tổ 3, Tân Lập 2, KP. 6, Hiệp Phú, Q.9', N'300388915', N'0902789777', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'a8ad04d1-17d4-4881-a7f7-60347a6e63b5', N'b', N'b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'd5d78dbb-d925-4b0d-a716-aaedf6125213', N'b', N'c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'c6b88701-2959-42f8-9df4-bbf772f9d60c', N'd', N'd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'6cc05096-2e15-4f1b-9aac-e8af5864f6da', N'f', N'f', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'43e74ecc-4f05-4855-a30b-2f506b68a322', N'g', N'g', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'18e51641-97e1-4dc2-9731-4938c681ff9c', N'gg', N'hh', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'2563fc7d-a47e-46a8-a42a-d79e087efc4c', N'q', N'q', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'4b771332-34d0-4a73-9862-584d5e14e261', N'r', N'r', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'e1f50e59-0345-4a42-b59f-a186c5b2e4bf', N's', N'a9', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'd5aace75-9892-413f-b214-c062bd971481', N's', N'q', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[HoiVien] ([APK], [DivisionID], [MemberID], [MemberName], [ShortName], [Address], [Identify], [Phone], [Tel], [Fax], [Email], [Birthday], [Website], [Mailbox], [AreaName], [CityName], [CountryName], [WardName], [CountyName], [CreateDate], [CreateUserID], [LastModifyDate], [LastModifyUserID], [Disable]) VALUES (N'a04dfa5b-6e5c-4dcb-9eb6-fb1dfb6e8a99', N'sss', N'dd', NULL, N'dd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[MenuDaCap] ON 

INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (1, N'Thông tin điều hành', NULL)
INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (2, N'POS', NULL)
INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (3, N'CRM', NULL)
INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (4, N'QLHV', NULL)
INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (5, N'Thiết lập', 2)
INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (6, N'Danh mục', 2)
INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (7, N'Nghiệp vụ', 2)
INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (8, N'Báo cáo', 2)
INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (9, N'Danh mục cửa hàng', 6)
INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (10, N'Danh mục hàng hóa', 6)
INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (11, N'Danh mục hội viên', 6)
INSERT [dbo].[MenuDaCap] ([MaMenu], [Ten], [MaParent]) VALUES (12, N'Danh mục hình thức thanh toán', 6)
SET IDENTITY_INSERT [dbo].[MenuDaCap] OFF
ALTER TABLE [dbo].[HoiVien] ADD  CONSTRAINT [DF_HoiVien_APK]  DEFAULT (newid()) FOR [APK]
GO
USE [master]
GO
ALTER DATABASE [QuanTriNhanLuc] SET  READ_WRITE 
GO
