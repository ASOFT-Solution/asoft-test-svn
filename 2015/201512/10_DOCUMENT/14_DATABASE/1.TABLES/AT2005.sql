-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2005]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2005](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[DetailOrderID] [nvarchar](50) NOT NULL,
	[OrderID] [nvarchar](50) NOT NULL,
	[InventoryID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[Quantity] [decimal](28, 8) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[Description] [nvarchar](250) NULL,
	[TotalAmount] [decimal](28, 8) NULL,
	[Discount] [decimal](28, 8) NULL,
	[DiscountTotalAmount] [decimal](28, 8) NULL,
	[Orders] [int] NULL,
	[ConversionFactor] [decimal](28, 8) NULL,
 CONSTRAINT [PK_AT2005] PRIMARY KEY NONCLUSTERED 
(
	[DetailOrderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


