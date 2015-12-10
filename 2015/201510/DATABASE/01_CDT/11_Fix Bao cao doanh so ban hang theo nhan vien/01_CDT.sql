use [CDT]

-- Them field Saleman
if not exists (select top 1 1 from sysField where sysTableID = 2031 and FieldName = N'Saleman')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (2031, N'Saleman', 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Người bán hàng', N'Sale man', 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_MT32_DMKH31', NULL, NULL, 0, NULL)
END

if not exists (select top 1 1 from sysField where sysTableID = 2030 and FieldName = N'Saleman')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (2030, N'Saleman', 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Người bán hàng', N'Sale man', 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_MT31_DMKH31', NULL, NULL, 0, NULL)
END

if not exists (select top 1 1 from sysField where sysTableID = 2035 and FieldName = N'Saleman')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (2035, N'Saleman', 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Người bán hàng', N'Sale man', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_MT43_DMKH14', NULL, NULL, 0, NULL)
END

if not exists (select top 1 1 from sysField where sysTableID = 2032 and FieldName = N'Saleman')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (2032, N'Saleman', 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Người bán hàng', N'Sale man', 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_MT33_DMKH31', NULL, NULL, 0, NULL)
END

declare @sysFieldID as int
declare @sysReportID as int
declare @sysMenuParent as int

-- Step 1: Thêm báo cáo
if not exists (select top 1 1 from sysReport where ReportName = N'Báo cáo doanh số bán hàng theo nhân viên')
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) VALUES (N'Báo cáo doanh số bán hàng theo nhân viên', 0, 2031, 2052, N'select x. ngayct, x.sohoadon, x.makh, x.tenkh, x.mavt, x.tenvt, x.soluong, x.gia, x.ps, x.ck, x.ps - x.ck as [Doanh số], vo.thue, x.saleman, (select tenkh from dmkh where x.saleman = dmkh.makh ) as sales
from
	(select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, saleman
	from mt32, dt32, dmvt v
	where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
union all
	select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, saleman
	from mt33, dt33, dmvt v
	where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt
union all
	select dt43id, ngayct, soct, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, 0.0, saleman
	from mt43, dt43, dmvt v
	where mt43.mt43id = dt43.mt43id and dt43.mavt = v.mavt and (left(tkno,3) = ''131'' or left(tkno,3) = ''111'' )
union all
select dt31id, ngayct, sohoadon, makhct, tenkhct,'''', diengiaict, 0.0, 0.0, ps, tck*ps/ttienh, saleman
from mt31, dt31
where mt31.mt31id = dt31.mt31id) x, vatout vo, dmkh b
where dt32id *= vo.mtiddt and x.saleman *= b.makh and @@ps
order by x.ngayct, x.sohoadon, x.mavt', N'BCDSBHNV', N'Sales reported by staff', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, N'x', N'x', NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo doanh số bán hàng theo nhân viên' and sysPackageID = 8

-- Site PRO
select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = 
							(select sysMenuID from sysMenu 
							where  MenuName = N'Bán hàng' and sysSiteID = 10)

if @sysMenuParent <> '' AND @sysMenuParent <> NULL
BEGIN	
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo doanh số bán hàng theo nhân viên' and sysSiteID = 10)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) VALUES (N'Báo cáo doanh số bán hàng theo nhân viên', N'Sales reported by staff', 10, NULL, NULL, @sysReportID, 9, NULL, @sysMenuParent, NULL, NULL, 5, NULL)
END

-- Site STD
select @sysMenuParent = sysMenuID from sysMenu 
where MenuName = N'Báo cáo' and sysMenuParent = 
							(select sysMenuID from sysMenu 
							where  MenuName = N'Bán hàng' and sysSiteID = 13)

if @sysMenuParent <> '' AND @sysMenuParent <> NULL
BEGIN					
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo doanh số bán hàng theo nhân viên' and sysSiteID = 13)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) VALUES (N'Báo cáo doanh số bán hàng theo nhân viên', N'Sales reported by staff', 13, NULL, NULL, @sysReportID, 9, NULL, @sysMenuParent, NULL, NULL, 5, NULL)
END

-- Step 2: Form báo cáo
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'NgayCT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MT32')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 0, 1, 1, 0, NULL)


select @sysFieldID = sysFieldID from SysField
				where FieldName = 'Saleman'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MT32')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 1, 1, 1, 0, NULL)
				
-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Báo cáo doanh số bán hàng theo nhân viên', N'BCDSBHNV', NULL, NULL)