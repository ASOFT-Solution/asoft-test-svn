-- <Summary>
---- 
-- <History>
---- Create on 24/10/2010 by Huỳnh Tấn Phú
---- Modified on 17/02/2012 by Nguyễn Bình Minh
---- Modified on 20/06/2013 by Luu Khanh Van: Them vao TBatchID
---- Modified on 01/10/2014 by Lê Thị Hạnh: Thêm 10 trường tham số trên lưới (theo dõi chiết khấu) [Customize Index: 36 - Sài Gòn Petro]
---- Modified on 27/10/2014 by Quốc Tuấn: bổ sung thêm 3 cột để kế thừa
---- Modified on 20/03/2015 by Lê Thị Hạnh: Bổ sung ETaxVoucherID, ETaxID, ETaxConvertedUnit, ETaxConvertedAmount
---- Modified on 01/01/2014 by Huỳnh Tấn Phú
---- Modified on 23/01/2014 by Thanh Sơn
---- Modified on 15/04/2014 by Luu Khanh Van
---- Modified on 09/03/2012 by Việt Khánh
---- Modified on 04/11/2013 by Bảo Anh
---- Modified on 13/09/2012 by Huỳnh Tấn Phú
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on 17/08/2015 by Trần Quốc Tuấn: Bo sung Thêm 2 cột CreditObjectNane, CreditVATNo
---- Modified on 9/11/2015 by Phương Thảo: Bổ sung thêm trường tỷ giá tính thuế nhà thầu (TaxBaseAmount)
---- Modified on 11/11/2015 by Phương Thảo: Bổ sung thêm trường để phân biệt bút toán chi phí hình thành TSCĐ (IsFACost)
---- Modified on 16/11/2015 by Phương Thảo: Bổ sung thêm trường để tập hợp TSCĐ 
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT9000]') AND type in (N'U'))
CREATE TABLE [dbo].[AT9000](
	[APK] [uniqueidentifier] NULL DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[BatchID] [nvarchar](50) NOT NULL DEFAULT ('AT9000'),
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
	[IsStock] [tinyint] NOT NULL DEFAULT ((0)),
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
	[SenderReceiver] [nvarchar](250) NULL,
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
	[Status] [nvarchar](50) NOT NULL DEFAULT ((0)),
	[IsAudit] [tinyint] NOT NULL DEFAULT ((0)),
	[IsCost] [tinyint] NOT NULL DEFAULT ((0)),
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
	[PaymentTermID] [nvarchar](50) NULL,
	[DiscountAmount] [decimal](28, 8) NULL,
	[OTransactionID] [nvarchar](50) NULL,
	[IsMultiTax] [tinyint] NULL,
	[VATOriginalAmount] [decimal](28, 8) NULL,
	[VATConvertedAmount] [decimal](28, 8) NULL,
	[ReVoucherID] [nvarchar](50) NULL,
	[ReBatchID] [nvarchar](50) NULL,
	[ReTransactionID] [nvarchar](50) NULL,
	[Parameter01] [varchar](250) NULL,
	[Parameter02] [varchar](250) NULL,
	[Parameter03] [varchar](250) NULL,
	[Parameter04] [varchar](250) NULL,
	[Parameter05] [varchar](250) NULL,
	[Parameter06] [varchar](250) NULL,
	[Parameter07] [varchar](250) NULL,
	[Parameter08] [varchar](250) NULL,
	[Parameter09] [varchar](250) NULL,
	[Parameter10] [varchar](250) NULL,
 CONSTRAINT [PK_AT9000] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC,
	[TableID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='ConvertedQuantity')
		ALTER TABLE AT9000 ADD ConvertedQuantity DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='ConvertedPrice')
		ALTER TABLE AT9000 ADD ConvertedPrice DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='ConvertedUnitID')
		ALTER TABLE AT9000 ADD ConvertedUnitID DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='ConversionFactor')
		ALTER TABLE AT9000 ADD ConversionFactor DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='UParameter01')
		ALTER TABLE AT9000 ADD UParameter01 DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='UParameter02')
		ALTER TABLE AT9000 ADD UParameter02 DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='UParameter03')
		ALTER TABLE AT9000 ADD UParameter03 DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='UParameter04')
		ALTER TABLE AT9000 ADD UParameter04 DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='UParameter05')
		ALTER TABLE AT9000 ADD UParameter05 DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='IsLateInvoice')
		ALTER TABLE AT9000 ADD IsLateInvoice TINYINT DEFAULT(0) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='MOrderID')
		ALTER TABLE AT9000 ADD MOrderID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='SOrderID')
		ALTER TABLE AT9000 ADD SOrderID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='MTransactionID')
		ALTER TABLE AT9000 ADD MTransactionID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='STransactionID')
		ALTER TABLE AT9000 ADD STransactionID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='RefVoucherNo')
		ALTER TABLE AT9000 ADD RefVoucherNo NVARCHAR(50) NULL
	END
