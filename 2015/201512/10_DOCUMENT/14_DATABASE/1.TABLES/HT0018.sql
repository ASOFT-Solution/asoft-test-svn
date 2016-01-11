-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0018]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0018](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ImportMethod] [nvarchar](100) NOT NULL,
	[Tab_char] [tinyint] NOT NULL,
	[Space_char] [tinyint] NOT NULL,
	[Semilicon_char] [tinyint] NOT NULL,
	[Comma_char] [tinyint] NOT NULL,
	[Others_char] [tinyint] NOT NULL,
	[Others_Define] [nchar](100) NULL,
	[S_InCode] [nvarchar](50) NULL,
	[S_OutCode] [nvarchar](50) NULL,
	CONSTRAINT [PK_HT0018] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
