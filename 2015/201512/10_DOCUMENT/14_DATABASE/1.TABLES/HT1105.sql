-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 27/12/2013 by Thanh Sơn: bổ sung 2 cột IsWarning & WarningDays
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1105]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1105](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ContractTypeID] [nvarchar](50) NOT NULL,
	[ContractTypeName] [nvarchar](250) NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT1105] PRIMARY KEY NONCLUSTERED 
(
	[ContractTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
IF(ISNULL(COL_LENGTH('HT1105', 'Months'), 0) <= 0)
ALTER TABLE [HT1105] ADD  [Months] [int] NULL
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1105' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1105' AND col.name='IsWarning')
	ALTER TABLE HT1105 ADD IsWarning TINYINT DEFAULT (0) NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1105' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1105' AND col.name='WarningDays')
	ALTER TABLE HT1105 ADD WarningDays DECIMAL(28,8) DEFAULT (0) NULL
END