If Exists (Select * From sysobjects Where name = 'AT9000' and xtype ='U') 
Begin 
	If not exists (select * from syscolumns col inner join sysobjects tab 
   On col.id = tab.id where tab.name = 'AT9000' and col.name = 'TBatchID') 
   Alter Table  AT9000 Add TBatchID nvarchar(50) Null 
End 
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='DParameter01')
		ALTER TABLE AT9000 ADD DParameter01 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='DParameter02')
		ALTER TABLE AT9000 ADD DParameter02 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='DParameter03')
		ALTER TABLE AT9000 ADD DParameter03 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='DParameter04')
		ALTER TABLE AT9000 ADD DParameter04 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='DParameter05')
		ALTER TABLE AT9000 ADD DParameter05 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='DParameter06')
		ALTER TABLE AT9000 ADD DParameter06 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='DParameter07')
		ALTER TABLE AT9000 ADD DParameter07 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='DParameter08')
		ALTER TABLE AT9000 ADD DParameter08 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='DParameter09')
		ALTER TABLE AT9000 ADD DParameter09 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='DParameter10')
		ALTER TABLE AT9000 ADD DParameter10 NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='InheritTableID')
		ALTER TABLE AT9000 ADD InheritTableID NVARCHAR(50) NULL
	END
	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='InheritVoucherID')
		ALTER TABLE AT9000 ADD InheritVoucherID VARCHAR(50) NULL
	END
	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='InheritTransactionID')
		ALTER TABLE AT9000 ADD InheritTransactionID VARCHAR(50) NULL
	END
-- Thuế bảo vệ môi trường - hỗ trợ 20/03/2015
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='ETaxVoucherID')
		ALTER TABLE AT9000 ADD ETaxVoucherID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='ETaxID')
		ALTER TABLE AT9000 ADD ETaxID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='ETaxConvertedUnit')
		ALTER TABLE AT9000 ADD ETaxConvertedUnit DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='ETaxConvertedAmount')
		ALTER TABLE AT9000 ADD ETaxConvertedAmount DECIMAL(28,8) NULL
	END
---- Modified on 25/03/2015 by Lê Thị Hạnh: Thêm trường ETaxTransactionID
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='ETaxTransactionID')
		ALTER TABLE AT9000 ADD ETaxTransactionID NVARCHAR(50) NULL
	END
---- Modified on 27/05/2015 by Lê Thị Hạnh: Thêm trường thuế tiêu thụ đặc biệt
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='AssignedSET')
		ALTER TABLE AT9000 ADD AssignedSET TINYINT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='SETID')
		ALTER TABLE AT9000 ADD SETID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='SETUnitID')
		ALTER TABLE AT9000 ADD SETUnitID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='SETTaxRate')
		ALTER TABLE AT9000 ADD SETTaxRate DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='SETConvertedUnit')
		ALTER TABLE AT9000 ADD SETConvertedUnit DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='SETQuantity')
		ALTER TABLE AT9000 ADD SETQuantity DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='SETOriginalAmount')
		ALTER TABLE AT9000 ADD SETOriginalAmount DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='SETConvertedAmount')
		ALTER TABLE AT9000 ADD SETConvertedAmount DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='SETConsistID')
		ALTER TABLE AT9000 ADD SETConsistID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='SETTransactionID')
		ALTER TABLE AT9000 ADD SETTransactionID NVARCHAR(50) NULL
	END
