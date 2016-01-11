-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT4725]') AND type in (N'U'))
CREATE TABLE [dbo].[AT4725](
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
	[PrintStatus] [tinyint] NULL,
	[LevelPrint] [tinyint] NULL,
	[Amount01] [decimal](28, 8) NULL,
	[Amount02] [decimal](28, 8) NULL,
	[Amount03] [decimal](28, 8) NULL,
	[Amount04] [decimal](28, 8) NULL,
	[Amount05] [decimal](28, 8) NULL,
	[Note01] [nvarchar](250) NULL,
	[Note02] [nvarchar](250) NULL,
	[Note03] [nvarchar](250) NULL,
	[Note04] [nvarchar](250) NULL,
	[Note05] [nvarchar](250) NULL,
	CONSTRAINT [PK_AT4725] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

) ON [PRIMARY]

