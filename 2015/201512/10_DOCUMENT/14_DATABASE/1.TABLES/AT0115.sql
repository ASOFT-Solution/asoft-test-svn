-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh 
---- Modified on ... by 
-- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0115]') AND type in (N'U'))
--DROP TABLE [dbo].[AT0115]
CREATE TABLE [dbo].[AT0115](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherID] [nvarchar](50) NULL,
	[TransactionID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[PriceQuantity] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[ReVoucherID] [nvarchar](50) NULL,
	[ReTransactionID] [nvarchar](50) NULL,
	[ReVoucherDate] [datetime] NULL,
	[ReVoucherNo] [nvarchar](50) NULL,
	CONSTRAINT [PK_AT0115] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON
)
) ON [PRIMARY]

