use [CDT]
declare @sysFieldID as int
declare @sysReportID as int
declare @sysMenuParent as int
declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int
declare @sysMtTableID as int
declare @sysDtTableID as int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = 'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = 'STD'

select @sysMtTableID = sysTableID from sysTable where tableName = 'MT32'
select @sysDtTableID = sysTableID from sysTable where tableName = 'DT32'

-- Step 1: Thêm báo cáo
if not exists (select top 1 1 from sysReport where ReportName = N'Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng')
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng', 0, @sysMtTableID, @sysDtTableID, 
N'declare @loaiVt int
set @loaiVt = @@Loaivt
select x.ngayct, x.makh as MaKH, x.tenkh as TenKH, x.mavt as MaVT, x.tenvt as TenVT, x.soluong as SoLuong, x.ps as DoanhThu, 
  sltl as [Số lượng trả lại], x.ck as ChiecKhau, x.ps - x.ck as [Doanh thu thuần], 
   x.tienvon, x.ps - x.ck - x.tienvon as [Lãi gộp], x.loaivt, x.IsNCC, x.IsKH, x.IsNV, x.MaNT, x.TenDVT
from ( 
 select dt32id, ngayct,  mt32.makh, mt32.tenkh, kh.IsNCC, kh.IsKH, kh.IsNV, v.mavt, tenvt, soluong, ps, ck,  tienvon,  0 ''sltl'', v.loaivt, mt32.MaNT, dvt.TenDVT
   from mt32, dt32, dmvt v , dmkh kh, DMDVT dvt
   where mt32.mt32id = dt32.mt32id and dt32.mavt *= v.mavt and mt32.makh *= kh.makh and v.MaDVT = dvt.MaDVT
 union all 
 select dt33id, ngayct, mt33.makh, mt33.tenkh, kh.IsNCC, kh.IsKH, kh.IsNV, v.mavt, tenvt, -soluong, -ps, 0.0,  -tienvon,  soluong ''sltl'', v.loaivt , mt33.MaNT, dvt.TenDVT
   from mt33, dt33, dmvt v , dmkh kh, DMDVT dvt
   where mt33.mt33id = dt33.mt33id and dt33.mavt *= v.mavt and mt33.makh *= kh.makh and v.MaDVT = dvt.MaDVT) x
where (x.loaivt = @loaiVt or @loaiVt = 0) and @@ps', 
N'BCTHBHKHMH', N'The general report about sales by customer and item', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng' and sysPackageID = 8

if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

-- Site PRO
select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = 
							(select sysMenuID from sysMenu 
							where  MenuName = N'Bán hàng' and sysSiteID = @sysSiteIDPRO)

if isnull(@sysMenuParent,'') <> ''
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng' and sysSiteID = @sysSiteIDPRO)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng', N'The general report about sales by customer and item', @sysSiteIDPRO, NULL, NULL, @sysReportID, 10, NULL, @sysMenuParent, NULL, NULL, 5, NULL)
END

END

if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

-- Site STD
select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = 
							(select sysMenuID from sysMenu 
							where  MenuName = N'Bán hàng' and sysSiteID = @sysSiteIDSTD)

if isnull(@sysMenuParent,'') <> ''
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng' and sysSiteID = @sysSiteIDSTD)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng', N'The general report about sales by customer and item', @sysSiteIDSTD, NULL, NULL, @sysReportID, 10, NULL, @sysMenuParent, NULL, NULL, 5, NULL)
END

END

-- Step 2: Form báo cáo
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'NgayCT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MT32')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 1, 0, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'IsNCC'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DMKH')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 1, 1, 0, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'IsKH'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DMKH')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 2, 1, 0, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'IsNV'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DMKH')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 3, 1, 0, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaKH'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MT32')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 4, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'Loaivt'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DMVT')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, 0, @sysReportID, 0, 5, 1, 0, 1, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaVT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DT32')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 6, 1, 0, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaNT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MT32')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 7, 1, 1, 0, NULL)

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng', N'BCTHBHKHMH', N'The general report about sales by customer and item', NULL)

-- Step 4: Update từ điển
--if not exists (select top 1 1 from Dictionary where Content = N'Mặt hàng')
--	insert into Dictionary(Content, Content2) Values (N'Mặt hàng',N'Goods')

