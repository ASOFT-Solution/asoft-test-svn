-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1703]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1703](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[JobID] [nvarchar](50) NOT NULL,
	[JobName] [nvarchar](250) NULL,
	[SerialNo] [nvarchar](50) NULL,
	[CreditAccountID] [nvarchar](50) NULL,
	[DebitAccountID] [nvarchar](50) NULL,
	[Periods] [int] NULL,
	[APercent] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[BeginMonth] [int] NOT NULL,
	[BeginYear] [int] NOT NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[Description] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[D_C] [nvarchar](100) NOT NULL,
	[UseStatus] [int] NOT NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[DepMonths] [int] NULL,
	[ResidualMonths] [int] NULL,
	[DepValue] [decimal](28, 8) NULL,
	[ResidualValue] [decimal](28, 8) NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[TransactionID] [nvarchar](50) NULL,
	[PeriodID] [nvarchar](50) NULL,
	[ApportionAmount] [decimal](28, 8) NULL,
	[IsMultiAccount] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT1703] PRIMARY KEY CLUSTERED 
(
	[JobID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT1703__IsMultiA__0E6206AD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1703] ADD  CONSTRAINT [DF__AT1703__IsMultiA__0E6206AD]  DEFAULT ((0)) FOR [IsMultiAccount]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT1703' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT1703'  and col.name = 'Ana06ID')
Alter Table  AT1703 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End