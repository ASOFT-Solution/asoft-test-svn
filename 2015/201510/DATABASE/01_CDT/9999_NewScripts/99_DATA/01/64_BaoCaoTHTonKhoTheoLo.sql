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

select @mtTableID = sysTableID from sysTable
where TableName = 'BLVT' and sysPackageID = 8

if not exists (select top 1 1 from sysReport where ReportName = N'Báo cáo tổng hợp tồn kho (theo lô)' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Báo cáo tổng hợp tồn kho (theo lô)', 0, @mtTableID, NULL, N'declare @ngayct1 datetime, 
		@ngayct2 datetime,
		@loaivt int,
		@sql NVARCHAR (4000)
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)
set @loaiVt = @@Loaivt

if exists (select top 1 1 from sys.all_views where name = ''Sodu'') drop view Sodu 
if exists (select top 1 1 from sys.all_views where name = ''bnhap'') drop view bnhap 
if exists (select top 1 1 from sys.all_views where name = ''bxuat'') drop view bxuat 
if exists (select top 1 1 from sys.all_views where name = ''WG1'') drop view WG1 

--Lấy Chứng từ nhập từ BLVT
set @sql = N''Create view bnhap as
select t.SoCT, t.NgayCT, t.DienGiai, t.MaKH, t.Makho, t.MaVT, t.MaDVT, t.soluong as SL_Nhap, t.dongia as DG_Nhap, t.psno GT_Nhap, t.Lotnumber, t.Expiredate  
from Blvt t left join DMVT dm on t.Mavt = dm.Mavt
where t.soluong <> 0 and 
(dm.loaivt = '' + convert(nvarchar, @loaiVt) + '' or '' + convert(nvarchar, @loaiVt) + '' = 0) and '' +  ''@@ps'' + 
'' and dm.Tonkho = 5 ''

exec(@sql)

--Lấy Chứng từ xuất từ BLVT
set @sql = N''Create view bxuat as
select t.SoCT, t.NgayCT, t.DienGiai, t.MaKH, t.Makho, t.MaVT, t.MaDVT, t.soluong_X as SL_Xuat, t.dongia as DG_Xuat, t.psco as GT_Xuat, t.SoCTDT, t.Lotnumber, t.Expiredate 
from Blvt t left join DMVT dm on t.Mavt = dm.Mavt 
where t.soluong_X <> 0 and 
(dm.loaivt = '' + convert(nvarchar, @loaiVt) + '' or '' + convert(nvarchar, @loaiVt) + '' = 0) and '' +  ''@@ps'' + 
'' and dm.Tonkho = 5 
and t.SoCTDT is not null''

exec(@sql)

--Lấy So du vật tư từ bảng OBVT và BLVT loại VT đích danh
set @sql = N''Create view Sodu as
Select t.MaKho, t.MaVT, t.MaDVT, t.Soluong as SL_Dau, t.Dudau as GT_Dau,0  as SL_Nhap, 0 as GT_Nhap, 0 as SL_Xuat, 0 as GT_Xuat,t.Lotnumber, t.Expiredate  
From OBVT t left join DMVT dm on t.Mavt = dm.Mavt
where '' + ''@@ps'' + '' and (dm.loaivt ='' + convert(nvarchar, @loaiVt) + '' or '' + convert(nvarchar, @loaiVt) + '' = 0)
		   and dm.Tonkho = 5
		   and t.Dudau > 0
Union all
select t.MaKho, t.MaVT, t.MaDVT, sum(t.soluong) as SL_Dau, sum(t.ps) as GT_Dau,0  as SL_Nhap, 0 as GT_Nhap, 0 as SL_Xuat, 0 as GT_Xuat, t.Lotnumber, t.Expiredate   from (
select n.Makho, n.MaVT, n.MaDVT, n.SL_Nhap as soluong, n.GT_Nhap as ps, n.Lotnumber, n.Expiredate 
from bnhap n
where n.NgayCt < cast('''''' + convert(nvarchar, @ngayct1) + '''''' as datetime)
Union all
select x.Makho, x.MaVT, x.MaDVT, -x.SL_Xuat, -x.GT_Xuat , x.Lotnumber, x.Expiredate  
from bxuat x
where x.NgayCt < cast('''''' + convert(nvarchar, @ngayct1) + '''''' as datetime)
) t
Group by t.Lotnumber, t.Expiredate, t.MaKho, t.MaVT, t.MaDVT''

exec(@sql)

--Xuất từ số dư đầu kỳ và Xuất từ phiếu nhập
set @sql = N''Create View WG1 as
Select D.MaKho, D.MaVT, D.MaDVT, D.[SL_Dau], D.[GT_Dau],0 as [SL_Nhap],0 as [GT_Nhap], 
 0 as SL_Xuat, 0 as GT_Xuat, D.Lotnumber, D.Expiredate  
 from Sodu D
