-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 14/04/2015 by Hoàng Vũ: Add column into table AT7602 about [TT200]
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7602]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7602](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
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
	[Accumulator] [nvarchar](50) NULL,
	[Level1] [tinyint] NULL,
	[Suppress] [tinyint] NULL,
	[PrintStatus] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[ColStatus01] [tinyint] NULL,
	[ColStatus02] [tinyint] NULL,
	[ColStatus03] [tinyint] NULL,
	[ColStatus04] [tinyint] NULL,
	[ColStatus05] [tinyint] NULL,
	[ColStatus06] [tinyint] NULL,
	[IsLastPeriod] [tinyint] NULL,
	[LineDescriptionE] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT7602] PRIMARY KEY NONCLUSTERED 
(
	[ReportCode] ASC,
	[Type] ASC,
	[LineCode] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_D_C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_D_C]  DEFAULT ((0)) FOR [D_C]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_AmountSign]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_AmountSign]  DEFAULT ((2)) FOR [AmountSign]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_PeriodAmount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_PeriodAmount]  DEFAULT ((1)) FOR [PeriodAmount]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_Level1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_Level1]  DEFAULT ((3)) FOR [Level1]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_Suppress]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_Suppress]  DEFAULT ((0)) FOR [Suppress]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_PrintStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_PrintStatus]  DEFAULT ((0)) FOR [PrintStatus]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_Col01Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_Col01Status]  DEFAULT ((0)) FOR [ColStatus01]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_Col02Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_Col02Status]  DEFAULT ((0)) FOR [ColStatus02]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_Col03Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_Col03Status]  DEFAULT ((0)) FOR [ColStatus03]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_Col04Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_Col04Status]  DEFAULT ((0)) FOR [ColStatus04]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_Col05Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_Col05Status]  DEFAULT ((0)) FOR [ColStatus05]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7602_Col06Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7602] ADD  CONSTRAINT [DF_AT7602_Col06Status]  DEFAULT ((0)) FOR [ColStatus06]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT7602' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7602'  and col.name = 'DisplayedMark')
           Alter Table  AT7602 Add DisplayedMark tinyint default 0  --0: Hiện dấu dương, 1: Hiện dấu âm
END

