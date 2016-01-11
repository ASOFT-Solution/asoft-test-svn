-- <Summary>
---- 
-- <History>
---- Create on 01/10/2013 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT0008]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[HT0008]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID () NOT NULL,
      [DivisionID] VARCHAR (50) NOT NULL,      
      [AbsentTypeID] VARCHAR (50) NOT NULL,
      [AbsentAmount] DECIMAL (28, 8) NULL,
      [DeleteFlag] TINYINT DEFAULT 0 NOT NULL,
      [CreateUserID] VARCHAR (50) NULL,
      [CreateDate] DATETIME NULL
    CONSTRAINT [PK_HT0008] PRIMARY KEY CLUSTERED
      (
      [APK]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
