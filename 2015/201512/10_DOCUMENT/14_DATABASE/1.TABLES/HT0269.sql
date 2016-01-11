-- <Summary>
---- 
-- <History>
---- Create on 23/05/2011 by Lê Thị Thu Hiền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0269]') AND type in (N'U')) 
BEGIN
CREATE TABLE [dbo].[HT0269](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](50) NOT NULL,
	[SalaryPlanID] [nvarchar](50) NOT NULL,
	[SalaryPlanName] [nvarchar](250) NULL,
	[InventoryTypeID] [nvarchar](50) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[PlanID] [nvarchar](50) NOT NULL,
	[WorkID] [nvarchar](50) NULL,
	[SubPlanID] [nvarchar](50) NOT NULL,
	[DeleteFlag] [tinyint] default(0) NOT NULL,
	[Disabled] [tinyint] default(0) NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT0269] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
 	[SalaryPlanID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT0269' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0269'  and col.name = 'WorkTypeID')
           Alter Table  HT0269 Add WorkTypeID nvarchar(50) Null
End 
---- Alter Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='HT0269' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='HT0269' AND col.name='SubPlanID')
		ALTER TABLE HT0269 ALTER COLUMN SubPlanID NVARCHAR(50) NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='HT0269' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='HT0269' AND col.name='PlanID')
		ALTER TABLE HT0269 ALTER COLUMN PlanID NVARCHAR(50) NULL 
	END