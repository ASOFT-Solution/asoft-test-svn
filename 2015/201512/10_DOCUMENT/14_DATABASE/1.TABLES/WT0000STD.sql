-- <Summary>
---- 
-- <History>
---- Create on 13/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WT0000STD]') AND type in (N'U'))
CREATE TABLE [dbo].[WT0000STD](
	[DefTranMonth] [int] NULL,
	[DefTranYear] [int] NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[VATGroupID] [nvarchar](50) NULL,
	[IsNegativeStock] [tinyint] NOT NULL,
	[PaymentTermID] [nvarchar](50) NULL,
	[IsAsoftM] [tinyint] NOT NULL,
	[IsAsoftHRM] [tinyint] NOT NULL,
	[IsAsoftOP] [tinyint] NOT NULL,
	[PrimeCostAccountID] [nvarchar](50) NULL,
	[IsAutoSourceNo] [tinyint] NOT NULL,
	[IsCalUnitPrice] [tinyint] NOT NULL,
	[IsBarcode] [tinyint] NOT NULL,
	[IsConvertUnit] [tinyint] NOT NULL
) ON [PRIMARY]
