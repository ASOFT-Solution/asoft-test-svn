-- <Summary>
---- 
-- <History>
---- Create on 09/06/2014 by Huỳnh Tấn Phú
---- Modified on 06/08/2013 by Nguyen Thanh Son
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CST2024]') AND type in (N'U')) 	
BEGIN
CREATE TABLE [dbo].[CST2024](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[OrderNo] [int] NULL,
	[InventoryID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[Quantity] [decimal](28, 8) NULL,
	[Price] [decimal](28, 8) NULL,
	[Amount] [decimal](28, 8) NULL,
	[IsRepair] [tinyint] NULL,
	[INotes] [nvarchar](250) NULL,
 CONSTRAINT [PK_CST2024] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[VoucherID] ASC,
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add Columns
--Thêm cột VATGroupID vào CST2024
If Exists (Select * From sysobjects Where name = 'CST2024' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'CST2024'  and col.name = 'VATGroupID')
           Alter Table  CST2024 Add VATGroupID nvarchar(50) Null
End 
--Thêm cột VATAmount vào CST2024
If Exists (Select * From sysobjects Where name = 'CST2024' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'CST2024'  and col.name = 'VATAmount')
           Alter Table  CST2024 Add VATAmount decimal(28,8) Null
End 
--Thêm cột ConvertedAmount vào CST2024
If Exists (Select * From sysobjects Where name = 'CST2024' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'CST2024'  and col.name = 'ConvertedAmount')
           Alter Table  CST2024 Add ConvertedAmount decimal(28,8) Null
End