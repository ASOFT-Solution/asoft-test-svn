-- <Summary>
---- 
-- <History>
---- Create on 22/12/2010 by Vĩnh Phong
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[A00004STD]') AND type in (N'U'))
CREATE TABLE [dbo].[A00004STD](
	[ModuleID] [nvarchar](50) NULL,
	[ScreenID] [nvarchar](50) NULL,
	[CommandMenu] [nvarchar](50) NULL
) ON [PRIMARY]
