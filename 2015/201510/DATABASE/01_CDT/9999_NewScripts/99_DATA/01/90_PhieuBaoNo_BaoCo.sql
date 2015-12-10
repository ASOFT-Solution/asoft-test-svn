USE [CDT]

declare @sysTableID int

-- 1) Phiếu báo có
select @sysTableID = sysTableID from sysTable
where TableName = 'DT15'

Update sysTable set Report = N'PBCO'
where sysTableID = @sysTableID and Report is null

-- 2) Thêm tham số chi nhánh ngân hàng
declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int
declare @DbName as varchar(50)
declare @sysSiteID as int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

declare curDbName CURSOR FOR
select DbName, sysSiteID from sysDatabase where DbName <> 'CDT' and sysSiteID <> 1

open curDbName 
fetch curDbName into @DbName, @sysSiteID

while @@FETCH_STATUS = 0
BEGIN

-- PRO
if isnull(@sysSiteIDPRO,'') <> '' AND @sysSiteID = @sysSiteIDPRO
BEGIN
	if not exists (select top 1 1 from sysConfig where _Key = N'ChiNhanhNH' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], [IsFormatString]) 
	VALUES (N'ChiNhanhNH', NULL, 1, @sysSiteIDPRO, 0, N'Tên chi nhánh ngân hàng', N'Bank Branch Name', @DbName, NULL)
END

-- STD
if isnull(@sysSiteIDSTD,'') <> '' AND @sysSiteID = @sysSiteIDSTD
BEGIN
	if not exists (select top 1 1 from sysConfig where _Key = N'ChiNhanhNH' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName], [IsFormatString]) 
	VALUES (N'ChiNhanhNH', NULL, 1, @sysSiteIDSTD, 0, N'Tên chi nhánh ngân hàng', N'Bank Branch Name', @DbName, NULL)
END

fetch curDbName into @DbName, @sysSiteID
END

close curDbName
deallocate curDbName

-- 3) Phiếu báo nợ
select @sysTableID = sysTableID from sysTable
where TableName = 'DT16'

Update sysTable set Report = N'PBNO'
where sysTableID = @sysTableID and Report is null