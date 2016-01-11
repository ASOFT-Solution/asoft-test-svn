-- <Summary>
---- 
-- <History>
---- Create on 29/01/2011 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7903STD]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7903STD](
	[ReportCode] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[ReportID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL
) ON [PRIMARY]


