-- <Summary>
---- 
-- <History>
---- Create on 17/01/2012 by Lê Thị Thu Hiền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2104]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[HT2104](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](3) NOT NULL,
		[S] [nvarchar](50) NOT NULL,
		[STypeID] [nvarchar](50) NOT NULL,
		[SName] [nvarchar](250) NULL,
		[CreateDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
		[Disabled] [tinyint] NULL,
	 CONSTRAINT [PK_HT2104] PRIMARY KEY NONCLUSTERED 
	(
		[DivisionID] ASC,
		[STypeID] ASC,
		[S] ASC	
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

