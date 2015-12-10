--------------------------------------------------------------------------------------------------------------
--
-- TEST
--
--------------------------------------------------------------------------------------------------------------
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DToKhaiTTDB]') AND type in (N'U'))
--DROP TABLE [dbo].[DToKhaiTTDB]
--GO

--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MToKhaiTTDB]') AND type in (N'U'))
--DROP TABLE [dbo].[MToKhaiTTDB]
--GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MToKhaiTTDB]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MToKhaiTTDB](
	[MToKhaiTTDBID] [uniqueidentifier] NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[KyToKhaiTTDB] [int] NOT NULL,
	[NgayToKhaiTTDB] [smalldatetime] NOT NULL,
	[NamToKhaiTTDB] [int] NOT NULL,
	[DienGiai] [nvarchar](128) NULL,
	[InLanDau] [bit] NULL,
	[SoLanIn] [int] NULL,
 CONSTRAINT [PK_MToKhaiTTDB] PRIMARY KEY CLUSTERED 
(
	[MToKhaiTTDBID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DToKhaiTTDB]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DToKhaiTTDB](
	[DToKhaiTTDBID] [uniqueidentifier] NOT NULL,
	[MToKhaiTTDBID] [uniqueidentifier] NOT NULL,
	[Code] [nvarchar](128) NOT NULL,
	[Stt] [nvarchar](128) NOT NULL,
	[MaNhomTTDB] [varchar](16) NULL,
	[TenNhomTTDB] [nvarchar](128) NULL,
	[MaDVT] [nvarchar](128) NULL,
	[SoLuong] [decimal](20, 6) NULL,
	[Ps] [decimal](20, 6) NULL,
	[Ps1] [decimal](20, 6) NULL,
	[ThueSuat] [decimal](20, 6) NULL,
	[Ps2] [decimal](20, 6) NULL,
	[Ps3] [decimal](20, 6) NULL,
 CONSTRAINT [PK_DToKhaiTTDB] PRIMARY KEY CLUSTERED 
(
	[DToKhaiTTDBID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ToKhaiTTDB]') AND type in (N'U'))
DROP TABLE [dbo].[ToKhaiTTDB]

CREATE TABLE [dbo].[ToKhaiTTDB](
	[Code] [nvarchar](128) NOT NULL,
	[Stt] [nvarchar](128) NOT NULL,
	[MaNhomTTDB] [varchar](16) NULL,
	[TenNhomTTDB] [nvarchar](128) NULL,
	[MaDVT] [nvarchar](128) NULL,
	[SoLuong] [decimal](20, 6) NULL,
	[Ps] [decimal](20, 6) NULL,
	[Ps1] [decimal](20, 6) NULL,
	[ThueSuat] [decimal](20, 6) NULL,
	[Ps2] [decimal](20, 6) NULL,
	[Ps3] [decimal](20, 6) NULL,
)

INSERT INTO [dbo].[ToKhaiTTDB]([Code], [Stt], [MaNhomTTDB], [TenNhomTTDB], [MaDVT], [SoLuong], [Ps], [Ps1], [ThueSuat], [Ps2], [Ps3])
          SELECT N'000000', N'', NULL, N'Không phát sinh giá trị tính thuế TTĐB trong kỳ này', NULL, NULL, NULL, NULL, NULL, NULL, NULL
UNION ALL SELECT N'010000', N'I', NULL, N'Hàng hoá chịu thuế TTĐB', NULL, NULL, NULL, NULL, NULL, NULL, NULL
UNION ALL SELECT N'020000', N'II', NULL, N'Dịch vụ chịu thuế TTĐB', NULL, NULL, NULL, NULL, NULL, NULL, NULL
UNION ALL SELECT N'030000', N'III', NULL, N'Hàng hoá thuộc trường hợp không phải chịu thuế TTĐB', NULL, NULL, NULL, NULL, NULL, NULL, NULL
UNION ALL SELECT N'030100', N'A', NULL, N'Hàng hoá xuất khẩu', NULL, NULL, NULL, NULL, NULL, NULL, NULL
UNION ALL SELECT N'030200', N'B', NULL, N'Hàng hoá bán để xuất khẩu', NULL, NULL, NULL, NULL, NULL, NULL, NULL
UNION ALL SELECT N'030300', N'C', NULL, N'Hàng hoá gia công để xuất khẩu', NULL, NULL, NULL, NULL, NULL, NULL, NULL
UNION ALL SELECT N'990000', N'', NULL, N'Tổng cộng', NULL, NULL, NULL, NULL, NULL, NULL, NULL
