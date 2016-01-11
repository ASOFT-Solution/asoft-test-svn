-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1206]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1206](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DebtAgeStepID] [nvarchar](50) NOT NULL,
	[AgeID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Orders] [tinyint] NOT NULL,
	[FromDay] [int] NULL,
	[ToDay] [int] NULL,
	[Title] [nvarchar](250) NULL,
	[DefinedUserID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1206] PRIMARY KEY CLUSTERED 
(
	[AgeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


