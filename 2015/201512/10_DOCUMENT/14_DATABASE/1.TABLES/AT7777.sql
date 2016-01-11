-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7777]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7777](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[UserID] [nvarchar](50) NULL,
	[Status] [tinyint] NULL,
	[Message] [nvarchar](250) NULL,
	[Value1] [nvarchar](250) NULL,
	[Value2] [nvarchar](250) NULL,
	[Value3] [nvarchar](250) NULL,
	[Value4] [nvarchar](250) NULL,
	[Value5] [nvarchar](250) NULL,
CONSTRAINT [PK_AT7777] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

