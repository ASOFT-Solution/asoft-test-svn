USE [CDT]
declare @sysTableID as int
declare @FieldIndex as int

-- Them table DT31
select @sysTableID = sysTableID from sysTable where TableName = 'DT31'

set @FieldIndex = 5

if not exists (select top 1 1 from sysField where FieldName = 'ChiuThueTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ChiuThueTTDB', 1, NULL, NULL, NULL, NULL, 10, N'Chịu thuế TTDB', N'Special consume tax', @FieldIndex, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 1, 0, 1, NULL, N'DF_DT32_ChiuThueTTDB', NULL, 0, NULL)

-- Them table DT32
select @sysTableID = sysTableID from sysTable where TableName = 'DT32'

set @FieldIndex = 4

if not exists (select top 1 1 from sysField where FieldName = 'ChiuThueTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ChiuThueTTDB', 1, NULL, NULL, NULL, NULL, 10, N'Chịu thuế TTDB', N'Special consume tax', @FieldIndex, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 1, 0, 1, NULL, N'DF_DT32_ChiuThueTTDB', NULL, 0, NULL)

-- Them table DT33
select @sysTableID = sysTableID from sysTable where TableName = 'DT33'

set @FieldIndex = 6

if not exists (select top 1 1 from sysField where FieldName = 'ChiuThueTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ChiuThueTTDB', 1, NULL, NULL, NULL, NULL, 10, N'Chịu thuế TTDB', N'Special consume tax', @FieldIndex, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 1, 0, 1, NULL, N'DF_DT33_ChiuThueTTDB', NULL, 0, NULL)


-- Them table DT21
select @sysTableID = sysTableID from sysTable where TableName = 'DT21'

set @FieldIndex = 7

if not exists (select top 1 1 from sysField where FieldName = 'ChiuThueTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ChiuThueTTDB', 1, NULL, NULL, NULL, NULL, 10, N'Chịu thuế TTDB', N'Special consume tax', @FieldIndex, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 1, 0, 1, NULL, N'DF_DT21_ChiuThueTTDB', NULL, 0, NULL)


-- Them table DT22
select @sysTableID = sysTableID from sysTable where TableName = 'DT22'

set @FieldIndex = 6

if not exists (select top 1 1 from sysField where FieldName = 'ChiuThueTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ChiuThueTTDB', 1, NULL, NULL, NULL, NULL, 10, N'Chịu thuế TTDB', N'Special consume tax', @FieldIndex, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 1, 0, 1, NULL, N'DF_DT22_ChiuThueTTDB', NULL, 0, NULL)


-- Them table DT23
select @sysTableID = sysTableID from sysTable where TableName = 'DT23'

set @FieldIndex = 6

if not exists (select top 1 1 from sysField where FieldName = 'ChiuThueTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ChiuThueTTDB', 1, NULL, NULL, NULL, NULL, 10, N'Chịu thuế TTDB', N'Special consume tax', @FieldIndex, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 1, 0, 1, NULL, N'DF_DT23_ChiuThueTTDB', NULL, 0, NULL)
