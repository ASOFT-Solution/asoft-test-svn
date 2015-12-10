USE [CDT]
declare @sysTableID int,
		@ListTypeID int

-- 1) Tạo cấu trúc table DMThueCapCuc trong CDT
if not exists (select top 1 1 from sysTable where TableName = 'DMThueCapCuc')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'DMThueCapCuc', N'Danh mục cơ quan thuế cấp cục', N'Danh mục cơ quan thuế cấp cục', N'Stt', NULL, NULL, 2, N'Stt', NULL, 1, NULL, 8, NULL, 0)

select @sysTableID = sysTableID from sysTable where TableName = 'DMThueCapCuc'

if not exists (select top 1 1 from sysField where FieldName = 'Stt' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'Stt', 0, NULL, NULL, NULL, NULL, 3, N'Stt', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TaxDepartmentID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TaxDepartmentID', 0, NULL, NULL, NULL, NULL, 2, N'Mã cơ quan thuế', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 1, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TaxDepartmentName' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TaxDepartmentName', 0, NULL, NULL, NULL, NULL, 2, N'Tên cơ quan thuế', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ShortTaxDepartment' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ShortTaxDepartment', 0, NULL, NULL, NULL, NULL, 2, N'Tên viết tắt', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)