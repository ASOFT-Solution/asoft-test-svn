-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified by Le Thi Thu Hien on 13/12/2011
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on 31/08/2015 by Tiểu Mai: Bổ sung cột Số lượng (cửa) QuoQuantity01 và 5 tham số Parameter
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT2102]') AND type in (N'U'))
CREATE TABLE [dbo].[OT2102](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[QuotationID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[QuoQuantity] [decimal](28, 8) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[VATPercent] [decimal](28, 8) NULL,
	[VATConvertedAmount] [decimal](28, 8) NULL,
	[VATOriginalAmount] [decimal](28, 8) NULL,
	[UnitID] [nvarchar](50) NULL,
	[Orders] [int] NULL,
	[DiscountPercent] [decimal](28, 8) NULL,
	[DiscountOriginalAmount] [decimal](28, 8) NULL,
	[DiscountConvertedAmount] [decimal](28, 8) NULL,
	[InventoryCommonName] [nvarchar](250) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Notes01] [nvarchar](250) NULL,
	[Notes02] [nvarchar](250) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[VATGroupID] [nvarchar](50) NULL,
	[finish] [tinyint] NULL,
	[ConvertedQuantity] [decimal](28, 8) NULL,
	[ConvertedSalePrice] [decimal](28, 8) NULL,
 CONSTRAINT [PK_OT2102] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'OT2102' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Parameter01')
           Alter Table  OT2102 Add Parameter01 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Parameter02')
           Alter Table  OT2102 Add Parameter02 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Parameter03')
           Alter Table  OT2102 Add Parameter03 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Parameter04')
           Alter Table  OT2102 Add Parameter04 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Parameter05')
           Alter Table  OT2102 Add Parameter05 decimal(28,8) NULL
END
If Exists (Select * From sysobjects Where name = 'OT2102' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'ConvertedSalepriceInput')
           Alter Table  OT2102 Add ConvertedSalepriceInput decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2102' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Parameter01')
           Alter Table  OT2102 Add Parameter01 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Parameter02')
           Alter Table  OT2102 Add Parameter02 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Parameter03')
           Alter Table  OT2102 Add Parameter03 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Parameter04')
           Alter Table  OT2102 Add Parameter04 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Parameter05')
           Alter Table  OT2102 Add Parameter05 decimal(28,8) NULL
END
If Exists (Select * From sysobjects Where name = 'OT2102' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'ReceiveDate')
           Alter Table  OT2102 Add ReceiveDate DateTime Null
End 
If Exists (Select * From sysobjects Where name = 'OT2102' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Barcode')
           Alter Table  OT2102 Add Barcode nvarchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2102' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Markup')
           Alter Table  OT2102 Add Markup DECIMAL(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'OT2102' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'OriginalAmountOutput')
           Alter Table  OT2102 Add OriginalAmountOutput decimal(28,8) Null
END
If Exists (Select * From sysobjects Where name = 'OT2102' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'Ana06ID')
Alter Table  OT2102 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
END
If Exists (Select * From sysobjects Where name = 'OT2102' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QuoQuantity01')
           Alter Table  OT2102 Add QuoQuantity01 decimal(28,8) Null
End
If Exists (Select * From sysobjects Where name = 'OT2102' and xtype ='U') 
BEGIN
			
			If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD01')
           Alter Table  OT2102 Add QD01 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD02')
           Alter Table  OT2102 Add QD02 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD03')
           Alter Table  OT2102 Add QD03 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD04')
           Alter Table  OT2102 Add QD04 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD05')
           Alter Table  OT2102 Add QD05 decimal(28,8) NULL			
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD06')
           Alter Table  OT2102 Add QD06 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD07')
           Alter Table  OT2102 Add QD07 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD08')
           Alter Table  OT2102 Add QD08 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD09')
           Alter Table  OT2102 Add QD09 decimal(28,8) NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD10')
           Alter Table  OT2102 Add QD10 decimal(28,8) NULL  
END
If Exists (Select * From sysobjects Where name = 'OT2102' and xtype ='U') 
BEGIN
			
			If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD01')
           Alter Table  OT2102 ALTER COLUMN QD01 NVARCHAR(100)           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD02')
           Alter Table  OT2102 ALTER COLUMN QD02 NVARCHAR(100)          
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD03')
           Alter Table  OT2102 ALTER COLUMN QD03 NVARCHAR(100)           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD04')
           Alter Table  OT2102 ALTER COLUMN QD04 NVARCHAR(100)           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD05')
           Alter Table  OT2102 ALTER COLUMN QD05 NVARCHAR(100)			
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD06')
           Alter Table  OT2102 ALTER COLUMN QD06 NVARCHAR(100)           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD07')
           Alter Table  OT2102 ALTER COLUMN QD07 NVARCHAR(100)           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD08')
           Alter Table  OT2102 ALTER COLUMN QD08 NVARCHAR(100)           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD09')
           Alter Table  OT2102 ALTER COLUMN QD09 NVARCHAR(100)           
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT2102'  and col.name = 'QD10')
           Alter Table  OT2102 ALTER COLUMN QD10 NVARCHAR(100)  
END