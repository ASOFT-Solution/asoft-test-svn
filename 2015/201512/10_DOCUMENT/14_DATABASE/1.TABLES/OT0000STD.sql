-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT0000STD]') AND type in (N'U'))
CREATE TABLE [dbo].[OT0000STD](
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[ConvertDecimal] [tinyint] NULL,
	[UnitPriceDecimal] [tinyint] NULL,
	[PercentDecimal] [tinyint] NULL,
	[QuantityDecimal] [tinyint] NULL,
	[IsDiscount] [tinyint] NULL,
	[IsCommission] [tinyint] NULL,
	[IsInventoryCommonName] [tinyint] NULL,
	[IsNotRepeatLinkNo] [tinyint] NULL,
	[IsPriceControl] [tinyint] NULL,
	[IsQuantityControl] [tinyint] NULL,
	[OPriceTypeID] [nvarchar](50) NULL,
	[IsPicking] [tinyint] NULL,
	[MaterialRate] [decimal](28, 8) NULL,
	[IsNotDebit] [tinyint] NULL,
	[IsConvertUnit] [tinyint] NULL,
	[IsLockSalePrice] [tinyint] NULL,
	[IsBarcode] [tinyint] NULL,
	[IsSaleOff] [int] NOT NULL,
	[IsConfirm] [tinyint] NOT NULL,
	[IsUpdateOStatus] [tinyint] NOT NULL
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'OT0000STD' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0000STD'  and col.name = 'IsQuantityPrice')
           Alter Table  OT0000STD Add IsQuantityPrice tinyint Null
End