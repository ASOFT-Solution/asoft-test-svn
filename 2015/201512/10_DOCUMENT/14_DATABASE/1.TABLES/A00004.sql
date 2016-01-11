-- <Summary>
---- 
-- <History>
---- Create on 22/12/2010 by Vĩnh Phong
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[A00004]') AND type in (N'U'))
CREATE TABLE [dbo].[A00004](
	[APK] [varbinary](16) NOT NULL,
	[DivisionID] [nvarchar](3) NULL,
	[ModuleID] [nvarchar](50) NULL,
	[ScreenID] [nvarchar](50) NULL,
	[CommandMenu] [nvarchar](50) NULL,
 CONSTRAINT [PK_A00004_1] PRIMARY KEY CLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_A00004_APK_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[A00004] ADD  CONSTRAINT [DF_A00004_APK_1]  DEFAULT (newid()) FOR [APK]
END