-- <Summary>
---- 
-- <History>
---- Create on 23/08/2015 by Thanh Sơn
---- Modified on ... by 
-- <Example>

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0128]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT0128]
     (
		[APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
		[DivisionID] VARCHAR(50) NOT NULL,
		[StandardID] VARCHAR(50) DEFAULT NEWID() NOT NULL,
		[StandardName] NVARCHAR(250) NULL,
		[StandardTypeID] VARCHAR(50) NOT NULL,
		[Disabled] TINYINT DEFAULT (0) NOT NULL,
		[IsCommon] TINYINT DEFAULT (0) NOT NULL,
		[CreateUserID] VARCHAR(50) NULL,
		[CreateDate] DATETIME NULL,
		[LastModifyUserID] VARCHAR(50) NULL,
		[LastModifyDate] DATETIME NULL
	CONSTRAINT [PK_AT0128] PRIMARY KEY CLUSTERED
      (
		[DivisionID],
		[StandardID],
		[StandardTypeID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		)
	ON [PRIMARY]
END

---- AddColumns ----
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT0128' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT0128' AND col.name = 'Notes')
		ALTER TABLE AT0128 ADD Notes NVARCHAR(500) NULL
	END	
---- AlterColumns ----

---- DropColumns ----
