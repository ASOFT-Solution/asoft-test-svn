-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 14/04/2015 by Hoàng Vũ: Add column into table AT7902STD about [TT200]
---- Modified on 25/05/2012 by Thiên Huỳnh: remove primary key from table AT7902
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7902]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7902](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[ReportCode] [nvarchar](50) NULL,
	[Type] [tinyint] NULL,
	[LineCode] [nvarchar](50) NULL,
	[LineDescription] [nvarchar](250) NULL,
	[AccountIDFrom] [nvarchar](50) NULL,
	[AccountIDTo] [nvarchar](50) NULL,
	[D_C] [tinyint] NULL,
	[Detail] [tinyint] NULL,
	[ParrentLineID] [nvarchar](50) NULL,
	[Accumulator] [nvarchar](100) NULL,
	[Level1] [tinyint] NULL,
	[PrintStatus] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LineDescriptionE] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
CONSTRAINT [PK_AT7902] PRIMARY KEY NONCLUSTERED 
(
	[LineID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT7902' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7902'  and col.name = 'DisplayedMark')
           Alter Table  AT7902 Add DisplayedMark tinyint default 0  --0: Hiện dấu dương, 1: Hiện dấu âm
END
---- Alter Primary Key
Declare @SQL varchar(500),
		@PKName varchar(200)
If Exists (Select * From sysobjects Where name = 'AT7902' and xtype ='U')
Begin
	Select @PKName = pk.name From sysobjects pk inner join sysobjects tab
	On pk.parent_obj = tab.id where pk.xtype = 'PK' and tab.name = 'AT7902'
	
	If @PKName is not null
	Begin
		Set @SQL = 'Alter Table AT7902 Drop Constraint ' + @PKName
		Execute(@SQL)
	END
End
--Purpose : change data type of column ReportCode
Set @SQL = 'Alter Table AT7902 Alter Column ReportCode nvarchar(50) Not Null' 
Execute(@SQL)
--Purpose : Add primary key to table AT7902
Set @SQL = 'Alter Table AT7902 Add Constraint PK_AT7902 
			Primary Key Clustered (DivisionID, LineID, ReportCode)'
Execute(@SQL)