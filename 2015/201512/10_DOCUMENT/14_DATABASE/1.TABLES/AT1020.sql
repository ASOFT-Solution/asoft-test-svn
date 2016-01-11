-- <Summary>
---- 
-- <History>
---- Create on 20/04/2011 by Việt Khánh
---- Modified on 21/01/2014 by Bảo Anh: Bổ sung các trường nhận biết hợp đồng thuộc đơn hàng và mặt hàng nào (Sinolife)
---- Modified on 24/03/2015 by Thanh Sơn:
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1020]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1020](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ContractID] [nvarchar](50) NOT NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[ContractNo] [nvarchar](50) NOT NULL,
	[ContractName] [nvarchar](250) NULL,
	[ContractType] [tinyint] NULL,
	[SignDate] [datetime] NULL,
	[ObjectID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[Amount] [decimal](28, 8) NULL,
	[Description] [nvarchar](250) NULL,
	[ConRef01] [nvarchar](250) NULL,
	[ConRef02] [nvarchar](250) NULL,
	[ConRef03] [nvarchar](250) NULL,
	[ConRef04] [nvarchar](250) NULL,
	[ConRef05] [nvarchar](250) NULL,
	[ConRef06] [nvarchar](250) NULL,
	[ConRef07] [nvarchar](250) NULL,
	[ConRef08] [nvarchar](250) NULL,
	[ConRef09] [nvarchar](250) NULL,
	[ConRef10] [nvarchar](250) NULL,	
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1020] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[ContractID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1020' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1020' AND col.name = 'SOrderID')
		ALTER TABLE AT1020 ADD SOrderID NVARCHAR(50) NULL
	END	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1020' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1020' AND col.name = 'STransactionID')
		ALTER TABLE AT1020 ADD STransactionID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1020' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1020' AND col.name = 'BeginDate')
		ALTER TABLE AT1020 ADD BeginDate DATETIME NULL
	END	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1020' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1020' AND col.name = 'EndDate')
		ALTER TABLE AT1020 ADD EndDate DATETIME NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1020' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1020' AND col.name = 'ExchangeRate')
		ALTER TABLE AT1020 ADD ExchangeRate DECIMAL(28,8) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1020' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1020' AND col.name = 'ConvertedAmount')
		ALTER TABLE AT1020 ADD ConvertedAmount DECIMAL(28,8) NULL
	END
