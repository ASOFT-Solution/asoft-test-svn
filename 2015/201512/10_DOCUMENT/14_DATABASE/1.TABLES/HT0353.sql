-- <Summary>
---- 
-- <History>
---- Create on 05/05/2015 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT0353]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[HT0353]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NULL,
      [TaxreturnID] VARCHAR(50) NULL,
      [TaxreturnYear] INT NULL,
      [FromMonth] INT NULL,
      [FromYear] INT NULL,
      [ToMonth] INT NULL,
      [ToYear] INT NULL,
      [TaxreturnTime] TINYINT DEFAULT (0) NULL,
      [IsNotEnoughYear] TINYINT DEFAULT (0) NULL,
      [NotEnougheReason] NVARCHAR(1000) NULL,
      [TaxAgentPerson] NVARCHAR(250) NULL,
      [TaxAgentCertificate] NVARCHAR(250) NULL,
      [TaxreturnPerson] NVARCHAR(250) NULL,
      [SignDate] DATETIME NULL,
      [MainReaturnTax] XML NULL,
      [ReturnTaxBK1] XML NULL,
      [ReturnTaxBK2] XML NULL,
      [ReturnTaxBK3] XML NULL,
      [TaxReturnFileID] NVARCHAR(250) NULL,
      [CreateDate] DATETIME NULL,
      [CreateUserID] VARCHAR(50) NULL,
      [LastModifyUserID] VARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_HT0353] PRIMARY KEY CLUSTERED
      (
      [APK]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
