-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT4723]') AND type in (N'U'))
CREATE TABLE [dbo].[AT4723](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCodeID] [nvarchar](50) NOT NULL,
	[ReportName] [nvarchar](250) NULL,
	[Title] [nvarchar](250) NULL,
	[RowTypeID] [nvarchar](50) NULL,
	[RowGroupID] [nvarchar](50) NULL,
	[IsColumn01] [tinyint] NOT NULL,
	[IsColumn02] [tinyint] NOT NULL,
	[IsColumn03] [tinyint] NOT NULL,
	[IsColumn04] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[Caption01] [nvarchar](250) NULL,
	[Caption02] [nvarchar](250) NULL,
	[Caption03] [nvarchar](250) NULL,
	[Caption04] [nvarchar](250) NULL,
	[Selection01ID] [nvarchar](50) NULL,
	[Selection02ID] [nvarchar](50) NULL,
	[Selection03ID] [nvarchar](50) NULL,
	[ReportID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT4723] PRIMARY KEY NONCLUSTERED 
(
	[ReportCodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT4723_IsColumn01]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4723] ADD  CONSTRAINT [DF_AT4723_IsColumn01]  DEFAULT ((1)) FOR [IsColumn01]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT4723_IsColumn02]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4723] ADD  CONSTRAINT [DF_AT4723_IsColumn02]  DEFAULT ((0)) FOR [IsColumn02]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT4723_IsColumn03]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4723] ADD  CONSTRAINT [DF_AT4723_IsColumn03]  DEFAULT ((0)) FOR [IsColumn03]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT4723_IsColumn04]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4723] ADD  CONSTRAINT [DF_AT4723_IsColumn04]  DEFAULT ((0)) FOR [IsColumn04]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT4723_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4723] ADD  CONSTRAINT [DF_AT4723_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
