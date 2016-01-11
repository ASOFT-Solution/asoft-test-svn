---- Create by truong ngoc phuong thao on 12/11/2015 1:05:44 PM
---- Modify by Kim Vu	on 17/11/2015	Sua kieu du lieu tu nvarchar(max) sang xml, Bo sung TranMonthTax, TranYearTax, Update PrimaryKey
---- Tờ khai thuế Nhà thầu

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0317]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT0317]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT newid() NOT NULL,
      [DivisionID] NVARCHAR(50) NOT NULL,
      [VoucherID] NVARCHAR(100) NOT NULL,
      [TaxReturnFileID] NVARCHAR(500) NULL,
      [TaxReturnID] NVARCHAR(500) NULL,
      [TranMonth] INT NULL,
      [TranYear] INT NULL,
	  [TranMonthTax] INT NULL,
	  [TranYearTax] INT NULL,
      [IsPeriodTax] TINYINT NULL,
      [TaxReturnDate] DATETIME NULL,
      [ReturnTime] INT NULL,
      [TaxAgentPeron] NVARCHAR(500) NULL,
      [TaxAgentCertificate] NVARCHAR(500) NULL,
      [TaxReturnPerson] NVARCHAR(500) NULL,
      [TaxAssignDate] DATETIME NULL,
      [AmendedReturnDate] DATETIME NULL,
      [MainReturnTax1] XML NULL,
      [MainReturnTax2] XML NULL,
      [AmendedReturnTax] XML NULL,
      [ReportID] NVARCHAR(50) NULL,
      [ReportName] NVARCHAR(500) NULL,
      [TotalAmount] DECIMAL(28,8) NULL,
      [CreateUserID] NVARCHAR(50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] NVARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_AT0317] PRIMARY KEY CLUSTERED
      (      
      [DivisionID],
      [VoucherID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END

