-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on 20/06/2014 by Thanh Sơn: Bổ sung thêm trường Số lẻ phần trăm và logo công ty

-- <Example>

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0001]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0001](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[CompanyName] [nvarchar](250) NULL,
	[ShortName] [nvarchar](250) NULL,
	[Tel] [nvarchar](100) NULL,
	[Fax] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[Address] [nvarchar](250) NULL,
	[CountryID] [nvarchar](50) NULL,
	[CityID] [nvarchar](50) NULL,
	[ChiefAccountant] [nvarchar](250) NULL,
	[Director] [nvarchar](250) NULL,
	[Chairmain] [nvarchar](250) NULL,
	[BaseCurrencyID] [nvarchar](50) NULL,
	[PeriodNum] [int] NULL,
	[DBID] [nvarchar](50) NULL,
	[QuantityDecimals] [tinyint] NOT NULL,
	[UnitCostDecimals] [tinyint] NOT NULL,
	[ConvertedDecimals] [tinyint] NOT NULL,
	[DBVersion] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[Serial] [nvarchar](250) NULL,
	[InvoiceNo] [nvarchar](250) NULL
	CONSTRAINT [PK_AT0001] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 

) ON [PRIMARY]
END
---- Add giá trị Default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0001_QuantityDecimals]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0001] ADD  CONSTRAINT [DF_AT0001_QuantityDecimals]  DEFAULT ((2)) FOR [QuantityDecimals]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0001_UnitCost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0001] ADD  CONSTRAINT [DF_AT0001_UnitCost]  DEFAULT ((2)) FOR [UnitCostDecimals]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0001_ConvertedDecimals]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0001] ADD  CONSTRAINT [DF_AT0001_ConvertedDecimals]  DEFAULT ((2)) FOR [ConvertedDecimals]
END
---- Add Columns
If Exists (Select TOP 1 1 From sysobjects Where name = 'AT0001' and xtype ='U') 
Begin
           If not exists (select TOP 1 1 from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT0001'  and col.name = 'BankAccountID')
           Alter Table AT0001 Add BankAccountID nvarchar(50) Null
END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0001' AND col.name='PercentDecimal')
		ALTER TABLE AT0001 ADD PercentDecimal TINYINT DEFAULT(2) NOT NULL
	END
	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0001' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0001' AND col.name='Logo')
		ALTER TABLE AT0001 ADD Logo IMAGE NULL
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0001' AND col.name='WebSiteUpdate')
		ALTER TABLE AT0001 ADD WebSiteUpdate NVARCHAR(50) NULL
	END

