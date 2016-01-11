-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WT1015]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[WT1015](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] nvarchar(3) NOT NULL,
		[LocationID] [nvarchar](50) NOT NULL,
		[TypeID] [nvarchar](50) NOT NULL,
		[LocationName] [nvarchar](250) NULL,
		[CreateDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
		[Disabled] [tinyint] NOT NULL
	 CONSTRAINT [PK_WT1015] PRIMARY KEY NONCLUSTERED 
	(
		[LocationID] ASC,
		[TypeID] ASC,
		[DivisionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
