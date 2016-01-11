-- <Summary>
---- 
-- <History>
---- Create on 17/10/2013 by Bảo Anh
---- Modified on 10/08/2015 by Thanh Thịnh : Tạo thêm cột FirstleaveDay
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0315]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[HT0315](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](3) NOT NULL,
		[TransactionID] [nvarchar](50) NOT NULL,
		[EmployeeID] [nvarchar](50) NOT NULL,
		[DepartmentID] [nvarchar](50) NOT NULL,
		[TeamID] [nvarchar](50) NULL,
		[TranMonth] int NULL,
		[TranYear] int NULL,
		[SNo] [nvarchar](50) NULL,
		[InsuranceSalary] decimal(28,8) NULL,
		[ConditionTypeID] [nvarchar](3) NULL,
		[VoucherDate] [datetime] NULL,
		[InLeaveDays] int NULL,
		[Amounts] decimal(28,8) NULL,
		[Notes] [nvarchar](250) NULL,
		[CreateDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
	 CONSTRAINT [PK_HT0315] PRIMARY KEY NONCLUSTERED 
	(
		[DivisionID] ASC,
		[TransactionID] ASC		
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT0315' and xtype ='U') 
Begin
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'HT0315'  and col.name = 'ConditionNotes')
	Alter Table  HT0315 Add ConditionNotes nvarchar(500) Null           
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'HT0315'  and col.name = 'TimesNo')
	Alter Table  HT0315 Add TimesNo int Null           
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'HT0315'  and col.name = 'IsExamined')
	Alter Table  HT0315 Add IsExamined tinyint Null           
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'HT0315'  and col.name = 'EndInLeaveDays')
	Alter Table  HT0315 Add EndInLeaveDays int Null           
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'HT0315'  and col.name = 'EndAmounts')
	Alter Table  HT0315 Add EndAmounts decimal(28,8) Null           
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'HT0315'  and col.name = 'Reason')
	Alter Table  HT0315 Add Reason nvarchar(500) Null
End
-- Thinh(10/08/2015) Add Column FirstleaveDay
If Exists (Select * From sysobjects Where name = 'HT0315' and xtype ='U') 
Begin
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'HT0315'  and col.name = 'FirstleaveDay')
	Alter Table  HT0315 Add FirstleaveDay int Null    
End