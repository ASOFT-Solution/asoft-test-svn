-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1404]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1404](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ModuleID] [nvarchar](50) NOT NULL,
	[ScreenID] [nvarchar](50) NOT NULL,
	[ScreenName] [nvarchar](250) NULL,
	[ScreenType] [tinyint] NOT NULL DEFAULT ((1)),
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[ScreenNameE] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT1404] PRIMARY KEY NONCLUSTERED 
(
	[ModuleID] ASC,
	[ScreenID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

--Add column 
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT1404' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT1404' AND col.name='Disabled')
		ALTER TABLE AT1404 ADD Disabled TINYINT NOT NULL DEFAULT(0)
	END