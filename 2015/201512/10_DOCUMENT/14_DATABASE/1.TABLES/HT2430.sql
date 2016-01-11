-- <Summary>
---- Tao table phu cap theo cong trinh
-- <History>
---- Create on 17/01/2013 by Bảo Anh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2430]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[HT2430](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] nvarchar(3) NOT NULL,
		[ProjectID] nvarchar(50) NOT NULL,
		[PeriodID] nvarchar(50) NULL,
		[EmployeeID] [nvarchar](50) NOT NULL,
		[DepartmentID] [nvarchar](50) NOT NULL,
		[TeamID] [nvarchar](50) NULL,
		[TranMonth] [int] NOT NULL,
		[TranYear] [int] NOT NULL,
		[C01] [decimal](28, 8) NULL,
		[C02] [decimal](28, 8) NULL,
		[C03] [decimal](28, 8) NULL,
		[C04] [decimal](28, 8) NULL,
		[C05] [decimal](28, 8) NULL,
		[C06] [decimal](28, 8) NULL,
		[C07] [decimal](28, 8) NULL,
		[C08] [decimal](28, 8) NULL,
		[C09] [decimal](28, 8) NULL,
		[C10] [decimal](28, 8) NULL,
		[C11] [decimal](28, 8) NULL,
		[C12] [decimal](28, 8) NULL,
		[C13] [decimal](28, 8) NULL,
		[CreateDate] [datetime] NULL,
		[LastModifyDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
	 CONSTRAINT [PK_HT2430] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT2430' and xtype ='U') 
Begin
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C14')
       Alter Table  HT2430 Add C14 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C15')
       Alter Table  HT2430 Add C15 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C16')
       Alter Table  HT2430 Add C16 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C17')
       Alter Table  HT2430 Add C17 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C18')
       Alter Table  HT2430 Add C18 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C19')
       Alter Table  HT2430 Add C19 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C20')
       Alter Table  HT2430 Add C20 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C21')
       Alter Table  HT2430 Add C21 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C22')
       Alter Table  HT2430 Add C22 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C23')
       Alter Table  HT2430 Add C23 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C24')
       Alter Table  HT2430 Add C24 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'C25')
       Alter Table  HT2430 Add C25 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'BaseSalary')
       Alter Table  HT2430 Add BaseSalary decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'Salary01')
       Alter Table  HT2430 Add Salary01 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'Salary02')
       Alter Table  HT2430 Add Salary02 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'Salary03')
       Alter Table  HT2430 Add Salary03 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'SalaryCoefficient')
       Alter Table  HT2430 Add SalaryCoefficient decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'TimeCoefficient')
       Alter Table  HT2430 Add TimeCoefficient decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'DutyCoefficient')
       Alter Table  HT2430 Add DutyCoefficient decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT2430'  and col.name = 'InsuranceSalary')
       Alter Table  HT2430 Add InsuranceSalary decimal(28,8) Null
End