if exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DT31' and col.name = 'MaBp')
exec sp_RENAME 'DT31.MaBp', 'MaBP' , 'COLUMN'


