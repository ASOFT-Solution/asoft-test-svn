-- <Summary>
---- Bang tam insert du lieu - Báo cáo thuế: Không tạo trong store in dữ liệu mà đưa ra ngoài riêng
-- <History>
---- Create on 14/02/2014 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT7419]') AND TYPE IN (N'U'))
DROP TABLE AT7419
CREATE TABLE [dbo].[AT7419] (
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar] (50) NULL ,
	[VoucherID] [nvarchar] (50) NOT NULL ,
	[BatchID] [nvarchar] (50) NOT NULL ,
	[TransactionID] [nvarchar] (50) NOT NULL ,
	[TransactionTypeID] [nvarchar] (50) NOT NULL ,
	[AccountID] [nvarchar] (50) NULL ,
	[CorAccountID] [nvarchar] (50) NOT NULL ,
	[D_C] [nvarchar] (1) NOT NULL ,
	[DebitAccountID] [nvarchar] (50) NULL ,
	[CreditAccountID] [nvarchar] (50) NULL ,
	[VoucherDate] [datetime] NULL ,
	[VoucherTypeID] [nvarchar] (50) NULL ,
	[VoucherNo] [nvarchar] (50) NULL ,
	[InvoiceDate] [datetime] NULL ,
	[InvoiceNo] [nvarchar] (50)  NULL ,
	[Serial] [nvarchar] (50)  NULL ,
	[ConvertedAmount] [decimal](28, 8) NULL ,
	[OriginalAmount] [decimal](28, 8) NULL ,
	[ImTaxConvertedAmount] [decimal](28, 8) NULL ,
	[ImTaxOriginalAmount] [decimal](28, 8) NULL ,
	[CurrencyID] [nvarchar] (50) NULL ,
	[Quantity] [decimal](28, 8) NULL ,
	[ExchangeRate] [decimal](28, 8) NULL ,
	[SignAmount] [decimal](28, 8) NULL ,
	[OSignAmount] [decimal](28, 8) NULL ,
	[TranMonth] [int] NULL ,
	[TranYear] [int] NULL ,
	[CreateUserID] [nvarchar] (50) NULL ,
	[VDescription] [nvarchar] (250) NULL ,
	[BDescription] [nvarchar] (250) NULL ,
	[TDescription] [nvarchar] (250) NULL ,
	[ObjectID] [nvarchar] (50) NULL ,
	[VATObjectID] [nvarchar] (50) NULL ,
	[VATNo] [nvarchar] (50) NULL ,
	[VATObjectName] [nvarchar] (250) NULL ,
	[ObjectAddress] [nvarchar] (250) NULL ,
	[VATTypeID] [nvarchar] (50) NULL ,
	[VATGroupID] [nvarchar] (50) NULL,
	[DueDate] [datetime] NULL,
	[InvoiceCode] NVARCHAR(50) NULL,
	[InvoiceSign] NVARCHAR(50) NULL 
CONSTRAINT [PK_AT7419] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]			 
) ON [PRIMARY]

