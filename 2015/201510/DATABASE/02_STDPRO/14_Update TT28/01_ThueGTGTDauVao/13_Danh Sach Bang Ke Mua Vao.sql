--2) Them table MVATIn
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MVATIn]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[MVATIn](
	[MVATInID] [uniqueidentifier] NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[KyBKMV] [int] NOT NULL,
	[NamBKMV] [int] NOT NULL,
	[NgayBKMV] [smalldatetime] NOT NULL,
	[ToTalTTien] [decimal](20, 6) NULL,
	[ToTalThue] [decimal](20, 6) NULL,
	[ToTalTTienNT] [decimal](20, 6) NULL,
	[ToTalThueNT] [decimal](20, 6) NULL
 CONSTRAINT [PK_MVATIn] PRIMARY KEY CLUSTERED 
(
	[MVATInID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MVATIn] ADD  CONSTRAINT [DF_MVATIn_ToTalTTien]  DEFAULT ('0') FOR [ToTalTTien]

ALTER TABLE [dbo].[MVATIn] ADD  CONSTRAINT [DF_MVATIn_ToTalThue]  DEFAULT ('0') FOR [ToTalThue]

ALTER TABLE [dbo].[MVATIn] ADD  CONSTRAINT [DF_MVATIn_ToTalTTienNT]  DEFAULT ('0') FOR [ToTalTTienNT]

ALTER TABLE [dbo].[MVATIn] ADD  CONSTRAINT [DF_MVATIn_ToTalThueNT]  DEFAULT ('0') FOR [ToTalThueNT]

END

GO

--2) Them table DVATIn
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DVatIn]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DVatIn](
	[DVATInID] [uniqueidentifier] NOT NULL,
	[MVATInID] [uniqueidentifier] NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[MaLoaiThue] [int] NOT NULL,
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
 CONSTRAINT [PK_DVatIn] PRIMARY KEY CLUSTERED 
(
	[DVATInID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[DVatIn]  WITH CHECK ADD  CONSTRAINT [FK_DVatIn_DMLHD4] FOREIGN KEY([MaLoaiHD])
REFERENCES [dbo].[DMLHD] ([MaLoaiHD])

ALTER TABLE [dbo].[DVatIn] CHECK CONSTRAINT [FK_DVatIn_DMLHD4]

ALTER TABLE [dbo].[DVatIn]  WITH CHECK ADD  CONSTRAINT [FK_DVatIn_DMLThue3] FOREIGN KEY([MaLoaiThue])
REFERENCES [dbo].[DMLThue] ([MaLoaiThue])

ALTER TABLE [dbo].[DVatIn] CHECK CONSTRAINT [FK_DVatIn_DMLThue3]

ALTER TABLE [dbo].[DVatIn]  WITH CHECK ADD  CONSTRAINT [FK_DVatIn_DMThueSuat13] FOREIGN KEY([MaThue])
REFERENCES [dbo].[DMThueSuat] ([MaThue])

ALTER TABLE [dbo].[DVatIn] CHECK CONSTRAINT [FK_DVatIn_DMThueSuat13]

ALTER TABLE [dbo].[DVatIn]  WITH CHECK ADD  CONSTRAINT [FK_DVatIn_DMKH] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])

ALTER TABLE [dbo].[DVatIn] CHECK CONSTRAINT [FK_DVatIn_DMKH]

ALTER TABLE [dbo].[DVatIn]  WITH CHECK ADD  CONSTRAINT [FK_DVatIn_MVATIn2] FOREIGN KEY([MVATInID])
REFERENCES [dbo].[MVATIn] ([MVATInID])

ALTER TABLE [dbo].[DVatIn] CHECK CONSTRAINT [FK_DVatIn_MVATIn2]

ALTER TABLE [dbo].[DVatIn] ADD  CONSTRAINT [DF_DVatIn_TTien]  DEFAULT ('0') FOR [TTien]

ALTER TABLE [dbo].[DVatIn] ADD  CONSTRAINT [DF_DVatIn_ThueSuat]  DEFAULT ('0') FOR [ThueSuat]

ALTER TABLE [dbo].[DVatIn] ADD  CONSTRAINT [DF_DVatIn_Thue]  DEFAULT ('0') FOR [Thue]

ALTER TABLE [dbo].[DVatIn] ADD  CONSTRAINT [DF_DVatIn_TTienNT]  DEFAULT ('0') FOR [TTienNT]

ALTER TABLE [dbo].[DVatIn] ADD  CONSTRAINT [DF_DVatIn_ThueNT]  DEFAULT ('0') FOR [ThueNT]

END
