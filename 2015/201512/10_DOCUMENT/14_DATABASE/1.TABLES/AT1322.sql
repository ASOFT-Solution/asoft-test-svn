-- <Summary>
---- 
-- <History>
---- Create on 23/04/2015 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT1322]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT1322]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [InventoryID] VARCHAR(50) NOT NULL,
      [StandardTypeID] VARCHAR(50) NULL,
      [UseName] NVARCHAR(250) NULL,
      [Orders] INT NULL,
      [IsUsed] TINYINT DEFAULT (0) NULL
    CONSTRAINT [PK_AT1322] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [InventoryID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END