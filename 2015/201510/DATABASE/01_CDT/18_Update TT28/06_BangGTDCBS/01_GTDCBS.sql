use [CDT]

--1) Them table VATinGTBS
if not exists (select top 1 1 from sysTable where TableName = 'VATinGTBS' and sysPackageID = 8)
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'VATinGTBS', N'Bảng giải trình bổ sung điều chỉnh', N'The explanation - additional - adjustment', N'MaGTBS', NULL, NULL, 2, N'Stt', NULL, 0, NULL, 8, N'01-KHBS', 2)

GO

declare @sysTableGTBSID as int
select @sysTableGTBSID = sysTableID from sysTable where TableName = 'VATinGTBS' and sysPackageID = 8

if not exists (select top 1 1 from sysField where FieldName = 'MaGTBS' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'MaGTBS', 0, NULL, NULL, NULL, NULL, 6, N'Mã GTBS', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'KyGTBS' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'KyGTBS', 0, 'Ky', N'wKyThueGTBS', 'Ky', NULL, 4, N'Kỳ tính thuế', N'Period', 1, NULL, NULL, 12, 1, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'NamGTBS' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'NamGTBS', 0, NULL, NULL, NULL, NULL, 5, N'Năm', N'Year', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'NgayGTBS' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'NgayGTBS', 0, NULL, NULL, NULL, NULL, 9, N'Ngày lập bảng giải trình', N'Created date', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'NgayKeKhai' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'NgayKeKhai', 0, NULL, NULL, NULL, NULL, 9, N'Ngày kê khai', N'Declaration date', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ToKhaiThue' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'ToKhaiThue', 0, NULL, NULL, NULL, NULL, 2, N'Tờ khai thuế', N'VAT return', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MauSo' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'MauSo', 0, NULL, NULL, NULL, NULL, 2, N'Mẫu số', N'Template No', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'DC1' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'DC1', 1, NULL, NULL, NULL, NULL, 8, N'Điều chỉnh tăng thuế GTGT bán ra', N'Increase VAT out', 9, N'@ChenhLech1 + @KeKhai1', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'DC2' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'DC2', 1, NULL, NULL, NULL, NULL, 8, N'Điều chỉnh giảm thuế GTGT mua vào', N'Decrease VAT in', 12, N'@ChenhLech2 - @KeKhai2', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'DC3' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'DC3', 1, NULL, NULL, NULL, NULL, 8, N'Điều chỉnh tăng thuế GTGT mua vào', N'Increase VAT in', 15, N'@ChenhLech3 + @KeKhai3', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'DC4' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'DC4', 1, NULL, NULL, NULL, NULL, 8, N'Điều chỉnh giảm thuế GTGT bán ra', N'Decrease VAT out', 18, N'@ChenhLech4 - @KeKhai4', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'KeKhai1' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'KeKhai1', 1, NULL, NULL, NULL, NULL, 8, N'Số đã kê khai 1', N'Declaration 1', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'KeKhai2' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'KeKhai2', 1, NULL, NULL, NULL, NULL, 8, N'Số đã kê khai 2', N'Declaration 2', 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'KeKhai3' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'KeKhai3', 1, NULL, NULL, NULL, NULL, 8, N'Số đã kê khai 3', N'Declaration 3', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'KeKhai4' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'KeKhai4', 1, NULL, NULL, NULL, NULL, 8, N'Số đã kê khai 4', N'Declaration 4', 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ChenhLech1' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'ChenhLech1', 1, NULL, NULL, NULL, NULL, 8, N'Chênh lệch 1', N'Difference 1', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ChenhLech2' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'ChenhLech2', 1, NULL, NULL, NULL, NULL, 8, N'Chênh lệch 2', N'Difference 2', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ChenhLech3' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'ChenhLech3', 1, NULL, NULL, NULL, NULL, 8, N'Chênh lệch 3', N'Difference 3', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ChenhLech4' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'ChenhLech4', 1, NULL, NULL, NULL, NULL, 8, N'Chênh lệch 4', N'Difference 4', 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ChiTieu1' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'ChiTieu1', 1, NULL, NULL, NULL, NULL, 2, N'MS chỉ tiêu 1', N'Target code 1', 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ChiTieu2' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'ChiTieu2', 1, NULL, NULL, NULL, NULL, 2, N'MS chỉ tiêu 2', N'Target code 2', 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ChiTieu3' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'ChiTieu3', 1, NULL, NULL, NULL, NULL, 2, N'MS chỉ tiêu 3', N'Target code 3', 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ChiTieu4' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'ChiTieu4', 1, NULL, NULL, NULL, NULL, 2, N'MS chỉ tiêu 4', N'Target code 4', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TongDC' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'TongDC', 1, NULL, NULL, NULL, NULL, 8, N'Tổng hợp điều chỉnh số thuế phải nộp', N'Total adjustment tax', 23, N'(@ChenhLech1 + @ChenhLech2) - (@ChenhLech3 + @ChenhLech4)', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'NopCham' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'NopCham', 1, NULL, NULL, NULL, NULL, 5, N'Số ngày nộp chậm', N'Total late day', 24, NULL, NULL, NULL, 1, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PhatNopCham' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'PhatNopCham', 1, NULL, NULL, NULL, NULL, 8, N'Số tiền phạt nộp chậm', N'Amount punished', 25, N'@TongDC * @NopCham * 0.0005', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'DienGiai' and sysTableID = @sysTableGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableGTBSID, N'DienGiai', 1, NULL, NULL, NULL, NULL, 13, N'Nội dung giải thích và tài liệu đính kèm', N'Description and attached documents', 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

GO

-- 2) Them view
if not exists (select top 1 1 from sysTable where TableName = 'wKyThueGTBS' and sysPackageID = 8)
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'wKyThueGTBS', N'View danh sách kỳ giải trình bổ sung', NULL, N'Ky', NULL, NULL, 1, N'Ky', NULL, 0, NULL, 8, NULL, -1)

