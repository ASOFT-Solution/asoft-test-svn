-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on 14/04/2015 by Lê Thị Hạnh: Thêm IsAppendix,CContractID cho phụ lục hợp đồng
---- Modified on 27/08/2013 by Bảo Anh: Bổ sung phân loại mã tự động cho HĐLĐ
--- Created by Bảo Anh	Date: 27/08/2013
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1360]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1360](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ContractID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,	
	[DepartmentID] [nvarchar](50) NOT NULL,
	[TeamID] [nvarchar](50) NULL,
	[SignPersonID] [nvarchar](50) NULL,
	[SignDate] [datetime] NULL,
	[ContractNo] [nvarchar](50) NOT NULL,
	[ContractTypeID] [nvarchar](50) NULL,
	[WorkDate] [datetime] NULL,
	[WorkEndDate] [datetime] NULL,
	[TestFromDate] [datetime] NULL,
	[TestEndDate] [datetime] NULL,
	[DutyID] [nvarchar](50) NULL,
	[Works] [nvarchar](250) NULL,
	[BaseSalary] [decimal](28,8) NULL,
	[Salary01] [decimal](28,8) NULL,
	[Salary02] [decimal](28,8) NULL,
	[Salary03] [decimal](28,8) NULL,
	[WorkAddress] [nvarchar](250) NULL,
	[WorkTime] [nvarchar](250) NULL,
	[IssueTool] [nvarchar](250) NULL,
	[Conveyance] [nvarchar](250) NULL,
	[PayForm] [nvarchar](250) NULL,
	[RestRegulation] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[TitleID] [nvarchar](50) NULL,
	[Allowance] [nvarchar](250) NULL,
	[PayDate] [nvarchar](50) NULL,
	[Bonus] [nvarchar](100) NULL,
	[SalaryRegulation] [nvarchar](100) NULL,
	[SafetyEquiment] [nvarchar](250) NULL,
	[SI] [nvarchar](250) NULL,
	[TrainingRegulation] [nvarchar](250) NULL,
	[OtherAgreement] [nvarchar](250) NULL,
	[Compensation] [nvarchar](250) NULL,
 CONSTRAINT [PK_HT1360] PRIMARY KEY NONCLUSTERED 
(
	[ContractID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='HT1360' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='HT1360' AND col.name='IsAppendix')
		ALTER TABLE HT1360 ADD IsAppendix TINYINT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='HT1360' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='HT1360' AND col.name='CContractID')
		ALTER TABLE HT1360 ADD CContractID NVARCHAR(50) NULL
	END
If Exists (Select * From sysobjects Where name = 'HT1360' and xtype ='U') 
Begin          
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1360'  and col.name = 'S1')
           Alter Table  HT1360 Add S1 nvarchar(50) Null           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1360'  and col.name = 'S2')
           Alter Table  HT1360 Add S2 nvarchar(50) Null           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1360'  and col.name = 'S3')
           Alter Table  HT1360 Add S3 nvarchar(50) Null
END

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='HT1360' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='HT1360' AND col.name='IsSLSendEmail')
		ALTER TABLE HT1360 ADD IsSLSendEmail INT NULL
	END