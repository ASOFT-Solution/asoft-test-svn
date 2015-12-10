--------------------------------------------------------------------------------------------------------------------------------------------
--
-- MT36
--
--------------------------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT36]') AND type in (N'U'))
CREATE TABLE [dbo].[MT36](
	[MT36ID] [uniqueidentifier] NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[MaCt] [nvarchar](128) NULL,
	[SoCt] [nvarchar](128) NOT NULL,
	[MaKH] [varchar](16) NULL,
	[TenKH] [nvarchar](128) NULL,
	[DienGiai] [nvarchar](128) NOT NULL,
	[MaNT] [varchar](16) NULL,
	[TyGia] [decimal](20, 6) NULL,
	[TotalPs] [decimal](20, 6) NOT NULL,
	[TotalPsNT] [decimal](20, 6) NULL,
	[MaLCTThue] [int] NOT NULL,
	[NgayCt] [smalldatetime] NOT NULL,
	[KyKTT] [int] NULL,
	[TThueBKMV] [decimal](20, 6) NULL,
	[TThueBKBR] [decimal](20, 6) NULL,
	[TThueBKMVNT] [decimal](20, 6) NULL,
	[TThueBKBRNT] [decimal](20, 6) NULL,
	[TThueKyTruoc] [decimal](20, 6) NULL,
	[TThueKyTruocNT] [decimal](20, 6) NULL,
 CONSTRAINT [PK_MT36] PRIMARY KEY CLUSTERED 
(
	[MT36ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MT36_DMKH4]') AND parent_object_id = OBJECT_ID(N'[dbo].[MT36]'))
ALTER TABLE [dbo].[MT36] WITH CHECK ADD CONSTRAINT [FK_MT36_DMKH4] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MT36_DMLCTThue11]') AND parent_object_id = OBJECT_ID(N'[dbo].[MT36]'))
ALTER TABLE [dbo].[MT36] WITH CHECK ADD CONSTRAINT [FK_MT36_DMLCTThue11] FOREIGN KEY([MaLCTThue])
REFERENCES [dbo].[DMLCTThue] ([MaLCTThue])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MT36_DMNT7]') AND parent_object_id = OBJECT_ID(N'[dbo].[MT36]'))
ALTER TABLE [dbo].[MT36] WITH CHECK ADD CONSTRAINT [FK_MT36_DMNT7] FOREIGN KEY([MaNT])
REFERENCES [dbo].[DMNT] ([MaNT])
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT36_MaNT]') AND type = 'D')
ALTER TABLE [dbo].[MT36] ADD CONSTRAINT [DF_MT36_MaNT] DEFAULT ('VND') FOR [MaNT]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT36_TotalPs]') AND type = 'D')
ALTER TABLE [dbo].[MT36] ADD CONSTRAINT [DF_MT36_TotalPs] DEFAULT ('0') FOR [TotalPs]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT36_TotalPsNT]') AND type = 'D')
ALTER TABLE [dbo].[MT36] ADD CONSTRAINT [DF_MT36_TotalPsNT] DEFAULT ('0') FOR [TotalPsNT]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT36_TThueBKMV]') AND type = 'D')
ALTER TABLE [dbo].[MT36] ADD CONSTRAINT [DF_MT36_TThueBKMV] DEFAULT ('0') FOR [TThueBKMV]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT36_TThueBKBR]') AND type = 'D')
ALTER TABLE [dbo].[MT36] ADD CONSTRAINT [DF_MT36_TThueBKBR] DEFAULT ('0') FOR [TThueBKBR]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT36_TThueBKMVNT]') AND type = 'D')
ALTER TABLE [dbo].[MT36] ADD CONSTRAINT [DF_MT36_TThueBKMVNT] DEFAULT ('0') FOR [TThueBKMVNT]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT36_TThueBKBRNT]') AND type = 'D')
ALTER TABLE [dbo].[MT36] ADD CONSTRAINT [DF_MT36_TThueBKBRNT] DEFAULT ('0') FOR [TThueBKBRNT]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT36_TThueKyTruoc]') AND type = 'D')
ALTER TABLE [dbo].[MT36] ADD CONSTRAINT [DF_MT36_TThueKyTruoc] DEFAULT ('0') FOR [TThueKyTruoc]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT36_TThueKyTruocNT]') AND type = 'D')
ALTER TABLE [dbo].[MT36] ADD CONSTRAINT [DF_MT36_TThueKyTruocNT] DEFAULT ('0') FOR [TThueKyTruocNT]