---- Modified on 01/06/2015 by Lê Thị Hạnh: Thêm trường thuế tiêu tài nguyên
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='AssignedNRT')
		ALTER TABLE AT9000 ADD AssignedNRT TINYINT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='NRTTaxAmount')
		ALTER TABLE AT9000 ADD NRTTaxAmount DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='NRTClassifyID')
		ALTER TABLE AT9000 ADD NRTClassifyID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='NRTUnitID')
		ALTER TABLE AT9000 ADD NRTUnitID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='NRTTaxRate')
		ALTER TABLE AT9000 ADD NRTTaxRate DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='NRTConvertedUnit')
		ALTER TABLE AT9000 ADD NRTConvertedUnit DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='NRTQuantity')
		ALTER TABLE AT9000 ADD NRTQuantity DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='NRTOriginalAmount')
		ALTER TABLE AT9000 ADD NRTOriginalAmount DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='NRTConvertedAmount')
		ALTER TABLE AT9000 ADD NRTConvertedAmount DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='NRTConsistID')
		ALTER TABLE AT9000 ADD NRTConsistID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='NRTTransactionID')
		ALTER TABLE AT9000 ADD NRTTransactionID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='InvoiceCode')
	ALTER TABLE AT9000 ADD InvoiceCode NVARCHAR (50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='InvoiceSign')
	ALTER TABLE AT9000 ADD InvoiceSign NVARCHAR (50) NULL
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='ReTableID')
	ALTER TABLE AT9000 ADD ReTableID NVARCHAR (50) NULL		
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'TVoucherID')
	Alter Table  AT9000 Add TVoucherID NVARCHAR(50) NULL
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'OldCounter')
	Alter Table  AT9000 Add OldCounter Decimal(28,8) NULL
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'NewCounter')
	Alter Table  AT9000 Add NewCounter Decimal(28,8) NULL
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'OtherCounter')
	Alter Table  AT9000 Add OtherCounter Decimal(28,8) NULL	
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'WOrderID')
	Alter Table  AT9000 Add WOrderID NVARCHAR(50) NULL
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'WTransactionID')
	Alter Table  AT9000 Add WTransactionID NVARCHAR(50) NULL	
	If not exists (select * from syscolumns col inner join sysobjects tab 
	On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'MarkQuantity')
	Alter Table  AT9000 Add MarkQuantity DECIMAL(28,8) NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='RefInfor')
	ALTER TABLE AT9000 ADD RefInfor NVARCHAR (250) NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='StandardPrice')
	ALTER TABLE AT9000 ADD StandardPrice DECIMAL(28,8) DEFAULT (0) NULL
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='StandardAmount')
	ALTER TABLE AT9000 ADD StandardAmount DECIMAL(28,8) DEFAULT (0) NULL
END
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='IsCom')
	ALTER TABLE AT9000 ADD IsCom tinyint DEFAULT (0) NULL
END
If Exists (Select * From sysobjects Where name = 'AT9000' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'PriceListID')
           Alter Table  AT9000 Add PriceListID nvarchar(50) Null
END
If Exists (Select * From sysobjects Where name = 'AT9000' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'WOrderID')
           Alter Table  AT9000 Add WOrderID NVARCHAR(50) NULL
           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'WTransactionID')
           Alter Table  AT9000 Add WTransactionID NVARCHAR(50) NULL
           
           --- Bổ sung trường nhận biết kế thừa hợp đồng (Sinolife)
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'ContractDetailID')
           Alter Table  AT9000 Add ContractDetailID NVARCHAR(50) NULL
