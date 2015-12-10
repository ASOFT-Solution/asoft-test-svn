use [CDT]

-- MVATTNDN
IF NOT EXISTS (SELECT TOP 1 1 FROM sysTable WHERE TableName = 'MVATTNDN' AND sysPackageID = 8)
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'MVATTNDN', N'Tờ khai thuế TNDN', NULL, N'MVATTNDNID', NULL, NULL, 0, NULL, NULL, 0, NULL, 8, NULL, 0)
GO

DECLARE @sysTableMVATTNDNID INT
SELECT @sysTableMVATTNDNID = sysTableID FROM sysTable WHERE TableName = 'MVATTNDN' AND sysPackageID = 8

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'MVATTNDNID' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'MVATTNDNID', 0, NULL, NULL, NULL, NULL, 3, N'Khóa chính', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'MauBaoCao' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'MauBaoCao', 0, NULL, NULL, NULL, NULL, 2, N'Mẫu báo cáo', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'Nam1' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'Nam1', 0, NULL, NULL, NULL, NULL, 5, N'Năm', NULL, 3, NULL, NULL, 9999, 1900, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'####', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'Nam2' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'Nam2', 1, NULL, NULL, NULL, NULL, 5, N'Năm', NULL, 4, NULL, NULL, 9999, 1900, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'####', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'ChonKy' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'ChonKy', 1, NULL, NULL, NULL, NULL, 5, N'Chọn kỳ', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'TuKy' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'TuKy', 0, NULL, NULL, NULL, NULL, 5, N'Từ kỳ', NULL, 6, NULL, NULL, 12, 0, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'DenKy' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'DenKy', 0, NULL, NULL, NULL, NULL, 5, N'Đến kỳ', NULL, 7, NULL, NULL, 12, 0, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'Quy' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'Quy', 0, NULL, NULL, NULL, NULL, 5, N'Quý', NULL, 8, NULL, NULL, 4, 1, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'Ngay' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'Ngay', 0, NULL, NULL, NULL, NULL, 9, N'Ngày lập tờ khai', NULL, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'InLanDau' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'InLanDau', 0, NULL, NULL, NULL, NULL, 10, N'In lần đầu', NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'SoLanIn' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'SoLanIn', 0, NULL, NULL, NULL, NULL, 5, N'Số lần in', NULL, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'PhuThuoc' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'PhuThuoc', 0, NULL, NULL, NULL, NULL, 12, N'Doanh nghiệp có cơ sở hạch toán phụ thuộc', NULL, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'DienGiai' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'DienGiai', 1, NULL, NULL, NULL, NULL, 2, N'Diễn giải', NULL, 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'TaiLieu1' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'TaiLieu1', 1, NULL, NULL, NULL, NULL, 2, N'Tên tài liệu 1', NULL, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'TaiLieu2' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'TaiLieu2', 1, NULL, NULL, NULL, NULL, 2, N'Tên tài liệu 2', NULL, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'TaiLieu3' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'TaiLieu3', 1, NULL, NULL, NULL, NULL, 2, N'Tên tài liệu 3', NULL, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'TaiLieu4' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'TaiLieu4', 1, NULL, NULL, NULL, NULL, 2, N'Tên tài liệu 4', NULL, 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'TaiLieu5' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'TaiLieu5', 1, NULL, NULL, NULL, NULL, 2, N'Tên tài liệu 5', NULL, 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'TaiLieu6' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'TaiLieu6', 1, NULL, NULL, NULL, NULL, 2, N'Tên tài liệu 6', NULL, 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'GiaHan' AND sysTableID = @sysTableMVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMVATTNDNID, N'GiaHan', 1, NULL, NULL, NULL, NULL, 5, N'Gia hạn', NULL, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

GO

-- DVATTNDN
IF NOT EXISTS (SELECT TOP 1 1 FROM sysTable WHERE TableName = 'DVATTNDN' AND sysPackageID = 8)
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'DVATTNDN', N'Chi tiết tờ khai thuế TNDN', NULL, N'DVATTNDNID', NULL, N'MVATTNDN', 3, NULL, NULL, 0, NULL, 8, NULL, 0)
GO

DECLARE @sysTableDVATTNDNID INT
SELECT @sysTableDVATTNDNID = sysTableID FROM sysTable WHERE TableName = 'DVATTNDN' AND sysPackageID = 8

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'DVATTNDNID' AND sysTableID = @sysTableDVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDVATTNDNID, N'DVATTNDNID', 0, NULL, NULL, NULL, NULL, 3, N'Khóa chính', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'MVATTNDNID' AND sysTableID = @sysTableDVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDVATTNDNID, N'MVATTNDNID', 0, N'MVATTNDNID', N'MVATTNDN', NULL, NULL, 4, N'Khóa ngoại', NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DVATTNDN_MVATTNDN2', NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'Stt1' AND sysTableID = @sysTableDVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDVATTNDNID, N'Stt1', 1, NULL, NULL, NULL, NULL, 2, N'Số thứ tự 1', NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'Stt2' AND sysTableID = @sysTableDVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDVATTNDNID, N'Stt2', 1, NULL, NULL, NULL, NULL, 2, N'Số thứ tự 2', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'TenChiTieu' AND sysTableID = @sysTableDVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDVATTNDNID, N'TenChiTieu', 0, NULL, NULL, NULL, NULL, 2, N'Tên chỉ tiêu', NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'TenChiTieu2' AND sysTableID = @sysTableDVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDVATTNDNID, N'TenChiTieu2', 1, NULL, NULL, NULL, NULL, 2, N'tên chỉ tiêu 2', NULL, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'MaCode' AND sysTableID = @sysTableDVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDVATTNDNID, N'MaCode', 0, NULL, NULL, NULL, NULL, 2, N'Mã số', NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'TTien' AND sysTableID = @sysTableDVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDVATTNDNID, N'TTien', 1, NULL, NULL, NULL, NULL, 8, N'Số tiền', NULL, 8, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DVATTNDN_TTien', NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'GhiChu' AND sysTableID = @sysTableDVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDVATTNDNID, N'GhiChu', 1, NULL, NULL, NULL, NULL, 2, N'Ghi chú', NULL, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE FieldName = 'SortOrder' AND sysTableID = @sysTableDVATTNDNID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDVATTNDNID, N'SortOrder', 0, NULL, NULL, NULL, NULL, 5, N'Thứ tự sắp xếp', NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- Dictionary
--IF NOT EXISTS (SELECT TOP 1 1 FROM Dictionary WHERE Content = N'Tạo tờ khai thuế VAT')
--insert into Dictionary(Content, Content2) Values (N'Tạo tờ khai thuế VAT',N'Edit VAT return')