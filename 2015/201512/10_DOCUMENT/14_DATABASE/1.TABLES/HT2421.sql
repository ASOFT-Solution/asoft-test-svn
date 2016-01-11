-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on 25/05/2012 by Thiên Huỳnh: remove primary key from table HT2421
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2421]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2421](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ProjectID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[BaseSalary] [decimal](28, 8) NULL,
	[InsuranceSalary] [decimal](28, 8) NULL,
	[Salary01] [decimal](28, 8) NULL,
	[Salary02] [decimal](28, 8) NULL,
	[Salary03] [decimal](28, 8) NULL,
	[SalaryCoefficient] [decimal](28, 8) NULL,
	[DutyCoefficient] [decimal](28, 8) NULL,
	[TimeCoefficient] [decimal](28, 8) NULL,
	[I01] [decimal](28, 8) NULL,
	[I02] [decimal](28, 8) NULL,
	[I03] [decimal](28, 8) NULL,
	[I04] [decimal](28, 8) NULL,
	[I05] [decimal](28, 8) NULL,
	[I06] [decimal](28, 8) NULL,
	[I07] [decimal](28, 8) NULL,
	[I08] [decimal](28, 8) NULL,
	[I09] [decimal](28, 8) NULL,
	[I10] [decimal](28, 8) NULL,
	[I11] [decimal](28, 8) NULL,
	[I12] [decimal](28, 8) NULL,
	[I13] [decimal](28, 8) NULL,
	[I14] [decimal](28, 8) NULL,
	[I15] [decimal](28, 8) NULL,
	[I16] [decimal](28, 8) NULL,
	[I17] [decimal](28, 8) NULL,
	[I18] [decimal](28, 8) NULL,
	[I19] [decimal](28, 8) NULL,
	[I20] [decimal](28, 8) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT2421] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC,
	[EmployeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Alter Primary Key
Declare @SQL varchar(500),
		@PKName varchar(200)
If Exists (Select * From sysobjects Where name = 'HT2421' and xtype ='U')
Begin
	Select @PKName = pk.name From sysobjects pk inner join sysobjects tab
	On pk.parent_obj = tab.id where pk.xtype = 'PK' and tab.name = 'HT2421'
	
	If @PKName is not null
	Begin
		Set @SQL = 'Alter Table HT2421 Drop Constraint ' + @PKName
		Execute(@SQL)
	END
End
--Purpose : change data type of column ReportCode
Set @SQL = 'Alter Table HT2421 Alter Column APK uniqueidentifier Not Null' 
Execute(@SQL)
--Purpose : Add primary key to table ht2421
Set @SQL = 'Alter Table HT2421 Add Constraint PK_HT2421 
			Primary Key Clustered (APK)'
Execute(@SQL)
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT2421' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT2421'  and col.name = 'BeginDate')
		   Alter Table  HT2421 Add BeginDate datetime Null         
End