union all
Select N.MaKho, N.MaVT, N.MaDVT, 0 as [SL_Dau], 0 as [GT_Dau], N.[SL_Nhap], N.[GT_Nhap],0 [SL_Xuat],0 [GT_Xuat], N.Lotnumber, N.Expiredate 
from Bnhap N
where N.ngayCt between cast('''''' +  convert(nvarchar, @ngayct1) + '''''' as datetime) and  cast('''''' + convert(nvarchar, @ngayct2) + '''''' as datetime)
union all
Select X.MaKho, X.MaVT, X.MaDVT, 0 as [SL_Dau], 0 as [GT_Dau], 0 [SL_Nhap], 0 [GT_Nhap], X.[SL_Xuat], X.[GT_Xuat], X.Lotnumber, X.Expiredate 
from BXuat X
where X.ngayCt between cast('''''' +  convert(nvarchar, @ngayct1) + '''''' as datetime) and  cast('''''' + convert(nvarchar, @ngayct2) + '''''' as datetime)''

exec(@sql)

--Lấy kết quả
select w.*,
k.Tenkho, V.TenVT, v.LoaiVT,
case when @@lang = 1 then Nhom.TenNhom2 else Nhom.TenNhom end as N''Tên nhóm vật tư'',
case when @@lang = 1 then Q.TenDVT2 else Q.TenDVT end as TenDVT 
from 
(select w.MaKho, w.MaVT, w.MaDVT,
sum(w.SL_Dau) as N''Tồn đầu'', sum(w.GT_Dau) as N''Dư đầu'',sum(w.SL_Nhap) as N''Số lượng nhập'', sum(w.GT_Nhap) as N''Giá trị nhập'', sum(w.SL_Xuat) as N''Số lượng xuất'', sum(w.GT_Xuat) as N''Giá trị xuất'',
sum(SL_dau+SL_Nhap-SL_Xuat) as N''Tồn cuối'', sum(GT_Dau+GT_Nhap-GT_Xuat) as N''Dư cuối'', w.Lotnumber, w.Expiredate
 from WG1 w 
group by w.MaKho, w.MaVT, w.MaDVT, w.Lotnumber, w.Expiredate
) w left join DMVT v on w.MaVT=v.MaVT
    left join DMKho k on k.MaKho = w.Makho
    left join DMNhomVT Nhom on Nhom.MaNhomVT=v.nhom
    left join DMDVT Q on Q.MaDvt=w.MADVT
Order by w.MaVT

drop view Sodu
drop view bnhap
drop view bxuat
drop view WG1', 
N'THTK_LO', N'Aggregate inventory (By Lot)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, N't', null, NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Báo cáo tổng hợp tồn kho (theo lô)' and sysPackageID = 8

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
				where FieldName = 'Nhom'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DMVT')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 3, 1, 0, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaVT'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 4, 1, 1, 0, N'TonKho = 5')

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Báo cáo tổng hợp tồn kho (theo lô)', N'THTK_LO', N'Aggregate inventory (By Lot)', NULL)

-- Step 4: Tạo menu
-- PRO
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Quản lý kho' and sysSiteID = @sysSiteIDPRO and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDPRO and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo tổng hợp tồn kho (theo lô)' and [sysSiteID] = @sysSiteIDPRO and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo tổng hợp tồn kho (theo lô)', N'Aggregate inventory (By Lot)', @sysSiteIDPRO, NULL, NULL, @sysReportID, 14, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- STD
if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Quản lý kho' and sysSiteID = @sysSiteIDSTD and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDSTD and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN
if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo tổng hợp tồn kho (theo lô)' and [sysSiteID] = @sysSiteIDSTD and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo tổng hợp tồn kho (theo lô)', N'Aggregate inventory (By Lot)', @sysSiteIDSTD, NULL, NULL, @sysReportID, 14, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- Dictionary
if not exists (select 1 from Dictionary where Content = N'Số lô') INSERT INTO Dictionary (Content, Content2) VALUES (N'Số lô', N'Lot Number');
if not exists (select 1 from Dictionary where Content = N'Số lô:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Số lô:', N'Lot Number:');
if not exists (select 1 from Dictionary where Content = N'Hạn dùng') INSERT INTO Dictionary (Content, Content2) VALUES (N'Hạn dùng', N'Expiration Date');
if not exists (select 1 from Dictionary where Content = N'Hạn dùng:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Hạn dùng:', N'Expiration Date:');

select @sysTableID = sysTableID from sysTable where TableName = 'wReportRvCtrl'

set @lang_vn = N'Tồn đầu'
set @lang_en = N'Beginning quantity'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Dư đầu'
set @lang_en = N'Beginning amount'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Số lượng nhập'
set @lang_en = N'Storing quantity'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Giá trị nhập'
set @lang_en = N'Storing amount'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Số lượng xuất'
set @lang_en = N'Delivering quantity'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Giá trị xuất'
set @lang_en = N'Delivering amount'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Tồn cuối'
set @lang_en = N'Closing quantity'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Dư cuối'
set @lang_en = N'Closing amount'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Tên nhóm vật tư'
set @lang_en = N'Name of material group'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Ngày chứng từ'
set @lang_en = N'Voucher date'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Số phiếu xuất'
set @lang_en = N'Delivery receipt number'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Thành tiền nguyên tệ'
set @lang_en = N'Original amount'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Thành tiền'
set @lang_en = N'Total amount'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)