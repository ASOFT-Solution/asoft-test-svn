Use CDT
declare @sysTableID int
Select @sysTableID = sysTableID FROM sysTable WHERE TableName = N'MToKhaiTTDB'

IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'InputDate' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'InputDate', 1, NULL, NULL, NULL, NULL, 9, N'Theo lần phát sinh', N'Input Date', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'AmendedReturnDate' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'AmendedReturnDate', 1, NULL, NULL, NULL, NULL, 9, N'Ngày lập KHBS', N'Amended ReturnDate', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'IsExten' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'IsExten', 1, NULL, NULL, NULL, NULL, 10, N'Gia hạn', N'Exten', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'IsInputAppendix' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'IsInputAppendix', 1, NULL, NULL, NULL, NULL, 10, N'Phụ lục bảng kê thuế TTDB mua vào', N'Input Appendix', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'IsOutputAppendix' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'IsOutputAppendix', 1, NULL, NULL, NULL, NULL, 10, N'Phụ lục bảng kê thuế TTDB bán ra', N'Output Appendix', 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'ExperiedDay' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'ExperiedDay', 1, NULL, NULL, NULL, NULL, 8, N'Số ngày chậm nộp', N'Experied Day', 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'ExperiedAmount' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'ExperiedAmount', 1, NULL, NULL, NULL, NULL, 8, N'Số tiền chậm nộp', N'Experied Amount', 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'##,###,###,###,##0', 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'PayableAmount' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'PayableAmount', 1, NULL, NULL, NULL, NULL, 8, N'Số tiền', N'Payable Amount', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'##,###,###,###,##0', 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'PayableCmt' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'PayableCmt', 1, NULL, NULL, NULL, NULL, 2, N'Lệnh hoàn trả', N'Payable Command', 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'PayableDate' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'PayableDate', 1, NULL, NULL, NULL, NULL, 9, N'Ngày', N'Payable Date', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'ReceivableExperied' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'ReceivableExperied', 1, NULL, NULL, NULL, NULL, 8, N'Số ngày nhận tiền hoàn thuế', N'Receivable Experied', 27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'##,###,###,###,##0', 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'ReceivableAmount' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'ReceivableAmount', 1, NULL, NULL, NULL, NULL, 8, N'Số tiền chậm nộp', N'Receivable Amount', 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'##,###,###,###,##0', 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'ExperiedReason' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'ExperiedReason', 1, NULL, NULL, NULL, NULL, 2, N'Lý do khác', N'Experied Reason', 29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'ExtenID' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'ExtenID', 1, N'ExtenID', N'DMGH', NULL, NULL, 1, N'Mã gia hạn', N'Exten Code', 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MToKhaiTTDB_DMGH27', NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'VocationID' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'VocationID', 1, N'VocationID', N'DMNN', NULL, NULL, 1, N'Mã ngành nghề', N'Vocation Code', 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MToKhaiTTDB_DMNN28', NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'DeclareType' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'DeclareType', 1, NULL, NULL, NULL, NULL, 5, N'Loại tờ khai', N'Declare Type', 12, NULL, NULL, 2, 1, NULL, N'1: Theo tháng; 2: Theo lần phát sinh', NULL, 1, 0, 0, 0, 1, NULL, NULL, N'#', 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'TaxDepartmentID' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'TaxDepartmentID', 1, N'TaxDepartmentID', N'DMThueCapCuc', NULL, NULL, 1, N'Tên cơ quan thuế cấp cục', N'TaxDepartment code', 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MToKhaiTTDB_DMThueCapCuc30', NULL, NULL, 0, NULL)
END
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'TaxDepartID' and sysTableID = @sysTableID)
BEGIN
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'TaxDepartID', 1, N'TaxDepartID', N'DMThueCapQL', NULL, NULL, 1, N'Tên cơ quan thuế QD hoàn thuế', N'TaxDepart code', 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MToKhaiTTDB_DMThueCapQL31', NULL, NULL, 0, NULL)
END
