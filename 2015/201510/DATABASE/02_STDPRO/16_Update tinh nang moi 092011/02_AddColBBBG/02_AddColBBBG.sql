if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMVT' and col.name = 'BaoHanh')
	alter table DMVT add BaoHanh nvarchar(128) NULL

if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMKH' and col.name = 'ChucVu')
	alter table DMKH add ChucVu nvarchar(128) NULL

if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMVuViec' and col.name = 'TenKH')
	alter table DMVuViec add TenKH nvarchar(128) NULL
	
if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMVuViec' and col.name = 'NgayBDVV')
	alter table DMVuViec add NgayBDVV smalldatetime NULL
	
if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMVuViec' and col.name = 'NgayKTVV')
	alter table DMVuViec add NgayKTVV smalldatetime NULL

if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'DMVuViec' and col.name = 'GiaTriVV')
	alter table DMVuViec add GiaTriVV decimal(20,6) NULL