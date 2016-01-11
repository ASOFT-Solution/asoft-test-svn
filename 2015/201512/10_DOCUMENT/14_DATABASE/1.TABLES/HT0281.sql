-- <Summary>
---- 
-- <History>
---- Create on 23/08/2013 by Thanh Sơn
---- Modified on 07/08/2013 by Le Thi Thu Hien
---- Modified on 22/08/2013 by Nguyen Thanh Son
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0281]') AND type in (N'U')) 
BEGIN
	CREATE TABLE [dbo].[HT0281](
		[APK] [uniqueidentifier] DEFAULT NEWID(),
		[DivisionID] [nvarchar](50) NOT NULL,
		[EmployeeID] [nvarchar] (50)NOT NULL,
		[FromDate] [Datetime] NULL,
		[ToDate] [DateTime] NULL,
		[TranMonth]INT,
		[TranYear] INT,
		[FromShiftID] [nvarchar] (50) NULL,
		[ToShiftID] [varchar] (50) NULL,
		[Salary] [decimal] (28,8) NULL,
		[Notes] [nvarchar] (1500) NULL,
		[CreateUserID] [nvarchar](50) NULL,
		[CreateDate] [datetime] NULL,
		[LastModifyUserID] [nvarchar](50) NULL,
		[LastModifyDate] [datetime] NULL,
	 CONSTRAINT [PK_HT0281] PRIMARY KEY CLUSTERED 
	(
		[APK] ASC,
 		[DivisionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT0281' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0281'  and col.name = 'TranMonth')
           Alter Table  HT0281 ADD TranMonth INT Null
End 
If Exists (Select * From sysobjects Where name = 'HT0281' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0281'  and col.name = 'TranYear')
           Alter Table  HT0281 Add TranYear INT Null
End 
If Exists (Select * From sysobjects Where name = 'HT0281' and xtype ='U') 
Begin
           If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0281'  and col.name = 'Salary')
           Alter Table HT0281 drop column Salary
END
If Exists (Select * From sysobjects Where name = 'HT0281' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0281'  and col.name = 'DayCoefficient')
           Alter Table  HT0281 ADD DayCoefficient DECIMAL(28,8) Null
End 