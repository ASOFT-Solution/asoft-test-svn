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

select @sysMtTableID = sysTableID from sysTable where tableName = 'MT22'
select @sysDtTableID = sysTableID from sysTable where tableName = 'DT22'

-- Step 1: Thêm báo cáo
if not exists (select top 1 1 from sysReport where ReportName = N'Sổ chi tiết mua hàng theo nhà cung cấp và mặt hàng')
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Sổ chi tiết mua hàng theo nhà cung cấp và mặt hàng', 0, @sysMtTableID, @sysDtTableID, 
N'Select v.makh, v.tenkh, v.NgayCT, v.SoCT, v.MaCT, v.mavt, v.diengiai,
v.gia, v.soluong, v.ps, v.tienck, v.[Giảm giá], v.[Số lượng trả lại], v.[Giá trị trả lại],
v.IsNCC, v.IsKH, v.IsNV, v.MaNT, V.TenVT
from
(Select  mt22.makh, k.tenkh, NgayCT, SoCT, MACT , dt22.mavt, DienGiai,gia ,soluong , ps , tienck , 
0 as [Giảm giá], 0 as [Số lượng trả lại], 0 as [Giá trị trả lại], k.IsNCC, k.IsKH, k.IsNV, mt22.MaNT, vt.TenVT
from MT22,DT22 , dmkh k, dmvt vt
where  MT22.mt22id = DT22.mt22id and MT22.makh *= k.makh and dt22.MaVT *= vt.MaVT
union all
select mt23.makh, k.tenkh, NgayCT, SoCT, MACT , dt23.mavt, DienGiai,gia,soluong, ps , tienck,
0 as [Giảm giá], 0 as [Số lượng trả lại], 0 as [Giá trị trả lại], k.IsNCC, k.IsKH, k.IsNV, mt23.MaNT, vt.TenVT
from MT23 , DT23 , dmkh k, dmvt vt
where  MT23.mt23id = DT23.mt23id and MT23.makh *= k.makh and dt23.MaVT *= vt.MaVT
union all
select mt24.makh, k.tenkh, NgayCT, SoCT, MACT , dt24.mavt, DienGiai,0 ,0 , 0, 0 ,
0 as [Giảm giá], soluong as [Số lượng trả lại], ps as [Giá trị trả lại], k.IsNCC, k.IsKH, k.IsNV, mt24.MaNT, vt.TenVT
from MT24 , DT24 , dmkh k, dmvt vt
where  MT24.mt24id = DT24.mt24id and MT24.makh *= k.makh and dt24.MaVT *= vt.MaVT
) v
where @@ps', 
N'SCTMH_NCCMH', N'The detail report about purchase by supplier and item', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Sổ chi tiết mua hàng theo nhà cung cấp và mặt hàng' and sysPackageID = 8

if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

-- Site PRO
select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = 
							(select sysMenuID from sysMenu 
							where  MenuName = N'Mua hàng' and sysSiteID = @sysSiteIDPRO)

if isnull(@sysMenuParent,'') <> ''
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Sổ chi tiết mua hàng theo nhà cung cấp và mặt hàng' and sysSiteID = @sysSiteIDPRO)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Sổ chi tiết mua hàng theo nhà cung cấp và mặt hàng', N'The detail report about purchase by supplier and item', @sysSiteIDPRO, NULL, NULL, @sysReportID, 11, NULL, @sysMenuParent, NULL, NULL, 5, NULL)
END

END

if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

-- Site STD
select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = 
							(select sysMenuID from sysMenu 
							where  MenuName = N'Mua hàng' and sysSiteID = @sysSiteIDSTD)

if isnull(@sysMenuParent,'') <> ''
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Sổ chi tiết mua hàng theo nhà cung cấp và mặt hàng' and sysSiteID = @sysSiteIDSTD)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Sổ chi tiết mua hàng theo nhà cung cấp và mặt hàng', N'The detail report about purchase by supplier and item', @sysSiteIDSTD, NULL, NULL, @sysReportID, 11, NULL, @sysMenuParent, NULL, NULL, 5, NULL)
END

END

-- Step 2: Form báo cáo
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'NgayCT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MT22')

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
				and sysTableID = (select sysTableID from sysTable where TableName = 'MT22')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 4, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaVT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DT22')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 5, 1, 0, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaNT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MT22')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 6, 1, 1, 0, NULL)

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Sổ chi tiết mua hàng theo nhà cung cấp và mặt hàng', N'SCTMH_NCCMH', N'The detail report about purchase by supplier and item', NULL)

-- Step 4: Update từ điển
--if not exists (select top 1 1 from Dictionary where Content = N'Mặt hàng')
--	insert into Dictionary(Content, Content2) Values (N'Mặt hàng',N'Goods')

