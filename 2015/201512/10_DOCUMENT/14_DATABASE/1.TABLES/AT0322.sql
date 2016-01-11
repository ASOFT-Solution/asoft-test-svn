---- Create by Đặng Thị Tiểu Mai on 25/11/2015 4:55:49 PM
---- Tỷ lệ phân bổ theo đơn vị - ngành (Master) (Customize KOYO)

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0322]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT0322]
     (
      [APK] [UNIQUEIDENTIFIER] DEFAULT NEWID(),
      [DivisionID] VARCHAR(50) NOT NULL,
      [ApportionID] VARCHAR(50) NOT NULL,
      [ApportionName] NVARCHAR(250) NULL,
      [Description] NVARCHAR(250) NULL,
      [EmployeeID] VARCHAR(50) NULL,
      [FromDate] DATETIME NULL,
      [ToDate] DATETIME NULL,
      [Disable] TINYINT DEFAULT (0) NULL,
      [CreateDate] DATETIME NULL,
      [CreateUserID] VARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL,
      [LastModifyUserID] VARCHAR(50) NULL
    CONSTRAINT [PK_AT0322] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [ApportionID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END