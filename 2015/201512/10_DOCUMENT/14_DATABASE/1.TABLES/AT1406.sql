-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1406]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1406](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ModuleID] [nvarchar](50) NOT NULL,
	[GroupID] [nvarchar](50) NOT NULL,
	[DataID] [nvarchar](50) NOT NULL,
	[DataType] [nvarchar](50) NOT NULL,
	[BeginChar] [nvarchar](100) NULL,
	[Permission] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_AT1406] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[ModuleID] ASC,
	[GroupID] ASC,
	[DataID] ASC,
	[DataType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1406_DataType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1406] ADD  CONSTRAINT [DF_AT1406_DataType]  DEFAULT ('PE') FOR [DataType]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1406_Permision]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1406] ADD  CONSTRAINT [DF_AT1406_Permision]  DEFAULT ((1)) FOR [Permission]
END
---- Alter Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT1406' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT1406' AND col.name='BeginChar')
		ALTER TABLE AT1406 ALTER COLUMN BeginChar NVARCHAR(MAX) NULL 
	END
