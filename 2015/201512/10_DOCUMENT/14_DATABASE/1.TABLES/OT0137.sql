IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[OT0137]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[OT0137]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [TranMonth] INT NOT NULL,
      [TranYear] INT NOT NULL,
      [VoucherTypeID] VARCHAR(50) NULL,
      [CompareID] VARCHAR(50) NOT NULL,
      [CompareNo] VARCHAR(50) NULL,
      [CompareDate] DATETIME NULL,
      [EstimateID] VARCHAR(50) NULL,
      [EmployeeID] VARCHAR(50) NULL,
      [Description] NVARCHAR(2000) NULL,
      [CreateUserID] VARCHAR(50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] VARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_OT0137] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [CompareID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
