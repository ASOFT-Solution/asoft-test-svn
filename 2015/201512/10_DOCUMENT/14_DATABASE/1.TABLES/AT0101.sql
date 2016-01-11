-- <Summary>
---- 
-- <History>
---- Create on 12/10/2013 by Bảo Anh
---- Modified on ... by 
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0101]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[AT0101](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](3) NOT NULL,
		[LevelNo] int NOT NULL,
		[LevelName] [nvarchar](250) NULL,
		[SalesCommission] decimal(28,8) NULL,
		[SameLevelCommission] decimal(28,8) NULL,
		[Generations] int NULL,
		[MiddleCommission] decimal(28,8) NULL,
		[UpSales] decimal(28,8) NULL,
		[MinEmployees] int NULL,
		[DownSales] decimal(28,8) NULL,
		[Notes] [nvarchar](250) NULL,
		[Disabled] [tinyint] default(0) NOT NULL,
		[CreateDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
	 CONSTRAINT [PK_AT0101] PRIMARY KEY NONCLUSTERED 
	(
		[DivisionID] ASC,
		[LevelNo] ASC		
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END