USE [CDT]

DECLARE @sysTableID INT

select @sysTableID = sysTableID from sysTable
					where tableName = 'DT32'
					
Update sysTable set  Report = 'HDBHDATIN,HDBHTUIN,HDBLE,INPXK-GB,INPXK-GV,BKHH-DVTHEOHD,HDBH-BBBG'
where sysTableID = @sysTableID
and sysPackageID = 8
and Report = 'HDBHDATIN,HDBHTUIN,HDBLE,INPXK-GB,INPXK-GV,BKHH-DVTHEOHD'

-- Them field BaoHanh
select @sysTableID = sysTableID from sysTable
					where tableName = 'DMVT'
					
if not exists (select top 1 1 from sysField where FieldName = N'BaoHanh' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'BaoHanh', N'Bảo hành', N'Warranty', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- Them field ChucVu
select @sysTableID = sysTableID from sysTable
					where tableName = 'DMKH'
					
if not exists (select top 1 1 from sysField where FieldName = N'ChucVu' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'ChucVu', N'Chức vụ', N'Position', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- Them field TenKH
select @sysTableID = sysTableID from sysTable
					where tableName = 'DMVuViec'
					
if not exists (select top 1 1 from sysField where FieldName = N'TenKH' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'TenKH', N'Tên khách hàng', N'Customer Name', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = N'NgayBDVV' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 9, N'NgayBDVV', N'Ngày bắt đầu', N'Start date', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = N'NgayKTVV' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 9, N'NgayKTVV', N'Ngày kết thúc', N'End date', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = N'GiaTriVV' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 8, N'GiaTriVV', N'Giá trị hợp đồng', N'Contract value', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)
