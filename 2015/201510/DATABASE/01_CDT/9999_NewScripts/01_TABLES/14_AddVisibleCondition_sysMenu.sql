USE [CDT]

If not exists (select * from syscolumns col inner join sysobjects tab On col.id = tab.id where tab.name = 'sysMenu' and col.name = 'VisibleCondition')
BEGIN
	Alter Table sysMenu Add VisibleCondition nvarchar(250) Null
END