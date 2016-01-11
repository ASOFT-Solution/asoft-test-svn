-- <Summary>
---- 
-- <History>
---- Create on 11/04/2013 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WT2027]') AND type in (N'U'))
CREATE TABLE [dbo].[WT2027](
	[APK] [uniqueidentifier] NULL DEFAULT (newid()),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[BatchID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[ApportionTable] [nvarchar](50) NULL,
	[ApportionID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[ActualQuantity] [decimal](28, 8) NULL,
	[ConversionFactor] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[DebitAccountID] [nvarchar](50) NULL,
	[CreditAccountID] [nvarchar](50) NULL,
	[Orders] [int] NOT NULL,
	[PeriodID] [nvarchar](50) NULL,
	[ReTransactionID] [nvarchar](50) NULL,
	[OTransactionID] [nvarchar](50) NULL,
	[ReVoucherID] [nvarchar](50) NULL,
	[OrderID] [nvarchar](50) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[Ana06ID] [nvarchar](50) NULL,
	[Ana07ID] [nvarchar](50) NULL,
	[Ana08ID] [nvarchar](50) NULL,
	[Ana09ID] [nvarchar](50) NULL,
	[Ana10ID] [nvarchar](50) NULL,
 CONSTRAINT [PK_WT2027] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
