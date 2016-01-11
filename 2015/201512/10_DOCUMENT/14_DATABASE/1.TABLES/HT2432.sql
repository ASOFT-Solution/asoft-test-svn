-- <Summary>
---- 
-- <History>
---- Create on 21/01/2013 by Bảo Anh
---- Modified on 25/05/2012 by Thiên Huỳnh: remove primary key from table HT2432
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2432]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[HT2432](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar] (3) NOT NULL,
		[ProjectID] [nvarchar] (50) NOT NULL,
		[PeriodID] [nvarchar] (50) NULL,
		[EmployeeID] [nvarchar](50) NOT NULL,
		[TranMonth] [int] NOT NULL,
		[TranYear] [int] NOT NULL,
		[DepartmentID] [nvarchar](50) NOT NULL,
		[TeamID] [nvarchar](50) NULL,
		[AbsentTypeID] [nvarchar](50) NULL,
		[AbsentAmount] [decimal](28, 8) NULL,
		[CreateDate] [datetime] NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
		CONSTRAINT [PK_HT2432] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
---- Alter Primary Key
Declare @SQL varchar(500),
		@PKName varchar(200)
If Exists (Select * From sysobjects Where name = 'HT2432' and xtype ='U')
Begin
	Select @PKName = pk.name From sysobjects pk inner join sysobjects tab
	On pk.parent_obj = tab.id where pk.xtype = 'PK' and tab.name = 'HT2432'	
	If @PKName is not null
	Begin
		Set @SQL = 'Alter Table HT2432 Drop Constraint ' + @PKName
		Execute(@SQL)
	END
End
--Purpose : Add primary key to table HT2432
Set @SQL = 'Alter Table HT2432 Add Constraint PK_HT2432 
			Primary Key Clustered (APK)'
Execute(@SQL)