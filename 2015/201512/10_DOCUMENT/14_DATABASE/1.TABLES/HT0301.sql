-- <Summary>
---- 
-- <History>
---- Create on 14/10/2013 by Bảo Anh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0301]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[HT0301](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](3) NOT NULL,
		[TransactionID] [nvarchar](50) NOT NULL,
		[EmployeeID] [nvarchar](50) NOT NULL,
		[DepartmentID] [nvarchar](50) NOT NULL,
		[TeamID] [nvarchar](50) NULL,
		[TranMonth] int NULL,
		[TranYear] int NULL,
		[SNo] [nvarchar](50) NULL,
		[DecayRate] decimal(28,8) NULL,
		[HomeDays] int NULL,
		[HealthCenterDays] int NULL,
		[Amounts] decimal(28,8) NULL,
		[LeaveFromDate] datetime NULL,
		[LeaveToDate] datetime NULL,
		[Notes] [nvarchar](250) NULL,
		[CreateDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
	 CONSTRAINT [PK_HT0301] PRIMARY KEY NONCLUSTERED 
	(
		[DivisionID] ASC,
		[TransactionID] ASC		
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT0301' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0301'  and col.name = 'TimesNo')
           Alter Table  HT0301 Add TimesNo int Null           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0301'  and col.name = 'IsExamined')
           Alter Table  HT0301 Add IsExamined tinyint Null           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0301'  and col.name = 'EndInLeaveDays')
           Alter Table  HT0301 Add EndInLeaveDays int Null           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0301'  and col.name = 'EndAmounts')
           Alter Table  HT0301 Add EndAmounts decimal(28,8) Null           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0301'  and col.name = 'Reason')
           Alter Table  HT0301 Add Reason nvarchar(500) Null
End
-- Thinh(10/8/2015) Add Column FirstLeaveDate
If Exists (Select * From sysobjects Where name = 'HT0301' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0301' and col.name = 'FirstLeaveDay')
           Alter Table  HT0301 Add FirstLeaveDay int Null        
END