-- <Summary>
---- 
-- <History>
---- Create on 09/08/2010 by Ngoc Nhut
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ST1500]') AND type in (N'U'))
CREATE TABLE [dbo].[ST1500](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[KeywordID] [nvarchar](50) NOT NULL,
	[KeywordName] [nvarchar](250) NULL,
	[KeywordContent] [nvarchar](100) NULL,
	[QuerySQL] [nvarchar](500) NULL,
	[AnswerText] [nvarchar](100) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_ST1500] PRIMARY KEY NONCLUSTERED 
(
	[KeywordID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ST1500_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ST1500] ADD  CONSTRAINT [DF_ST1500_Disabled]  DEFAULT ((0)) FOR [Disabled]
END