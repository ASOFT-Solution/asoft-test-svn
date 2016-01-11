-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT5559]') AND type in (N'U'))
CREATE TABLE [dbo].[AT5559](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[OrderID] [nvarchar](50) NOT NULL,
	[Product_ID] [nvarchar](50) NULL,
	[Quantity] [float] NULL,
	[Price] [decimal](28, 8) NULL,
	[Discount] [float] NULL,
	[QunitofTrans] [float] NULL,
	[transcharge] [decimal](28, 8) NULL,
	[Store_ID] [nvarchar](50) NULL,
	[Unit] [nvarchar](50) NULL,
	[Quidoi] [float] NULL,
	[QuantityOrder] [float] NULL,
	[PriceOrder] [decimal](28, 8) NULL,
	[HScode] [nvarchar](50) NULL,
	[Origin] [nvarchar](50) NULL,
	[FreeTax] [decimal](28, 8) NULL,
	[VAT] [float] NULL,
	[TaxTTDB] [float] NULL,
	[TaxNK] [float] NULL,
	[IsTax] [tinyint] NULL,
	[tysuat] [float] NULL,
	[Paytax] [decimal](28, 8) NULL,
	[isKM] [tinyint] NULL,
	CONSTRAINT [PK_AT5559] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
