use [CDT]

-- Thêm column QuyetDinh
if not exists (select top 1 1 from syscolumns col join sysobjects tbl on tbl.id = col.id and tbl.name = 'sysDatabase' and col.name = 'QuyetDinh')
	alter table sysDatabase add QuyetDinh varchar(50) NULL
	
GO

declare @value nvarchar(128)
declare @QuyetDinh nvarchar(128)
declare @DbName varchar(50)
declare @sysSiteID int

declare cur_Config cursor for
select _Value, DbName, sysSiteID from sysConfig
where _Key = 'SoQD'

open cur_Config 
fetch next from cur_Config into @value, @DbName, @sysSiteID

while @@fetch_status = 0
BEGIN
	
	if isnull(@value,'') = N'15/2006/QĐ-BTC'
		set @QuyetDinh = '15'
	else if isnull(@value,'') = N'48/2006/QĐ-BTC'
		set @QuyetDinh = '48'
	
	Update sysDatabase set QuyetDinh = @QuyetDinh
	where DbName = @DbName and sysSiteID = @sysSiteID and QuyetDinh is null
	
	fetch next from cur_Config into @value, @DbName, @sysSiteID
END

close cur_Config
deallocate cur_Config