IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[OT0138]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[OT0138]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [TranMonth] INT NOT NULL,
      [TranYear] INT NOT NULL,
      [CompareID] VARCHAR(50) NOT NULL,
      [MaterialID] VARCHAR(50) NOT NULL,
      [MaterialQuantity] DECIMAL(28,8) NOT NULL,
      [WareHouseID] VARCHAR(50) NULL,
      [BookingQuantity] DECIMAL(28,8) NULL,
      [CompareQuantity] DECIMAL(28,8) NULL,
      [EndQuantity] DECIMAL(28,8) NULL,
      [SQuantity] DECIMAL(28,8) NULL,
      [PQuantity] DECIMAL(28,8) NULL,
      [ReadyQuantity] DECIMAL(28,8) NULL,
      [MaterialTypeID] TINYINT DEFAULT (0) NULL,
      [Level] TINYINT DEFAULT (0) NULL,
      [ApportionID] VARCHAR(50) NULL,
      [SuggestQuantity] DECIMAL(28,8) NULL
    CONSTRAINT [PK_OT0138] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [CompareID],
      [MaterialID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
