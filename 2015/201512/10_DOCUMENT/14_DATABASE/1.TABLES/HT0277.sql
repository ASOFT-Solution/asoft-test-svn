-- <Summary>
---- 
-- <History>
---- Create on 05/12/2014 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT0277]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[HT0277]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR (50) NOT NULL,
      [DepartmentID] VARCHAR (50) NULL,
      [TeamID] VARCHAR (50) NULL,
      [EmployeeID] VARCHAR (50) NULL,
      [DeleteFlag] TINYINT DEFAULT (0) NOT NULL,
      [CreateUserID] VARCHAR (50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] VARCHAR (50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_HT0277] PRIMARY KEY CLUSTERED
      (
      [APK]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END