-- <Summary>
---- 
-- <History>
---- Create on 15/05/2015 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT0009]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[HT0009]
     (
      [OrderNo] INT NULL,
      [OrderText] VARCHAR(50) NULL,
      [DeclareRationType] NVARCHAR(50) NOT NULL,
      [TagetID] VARCHAR(50) NOT NULL,
      [TagetName] NVARCHAR(250) NULL,
      [UnitName] NVARCHAR(250) NULL,
      [Person_Amount] DECIMAL(28,8) NULL,
      [ReadOnly] TINYINT DEFAULT (0) NULL
    CONSTRAINT [PK_HT0009] PRIMARY KEY CLUSTERED
      (
      [DeclareRationType],
      [TagetID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT0009' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'HT0009' AND col.name = 'FormulaString')
		ALTER TABLE HT0009 ADD FormulaString NVARCHAR(100) NULL
	END
