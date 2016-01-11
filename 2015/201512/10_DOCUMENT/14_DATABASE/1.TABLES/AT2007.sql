-- <Summary>
---- Thông tin kho [Detail]
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on 27/04/2012 by Huỳnh Tấn Phú
---- Modified on 13/12/2012 by Bảo Anh
---- Modified on 07/10/2012 by Bảo Anh
---- Modified on 09/06/2014 by Thanh Sơn
---- Modified on 23/01/2014 by Thanh Sơn
---- Modified on 28/01/2013 by Bảo Anh
---- Modified on 21/08/2013 by Bảo Anh
---- Modified on 15/05/2012 by Việt Khánh
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2007]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2007](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[BatchID] [nvarchar](50) NULL,
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
	[PeriodID] [nvarchar](50) NULL,
	[ProductID] [nvarchar](50) NULL,
	[OrderID] [nvarchar](50) NULL,
	[InventoryName1] [nvarchar](250) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[OTransactionID] [nvarchar](50) NULL,
	[ReSPVoucherID] [nvarchar](50) NULL,
	[ReSPTransactionID] [nvarchar](50) NULL,
	[ETransactionID] [nvarchar](50) NULL,
	[MTransactionID] [nvarchar](50) NULL,
	[Parameter01] [decimal](28, 8) NULL,
	[Parameter02] [decimal](28, 8) NULL,
	[Parameter03] [decimal](28, 8) NULL,
	[Parameter04] [decimal](28, 8) NULL,
	[Parameter05] [decimal](28, 8) NULL,
	[ConvertedQuantity] [decimal](28, 8) NULL,
	[ConvertedPrice] [decimal](28, 8) NULL,
	[ConvertedUnitID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT2007] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2007_CurrencyID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2007] ADD  CONSTRAINT [DF_AT2007_CurrencyID]  DEFAULT ('VND') FOR [CurrencyID]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2007_ExchangeRate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2007] ADD  CONSTRAINT [DF_AT2007_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2007_Orders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2007] ADD  CONSTRAINT [DF_AT2007_Orders]  DEFAULT ((0)) FOR [Orders]
END
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT2007' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT2007' AND col.name='MOrderID')
		ALTER TABLE AT2007 ADD MOrderID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT2007' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT2007' AND col.name='SOrderID')
		ALTER TABLE AT2007 ADD SOrderID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT2007' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT2007' AND col.name='MTransactionID')
		ALTER TABLE AT2007 ADD MTransactionID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT2007' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT2007' AND col.name='STransactionID')
		ALTER TABLE AT2007 ADD STransactionID NVARCHAR(50) NULL
	END
If Exists (Select * From sysobjects Where name = 'AT2007' and xtype ='U') 
Begin
    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'OExpenseConvertedAmount')
    Alter Table  AT2007 Add OExpenseConvertedAmount Decimal(28,8) NULL
END
If Exists (Select * From sysobjects Where name = 'AT2007' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'WVoucherID')
           Alter Table  AT2007 Add WVoucherID NVARCHAR(50) NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='AT2007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT2007' AND col.name='StandardPrice')
	ALTER TABLE AT2007 ADD StandardPrice DECIMAL(28,8) DEFAULT (0) NULL
END

IF EXISTS (SELECT * FROM sysobjects WHERE NAME='AT2007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT2007' AND col.name='StandardAmount')
	ALTER TABLE AT2007 ADD StandardAmount DECIMAL(28,8) DEFAULT (0) NULL
END

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT2007' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT2007' AND col.name='InheritTableID')
		ALTER TABLE AT2007 ADD InheritTableID NVARCHAR(50) NULL
	END
	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT2007' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT2007' AND col.name='InheritVoucherID')
		ALTER TABLE AT2007 ADD InheritVoucherID VARCHAR(50) NULL
	END
	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT2007' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT2007' AND col.name='InheritTransactionID')
		ALTER TABLE AT2007 ADD InheritTransactionID VARCHAR(50) NULL
	END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='AT2007' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT2007' AND col.name='RefInfor')
	ALTER TABLE AT2007 ADD RefInfor NVARCHAR(250) NULL
END
If Exists (Select * From sysobjects Where name = 'AT2007' and xtype ='U') 
Begin
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes01')
        Alter Table  AT2007 Add Notes01 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes02')
        Alter Table  AT2007 Add Notes02 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes03')
        Alter Table  AT2007 Add Notes03 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes04')
        Alter Table  AT2007 Add Notes04 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes05')
        Alter Table  AT2007 Add Notes05 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes06')
        Alter Table  AT2007 Add Notes06 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes07')
        Alter Table  AT2007 Add Notes07 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes08')
        Alter Table  AT2007 Add Notes08 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes09')
        Alter Table  AT2007 Add Notes09 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes10')
        Alter Table  AT2007 Add Notes10 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes11')
        Alter Table  AT2007 Add Notes11 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes12')
        Alter Table  AT2007 Add Notes12 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes13')
        Alter Table  AT2007 Add Notes13 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes14')
        Alter Table  AT2007 Add Notes14 NVARCHAR(250) NULL           
        If not exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Notes15')
        Alter Table  AT2007 Add Notes15 NVARCHAR(250) NULL
END
If Exists (Select * From sysobjects Where name = 'AT2007' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'MarkQuantity')
           Alter Table  AT2007 Add MarkQuantity DECIMAL(28,8) NULL
END
If Exists (Select * From sysobjects Where name = 'AT2007' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'LocationCode')
           Alter Table  AT2007 Add LocationCode nvarchar(50) Null
END
If Exists (Select * From sysobjects Where name = 'AT2007' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Location01ID')
           Alter Table  AT2007 Add Location01ID nvarchar(50) Null
END
If Exists (Select * From sysobjects Where name = 'AT2007' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Location02ID')
           Alter Table  AT2007 Add Location02ID nvarchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'AT2007' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Location03ID')
           Alter Table  AT2007 Add Location03ID nvarchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'AT2007' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Location04ID')
           Alter Table  AT2007 Add Location04ID nvarchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'AT2007' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Location05ID')
           Alter Table  AT2007 Add Location05ID nvarchar(50) Null
END
If Exists (Select * From sysobjects Where name = 'AT2007' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT2007'  and col.name = 'Ana06ID')
Alter Table  AT2007 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End