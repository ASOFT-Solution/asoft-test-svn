USE [CDT]

-- Thêm field số CT gốc kèm theo trong phiếu thu/chi

declare @sysTableID int
		
-- 1) Phiếu thu
select @sysTableID = sysTableID from sysTable
where TableName = 'MT11'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 2) Phiếu chi
select @sysTableID = sysTableID from sysTable
where TableName = 'MT12'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 3) Hóa đơn bán hàng
select @sysTableID = sysTableID from sysTable
where TableName = 'MT32'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 34

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 4) Hóa đơn dịch vụ
select @sysTableID = sysTableID from sysTable
where TableName = 'MT31'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 15

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 5) Phiếu xuất hàng trả nhà cung cấp
select @sysTableID = sysTableID from sysTable
where TableName = 'MT24'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 19

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 6) Phiếu mua hàng
select @sysTableID = sysTableID from sysTable
where TableName = 'MT22'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 19

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 7) Phiếu Nhập khẩu
select @sysTableID = sysTableID from sysTable
where TableName = 'MT23'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 19

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 8) Phiếu nhập hàng bán trả lại
select @sysTableID = sysTableID from sysTable
where TableName = 'MT33'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 19

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 9) Phiếu mua dịch vụ
select @sysTableID = sysTableID from sysTable
where TableName = 'MT21'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 19

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 10) Phiếu chi phí mua hàng
select @sysTableID = sysTableID from sysTable
where TableName = 'MT25'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 19

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 11) Phiếu xuất công cụ, dụng cụ
select @sysTableID = sysTableID from sysTable
where TableName = 'MT45'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 14

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 12) Phiếu nhập thành phẩm
select @sysTableID = sysTableID from sysTable
where TableName = 'MT41'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 13

Update sysField set TabIndex = 14
where sysTableID = @sysTableID and FieldName = 'TtienNT'

Update sysField set TabIndex = 15
where sysTableID = @sysTableID and FieldName = 'Ttien'

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 13) Phiếu nhập kho khác
select @sysTableID = sysTableID from sysTable
where TableName = 'MT42'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 15

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 14) Thu hồi công nợ theo hóa đơn
select @sysTableID = sysTableID from sysTable
where TableName = 'MT34'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 16

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 15) Thanh toán công nợ theo hóa đơn
select @sysTableID = sysTableID from sysTable
where TableName = 'MT26'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 16

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 16) Phiếu thu 2 tỷ giá
select @sysTableID = sysTableID from sysTable
where TableName = 'MT13'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 18

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 17) Phiếu chi  2 tỷ giá
select @sysTableID = sysTableID from sysTable
where TableName = 'MT14'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTG' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= 18

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTG', N'Số chứng từ gốc kèm theo', N'Original refno following', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END