-- <Summary>
---- 
-- <History>
---- Create on 28/05/2015 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT0357]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[HT0357]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NULL,
      [TaxreturnID] VARCHAR(50) NULL,
      [IsPeriod] TINYINT DEFAULT (0) NULL,
      [TranMonth] INT NOT NULL,
      [TranYear] INT NOT NULL,
      [Quarter] VARCHAR(50) NULL,
      [TaxreturnTime] TINYINT DEFAULT (0) NULL,
      [TaxAgentPerson] NVARCHAR(250) NULL,
      [TaxAgentCertificate] NVARCHAR(250) NULL,
      [TaxreturnPerson] NVARCHAR(250) NULL,
      [SignDate] DATETIME NULL,
      [MainReaturnTax] XML NULL,
      [CreateUserID] VARCHAR(50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] VARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_HT0357] PRIMARY KEY CLUSTERED
      (
      [APK]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END