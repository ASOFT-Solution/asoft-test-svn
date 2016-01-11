IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0129]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT0129]
     (
		[APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
		[DivisionID] VARCHAR(50) NOT NULL,
		[MachineID] VARCHAR(50) NOT NULL,
		[MachineName] NVARCHAR(250) NULL,
		[Notes] NVARCHAR(1000) NULL,
		[Disabled] TINYINT DEFAULT(0),
		[IsCommon] TINYINT DEFAULT(0),
		[CreateUserID] VARCHAR(50) NULL,		
		[CreateDate] DATETIME NULL,
		[LastModifyUserID] VARCHAR(50) NULL,
		[LastModifyDate] DATETIME NULL		
	CONSTRAINT [PK_AT0129] PRIMARY KEY CLUSTERED
      (
		[DivisionID],
		[MachineID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		)
	ON [PRIMARY]
END
