-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7601]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7601](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[ReportName1] [nvarchar](250) NULL,
	[ReportName2] [nvarchar](250) NULL,
	[ReportID] [nvarchar](50) NULL,
	[ReportID2] [nvarchar](50) NULL,
	[ReportID3] [nvarchar](50) NULL,
	[BracketNegative] [tinyint] NULL,
	[AmountFormat] [tinyint] NULL,
	[Customized] [tinyint] NULL,
	[Column01_1] [nvarchar](50) NULL,
	[Column01_2] [nvarchar](50) NULL,
	[Column01_3] [nvarchar](50) NULL,
	[Column01_4] [nvarchar](50) NULL,
	[Column01_5] [nvarchar](50) NULL,
	[Column02_1] [nvarchar](50) NULL,
	[Column02_2] [nvarchar](50) NULL,
	[Column02_3] [nvarchar](50) NULL,
	[Column02_4] [nvarchar](50) NULL,
	[Column02_5] [nvarchar](50) NULL,
	[Column02_6] [nvarchar](50) NULL,
	[Column02_7] [nvarchar](50) NULL,
	[Column02_8] [nvarchar](50) NULL,
	[Column02_9] [nvarchar](50) NULL,
	[Column03_1] [nvarchar](50) NULL,
	[Column03_2] [nvarchar](50) NULL,
	[Column03_4] [nvarchar](50) NULL,
	[Column03_5] [nvarchar](50) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Disabled] [tinyint] NULL,
 CONSTRAINT [PK_AT7601] PRIMARY KEY NONCLUSTERED 
(
	[ReportCode] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Column01_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Column01_1]  DEFAULT ((205)) FOR [Column01_1]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Column01_2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Column01_2]  DEFAULT ((200)) FOR [Column01_2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Column01_3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Column01_3]  DEFAULT ((300)) FOR [Column01_3]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Column02_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Column02_1]  DEFAULT ((101)) FOR [Column02_1]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Column02_2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Column02_2]  DEFAULT ((202)) FOR [Column02_2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Column02_3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Column02_3]  DEFAULT ((201)) FOR [Column02_3]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Column02_4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Column02_4]  DEFAULT ((302)) FOR [Column02_4]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Column02_5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Column02_5]  DEFAULT ((301)) FOR [Column02_5]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Column02_6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Column02_6]  DEFAULT ((100)) FOR [Column02_6]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Column03_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Column03_1]  DEFAULT ((200)) FOR [Column03_1]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Column03_2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Column03_2]  DEFAULT ((300)) FOR [Column03_2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7601_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7601] ADD  CONSTRAINT [DF_AT7601_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
