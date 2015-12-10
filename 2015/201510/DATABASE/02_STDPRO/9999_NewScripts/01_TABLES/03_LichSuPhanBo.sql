/****** Object:  Table [dbo].[LSPBO]    Script Date: 03/30/2012 11:46:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LSPBO]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LSPBO](
	[LSPBOID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MaCT] [nvarchar](512) NULL,
	[MTID] [uniqueidentifier] NOT NULL,
	[SoCT] [nvarchar](512) NULL,
	[NgayCT] [smalldatetime] NOT NULL,
	[DienGiai] [nvarchar](512) NULL,
	[MaKH] [varchar](16) NULL,
	[TK] [varchar](16) NOT NULL,
	[TKDu] [varchar](16) NOT NULL,
	[PsNo] [decimal](28, 6) NULL,
	[PsCo] [decimal](28, 6) NULL,
	[NhomDk] [nvarchar](512) NOT NULL,
	[MaPhi] [varchar](16) NULL,
	[MaVV] [varchar](16) NULL,
	[PsNoNT] [decimal](28, 6) NULL,
	[PsCoNT] [decimal](28, 6) NULL,
	[MaNT] [varchar](16) NULL,
	[OngBa] [nvarchar](512) NULL,
	[MaBP] [varchar](16) NULL,
	[TyGia] [decimal](28, 6) NULL,
	[MTIDDT] [uniqueidentifier] NULL,
	[MaSP] [varchar](16) NULL,
	[MaCongTrinh] [varchar](16) NULL,
	[TenKH] [nvarchar](512) NULL,
	[SLConLai] [int] NULL,
	[SLHong] [int] NULL,
	[PhanBoDeu] [int] NULL,
	[TienHong] [decimal](28, 6) NULL,
	[TSBaoHong] [decimal](28, 6) NULL,
	[TPhanBo] [decimal](28, 6) NULL,
	[TDaPhanBo] [decimal](28, 6) NULL,
	[TConLai] [decimal](28, 6) NULL,
 CONSTRAINT [PK_LSPBOID] PRIMARY KEY CLUSTERED 
(
	[LSPBOID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
