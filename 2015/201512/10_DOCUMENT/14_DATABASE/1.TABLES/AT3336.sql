-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT3336]') AND type in (N'U'))
CREATE TABLE [dbo].[AT3336](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[HideID] [nvarchar](50) NOT NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[Serial] [nvarchar](50) NULL,
	[ClientName] [nvarchar](250) NULL,
	[DepID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[SpecialTaxPercent] [decimal](28, 8) NULL,
	[VATPercent] [decimal](28, 8) NULL,
	[ServiceChargePercent] [decimal](28, 8) NULL,
	[RoomNo] [nvarchar](50) NULL,
	[RegisterNo] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[CIDate] [datetime] NULL,
	[CODate] [datetime] NULL,
 CONSTRAINT [PK_AT3336] PRIMARY KEY CLUSTERED 
(
	[HideID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
