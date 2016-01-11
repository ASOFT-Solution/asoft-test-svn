-- <Summary>
---- 
-- <History>
---- Create on 11/06/2014 by Lê Thị Thu Hiền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0280]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0280](
	[APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[AnaID] [nvarchar](50) NOT NULL,
	[VoucherDate] [datetime] NOT NULL,
	[SalesVoucherTypeID] [nvarchar](50) NOT NULL,	
	[SalesVoucherNo] [nvarchar](50) NULL,
	[SalesVDescription] [nvarchar](250) NULL,	
	[EmployeeID] [nvarchar](50) NULL,	
	[InvoiceCode] [nvarchar](50) NULL,
	[InvoiceSign] [nvarchar](50) NULL,
	[InvSerial] [nvarchar](50) NULL,
	[InvNo] [nvarchar](50) NULL,
	[InvDate] [datetime] NULL,
	[InvVATType] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[WareVoucherTypeID] [nvarchar](50) NULL,
	[WareVDescription] [nvarchar](250) NULL,
	[WareVoucherNo] [nvarchar](50) NULL,	
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,	
 CONSTRAINT [PK_AT0280] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[AnaID] ASC,
	[VoucherDate] ASC,
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]	
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT0280' and xtype ='U') 
Begin
 	If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT0280'  and col.name = 'VoucherID')
           Alter Table  AT0280 Add VoucherID nvarchar(50) Null
	If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT0280'  and col.name = 'EmployeeAnaTypeID')
           Alter Table  AT0280 Add EmployeeAnaTypeID nvarchar(50) Null
	If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT0280'  and col.name = 'ShopAnaTypeID')
           Alter Table  AT0280 Add ShopAnaTypeID nvarchar(50) Null
	If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT0280'  and col.name = 'ReturnVoucherTypeID')
           Alter Table  AT0280 Add ReturnVoucherTypeID nvarchar(50) Null
	If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT0280'  and col.name = 'ImWareVoucherTypeID')
           Alter Table  AT0280 Add ImWareVoucherTypeID nvarchar(50) Null
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT0280'  and col.name = 'ReturnVoucherNo')
	Alter Table  AT0280 Add ReturnVoucherNo nvarchar(50) Null
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT0280'  and col.name = 'ImWareVoucherNo')
	Alter Table  AT0280 Add ImWareVoucherNo nvarchar(50) Null
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT0280'  and col.name = 'ReturnVDescription')
	Alter Table  AT0280 Add ReturnVDescription nvarchar(250) Null
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT0280'  and col.name = 'ImWareVDescription')
	Alter Table  AT0280 Add ImWareVDescription nvarchar(250) Null
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT0280'  and col.name = 'CostAnaTypeID')
	Alter Table  AT0280 Add CostAnaTypeID nvarchar(50) Null
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT0280'  and col.name = 'CostAnaID')
	Alter Table  AT0280 Add CostAnaID nvarchar(50) Null
End
