-- <Summary>
---- 
-- <History>
---- Create on 26/12/2014 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[CMT0008]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[CMT0008]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [CommissionMethodID] VARCHAR(50) NOT NULL,
      [InventoryID] VARCHAR(50) NOT NULL,
      [RateValue] DECIMAL(28,8) DEFAULT (0) NULL,
      [Notes] NVARCHAR(1000) NULL
    CONSTRAINT [PK_CMT0008] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [CommissionMethodID],
      [InventoryID] 
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END