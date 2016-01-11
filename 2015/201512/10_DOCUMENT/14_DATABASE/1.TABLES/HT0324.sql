-- <Summary>
---- 
-- <History>
---- Create on 13/11/2013 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT0324]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[HT0324]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR (50) NOT NULL,
      [TranMonth] INT NOT NULL,
      [TranYear] INT NOT NULL,
      [ResultAPK] VARCHAR (50) NOT NULL,
      [Mode] TINYINT DEFAULT (0) NOT NULL,
      [SalaryPlanID] VARCHAR (50) NOT NULL,
      [Price] DECIMAL (28,8) DEFAULT (0) NOT NULL,
      [Amount] DECIMAL (28,8) DEFAULT (0) NOT NULL,
      [CreateUserID] VARCHAR (50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] VARCHAR (50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_HT0324] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [ResultAPK]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
