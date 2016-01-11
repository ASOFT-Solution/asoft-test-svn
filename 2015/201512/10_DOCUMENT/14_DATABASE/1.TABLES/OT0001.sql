-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT0001]') AND type in (N'U'))
CREATE TABLE [dbo].[OT0001](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TypeID] [nvarchar](50) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[OrderType] [tinyint] NULL,
	[ClassifyID] [nvarchar](50) NULL,
	[OrderStatus] [tinyint] NULL,
	[Notes] [nvarchar](250) NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[PaymentID] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[DeReAddress] [nvarchar](250) NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[ApportionType] [tinyint] NULL,
	[Is621] [tinyint] NULL,
	[Is622] [tinyint] NULL,
	[Is627] [tinyint] NULL,
	[DeReAddess] [nvarchar](250) NULL,
	CONSTRAINT [PK_OT0001] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'OT0001' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0001'  and col.name = 'SOCheckWH')
           Alter Table  OT0001 Add SOCheckWH tinyint  Null Default(0)         
End
If Exists (Select * From sysobjects Where name = 'OT0001' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OT0001'  and col.name = 'IsPermissionView')
           Alter Table  OT0001 Add IsPermissionView tinyint Not Null Default(0)
End 