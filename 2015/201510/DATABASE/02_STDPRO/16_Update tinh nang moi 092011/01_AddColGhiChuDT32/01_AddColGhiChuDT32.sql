if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DT32' and col.name = 'GhiChu')
	alter table DT32 add GhiChu nvarchar(128) NULL

