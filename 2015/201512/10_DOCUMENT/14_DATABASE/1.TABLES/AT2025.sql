-- <Summary>
---- 
-- <History>
---- Create on 28/02/2011 by Phát Danh
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2025]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2025](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[WareHouseID] [nvarchar](50) NOT NULL,
	[WareHouseName] [nvarchar](250) NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[Orders] [nvarchar](250) NOT NULL,
	[VoucherDate] [datetime] NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[AccountID] [nvarchar](50) NULL,
	[AccountName] [nvarchar](250) NULL,
	[CorAccountID] [nvarchar](50) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[ImQuantity] [decimal](28, 8) NULL,
	[ImConvertedAmount] [decimal](28, 8) NULL,
	[ImOriginalAmount] [decimal](28, 8) NULL,
	[ExQuantity] [decimal](28, 8) NULL,
	[ExConvertedAmount] [decimal](28, 8) NULL,
	[ExOriginalAmount] [decimal](28, 8) NULL,
	[Description] [nvarchar](250) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[InventoryName] [nvarchar](250) NULL,
	[UnitID] [nvarchar](50) NULL,
	[BeginQuantity] [decimal](28, 8) NULL,
	[BeginAmount] [decimal](28, 8) NULL,
	[EndQuantity] [decimal](28, 8) NULL,
	[EndAmount] [decimal](28, 8) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	CONSTRAINT [PK_AT2025] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC, 
	[DivisionID] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT2025' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT2025'  and col.name = 'Ana06ID')
Alter Table  AT2025 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End