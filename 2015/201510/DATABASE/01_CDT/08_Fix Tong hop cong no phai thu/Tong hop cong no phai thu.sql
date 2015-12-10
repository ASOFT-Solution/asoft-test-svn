use [CDT]

declare 
@sysSiteID1 int,
@sysSiteID2 int,
@sysPackageID int,
@sysFieldID int,
@sysReportID int,
@sysMenuParent1 int,
@sysMenuParent2 int,
@MenuOrder int,
@ReportName nvarchar (256),
@ReportName2 nvarchar (256),
@ReportFile nvarchar (256),
@sysTableId int,
@mtTableName nvarchar (256),
@resultTableId int,
@resultTableName nvarchar (256),
@Query nvarchar (max)

select @sysSiteID1 = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteID2 = sysSiteID from sysSite where SiteCode = N'STD'

select @sysPackageID = sysPackageID from sysPackage where Package = N'HTA'

select @sysMenuParent1 = c.sysMenuId from sysMenu c inner join sysMenu p on c.sysMenuParent = p.sysMenuId 
where p.Menuname = N'Công nợ phải thu' and c.MenuName = N'Báo cáo' and c.sysSiteID = @sysSiteID1

select @sysMenuParent2 = c.sysMenuId from sysMenu c inner join sysMenu p on c.sysMenuParent = p.sysMenuId 
where p.Menuname = N'Công nợ phải thu' and c.MenuName = N'Báo cáo' and c.sysSiteID = @sysSiteID2

select @mtTableName = 'bltk'
select @sysTableId = sysTableId from sysTable where TableName = @mtTableName
	
set @ReportName = N'Tổng hợp công nợ phải thu'
set @ReportName2 = N'Account receivable in general'
set @ReportFile = 'THCNPTHU'
set @resultTableName = 'wTHCNPTHU'
set @Query = N'
declare @sql nvarchar (4000) 
declare @ngayct1 datetime 
declare @ngayct2 datetime 

set @ngayct1 = @@ngayct1 
set @ngayct2 = @@ngayct2 

if exists (select distinct name from sys.all_views where name = ''sddk'') drop view sddk 
if exists (select distinct name from sys.all_views where name = ''pstk'') drop view pstk 
if exists (select distinct name from sys.all_views where name = ''sdck'') drop view sdck 
if exists (select distinct name from sys.all_views where name = ''wTHCNPTHU'') drop view wTHCNPTHU 

set @sql = '' 
create view sddk as 
select makh, tk, sum (psno) - sum (psco) as dk from bltk 
where ngayct < cast ('''''' + convert (nvarchar,@ngayct1) + '''''' as datetime) '' +'' 
group by tk, makh'' 
exec (@sql) 

set @sql = '' 
create view pstk as select makh, tk, sum (isnull (psno,0)) as psn, sum (isnull (psco,0)) as psc from bltk 
where ngayct between cast ('''''' + convert (nvarchar,@ngayct1) + '''''' as datetime) and cast ('''''' + convert (nvarchar,@ngayct2) + '''''' as datetime) '' +'' 
group by tk, makh'' 
exec (@sql) 

set @sql = '' 
create view sdck as select makh, tk, sum (psno) - sum (psco) as ck from bltk 
where ngayct <= cast ('''''' + convert (nvarchar,@ngayct2) + '''''' as datetime) '' +'' 
group by tk, makh'' 
exec (@sql) 

set @sql = '' 
create view wTHCNPTHU as 
select distinct 
bltk.makh as mkh, 
bltk.tenkh as tkh, 
bltk.tk, 
case when dk > 0 then dk else 0 end as dndk, 
case when dk < 0 then -dk else 0 end as dcdk, 
isnull (pstk.psn,0) as psn, 
isnull (pstk.psc,0) as psc, 
case when ck > 0 then ck else 0 end as dnck, 
case when ck < 0 then -ck else 0 end as dcck 
from bltk 
left join sddk on sddk.makh = bltk.makh and sddk.tk = bltk.tk 
left join pstk on pstk.makh = bltk.makh and pstk.tk = bltk.tk 
left join sdck on sdck.makh = bltk.makh and sdck.tk = bltk.tk 
where '' + @@ps 
exec (@sql) 

select * from wTHCNPTHU 

if exists (select distinct name from sys.all_views where name = ''sddk'') drop view sddk 
if exists (select distinct name from sys.all_views where name = ''pstk'') drop view pstk 
if exists (select distinct name from sys.all_views where name = ''sdck'') drop view sdck 
if exists (select distinct name from sys.all_views where name = ''wTHCNPTHU'') drop view wTHCNPTHU
' 
-- Thêm báo cáo
-- delete sysReport where ReportName = @ReportName

