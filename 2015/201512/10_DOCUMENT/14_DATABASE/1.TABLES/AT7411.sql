-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on 21/09/2015 by Tiểu Mai: Add 2 columns: DebitAccountID, CreditAccountID
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7411]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7411](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[BatchID] [nvarchar](50) NULL,
	[VoucherID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[Serial] [nvarchar](50) NULL,
	[VDescription] [nvarchar](250) NULL,
	[BDescription] [nvarchar](250) NULL,
	[VoucherDate] [datetime] NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[OriginalTaxAmount] [decimal](28, 8) NULL,
	[ConvertedTaxAmount] [decimal](28, 8) NULL,
	[OriginalNetAmount] [decimal](28, 8) NULL,
	[ConvertedNetAmount] [decimal](28, 8) NULL,
	[SignNetAmount] [decimal](28, 8) NULL,
	[SignTaxAmount] [decimal](28, 8) NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[VATObjectID] [nvarchar](50) NULL,
	[VATNo] [nvarchar](50) NULL,
	[VATObjectName] [nvarchar](250) NULL,
	[ObjectAddress] [nvarchar](250) NULL,
	[VATGroupID] [nvarchar](50) NULL,
	[VATTypeID] [nvarchar](50) NULL,
	[CreateUserID] [varbinary](50) NULL,
	[VATRate] [nvarchar](50) NULL,
	[Quantity] [decimal](28, 8) NULL,
	[DueDate] [datetime] NULL,
	[VATTradeName] [nvarchar](250) NULL,
	[InvoiceCode] [nvarchar](50) NULL,
	[InvoiceSign] [nvarchar](50) NULL,
	CONSTRAINT [PK_AT7411] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

-- Add columns
If Exists (Select * From sysobjects Where name = 'AT7411' and xtype ='U') 
BEGIN
	If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7411'  and col.name = 'DebitAccountID')
           Alter Table  AT7411 Add DebitAccountID NVARCHAR(50) NULL
    If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7411'  and col.name = 'CreditAccountID')
           Alter Table  AT7411 Add CreditAccountID NVARCHAR(50) NULL       
END
