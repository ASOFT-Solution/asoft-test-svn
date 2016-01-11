-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT5002]') AND type in (N'U'))
CREATE TABLE [dbo].[MT5002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[DistributedMethod] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[IsCoefficient] [tinyint] NOT NULL,
	[IsApportion] [tinyint] NOT NULL,
	[Types] [tinyint] NOT NULL,
	[Other] [nvarchar](50) NULL,
	[Is621] [tinyint] NOT NULL,
	[Is622] [tinyint] NOT NULL,
	[Is627] [tinyint] NOT NULL,
 CONSTRAINT [PK_MT5002] PRIMARY KEY NONCLUSTERED 
(
	[DistributedMethod] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT5002_IsCoefficient]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT5002] ADD  CONSTRAINT [DF_MT5002_IsCoefficient]  DEFAULT ((0)) FOR [IsCoefficient]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT5002_IsApportion]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT5002] ADD  CONSTRAINT [DF_MT5002_IsApportion]  DEFAULT ((0)) FOR [IsApportion]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT5002_Types]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT5002] ADD  CONSTRAINT [DF_MT5002_Types]  DEFAULT ((0)) FOR [Types]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT5002_Is621]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT5002] ADD  CONSTRAINT [DF_MT5002_Is621]  DEFAULT ((1)) FOR [Is621]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT5002_Is622]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT5002] ADD  CONSTRAINT [DF_MT5002_Is622]  DEFAULT ((1)) FOR [Is622]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT5002_Is627]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT5002] ADD  CONSTRAINT [DF_MT5002_Is627]  DEFAULT ((1)) FOR [Is627]
END