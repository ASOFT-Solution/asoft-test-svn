-- <Summary>
---- 
-- <History>
---- Create on 25/09/2012 by Huỳnh Tấn Phú
---- Modify on 12/12/2013 by Bảo Anh: Bổ sung trường ShortName, Alias
---- Modify on 12/12/2013 by Bảo Anh: Bổ sung trường thực lãnh và thuế TNCN
---- Modified on 21/01/2015 by Thanh Sơn: bổ sung thêm 3 trường cho SG Petro
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT7110]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HT7110](
	[APK] [uniqueidentifier] NULL DEFAULT NEWID(),
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[STT] [int] NULL,
	[DivisionID] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[DepartmentName] [nvarchar](250) NULL,
	[TeamID] [nvarchar](50) NULL,
	[TeamName] [nvarchar](250) NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[FullName] [nvarchar](250) NULL,
	[IdentifyCardNo] [nvarchar](50) NULL,
	[BankID] [nvarchar](50) NULL,
	[BankName] [nvarchar](250) NULL,
	[BankAccountNo] [nvarchar](50) NULL,
	[DutyID] [nvarchar](50) NULL,
	[DutyName] [nvarchar](250) NULL,
	[Orders] [int] NULL,
	[Groups] [tinyint] NULL,
	[BaseSalary] [decimal](28, 8) NULL,
	[ColumnAmount01] [decimal](28, 8) NULL,
	[ColumnAmount02] [decimal](28, 8) NULL,
	[ColumnAmount03] [decimal](28, 8) NULL,
	[ColumnAmount04] [decimal](28, 8) NULL,
	[ColumnAmount05] [decimal](28, 8) NULL,
	[ColumnAmount06] [decimal](28, 8) NULL,
	[ColumnAmount07] [decimal](28, 8) NULL,
	[ColumnAmount08] [decimal](28, 8) NULL,
	[ColumnAmount09] [decimal](28, 8) NULL,
	[ColumnAmount10] [decimal](28, 8) NULL,
	[ColumnAmount11] [decimal](28, 8) NULL,
	[ColumnAmount12] [decimal](28, 8) NULL,
	[ColumnAmount13] [decimal](28, 8) NULL,
	[ColumnAmount14] [decimal](28, 8) NULL,
	[ColumnAmount15] [decimal](28, 8) NULL,
	[ColumnAmount16] [decimal](28, 8) NULL,
	[ColumnAmount17] [decimal](28, 8) NULL,
	[ColumnAmount18] [decimal](28, 8) NULL,
	[ColumnAmount19] [decimal](28, 8) NULL,
	[ColumnAmount20] [decimal](28, 8) NULL,
	[ColumnAmount21] [decimal](28, 8) NULL,
	[ColumnAmount22] [decimal](28, 8) NULL,
	[ColumnAmount23] [decimal](28, 8) NULL,
	[ColumnAmount24] [decimal](28, 8) NULL,
	[ColumnAmount25] [decimal](28, 8) NULL,
	[ColumnAmount26] [decimal](28, 8) NULL,
	[ColumnAmount27] [decimal](28, 8) NULL,
	[ColumnAmount28] [decimal](28, 8) NULL,
	[ColumnAmount29] [decimal](28, 8) NULL,
	[ColumnAmount30] [decimal](28, 8) NULL,
	[ColumnAmount31] [decimal](28, 8) NULL,
	[ColumnAmount32] [decimal](28, 8) NULL,
	[ColumnAmount33] [decimal](28, 8) NULL,
	[ColumnAmount34] [decimal](28, 8) NULL,
	[ColumnAmount35] [decimal](28, 8) NULL,
	[ColumnAmount36] [decimal](28, 8) NULL,
	[ColumnAmount37] [decimal](28, 8) NULL,
	[ColumnAmount38] [decimal](28, 8) NULL,
	[ColumnAmount39] [decimal](28, 8) NULL,
	[ColumnAmount40] [decimal](28, 8) NULL,
	[ColumnAmount41] [decimal](28, 8) NULL,
	[ColumnAmount42] [decimal](28, 8) NULL,
	[ColumnAmount43] [decimal](28, 8) NULL,
	[ColumnAmount44] [decimal](28, 8) NULL,
	[ColumnAmount45] [decimal](28, 8) NULL,
	[ColumnAmount46] [decimal](28, 8) NULL,
	[ColumnAmount47] [decimal](28, 8) NULL,
	[ColumnAmount48] [decimal](28, 8) NULL,
	[ColumnAmount49] [decimal](28, 8) NULL,
	[ColumnAmount50] [decimal](28, 8) NULL,
	[WorkDate] [datetime] NULL,
	[LeaveDate] [datetime] NULL,
	[CountryName] [nvarchar](250) NULL,
	[Parameter01] [nvarchar](250) NULL,
	[Parameter02] [nvarchar](250) NULL,
	[Parameter03] [nvarchar](250) NULL,
	[Parameter04] [nvarchar](250) NULL,
	[Parameter05] [nvarchar](250) NULL,
 CONSTRAINT [PK__HT7110__47ED27BF] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add Columns
--- Thêm field bảng HT7110
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'HT7110' AND xtype = 'U') 
BEGIN
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'Birthday')
    ALTER TABLE HT7110 ADD Birthday datetime NULL    
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'PersonalTaxID')
    ALTER TABLE HT7110 ADD PersonalTaxID NVARCHAR(50) NULL    
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'EducationLevelID')
    ALTER TABLE HT7110 ADD EducationLevelID nvarchar(50) NULL    
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'EducationLevelName')
    ALTER TABLE HT7110 ADD EducationLevelName nvarchar(250) NULL    
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'MajorID')
    ALTER TABLE HT7110 ADD MajorID NVARCHAR(50) NULL    
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'MajorName')
    ALTER TABLE HT7110 ADD MajorName NVARCHAR(250) NULL	
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'ShortName')
    ALTER TABLE HT7110 ADD ShortName NVARCHAR(50) NULL    
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'Alias')
    ALTER TABLE HT7110 ADD Alias NVARCHAR(50) NULL        
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'Total')
    ALTER TABLE HT7110 ADD Total decimal(28,8) NULL    
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'TaxAmount')
    ALTER TABLE HT7110 ADD TaxAmount decimal(28,8) NULL   
END 
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT7110' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'ExpenseAccountID')
		ALTER TABLE HT7110 ADD ExpenseAccountID VARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT7110' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'PayableAccountID')
		ALTER TABLE HT7110 ADD PayableAccountID VARCHAR(50) NULL
	END	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT7110' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'PerInTaxID')
		ALTER TABLE HT7110 ADD PerInTaxID VARCHAR(50) NULL
	END	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT7110' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'TranMonth')
		ALTER TABLE HT7110 ADD TranMonth INT NULL
	END	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT7110' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT7110' AND col.name = 'TranYear')
		ALTER TABLE HT7110 ADD TranYear INT NULL
	END