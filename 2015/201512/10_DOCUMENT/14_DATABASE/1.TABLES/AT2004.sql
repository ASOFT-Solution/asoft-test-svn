-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2004]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2004](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[OrderID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[OrderDate] [datetime] NULL,
	[OrderNo] [nvarchar](50) NULL,
	[QuotationID] [nvarchar](50) NULL,
	[CustomerID] [nvarchar](50) NULL,
	[ProjectID] [nvarchar](50) NULL,
	[ContractNo] [nvarchar](50) NULL,
	[ContractDate] [datetime] NULL,
	[Content] [nvarchar](100) NULL,
	[TotalAmount] [decimal](28, 8) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[TotalQuantity] [decimal](28, 8) NULL,
	[PaymentID] [nvarchar](50) NULL,
	[Notes] [nvarchar](250) NULL,
	[Status] [tinyint] NOT NULL,
	[IsPicking] [tinyint] NOT NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_AT2004] PRIMARY KEY NONCLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2004_Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2004] ADD  CONSTRAINT [DF_AT2004_Status]  DEFAULT ((0)) FOR [Status]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2004_IsPicking]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2004] ADD  CONSTRAINT [DF_AT2004_IsPicking]  DEFAULT ((0)) FOR [IsPicking]
END