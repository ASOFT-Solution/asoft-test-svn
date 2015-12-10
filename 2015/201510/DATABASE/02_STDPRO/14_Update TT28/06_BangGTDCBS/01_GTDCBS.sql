--2) Them table MToKhai
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VATinGTBS]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[VATinGTBS](
	[MaGTBS] [uniqueidentifier] NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[KyGTBS] [int] NOT NULL,
	[NamGTBS] [int] NOT NULL,
	[NgayGTBS] [smalldatetime] NOT NULL,
	[NgayKeKhai] [smalldatetime] NOT NULL,
	[ToKhaiThue] [nvarchar](128) NOT NULL,
	[MauSo] [nvarchar](128) NOT NULL,
	[DC1] [decimal](20, 6) NULL,
	[DC2] [decimal](20, 6) NULL,
	[DC3] [decimal](20, 6) NULL,
	[DC4] [decimal](20, 6) NULL,
	[KeKhai1] [decimal](20, 6) NULL,
	[KeKhai2] [decimal](20, 6) NULL,
	[KeKhai3] [decimal](20, 6) NULL,
	[KeKhai4] [decimal](20, 6) NULL,
	[ChenhLech1] [decimal](20, 6) NULL,
	[ChenhLech2] [decimal](20, 6) NULL,
	[ChenhLech3] [decimal](20, 6) NULL,
	[ChenhLech4] [decimal](20, 6) NULL,
	[ChiTieu1] [nvarchar](128) NULL,
	[ChiTieu2] [nvarchar](128) NULL,
	[ChiTieu3] [nvarchar](128) NULL,
	[ChiTieu4] [nvarchar](128) NULL,
	[TongDC] [decimal](20, 6) NULL,
	[NopCham] [int] NULL,
	[PhatNopCham] [decimal](20, 6) NULL,
	[DienGiai] [ntext] NULL,
 CONSTRAINT [PK_VATinGTBS] PRIMARY KEY CLUSTERED 
(
	[MaGTBS] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

END

GO
