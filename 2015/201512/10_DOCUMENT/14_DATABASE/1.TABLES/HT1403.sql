-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modify on 03/01/2014 by Bảo Anh
---- Modify on 30/09/2014 by Bảo Anh
---- Modified on 09/12/2015 by Phương Thảo: Bổ sung IsManager
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1403]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1403](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,	
	[SalaryCoefficient] [decimal](28, 8) NULL,
	[DutyCoefficient] [decimal](28, 8) NULL,
	[TimeCoefficient] [decimal](28, 8) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[DutyID] [nvarchar](50) NULL,
	[TaxObjectID] [nvarchar](50) NULL,
	[EmployeeStatus] [tinyint] NULL,
	[Experience] [nvarchar](100) NULL,
	[SuggestSalary] [decimal](28, 8) NULL,
	[RecruitDate] [datetime] NULL,
	[RecruitPlace] [nvarchar](250) NULL,
	[WorkDate] [datetime] NULL,
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
	[BaseSalary] [decimal](28, 8) NULL,
	[InsuranceSalary] [decimal](28, 8) NULL,
	[Salary01] [decimal](28, 8) NULL,
	[Salary02] [decimal](28, 8) NULL,
	[Salary03] [decimal](28, 8) NULL,
	[Target01ID] [nvarchar](50) NULL,
	[Target02ID] [nvarchar](50) NULL,
	[Target03ID] [nvarchar](50) NULL,
	[Target04ID] [nvarchar](50) NULL,
	[Target05ID] [nvarchar](50) NULL,
	[Target06ID] [nvarchar](50) NULL,
	[Target07ID] [nvarchar](50) NULL,
	[Target08ID] [nvarchar](50) NULL,
	[Target09ID] [nvarchar](50) NULL,
	[Target10ID] [nvarchar](50) NULL,
	[TargetAmount01] [decimal](28, 8) NULL,
	[TargetAmount02] [decimal](28, 8) NULL,
	[TargetAmount03] [decimal](28, 8) NULL,
	[TargetAmount04] [decimal](28, 8) NULL,
	[TargetAmount05] [decimal](28, 8) NULL,
	[TargetAmount06] [decimal](28, 8) NULL,
	[TargetAmount07] [decimal](28, 8) NULL,
	[TargetAmount08] [decimal](28, 8) NULL,
	[TargetAmount09] [decimal](28, 8) NULL,
	[TargetAmount10] [decimal](28, 8) NULL,
	[LeaveDate] [datetime] NULL,
	[LoaCondID] [nvarchar](50) NULL,
	[IsOtherDayPerMonth] [tinyint] NULL,
	[FileID] [nvarchar](50) NULL,
	[ApplyDate] [datetime] NULL,
	[BeginProbationDate] [datetime] NULL,
	[EndProbationDate] [datetime] NULL,
	[ProbationNote] [nvarchar](250) NULL,
	[QuitJobID] [nvarchar](50) NULL,
	[C11] [decimal](28, 8) NULL,
	[C12] [decimal](28, 8) NULL,
	[C13] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT1403] PRIMARY KEY NONCLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT1403__IsOtherD__53B3AE5C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1403] ADD  CONSTRAINT [DF__HT1403__IsOtherD__53B3AE5C]  DEFAULT ((0)) FOR [IsOtherDayPerMonth]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT1403' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'ExpenseAccountID')
           Alter Table  HT1403 Add ExpenseAccountID nvarchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'HT1403' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'PayableAccountID')
           Alter Table  HT1403 Add PayableAccountID nvarchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'HT1403' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'PerInTaxID')
           Alter Table  HT1403 Add PerInTaxID nvarchar(50) Null
END
If Exists (Select * From sysobjects Where name = 'HT1403' and xtype ='U') 
Begin
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C14')
       Alter Table  HT1403 Add C14 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C15')
       Alter Table  HT1403 Add C15 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C16')
       Alter Table  HT1403 Add C16 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C17')
       Alter Table  HT1403 Add C17 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C18')
       Alter Table  HT1403 Add C18 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C19')
       Alter Table  HT1403 Add C19 decimal(28,8) Null
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C20')
       Alter Table  HT1403 Add C20 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C21')
       Alter Table  HT1403 Add C21 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C22')
       Alter Table  HT1403 Add C22 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C23')
       Alter Table  HT1403 Add C23 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C24')
       Alter Table  HT1403 Add C24 decimal(28,8) Null       
       If not exists (select * from syscolumns col inner join sysobjects tab 
       On col.id = tab.id where tab.name =   'HT1403'  and col.name = 'C25')
       Alter Table  HT1403 Add C25 decimal(28,8) Null
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1403' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1403' AND col.name='IsJobWage')
	ALTER TABLE HT1403 ADD IsJobWage TINYINT DEFAULT (0)
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1403' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1403' AND col.name='IsPiecework')
	ALTER TABLE HT1403 ADD IsPiecework TINYINT DEFAULT (0)
END
--Bổ sung trường Ngày vào công ty (Thanh Sơn)
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1403' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1403' AND col.name='CompanyDate')
	ALTER TABLE HT1403 ADD CompanyDate DATETIME NULL
END
--Bổ sung trường Chức danh (Thanh Sơn)
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1403' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1403' AND col.name='TitleID')
	ALTER TABLE HT1403 ADD TitleID VARCHAR (50) NULL
END
--Bổ sung trường SalaryLevel (Thanh Sơn on 18/12/2013)
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1403' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1403' AND col.name='SalaryLevel')
	ALTER TABLE HT1403 ADD SalaryLevel VARCHAR (50) NULL
END
--Bổ sung trường SalaryLevelDate (Thanh Sơn on 18/12/2013)
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1403' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1403' AND col.name='SalaryLevelDate')
	ALTER TABLE HT1403 ADD SalaryLevelDate DATETIME NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1403' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1403' AND col.name='MidEmployeeID')
	ALTER TABLE HT1403 ADD MidEmployeeID nvarchar(50) NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1403' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1403' AND col.name='LeaveToDate')
	ALTER TABLE HT1403 ADD LeaveToDate datetime NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1403' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1403' AND col.name='Notes')
	ALTER TABLE HT1403 ADD Notes nvarchar(250) NULL
END

---- Modified on 09/12/2015 by Phương Thảo: Bổ sung IsManager
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT1403' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'HT1403' AND col.name = 'IsManager')
        ALTER TABLE HT1403 ADD IsManager TINYINT NULL
    END