---- Create by Đặng Thị Tiểu Mai on 01/12/2015 3:18:50 PM
---- Chi tiết bộ định mức theo quy cách

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[MT0136]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[MT0136]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [TransactionID] VARCHAR(50) DEFAULT NewID() NOT NULL,
      [ApportionID] VARCHAR(50) NOT NULL,
      [ProductID] VARCHAR(50) NULL,
      [UnitID] VARCHAR(50) NULL,
      [ProductQuantity] DECIMAL(28,8) NULL,
      [S01ID] VARCHAR(50) NULL,
      [S02ID] VARCHAR(50) NULL,
      [S03ID] VARCHAR(50) NULL,
      [S04ID] VARCHAR(50) NULL,
      [S05ID] VARCHAR(50) NULL,
      [S06ID] VARCHAR(50) NULL,
      [S07ID] VARCHAR(50) NULL,
      [S08ID] VARCHAR(50) NULL,
      [S09ID] VARCHAR(50) NULL,
      [S10ID] VARCHAR(50) NULL,
      [S11ID] VARCHAR(50) NULL,
      [S12ID] VARCHAR(50) NULL,
      [S13ID] VARCHAR(50) NULL,
      [S14ID] VARCHAR(50) NULL,
      [S15ID] VARCHAR(50) NULL,
      [S16ID] VARCHAR(50) NULL,
      [S17ID] VARCHAR(50) NULL,
      [S18ID] VARCHAR(50) NULL,
      [S19ID] VARCHAR(50) NULL,
      [S20ID] VARCHAR(50) NULL,
      [Parameter01] NVARCHAR(250) NULL,
      [Parameter02] NVARCHAR(250) NULL,
      [Parameter03] NVARCHAR(250) NULL,
      [Orders] INT NULL
    CONSTRAINT [PK_MT0136] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [TransactionID],
      [ApportionID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END

