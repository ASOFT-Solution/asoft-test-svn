-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7905]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7905](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[TitleID] [nvarchar](50) NOT NULL,
	[TitleName] [nvarchar](250) NULL,
	[LineDes] [nvarchar](250) NULL,
	[FromAccountID] [nvarchar](50) NULL,
	[ToAccountID] [nvarchar](50) NULL,
	[OperatorID] [nvarchar](50) NULL,
	[GroupID] [nvarchar](50) NULL,
	[FromCorAccountID] [nvarchar](50) NULL,
	[ToCorAccountID] [nvarchar](50) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
CONSTRAINT [PK_AT7905] PRIMARY KEY CLUSTERED 
(
	[ReportCode] ASC,
	[TitleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]