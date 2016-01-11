-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on 26/07/2013 by Bao Anh
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1101]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1101](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,	
	[DepartmentID] [nvarchar](50) NOT NULL,
	[TeamID] [nvarchar](50) NOT NULL,
	[TeamName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Notes] [nvarchar](250) NULL,
	[Notes01] [nvarchar](250) NULL,
 CONSTRAINT [PK_HT1101] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[DepartmentID] ASC,
	[TeamID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT1101' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1101'  and col.name = 'AccountID')
           Alter Table  HT1101 Add AccountID nvarchar(50) NULL
END
If Exists (Select * From sysobjects Where name = 'HT1101' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1101'  and col.name = 'WorkID')
           Alter Table  HT1101 Add WorkID nvarchar(50) Null
End 