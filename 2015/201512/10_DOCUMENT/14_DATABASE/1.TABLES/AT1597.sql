-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1597]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1597](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[LineDescription] [nvarchar](250) NULL,
	[PrintStatus] [tinyint] NULL,
	[Amount01] [decimal](28, 8) NULL,
	[Amount02] [decimal](28, 8) NULL,
	[Amount03] [decimal](28, 8) NULL,
	[Amount04] [decimal](28, 8) NULL,
	[Amount05] [decimal](28, 8) NULL,
	[Amount06] [decimal](28, 8) NULL,
	[Amount07] [decimal](28, 8) NULL,
	[Amount08] [decimal](28, 8) NULL,
	[Amount09] [decimal](28, 8) NULL,
	[Amount10] [decimal](28, 8) NULL,
	[Level1] [tinyint] NULL,
	[Accumulator] [nvarchar](100) NULL,
	[LineDescriptionE] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[Sign] [nvarchar](5) NULL,
	CONSTRAINT [PK_AT1597] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
