-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 19/02/2013 by Lê Thị Thu Hiền
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT4700]') AND type in (N'U'))
CREATE TABLE [dbo].[AT4700](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[ReportName1] [nvarchar](250) NOT NULL,
	[ReportName2] [nvarchar](250) NULL,
	[Selection01] [nvarchar](100) NULL,
	[Selection02] [nvarchar](100) NULL,
	[Selection03] [nvarchar](100) NULL,
	[Selection04] [nvarchar](100) NULL,
	[Selection05] [nvarchar](100) NULL,
	[Level01] [nvarchar](100) NULL,
	[Level02] [nvarchar](100) NULL,
	[Level03] [nvarchar](100) NULL,
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
	[Level00] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT4700] PRIMARY KEY NONCLUSTERED 
(
	[ReportCode] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT4700_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4700] ADD  CONSTRAINT [DF_AT4700_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT4700' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT4700'  and col.name = 'ChartType')
           Alter Table  AT4700 Add ChartType varchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'AT4700' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT4700'  and col.name = 'x')
           Alter Table  AT4700 Add x varchar(50) Null
END
If Exists (Select * From sysobjects Where name = 'AT4700' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT4700'  and col.name = 'Data')
           Alter Table  AT4700 Add Data varchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'AT4700' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT4700'  and col.name = 'y')
           Alter Table  AT4700 Add y varchar(50) Null
End