-- <Summary>
---- Thiết lập hệ thống - bảng standard
-- <History>
---- Create on 12/01/2011 by Thanh Trẫm
---- Modified on 29/08/2012 by Huỳnh Tấn Phú::Thêm cột IsAutoSerialInvoiceNo vào bảng AT0000STD
-- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0000STD]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0000STD](
	[DefTranMonth] [int] NULL,
	[DefTranYear] [int] NULL,
	[DefLoginDate] [datetime] NULL,
	[ScheduleDays] [int] NULL,
	[StartHour] [int] NULL,
	[StartMinute] [int] NULL,
	[EndHour] [int] NULL,
	[EndMinute] [int] NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[CashAccountID] [nvarchar](50) NULL,
	[ReceivedAccountID] [nvarchar](50) NULL,
	[PayableAccountID] [nvarchar](50) NULL,
	[TurnOverAccountID] [nvarchar](50) NULL,
	[PrimeCostAccountID] [nvarchar](50) NULL,
	[VATInAccountID] [nvarchar](50) NULL,
	[VATOutAccountID] [nvarchar](50) NULL,
	[DifferenceAccountID] [nvarchar](50) NULL,
	[LossExchangeAccID] [nvarchar](50) NOT NULL,
	[InterestExchangeAccID] [nvarchar](50) NOT NULL,
	[VATGroupID] [nvarchar](50) NULL,
	[IsNegativeStock] [tinyint] NOT NULL,
	[PaymentTermID] [nvarchar](50) NULL,
	[IsDiscount] [tinyint] NOT NULL,
	[IsAsoftM] [tinyint] NOT NULL,
	[IsAsoftHRM] [tinyint] NOT NULL,
	[IsAsoftOP] [tinyint] NOT NULL,
	[PreCostAccountID] [nvarchar](50) NULL,
	[IsCommission] [tinyint] NULL,
	[CommissionAccountID] [nvarchar](50) NULL,
	[IsNegativeCash] [tinyint] NULL,
	[IsLockSalePrice] [tinyint] NULL,
	[IsAutoSourceNo] [tinyint] NOT NULL,
	[IsTestSalePrice] [tinyint] NULL,
	[IsConsecutiveExchange] [tinyint] NOT NULL,
	[IsNotDebit] [tinyint] NULL,
	[ImportExcel] [tinyint] NULL,
	[IsBarcode] [tinyint] NULL,
	[IsPrintedInvoice] [tinyint] NULL,
	[Image01ID] [image] NULL,
	[Image02ID] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
---- Add Columns 
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'AT0000STD' AND xtype = 'U') 
BEGIN
    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'AT0000STD' AND col.name = 'IsAutoSerialInvoiceNo')
    ALTER TABLE AT0000STD ADD IsAutoSerialInvoiceNo  tinyint Null Default(1)
END 