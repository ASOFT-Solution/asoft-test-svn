-- <Summary>
---- Danh mục sơ đồ tuyến - CF0135-6 - Master
-- <History>
---- Create on 04/12/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0135]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT0135]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] NVARCHAR(50) NOT NULL,
      [RouteID] NVARCHAR(50) NOT NULL,
      [RouteName] NVARCHAR(250) NULL,
      [Description] NVARCHAR(500) NULL,
      [Disabled] TINYINT NULL,
      [CreateUserID] NVARCHAR(50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] NVARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_AT0135] PRIMARY KEY CLUSTERED
      ( 
      [DivisionID] ASC,
      [RouteID] ASC
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END