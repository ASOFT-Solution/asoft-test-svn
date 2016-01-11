-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1410]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1410](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ModuleID] [nvarchar](50) NOT NULL,
	[ModuleName] [nvarchar](250) NULL,
	[ModuleNameE] [nvarchar](250) NULL,
	[GroupID] [nvarchar](50) NULL,
	[Status] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT1410] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1410_Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1410] ADD  CONSTRAINT [DF_AT1410_Status]  DEFAULT ((0)) FOR [Status]
END
