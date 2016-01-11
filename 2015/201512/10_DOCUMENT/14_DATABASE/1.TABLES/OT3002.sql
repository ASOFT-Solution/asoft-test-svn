-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT3002]') AND type in (N'U'))
CREATE TABLE [dbo].[OT3002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[POrderID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[MethodID] [nvarchar](50) NULL,
	[OrderQuantity] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[PurchasePrice] [decimal](28, 8) NULL,
	[VATPercent] [decimal](28, 8) NULL,
	[VATConvertedAmount] [decimal](28, 8) NULL,
	[DiscountPercent] [decimal](28, 8) NULL,
	[DiscountConvertedAmount] [decimal](28, 8) NULL,
	[IsPicking] [tinyint] NOT NULL,
	[Quantity01] [decimal](28, 8) NULL,
	[Quantity02] [decimal](28, 8) NULL,
	[Quantity03] [decimal](28, 8) NULL,
	[Quantity04] [decimal](28, 8) NULL,
	[Quantity05] [decimal](28, 8) NULL,
	[Quantity06] [decimal](28, 8) NULL,
	[Quantity07] [decimal](28, 8) NULL,
	[Quantity08] [decimal](28, 8) NULL,
	[Quantity09] [decimal](28, 8) NULL,
	[Quantity10] [decimal](28, 8) NULL,
	[Quantity11] [decimal](28, 8) NULL,
	[Quantity12] [decimal](28, 8) NULL,
	[Quantity13] [decimal](28, 8) NULL,
	[Quantity14] [decimal](28, 8) NULL,
	[Quantity15] [decimal](28, 8) NULL,
	[Quantity16] [decimal](28, 8) NULL,
	[Quantity17] [decimal](28, 8) NULL,
	[Quantity18] [decimal](28, 8) NULL,
	[Quantity19] [decimal](28, 8) NULL,
	[Quantity20] [decimal](28, 8) NULL,
	[Quantity21] [decimal](28, 8) NULL,
	[Quantity22] [decimal](28, 8) NULL,
	[Quantity23] [decimal](28, 8) NULL,
	[Quantity24] [decimal](28, 8) NULL,
	[Quantity25] [decimal](28, 8) NULL,
	[Quantity26] [decimal](28, 8) NULL,
	[Quantity27] [decimal](28, 8) NULL,
	[Quantity28] [decimal](28, 8) NULL,
	[Quantity29] [decimal](28, 8) NULL,
	[Quantity30] [decimal](28, 8) NULL,
	[WareHouseID] [nvarchar](50) NULL,
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
	[RefTransactionID] [nvarchar](50) NULL,
	[ROrderID] [nvarchar](50) NULL,
	[ConvertedQuantity] [decimal](28, 8) NULL,
	[ImTaxPercent] [decimal](28, 8) NULL,
	[ImTaxOriginalAmount] [decimal](28, 8) NULL,
	[ImTaxConvertedAmount] [decimal](28, 8) NULL,
	[ConvertedSalePrice] [decimal](28, 8) NULL,
	CONSTRAINT [PK_OT3002] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'ShipDate')
           Alter Table  OT3002 Add ShipDate DateTime Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'ReceiveDate')
           Alter Table  OT3002 Add ReceiveDate DateTime Null
End 
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'OT3002' AND xtype ='U') 
BEGIN
    IF NOT EXISTS (SELECT * FROM syscolumns c INNER JOIN sysobjects t 
    ON c.id = t.id WHERE t.name = 'OT3002' AND c.name = 'Parameter01')
    ALTER TABLE OT3002 ADD Parameter01 DECIMAL(28,8) NULL
    IF NOT EXISTS (SELECT * FROM syscolumns c INNER JOIN sysobjects t 
    ON c.id = t.id WHERE t.name = 'OT3002' AND c.name = 'Parameter02')
    ALTER TABLE OT3002 ADD Parameter02 DECIMAL(28,8) NULL
    IF NOT EXISTS (SELECT * FROM syscolumns c INNER JOIN sysobjects t 
    ON c.id = t.id WHERE t.name = 'OT3002' AND c.name = 'Parameter03')
    ALTER TABLE OT3002 ADD Parameter03 DECIMAL(28,8) NULL
    IF NOT EXISTS (SELECT * FROM syscolumns c INNER JOIN sysobjects t 
    ON c.id = t.id WHERE t.name = 'OT3002' AND c.name = 'Parameter04')
    ALTER TABLE OT3002 ADD Parameter04 DECIMAL(28,8) NULL
    IF NOT EXISTS (SELECT * FROM syscolumns c INNER JOIN sysobjects t 
    ON c.id = t.id WHERE t.name = 'OT3002' AND c.name = 'Parameter05')
    ALTER TABLE OT3002 ADD Parameter05 DECIMAL(28,8) NULL
END
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'Notes03')
           Alter Table  OT3002 Add Notes03 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'Notes04')
           Alter Table  OT3002 Add Notes04 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'Notes05')
           Alter Table  OT3002 Add Notes05 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'Notes06')
           Alter Table  OT3002 Add Notes06 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'Notes07')
           Alter Table  OT3002 Add Notes07 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'Notes08')
           Alter Table  OT3002 Add Notes08 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'Notes09')
           Alter Table  OT3002 Add Notes09 nvarchar(250) Null
End 
---- StrParameter01-->StrParameter20
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter01')
           Alter Table  OT3002 Add StrParameter01 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter02')
           Alter Table  OT3002 Add StrParameter02 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter03')
           Alter Table  OT3002 Add StrParameter03 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter04')
           Alter Table  OT3002 Add StrParameter04 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter05')
           Alter Table  OT3002 Add StrParameter05 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter06')
           Alter Table  OT3002 Add StrParameter06 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter07')
           Alter Table  OT3002 Add StrParameter07 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter08')
           Alter Table  OT3002 Add StrParameter08 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter09')
           Alter Table  OT3002 Add StrParameter09 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter10')
           Alter Table  OT3002 Add StrParameter10 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter11')
           Alter Table  OT3002 Add StrParameter11 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter12')
           Alter Table  OT3002 Add StrParameter12 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter13')
           Alter Table  OT3002 Add StrParameter13 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter14')
           Alter Table  OT3002 Add StrParameter14 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter15')
           Alter Table  OT3002 Add StrParameter15 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter16')
           Alter Table  OT3002 Add StrParameter16 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter17')
           Alter Table  OT3002 Add StrParameter17 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter18')
           Alter Table  OT3002 Add StrParameter18 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter19')
           Alter Table  OT3002 Add StrParameter19 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'StrParameter20')
           Alter Table  OT3002 Add StrParameter20 nvarchar(250) Null
End 
If Exists (Select * From sysobjects Where name = 'OT3002' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'OT3002'  and col.name = 'Ana06ID')
Alter Table  OT3002 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End