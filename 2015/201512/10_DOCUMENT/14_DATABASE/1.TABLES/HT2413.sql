-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on 26/03/2013 by Bảo Anh: Thay khoa chinh la APK
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2413]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2413](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TimesID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[DepartmentID] [nvarchar](50) NOT NULL,
	[TeamID] [nvarchar](50) NOT NULL,
	[ProductID] [nvarchar](50) NOT NULL,
	[Quantity] [decimal](28, 8) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[UnitID] [nvarchar](50) NULL,
	[OriginalQuantity] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT2413] PRIMARY KEY NONCLUSTERED 
(
	[TimesID] ASC,
	[TranMonth] ASC,
	[TranYear] ASC,
	[DepartmentID] ASC,
	[TeamID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Alter Primary Key
Declare @SQL varchar(500),
		@PKName varchar(200)
If Exists (Select * From sysobjects Where name = 'HT2413' and xtype ='U')
Begin
	Select @PKName = pk.name From sysobjects pk inner join sysobjects tab
	On pk.parent_obj = tab.id where pk.xtype = 'PK' and tab.name = 'HT2413'
	
	If @PKName is not null
	Begin
		Set @SQL = 'Alter Table HT2413 Drop Constraint ' + @PKName
		Execute(@SQL)
	END
End
--Purpose : Add primary key to table HT2413
Alter table HT2413 Alter column APK uniqueidentifier NOT NULL
Alter Table HT2413 Add Constraint PK_HT2413 Primary Key Clustered (APK)
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT2413' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT2413'  and col.name = 'TrackingDate')
           Alter Table  HT2413 Add TrackingDate datetime NULL
END