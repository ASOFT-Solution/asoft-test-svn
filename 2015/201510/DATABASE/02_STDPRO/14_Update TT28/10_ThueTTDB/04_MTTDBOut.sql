--------------------------------------------------------------------------------------------------------------
--
-- TEST
--
--------------------------------------------------------------------------------------------------------------
--IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DTTDBOut_MTTDBOut2]') AND parent_object_id = OBJECT_ID(N'[dbo].[DTTDBOut]'))
--ALTER TABLE [dbo].[DTTDBOut] DROP CONSTRAINT [FK_DTTDBOut_MTTDBOut2]
--GO

--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DTTDBOut]') AND type in (N'U'))
--DROP TABLE [dbo].[DTTDBOut]
--GO

--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTTDBOut]') AND type in (N'U'))
--DROP TABLE [dbo].[MTTDBOut]
--GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MTTDBOut]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MTTDBOut](
	[MTTDBOutID] [uniqueidentifier] NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[KyBKBRTTDB] [int] NOT NULL,
	[NgayBKBRTTDB] [smalldatetime] NOT NULL,
	[NamBKBRTTDB] [int] NOT NULL,
 CONSTRAINT [PK_MTTDBOut] PRIMARY KEY CLUSTERED 
(
	[MTTDBOutID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DTTDBOut]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DTTDBOut](
	[DTTDBOutID] [uniqueidentifier] NOT NULL,
	[MTTDBOutID] [uniqueidentifier] NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[NgayHD] [smalldatetime] NULL,
	[NgayCt] [smalldatetime] NULL,
	[SoHoaDon] [nvarchar](128) NULL,
	[SoSeries] [nvarchar](128) NULL,
	[TenKH] [nvarchar](128) NULL,
	[TenVT] [nvarchar](128) NULL,
	[SoLuong] [decimal](20, 6) NULL,
	[GiaNT] [decimal](20, 6) NULL,
	[Gia] [decimal](20, 6) NULL,	
	[PsNT] [decimal](20, 6) NULL,
	[Ps] [decimal](20, 6) NULL,
	[MaNhomTTDB] [varchar](16) NULL,
	[ThueSuatTTDB] [decimal](20, 6) NULL,
	[TienTTDBNT] [decimal](20, 6) NULL,
	[TienTTDB] [decimal](20, 6) NULL,
	[Ps1NT] [decimal](20, 6) NULL,
	[Ps1] [decimal](20, 6) NULL,
 CONSTRAINT [PK_DTTDBOut] PRIMARY KEY CLUSTERED 
(
	[DTTDBOutID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DTTDBOut]  WITH CHECK ADD  CONSTRAINT [FK_DTTDBOut_MTTDBOut] FOREIGN KEY([MTTDBOutID])
REFERENCES [dbo].[MTTDBOut] ([MTTDBOutID])
ALTER TABLE [dbo].[DTTDBOut] CHECK CONSTRAINT [FK_DTTDBOut_MTTDBOut]

ALTER TABLE [dbo].[DTTDBOut]  WITH CHECK ADD  CONSTRAINT [FK_DTTDBOut_DMThueTTDB] FOREIGN KEY([MaNhomTTDB])
REFERENCES [dbo].[DMThueTTDB] ([MaNhomTTDB])
ALTER TABLE [dbo].[DTTDBOut] CHECK CONSTRAINT [FK_DTTDBOut_DMThueTTDB]

ALTER TABLE [dbo].[DTTDBOut] ADD  CONSTRAINT [DF_DTTDBOut_SoLuong]  DEFAULT ('0') FOR [SoLuong]

ALTER TABLE [dbo].[DTTDBOut] ADD  CONSTRAINT [DF_DTTDBOut_GiaNT]  DEFAULT ('0') FOR [GiaNT]

ALTER TABLE [dbo].[DTTDBOut] ADD  CONSTRAINT [DF_DTTDBOut_Gia]  DEFAULT ('0') FOR [Gia]

ALTER TABLE [dbo].[DTTDBOut] ADD  CONSTRAINT [DF_DTTDBOut_PsNT]  DEFAULT ('0') FOR [PsNT]

ALTER TABLE [dbo].[DTTDBOut] ADD  CONSTRAINT [DF_DTTDBOut_Ps]  DEFAULT ('0') FOR [Ps]

ALTER TABLE [dbo].[DTTDBOut] ADD  CONSTRAINT [DF_DTTDBOut_ThueSuatTTDB]  DEFAULT ('0') FOR [ThueSuatTTDB]

ALTER TABLE [dbo].[DTTDBOut] ADD  CONSTRAINT [DF_DTTDBOut_TienTTDBNT]  DEFAULT ('0') FOR [TienTTDBNT]

ALTER TABLE [dbo].[DTTDBOut] ADD  CONSTRAINT [DF_DTTDBOut_TienTTDB]  DEFAULT ('0') FOR [TienTTDB]

ALTER TABLE [dbo].[DTTDBOut] ADD  CONSTRAINT [DF_DTTDBOut_Ps1]  DEFAULT ('0') FOR [Ps1]

ALTER TABLE [dbo].[DTTDBOut] ADD  CONSTRAINT [DF_DTTDBOut_Ps1NT]  DEFAULT ('0') FOR [Ps1NT]

END