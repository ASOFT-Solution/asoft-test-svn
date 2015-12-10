USE [CDT]
GO


If Exists (Select * From sysobjects Where name = 'DevLocalizer' and xtype ='U')
Begin
	If not exists (select * from syscolumns col inner join sysobjects tab On col.id = tab.id where tab.name = 'DevLocalizer' and col.name = 'StringName')
	BEGIN
		Alter Table DevLocalizer Add StringName nvarchar(256) Not Null Default('')
		delete from DevLocalizer
	END
End
GO
