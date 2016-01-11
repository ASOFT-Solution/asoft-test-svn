-- <Summary>
---- 
-- <History>
---- Create on 02/11/2015 by Tiểu Mai: Lưu tồn kho theo quy cách.
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2008_QC]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2008_QC](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[WareHouseID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[InventoryAccountID] [nvarchar](50) NOT NULL,
	[BeginQuantity] [decimal](28, 8) NULL,
	[EndQuantity] [decimal](28, 8) NULL,
	[DebitQuantity] [decimal](28, 8) NULL,
	[CreditQuantity] [decimal](28, 8) NULL,
	[InDebitQuantity] [decimal](28, 8) NULL,
	[InCreditQuantity] [decimal](28, 8) NULL,
	[BeginAmount] [decimal](28, 8) NULL,
	[EndAmount] [decimal](28, 8) NULL,
	[DebitAmount] [decimal](28, 8) NULL,
	[CreditAmount] [decimal](28, 8) NULL,
	[InDebitAmount] [decimal](28, 8) NULL,
	[InCreditAmount] [decimal](28, 8) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
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
    [S20ID] VARCHAR(50) NULL

	
 CONSTRAINT [PK_AT2008_QC] PRIMARY KEY NONCLUSTERED 
(	
	[APK] ASC,
	[WareHouseID] ASC,
	[TranMonth] ASC,
	[TranYear] ASC,
	[DivisionID] ASC,
	[InventoryID] ASC,
	[InventoryAccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

