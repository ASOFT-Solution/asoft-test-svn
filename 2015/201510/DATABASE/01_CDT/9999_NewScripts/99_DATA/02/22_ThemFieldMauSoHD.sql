USE [CDT]

declare @sysTableID int,
		@TabIndex int,
		@RefName nvarchar(50)

-- 1) VATIn
select @sysTableID = sysTableID from sysTable
where TableName = 'VATIn'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 2
set @RefName = N'fk_VATIn_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 3
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 2) VATOut
select @sysTableID = sysTableID from sysTable
where TableName = 'VATOut'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 2
set @RefName = N'fk_VATOut_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 3
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 3) MT22
select @sysTableID = sysTableID from sysTable
where TableName = 'MT22'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 9
set @RefName = N'fk_MT22_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 10
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 4) MT23
select @sysTableID = sysTableID from sysTable
where TableName = 'MT23'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 9
set @RefName = N'fk_MT23_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 10
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 5) MT21
select @sysTableID = sysTableID from sysTable
where TableName = 'MT21'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 9
set @RefName = N'fk_MT21_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 10
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 6) MT25
select @sysTableID = sysTableID from sysTable
where TableName = 'MT25'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 9
set @RefName = N'fk_MT25_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 10
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 7) MT24
select @sysTableID = sysTableID from sysTable
where TableName = 'MT24'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 9
set @RefName = N'fk_MT24_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 10
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 8) MT32
select @sysTableID = sysTableID from sysTable
where TableName = 'MT32'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 9
set @RefName = N'fk_MT32_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 10
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 9) MT33
select @sysTableID = sysTableID from sysTable
where TableName = 'MT33'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 9
set @RefName = N'fk_MT33_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 10
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 10) MT31
select @sysTableID = sysTableID from sysTable
where TableName = 'MT31'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 9
set @RefName = N'fk_MT31_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 10
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 11) DVATIn
select @sysTableID = sysTableID from sysTable
where TableName = 'DVATIn'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 7
set @RefName = N'fk_DVATIn_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 8
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

-- 12) DVATOut
select @sysTableID = sysTableID from sysTable
where TableName = 'DVATOut'

if not exists (select top 1 1 from sysField where FieldName = N'FormID' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 7
set @RefName = N'fk_DVATOut_DMMauSoHD'

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'FormID', N'DMMauSoHD', NULL, NULL, 1, N'FormID', N'Mẫu số hóa đơn', N'Form of invoices', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'FormSymbol' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 8
--set @RefName = N''

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'FormSymbol', N'Ký hiệu mẫu số', N'Form Symbol', @TabIndex, NULL, N'FormID.FormSymbol', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END