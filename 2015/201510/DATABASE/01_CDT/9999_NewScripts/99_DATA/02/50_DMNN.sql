USE [CDT]
declare @sysTableID int

-- 1) Tạo cấu trúc table DMNN trong CDT
if not exists (select top 1 1 from sysTable where TableName = 'DMNN')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'DMNN', N'Danh mục ngành nghề', N'Danh mục ngành nghề', N'Stt', NULL, NULL, 2, N'Stt', NULL, 1, NULL, 8, NULL, 0)

select @sysTableID = sysTableID from sysTable where TableName = 'DMNN'

if not exists (select top 1 1 from sysField where FieldName = 'Stt' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'Stt', 0, NULL, NULL, NULL, NULL, 3, N'Stt', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ExtenID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'VocationID', 0, NULL, NULL, NULL, NULL, 2, N'Mã ngành nghề', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 1, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ExtenName' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'VocationName', 0, NULL, NULL, NULL, NULL, 2, N'Tên ngành nghề', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ExtenName2' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'VocationName2', 1, NULL, NULL, NULL, NULL, 2, N'Tên ngành nghề 2', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'Notes' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'Notes', 1, NULL, NULL, NULL, NULL, 2, N'Ghi chú', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'Disabled' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'Disabled', 1, NULL, NULL, NULL, NULL, 10, N'Không sử dụng', N'Disabled', 5, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DMNN_Disabled', NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TaxType' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TaxType', 1, NULL, NULL, NULL, NULL, 2, N'Loại thuế', NULL, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)