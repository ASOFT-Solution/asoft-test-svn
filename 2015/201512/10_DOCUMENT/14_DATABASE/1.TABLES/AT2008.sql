-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2008]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2008](
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
 CONSTRAINT [PK_AT2008] PRIMARY KEY NONCLUSTERED 
(
	[WareHouseID] ASC,
	[TranMonth] ASC,
	[TranYear] ASC,
	[DivisionID] ASC,
	[InventoryID] ASC,
	[InventoryAccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
