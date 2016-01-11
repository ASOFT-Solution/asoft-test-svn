-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1690]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1690](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[BatchID] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[TableID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[TransactionTypeID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[CreditObjectID] [nvarchar](50) NULL,
	[VATNo] [nvarchar](50) NULL,
	[VATObjectID] [nvarchar](50) NULL,
	[VATObjectName] [nvarchar](250) NULL,
	[VATObjectAddress] [nvarchar](250) NULL,
	[DebitAccountID] [nvarchar](50) NULL,
	[CreditAccountID] [nvarchar](50) NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[ImTaxOriginalAmount] [decimal](28, 8) NULL,
	[ImTaxConvertedAmount] [decimal](28, 8) NULL,
	[ExpenseOriginalAmount] [decimal](28, 8) NULL,
	[ExpenseConvertedAmount] [decimal](28, 8) NULL,
	[IsStock] [tinyint] NOT NULL,
	[VoucherDate] [datetime] NULL,
	[InvoiceDate] [datetime] NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[VATTypeID] [nvarchar](50) NULL,
	[VATGroupID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[Serial] [nvarchar](50) NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[Orders] [int] NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[SenderReceiver] [nvarchar](100) NULL,
	[SRDivisionName] [nvarchar](250) NULL,
	[SRAddress] [nvarchar](250) NULL,
	[RefNo01] [nvarchar](100) NULL,
	[RefNo02] [nvarchar](100) NULL,
	[VDescription] [nvarchar](250) NULL,
	[BDescription] [nvarchar](250) NULL,
	[TDescription] [nvarchar](250) NULL,
	[Quantity] [decimal](28, 8) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[IsAudit] [tinyint] NOT NULL,
	[IsCost] [tinyint] NOT NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[PeriodID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[ProductID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[OriginalAmountCN] [decimal](28, 8) NULL,
	[ExchangeRateCN] [decimal](28, 8) NULL,
	[CurrencyIDCN] [nvarchar](50) NULL,
	[DueDays] [int] NULL,
	[PaymentID] [nvarchar](50) NULL,
	[DueDate] [datetime] NULL,
	[DiscountRate] [decimal](28, 8) NULL,
	[OrderID] [nvarchar](50) NULL,
	[CreditBankAccountID] [nvarchar](50) NULL,
	[DebitBankAccountID] [nvarchar](50) NULL,
	[CommissionPercent] [decimal](28, 8) NULL,
	[InventoryName1] [nvarchar](250) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1690] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC,
	[TableID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT1690' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT1690'  and col.name = 'Ana06ID')
Alter Table  AT1690 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End
