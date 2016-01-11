-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7907]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7907](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[GroupID] [nvarchar](50) NOT NULL,
	[TitleID] [nvarchar](50) NOT NULL,
	[LineDes] [nvarchar](250) NULL,
	[LineLevel] [tinyint] NULL,
	[OperatorID] [nvarchar](50) NULL,
CONSTRAINT [PK_AT7907] PRIMARY KEY CLUSTERED 
(
	[ReportCode] ASC,
	[TitleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7907_LineLevel]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7907] ADD  CONSTRAINT [DF_AT7907_LineLevel]  DEFAULT ((2)) FOR [LineLevel]
END
---- Alter Columns
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT7907]') AND TYPE IN (N'U'))
BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS TB
			WHERE TB.CONSTRAINT_NAME ='PK_AT7907')
	BEGIN
		ALTER TABLE AT7907
		DROP  CONSTRAINT PK_AT7907
	END
	ALTER TABLE AT7907
	ALTER COLUMN APK  UNIQUEIDENTIFIER NOT NULL
	ALTER TABLE AT7907
	ADD CONSTRAINT PK_AT7907 PRIMARY KEY (APK)
END