End 
If Exists (Select * From sysobjects Where name = 'AT9000' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'MarkQuantity')
           Alter Table  AT9000 Add MarkQuantity DECIMAL(28,8) NULL
END
If Exists (Select * From sysobjects Where name = 'AT9000' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT9000'  and col.name = 'Ana06ID')
Alter Table  AT9000 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
END
--Bố sung thêm cột CreditObjectName,
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='CreditObjectName')
		ALTER TABLE AT9000 ADD CreditObjectName NVARCHAR(500) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='CreditVATNo')
		ALTER TABLE AT9000 ADD CreditVATNo NVARCHAR(500) NULL
	END
---- Alter Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='Parameter01')
		ALTER TABLE AT9000 ALTER COLUMN Parameter01 NVARCHAR(250) NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='Parameter02')
		ALTER TABLE AT9000 ALTER COLUMN Parameter02 NVARCHAR(250) NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='Parameter03')
		ALTER TABLE AT9000 ALTER COLUMN Parameter03 NVARCHAR(250) NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='Parameter04')
		ALTER TABLE AT9000 ALTER COLUMN Parameter04 NVARCHAR(250) NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='Parameter05')
		ALTER TABLE AT9000 ALTER COLUMN Parameter05 NVARCHAR(250) NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='Parameter06')
		ALTER TABLE AT9000 ALTER COLUMN Parameter06 NVARCHAR(250) NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='Parameter07')
		ALTER TABLE AT9000 ALTER COLUMN Parameter07 NVARCHAR(250) NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='Parameter08')
		ALTER TABLE AT9000 ALTER COLUMN Parameter08 NVARCHAR(250) NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='Parameter09')
		ALTER TABLE AT9000 ALTER COLUMN Parameter09 NVARCHAR(250) NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='Parameter10')
		ALTER TABLE AT9000 ALTER COLUMN Parameter10 NVARCHAR(250) NULL 
	END
 IF((ISNULL(COL_LENGTH('AT9000', 'OrderID'), 0)/2)<=50)
 ALTER TABLE AT9000 ALTER COLUMN OrderID NVARCHAR(500)

 IF((ISNULL(COL_LENGTH('AT9000', 'InheritTransactionID'), 0)/2)<=50)
 ALTER TABLE AT9000 ALTER COLUMN InheritTransactionID NVARCHAR(2000)

--- Thêm check chi phí mua hàng IsPOCost[LAVO]
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT9000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT9000' AND col.name='IsPOCost')
		ALTER TABLE AT9000 ADD IsPOCost TINYINT NULL
	END

--- Them truong tri gia tinh thue nha thau
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT9000' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT9000' AND col.name = 'TaxBaseAmount')
        ALTER TABLE AT9000 ADD TaxBaseAmount DECIMAL(28,8) NULL
    END

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT9000' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT9000' AND col.name = 'WTCExchangeRate')
        ALTER TABLE AT9000 ADD WTCExchangeRate DECIMAL(28,8) NULL
    END

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT9000' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT9000' AND col.name = 'WTCOperator')
        ALTER TABLE AT9000 ADD WTCOperator TINYINT NULL
    END

--- But toan chi phi hinh thanh TSCD
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT9000' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT9000' AND col.name = 'IsFACost')
        ALTER TABLE AT9000 ADD IsFACost TINYINT NULL
    END

--- Phieu tap hop TSCĐ
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT9000' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT9000' AND col.name = 'IsInheritFA')
        ALTER TABLE AT9000 ADD IsInheritFA TINYINT NULL
    END

--- Khoa cua phieu tap hop TSCD, luu vao cac but toan hinh thanh
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT9000' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT9000' AND col.name = 'InheritedFAVoucherID')
        ALTER TABLE AT9000 ADD InheritedFAVoucherID NVARCHAR(50) NULL
    END