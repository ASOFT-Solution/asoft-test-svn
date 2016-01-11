-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1702]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1702](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[LevelID] [nvarchar](50) NOT NULL,
	[LevelName] [nvarchar](250) NULL,
	[WorkID] [nvarchar](50) NOT NULL,
	[Orders] [int] NULL,
 CONSTRAINT [PK_MT1702] PRIMARY KEY CLUSTERED 
(
	[LevelID] ASC,
	[WorkID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
