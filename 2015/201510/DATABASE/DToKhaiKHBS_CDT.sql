use [CDT]
IF NOT EXISTS(Select Top 1 1 From sysTable Where TableName ='DToKhaiKHBS')
BEGIN

--Thêm vào bảng sysTable
Insert into sysTable(TableName, DienGiai, DienGiai2, Pk, ParentPk, MasterTable, Type, SortOrder, DetailField, System, MaCT, sysPackageID, Report, CollectType)
Values(N'DToKhaiKHBS',	N'Bảng giải trình bổ sung',	NULL,	N'DToKhaiKHBSID',	NULL,	NULL,	0,	N'Stt',	NULL,	0,	NULL,	8,	NULL,	0)

--Thêm vào bảng sysField
declare @sysTableID int
Select @sysTableID = sysTableID FROM sysTable WHERE TableName = 'DToKhaiKHBS'

--Field DToKhaiKHBSID
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'DToKhaiKHBSID')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'DToKhaiKHBSID',	0,	NULL,	NULL,	NULL,	NULL,	6,	N'Khóa chính',	NULL,	0,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field MToKhaiID
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'MToKhaiID')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MToKhaiID',	0,	N'MToKhaiID',	N'MToKhai',	NULL,	NULL,	7,	N'Mã tờ khai',	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	N'FK_DToKhaiKHBS_MToKhai2',	NULL,	NULL,	0,	NULL)
END

--Field SortOrder
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'SortOrder')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SortOrder',	0,	NULL,	NULL,	NULL,	NULL,	5,	N'Stt',	NULL,	2,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field TargetTypeID
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'TargetTypeID')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TargetTypeID',	0,	NULL,	NULL,	NULL,	NULL,	2,	N'Loại chỉ tiêu',	N'Target Type',	3,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field TargetName
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'TargetName')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TargetName',	1,	NULL,	NULL,	NULL,	NULL,	2,	N'Chỉ tiêu điều chỉnh',	N'Target Name',	4,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field TargetID
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'TargetID')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TargetID',	1,	NULL,	NULL,	NULL,	NULL,	2,	N'Mã chỉ tiêu',	N'Target ID',	5,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field TargetReturn
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'TargetReturn')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TargetReturn',	1,	NULL,	NULL,	NULL,	NULL,	8,	N'Số đã kê khai',	N'Target Return',	6,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field TargetAmended
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'TargetAmended')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TargetAmended',	1,	NULL,	NULL,	NULL,	NULL,	8,	N'Số điều chỉnh',	N'Target Amended',	7,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END

--Field TargetDifference
if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'TargetDifference')
BEGIN
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TargetDifference',	1,	NULL,	NULL,	NULL,	NULL,	8,	N'Chênh lênh giữa số điều chỉnh và số đã kê khai',	N'Target Difference',	8,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	0,	0,	0,	1,	NULL,	NULL,	NULL,	0,	NULL)
END
	
END

