USE [CDT]

DECLARE 
@sysSiteID INT,
@sysPackageID INT,
@sysTableId INT,
@sysTableMVatID INT,
@query nvarchar(max),
@sysReportID INT,
@sysMenuParent INT,
@sysMenuParentReport INT,
@sysFieldID INT

SELECT @sysPackageID = 8

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- Sửa tooltip cho field [Loại vật tư]
--
--------------------------------------------------------------------------------------------------------------------------------------------
SELECT @sysTableId = [sysTableID] FROM [sysTable] WHERE [TableName] = 'DMVT'
UPDATE [sysField] SET 
[Tip] = N'1:Hàng hóa; 2: Nguyên liệu; 3: Công cụ dụng cụ; 4:thành phẩm; 5: TSCĐ; 6: Dịch vụ; 7: Xe ô tô; 8: Xe hai bánh gắn máy',
[TipE] = N'1: Goods; 2:Material; 3: Tools; 4: Product; 5: Fixed Asset; 6: Services; 7: Cars; 8: Motobike',
[MaxValue] = 8
WHERE [sysTableID] = @sysTableId AND [FieldName] = N'LoaiVt'

SELECT @sysTableId = [sysTableID] FROM [sysTable] WHERE [TableName] = 'MVATin'

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- Báo cáo
--
--------------------------------------------------------------------------------------------------------------------------------------------
--delete [sysReport] WHERE [sysPackageID] = @sysPackageID AND [ReportName] = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra'

SET @query = N'
declare @sql nvarchar(max)  
declare @thang int 
declare @nam int 
declare @a decimal(20,6)
declare @a1 decimal(20,6)
declare @a2 decimal(20,6)
declare @a3 decimal(20,6)
declare @b1 decimal(20,6)
declare @b2 decimal(20,6)
declare @b3 decimal(20,6)
declare @b4 decimal(20,6)
declare @b5 decimal(20,6)

set @thang = @@KyBKMV
set @nam = @@NamBKMV

if exists (select top 1 1 from sys.all_views where name = ''wTempVATIn'') drop view wTempVATIn 
if exists (select top 1 1 from sys.all_views where name = ''wTempVATOut'') drop view wTempVATOut
if exists (select top 1 1 from sys.all_views where name = ''wTempCommon'') drop view wTempCommon
if exists (select top 1 1 from sys.all_views where name = ''wTempVT7'') drop view wTempVT7 
if exists (select top 1 1 from sys.all_views where name = ''wTempVT8'') drop view wTempVT8 

set @sql = ''
create view wTempVATIn as 
select Thue, MaLoaiThue
from MVATIn inner join DVATIn on MVATIn.MVATInID = DVATIn.MVATInID and MVATIn.KyBKMV = '' + str(@thang)
exec (@sql) 
 
set @sql = ''
create view wTempVATOut as 
select TTien, MaThue
from MVATOut inner join DVATOut on MVATOut.MVATOutID = DVATOut.MVATOutID and MVATOut.KyBKBR = '' + str(@thang)
exec (@sql) 

select @a1 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 1
select @a2 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 2
select @a3 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 3
set @a = @a1 + @a2 + @a3
select @b1 = isnull(sum(isnull(TTien, 0)), 0) from wTempVATOut where MaThue in (''KT'', ''00'', ''05'', ''10'')
select @b2 = isnull(sum(isnull(TTien, 0)), 0) from wTempVATOut where MaThue in (''00'', ''05'', ''10'')
if(@b1 <> 0) set @b3 = (@b2 * 100) / @b1  else set @b3 = 0
select @b4 = @a3
select @b5 = (@b4 * @b3) / 100

set @sql = N''create view wTempCommon as select 
N'''''' + convert(nvarchar(256), @thang) + N'''''' as  [Kỳ kế toán],
N'''''' + convert(nvarchar(256), @nam) + N'''''' as  [Năm kế toán]''
exec (@sql) 

set @sql = N''create view wTempVT7 as
select 
1 as [STT],
N''''Xe ôtô'''' as [Tên loại vật tư],
DMVT.TenVT as [Tên vật tư], 
DMDVT.TenDVT as [Tên ĐVT], 
sum(DT32.SoLuong) as [Số lượng],
sum(DT32.Ps) as [Tổng tiền], 
MT32.DienGiai as [Diễn giải]
from MT32 
inner join DT32 on MT32.MT32ID = DT32.MT32ID 
left join DMVT on DMVT.MaVT = DT32.MaVT
left join DMDVT on DMDVT.MaDVT = DT32.MaDVT
where month(MT32.NgayCt) = '' + convert(nvarchar(10), @thang) + '' and year(MT32.NgayCt) = '' + convert(nvarchar(10), @nam) + ''
and DMVT.LoaiVt = 7 
group by DMVT.TenVT, DMDVT.TenDVT, DMVT.LoaiVt, MT32.DienGiai
''
exec (@sql) 

