-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 14/04/2015 by Hoàng Vũ: Add column into table AT7604 about [TT200]=> Báo cáo kết quả kính doanh
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7604]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7604](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[LineCode] [nvarchar](50) NOT NULL,
	[LineDescription] [nvarchar](250) NULL,
	[PrintCode] [nvarchar](50) NULL,
	[Amount1] [decimal](28, 8) NULL,
	[Amount2] [decimal](28, 8) NULL,
	[Amount3] [decimal](28, 8) NULL,
	[AccuSign] [nvarchar](5) NULL,
	[Accumulator] [nvarchar](100) NULL,
	[Level1] [tinyint] NULL,
	[PrintStatus] [tinyint] NULL,
	[LineDescriptionE] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT7604] PRIMARY KEY NONCLUSTERED 
(
	[LineCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7604_Amount1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7604] ADD  CONSTRAINT [DF_AT7604_Amount1]  DEFAULT ((0)) FOR [Amount1]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7604_Amount2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7604] ADD  CONSTRAINT [DF_AT7604_Amount2]  DEFAULT ((0)) FOR [Amount2]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7604_Amount3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7604] ADD  CONSTRAINT [DF_AT7604_Amount3]  DEFAULT ((0)) FOR [Amount3]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7604_PrintStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7604] ADD  CONSTRAINT [DF_AT7604_PrintStatus]  DEFAULT ((1)) FOR [PrintStatus]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT7604' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7604'  and col.name = 'DisplayedMark')
           Alter Table  AT7604 Add DisplayedMark tinyint default 0 --0: Hiện dấu dương, 1: Hiện dấu âm
END