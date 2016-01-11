-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1619]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1619](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EndMethodID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[IsApportion] [tinyint] NULL,
 CONSTRAINT [PK_MT1619] PRIMARY KEY NONCLUSTERED 
(
	[EndMethodID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
