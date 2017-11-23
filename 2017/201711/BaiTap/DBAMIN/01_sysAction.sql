--- Created on 14/10/2016 by Phan thanh hoàng vũ
--- Lưu user đăng nhập tool quản trị
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysAction]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[sysAction]
     (
      [sysActionID] [int] IDENTITY(1,1) NOT NULL,
	  [Desciption] VARCHAR(Max) NULL,
      [IDLanguage] VARCHAR(250) NULL,
      [Url] NVARCHAR(250) NULL,
	  [ClickEvent] NVARCHAR(250) NULL,
	  [ScreenID] VARCHAR(100) NULL,
	  [ActionID] VARCHAR(250) NULL,
	  [ModuleID] VARCHAR(250) NULL
   CONSTRAINT [PK_sysActionID] PRIMARY KEY CLUSTERED
      (
      [sysActionID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
