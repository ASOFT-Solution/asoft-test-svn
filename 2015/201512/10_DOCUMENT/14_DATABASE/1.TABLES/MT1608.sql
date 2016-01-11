-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1608]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1608](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[InprocessID] [nvarchar](50) NOT NULL,
	[InprocessDate] [datetime] NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[BeginMethodID] [tinyint] NOT NULL,
	[EndMethodID] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Disabled] [tinyint] NULL,
 CONSTRAINT [PK_MT1608] PRIMARY KEY NONCLUSTERED 
(
	[InprocessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1608_BeginMethodID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1608] ADD  CONSTRAINT [DF_MT1608_BeginMethodID]  DEFAULT ((0)) FOR [BeginMethodID]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1608_EndMethodID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1608] ADD  CONSTRAINT [DF_MT1608_EndMethodID]  DEFAULT ((0)) FOR [EndMethodID]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1608_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1608] ADD  CONSTRAINT [DF_MT1608_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
