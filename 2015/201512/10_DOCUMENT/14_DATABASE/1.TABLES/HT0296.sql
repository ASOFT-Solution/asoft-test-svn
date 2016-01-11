-- <Summary>
---- 
-- <History>
---- Create on 10/09/2013 by Bảo Anh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0296]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[HT0296](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](3) NOT NULL,
		[TypeID] [nvarchar](50) NOT NULL,
		[TypeOf] tinyint NOT NULL,
		[FromMark] int NULL,
		[ToMark] int NULL,
		[Notes] [nvarchar](250) NULL,
		[CreateDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
	 CONSTRAINT [PK_HT0296] PRIMARY KEY NONCLUSTERED 
	(
		[DivisionID] ASC,
		[TypeID] ASC,
		[TypeOf] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

