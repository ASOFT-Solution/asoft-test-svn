-- <Summary>
---- 
-- <History>
---- Create on 29/05/2015 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[OT8899]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[OT8899]
     (
	  [DivisionID] VARCHAR(50) NOT NULL,
	  [VoucherID] VARCHAR(50) NOT NULL,
      [TransactionID] VARCHAR(50) NOT NULL,
      [TableID] VARCHAR(50) NULL,
      [S01ID] VARCHAR(50) NULL,
      [S02ID] VARCHAR(50) NULL,
      [S03ID] VARCHAR(50) NULL,
      [S04ID] VARCHAR(50) NULL,
      [S05ID] VARCHAR(50) NULL,
      [S06ID] VARCHAR(50) NULL,
      [S07ID] VARCHAR(50) NULL,
      [S08ID] VARCHAR(50) NULL,
      [S09ID] VARCHAR(50) NULL,
      [S10ID] VARCHAR(50) NULL,
      [S11ID] VARCHAR(50) NULL,
      [S12ID] VARCHAR(50) NULL,
      [S13ID] VARCHAR(50) NULL,
      [S14ID] VARCHAR(50) NULL,
      [S15ID] VARCHAR(50) NULL,
      [S16ID] VARCHAR(50) NULL,
      [S17ID] VARCHAR(50) NULL,
      [S18ID] VARCHAR(50) NULL,
      [S19ID] VARCHAR(50) NULL,
      [S20ID] VARCHAR(50) NULL,
      [SUnitPrice01] DECIMAL(28,8) NULL,
      [SUnitPrice02] DECIMAL(28,8) NULL,
      [SUnitPrice03] DECIMAL(28,8) NULL,
      [SUnitPrice04] DECIMAL(28,8) NULL,
      [SUnitPrice05] DECIMAL(28,8) NULL,
      [SUnitPrice06] DECIMAL(28,8) NULL,
      [SUnitPrice07] DECIMAL(28,8) NULL,
      [SUnitPrice08] DECIMAL(28,8) NULL,
      [SUnitPrice09] DECIMAL(28,8) NULL,
      [SUnitPrice10] DECIMAL(28,8) NULL,
      [SUnitPrice11] DECIMAL(28,8) NULL,
      [SUnitPrice12] DECIMAL(28,8) NULL,
      [SUnitPrice13] DECIMAL(28,8) NULL,
      [SUnitPrice14] DECIMAL(28,8) NULL,
      [SUnitPrice15] DECIMAL(28,8) NULL,
      [SUnitPrice16] DECIMAL(28,8) NULL,
      [SUnitPrice17] DECIMAL(28,8) NULL,
      [SUnitPrice18] DECIMAL(28,8) NULL,
      [SUnitPrice19] DECIMAL(28,8) NULL,
      [SUnitPrice20] DECIMAL(28,8) NULL,
	  [UnitPriceStandard] DECIMAL(28,8) NULL
    CONSTRAINT [PK_OT8899] PRIMARY KEY CLUSTERED
      (
      [TransactionID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
