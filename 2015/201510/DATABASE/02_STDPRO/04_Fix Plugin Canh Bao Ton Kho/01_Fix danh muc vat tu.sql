if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMVT' and col.name = 'IsTon')
	alter table DMVT  add IsTon bit NULL

