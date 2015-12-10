USE [CDT]

declare @sysTableID int,
		@TabIndex int,
		@RefName nvarchar(50)

-- 1) OBKH
select @sysTableID = sysTableID from sysTable
where TableName = 'OBKH'

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 3

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

set @RefName = N'fk_obkh_dmkh2'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 2) BLTK
select @sysTableID = sysTableID from sysTable
where TableName = 'BLTK'

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 26

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

set @RefName = N'fk_bltk_dmkh2'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 3) MT11
select @sysTableID = sysTableID from sysTable
where TableName = 'MT11'

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 6

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

set @RefName = N'fk_mt11_dmkh2'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 4) MT12
select @sysTableID = sysTableID from sysTable
where TableName = 'MT12'

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 6

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

set @RefName = N'fk_mt12_dmkh2'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 5) MT13
select @sysTableID = sysTableID from sysTable
where TableName = 'MT13'

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 6

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

set @RefName = N'fk_mt13_dmkh2'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 6) MT14
select @sysTableID = sysTableID from sysTable
where TableName = 'MT14'

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 6

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

set @RefName = N'fk_mt14_dmkh2'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 7) MT15
select @sysTableID = sysTableID from sysTable
where TableName = 'MT15'

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 5

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

set @RefName = N'fk_mt15_dmkh2'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 8) MT16
select @sysTableID = sysTableID from sysTable
where TableName = 'MT16'
set @RefName = N'fk_mt16_dmkh2'

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 5

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 9) MT17
select @sysTableID = sysTableID from sysTable
where TableName = 'MT17'
set @RefName = N'fk_mt17_dmkh2'
set @TabIndex = 7

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 10) MT18
select @sysTableID = sysTableID from sysTable
where TableName = 'MT18'
set @RefName = N'fk_mt18_dmkh2'
set @TabIndex = 7

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 11) MT21
select @sysTableID = sysTableID from sysTable
where TableName = 'MT21'
set @RefName = N'fk_mt21_dmkh2'
set @TabIndex = 13

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 12) MT22
select @sysTableID = sysTableID from sysTable
where TableName = 'MT22'
set @RefName = N'fk_mt22_dmkh2'
set @TabIndex = 13

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 13) MT23
select @sysTableID = sysTableID from sysTable
where TableName = 'MT23'
set @RefName = N'fk_mt23_dmkh2'
set @TabIndex = 13

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 14) MT24
select @sysTableID = sysTableID from sysTable
where TableName = 'MT24'
set @RefName = N'fk_mt24_dmkh2'
set @TabIndex = 13

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 15) MT25
select @sysTableID = sysTableID from sysTable
where TableName = 'MT25'
set @RefName = N'fk_mt25_dmkh2'
set @TabIndex = 13

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 16) MT26
select @sysTableID = sysTableID from sysTable
where TableName = 'MT26'
set @RefName = N'fk_mt26_dmkh2'
set @TabIndex = 7

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 17) MT34
select @sysTableID = sysTableID from sysTable
where TableName = 'MT34'
set @RefName = N'fk_mt34_dmkh2'
set @TabIndex = 7

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 18) DT35
select @sysTableID = sysTableID from sysTable
where TableName = 'DT35'
set @RefName = N'fk_dt35_dmkh2'
set @TabIndex = 2

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 19) MT36
select @sysTableID = sysTableID from sysTable
where TableName = 'MT36'
set @RefName = N'fk_mt36_dmkh2'
set @TabIndex = 20

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 20) MT42
select @sysTableID = sysTableID from sysTable
where TableName = 'MT42'
set @RefName = N'fk_mt42_dmkh2'
set @TabIndex = 7

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 21) MT51
select @sysTableID = sysTableID from sysTable
where TableName = 'MT51'
set @RefName = N'fk_mt51_dmkh2'
set @TabIndex = 4

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END

-- 22) MT52
select @sysTableID = sysTableID from sysTable
where TableName = 'MT52'
set @RefName = N'fk_mt52_dmkh2'
set @TabIndex = 9

if not exists (select top 1 1 from sysField where FieldName = N'Saleman' and sysTableID = @sysTableID)
BEGIN

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, N'MaKH', N'DMKH', N'TenKH', N'isNV = 1', 1, N'Saleman', N'Nhân viên', N'Saleman', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, @RefName, NULL, NULL, 0, NULL)

END