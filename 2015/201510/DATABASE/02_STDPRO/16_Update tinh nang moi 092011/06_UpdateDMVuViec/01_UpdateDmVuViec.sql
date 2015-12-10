if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMVuViec' and col.name = 'OngBa')
	alter table DMVuViec add OngBa nvarchar(128) NULL
	
if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMVuViec' and col.name = 'NgayKyVV')
	alter table DMVuViec add NgayKyVV smalldatetime NULL
	
if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMVuViec' and col.name = 'NgayHLVV')
	alter table DMVuViec add NgayHLVV smalldatetime NULL

if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMVuViec' and col.name = 'NoiDungVV')
	alter table DMVuViec add NoiDungVV nvarchar(128) NULL