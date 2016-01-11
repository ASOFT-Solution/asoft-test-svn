---- Create by Đặng Thị Tiểu Mai on 25/11/2015 4:56:27 PM
---- Tỷ lệ phân bổ theo đơn vị - ngành (Detail) (Customize cho KOYO)

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0323]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT0323]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID(),
      [DivisionID] VARCHAR(50) NOT NULL,
      [TransactionID] VARCHAR(50) NOT NULL,
      [ApportionID] VARCHAR(50) NOT NULL,
      [DivisionID1] VARCHAR(50) NULL,
      [DepartmentID] VARCHAR(50) NULL,
      [CostID] VARCHAR(50) NULL,
      [RatioDecimal] DECIMAL(28,8) NULL,
      [Notes] NVARCHAR(250) NULL
    CONSTRAINT [PK_AT0323] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [TransactionID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END