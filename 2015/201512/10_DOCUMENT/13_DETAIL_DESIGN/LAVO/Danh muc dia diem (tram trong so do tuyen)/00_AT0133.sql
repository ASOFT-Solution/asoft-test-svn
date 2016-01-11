-- <Summary>
---- Danh mục địa điểm
-- <History>
---- Create on 03/12/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0133]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT0133]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] NVARCHAR(50) NOT NULL,
      [StationID] NVARCHAR(50) NOT NULL,
      [StationName] NVARCHAR(250) NULL,
      [Address] NVARCHAR(500) NULL,
      [StreetNo] NVARCHAR(100) NULL,
      [Street] NVARCHAR(250) NULL,
      [Ward] NVARCHAR(250) NULL,
      [District] NVARCHAR(250) NULL,
      [CityID] NVARCHAR(50) NULL,
      [Description] NVARCHAR(250) NULL,
      [Disabled] TINYINT DEFAULT (0) NULL,
      [CreateUserID] NVARCHAR(50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] NVARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_AT0133] PRIMARY KEY CLUSTERED
      (
      [DivisionID] ASC,
      [StationID] ASC
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
