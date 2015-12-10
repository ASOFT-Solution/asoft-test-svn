USE [CDT]

declare @sysTableID int,
		@sysSiteIDPRO int,
		@sysSiteIDSTD int,
		@sysMenuParent int, 
		@sysOtherReport int,
		@mtTableID int,
		@sysReportID int,
		@sysFieldID int,
		@lang_vn nvarchar(255),
		@lang_en nvarchar(255)

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

-- Thêm giá trị filter chứng từ kết chuyển trong DMKetChuyen
select @sysTableID = sysTableID from sysTable
where TableName = 'wFilterControl' and sysPackageID = 8

if not exists (select top 1 1 from [sysField] where [sysTableID] = @sysTableID and [FieldName] = N'MaCT' and [RefTable] = N'DMKetChuyen')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaCT', 1, N'MaCT', N'DMKetChuyen', NULL, NULL, 1, N'Mã chứng từ', N'Voucher type', 8, NULL, NULL, NULL, NULL, NULL, N'Chứng từ kết chuyển', N'Transfers voucher', 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

select @mtTableID = sysTableID from sysTable
where TableName = 'BLTK' and sysPackageID = 8

if not exists (select top 1 1 from sysReport where ReportName = N'Báo cáo nghiệp vụ kết chuyển' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Báo cáo nghiệp vụ kết chuyển', 0, @mtTableID, NULL, N'', 
N'BCKC', N'Transfer Report', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, N't', null, NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo nghiệp vụ kết chuyển' and sysPackageID = 8

Update sysReport
set Query = N'Select t.MaCT, t.NgayCT, t.SoCT, t.Diengiai, t.TK, t.TKDu, t.PsNo, t.MaNT, t.TyGia, t.PsNoNT, t.MaVV, t.MaPhi,t.MaBP
From BLTK t left join DMKetChuyen dmkc on t.MaCT = dmkc.MaCT
Where t.Psno>0 and t.MaCT like N''KC%'' and @@ps
order by t.NgayCT, dmkc.Stt'
where sysReportID = @sysReportID


-- Step 2: Tham số báo cáo
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'NgayCT'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 1, 0, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaCT' and [RefTable] = N'DMKetChuyen'
				and sysTableID = (select sysTableID from sysTable where TableName = N'wFilterControl')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 1, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TK'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 2, 1, 1, 0, N'TK like N''154%'' or TK like N''413%'' or TK like N''421%'' or TK not in (Select TK from DMTK Where TK like N''0%'' or TK like N''1%'' or TK like N''2%'' or TK like N''3%'' or TK like N''4%'')')

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TKDu'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 3, 1, 1, 0, N'TK like N''154%'' or TK like N''413%'' or TK like N''421%'' or TK not in (Select TK from DMTK Where TK like N''0%'' or TK like N''1%'' or TK like N''2%'' or TK like N''3%'' or TK like N''4%'')')

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaVV'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 4, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaPhi'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 5, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaBP'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 6, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaCongTrinh'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 7, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaNT'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 8, 1, 1, 0, NULL)

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Báo cáo nghiệp vụ kết chuyển', N'BCKC', N'Transfer Report', NULL)

-- Step 4: Tạo menu
-- PRO
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Tổng hợp' and sysSiteID = @sysSiteIDPRO and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Sổ kế toán' and sysSiteID = @sysSiteIDPRO and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN

if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo nghiệp vụ kết chuyển' and [sysSiteID] = @sysSiteIDPRO and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo nghiệp vụ kết chuyển', N'Transfer Report', @sysSiteIDPRO, NULL, NULL, @sysReportID, 7, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- STD
if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Tổng hợp' and sysSiteID = @sysSiteIDSTD and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Sổ kế toán' and sysSiteID = @sysSiteIDSTD and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo nghiệp vụ kết chuyển' and [sysSiteID] = @sysSiteIDSTD and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo nghiệp vụ kết chuyển', N'Transfer Report', @sysSiteIDSTD, NULL, NULL, @sysReportID, 7, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- Dictionary
--select @sysTableID = sysTableID from sysTable where TableName = 'wReportRvCtrl'

--set @lang_vn = N'Tồn đầu'
--set @lang_en = N'Beginning quantity'
--if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
--INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
--VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)