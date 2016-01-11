-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1404STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT1404STD](
	[ModuleID] [nvarchar](50) NOT NULL,
	[ScreenID] [nvarchar](50) NOT NULL,
	[ScreenName] [nvarchar](250) NULL,
	[ScreenType] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[ScreenNameE] [nvarchar](250) NULL
) ON [PRIMARY]
END