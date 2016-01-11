-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on 27/01/2013 by Huỳnh Tấn Phú
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7620]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7620](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[Title] [nvarchar](250) NULL,
	[TitleE] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[ReportID] [nvarchar](50) NULL,
	[FieldID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_AT7620] PRIMARY KEY CLUSTERED 
(
	[ReportCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7620_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7620] ADD  CONSTRAINT [DF_AT7620_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT7620' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7620'  and col.name = 'ChartType')
           Alter Table  AT7620 Add ChartType varchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'AT7620' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7620'  and col.name = 'Data')
           Alter Table  AT7620 Add Data varchar(50) Null
END
If Exists (Select * From sysobjects Where name = 'AT7620' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7620'  and col.name = 'x')
           Alter Table  AT7620 Add x varchar(50) Null
End 
If Exists (Select * From sysobjects Where name = 'AT7620' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7620'  and col.name = 'y')
           Alter Table  AT7620 Add y varchar(50) Null
End