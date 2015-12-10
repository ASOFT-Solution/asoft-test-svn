-- Tạo các báo cáo tài chính mới theo TT200, các báo cáo cũ vẫn giữ cho KH cũ
USE [CDT]

declare @sysSiteIDPRO int,
		@sysSiteIDSTD int,
		@sysReportID_Old int,
		@sysReportID_TT200 int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

----------------------------- 1) Bảng cấn đối kế toán - TT200 -----------------------------
-- Step 1: Thêm report mới (Copy từ báo cáo Bảng cân đối kế toán cũ)
if not exists (select top 1 1 from sysReport where ReportName = N'Bảng cân đối kế toán - TT200' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
select N'Bảng cân đối kế toán - TT200', [RpType], [mtTableID], [dtTableID], [Query], [ReportFile] + '_TT200', [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]
from sysReport where ReportName = N'Bảng cân đối kế toán'

select @sysReportID_TT200 = sysReportID from sysReport where ReportName = N'Bảng cân đối kế toán - TT200' and sysPackageID = 8
select @sysReportID_Old = sysReportID from sysReport where ReportName = N'Bảng cân đối kế toán' and sysPackageID = 8

-- Step 2: Tham số báo cáo (Copy từ báo cáo Bảng cân đối kế toán cũ)
if not exists (select 1 from [sysReportFilter] where sysReportID = @sysReportID_TT200)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
select [sysFieldID], [AllowNull], [DefaultValue], @sysReportID_TT200, [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond] 
from sysReportFilter where sysReportID = @sysReportID_Old

-- Step 3: Biểu mẫu báo cáo (Copy từ báo cáo Bảng cân đối kế toán cũ)
if not exists (select 1 from sysFormReport where sysReportID = @sysReportID_TT200)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
select @sysReportID_TT200, [ReportName], [ReportFile] + '_TT200', [ReportName2], [ReportFile2] from sysFormReport where sysReportID = @sysReportID_Old

-- Step 4: Tạo menu
if not exists (select 1 from sysMenu where MenuName = N'Bảng cân đối kế toán - TT200')
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image], [VisibleCondition]) 
select N'Bảng cân đối kế toán - TT200', [MenuName2], [sysSiteID], [CustomType], [sysTableID], @sysReportID_TT200, [MenuOrder]+3, [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image] ,N'@QuyetDinh==48'
from sysMenu where MenuName = N'Bảng cân đối kế toán'

----------------------------- 2) Báo cáo kết quả kinh doanh - TT200 -----------------------------
-- Step 1: Thêm report mới (Copy từ Báo cáo cũ)
if not exists (select top 1 1 from sysReport where ReportName = N'Báo cáo kết quả kinh doanh - TT200' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
select N'Báo cáo kết quả kinh doanh - TT200', [RpType], [mtTableID], [dtTableID], [Query], [ReportFile] + '_TT200', [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]
from sysReport where ReportName = N'Báo cáo kết quả kinh doanh'

select @sysReportID_TT200 = sysReportID from sysReport where ReportName = N'Báo cáo kết quả kinh doanh - TT200' and sysPackageID = 8
select @sysReportID_Old = sysReportID from sysReport where ReportName = N'Báo cáo kết quả kinh doanh' and sysPackageID = 8

-- Step 2: Tham số báo cáo (Copy từ báo cáo cũ)
if not exists (select 1 from [sysReportFilter] where sysReportID = @sysReportID_TT200)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
select [sysFieldID], [AllowNull], [DefaultValue], @sysReportID_TT200, [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond] 
from sysReportFilter where sysReportID = @sysReportID_Old

-- Step 3: Biểu mẫu báo cáo (Copy từ báo cáo cũ)
if not exists (select 1 from sysFormReport where sysReportID = @sysReportID_TT200)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
select @sysReportID_TT200, [ReportName], [ReportFile] + '_TT200', [ReportName2], [ReportFile2] from sysFormReport where sysReportID = @sysReportID_Old

-- Step 4: Tạo menu
if not exists (select 1 from sysMenu where MenuName = N'Báo cáo kết quả kinh doanh - TT200')
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image], [VisibleCondition]) 
select N'Báo cáo kết quả kinh doanh - TT200', [MenuName2], [sysSiteID], [CustomType], [sysTableID], @sysReportID_TT200, [MenuOrder] + 1, [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image], N'@QuyetDinh==48' 
from sysMenu where MenuName = N'Báo cáo kết quả kinh doanh'

----------------------------- 3) Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp - TT200 -----------------------------
-- Step 1: Thêm report mới (Copy từ Báo cáo cũ)
if not exists (select top 1 1 from sysReport where ReportName = N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp - TT200' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
select N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp - TT200', [RpType], [mtTableID], [dtTableID], [Query], [ReportFile] + '_TT200', [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]
from sysReport where ReportName = N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp'

select @sysReportID_TT200 = sysReportID from sysReport where ReportName = N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp - TT200' and sysPackageID = 8
select @sysReportID_Old = sysReportID from sysReport where ReportName = N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp' and sysPackageID = 8

-- Step 2: Tham số báo cáo (Copy từ báo cáo cũ)
if not exists (select 1 from [sysReportFilter] where sysReportID = @sysReportID_TT200)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
select [sysFieldID], [AllowNull], [DefaultValue], @sysReportID_TT200, [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond] 
from sysReportFilter where sysReportID = @sysReportID_Old

-- Step 3: Biểu mẫu báo cáo (Copy từ báo cáo cũ)
if not exists (select 1 from sysFormReport where sysReportID = @sysReportID_TT200)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
select @sysReportID_TT200, [ReportName], [ReportFile] + '_TT200', [ReportName2], [ReportFile2] from sysFormReport where sysReportID = @sysReportID_Old

-- Step 4: Tạo menu
if not exists (select 1 from sysMenu where MenuName = N'Báo cáo LCTT - PP trực tiếp - TT200')
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image], [VisibleCondition]) 
select N'Báo cáo LCTT - PP trực tiếp - TT200', [MenuName2], [sysSiteID], [CustomType], [sysTableID], @sysReportID_TT200, [MenuOrder] + 1, [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image] , N'@QuyetDinh==48'
from sysMenu where MenuName = N'Báo cáo LCTT - PP trực tiếp'