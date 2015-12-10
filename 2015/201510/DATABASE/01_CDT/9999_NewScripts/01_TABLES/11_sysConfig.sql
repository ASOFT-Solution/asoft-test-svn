USE [CDT]
GO

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysConfig'  and col.name = 'SortOrder')
BEGIN
	ALTER TABLE sysConfig ADD  [SortOrder] int NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysConfig'  and col.name = 'IsDaiLyThue')
BEGIN
	ALTER TABLE sysConfig ADD  [IsDaiLyThue] bit NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysConfig'  and col.name = 'IsNopThueInfor')
BEGIN
	ALTER TABLE sysConfig ADD  [IsNopThueInfor] bit NULL
END