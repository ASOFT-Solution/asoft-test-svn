USE [CDT]
GO

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysUserMenu'  and col.name = 'Report')
BEGIN
	ALTER TABLE sysUserMenu ADD  [Report] NVARCHAR(512) NULL
END