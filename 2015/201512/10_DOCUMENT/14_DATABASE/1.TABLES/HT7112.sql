-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT7112]') AND type in (N'U'))
CREATE TABLE [dbo].[HT7112](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[COL1] [ntext] NULL,
	[COL2] [ntext] NULL,
	[COL3] [ntext] NULL,
	[COL4] [ntext] NULL,
	[COL5] [ntext] NULL,
	[COL6] [ntext] NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	CONSTRAINT [PK_HT7112] PRIMARY KEY NONCLUSTERED
	(
	[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
