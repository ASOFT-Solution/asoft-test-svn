USE [CDT]

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'sysConfig'  and col.name = 'IsFormatString')
BEGIN
	ALTER TABLE sysConfig ADD  IsFormatString [bit] NULL
END

GO

declare @DbName varchar(50)
declare @sysSiteID int

declare cur_db cursor for
select DbName, sysSiteID from sysDatabase where DbName <> 'CDT' and sysSiteID <> 1

open cur_db

fetch next from cur_db into @DbName, @sysSiteID

WHILE @@FETCH_STATUS = 0
BEGIN

if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteID and _Key = 'DonGia')
Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
Values ('DonGia','0',1,@sysSiteID,0,N'Đơn giá', N'Unit price',@DbName,1)

if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteID and _Key = 'DonGiaNT')
Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
Values ('DonGiaNT','0',1,@sysSiteID,0,N'Đơn giá nguyên tệ', N'Original unit price',@DbName,1)

if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteID and _Key = 'HeSo')
Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
Values ('HeSo','0',1,@sysSiteID,0,N'Hệ số', N'Coefficient',@DbName,1)

if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteID and _Key = 'SoLuong')
Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
Values ('SoLuong','0',1,@sysSiteID,0,N'Số lượng', N'Quantity',@DbName,1)

if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteID and _Key = 'ThueSuat')
Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
Values ('ThueSuat','0',1,@sysSiteID,0,N'Thuế suất', N'Tax rate',@DbName,1)

if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteID and _Key = 'Tien')
Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
Values ('Tien','0',1,@sysSiteID,0,N'Tiền', N'Amount',@DbName,1)

if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteID and _Key = 'TienNT')
Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
Values ('TienNT','0',1,@sysSiteID,0,N'Tiền nguyên tệ', N'Original amount',@DbName,1)

if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteID and _Key = 'TyGia')
Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
Values ('TyGia','0',1,@sysSiteID,0,N'Tỷ giá', N'Rate of exchange',@DbName,1)

if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteID and _Key = 'DisplayZero')
Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
Values ('DisplayZero','true',1,@sysSiteID,0,N'Cho phép hiển thị số 0 khi giá trị nhập liệu hoặc trên báo cáo bằng 0', N'Allow display zero value',@DbName,1)

fetch next from cur_db into @DbName, @sysSiteID
END

close cur_db
deallocate cur_db