if not exists (select top 1 1 from sysReport where ReportName = @ReportName)
insert into sysReport (ReportName, RpType, mtTableID, Query, ReportFile, ReportName2, sysPackageID, mtAlias)
			   values (@ReportName, 0, @sysTableId, @Query, @ReportFile, @ReportName2, @sysPackageID, @mtTableName)
select @sysReportID = sysReportID from sysReport where ReportName = @ReportName

-- Thêm điều kiện lọc
-- delete sysReportFilter where sysReportID = @sysReportID

select @sysFieldID = sysFieldID from sysField where FieldName = 'NgayCT' and sysTableId = @sysTableId
if not exists (select top 1 1 from sysReportFilter where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
insert into sysReportFilter (sysFieldID, AllowNull, DefaultValue, sysReportID, IsBetween, TabIndex, Visible, IsMaster, SpecialCond, FilterCond)
					 values (@sysFieldID, 0, NULL, @sysReportID, 1, 0, 1, 1, 1, NULL)

select @sysFieldID = sysFieldID from sysField where FieldName = 'TK' and sysTableId = @sysTableId
if not exists (select top 1 1 from sysReportFilter where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
insert into sysReportFilter (sysFieldID, AllowNull, DefaultValue, sysReportID, IsBetween, TabIndex, Visible, IsMaster, SpecialCond, FilterCond)
					 values (@sysFieldID, 0, NULL, @sysReportID, 0, 0, 1, 1, 0, N'TkCongNo = 1 and Tk like ''1%''')

select @sysFieldID = sysFieldID from sysField where FieldName = 'MaKH' and sysTableId = @sysTableId
if not exists (select top 1 1 from sysReportFilter where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
insert into sysReportFilter (sysFieldID, AllowNull, DefaultValue, sysReportID, IsBetween, TabIndex, Visible, IsMaster, SpecialCond, FilterCond)
					 values (@sysFieldID, 1, NULL, @sysReportID, 1, 0, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from sysField where FieldName = 'TKDu' and sysTableId = @sysTableId
if not exists (select top 1 1 from sysReportFilter where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
insert into sysReportFilter (sysFieldID, AllowNull, DefaultValue, sysReportID, IsBetween, TabIndex, Visible, IsMaster, SpecialCond, FilterCond)
					 values (@sysFieldID, 1, NULL, @sysReportID, 0, 0, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from sysField where FieldName = 'MaPhi' and sysTableId = @sysTableId
if not exists (select top 1 1 from sysReportFilter where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
insert into sysReportFilter (sysFieldID, AllowNull, DefaultValue, sysReportID, IsBetween, TabIndex, Visible, IsMaster, SpecialCond, FilterCond)
					 values (@sysFieldID, 1, NULL, @sysReportID, 0, 0, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from sysField where FieldName = 'MaVV' and sysTableId = @sysTableId
if not exists (select top 1 1 from sysReportFilter where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
insert into sysReportFilter (sysFieldID, AllowNull, DefaultValue, sysReportID, IsBetween, TabIndex, Visible, IsMaster, SpecialCond, FilterCond)
					 values (@sysFieldID, 1, NULL, @sysReportID, 0, 0, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from sysField where FieldName = 'MaNT' and sysTableId = @sysTableId
if not exists (select top 1 1 from sysReportFilter where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
insert into sysReportFilter (sysFieldID, AllowNull, DefaultValue, sysReportID, IsBetween, TabIndex, Visible, IsMaster, SpecialCond, FilterCond)
					 values (@sysFieldID, 1, NULL, @sysReportID, 0, 0, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from sysField where FieldName = 'MaBP' and sysTableId = @sysTableId
if not exists (select top 1 1 from sysReportFilter where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
insert into sysReportFilter (sysFieldID, AllowNull, DefaultValue, sysReportID, IsBetween, TabIndex, Visible, IsMaster, SpecialCond, FilterCond)
					 values (@sysFieldID, 1, NULL, @sysReportID, 0, 0, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from sysField where FieldName = 'MaCongTrinh' and sysTableId = @sysTableId
if not exists (select top 1 1 from sysReportFilter where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
insert into sysReportFilter (sysFieldID, AllowNull, DefaultValue, sysReportID, IsBetween, TabIndex, Visible, IsMaster, SpecialCond, FilterCond)
					 values (@sysFieldID, 1, NULL, @sysReportID, 0, 0, 1, 1, 0, NULL)
					 
-- Thêm form report
-- delete sysFormReport where ReportName = @ReportName

if not exists (select top 1 1 from sysFormReport where ReportName = @ReportName)
insert into sysFormReport (sysReportID, ReportName, ReportFile, ReportName2)
				  values (@sysReportID, @ReportName, @ReportFile, @ReportName2)

-- Thêm menu
-- delete sysMenu where MenuName = @ReportName

if @sysSiteID1 <> '' AND @sysSiteID1 <> NULL
BEGIN
select @MenuOrder = max (MenuOrder) + 1 from sysMenu where sysMenuParent = @sysMenuParent1 and sysSiteID = @sysSiteID1
if not exists (select top 1 1 from sysMenu where MenuName = @ReportName and sysSiteID = @sysSiteID1)
insert into sysMenu (MenuName, MenuName2, sysSiteID, sysReportID, MenuOrder, sysMenuParent, UIType)
			 values (@ReportName, @ReportName2, @sysSiteID1, @sysReportID, @MenuOrder, @sysMenuParent1, 5)
END

if @sysSiteID2 <> '' AND @sysSiteID2 <> NULL
BEGIN	 
select @MenuOrder = max (MenuOrder) + 1 from sysMenu where sysMenuParent = @sysMenuParent2 and sysSiteID = @sysSiteID2
if not exists (select top 1 1 from sysMenu where MenuName = @ReportName and sysSiteID = @sysSiteID2)
insert into sysMenu (MenuName, MenuName2, sysSiteID, sysReportID, MenuOrder, sysMenuParent, UIType)
			 values (@ReportName, @ReportName2, @sysSiteID2, @sysReportID, @MenuOrder, @sysMenuParent2, 5)
END

-- Thêm thông tin view
-- delete sysTable where TableName = @resultTableName

if not exists (select top 1 1 from sysTable where TableName = @resultTableName)
insert into sysTable (TableName, DienGiai, DienGiai2, Pk, ParentPk, MasterTable, Type, SortOrder, DetailField, System, MaCT, sysPackageID, Report, CollectType)
select @resultTableName, @ReportName, @ReportName2, 'makh', NULL, NULL, 0, 'makh', NULL, 0, NULL, @sysPackageID, NULL, -1 
select @resultTableId = sysTableId from sysTable where TableName = @resultTableName

-- delete sysField where sysTableID = @resultTableId

if not exists (select top 1 1 from sysField where FieldName = N'mkh' and sysTableID = @resultTableId)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
	    values (@resultTableId, 1, NULL, NULL, NULL, NULL, 2, N'mkh', N'Mã khách hàng', N'Customer Code', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = N'tkh' and sysTableID = @resultTableId)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
	    values (@resultTableId, 1, NULL, NULL, NULL, NULL, 2, N'tkh', N'Tên khách hàng', N'Customer name', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = N'tk' and sysTableID = @resultTableId)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
	    values (@resultTableId, 1, NULL, NULL, NULL, NULL, 2, N'tk', N'Tài khoản', N'Account', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = N'dndk' and sysTableID = @resultTableId)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
	    values (@resultTableId, 1, NULL, NULL, NULL, NULL, 2, N'dndk', N'Dư nợ đầu kỳ', N'Beginning debit amount', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = N'dcdk' and sysTableID = @resultTableId)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
	    values (@resultTableId, 1, NULL, NULL, NULL, NULL, 2, N'dcdk', N'Dư có đầu kỳ', N'Beginning credit amount', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = N'psn' and sysTableID = @resultTableId)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
	    values (@resultTableId, 1, NULL, NULL, NULL, NULL, 2, N'psn', N'Phát sinh nợ', N'Arising debit', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = N'psc' and sysTableID = @resultTableId)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
	    values (@resultTableId, 1, NULL, NULL, NULL, NULL, 2, N'psc', N'Phát sinh có', N'Arising credit', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = N'dnck' and sysTableID = @resultTableId)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
	    values (@resultTableId, 1, NULL, NULL, NULL, NULL, 2, N'dnck', N'Dư nợ cuối kỳ', N'Closing debit amount', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = N'dcck' and sysTableID = @resultTableId)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
	    values (@resultTableId, 1, NULL, NULL, NULL, NULL, 2, N'dcck', N'Dư có cuối kỳ', N'Closing credit amount', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- Thêm từ điển
if not exists (select top 1 1 from Dictionary where Content = N'Mã khách hàng')
                 insert Dictionary (Content, Content2) values (N'Mã khách hàng', N'Customer Code')

if not exists (select top 1 1 from Dictionary where Content = N'Tên khách hàng')
                 insert Dictionary (Content, Content2) values (N'Tên khách hàng', N'Customer name')
