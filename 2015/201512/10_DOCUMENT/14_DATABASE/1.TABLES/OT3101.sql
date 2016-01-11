-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 11/10/2011 by Việt Khánh: Thêm cột PriceListID vào bảng OT3101
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT3101]') AND type in (N'U'))
CREATE TABLE [dbo].[OT3101](
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[ROrderID] [nvarchar](50) NOT NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[OrderDate] [datetime] NULL,
	[ClassifyID] [nvarchar](50) NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[OrderType] [tinyint] NULL,
	[ObjectID] [nvarchar](50) NULL,
	[ReceivedAddress] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	[Disabled] [tinyint] NULL,
	[OrderStatus] [tinyint] NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Transport] [nvarchar](100) NULL,
	[PaymentID] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[VATNo] [nvarchar](50) NULL,
	[Address] [nvarchar](250) NULL,
	[ShipDate] [datetime] NULL,
	[ContractNo] [nvarchar](50) NULL,
	[ContractDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[SOrderID] [nvarchar](50) NULL,
	[IsConfirm] [tinyint] NULL,
	[DescriptionConfirm] [nvarchar](250) NULL,
 CONSTRAINT [PK_OT3101] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'OT3101' AND xtype = 'U') 
BEGIN
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'OT3101' AND col.name = 'PriceListID')
    ALTER TABLE OT3101 ADD PriceListID NVARCHAR(50) NULL
END
If Exists (Select * From sysobjects Where name = 'OT3101' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'OT3101'  and col.name = 'Ana06ID')
Alter Table  OT3101 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__OT3101__APK__2B023E0E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT3101] ADD  CONSTRAINT [DF__OT3101__APK__2B023E0E]  DEFAULT (newid()) FOR [APK]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__OT3101__IsConfir__7978CB04]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT3101] ADD  CONSTRAINT [DF__OT3101__IsConfir__7978CB04]  DEFAULT ((0)) FOR [IsConfirm]
END