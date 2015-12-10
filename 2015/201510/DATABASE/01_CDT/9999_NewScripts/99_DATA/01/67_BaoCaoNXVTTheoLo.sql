USE [CDT]

declare @sysTableID int,
		@sysSiteIDPRO int,
		@sysSiteIDSTD int,
		@sysMenuParent int, 
		@sysOtherReport int,
		@mtTableID int,
		@sysReportID int,
		@sysFieldID int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

select @mtTableID = sysTableID from sysTable
where TableName = 'BLVT' and sysPackageID = 8

if not exists (select top 1 1 from sysReport where ReportName = N'Báo cáo xuất nhập vật tư (theo lô)' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Báo cáo xuất nhập vật tư (theo lô)', 0, @mtTableID, NULL, N'declare @ngayct1 datetime, 
		@ngayct2 datetime,
		@loaivt int
		
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)
set @loaiVt = @@Loaivt

Select b.MaCT, b.SoCT, b.NgayCT, b.MaKH,b.TenKH,b.Makho,k.Tenkho,b.mavt, v.tenVt, b.MaDvt,
case when @@lang = 1 then t.TenDvt2 else t.TenDvt end TenDvt,
b.SoCTDT, b.LotnumBer, b.Expiredate,
v.LoaiVT, b.Dongia, b.Soluong as [Số lượng nhập], b.PsNo as [Giá trị nhập],  0 as [Số lượng xuất], 0 as [Giá trị xuất] 
from BLVT b left join DMkho k on k.makho = b.makho
            left join DMVT v on v.mavt=b.mavt
            left join DMDVT t on t.MaDvt=b.MaDvt
Where	Soluong<>0 and 
		b.NgayCT between @ngayct1 and @ngayct2 and 
		(v.loaivt = @loaiVt or @loaiVt = 0) and 
		v.Tonkho = 5 and @@ps
union all
Select b.MaCT, b.SoCT, b.NgayCT, b.MaKH,b.TenKH,b.Makho,k.Tenkho,b.mavt, v.tenVt, b.MaDvt,
case when @@lang = 1 then t.TenDvt2 else t.TenDvt end TenDvt,
b.SoCTDT, b.LotnumBer, b.Expiredate,
v.LoaiVT, b.Dongia,0 as [Số lượng nhập], 0 as [Giá trị nhập],  b.Soluong_X as [Số lượng xuất], b.PsCo as [Giá trị xuất]
from BLVT b left join DMkho k on k.makho = b.makho
            left join DMVT v on v.mavt=b.mavt
            left join DMDVT t on t.MaDvt=b.MaDvt
Where	Soluong_X<>0 and
		b.NgayCT between @ngayct1 and @ngayct2 and 
		(v.loaivt = @loaiVt or @loaiVt = 0) and 
		v.Tonkho = 5 and @@ps', 
N'NXVTTHEOLO', N'Import and export material (By Lot)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, N'b', null, NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo xuất nhập vật tư (theo lô)' and sysPackageID = 8

-- Step 2: Tham số báo cáo
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'NgayCT'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 1, 0, 1, 1, 1, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaKho'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 1, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'Loaivt'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DMVT')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, 0, @sysReportID, 0, 2, 1, 0, 1, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaVT'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 3, 1, 1, 0, N'TonKho = 5')

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaKH'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 4, 1, 1, 0, NULL)

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Báo cáo xuất nhập vật tư (theo lô)', N'NXVTTHEOLO', N'Import and export material (By Lot)', NULL)

-- Step 4: Tạo menu
-- PRO
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Quản lý kho' and sysSiteID = @sysSiteIDPRO and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDPRO and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo xuất nhập vật tư (theo lô)' and [sysSiteID] = @sysSiteIDPRO and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo xuất nhập vật tư (theo lô)', N'Import and export material (By Lot)', @sysSiteIDPRO, NULL, NULL, @sysReportID, 15, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- STD
if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Quản lý kho' and sysSiteID = @sysSiteIDSTD and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDSTD and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo xuất nhập vật tư (theo lô)' and [sysSiteID] = @sysSiteIDSTD and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo xuất nhập vật tư (theo lô)', N'Import and export material (By Lot)', @sysSiteIDSTD, NULL, NULL, @sysReportID, 15, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END