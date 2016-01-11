-- <Summary>
---- 
-- <History>
---- Create on 15/05/2013 by Lê Thị Thu Hiền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0267]') AND type in (N'U')) 
BEGIN
CREATE TABLE [dbo].[HT0267](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](50) NOT NULL,
	[WorkID] [nvarchar](50) NOT NULL,
	[WorkName] [nvarchar](250) NULL,
	[DeleteFlag] [tinyint] default(0) NULL,
	[Disabled] [tinyint] default(0) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,

CONSTRAINT [PK_HT0267] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
 	[WorkID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

