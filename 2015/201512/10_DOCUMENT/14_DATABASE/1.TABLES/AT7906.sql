-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7906]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7906](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[GroupID] [nvarchar](50) NOT NULL,
	[TitleName] [nvarchar](250) NULL,
	[IsCol01] [tinyint] NOT NULL,
	[IsCol02] [tinyint] NOT NULL,
	[IsCol03] [tinyint] NOT NULL,
	[IsCol04] [tinyint] NOT NULL,
	[IsCol05] [tinyint] NOT NULL,
	[IsCol06] [tinyint] NOT NULL,
	[IsCol07] [tinyint] NOT NULL,
	[IsCol08] [tinyint] NOT NULL,
	[IsCol09] [tinyint] NOT NULL,
	[IsCol10] [tinyint] NOT NULL,
	[Caption01] [nvarchar](250) NULL,
	[Caption02] [nvarchar](250) NULL,
	[Caption03] [nvarchar](250) NULL,
	[Caption04] [nvarchar](250) NULL,
	[Caption05] [nvarchar](250) NULL,
	[Caption06] [nvarchar](250) NULL,
	[Caption07] [nvarchar](250) NULL,
	[Caption08] [nvarchar](250) NULL,
	[Caption09] [nvarchar](250) NULL,
	[Caption10] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
CONSTRAINT [PK_AT7906] PRIMARY KEY CLUSTERED 
(
	[ReportCode] ASC,
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7906_IsCol01]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7906] ADD  CONSTRAINT [DF_AT7906_IsCol01]  DEFAULT ((0)) FOR [IsCol01]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7906_IsCol02]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7906] ADD  CONSTRAINT [DF_AT7906_IsCol02]  DEFAULT ((0)) FOR [IsCol02]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7906_IsCol03]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7906] ADD  CONSTRAINT [DF_AT7906_IsCol03]  DEFAULT ((0)) FOR [IsCol03]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7906_IsCol04]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7906] ADD  CONSTRAINT [DF_AT7906_IsCol04]  DEFAULT ((0)) FOR [IsCol04]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7906_IsCol05]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7906] ADD  CONSTRAINT [DF_AT7906_IsCol05]  DEFAULT ((0)) FOR [IsCol05]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7906_IsCol06]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7906] ADD  CONSTRAINT [DF_AT7906_IsCol06]  DEFAULT ((0)) FOR [IsCol06]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7906_IsCol07]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7906] ADD  CONSTRAINT [DF_AT7906_IsCol07]  DEFAULT ((0)) FOR [IsCol07]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7906_IsCol08]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7906] ADD  CONSTRAINT [DF_AT7906_IsCol08]  DEFAULT ((0)) FOR [IsCol08]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7906_IsCol09]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7906] ADD  CONSTRAINT [DF_AT7906_IsCol09]  DEFAULT ((0)) FOR [IsCol09]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7906_IsCol10]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7906] ADD  CONSTRAINT [DF_AT7906_IsCol10]  DEFAULT ((0)) FOR [IsCol10]
END