declare @sysViewGTBSID as int
select @sysViewGTBSID = sysTableID from sysTable where TableName = 'wKyThueGTBS' and sysPackageID = 8

if not exists (select top 1 1 from sysField where FieldName = 'Ky' and sysTableID = @sysViewGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysViewGTBSID, N'Ky', 0, NULL, NULL, NULL, NULL, 1, N'Kỳ', N'Period', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'Nam' and sysTableID = @sysViewGTBSID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysViewGTBSID, N'Nam', 0, NULL, NULL, NULL, NULL, 1, N'Năm', N'Year', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

--3) Tao menu
declare @sysTableGTBSID as int
declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int
declare @sysMenuGTGT as int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

select @sysTableGTBSID = sysTableID from sysTable where tableName = N'VATinGTBS' and sysPackageID = 8

if isnull(@sysSiteIDPRO,'') <> ''
BEGIN
select @sysMenuGTGT = sysMenuID from sysMenu where MenuName = N'Thuế GTGT' and sysSiteID = @sysSiteIDPRO

-- PRO
if not exists (select top 1 1 from [sysMenu] where MenuName = N'Bảng giải trình, bổ sung, điều chỉnh' and [sysSiteID] = @sysSiteIDPRO and [sysMenuParent] = @sysMenuGTGT)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Bảng giải trình, bổ sung, điều chỉnh', N'The explanation - additional - adjustment', @sysSiteIDPRO, 2, @sysTableGTBSID, NULL, 2, NULL, @sysMenuGTGT, NULL, NULL, 4, NULL)
END

if isnull(@sysSiteIDSTD,'') <> ''
BEGIN
select @sysMenuGTGT = sysMenuID from sysMenu where MenuName = N'Thuế GTGT' and sysSiteID = @sysSiteIDSTD

-- STD
if not exists (select top 1 1 from [sysMenu] where MenuName = N'Bảng giải trình, bổ sung, điều chỉnh' and [sysSiteID] = @sysSiteIDSTD and [sysMenuParent] = @sysMenuGTGT)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Bảng giải trình, bổ sung, điều chỉnh', N'The explanation - additional - adjustment', @sysSiteIDSTD, 2, @sysTableGTBSID, NULL, 2, NULL, @sysMenuGTGT, NULL, NULL, 4, NULL)

END

-- Dictionary
if not exists (select top 1 1 from Dictionary where Content = N'Kỳ tính thuế')
insert into Dictionary(Content, Content2) Values (N'Kỳ tính thuế',N'Period')

if not exists (select top 1 1 from Dictionary where Content = N'Năm')
insert into Dictionary(Content, Content2) Values (N'Năm',N'Year')

if not exists (select top 1 1 from Dictionary where Content = N'Ngày lập bảng giải trình')
insert into Dictionary(Content, Content2) Values (N'Ngày lập bảng giải trình',N'Created date')

if not exists (select top 1 1 from Dictionary where Content = N'Ngày kê khai')
insert into Dictionary(Content, Content2) Values (N'Ngày kê khai',N'Declaration date')

if not exists (select top 1 1 from Dictionary where Content = N'Tờ khai thuế')
insert into Dictionary(Content, Content2) Values (N'Tờ khai thuế',N'VAT return')

