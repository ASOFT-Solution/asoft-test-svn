---- Create by Đào Tấn Đạt on 2/26/2018 1:51:44 PM
---- Danh mục Hợp đồng

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[OT2012]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[OT2012]
(
  [APK] UNIQUEIDENTIFIER DEFAULT newid() NULL,
  [ContractID] NVARCHAR(50) NOT NULL,
  [DivisionID] VARCHAR(50) NOT NULL,
  [ContractNO] NVARCHAR(50) NOT NULL,
  [DeleteFlag] TINYINT DEFAULT (0) NULL,
  [CreateUserID] VARCHAR(50) NULL,
  [CreateDate] DATETIME NULL,
  [LastModifyUserID] VARCHAR(50) NULL,
  [LastModifyDate] DATETIME NULL,
  [RelatedToTypeID] INT NULL,
  [RelatedToID] INT NULL,
  [VoucherTypeID] NVARCHAR(50) NULL,
  [OrderDate] DATETIME NULL,
  [CurrencyID] VARCHAR(50) NULL,
  [ExchangeRate] DECIMAL(28,8) NULL,
  [OrderStatus] TINYINT DEFAULT (0) NULL,
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
  [InvoiceFlg] TINYINT DEFAULT (0) NULL,
  [ObjectName] NVARCHAR(250) NOT NULL,
  [DeliveryAddress] NVARCHAR(250) NULL,
  [Disabled] TINYINT DEFAULT (0) NOT NULL,
  [TranMonth] INT NULL,
  [TranYear] INT NULL,
  [ShipDate] DATETIME NULL,
  [IsConfirm] TINYINT DEFAULT (0) NOT NULL,
  [DescriptionConfirm] NVARCHAR(250) NULL,
  [ConfirmDate] DATETIME NULL,
  [ConfirmUserID] VARCHAR(50) NULL,
  [IsInvoice] TINYINT DEFAULT (0) NULL,
  [SOrderType] TINYINT DEFAULT (0) NULL
CONSTRAINT [PK_OT2012] PRIMARY KEY CLUSTERED
(
  [ContractID],
  [DivisionID]
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
END