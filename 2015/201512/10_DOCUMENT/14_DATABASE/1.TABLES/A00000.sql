-- <Summary>
---- 
-- <History>
---- Create on 22/12/2010 by Vĩnh Phong
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[A00000]') AND type in (N'U'))
CREATE TABLE [dbo].[A00000](
	[LanguageID] [varchar](10) NOT NULL,
	[LanguageName] [nvarchar](50) NOT NULL,
	[InsertDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[Version] [varchar](10) NULL,
	[Module] [varchar](2) NOT NULL,
	[Type] [varchar](1) NOT NULL,
 CONSTRAINT [PK_A00000] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC,
	[Module] ASC,
	[Type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Alter Primary Key
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[A00000]') AND name = N'PK_A00000')
ALTER TABLE [dbo].[A00000] DROP CONSTRAINT [PK_A00000]
ALTER TABLE [A00000] ALTER COLUMN  [Module] [nvarchar](5) NOT NULL
ALTER TABLE [A00000] ALTER COLUMN  [Type] [nvarchar](5) NOT NULL
ALTER TABLE [dbo].[A00000] ADD  CONSTRAINT [PK_A00000] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC,
	[Module] ASC,
	[Type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
