-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on 22/12/2011 by Nguyễn Bình Minh
---- Modified on 27/03/2013 by Bảo Quỳnh
---- Modified on 15/04/2015 by Hoàng Vũ: Add column into table AT7915 about [TT200] => Báo cáo bảng cân đối kế toán
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7915]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7915](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[LineCode] [nvarchar](50) NULL,
	[LineDescription] [nvarchar](250) NULL,
	[PrintStatus] [tinyint] NULL,
	[Amount1] [decimal](28, 8) NULL,
	[Amount2] [decimal](28, 8) NULL,
	[Level1] [tinyint] NULL,
	[Type] [tinyint] NULL,
	[Accumulator] [nvarchar](100) NULL,
	[LineDescriptionE] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
CONSTRAINT [PK_AT7915] PRIMARY KEY NONCLUSTERED 
(
	[LineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
IF(ISNULL(COL_LENGTH('AT7915', 'Amount3'), 0) <= 0)
	ALTER TABLE AT7915 ADD Amount3 DECIMAL(28, 8) NULL
IF(ISNULL(COL_LENGTH('AT7915', 'Amount4'), 0) <= 0)
	ALTER TABLE AT7915 ADD Amount4 DECIMAL(28, 8) NULL
If Exists (Select * From sysobjects Where name = 'AT7915' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7915'  and col.name = 'DisplayedMark')
           Alter Table  AT7915 Add DisplayedMark tinyint default 0 NULL --0: Hiện dấu dương, 1: Hiện dấu âm
END