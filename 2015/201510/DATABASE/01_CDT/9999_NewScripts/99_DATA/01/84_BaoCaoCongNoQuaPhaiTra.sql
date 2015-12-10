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

-- Thêm giá trị filter Đến ngày
select @sysTableID = sysTableID from sysTable
where TableName = 'wFilterControl' and sysPackageID = 8

if not exists (select top 1 1 from [sysField] where [sysTableID] = @sysTableID and [FieldName] = N'ToDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ToDate', 0, NULL, NULL, NULL, NULL, 9, N'Đến ngày', N'To Date', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- Báo cáo công nợ quá hạn phải trả
select @mtTableID = sysTableID from sysTable
where TableName = 'BLTK' and sysPackageID = 8

if not exists (select top 1 1 from sysReport where ReportName = N'Báo cáo công nợ quá hạn phải trả' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Báo cáo công nợ quá hạn phải trả', 0, @mtTableID, NULL, N'', 
N'BCCNQHPTR', N'Overdue pay report', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, null, NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo công nợ quá hạn phải trả' and sysPackageID = 8

Update sysReport
set Query = N'DECLARE @ToDate DATETIME

set @ToDate = @@ToDate
select * from (
  SELECT     MT21.MT21ID as MTID, MaCT, NgayCT,SoCT,NgayHD,SoHoaDon,MaKH,TenKH,TKCo as TK, Diengiai, MaNT,Tygia, NgayBatdauTT, HanTT
     ,(HanTT-(CASE WHEN (NgayBatdauTT IS NULL) OR (NgayBatdauTT >= @ToDate) THEN 0 ELSE DATEDIFF(day,NgayBatdauTT,@ToDate) END)) as [Ngày quá hạn]
      ,TTienNT, TTien, ConLaiNT = TTienNT - DaTTNT, ConLai = Ttien - DaTT,  MaBP, MaVV, MaPhi, MaCongTrinh
     FROM  MT21 INNER JOIN DT21 ON MT21.MT21ID = DT21.MT21ID
     WHERE     TKCO IN (SELECT TK FROM  DMTK WHERE TKCONGNO = 1)
  UNION
  SELECT     MT22.MT22ID, MaCT, NgayCT,SoCT,NgayHD,SoHoaDon,MaKH,TenKH,TKCo, Diengiai, MaNT,Tygia, NgayBatdauTT, HanTT
     ,
     (HanTT-(CASE WHEN (NgayBatdauTT IS NULL) OR (NgayBatdauTT >= @ToDate) THEN 0 ELSE DATEDIFF(day,NgayBatdauTT,@ToDate) END)) 
     ,TTienNT, TTien, ConLaiNT = TTienNT - DaTTNT,ConLai = Ttien - DaTT,  MaBP, MaVV, MaPhi, MaCongTrinh
     FROM  MT22 INNER JOIN DT22 ON MT22.MT22ID = DT22.MT22ID
     WHERE     TKCO IN (SELECT TK FROM  DMTK WHERE TKCONGNO = 1)
  UNION
  SELECT     MT23.MT23ID, MaCT, NgayCT,SoCT,NgayHD,SoHoaDon,MaKH,TenKH,TKCo, Diengiai, MaNT,Tygia, NgayBatdauTT, HanTT
     ,
     (HanTT-(CASE WHEN (NgayBatdauTT IS NULL) OR (NgayBatdauTT >= @ToDate) THEN 0 ELSE DATEDIFF(day,NgayBatdauTT,@ToDate) END)) 
     ,TTienNT, TTien, ConLaiNT = TTienNT - DaTTNT,ConLai = Ttien - DaTT,  MaBP, MaVV, MaPhi, MaCongTrinh
     FROM  MT23 INNER JOIN DT23 ON MT23.MT23ID = DT23.MT23ID
     WHERE     TKCO IN (SELECT TK FROM  DMTK WHERE TKCONGNO = 1)
  UNION
  SELECT     MT24.MT24ID, MaCT, NgayCT,SoCT,NgayHD,SoHoaDon,MaKH,TenKH,TKNo, Diengiai, MaNT,Tygia, NgayBatdauTT, HanTT
     ,(HanTT-(CASE WHEN (NgayBatdauTT IS NULL) OR (NgayBatdauTT >= @ToDate) THEN 0 ELSE DATEDIFF(day,NgayBatdauTT,@ToDate) END)) 
     ,TTienNT, TTien, ConLaiNT = TTienNT - DaTTNT,ConLai = Ttien - DaTT,  MaBP, MaVV, MaPhi, MaCongTrinh
     FROM  MT24 INNER JOIN DT24 ON MT24.MT24ID = DT24.MT24ID
     WHERE     TKNo IN (SELECT TK FROM  DMTK WHERE TKCONGNO = 1)
  UNION
  SELECT     MT25.MT25ID, MaCT, NgayCT,SoCT,NgayHD,SoHoaDon,MaKH,TenKH,TKCo, Diengiai, MaNT,Tygia, NgayBatdauTT, HanTT
     ,(HanTT-(CASE WHEN (NgayBatdauTT IS NULL) OR (NgayBatdauTT >= @ToDate) THEN 0 ELSE DATEDIFF(day,NgayBatdauTT,@ToDate) END)) 
     ,TTienNT, TTien, ConLaiNT = TTienNT - DaTTNT,ConLai = Ttien - DaTT,  MaBP, MaVV, MaPhi, MaCongTrinh
     FROM  MT25 INNER JOIN DT25 ON MT25.MT25ID = DT25.MT25ID
     WHERE     TKCO IN (SELECT TK FROM  DMTK WHERE TKCONGNO = 1)
) x     
WHERE (x.Conlai <> 0 or x.ConlaiNT <> 0) AND (x.[Ngày quá hạn] is not Null) And @@ps
ORDER BY x.NgayCT, x.TenKH, x.SoCT'
where sysReportID = @sysReportID


-- Step 2: Tham số báo cáo
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'ToDate'
				and sysTableID = (select sysTableID from sysTable where TableName = N'wFilterControl')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 0, 0, 1, 0, 1, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TK'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 1, 1, 0, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaKH'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 2, 1, 0, 0, NULL)

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
VALUES (@sysReportID, N'Báo cáo công nợ quá hạn phải trả', N'BCCNQHPTR', N'Overdue pay report', NULL)

-- Step 4: Tạo menu
-- PRO
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Công nợ phải trả' and sysSiteID = @sysSiteIDPRO and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDPRO and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN

if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo công nợ quá hạn phải trả' and [sysSiteID] = @sysSiteIDPRO and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo công nợ quá hạn phải trả', N'Overdue pay report', @sysSiteIDPRO, NULL, NULL, @sysReportID, 6, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- STD
if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Công nợ phải trả' and sysSiteID = @sysSiteIDSTD and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDSTD and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo công nợ quá hạn phải trả' and [sysSiteID] = @sysSiteIDSTD and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo công nợ quá hạn phải trả', N'Overdue pay report', @sysSiteIDSTD, NULL, NULL, @sysReportID, 6, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- Dictionary
select @sysTableID = sysTableID from sysTable where TableName = 'wReportRvCtrl'

set @lang_vn = N'Ngày quá hạn'
set @lang_en = N'Days past due'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)