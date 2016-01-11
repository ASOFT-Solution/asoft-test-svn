-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT5555]') AND type in (N'U'))
CREATE TABLE [dbo].[AT5555](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ModuleID] [nvarchar](50) NOT NULL,
	[SQLString] [nvarchar](1000) NOT NULL,
	[OrderBy] [nvarchar](1000) NULL,
	[Style] [nvarchar](100) NULL,
	[Description] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT5555] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
