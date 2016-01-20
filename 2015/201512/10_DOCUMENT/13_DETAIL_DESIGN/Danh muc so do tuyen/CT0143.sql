---- Create by Phan thanh hoàng vũ on 23/11/2015 2:50:53 PM
---- Danh mục sơ đồ tuyến (LAVO bảng AT0135)

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[CT0143]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[CT0143]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [RouteID] VARCHAR(50) NOT NULL,
      [RouteName] NVARCHAR(250) NULL,
      [Description] NVARCHAR(500) NULL,
      [EmployeeID] VARCHAR(50) NULL,
      [Disabled] TINYINT DEFAULT 0 NULL,
      [CreateUserID] VARCHAR(50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] VARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_CT0143] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [RouteID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END