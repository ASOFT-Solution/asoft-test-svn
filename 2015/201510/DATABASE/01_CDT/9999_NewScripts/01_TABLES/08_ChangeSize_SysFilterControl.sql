USE [CDT]
GO

Declare @DefaultName varchar(200), @DefaultText varchar(200), @AllowNull varchar(50), @SQL nvarchar(512)
If Exists (Select * From sysobjects Where name = 'sysReportFilter' and xtype ='U') 
Begin
		Select @AllowNull = Case When col.isnullable  = 1 Then 'NULL' Else 'NOT NULL' End 
		From syscolumns col inner join sysobjects tab 
		On col.id = tab.id where tab.name = 'sysReportFilter'  and col.name = 'FilterCond'
		If @AllowNull Is Not Null
		Begin 
		   --change column type
		   Set @SQL = 'Alter Table sysReportFilter  Alter Column FilterCond nvarchar(512)'  + @AllowNull 
		   Execute(@SQL) 
		End
End 