-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT3335]') AND type in (N'U'))
CREATE TABLE [dbo].[AT3335](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ModuleID] [nvarchar](50) NOT NULL,
	[SQLString] [nvarchar](1000) NOT NULL,
	[OrderBy] [nvarchar](1000) NULL,
	[Style] [nvarchar](100) NULL,
	[Description] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT3335] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
