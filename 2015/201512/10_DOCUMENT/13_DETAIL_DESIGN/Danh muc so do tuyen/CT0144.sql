---- Create by Phan thanh hoàng vũ on 23/11/2015 2:52:45 PM
---- Chi tiết sơ đồ tuyến (LAVO bảng AT0136)

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[CT0144]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[CT0144]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [RouteID] VARCHAR(50) NOT NULL,
      [TransactionID] VARCHAR(50) NOT NULL,
      [StationID] VARCHAR(50) NULL,
      [StationOrder] INT NULL,
      [Notes] NVARCHAR(250) NULL
    CONSTRAINT [PK_CT0144] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [TransactionID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END