-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7111]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7111](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[VoucherID] [nvarchar](50) NULL,
	[BatchID] [nvarchar](50) NULL,
	[TransactionID] [nvarchar](50) NULL,
	[Orders] [int] NULL,
	[TransactionTypeID] [nvarchar](50) NULL,
	[AccountID] [nvarchar](50) NULL,
	[CorAccountID] [nvarchar](50) NULL,
	[D_C] [nvarchar](100) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[VoucherDate] [datetime] NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[Serial] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[SignAmount] [decimal](28, 8) NULL,
	[OSignAmount] [decimal](28, 8) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[Description] [nvarchar](250) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[OpeningAmount] [decimal](28, 8) NULL,
	[ClosingAmount] [decimal](28, 8) NULL,
	[AccountName] [nvarchar](250) NULL,
	[ReportAccountID] [nvarchar](50) NULL,
	CONSTRAINT [PK_AT7111] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
