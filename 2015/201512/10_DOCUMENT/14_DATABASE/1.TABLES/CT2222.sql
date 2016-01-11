-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CT2222]') AND type in (N'U'))
CREATE TABLE [dbo].[CT2222](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TablesName] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[FieldID] [nvarchar](50) NOT NULL,
	[Type] [tinyint] NULL,
	[Orders] [tinyint] NULL,
	[Disabled] [tinyint] NOT NULL,
 CONSTRAINT [PK_CT2222] PRIMARY KEY CLUSTERED 
(
	[FieldID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]