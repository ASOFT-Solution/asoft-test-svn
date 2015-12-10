use [CDT]
Declare @sysTableID int,
		@sysTableBLID int,
		@blConfigID int,
		@blFieldID int,
		@mtFieldID int

-- 1) Thêm field table OBVT
select @sysTableID = sysTableID from sysTable where TableName = 'OBVT'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'SoCTOBVT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoCTOBVT', 0, NULL, NULL, NULL, NULL, 2, N'Số chứng từ', N'Voucher number', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, N'OB1', 1, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 2) Đổi tên menu
Update sysMenu set MenuName = N'Số dư đầu kỳ bình quân và đích danh', MenuName2 = N'Average material balance and by named balance'
where MenuName = N'Số dư đầu kỳ bình quân' and sysTableID = @sysTableID and MenuOrder = 3 and UIType = 3

-- 3) Thêm field table BLVT
select @sysTableID = sysTableID from sysTable where TableName = 'BLVT'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'SoCTDT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoCTDT', 1, NULL, NULL, NULL, NULL, 2, N'Số chứng từ đối trừ', N'Voucher number', 34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'MTIDDoiTru')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MTIDDoiTru', 1, NULL, NULL, NULL, NULL, 6, N'Mã đối trừ', N'Mã đối trừ E', 37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- 4) Thêm field table DT45
select @sysTableID = sysTableID from sysTable where TableName = 'DT45'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'SoCTDT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoCTDT', 1, NULL, NULL, NULL, NULL, 2, N'Số chứng từ đối trừ', N'Voucher number', 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'MTIDDoiTru')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MTIDDoiTru', 1, NULL, NULL, NULL, NULL, 6, N'Mã đối trừ', N'Mã đối trừ E', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- 4) Thêm field table DT24
select @sysTableID = sysTableID from sysTable where TableName = 'DT24'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'SoCTDT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoCTDT', 1, NULL, NULL, NULL, NULL, 2, N'Số chứng từ đối trừ', N'Voucher number', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'MTIDDoiTru')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MTIDDoiTru', 1, NULL, NULL, NULL, NULL, 6, N'Mã đối trừ', N'Mã đối trừ E', 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- 5) Thêm field table DT32
select @sysTableID = sysTableID from sysTable where TableName = 'DT32'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'SoCTDT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoCTDT', 1, NULL, NULL, NULL, NULL, 2, N'Số chứng từ đối trừ', N'Voucher number', 31, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'MTIDDoiTru')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MTIDDoiTru', 1, NULL, NULL, NULL, NULL, 6, N'Mã đối trừ', N'Mã đối trừ E', 34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- 6) Thêm field table DT44
select @sysTableID = sysTableID from sysTable where TableName = 'DT44'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'SoCTDT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoCTDT', 1, NULL, NULL, NULL, NULL, 2, N'Số chứng từ đối trừ', N'Voucher number', 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'MTIDDoiTru')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MTIDDoiTru', 1, NULL, NULL, NULL, NULL, 6, N'Mã đối trừ', N'Mã đối trừ E', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- 7) Thêm field table DT43
select @sysTableID = sysTableID from sysTable where TableName = 'DT43'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'SoCTDT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoCTDT', 1, NULL, NULL, NULL, NULL, 2, N'Số chứng từ đối trừ', N'Voucher number', 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'MTIDDoiTru')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MTIDDoiTru', 1, NULL, NULL, NULL, NULL, 6, N'Mã đối trừ', N'Mã đối trừ E', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- 8) Thêm field table DT22
select @sysTableID = sysTableID from sysTable where TableName = 'DT22'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 9) Thêm field table DT23
select @sysTableID = sysTableID from sysTable where TableName = 'DT23'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 10) Thêm field table DT41
select @sysTableID = sysTableID from sysTable where TableName = 'DT41'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 11) Thêm field table DT42
select @sysTableID = sysTableID from sysTable where TableName = 'DT42'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 12) Thêm field table DT33
select @sysTableID = sysTableID from sysTable where TableName = 'DT33'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'LotNumBer')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'ExpireDate')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expiration Date', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 13) Update sysDataConfigDt
-- Xuất kho
SELECT @sysTableBLID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'BLVT'

-- PXC
select @sysTableID = sysTableID from sysTable where TableName = 'DT45'
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PXC' and sysTableID = @sysTableBLID

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'SoCTDT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'SoCTDT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'MTIDDoiTru'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'MTIDDoiTru'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

-- PXT1
select @sysTableID = sysTableID from sysTable where TableName = 'DT24'
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PXT1' and sysTableID = @sysTableBLID

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'SoCTDT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'SoCTDT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'MTIDDoiTru'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'MTIDDoiTru'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

-- HDB1
select @sysTableID = sysTableID from sysTable where TableName = 'DT32'
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'HDB1' and sysTableID = @sysTableBLID

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'SoCTDT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'SoCTDT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'MTIDDoiTru'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'MTIDDoiTru'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

-- PDC1
select @sysTableID = sysTableID from sysTable where TableName = 'DT44'
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PDC1' and sysTableID = @sysTableBLID

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'SoCTDT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'SoCTDT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'MTIDDoiTru'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'MTIDDoiTru'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

-- PDC2
select @sysTableID = sysTableID from sysTable where TableName = 'DT44'
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PDC2' and sysTableID = @sysTableBLID

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

-- PXK1
select @sysTableID = sysTableID from sysTable where TableName = 'DT43'
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PXK1' and sysTableID = @sysTableBLID

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'SoCTDT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'SoCTDT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'MTIDDoiTru'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'MTIDDoiTru'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

-- Nhập kho
-- PNM1
select @sysTableID = sysTableID from sysTable where TableName = 'DT22'
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PNM1' and sysTableID = @sysTableBLID

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

-- PNK1
select @sysTableID = sysTableID from sysTable where TableName = 'DT23'
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PNK1' and sysTableID = @sysTableBLID

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

-- NSX1
select @sysTableID = sysTableID from sysTable where TableName = 'DT41'
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'NSX1' and sysTableID = @sysTableBLID

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

-- PNH1
select @sysTableID = sysTableID from sysTable where TableName = 'DT42'
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PNH1' and sysTableID = @sysTableBLID

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

-- HTL1
select @sysTableID = sysTableID from sysTable where TableName = 'DT33'
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'HTL1' and sysTableID = @sysTableBLID

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @mtFieldID, NULL)

-- Dictionary
if not exists (select 1 from Dictionary where Content = N'Vật tư {0} đã được sử dụng. Bạn không được phép chỉnh sửa') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Vật tư {0} đã được sử dụng. Bạn không được phép chỉnh sửa', N'Material {0} has been used. You do not have permission to edit');	

if not exists (select 1 from Dictionary where Content = N'Chọn chứng từ đầu vào cho vật tư') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Chọn chứng từ đầu vào cho vật tư', N'Select the input voucher for this material');	

if not exists (select 1 from Dictionary where Content = N'Không được xuất quá số lượng tồn') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Không được xuất quá số lượng tồn', N'Can not deliver more than the inventory quantity');	

