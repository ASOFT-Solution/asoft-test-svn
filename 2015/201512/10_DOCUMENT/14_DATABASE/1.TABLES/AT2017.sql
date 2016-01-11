-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on 03/09/2013 by Khánh Vân
---- Modified on 28/01/2013 by Bảo Anh
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2017]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2017](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[UnitID] [nvarchar](50) NULL,
	[ActualQuantity] [decimal](28, 8) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[SaleUnitPrice] [decimal](28, 8) NULL,
	[SaleAmount] [decimal](28, 8) NULL,
	[DiscountAmount] [decimal](28, 8) NULL,
	[SourceNo] [nvarchar](50) NULL,
	[DebitAccountID] [nvarchar](50) NULL,
	[CreditAccountID] [nvarchar](50) NULL,
	[LocationID] [nvarchar](50) NULL,
	[ImLocationID] [nvarchar](50) NULL,
	[LimitDate] [datetime] NULL,
	[Orders] [int] NOT NULL,
	[ConversionFactor] [decimal](28, 8) NULL,
	[ReTransactionID] [nvarchar](50) NULL,
	[ReVoucherID] [nvarchar](50) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[Parameter01] [decimal](28, 8) NULL,
	[Parameter02] [decimal](28, 8) NULL,
	[Parameter03] [decimal](28, 8) NULL,
	[Parameter04] [decimal](28, 8) NULL,
	[Parameter05] [decimal](28, 8) NULL,
	[ConvertedQuantity] [decimal](28, 8) NULL,
	[ConvertedPrice] [decimal](28, 8) NULL,
	[ConvertedUnitID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT2017] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2017_CurrencyID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2017] ADD  CONSTRAINT [DF_AT2017_CurrencyID]  DEFAULT ('VND') FOR [CurrencyID]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2017_ExchangeRate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2017] ADD  CONSTRAINT [DF_AT2017_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2017_Orders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2017] ADD  CONSTRAINT [DF_AT2017_Orders]  DEFAULT ((0)) FOR [Orders]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT2017' and xtype ='U') 
Begin
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes01')
        Alter Table  AT2017 Add Notes01 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes02')
        Alter Table  AT2017 Add Notes02 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes03')
        Alter Table  AT2017 Add Notes03 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes04')
        Alter Table  AT2017 Add Notes04 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes05')
        Alter Table  AT2017 Add Notes05 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes06')
        Alter Table  AT2017 Add Notes06 NVARCHAR(250) NULL
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes07')
        Alter Table  AT2017 Add Notes07 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes08')
        Alter Table  AT2017 Add Notes08 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes09')
        Alter Table  AT2017 Add Notes09 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes10')
        Alter Table  AT2017 Add Notes10 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes11')
        Alter Table  AT2017 Add Notes11 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes12')
        Alter Table  AT2017 Add Notes12 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes13')
        Alter Table  AT2017 Add Notes13 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes14')
        Alter Table  AT2017 Add Notes14 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Notes15')
        Alter Table  AT2017 Add Notes15 NVARCHAR(250) NULL
END
If Exists (Select * From sysobjects Where name = 'AT2017' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'MarkQuantity')
           Alter Table  AT2017 Add MarkQuantity DECIMAL(28,8) NULL          
End
If Exists (Select * From sysobjects Where name = 'AT2017' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT2017'  and col.name = 'Ana06ID')
Alter Table  AT2017 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End