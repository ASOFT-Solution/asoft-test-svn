-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT8000]') AND type in (N'U'))
CREATE TABLE [dbo].[AT8000](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[SectionID] [nvarchar](50) NOT NULL,
	[IsShow] [tinyint] NOT NULL,
	[Section] [nvarchar](250) NULL,
	[FontDetail] [nvarchar](250) NULL,
	[FontName] [nvarchar](250) NOT NULL,
	[FontSize] [tinyint] NOT NULL,
	[FontType] [nvarchar](250) NOT NULL,
	[Content] [nvarchar](250) NULL,
	[Alignment] [tinyint] NOT NULL,
	[IsLock] [tinyint] NOT NULL,
	[IsHide] [tinyint] NOT NULL,
	[PrintGridLine] [tinyint] NOT NULL,
	[TopMargin] [float] NOT NULL,
	[BottomMargin] [float] NOT NULL,
	[LeftMargin] [float] NOT NULL,
	[RightMargin] [float] NOT NULL,
	[Path] [nvarchar](250) NULL,
CONSTRAINT [PK_AT8000] PRIMARY KEY NONCLUSTERED 
(
	[SectionID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_IsShow]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_IsShow]  DEFAULT ((1)) FOR [IsShow]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_FontName]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_FontName]  DEFAULT ('AsoftR') FOR [FontName]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_FontSize]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_FontSize]  DEFAULT ((8)) FOR [FontSize]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_FontType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_FontType]  DEFAULT ('xlsNoFormat') FOR [FontType]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_Alignment]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_Alignment]  DEFAULT ((0)) FOR [Alignment]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_IsLock]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_IsLock]  DEFAULT ((0)) FOR [IsLock]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_IsHide]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_IsHide]  DEFAULT ((0)) FOR [IsHide]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_PrintGridLine]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_PrintGridLine]  DEFAULT ((0)) FOR [PrintGridLine]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_TopMargin]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_TopMargin]  DEFAULT ((1.5)) FOR [TopMargin]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_BottomMargin]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_BottomMargin]  DEFAULT ((1.5)) FOR [BottomMargin]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_LeftMargin]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_LeftMargin]  DEFAULT ((1.5)) FOR [LeftMargin]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT8000_RightMargin]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT8000] ADD  CONSTRAINT [DF_AT8000_RightMargin]  DEFAULT ((1.5)) FOR [RightMargin]
END

