-- <Summary>
---- 
-- <History>
---- Create on 24/12/2014 by Bảo Anh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1032]') AND type in (N'U'))
BEGIN

	CREATE TABLE [dbo].[HT1032](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](50) NOT NULL,
		[IDCityID] [nvarchar](50) NOT NULL,
		[IDCityName] [nvarchar](250) NULL,
		[Disabled] tinyint NOT NULL DEFAULT(0),
		[CreateDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT1032] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[IDCityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
