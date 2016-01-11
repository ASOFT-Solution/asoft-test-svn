-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7408]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7408](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[GroupID] [nvarchar](50) NULL,
	[BatchID] [nvarchar](50) NULL,
	[VoucherID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[Orders] [int] NULL,
	[RPTransactionType] [nvarchar](50) NULL,
	[TransactionTypeID] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[DebitAccountID] [nvarchar](50) NULL,
	[CreditAccountID] [nvarchar](50) NULL,
	[AccountID] [nvarchar](50) NULL,
	[AccountName] [nvarchar](250) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[Serial] [nvarchar](50) NULL,
	[VDescription] [nvarchar](250) NULL,
	[BDescription] [nvarchar](250) NULL,
	[TDescription] [nvarchar](250) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[CreateDate] [datetime] NULL,
	[SignConvertedAmount] [decimal](28, 8) NULL,
	[SignOriginalAmount] [decimal](28, 8) NULL,
	[DebitOriginalAmount] [decimal](28, 8) NULL,
	[CreditOriginalAmount] [decimal](28, 8) NULL,
	[DebitConvertedAmount] [decimal](28, 8) NULL,
	[CreditConvertedAmount] [decimal](28, 8) NULL,
	[OpeningOriginalAmount] [decimal](28, 8) NULL,
	[OpeningConvertedAmount] [decimal](28, 8) NULL,
	[ClosingOriginalAmount] [decimal](28, 8) NULL,
	[ClosingConvertedAmount] [decimal](28, 8) NULL,
	CONSTRAINT [PK_AT7408] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
