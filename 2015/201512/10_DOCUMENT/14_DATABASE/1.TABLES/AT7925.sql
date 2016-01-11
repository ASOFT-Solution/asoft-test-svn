-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7925]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7925](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[LineCode] [nvarchar](50) NULL,
	[LineDescription] [nvarchar](250) NULL,
	[PrintStatus] [tinyint] NULL,
	[Amount1] [decimal](28, 8) NULL,
	[Amount2] [decimal](28, 8) NULL,
	[Amount3] [decimal](28, 8) NULL,
	[Amount4] [decimal](28, 8) NULL,
	[Amount5] [decimal](28, 8) NULL,
	[Amount6] [decimal](28, 8) NULL,
	[Amount7] [decimal](28, 8) NULL,
	[Amount8] [decimal](28, 8) NULL,
	[Amount9] [decimal](28, 8) NULL,
	[Amount10] [decimal](28, 8) NULL,
	[Amount11] [decimal](28, 8) NULL,
	[Amount12] [decimal](28, 8) NULL,
	[Amount13] [decimal](28, 8) NULL,
	[Amount14] [decimal](28, 8) NULL,
	[Amount15] [decimal](28, 8) NULL,
	[Amount16] [decimal](28, 8) NULL,
	[Amount17] [decimal](28, 8) NULL,
	[Amount18] [decimal](28, 8) NULL,
	[Amount19] [decimal](28, 8) NULL,
	[Amount20] [decimal](28, 8) NULL,
	[Level1] [tinyint] NULL,
	[Type] [tinyint] NULL,
	[Accumulator] [nvarchar](100) NULL,
	[LineDescriptionE] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
CONSTRAINT [PK_AT7925] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

