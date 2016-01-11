-- <Summary>
---- 
-- <History>
---- Create on 26/12/2014 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[CMT0010]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[CMT0010]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [TranMonth] INT NOT NULL,
      [TranYear] INT NOT NULL,
      [VoucherID] VARCHAR(50) NOT NULL,
      [InventoryID] VARCHAR(50) NOT NULL,
      [ObjectID] VARCHAR(50) NOT NULL,
      [ComPercent] DECIMAL(28,8) DEFAULT (0) NULL,
      [ComUnit] DECIMAL(28,8) DEFAULT (0) NOT NULL,
      [ComAmount] DECIMAL(28,8) DEFAULT (0) NULL,
      [Notes] NVARCHAR(2000) NULL
    CONSTRAINT [PK_CMT0010] PRIMARY KEY CLUSTERED
      (
      [VoucherID],
      [InventoryID],
      [ObjectID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END