--------------------------------------------------------------------------------------------------------------------------------------------
--
-- DT36
--
--------------------------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DT36]') AND type in (N'U'))
 CREATE TABLE [dbo].[DT36](
	 [DT36ID] [uniqueidentifier] NOT NULL,
	 [MT36ID] [uniqueidentifier] NOT NULL,
	 [Stt] [int] IDENTITY(1,1) NOT NULL,
	 [TK] [varchar](16) NULL,
	 [TKDU] [varchar](16) NULL,
	 [Ps] [decimal](20, 6) NULL,
	 [PsNT] [decimal](20, 6) NOT NULL,
	 [DienGiai] [nvarchar](128) NOT NULL,
	 [MaKH] [varchar](16) NULL,
	 [TenKH] [nvarchar](128) NULL,
	 [MaVV] [varchar](16) NULL,
	 [MaPhi] [varchar](16) NULL,
	 [MaBP] [varchar](16) NULL,
	 [MaSP] [varchar](16) NULL,
	 [MaCongTrinh] [varchar](16) NULL,
 CONSTRAINT [PK_DT36] PRIMARY KEY CLUSTERED 
 (
	 [DT36ID] ASC
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 ) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DT36_DMKH4]') AND parent_object_id = OBJECT_ID(N'[dbo].[DT36]'))
ALTER TABLE [dbo].[DT36] WITH CHECK ADD CONSTRAINT [FK_DT36_DMKH4] FOREIGN KEY([MaKH])
REFERENCES [dbo].[DMKH] ([MaKH])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DT36_DMBoPhan12]') AND parent_object_id = OBJECT_ID(N'[dbo].[DT36]'))
ALTER TABLE [dbo].[DT36] WITH CHECK ADD CONSTRAINT [FK_DT36_DMBoPhan12] FOREIGN KEY([MaBP])
REFERENCES [dbo].[DMBoPhan] ([MaBP])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DT36_dmCongtrinh14]') AND parent_object_id = OBJECT_ID(N'[dbo].[DT36]'))
ALTER TABLE [dbo].[DT36] WITH CHECK ADD CONSTRAINT [FK_DT36_dmCongtrinh14] FOREIGN KEY([MaCongTrinh])
REFERENCES [dbo].[DMCONGTRINH] ([MaCongTrinh])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DT36_DMPhi11]') AND parent_object_id = OBJECT_ID(N'[dbo].[DT36]'))
ALTER TABLE [dbo].[DT36] WITH CHECK ADD CONSTRAINT [FK_DT36_DMPhi11] FOREIGN KEY([MaPhi])
REFERENCES [dbo].[DMPhi] ([MaPhi])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DT36_DMTK3]') AND parent_object_id = OBJECT_ID(N'[dbo].[DT36]'))
ALTER TABLE [dbo].[DT36] WITH CHECK ADD CONSTRAINT [FK_DT36_DMTK3] FOREIGN KEY([TK])
REFERENCES [dbo].[DMTK] ([TK])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DT36_DMTK4]') AND parent_object_id = OBJECT_ID(N'[dbo].[DT36]'))
ALTER TABLE [dbo].[DT36] WITH CHECK ADD CONSTRAINT [FK_DT36_DMTK4] FOREIGN KEY([TKDU])
REFERENCES [dbo].[DMTK] ([TK])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DT36_DMVT13]') AND parent_object_id = OBJECT_ID(N'[dbo].[DT36]'))
ALTER TABLE [dbo].[DT36] WITH CHECK ADD CONSTRAINT [FK_DT36_DMVT13] FOREIGN KEY([MaSP])
REFERENCES [dbo].[DMVT] ([MaVT])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DT36_DMVuViec10]') AND parent_object_id = OBJECT_ID(N'[dbo].[DT36]'))
ALTER TABLE [dbo].[DT36] WITH CHECK ADD CONSTRAINT [FK_DT36_DMVuViec10] FOREIGN KEY([MaVV])
REFERENCES [dbo].[DMVuViec] ([MaVV])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DT36_MT362]') AND parent_object_id = OBJECT_ID(N'[dbo].[DT36]'))
ALTER TABLE [dbo].[DT36] WITH CHECK ADD CONSTRAINT [FK_DT36_MT362] FOREIGN KEY([MT36ID])
REFERENCES [dbo].[MT36] ([MT36ID])
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DT36_Ps]') AND type = 'D')
ALTER TABLE [dbo].[DT36] ADD CONSTRAINT [DF_DT36_Ps] DEFAULT ('0') FOR [Ps]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DT36_PsNT]') AND type = 'D')
ALTER TABLE [dbo].[DT36] ADD CONSTRAINT [DF_DT36_PsNT] DEFAULT ('0') FOR [PsNT]