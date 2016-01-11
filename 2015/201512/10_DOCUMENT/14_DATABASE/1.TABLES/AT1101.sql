-- <Summary>
---- Danh mục đơn vị
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on 13/03/2015 by Thanh Sơn
---- Modify on 24/06/2015 by Bảo Anh: Bổ sung các trường định nghĩa niên độ tài chính
---- Modified on 08/10/2015 by Tiểu Mai: bổ sung các trường thiết lập: BaseCurrencyID, BankAccountID, QuantityDecimals, UnitCostDecimals, ConvertedDecimals, PercentDecimal
---- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1101]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1101](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DivisionName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[Tel] [nvarchar](100) NULL,
	[Fax] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[Address] [nvarchar](250) NULL,
	[ContactPerson] [nvarchar](100) NULL,
	[VATNO] [nvarchar](50) NULL,
	[BeginMonth] [int] NULL,
	[BeginYear] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[DivisionNameE] [nvarchar](250) NULL,
	[AddressE] [nvarchar](250) NULL,
	[ImageLogo] [ntext] NULL,
	[Logo] [image] NULL,
 CONSTRAINT [PK_AT1101] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1101_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1101] ADD  CONSTRAINT [DF_AT1101_Disabled]  DEFAULT ((0)) FOR [Disabled]
END

---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentCertificate')
		ALTER TABLE AT1101 ADD TaxAgentCertificate NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentContractDate')
		ALTER TABLE AT1101 ADD TaxAgentContractDate DATETIME NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentFax')
		ALTER TABLE AT1101 ADD TaxAgentFax NVARCHAR(100) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentTel')
		ALTER TABLE AT1101 ADD TaxAgentTel NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentEmail')
		ALTER TABLE AT1101 ADD TaxAgentEmail NVARCHAR(250) NULL
	END	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentPerson')
		ALTER TABLE AT1101 ADD TaxAgentPerson NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentContractNo')
		ALTER TABLE AT1101 ADD TaxAgentContractNo NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentCity')
		ALTER TABLE AT1101 ADD TaxAgentCity NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentDistrict')
		ALTER TABLE AT1101 ADD TaxAgentDistrict NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentAddress')
		ALTER TABLE AT1101 ADD TaxAgentAddress NVARCHAR(250) NULL
	END	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentName')
		ALTER TABLE AT1101 ADD TaxAgentName NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxAgentNo')
		ALTER TABLE AT1101 ADD TaxAgentNo NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'IsUseTaxAgent')
		ALTER TABLE AT1101 ADD IsUseTaxAgent TINYINT NULL
	END

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'ManagingUnitTaxNo')
		ALTER TABLE AT1101 ADD ManagingUnitTaxNo NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'ManagingUnit')
		ALTER TABLE AT1101 ADD ManagingUnit NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxDepartID')
		ALTER TABLE AT1101 ADD TaxDepartID VARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxDepartmentID')
		ALTER TABLE AT1101 ADD TaxDepartmentID VARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'TaxreturnPerson')
		ALTER TABLE AT1101 ADD TaxreturnPerson NVARCHAR(250) NULL
	END

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'FiscalBeginDate')
		ALTER TABLE AT1101 ADD FiscalBeginDate NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'District')
		ALTER TABLE AT1101 ADD District NVARCHAR(250) NULL
	END
	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'City')
		ALTER TABLE AT1101 ADD City NVARCHAR(250) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'Industry')
		ALTER TABLE AT1101 ADD Industry NVARCHAR(500) NULL
	END

--- Bổ sung các trường định nghĩa niên độ tài chính
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'StartDate')
		ALTER TABLE AT1101 ADD StartDate DateTime DEFAULT('01/01/1900') NULL
	END

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'EndDate')
		ALTER TABLE AT1101 ADD EndDate DATETIME DEFAULT('12/31/1900') NULL
	END

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'PeriodNum')
		ALTER TABLE AT1101 ADD PeriodNum INT DEFAULT(12) NULL
	END
	
--- Bổ sung các trường thiết lập ngày 08/10/2015
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1101' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'BaseCurrencyID')
		ALTER TABLE AT1101 ADD BaseCurrencyID VARCHAR(50) NULL
		
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'BankAccountID')
		ALTER TABLE AT1101 ADD BankAccountID VARCHAR(50) NULL
		
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'QuantityDecimals')
		ALTER TABLE AT1101 ADD QuantityDecimals TINYINT DEFAULT(0) NULL
		
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'UnitCostDecimals')
		ALTER TABLE AT1101 ADD UnitCostDecimals TINYINT DEFAULT(0) NULL
		
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'ConvertedDecimals')
		ALTER TABLE AT1101 ADD ConvertedDecimals TINYINT DEFAULT(0) NULL
		
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT1101' AND col.name = 'PercentDecimal')
		ALTER TABLE AT1101 ADD PercentDecimal TINYINT DEFAULT(0) NULL
	END
	
