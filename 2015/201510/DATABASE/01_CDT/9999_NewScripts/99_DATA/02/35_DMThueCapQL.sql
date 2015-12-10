USE [CDT]
declare @sysTableID int

-- 1) Tạo cấu trúc table DMThueCapQL trong CDT
if not exists (select top 1 1 from sysTable where TableName = 'DMThueCapQL')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'DMThueCapQL', N'Danh mục cơ quan thuế cấp quản lý', N'Danh mục cơ quan thuế cấp quản lý', N'TaxDepartID', NULL, N'DMThueCapCuc', 5, N'Stt', NULL, 1, NULL, 8, NULL, 0)

select @sysTableID = sysTableID from sysTable where TableName = 'DMThueCapQL'

if not exists (select top 1 1 from sysField where FieldName = 'TaxDepartmentID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TaxDepartmentID', 0, N'TaxDepartmentID', N'DMThueCapCuc', N'TaxDepartmentName', NULL, 1, N'Mã cơ quan thuế cấp cục', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DmThueCapQL_DMThueCapCuc2', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TaxDepartID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TaxDepartID', 0, NULL, NULL, NULL, NULL, 0, N'Mã cơ quan thuế cấp quản lý', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 1, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TaxDepartName' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TaxDepartName', 0, NULL, NULL, NULL, NULL, 2, N'Tên cơ quan thuế cấp quản lý', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)