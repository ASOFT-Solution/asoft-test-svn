-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT9011]') AND type in (N'U'))
CREATE TABLE [dbo].[AT9011](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[ColumnID] [nvarchar](50) NOT NULL,
	[ColumnName] [nvarchar](250) NULL,
	[SysColumnName] [nvarchar](250) NULL,
	[Orders] [int] NOT NULL,
	[IsChosen] [tinyint] NOT NULL,
CONSTRAINT [PK_AT9011] PRIMARY KEY CLUSTERED 
(
	[ColumnID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


