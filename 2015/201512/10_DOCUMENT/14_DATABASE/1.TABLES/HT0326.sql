-- <Summary>
---- 
-- <History>
---- Create on 09/12/2013 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT0326]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[HT0326]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NULL,
      [DivisionID] VARCHAR (50) NOT NULL,
      [VoucherID] VARCHAR (50) NOT NULL,
      [TranMonth] INT NOT NULL,
      [TranYear] INT NOT NULL,
      [VoucherTypeID] VARCHAR (50) NULL,
      [VoucherNo] VARCHAR (50) NULL,
      [VoucherDate] DATETIME NULL,
      [EmployeeID] VARCHAR (50) NOT NULL,
      [DepartmentID] VARCHAR (50) NULL,
      [TeamID] VARCHAR (50) NULL,
      [FromDate] DATETIME NOT NULL,
      [ToDate] DATETIME NOT NULL,
      [SabbaticalAmount] DECIMAL (28,8) DEFAULT (0) NULL,
      [SabbaticalReason] NVARCHAR (500) NULL,
      [SabbaticalPlace] NVARCHAR (500) NULL,
      [DeleteFlag] TINYINT DEFAULT (0) NOT NULL,
      [CreateUserID] VARCHAR (50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] VARCHAR (50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_HT0326] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [VoucherID],
      [FromDate],
      [ToDate]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
