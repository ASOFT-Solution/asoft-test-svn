use [CDT]
declare @sysTableID int
Select @sysTableID = sysTableID FROM sysTable WHERE TableName = 'MToKhai'
--Field DeclareType
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'DeclareType')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'DeclareType', 1, NULL, NULL, NULL, NULL,5, N'Loại tờ khai', N'Type Declaration', 8, NULL, NULL,NULL, NULL,	NULL, N'(1: Tờ khai tháng; 2: Tờ khai Quý; 0:Không chọn)', NULL, 1,	0, 0, 0, 1,	NULL, NULL,	NULL, 0, NULL)
END

--Field AmendedReturnDate
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'AmendedReturnDate')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'AmendedReturnDate',	1,	NULL,	NULL,	NULL,	NULL,	9,	N'Ngày lập KHBS',	NULL,	9,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field IsExten
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'IsExten')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'IsExten', 1,	NULL,	NULL,	NULL,	NULL,	10,	N'Gia hạn',	N'Extend',	10,	NULL,	NULL,	NULL,	NULL,	0,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	N'DF_MToKhai_IsExten',	NULL,	0,	NULL)
END

--Field ExtenID
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'ExtenID')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExtenID', 1,	N'ExtenID',	N'DMGH',	NULL,	NULL,	1,	N'Mã gia hạn',	N'Extend ID',	11,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	N'FK_MToKhai_DMGH25',	NULL,	NULL,	0,	NULL)
END

--Field VocationID
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'VocationID')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'VocationID',	1,	N'VocationID',	N'DMNN',	NULL,	NULL,	1,	N'Mã ngành nghề',	N'Vocation ID',	12,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	N'FK_MToKhai_DMNN25',	NULL,	NULL,	0,	NULL)
END

--Field IsInputAppendix
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'IsInputAppendix')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'IsInputAppendix', 1,	NULL,	NULL,	NULL,	NULL,	10,	N'Phụ lục bảng kê thuế GTGT mua vào',	NULL,	13,	NULL,	NULL,	NULL,	NULL,	0,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	N'DF_MToKhai_IsInputAppendix',	NULL,	0,	NULL)
END

--Field IsOutputAppendix
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'IsOutputAppendix')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'IsOutputAppendix', 1, NULL,	NULL,	NULL,	NULL,	10,	N'Phụ lục bảng kê thuế GTGT bán ra',	NULL,	14,	NULL,	NULL,	NULL,	NULL,	0,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	N'DF_MToKhai_IsOutputAppendix',	NULL,	0,	NULL)
END

--Field ExperiedDay
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'ExperiedDay')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExperiedDay', 1,	NULL,	NULL,	NULL,	NULL,	5,	N'Số ngày chậm nộp',	N'Experied Day',	15,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field ExperiedAmount
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'ExperiedAmount')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExperiedAmount',	1,	NULL,	NULL,	NULL,	NULL,	8,	N'Số tiền chậm nộp',	N'Experied Amount',	16,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field PayableAmount
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'PayableAmount')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PayableAmount',	1,	NULL,	NULL,	NULL,	NULL,	8,	N'Số tiền',	N'Payable Amount',	17,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field PayableCmt
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'PayableCmt')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PayableCmt',	1,	NULL,	NULL,	NULL,	NULL,	2,	N'Lệnh hoàn trả',	N'Payable Comment',	18,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field PayableDate
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'PayableDate')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PayableDate', 1,	NULL,	NULL,	NULL,	NULL,	9,	N'Ngày',	N'Payable Date',	19,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field TaxDepartmentID
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'TaxDepartmentID')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TaxDepartmentID', 1,	N'TaxDepartmentID',	N'DMThueCapCuc',	NULL,	NULL,	1,	N'Tên cơ quan thuế cấp cục',	NULL,	20,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	N'FK_MToKhai_DMThueCapCuc24',	NULL,	NULL,	0,	NULL)
END

--Field TaxDepartID
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'TaxDepartID')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TaxDepartID', 1,	N'TaxDepartID',	N'DMThueCapQL',	NULL,	NULL,	1,	N'Tên cơ quan thuế QD hoàn thuế',	NULL,	21,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	N'FK_MToKhai_DMThueCapQL25',	NULL,	NULL,	0,	NULL)
END

--Field ReceivableExperied
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'ReceivableExperied')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ReceivableExperied',	1,	NULL,	NULL,	NULL,	NULL,	5,	N'Số ngày nhận tiền hoàn thuế',	N'Receivable Experied',	22,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field ReceivableAmount
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'ReceivableAmount')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ReceivableAmount', 1, NULL,	NULL,	NULL,	NULL,	8,	N'Số tiền chậm nộp',	N'Receivable Amount',	23,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field ExperiedReason
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'ExperiedReason')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExperiedReason',	1,	NULL,	NULL,	NULL,	NULL,	2,	N'Lý do khác',	N'Experied Reason',	24,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

