-- <Summary>
---- 
-- <History>
---- Create on 29/05/2015 by Thanh Sơn
---- Modified on 26/10/2015 by Tiểu Mai: Add columns UnitID
---- Modified on 17/11/2015 by Tiểu Mai: Bổ sung khóa chính.
-- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0135]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT0135]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NULL,
      [PriceID] VARCHAR(50) NOT NULL,
      [InventoryID] VARCHAR(50) NOT NULL,
      [StandardID] VARCHAR(50) NOT NULL,
      [UnitPrice] DECIMAL(28,8) NULL,
      [CreateUserID] VARCHAR(50) NULL,
      [CreateDate] DATETIME NULL
    CONSTRAINT [PK_AT0135] PRIMARY KEY CLUSTERED
      (
      [PriceID],
      [InventoryID],
      [StandardID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END

---- Modified on 26/10/2015 by Tiểu Mai: Add columns UnitID
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0135' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0135' AND col.name='UnitID')
		ALTER TABLE AT0135 ADD UnitID VARCHAR (50) NULL
	END	
GO
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0135' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0135' AND col.name='DivisionID')
		ALTER TABLE AT0135 ALTER COLUMN [DivisionID] varchar(50) NOT NULL
		
		--- Modified on 17/11/2015 by Tiểu Mai
		IF EXISTS (SELECT TOP 1 1 FROM AT0135)
		BEGIN
			IF EXISTS (SELECT TOP 1 1 FROM AT0135 WHERE UnitID is NULL)
				UPDATE AT0135
				SET
					UnitID = AT1302.UnitID
				FROM AT0135
				LEFT JOIN AT1302 ON AT1302.DivisionID = AT0135.DivisionID AND AT1302.InventoryID = AT0135.InventoryID
				WHERE AT0135.InventoryID = AT1302.InventoryID AND AT1302.DivisionID = AT0135.DivisionID
		END
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0135' AND col.name='UnitID')
		ALTER TABLE AT0135 ALTER COLUMN [UnitID] varchar(50) NOT NULL
	END
GO
---- Modified on 17/11/2015 by Tiểu Mai	
IF (SELECT count (col.name) FROM SYS.indexes ind 
					INNER JOIN SYS.index_columns ic 
						ON  ind.OBJECT_ID = ic.OBJECT_ID and ind.index_id = ic.index_id 
					INNER JOIN SYS.COLUMNS col 
						ON ic.OBJECT_ID = col.OBJECT_ID and ic.column_id = col.column_id 
					WHERE ind.name = 'PK_AT0135' AND (col.name = 'DivisionID' or col.name = 'UnitID')) < 2
BEGIN
	ALTER TABLE AT0135 DROP CONSTRAINT [PK_AT0135]
	ALTER TABLE AT0135 ADD CONSTRAINT [PK_AT0135] PRIMARY KEY ([DivisionID],[PriceID],[InventoryID],[StandardID],[UnitID])

END	


