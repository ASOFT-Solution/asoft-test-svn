USE [CDT]

DECLARE @sysTableID AS INT

IF NOT EXISTS (SELECT TOP 1 1 FROM sysTable WHERE TableName = 'DMLCTThue')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES ( N'DMLCTThue', N'Danh mục loại chứng từ thuế', N'List of tax invoice type', N'MaLCTThue', NULL, NULL, 2, NULL, NULL, 0, NULL, 8, NULL, 0)

SELECT @sysTableID = sysTableID FROM sysTable WHERE TableName = 'DMLCTThue'

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableID AND FieldName = 'MaLCTThue')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaLCTThue', 0, NULL, NULL, NULL, NULL, 3, N'Mã loại chứng từ thuế', N'Tax invoice type code', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 1, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableID AND FieldName = 'TenLCTThue')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TenLCTThue', 0, NULL, NULL, NULL, NULL, 2, N'Tên loại chứng từ thuế', N'Tax invoice type name', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableID AND FieldName = 'TenLCTThue2')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TenLCTThue2', 1, NULL, NULL, NULL, NULL, 2, N'Tên loại chứng từ thuế tiếng Anh', N'Tax invoice type name in English', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableID AND FieldName = 'TK1')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TK1', 1, NULL, NULL, NULL, NULL, 2, N'Tài khoản 1', N'Account 1', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableID AND FieldName = 'TKDU1')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TKDU1', 1, NULL, NULL, NULL, NULL, 2, N'Tài khoản đối ứng 1', N'Corresponding account 1', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableID AND FieldName = 'TK2')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TK2', 1, NULL, NULL, NULL, NULL, 2, N'Tài khoản 2', N'Account 2', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableID AND FieldName = 'TKDU2')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TKDU2', 1, NULL, NULL, NULL, NULL, 2, N'Tài khoản đối ứng 2', N'Corresponding account 2', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)