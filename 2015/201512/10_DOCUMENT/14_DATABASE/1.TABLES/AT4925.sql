-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT4925]') AND type in (N'U'))
CREATE TABLE [dbo].[AT4925](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[LineID] [nvarchar](50) NULL,
	[Level01] [nvarchar](50) NULL,
	[Level01Desc] [nvarchar](250) NULL,
	[Level02] [nvarchar](50) NULL,
	[Level02Desc] [nvarchar](250) NULL,
	[LineCode] [nvarchar](50) NULL,
	[LineSubCode] [int] NULL,
	[LineDesc] [nvarchar](250) NULL,
	[AccuSign] [nvarchar](5) NULL,
	[Accumulator] [nvarchar](100) NULL,
	[ColumnA] [decimal](28, 8) NULL,
	[ColumnB] [decimal](28, 8) NULL,
	[ColumnC] [decimal](28, 8) NULL,
	[ColumnD] [decimal](28, 8) NULL,
	[ColumnE] [decimal](28, 8) NULL,
	[ColumnF] [decimal](28, 8) NULL,
	[ColumnG] [decimal](28, 8) NULL,
	[ColumnH] [decimal](28, 8) NULL,
	[PrintStatus] [tinyint] NULL,
	[LevelPrint] [tinyint] NULL,
	CONSTRAINT [PK_AT4925s] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

) ON [PRIMARY]

