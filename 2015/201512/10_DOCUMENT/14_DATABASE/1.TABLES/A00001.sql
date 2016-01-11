-- <Summary>
---- 
-- <History>
---- Create on 22/12/2010 by Vĩnh Phong
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[A00001]') AND type in (N'U'))
CREATE TABLE [dbo].[A00001](
	[ID] [varchar](100) NOT NULL,
	[LanguageID] [varchar](10) NOT NULL,
	[Name] [nvarchar](2000) NULL,
	[InsertDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[Module] [varchar](5) NOT NULL,
	[Deleted] [bit] NULL DEFAULT ((0)),
 CONSTRAINT [PK_A00001] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[LanguageID] ASC,
	[Module] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
IF(ISNULL(COL_LENGTH('A00001', 'CustomName'), 0) <= 0)
ALTER TABLE A00001 ADD CustomName NVARCHAR(100)
If Exists (Select * From sysobjects Where name = 'A00001' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'A00001'  and col.name = 'FormID')
           Alter Table A00001 Add FormID nvarchar(50) Null
END
