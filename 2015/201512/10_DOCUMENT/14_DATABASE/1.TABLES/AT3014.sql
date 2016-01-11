-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT3014]') AND type in (N'U'))
CREATE TABLE [dbo].[AT3014](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherID] [nvarchar](50) NULL,
	[TaxOrders] [int] NULL,
	[Orders] [int] NULL,
	[InventoryID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[UnitName] [nvarchar](250) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[Serial] [nvarchar](50) NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[InventoryName] [nvarchar](250) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[PaymentID] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[Address] [nvarchar](250) NULL,
	[Tel] [nvarchar](100) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[VATNo] [nvarchar](50) NULL,
	[Fax] [nvarchar](100) NULL,
	[DivisionVATNO] [nvarchar](50) NULL,
	[OriginalAmountTax] [decimal](28, 8) NULL,
	[ConvertedAmountTax] [decimal](28, 8) NULL,
	[SayVN] [nvarchar](250) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[AnaName1] [nvarchar](250) NULL,
	[Ana01RefDate] [datetime] NULL,
	[Quantity] [decimal](28, 8) NULL,
	[DiscountRate] [decimal](28, 8) NULL,
	[ObAddress] [nvarchar](250) NULL,
	[DivisionName] [nvarchar](250) NULL,
	[VATRate] [decimal](28, 8) NULL,
	[EndAmount] [decimal](28, 8) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[ObjectTel] [nvarchar](100) NULL,
	[ObjectFax] [nvarchar](100) NULL,
	[OrderID] [nvarchar](50) NULL,
	[VDescription] [nvarchar](250) NULL,
	[BDescription] [nvarchar](250) NULL,
	[TDescription] [nvarchar](250) NULL,
	CONSTRAINT [PK_AT3014] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT3014' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT3014'  and col.name = 'Ana04ID')
Alter Table  AT3014 Add Ana04ID nvarchar(50) Null,
					 Ana05ID nvarchar(50) Null,
					 Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End
