-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on 27/02/2013 by Huỳnh Tấn Phú
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT6200]') AND type in (N'U'))
CREATE TABLE [dbo].[AT6200](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[ReportName1] [nvarchar](250) NOT NULL,
	[ReportName2] [nvarchar](250) NULL,
	[IsUsedColA] [tinyint] NOT NULL,
	[IsUsedColB] [tinyint] NOT NULL,
	[IsUsedColC] [tinyint] NOT NULL,
	[IsUsedColD] [tinyint] NOT NULL,
	[IsUsedColE] [tinyint] NOT NULL,
	[IsUsedColF] [tinyint] NOT NULL,
	[IsUsedColG] [tinyint] NOT NULL,
	[IsUsedColH] [tinyint] NOT NULL,
	[ColumnACaption] [nvarchar](250) NULL,
	[ColumnBCaption] [nvarchar](250) NULL,
	[ColumnCCaption] [nvarchar](250) NULL,
	[ColumnDCaption] [nvarchar](250) NULL,
	[ColumnECaption] [nvarchar](250) NULL,
	[ColumnFCaption] [nvarchar](250) NULL,
	[ColumnGCaption] [nvarchar](250) NULL,
	[ColumnHCaption] [nvarchar](250) NULL,
	[ColumnABudget] [nvarchar](50) NULL,
	[ColumnBBudget] [nvarchar](50) NULL,
	[ColumnCBudget] [nvarchar](50) NULL,
	[ColumnDBudget] [nvarchar](50) NULL,
	[ColumnEBudget] [nvarchar](50) NULL,
	[ColumnFBudget] [nvarchar](50) NULL,
	[ColumnGBudget] [nvarchar](50) NULL,
	[ColumnHBudget] [nvarchar](50) NULL,
	[ColumnAPeriodType] [nvarchar](50) NULL,
	[ColumnBPeriodType] [nvarchar](50) NULL,
	[ColumnCPeriodType] [nvarchar](50) NULL,
	[ColumnDPeriodType] [nvarchar](50) NULL,
	[ColumnEPeriodType] [nvarchar](50) NULL,
	[ColumnFPeriodType] [nvarchar](50) NULL,
	[ColumnGPeriodType] [nvarchar](50) NULL,
	[ColumnHPeriodType] [nvarchar](50) NULL,
	[Selection01] [nvarchar](50) NULL,
	[Selection02] [nvarchar](50) NULL,
	[Selection03] [nvarchar](50) NULL,
	[Selection04] [nvarchar](50) NULL,
	[Selection05] [nvarchar](50) NULL,
	[Level01] [nvarchar](50) NULL,
	[Level02] [nvarchar](50) NULL,
	[BracketNegative] [tinyint] NULL,
	[DecimalPlaces] [tinyint] NULL,
	[AmountFormat] [tinyint] NULL,
	[Customized] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Disabled] [tinyint] NOT NULL,
	[ReportID] [nvarchar](50) NULL,
	[LineZeroSuppress] [tinyint] NULL,
CONSTRAINT [PK_AT6200] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Tmp_AT620__IsUse__08771EBF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6200] ADD  CONSTRAINT [DF__Tmp_AT620__IsUse__08771EBF]  DEFAULT ((1)) FOR [IsUsedColA]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Tmp_AT620__IsUse__096B42F8]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6200] ADD  CONSTRAINT [DF__Tmp_AT620__IsUse__096B42F8]  DEFAULT ((1)) FOR [IsUsedColB]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Tmp_AT620__IsUse__0A5F6731]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6200] ADD  CONSTRAINT [DF__Tmp_AT620__IsUse__0A5F6731]  DEFAULT ((1)) FOR [IsUsedColC]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Tmp_AT620__IsUse__0B538B6A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6200] ADD  CONSTRAINT [DF__Tmp_AT620__IsUse__0B538B6A]  DEFAULT ((1)) FOR [IsUsedColD]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Tmp_AT620__IsUse__0C47AFA3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6200] ADD  CONSTRAINT [DF__Tmp_AT620__IsUse__0C47AFA3]  DEFAULT ((1)) FOR [IsUsedColE]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Tmp_AT620__IsUse__0D3BD3DC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6200] ADD  CONSTRAINT [DF__Tmp_AT620__IsUse__0D3BD3DC]  DEFAULT ((1)) FOR [IsUsedColF]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Tmp_AT620__IsUse__0E2FF815]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6200] ADD  CONSTRAINT [DF__Tmp_AT620__IsUse__0E2FF815]  DEFAULT ((1)) FOR [IsUsedColG]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Tmp_AT620__IsUse__0F241C4E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6200] ADD  CONSTRAINT [DF__Tmp_AT620__IsUse__0F241C4E]  DEFAULT ((1)) FOR [IsUsedColH]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT6200' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT6200'  and col.name = 'ChartType')
           Alter Table  AT6200 Add ChartType varchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'AT6200' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT6200'  and col.name = 'Data')
           Alter Table  AT6200 Add Data varchar(50) Null
End 

If Exists (Select * From sysobjects Where name = 'AT6200' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT6200'  and col.name = 'x')
           Alter Table  AT6200 Add x varchar(50) Null
End 

If Exists (Select * From sysobjects Where name = 'AT6200' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT6200'  and col.name = 'y')
           Alter Table  AT6200 Add y varchar(50) Null
End