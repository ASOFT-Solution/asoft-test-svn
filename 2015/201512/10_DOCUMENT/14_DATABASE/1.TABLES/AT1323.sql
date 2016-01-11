-- <Summary>
---- 
-- <History>
---- Create on 29/05/2015 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT1323]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT1323]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NULL,
      [InventoryID] VARCHAR(50) NULL,     
      [StandardID] VARCHAR(50) NULL,
      [IsUsed] TINYINT DEFAULT (0) NULL
    CONSTRAINT [PK_AT1323] PRIMARY KEY CLUSTERED
      (
      [APK]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
---- AddColumns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1323' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1323' AND col.name = 'StandardTypeID')
		ALTER TABLE AT1323 ADD StandardTypeID VARCHAR(50) NULL
	END
