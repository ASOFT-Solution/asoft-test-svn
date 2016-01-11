-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on 16/01/2013 by Le Thi Thu Hien : Bổ sung trường DiscountAmount1-> DiscountAmount10 cho bảng giá bậc thang
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT0117]') AND type in (N'U')) 	
BEGIN	
CREATE TABLE [dbo].[OT0117](
	[APK] [uniqueidentifier] NOT NULL CONSTRAINT [DF_OT0117_APK] DEFAULT newid(),
	[DivisionID] [nvarchar](50) NOT NULL,
	[ID] [nvarchar](50) NOT NULL,	
	[InventoryID] [nvarchar](50) NOT NULL,
	[UnitID] [nvarchar](50) NULL,
	[FromQuantity1] [decimal](28, 8) NULL,
	[ToQuantity1] [decimal](28, 8) NULL,
	[Price1] [decimal](28, 8) NULL,
	[FromQuantity2] [decimal](28, 8) NULL,
	[ToQuantity2] [decimal](28, 8) NULL,
	[Price2] [decimal](28, 8) NULL,
	[FromQuantity3] [decimal](28, 8) NULL,
	[ToQuantity3] [decimal](28, 8) NULL,
	[Price3] [decimal](28, 8) NULL,
	[FromQuantity4] [decimal](28, 8)  NULL,
	[ToQuantity4] [decimal](28, 8) NULL,
	[Price4] [decimal](28, 8) NULL,
	[FromQuantity5] [decimal](28, 8)  NULL,
	[ToQuantity5] [decimal](28, 8) NULL,
	[Price5] [decimal](28, 8) NULL,
	[FromQuantity6] [decimal](28, 8)  NULL,
	[ToQuantity6] [decimal](28, 8) NULL,
	[Price6] [decimal](28, 8) NULL,
	[FromQuantity7] [decimal](28, 8)  NULL,
	[ToQuantity7] [decimal](28, 8) NULL,
	[Price7] [decimal](28, 8) NULL,
	[FromQuantity8] [decimal](28, 8)  NULL,
	[ToQuantity8] [decimal](28, 8) NULL,
	[Price8] [decimal](28, 8) NULL,
	[FromQuantity9] [decimal](28, 8)  NULL,
	[ToQuantity9] [decimal](28, 8) NULL,
	[Price9] [decimal](28, 8) NULL,
	[FromQuantity10] [decimal](28, 8)  NULL,
	[ToQuantity10] [decimal](28, 8) NULL,
	[Price10] [decimal](28, 8) NULL,
	[Price] [decimal](28, 8) NULL,
	[Discount] [decimal](28, 8)  NULL,
	[Disabled] [Tinyint] NULL,

 CONSTRAINT [PK_OT0117] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[ID] ASC,
	[InventoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'OT0117' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0117'  and col.name = 'DiscountAmount1')
           Alter Table  OT0117 Add DiscountAmount1 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'OT0117' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0117'  and col.name = 'DiscountAmount2')
           Alter Table  OT0117 Add DiscountAmount2 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'OT0117' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0117'  and col.name = 'DiscountAmount3')
           Alter Table  OT0117 Add DiscountAmount3 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'OT0117' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0117'  and col.name = 'DiscountAmount4')
           Alter Table  OT0117 Add DiscountAmount4 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'OT0117' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0117'  and col.name = 'DiscountAmount5')
           Alter Table  OT0117 Add DiscountAmount5 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'OT0117' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0117'  and col.name = 'DiscountAmount6')
           Alter Table  OT0117 Add DiscountAmount6 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'OT0117' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0117'  and col.name = 'DiscountAmount7')
           Alter Table  OT0117 Add DiscountAmount7 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'OT0117' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0117'  and col.name = 'DiscountAmount8')
           Alter Table  OT0117 Add DiscountAmount8 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'OT0117' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0117'  and col.name = 'DiscountAmount9')
           Alter Table  OT0117 Add DiscountAmount9 decimal(28,8) Null
End 
If Exists (Select * From sysobjects Where name = 'OT0117' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0117'  and col.name = 'DiscountAmount10')
           Alter Table  OT0117 Add DiscountAmount10 decimal(28,8) Null
End 