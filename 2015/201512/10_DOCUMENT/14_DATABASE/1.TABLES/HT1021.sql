-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1021]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1021](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ShiftID] [nvarchar](50) NOT NULL,
	[AbsentTypeID] [nvarchar](50) NULL,
	[ConvertUnit] [decimal](28, 8) NULL,
	[AbsentAmount] [decimal](28, 8) NULL,
	[FromHour] [int] NULL,
	[ToHour] [int] NULL,
	[FromMinute] [int] NULL,
	[ToMinute] [int] NULL,
	[IsOvertime] [tinyint] NOT NULL,
	[RestrictID] [nvarchar](50) NULL,
	[DateTypeID] [nvarchar](50) NULL,
	[IsNextDay] [tinyint] NOT NULL,
	[Orders] [int] NULL,
	CONSTRAINT [PK_HT1021] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT1021__IsOverti__6F573691]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1021] ADD  CONSTRAINT [DF__HT1021__IsOverti__6F573691]  DEFAULT ((0)) FOR [IsOvertime]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT1021__IsNextDa__704B5ACA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1021] ADD  CONSTRAINT [DF__HT1021__IsNextDa__704B5ACA]  DEFAULT ((0)) FOR [IsNextDay]
END
---- Alter Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='HT1021' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='HT1021' AND col.name='FromMinute')
		ALTER TABLE HT1021 ALTER COLUMN FromMinute NVARCHAR(100) NULL 
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='HT1021' AND xtype='U')
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='HT1021' AND col.name='ToMinute')
		ALTER TABLE HT1021 ALTER COLUMN ToMinute NVARCHAR(100) NULL 
	END