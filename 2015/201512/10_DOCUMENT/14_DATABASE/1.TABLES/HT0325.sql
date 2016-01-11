-- <Summary>
---- 
-- <History>
---- Create on 31/10/2013 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT0325]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[HT0325]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR (50) NOT NULL,
      [ResultAPK] VARCHAR (50) NOT NULL,
      [EmployeeID] VARCHAR (50) NOT NULL,
      [SalaryAmount] DECIMAL (28,8) DEFAULT (0) NOT NULL
    CONSTRAINT [PK_HT0325] PRIMARY KEY CLUSTERED
      (
      [APK]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0325' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0325' AND col.name='Coefficient')
	ALTER TABLE HT0325 ADD Coefficient DECIMAL (28,8) DEFAULT (1) NOT NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT0325' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT0325' AND col.name='ProductAmount')
	ALTER TABLE HT0325 ADD ProductAmount DECIMAL (28,8) DEFAULT (0) NOT NULL
END