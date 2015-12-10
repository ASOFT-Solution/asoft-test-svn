--2) Them table MVATOut
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MVATOut]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[MVATOut](
	[MVATOutID] [uniqueidentifier] NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[KyBKBR] [int] NOT NULL,
	[NamBKBR] [int] NOT NULL,
	[NgayBKBR] [smalldatetime] NOT NULL,
	[ToTalTTien] [decimal](20, 6) NULL,
	[ToTalThue] [decimal](20, 6) NULL,
	[ToTalTTienNT] [decimal](20, 6) NULL,
	[ToTalThueNT] [decimal](20, 6) NULL
 CONSTRAINT [PK_MVATOut] PRIMARY KEY CLUSTERED 
(
	[MVATOutID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MVATOut] ADD  CONSTRAINT [DF_MVATOut_ToTalTTien]  DEFAULT ('0') FOR [ToTalTTien]

ALTER TABLE [dbo].[MVATOut] ADD  CONSTRAINT [DF_MVATOut_ToTalThue]  DEFAULT ('0') FOR [ToTalThue]

ALTER TABLE [dbo].[MVATOut] ADD  CONSTRAINT [DF_MVATOut_ToTalTTienNT]  DEFAULT ('0') FOR [ToTalTTienNT]

ALTER TABLE [dbo].[MVATOut] ADD  CONSTRAINT [DF_MVATOut_ToTalThueNT]  DEFAULT ('0') FOR [ToTalThueNT]

END

GO

--2) Them table DVATOut
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DVATOut]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DVATOut](
	[DVATOutID] [uniqueidentifier] NOT NULL,
	[MVATOutID] [uniqueidentifier] NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[MaLoaiHD] [varchar](16) NOT NULL,
	[NgayHd] [smalldatetime] NOT NULL,
	[NgayCt] [smalldatetime] NOT NULL,
	[Sohoadon] [nvarchar](128) NOT NULL,
	[SoSeries] [nvarchar](128) NULL,
	[TenKH] [nvarchar](128) NULL,
	[MST] [nvarchar](128) NULL,
	[DienGiai] [nvarchar](128) NULL,
	[TTien] [decimal](20, 6) NOT NULL,
	[MaThue] [varchar](16) NULL,
	[ThueSuat] [decimal](20, 6) NULL,
	[Thue] [decimal](20, 6) NOT NULL,
	[GhiChu] [nvarchar](128) NULL,
	[TTienNT] [decimal](20, 6) NOT NULL,
	[ThueNT] [decimal](20, 6) NOT NULL,
	[MaKH] [varchar](16) NOT NULL
 CONSTRAINT [PK_DVATOut] PRIMARY KEY CLUSTERED 
(
	[DVATOutID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[DVATOut]  WITH CHECK ADD  CONSTRAINT [FK_DVATOut_DMLHD4] FOREIGN KEY([MaLoaiHD])
REFERENCES [dbo].[DMLHD] ([MaLoaiHD])

ALTER TABLE [dbo].[DVATOut] CHECK CONSTRAINT [FK_DVATOut_DMLHD4]

ALTER TABLE [dbo].[DVATOut]  WITH CHECK ADD  CONSTRAINT [FK_DVATOut_DMThueSuat13] FOREIGN KEY([MaThue])
REFERENCES [dbo].[DMThueSuat] ([MaThue])

ALTER TABLE [dbo].[DVATOut] CHECK CONSTRAINT [FK_DVATOut_DMThueSuat13]

ALTER TABLE [dbo].[DVATOut]  WITH CHECK ADD  CONSTRAINT [FK_DVATOut_DMKH] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])

ALTER TABLE [dbo].[DVATOut] CHECK CONSTRAINT [FK_DVATOut_DMKH]

ALTER TABLE [dbo].[DVATOut]  WITH CHECK ADD  CONSTRAINT [FK_DVATOut_MVATOut2] FOREIGN KEY([MVATOutID])
REFERENCES [dbo].[MVATOut] ([MVATOutID])

ALTER TABLE [dbo].[DVATOut] CHECK CONSTRAINT [FK_DVATOut_MVATOut2]

ALTER TABLE [dbo].[DVATOut] ADD  CONSTRAINT [DF_DVATOut_TTien]  DEFAULT ('0') FOR [TTien]

ALTER TABLE [dbo].[DVATOut] ADD  CONSTRAINT [DF_DVATOut_ThueSuat]  DEFAULT ('0') FOR [ThueSuat]

ALTER TABLE [dbo].[DVATOut] ADD  CONSTRAINT [DF_DVATOut_Thue]  DEFAULT ('0') FOR [Thue]

ALTER TABLE [dbo].[DVATOut] ADD  CONSTRAINT [DF_DVATOut_TTienNT]  DEFAULT ('0') FOR [TTienNT]

ALTER TABLE [dbo].[DVATOut] ADD  CONSTRAINT [DF_DVATOut_ThueNT]  DEFAULT ('0') FOR [ThueNT]

END
