-- <Summary>
---- 
-- <History>
---- Create on 21/12/2010 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT3000]') AND type in (N'U'))
CREATE TABLE [dbo].[AT3000](
	[APK] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ReportID] [nvarchar](50) NOT NULL,
	[ReportName] [nvarchar](250) NOT NULL,
	[Pages] [int] NOT NULL,
	[Page1] [nvarchar](250) NOT NULL,
	[Page2] [nvarchar](250) NULL,
	[Page3] [nvarchar](250) NULL,
	[Page4] [nvarchar](250) NULL,
	[Page5] [nvarchar](250) NULL,
	[Page6] [nvarchar](250) NULL,
	[Page7] [nvarchar](250) NULL,
	[Page8] [nvarchar](250) NULL,
	[Page9] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT3000] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
