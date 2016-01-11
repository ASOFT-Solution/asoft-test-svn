-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 27/02/2012 by Huỳnh Tấn Phú
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT6100]') AND type in (N'U'))
CREATE TABLE [dbo].[AT6100](
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
	[ColumnACaption] [nvarchar](250) NULL,
	[ColumnBCaption] [nvarchar](250) NULL,
	[ColumnCCaption] [nvarchar](250) NULL,
	[ColumnDCaption] [nvarchar](250) NULL,
	[ColumnECaption] [nvarchar](250) NULL,
	[ColumnABudget] [nvarchar](50) NULL,
	[ColumnBBudget] [nvarchar](50) NULL,
	[ColumnCBudget] [nvarchar](50) NULL,
	[ColumnDBudget] [nvarchar](50) NULL,
	[ColumnEBudget] [nvarchar](50) NULL,
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
 CONSTRAINT [PK_AT6100] PRIMARY KEY NONCLUSTERED 
(
	[ReportCode] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT6100_IsUsedColA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6100] ADD  CONSTRAINT [DF_AT6100_IsUsedColA]  DEFAULT ((0)) FOR [IsUsedColA]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT6100_IsUsedColB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6100] ADD  CONSTRAINT [DF_AT6100_IsUsedColB]  DEFAULT ((0)) FOR [IsUsedColB]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT6100_IsUsedColC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6100] ADD  CONSTRAINT [DF_AT6100_IsUsedColC]  DEFAULT ((0)) FOR [IsUsedColC]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT6100_IsUsedColD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6100] ADD  CONSTRAINT [DF_AT6100_IsUsedColD]  DEFAULT ((0)) FOR [IsUsedColD]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT6100_IsUsedColE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT6100] ADD  CONSTRAINT [DF_AT6100_IsUsedColE]  DEFAULT ((0)) FOR [IsUsedColE]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT6100' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT6100'  and col.name = 'ChartType')
           Alter Table  AT6100 Add ChartType varchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'AT6100' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT6100'  and col.name = 'Data')
           Alter Table  AT6100 Add Data varchar(50) Null
END
If Exists (Select * From sysobjects Where name = 'AT6100' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT6100'  and col.name = 'x')
           Alter Table  AT6100 Add x varchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'AT6100' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT6100'  and col.name = 'y')
           Alter Table  AT6100 Add y varchar(50) Null
End