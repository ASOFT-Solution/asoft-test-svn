-- <Summary>
---- Chi tiết mặt hàng trong hợp đồng (customize Angel)
-- <History>
---- Create on 03/01/2016 by Bảo Anh

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1031]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1031](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ContractID] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[UnitID] [nvarchar](50) NULL,
	[OrderQuantity] [decimal](28, 8) NULL,
	[SalePrice] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[VATGroupID] [nvarchar](50) NULL,
	[VATOriginalAmount] [decimal](28, 8) NULL,
	[VATConvertedAmount] [decimal](28, 8) NULL,
	[VATPercent] [decimal](28, 8) NULL,
	[DiscountOriginalAmount] [decimal](28, 8) NULL,
	[DiscountConvertedAmount] [decimal](28, 8) NULL,
	[DiscountPercent] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[InheritTableID] [nvarchar] (20) NULL,
	[InheritVoucherID] [nvarchar](50) NULL,
	[InheritTransactionID] [nvarchar](50) NULL,
	
 CONSTRAINT [PK_AT1031] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[ContractID] ASC,
	[TransactionID]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]