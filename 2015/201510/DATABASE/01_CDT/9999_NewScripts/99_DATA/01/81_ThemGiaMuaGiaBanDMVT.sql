-- Thêm field giá mua, giá bán trong DMVT và view wTonkhoTucthoi
USE [CDT]

declare @sysTableID int,
		@formatDonGia nvarchar(128)

-- DMVT
select @sysTableID = sysTableID from sysTable
where TableName = 'DMVT' and sysPackageID = 8

set @formatDonGia = dbo.GetFormatString('DonGia')

if not exists (select top 1 1 from [sysField] where [sysTableID] = @sysTableID and [FieldName] = N'GiaMua')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'GiaMua', 1, NULL, NULL, NULL, NULL, 8, N'Giá mua', N'Unit price', 15, NULL, NULL, NULL, NULL, NULL, N'Giá mua mặc định', N'Default unit price', 1, 0, 0, 0, 0, NULL, NULL, @formatDonGia, 0, NULL)

if not exists (select top 1 1 from [sysField] where [sysTableID] = @sysTableID and [FieldName] = N'GiaBan')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'GiaBan', 1, NULL, NULL, NULL, NULL, 8, N'Giá bán', N'Selling price', 16, NULL, NULL, NULL, NULL, NULL, N'Giá bán mặc định', N'Default selling price', 1, 0, 0, 0, 0, NULL, NULL, @formatDonGia, 0, NULL)

-- wTonkhoTucthoi
select @sysTableID = sysTableID from sysTable
where TableName = 'wTonkhoTucthoi' and sysPackageID = 8

if not exists (select top 1 1 from [sysField] where [sysTableID] = @sysTableID and [FieldName] = N'GiaMua')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'GiaMua', 1, NULL, NULL, NULL, NULL, 8, N'Giá mua', N'Unit price', 17, NULL, NULL, NULL, NULL, NULL, N'Giá mua mặc định', N'Default unit price', 1, 0, 0, 0, 1, NULL, NULL, @formatDonGia, 0, NULL)

if not exists (select top 1 1 from [sysField] where [sysTableID] = @sysTableID and [FieldName] = N'GiaBan')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'GiaBan', 1, NULL, NULL, NULL, NULL, 8, N'Giá bán', N'Selling price', 18, NULL, NULL, NULL, NULL, NULL, N'Giá bán mặc định', N'Default selling price', 1, 0, 0, 0, 1, NULL, NULL, @formatDonGia, 0, NULL)

-- Set mặc định giá mua, giá bán khi chọn vật tư
-- DT22
select @sysTableID = sysTableID from sysTable
where TableName = 'DT22' and sysPackageID = 8

Update [sysField] set FormulaDetail = N'MaVT.GiaMua'
where [sysTableID] = @sysTableID and [FieldName] = N'Gia' and FormulaDetail is null

-- DT33
select @sysTableID = sysTableID from sysTable
where TableName = 'DT33' and sysPackageID = 8

Update [sysField] set FormulaDetail = N'MaVT.GiaMua'
where [sysTableID] = @sysTableID and [FieldName] = N'Gia' and FormulaDetail is null

-- DT23
select @sysTableID = sysTableID from sysTable
where TableName = 'DT23' and sysPackageID = 8

Update [sysField] set FormulaDetail = N'MaVT.GiaMua'
where [sysTableID] = @sysTableID and [FieldName] = N'Gia' and FormulaDetail is null

-- DT32
select @sysTableID = sysTableID from sysTable
where TableName = 'DT32' and sysPackageID = 8

Update [sysField] set FormulaDetail = N'MaVT.GiaBan'
where [sysTableID] = @sysTableID and [FieldName] = N'Gia' and FormulaDetail is null