set @sql = N''create view wTempVT8 as
select 
2 as [STT],
N''''Xe hai bánh gắn máy'''' as [Tên loại vật tư],
DMVT.TenVT as [Tên vật tư], 
DMDVT.TenDVT as [Tên ĐVT], 
sum(DT32.SoLuong) as [Số lượng],
sum(DT32.Ps) as [Tổng tiền], 
MT32.DienGiai as [Diễn giải]
from MT32 
inner join DT32 on MT32.MT32ID = DT32.MT32ID 
left join DMVT on DMVT.MaVT = DT32.MaVT
left join DMDVT on DMDVT.MaDVT = DT32.MaDVT
where month(MT32.NgayCt) = '' + convert(nvarchar(10), @thang) + '' and year(MT32.NgayCt) = '' + convert(nvarchar(10), @nam) + ''
and DMVT.LoaiVt = 8 
group by DMVT.TenVT, DMDVT.TenDVT, DMVT.LoaiVt, MT32.DienGiai
''
exec (@sql) 

select * from wTempCommon, wTempVT7 
union all
select * from wTempCommon, wTempVT8

if exists (select distinct name from sys.all_views where name = ''wTempVATIn'') drop view wTempVATIn 
if exists (select top 1 1 from sys.all_views where name = ''wTempVATOut'') drop view wTempVATOut 
if exists (select top 1 1 from sys.all_views where name = ''wTempCommon'') drop view wTempCommon 
if exists (select top 1 1 from sys.all_views where name = ''wTempVT7'') drop view wTempVT7 
if exists (select top 1 1 from sys.all_views where name = ''wTempVT8'') drop view wTempVT8 
'

SELECT @sysTableId = [sysTableID] FROM [sysTable] WHERE [TableName] = 'MT32'

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysReport] WHERE [sysPackageID] = @sysPackageID AND [ReportName] = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra')
INSERT [dbo].[sysReport]([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData])
VALUES(N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra', 0, @sysTableId, NULL, @query, N'01-3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @sysPackageID, NULL, NULL, NULL)

--select * from [sysReport] WHERE [sysPackageID] = @sysPackageID AND [ReportName] = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra'

SELECT @sysReportID = [sysReportID] FROM [sysReport] WHERE [sysPackageID] = @sysPackageID AND [ReportName] = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra'

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- Điều kiện lọc báo cáo
--
--------------------------------------------------------------------------------------------------------------------------------------------

--delete [sysReportFilter] WHERE [sysReportID] = @sysReportID

select @sysTableMVatID = sysTableID from sysTable where TableName = 'MVATIn' and sysPackageID = 8

SELECT @sysFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableId] = @sysTableMVatID AND [FieldName] = N'KyBKMV'
IF NOT EXISTS (SELECT TOP 1 1 FROM [sysReportFilter] WHERE [sysReportID] = @sysReportID AND [sysFieldID] = @sysFieldID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond])
VALUES (@sysFieldID, 0, NULL, @sysReportID, 0, 0, 1, 1, 1, NULL)	

SELECT @sysFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableId] = @sysTableMVatID AND [FieldName] = N'NamBKMV'
IF NOT EXISTS (SELECT TOP 1 1 FROM [sysReportFilter] WHERE [sysReportID] = @sysReportID AND [sysFieldID] = @sysFieldID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond])
VALUES (@sysFieldID, 0, NULL, @sysReportID, 0, 0, 1, 1, 1, NULL)	

--select * from [sysReportFilter] WHERE [sysReportID]

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- Menu
--
--------------------------------------------------------------------------------------------------------------------------------------------
-- PRO
SELECT @sysSiteID = [sysSiteID], @sysPackageID = [sysPackageID] FROM [sysSite] WHERE [SiteCode] = N'PRO'
SELECT @sysMenuParent = [sysMenuID] FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND MenuName = N'Thuế GTGT'
SELECT @sysMenuParentReport = [sysMenuID] FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParent AND MenuName = N'Báo cáo'

--delete [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra'

if isnull(@sysSiteID, '') <> ''
BEGIN

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra')
INSERT [dbo].[sysMenu]([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image])
VALUES(N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra', NULL, @sysSiteID, NULL, NULL, @sysReportID, 9, NULL, @sysMenuParentReport, NULL, NULL, 5, NULL)

END

--select * from [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra'

-- STD
SELECT @sysSiteID = [sysSiteID], @sysPackageID = [sysPackageID] FROM [sysSite] WHERE [SiteCode] = N'STD'
SELECT @sysMenuParent = [sysMenuID] FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND MenuName = N'Thuế GTGT'
SELECT @sysMenuParentReport = [sysMenuID] FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParent AND MenuName = N'Báo cáo'

--delete [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra'

if isnull(@sysSiteID, '') <> ''
BEGIN

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra')
INSERT [dbo].[sysMenu]([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image])
VALUES(N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra', NULL, @sysSiteID, NULL, NULL, @sysReportID, 9, NULL, @sysMenuParentReport, NULL, NULL, 5, NULL)

END

--select * from [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra'