if not exists (select top 1 1 from Dictionary where Content = N'Mẫu số')
insert into Dictionary(Content, Content2) Values (N'Mẫu số',N'Template No')

if not exists (select top 1 1 from Dictionary where Content = N'Điều chỉnh tăng thuế GTGT bán ra')
insert into Dictionary(Content, Content2) Values (N'Điều chỉnh tăng thuế GTGT bán ra',N'Increase VAT out')

if not exists (select top 1 1 from Dictionary where Content = N'Điều chỉnh giảm thuế GTGT mua vào')
insert into Dictionary(Content, Content2) Values (N'Điều chỉnh giảm thuế GTGT mua vào',N'Decrease VAT in')

if not exists (select top 1 1 from Dictionary where Content = N'Điều chỉnh tăng thuế GTGT mua vào')
insert into Dictionary(Content, Content2) Values (N'Điều chỉnh tăng thuế GTGT mua vào',N'Increase VAT in')

if not exists (select top 1 1 from Dictionary where Content = N'Điều chỉnh giảm thuế GTGT bán ra')
insert into Dictionary(Content, Content2) Values (N'Điều chỉnh giảm thuế GTGT bán ra',N'Decrease VAT out')

if not exists (select top 1 1 from Dictionary where Content = N'Số đã kê khai 1')
insert into Dictionary(Content, Content2) Values (N'Số đã kê khai 1',N'Declaration 1')

if not exists (select top 1 1 from Dictionary where Content = N'Số đã kê khai 2')
insert into Dictionary(Content, Content2) Values (N'Số đã kê khai 2',N'Declaration 2')

if not exists (select top 1 1 from Dictionary where Content = N'Số đã kê khai 3')
insert into Dictionary(Content, Content2) Values (N'Số đã kê khai 3',N'Declaration 3')

if not exists (select top 1 1 from Dictionary where Content = N'Số đã kê khai 4')
insert into Dictionary(Content, Content2) Values (N'Số đã kê khai 4',N'Declaration 4')

if not exists (select top 1 1 from Dictionary where Content = N'Chênh lệch 1')
insert into Dictionary(Content, Content2) Values (N'Chênh lệch 1',N'Difference 1')

if not exists (select top 1 1 from Dictionary where Content = N'Chênh lệch 2')
insert into Dictionary(Content, Content2) Values (N'Chênh lệch 2',N'Difference 2')

if not exists (select top 1 1 from Dictionary where Content = N'Chênh lệch 3')
insert into Dictionary(Content, Content2) Values (N'Chênh lệch 3',N'Difference 3')

if not exists (select top 1 1 from Dictionary where Content = N'Chênh lệch 4')
insert into Dictionary(Content, Content2) Values (N'Chênh lệch 4',N'Difference 4')

if not exists (select top 1 1 from Dictionary where Content = N'MS chỉ tiêu 1')
insert into Dictionary(Content, Content2) Values (N'MS chỉ tiêu 1',N'Target code 1')

if not exists (select top 1 1 from Dictionary where Content = N'MS chỉ tiêu 2')
insert into Dictionary(Content, Content2) Values (N'MS chỉ tiêu 2',N'Target code 2')

if not exists (select top 1 1 from Dictionary where Content = N'MS chỉ tiêu 3')
insert into Dictionary(Content, Content2) Values (N'MS chỉ tiêu 3',N'Target code 3')

if not exists (select top 1 1 from Dictionary where Content = N'MS chỉ tiêu 4')
insert into Dictionary(Content, Content2) Values (N'MS chỉ tiêu 4',N'Target code 4')

if not exists (select top 1 1 from Dictionary where Content = N'Tổng hợp điều chỉnh số thuế phải nộp')
insert into Dictionary(Content, Content2) Values (N'Tổng hợp điều chỉnh số thuế phải nộp',N'Total adjustment tax')

if not exists (select top 1 1 from Dictionary where Content = N'Số ngày nộp chậm')
insert into Dictionary(Content, Content2) Values (N'Số ngày nộp chậm',N'Total late day')

if not exists (select top 1 1 from Dictionary where Content = N'Số tiền phạt nộp chậm')
insert into Dictionary(Content, Content2) Values (N'Số tiền phạt nộp chậm',N'Amount punished')

if not exists (select top 1 1 from Dictionary where Content = N'Nội dung giải thích và tài liệu đính kèm')
insert into Dictionary(Content, Content2) Values (N'Nội dung giải thích và tài liệu đính kèm',N'Description and attached documents')

