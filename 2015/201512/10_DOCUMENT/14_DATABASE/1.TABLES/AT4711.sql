-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 19/02/2013 by Lê Thị Thu Hiền
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT4711]') AND type in (N'U'))
CREATE TABLE [dbo].[AT4711](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[ReportName] [nvarchar](250) NOT NULL,
	[Title] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[ReportID] [nvarchar](50) NULL,
	[Filter1ID] [nvarchar](50) NULL,
	[Filter2ID] [nvarchar](50) NULL,
	[Filter3ID] [nvarchar](50) NULL,
	[Filter4ID] [nvarchar](50) NULL,
	[Filter5ID] [nvarchar](50) NULL,
	[GroupID] [nvarchar](50) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_AT4711] PRIMARY KEY NONCLUSTERED 
(
	[ReportCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT4711' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT4711'  and col.name = 'ChartType')
           Alter Table  AT4711 Add ChartType varchar(50) Null
End 
GO
