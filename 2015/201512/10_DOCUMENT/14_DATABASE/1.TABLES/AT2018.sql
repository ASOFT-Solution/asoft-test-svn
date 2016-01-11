-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2018]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2018](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[WareHouseID] [nvarchar](50) NOT NULL,
	[WareHouseName] [nvarchar](250) NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[Orders] [nvarchar](250) NULL,
	[VoucherDate] [datetime] NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[ImVoucherDate] [datetime] NULL,
	[ImVoucherNo] [nvarchar](50) NULL,
	[ImSourceNo] [nvarchar](50) NULL,
	[ImWareHouseID] [nvarchar](50) NULL,
	[ImQuantity] [decimal](28, 8) NULL,
	[ImUnitPrice] [decimal](28, 8) NULL,
	[ImConvertedAmount] [decimal](28, 8) NULL,
	[ImOriginalAmount] [decimal](28, 8) NULL,
	[ImConvertedQuantity] [decimal](28, 8) NULL,
	[ExVoucherDate] [datetime] NULL,
	[ExVoucherNo] [nvarchar](50) NULL,
	[ExSourceNo] [nvarchar](50) NULL,
	[ExWareHouseID] [nvarchar](50) NULL,
	[ExQuantity] [decimal](28, 8) NULL,
	[ExUnitPrice] [decimal](28, 8) NULL,
	[ExConvertedAmount] [decimal](28, 8) NULL,
	[ExOriginalAmount] [decimal](28, 8) NULL,
	[ExConvertedQuantity] [decimal](28, 8) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[InventoryName] [nvarchar](250) NULL,
	[UnitID] [nvarchar](50) NULL,
	[ConversionFactor] [decimal](28, 8) NULL,
	[ConversionUnitID] [nvarchar](50) NULL,
	[ConversionFactor2] [decimal](28, 8) NULL,
	[Operator] [tinyint] NULL,
	[BeginQuantity] [decimal](28, 8) NULL,
	[BeginAmount] [decimal](28, 8) NULL,
	[EndQuantity] [decimal](28, 8) NULL,
	[EndAmount] [decimal](28, 8) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[Ana01Name] [nvarchar](250) NULL,
	[Ana02Name] [nvarchar](250) NULL,
	[Ana03Name] [nvarchar](250) NULL,
	[Ana04Name] [nvarchar](250) NULL,
	[Ana05Name] [nvarchar](250) NULL,
	[Notes01] [nvarchar](250) NULL,
	CONSTRAINT [PK_AT2018] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT2018' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT2018'  and col.name = 'Ana06ID')
Alter Table  AT2018 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End
If Exists (Select * From sysobjects Where name = 'AT2018' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT2018'  and col.name = 'Ana06Name')
Alter Table  AT2018 Add Ana06Name nvarchar(50) Null,
					 Ana07Name nvarchar(50) Null,
					 Ana08Name nvarchar(50) Null,
					 Ana09Name nvarchar(50) Null,
					 Ana10Name nvarchar(50) Null
End