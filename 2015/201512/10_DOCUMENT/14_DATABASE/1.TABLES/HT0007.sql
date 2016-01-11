-- <Summary>
---- 
-- <History>
---- Create on 01/10/2013 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT0007]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[HT0007]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID () NOT NULL,
      [DivisionID] VARCHAR (50) NOT NULL,
      [IsAutoPayRoll] TINYINT NULL,
      [IsAutoProfileSalary] TINYINT NULL,
      [DeleteFlag] TINYINT DEFAULT 0 NOT NULL,
      [CreateUserID] VARCHAR (50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] VARCHAR (50) NULL,
      [LastModifyDate] DATETIME NULL      
    CONSTRAINT [PK_HT0007] PRIMARY KEY CLUSTERED
      (
      [APK]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
---- Add Columns
--Thêm cột PeriodID để lưu kì lương chấm công tự động
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='PeriodID')
	ALTER TABLE HT0007 ADD PeriodID VARCHAR (50) NULL
END
--Thêm các cột để lưu hệ số đăng kí bảo hiểm xã hội (06/12/2013)
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='SRate')
	ALTER TABLE HT0007 ADD SRate DECIMAL (28,8) NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='SRate2')
	ALTER TABLE HT0007 ADD SRate2 DECIMAL (28,8) NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='HRate')
	ALTER TABLE HT0007 ADD HRate DECIMAL (28,8) NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='HRate2')
	ALTER TABLE HT0007 ADD HRate2 DECIMAL (28,8) NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='TRate')
	ALTER TABLE HT0007 ADD TRate DECIMAL (28,8) NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='TRate2')
	ALTER TABLE HT0007 ADD TRate2 DECIMAL (28,8) NULL
END
--Thêm cột AbsentTypeID để lưu định nghĩa công phép (09/12/2013)
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='VacationAbsentID')
	ALTER TABLE HT0007 ADD VacationAbsentID VARCHAR(50) NULL
END
--Thêm cột AbsentTypeID1 để lưu định nghĩa công bộ phận trực tiếp (10/12/2013)
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='ProductAbsentID')
	ALTER TABLE HT0007 ADD ProductAbsentID VARCHAR(50) NULL
END
--Thêm cột IsRetirement và RetirementMes để lưu thiết lập cảnh báo nhân viên về hưu (30/12/2013)
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='IsRetirement')
	ALTER TABLE HT0007 ADD IsRetirement TINYINT DEFAULT (0)
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='RetirementMes')
	ALTER TABLE HT0007 ADD RetirementMes NVARCHAR(1000)
END
--Thêm cột IsSalaryIncrease và SalaryIncreaseMes để lưu thiết lập cảnh báo nhân viên về hưu (30/12/2013)
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='IsSalaryIncrease')
	ALTER TABLE HT0007 ADD IsSalaryIncrease TINYINT DEFAULT (0)
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='SalaryIncreaseMes')
	ALTER TABLE HT0007 ADD SalaryIncreaseMes NVARCHAR(1000)
END
--Thêm cột ISExpireContract và ExpireContractMes để lưu thiết lập cảnh báo nhân viên về hưu (30/12/2013)
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='IsExpireContract')
	ALTER TABLE HT0007 ADD ISExpireContract TINYINT DEFAULT (0)
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0007' AND col.name='ExpireContractMes')
	ALTER TABLE HT0007 ADD ExpireContractMes NVARCHAR(1000)
END