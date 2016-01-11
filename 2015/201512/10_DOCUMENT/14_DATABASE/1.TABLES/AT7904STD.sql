-- <Summary>
---- 
-- <History>
---- Create on 29/01/2011 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7904STD]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7904STD](
	[ReportCode] [nvarchar](50) NOT NULL,
	[TitleName] [nvarchar](250) NULL,
	[TitleID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](4000) NULL,
	[SubTitleName] [nvarchar](250) NULL,
	[GroupID] [nvarchar](50) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL
) ON [PRIMARY]
