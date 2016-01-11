-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on 14/04/2015 by Hoàng Vũ: Add column into table AT6502 about [TT200]
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT6502]') AND type in (N'U'))
CREATE TABLE [dbo].[AT6502](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[LineCode] [nvarchar](50) NOT NULL,
	[LineDescription] [nvarchar](250) NULL,
	[PrintCode] [nvarchar](50) NULL,
	[AccountIDFrom] [nvarchar](50) NULL,
	[AccountIDTo] [nvarchar](50) NULL,
	[CorAccountIDFrom] [nvarchar](50) NULL,
	[CorAccountIDTo] [nvarchar](50) NULL,
	[D_C] [tinyint] NULL,
	[AmountSign] [tinyint] NULL,
	[PeriodAmount] [tinyint] NULL,
	[AccuSign] [nvarchar](5) NULL,
	[Accumulator] [nvarchar](100) NULL,
	[Level1] [tinyint] NULL,
	[Suppress] [tinyint] NULL,
	[PrintStatus] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LineDescriptionE] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT6502] PRIMARY KEY NONCLUSTERED 
(
	[ReportCode] ASC,
	[LineCode] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add gia trị defalt
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT6502_D_C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6502] ADD  CONSTRAINT [DF_AT6502_D_C]  DEFAULT ((0)) FOR [D_C]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT6502_AmountSign]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6502] ADD  CONSTRAINT [DF_AT6502_AmountSign]  DEFAULT ((0)) FOR [AmountSign]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT6502_PrintStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6502] ADD  CONSTRAINT [DF_AT6502_PrintStatus]  DEFAULT ((0)) FOR [PrintStatus]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT6502' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT6502'  and col.name = 'DisplayedMark')
           Alter Table  AT6502 Add DisplayedMark tinyint default 0 --0: Hiện dấu dương, 1: Hiện dấu âm
END