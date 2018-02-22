---- Create by Đào Tấn Đạt on 2/22/2018 11:52:42 AM
---- Danh mục Hợp đồng

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[CRMT20001]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[CRMT20001]
(
  [APK] UNIQUEIDENTIFIER DEFAULT newid() NULL,
  [ContractID] NVARCHAR(50) NOT NULL,
  [DivisionID] VARCHAR(50) NOT NULL,
  [ContractNO] NVARCHAR(50) NOT NULL,
  [DeleteFlag] TINYINT DEFAULT (0) NOT NULL,
  [CreateUserID] VARCHAR(50) NULL,
  [CreateDate] DATETIME NULL,
  [LastModifyUserID] VARCHAR(50) NULL,
  [LastModifyDate] DATETIME NULL,
  [RelatedToTypeID] INT NULL,
  [RelatedToID] INT NULL,
  [VoucherTypeID] NVARCHAR(50) NULL,
  [ContractDate] DATETIME NOT NULL,
  [CurrencyID] VARCHAR(50) NULL,
  [ExchangeRate] DECIMAL(28,8) NULL,
  [OrderStatus] TINYINT DEFAULT (0) NOT NULL,
  [ImpactLevel] TINYINT NULL,
  [InventoryTypeID] NVARCHAR(50) NULL,
  [EmployeeID] VARCHAR(50) NULL,
  [SalesManID] VARCHAR(50) NULL,
  [ObjectID] VARCHAR(50) NOT NULL,
  [Address] NVARCHAR(250) NULL,
  [VATNo] NVARCHAR(50) NULL,
  [DueDate] DATETIME NULL,
  [Contact] NVARCHAR(100) NULL,
  [StartWarranty] DATETIME NULL,
  [EndWarranty] DATETIME NULL,
  [StartMaintenance] DATETIME NULL,
  [EndMaintenance] DATETIME NULL,
  [StartAddendum] DATETIME NULL,
  [EndAddendum] DATETIME NULL,
  [Notes] NVARCHAR(Max) NULL,
  [InvoiceFlg] TINYINT DEFAULT (0) NULL
CONSTRAINT [PK_CRMT20001] PRIMARY KEY CLUSTERED
(
  [ContractID],
  [DivisionID]
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
END