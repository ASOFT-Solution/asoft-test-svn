USE [CDT]
GO

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysReport'  and col.name = 'HasExportXML')
BEGIN
	ALTER TABLE sysReport ADD  [HasExportXML] bit NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysReport'  and col.name = 'QueryXML')
BEGIN
	ALTER TABLE sysReport ADD  [QueryXML] ntext NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysReport'  and col.name = 'XMLTemplate')
BEGIN
	ALTER TABLE sysReport ADD  [XMLTemplate] [nvarchar](128) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysReport'  and col.name = 'OutputXMLFileNamePattern')
BEGIN
	ALTER TABLE sysReport ADD  [OutputXMLFileNamePattern] [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysReport'  and col.name = 'AttachedReport')
BEGIN
	ALTER TABLE sysReport ADD  [AttachedReport] [nvarchar](512) NULL
END