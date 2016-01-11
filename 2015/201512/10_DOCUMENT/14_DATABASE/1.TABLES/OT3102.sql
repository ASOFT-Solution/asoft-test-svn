-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT3102]') AND type in (N'U'))
CREATE TABLE [dbo].[OT3102](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[ROrderID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[RequestPrice] [decimal](28, 8) NULL,
	[OrderQuantity] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[VATPercent] [decimal](28, 8) NULL,
	[VATConvertedAmount] [decimal](28, 8) NULL,
	[DiscountPercent] [decimal](28, 8) NULL,
	[DiscountConvertedAmount] [decimal](28, 8) NULL,
	[DiscountOriginalAmount] [decimal](28, 8) NULL,
	[VATOriginalAmount] [decimal](28, 8) NULL,
	[Orders] [int] NULL,
	[Description] [nvarchar](250) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[AdjustQuantity] [decimal](28, 8) NULL,
	[InventoryCommonName] [nvarchar](250) NULL,
	[UnitID] [nvarchar](50) NULL,
	[Finish] [tinyint] NULL,
	[Notes] [nvarchar](250) NULL,
	[Notes01] [nvarchar](250) NULL,
	[Notes02] [nvarchar](250) NULL,
	[PriceList] [decimal](28, 8) NULL,
	[ConvertedQuantity] [decimal](28, 8) NULL,
	[ConvertedSalePrice] [decimal](28, 8) NULL,
	[RefTransactionID] [nvarchar](50) NULL,
	CONSTRAINT [PK_OT3102] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'OT3102' AND xtype ='U') 
BEGIN
    IF NOT EXISTS (SELECT * FROM syscolumns c INNER JOIN sysobjects t 
    ON c.id = t.id WHERE t.name = 'OT3102' AND c.name = 'Parameter01')
    ALTER TABLE OT3102 ADD Parameter01 DECIMAL(28,8) NULL
    IF NOT EXISTS (SELECT * FROM syscolumns c INNER JOIN sysobjects t 
    ON c.id = t.id WHERE t.name = 'OT3102' AND c.name = 'Parameter02')
    ALTER TABLE OT3102 ADD Parameter02 DECIMAL(28,8) NULL
    IF NOT EXISTS (SELECT * FROM syscolumns c INNER JOIN sysobjects t 
    ON c.id = t.id WHERE t.name = 'OT3102' AND c.name = 'Parameter03')
    ALTER TABLE OT3102 ADD Parameter03 DECIMAL(28,8) NULL
    IF NOT EXISTS (SELECT * FROM syscolumns c INNER JOIN sysobjects t 
    ON c.id = t.id WHERE t.name = 'OT3102' AND c.name = 'Parameter04')
    ALTER TABLE OT3102 ADD Parameter04 DECIMAL(28,8) NULL
    IF NOT EXISTS (SELECT * FROM syscolumns c INNER JOIN sysobjects t 
    ON c.id = t.id WHERE t.name = 'OT3102' AND c.name = 'Parameter05')
    ALTER TABLE OT3102 ADD Parameter05 DECIMAL(28,8) NULL
End
If Exists (Select * From sysobjects Where name = 'OT3102' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'OT3102'  and col.name = 'Ana06ID')
Alter Table  OT3102 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End