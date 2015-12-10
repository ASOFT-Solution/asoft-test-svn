USE [CDT]

declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int
declare @sysFieldID as int
declare @sysReportID as int
declare @sysMenuParent as int
declare @mtTableID as int
declare @dtTableID as int
declare @ThueKhacMenu as int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

select @mtTableID = sysTableID from sysTable where TableName = 'MVATTNDN' and sysPackageID = 8
select @dtTableID = sysTableID from sysTable where TableName = 'DVATTNDN' and sysPackageID = 8

-- Step 1: Thêm báo cáo
if not exists (select top 1 1 from sysReport where ReportName = N'Tờ khai Thuế TNDN tạm tính 1B')
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Tờ khai Thuế TNDN tạm tính 1B', 0, @mtTableID, @dtTableID, 
N'select dt.Stt1, dt.Stt2, dt.TenChiTieu, dt.MaCode, dt.TTien, mst.Quy, mst.Nam1, mst.InLanDau, mst.SoLanIn, mst.PhuThuoc, mst.DienGiai from MVATTNDN mst inner join DVATTNDN dt on mst.MVATTNDNID = dt.MVATTNDNID
where mst.MauBaoCao = N''1B/TNDN-TT28'' and @@ps order by dt.SortOrder', N'01B-TNDN', N'Provisional VAT return 1B - Income of business', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, N'mst', N'dt', NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Tờ khai Thuế TNDN tạm tính 1B' and sysPackageID = 8

-- Site PRO
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

-- Tao menu 'Báo cáo' trong tab 'Thuế Khác'
select @ThueKhacMenu = sysMenuID from sysMenu where  MenuName = N'Thuế khác' and sysSiteID = @sysSiteIDPRO

if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo' and sysMenuParent = @ThueKhacMenu and sysSiteID = @sysSiteIDPRO)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo', N'Reports', @sysSiteIDPRO, NULL, NULL, NULL, 8, NULL, @ThueKhacMenu, NULL, NULL, 5, NULL)


select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = @ThueKhacMenu

if isnull(@sysMenuParent,'') <> ''
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Tờ khai Thuế TNDN tạm tính 1B' and sysSiteID = @sysSiteIDPRO)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Tờ khai Thuế TNDN tạm tính 1B', N'Provisional VAT return 1B - Income of business', @sysSiteIDPRO, NULL, NULL, @sysReportID, 1, NULL, @sysMenuParent, NULL, NULL, 5, NULL)
END

END

-- Site STD
if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

-- Tao menu 'Báo cáo' trong tab 'Thuế Khác'
select @ThueKhacMenu = sysMenuID from sysMenu where MenuName = N'Thuế khác' and sysSiteID = @sysSiteIDSTD

if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo' and sysMenuParent = @ThueKhacMenu and sysSiteID = @sysSiteIDSTD)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo', N'Reports', @sysSiteIDSTD, NULL, NULL, NULL, 8, NULL, @ThueKhacMenu, NULL, NULL, 5, NULL)

select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = @ThueKhacMenu

if isnull(@sysMenuParent,'') <> ''
BEGIN					
if not exists (select top 1 1 from sysMenu where MenuName = N'Tờ khai Thuế TNDN tạm tính 1B' and sysSiteID = @sysSiteIDSTD)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Tờ khai Thuế TNDN tạm tính 1B', N'Provisional VAT return 1B - Income of business', @sysSiteIDSTD, NULL, NULL, @sysReportID, 1, NULL, @sysMenuParent, NULL, NULL, 5, NULL)
END

END

-- Step 2: Form tham số báo cáo
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'Nam1'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 0, 0, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'Quy'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 0, 1, 1, 1, 0, NULL)
				
-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Tờ khai Thuế TNDN tạm tính 1B', N'01B-TNDN', NULL, NULL)

-- Step 4: Update từ điển
--if not exists (select top 1 1 from Dictionary where Content = N'Mặt hàng')
--	insert into Dictionary(Content, Content2) Values (N'Mặt hàng',N'Goods')

