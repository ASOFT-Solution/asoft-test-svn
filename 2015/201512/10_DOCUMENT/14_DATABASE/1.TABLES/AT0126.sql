IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0126]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT0126]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [PhaseID] VARCHAR(50) NOT NULL,
      [PhaseName] NVARCHAR(250) NULL,
      [Notes] NVARCHAR(1000) NULL,
      [Disabled] TINYINT DEFAULT (0) NOT NULL,
      [CreateUserID] VARCHAR(50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] VARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_AT0126] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [PhaseID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
----------------AddColumn------------------------------------------------------------
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT0126' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'AT0126' AND col.name = 'TeamID')
		ALTER TABLE AT0126 ADD TeamID VARCHAR(50) NULL
	END
