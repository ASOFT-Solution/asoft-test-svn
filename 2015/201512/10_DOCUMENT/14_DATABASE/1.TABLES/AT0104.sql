-- <Summary>
---- 
-- <History>
---- Create on 21/01/2014 by Khánh Vân
---- Modified on ... by 
-- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0104]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT0104]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [ObjectID] VARCHAR(50) NOT NULL,
      [InventoryID] VARCHAR(50) NOT NULL,
      [SalePrice] DECIMAL(28,8) NULL,
      [BuyPrice] DECIMAL(28,8) NULL,
      [Commission] DECIMAL(28,8) NULL,
      [CreateUserID] VARCHAR(50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] VARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_AT0104] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [ObjectID],
      [InventoryID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
