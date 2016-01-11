-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 21/03/2014 by Bảo Anh: Xoa field InventoryIDSNL
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1302]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1302](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[DetailID] [nvarchar](50) NOT NULL,
	[ID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[MinPrice] [decimal](28, 8) NULL,
	[MaxPrice] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[Orders] [int] NULL,
	[Notes01] [nvarchar](250) NULL,
	[Notes02] [nvarchar](250) NULL,
	[DiscountPercent] [decimal](28, 8) NULL,
	[DiscountAmount] [decimal](28, 8) NULL,
	[SaleOffPercent01] [decimal](28, 8) NULL,
	[SaleOffAmount01] [decimal](28, 8) NULL,
	[SaleOffPercent02] [decimal](28, 8) NULL,
	[SaleOffAmount02] [decimal](28, 8) NULL,
	[SaleOffPercent03] [decimal](28, 8) NULL,
	[SaleOffAmount03] [decimal](28, 8) NULL,
	[SaleOffPercent04] [decimal](28, 8) NULL,
	[SaleOffAmount04] [decimal](28, 8) NULL,
	[SaleOffPercent05] [decimal](28, 8) NULL,
	[SaleOffAmount05] [decimal](28, 8) NULL,
 CONSTRAINT [PK_OT1302] PRIMARY KEY CLUSTERED 
(
	[DetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'OT1302' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT1302'  and col.name = 'ConvertedUnitPrice')
           Alter Table  OT1302 Add ConvertedUnitPrice decimal NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT1302'  and col.name = 'ConvertedMinPrice')
           Alter Table  OT1302 Add ConvertedMinPrice decimal NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT1302'  and col.name = 'ConvertedMaxPrice')
           Alter Table  OT1302 Add ConvertedMaxPrice decimal NULL           
End
If Exists (Select * From sysobjects Where name = 'OT1302' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT1302'  and col.name = 'ConvertedUnitPrice')
           Alter Table  OT1302 Add ConvertedUnitPrice decimal NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT1302'  and col.name = 'ConvertedMinPrice')
           Alter Table  OT1302 Add ConvertedMinPrice decimal NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT1302'  and col.name = 'ConvertedMaxPrice')
           Alter Table  OT1302 Add ConvertedMaxPrice decimal NULL           
           --- Modify on 16/01/2014 by Bao Anh: customize cho Sinolife       
		   If not exists (select * from syscolumns col inner join sysobjects tab 
		   On col.id = tab.id where tab.name =   'OT1302'  and col.name = 'PaymentID')
		   Alter Table  OT1302 Add PaymentID nvarchar(50) Null
		   --- Modify on 17/02/2014 by Bao Anh: customize cho Sinolife (dùng MPT8 làm mặt hàng)
		   If not exists (select * from syscolumns col inner join sysobjects tab 
		   On col.id = tab.id where tab.name =   'OT1302'  and col.name = 'InventoryIDSNL')
		   Alter Table  OT1302 Add InventoryIDSNL nvarchar(50) Null

		    --- Modify on 09/09/2015 by Thanh Thinh: customize cho ABA Thêm Cột Phí Trả Khay
		   If not exists (select * from syscolumns col inner join sysobjects tab 
		   On col.id = tab.id where tab.name =   'OT1302'  and col.name = 'TrayPrice')
		   Alter Table  OT1302 Add TrayPrice decimal Null
		   --- Modify on 09/09/2015 by Thanh Thinh: customize cho ABA Thêm Cột Phí Rớt Điểm Khay
		   If not exists (select * from syscolumns col inner join sysobjects tab 
		   On col.id = tab.id where tab.name =   'OT1302'  and col.name = 'DecreaseTrayPrice')
		   Alter Table  OT1302 Add DecreaseTrayPrice decimal Null
END
---- Alter Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='OT1302' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='OT1302' AND col.name='ConvertedUnitPrice')
		ALTER TABLE OT1302 ALTER COLUMN ConvertedUnitPrice DECIMAL(28,8) NULL 
	END	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='OT1302' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='OT1302' AND col.name='ConvertedMinPrice')
		ALTER TABLE OT1302 ALTER COLUMN ConvertedMinPrice DECIMAL(28,8) NULL 
	END	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='OT1302' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='OT1302' AND col.name='ConvertedMaxPrice')
		ALTER TABLE OT1302 ALTER COLUMN ConvertedMaxPrice DECIMAL(28,8) NULL 
	END
---- Drop Columns
If Exists (Select * From sysobjects Where name = 'OT1302' and xtype ='U') 
Begin
        If exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'OT1302'  and col.name = 'InventoryIDSNL')
			Alter table OT1302 drop column InventoryIDSNL
End