USE [CDT]

declare @sysTableID int,
		@TabIndex int,
		@sysTableVWID int,
		@RefName nvarchar(50),
		@formatTien nvarchar(128)

set @formatTien = dbo.GetFormatString('Tien')

-- 1) wQuyDaLapBK
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysTable] WHERE [sysPackageID] = 8 AND [TableName] = 'wQuyDaLapBK')
INSERT [dbo].[sysTable]([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType])
VALUES(N'wQuyDaLapBK', N'View danh sách quý đã lập đầy đủ bảng kê', NULL, N'Quy',NULL, NULL, 1, N'Quy', NULL, 0, NULL, 8, NULL, -1)

SELECT @sysTableVWID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'wQuyDaLapBK'

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'Quy')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'Quy', 0, NULL, NULL, NULL, NULL, 1, N'Quý', N'Quarter', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'Nam')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'Nam', 0, NULL, NULL, NULL, NULL, 1, N'Năm', N'Year', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'ThueMVNT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'ThueMVNT', 1, NULL, NULL, NULL, NULL, 8, N'Thuế mua vào nguyên tệ', N'Original VAT In', 3, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, @formatTien, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'ThueMV')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'ThueMV', 1, NULL, NULL, NULL, NULL, 8, N'Thuế mua vào', N'VAT In', 4, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, @formatTien, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'ThueBRNT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'ThueBRNT', 1, NULL, NULL, NULL, NULL, 8, N'Thuế bán ra nguyên tệ', N'Original VAT Out', 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, @formatTien, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'ThueBR')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'ThueBR', 1, NULL, NULL, NULL, NULL, 8, N'Thuế bán ra', N'VAT Out', 6, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, @formatTien, 0, NULL)

-- 2) MT36
select @sysTableID = sysTableID from sysTable
where TableName = 'MT36'

if not exists (select top 1 1 from sysField where FieldName = N'IsQuy' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 10

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

set @RefName = N'DF_MT36_IsQuy'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 10, N'IsQuy', N'Theo Quý', N'By Quarter', @TabIndex, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, @RefName, NULL, 0, NULL)

END

if not exists (select top 1 1 from sysField where FieldName = N'QuyKTT' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 11

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

--set @RefName = N'DF_MT36_IsQuy'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 0, N'Quy', N'wQuyDaLapBK', N'Quy', NULL, 4, N'QuyKTT', N'Quý khấu trừ', N'Deduction Quarter', @TabIndex, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

END

Update sysField set FormulaDetail = NULL
where sysTableID = @sysTableID
and FieldName = N'TThueBKMVNT'
and FormulaDetail = N'KyKTT.ThueMVNT'

Update sysField set FormulaDetail = NULL
where sysTableID = @sysTableID
and FieldName = N'TThueBKMV'
and FormulaDetail = N'KyKTT.ThueMV'

Update sysField set FormulaDetail = NULL
where sysTableID = @sysTableID
and FieldName = N'TThueBKBRNT'
and FormulaDetail = N'KyKTT.ThueBRNT'

Update sysField set FormulaDetail = NULL
where sysTableID = @sysTableID
and FieldName = N'TThueBKBR'
and FormulaDetail = N'KyKTT.ThueBR'

-- 3) MVATIn
select @sysTableID = sysTableID from sysTable
where TableName = 'MVATIn'

if not exists (select top 1 1 from sysField where FieldName = N'QuyBKMV' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 1

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

set @RefName = N'DF_MVATIn_QuyBKMV'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 0, NULL, NULL, NULL, NULL, 5, N'QuyBKMV', N'Quý báo cáo', N'Post Quarter', @TabIndex, NULL, NULL, 4, 1, N'0', NULL, NULL, 1, 0, 1, 0, 1, NULL, @RefName, N'#', 0, NULL)

END

-- 4) MVATOut
select @sysTableID = sysTableID from sysTable
where TableName = 'MVATOut'

if not exists (select top 1 1 from sysField where FieldName = N'QuyBKBR' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 1

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

set @RefName = N'DF_MVATOut_QuyBKBR'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 0, NULL, NULL, NULL, NULL, 5, N'QuyBKBR', N'Quý báo cáo', N'Post Quarter', @TabIndex, NULL, NULL, 4, 1, N'0', NULL, NULL, 1, 0, 1, 0, 1, NULL, @RefName, N'#', 0, NULL)

END

-- 5) MToKhai
select @sysTableID = sysTableID from sysTable
where TableName = 'MToKhai'

if not exists (select top 1 1 from sysField where FieldName = N'QuyToKhai' and sysTableID = @sysTableID)
BEGIN

set @TabIndex = 1

-- Update TabIndex
Update sysField set TabIndex = TabIndex + 1
where sysTableID = @sysTableID and TabIndex >= @TabIndex

set @RefName = N'DF_MToKhai_QuyToKhai'
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 0, NULL, NULL, NULL, NULL, 5, N'QuyToKhai', N'Quý lập tờ khai', N'VAT Return Quarter', @TabIndex, NULL, NULL, 4, 1, N'0', NULL, NULL, 1, 0, 1, 0, 1, NULL, @RefName, N'#', 0, NULL)

END