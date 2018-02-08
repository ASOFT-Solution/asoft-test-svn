---- Create by HOANGVU on 12/17/2015 10:07:04 AM
---- Bảng thiết lập hệ thống

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[CRMT00000]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[CRMT00000]
(
  [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
  [DivisionID] VARCHAR(50) NOT NULL,
  [TranYear] INT(50) NOT NULL,
  [TranMonth] INT(50) NOT NULL,
  [VoucherType01] VARCHAR(50) NULL,
  [VoucherType02] VARCHAR(50) NULL,
  [VoucherType03] VARCHAR(50) NULL,
  [VoucherType04] VARCHAR(50) NULL,
  [WareHouseID] VARCHAR(50) NULL,
  [WareHouseTempID] VARCHAR(50) NULL,
  [ApportionID] VARCHAR(50) NULL,
  [ExportAccountID] VARCHAR(50) NULL,
  [ImportAccountID] VARCHAR(50) NULL,
  [CreateDate] DATETIME NULL,
  [CreateUserID] VARCHAR(50) NULL,
  [LastModifyDate] DATETIME NULL,
  [LastModifyUserID] VARCHAR(50) NULL
CONSTRAINT [PK_CRMT00000] PRIMARY KEY CLUSTERED
(
  [DivisionID]
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
END


IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'CRMT00000' AND xtype = 'U')
BEGIN 
   IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
   ON col.id = tab.id WHERE tab.name = 'CRMT00000' AND col.name = 'ProjectID') 
   ALTER TABLE CRMT00000 ADD ProjectID VARCHAR(50) NULL 
END

/*===============================================END ProjectID===============================================*/ 