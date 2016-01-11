-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on 28/12/2015 by Hoàng Vũ: CustomizeIndex = 51 (Hoàng trần), Bổ sung thêm 3 trường InheritTableID, InheritVoucherID, InheritTransactionID.
---- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2027]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2027](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[BatchID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[ApportionTable] [nvarchar](50) NULL,
	[ApportionID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[ActualQuantity] [decimal](28, 8) NULL,
	[ConversionFactor] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[DebitAccountID] [nvarchar](50) NULL,
	[CreditAccountID] [nvarchar](50) NULL,
	[Orders] [int] NOT NULL,
	[ReTransactionID] [nvarchar](50) NULL,
	[ReVoucherID] [nvarchar](50) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[PeriodID] [nvarchar](50) NULL,
	[OrderID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[OTransactionID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT2027] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2027_ApportionTable]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2027] ADD  CONSTRAINT [DF_AT2027_ApportionTable]  DEFAULT ('AT1326') FOR [ApportionTable]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT2027' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'AT2027'  and col.name = 'Ana06ID')
Alter Table  AT2027 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End


--CustomizeIndex = 51 (hoàng trần)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2027' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2027' AND col.name = 'InheritTableID')
        ALTER TABLE AT2027 ADD InheritTableID VARCHAR(50) NULL
    END
--CustomizeIndex = 51 (hoàng trần)	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2027' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2027' AND col.name = 'InheritVoucherID')
        ALTER TABLE AT2027 ADD InheritVoucherID VARCHAR(50) NULL
    END	
--CustomizeIndex = 51 (hoàng trần)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT2027' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT2027' AND col.name = 'InheritTransactionID')
        ALTER TABLE AT2027 ADD InheritTransactionID VARCHAR(50) NULL
    END