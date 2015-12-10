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
	if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteIDPRO and _Key = 'DigitGroupSymbol')
	Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
	Values ('DigitGroupSymbol', N',',1,@sysSiteIDPRO,0,N'Ký tự phân cách hàng nghìn', N'Digit Group Symbol',@DbName,1)
	
	if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteIDPRO and _Key = 'DecimalSymbol')
	Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
	Values ('DecimalSymbol', N'.',1,@sysSiteIDPRO,0,N'Ký tự số thập phân', N'Decimal Symbol',@DbName,1)
END

-- STD
if isnull(@sysSiteIDSTD,'') <> '' AND @sysSiteID = @sysSiteIDSTD
BEGIN
	if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteIDSTD and _Key = 'DigitGroupSymbol')
	Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
	Values ('DigitGroupSymbol', N',',1,@sysSiteIDSTD,0,N'Ký tự phân cách hàng nghìn', N'Digit Group Symbol',@DbName,1)
	
	if not exists (select top 1 1 from sysConfig where DbName = @DbName and sysSiteID = @sysSiteIDSTD and _Key = 'DecimalSymbol')
	Insert into sysConfig([_Key],[_Value],[IsUser],[sysSiteID],[StartConfig],[DienGiai],[DienGiai2],[DbName],IsFormatString)
	Values ('DecimalSymbol', N'.',1,@sysSiteIDSTD,0,N'Ký tự số thập phân', N'Decimal Symbol',@DbName,1)
END

fetch curDbName into @DbName, @sysSiteID
END

close curDbName
deallocate curDbName