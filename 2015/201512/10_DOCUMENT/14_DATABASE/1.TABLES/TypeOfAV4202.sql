-- <Summary>
---- 
-- <History>
---- Create on 23/05/2013 by Bảo Quỳnh
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'TypeOfAV4202' AND ss.name = N'dbo')
CREATE TYPE [dbo].[TypeOfAV4202] AS TABLE(
	[ObjectID] [nvarchar](50) NULL,
	[CurrencyIDCN] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[InvoiceDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[DivisionID] [nvarchar](50) NULL,
	[AccountID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[CorAccountID] [nvarchar](50) NULL,
	[D_C] [nvarchar](50) NULL,
	[TransactionTypeID] [nvarchar](50) NULL
)



