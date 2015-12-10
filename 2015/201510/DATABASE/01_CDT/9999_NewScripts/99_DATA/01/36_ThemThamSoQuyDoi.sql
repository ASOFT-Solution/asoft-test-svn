use [CDT]
declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int
declare @DbName as varchar(50)
declare @sysSiteID as int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

declare curDbName CURSOR FOR
select DbName, sysSiteID from sysDatabase where DbName <> 'CDT'

open curDbName 
fetch curDbName into @DbName, @sysSiteID

while @@FETCH_STATUS = 0
BEGIN

-- PRO
if isnull(@sysSiteIDPRO,'') <> '' AND @sysSiteID = @sysSiteIDPRO
BEGIN
	if not exists (select top 1 1 from sysConfig where _Key = N'DonViTinhQD' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'DonViTinhQD', N'0', 1, @sysSiteIDPRO, 0, N'Sử dụng đơn vị tính quy đổi', N'Use converted unit', @DbName)
	
	if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteIDPRO and _Key = 'SoLuongQD')
	Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
	Values ('SoLuongQD','0',1,@sysSiteIDPRO,0,N'Số lượng quy đổi', N'Converted Amount',@DbName,1)
	
	if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteIDPRO and _Key = 'DonGiaQD')
	Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
	Values ('DonGiaQD','0',1,@sysSiteIDPRO,0,N'Đơn giá quy đổi', N'Converted unit price',@DbName,1)
	
	if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteIDPRO and _Key = 'DonGiaQDNT')
	Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
	Values ('DonGiaQDNT','0',1,@sysSiteIDPRO,0,N'Đơn giá quy đổi nguyên tệ', N'Original converted unit price',@DbName,1)
END

-- STD
if isnull(@sysSiteIDSTD,'') <> '' AND @sysSiteID = @sysSiteIDSTD
BEGIN
	if not exists (select top 1 1 from sysConfig where _Key = N'DonViTinhQD' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'DonViTinhQD', N'0', 1, @sysSiteIDSTD, 0, N'Sử dụng đơn vị tính quy đổi', N'Use converted unit', @DbName)
	
	if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteIDSTD and _Key = 'SoLuongQD')
	Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
	Values ('SoLuongQD','0',1,@sysSiteIDSTD,0,N'Số lượng quy đổi', N'Converted Amount',@DbName,1)
	
	if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteIDSTD and _Key = 'DonGiaQD')
	Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
	Values ('DonGiaQD','0',1,@sysSiteIDSTD,0,N'Đơn giá quy đổi', N'Converted unit price',@DbName,1)
	
	if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteIDSTD and _Key = 'DonGiaQDNT')
	Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
	Values ('DonGiaQDNT','0',1,@sysSiteIDSTD,0,N'Đơn giá quy đổi nguyên tệ', N'Original converted unit price',@DbName,1)
END

fetch curDbName into @DbName, @sysSiteID
END

close curDbName
deallocate curDbName

-- Thêm dữ liệu FormatString
if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuongQD' and Fieldname='SoluongQD') 
 insert into sysFormatString(_Key, Fieldname) Values ('SoLuongQD','SoluongQD')
 
if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQD' and Fieldname='GiaQD') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQD','GiaQD')
 
if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQDNT' and Fieldname='GiaQDNT') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQDNT','GiaQDNT')
 
if not exists (select top 1 1 from sysFormatString where _Key = 'HeSo' and Fieldname='TyLeQD') 
 insert into sysFormatString(_Key, Fieldname) Values ('HeSo','TyLeQD')

if not exists (select top 1 1 from sysFormatString where _Key = 'HeSo' and Fieldname='TyLeQD1') 
 insert into sysFormatString(_Key, Fieldname) Values ('HeSo','TyLeQD1')

if not exists (select top 1 1 from sysFormatString where _Key = 'HeSo' and Fieldname='Tyle1QD') 
 insert into sysFormatString(_Key, Fieldname) Values ('HeSo','Tyle1QD') 

if not exists (select top 1 1 from sysFormatString where _Key = 'HeSo' and Fieldname='Tyle2QD') 
 insert into sysFormatString(_Key, Fieldname) Values ('HeSo','Tyle2QD') 

if not exists (select top 1 1 from sysFormatString where _Key = 'HeSo' and Fieldname='TyLeQD2') 
 insert into sysFormatString(_Key, Fieldname) Values ('HeSo','TyLeQD2')
  
if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuongQD' and Fieldname='SoluongQD1') 
 insert into sysFormatString(_Key, Fieldname) Values ('SoLuongQD','SoluongQD1')
 
if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuongQD' and Fieldname='Soluong1QD') 
 insert into sysFormatString(_Key, Fieldname) Values ('SoLuongQD','Soluong1QD')

if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuongQD' and Fieldname='Soluong2QD') 
 insert into sysFormatString(_Key, Fieldname) Values ('SoLuongQD','Soluong2QD') 

if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQD' and Fieldname='GiaQD1') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQD','GiaQD1')

if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQD' and Fieldname='Gia1QD') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQD','Gia1QD') 

if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQD' and Fieldname='Gia2QD') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQD','Gia2QD') 

if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQDNT' and Fieldname='GiaQD1NT') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQDNT','GiaQD1NT')

if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQDNT' and Fieldname='Gia1QDNT') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQDNT','Gia1QDNT')

if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQDNT' and Fieldname='Gia2QDNT') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQDNT','Gia2QDNT')

if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuongQD' and Fieldname='SoluongQD2') 
 insert into sysFormatString(_Key, Fieldname) Values ('SoLuongQD','SoluongQD2')
 
if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQD' and Fieldname='GiaQD2') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQD','GiaQD2')
 
if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQDNT' and Fieldname='GiaQD2NT') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQDNT','GiaQD2NT')
 
if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQD' and Fieldname='DongiaQD') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQD','DongiaQD')
 
if not exists (select top 1 1 from sysFormatString where _Key = 'DonGiaQDNT' and Fieldname='DongiaQDNT') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGiaQDNT','DongiaQDNT')