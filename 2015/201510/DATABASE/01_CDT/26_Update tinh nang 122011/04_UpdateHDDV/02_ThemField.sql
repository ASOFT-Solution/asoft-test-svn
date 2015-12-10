use [CDT]

declare @sysTable as int
declare @formatDonGia as nvarchar(128)
declare @formatDonGiaNT as nvarchar(128)
declare @formatSoLuong as nvarchar(128)
select @sysTable = sysTableID from sysTable where TableName = 'DT31' and sysPackageID = 8

set @formatDonGia = dbo.GetFormatString('DonGia')
set @formatDonGiaNT = dbo.GetFormatString('DonGiaNT')
set @formatSoLuong = dbo.GetFormatString('SoLuong')

if not exists (select top 1 1 from sysField where FieldName = 'MaDVT' and sysTableID = @sysTable)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTable, N'MaDVT', 1, N'MaDVT', N'DMDVT', NULL, NULL, 1, N'Đơn vị tính', N'Unit', 3, NULL, N'MaVT.MaDVT', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'fk_dt31_dmdvt', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'SoLuong' and sysTableID = @sysTable)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTable, N'SoLuong', 1, NULL, NULL, NULL, NULL, 8, N'Số lượng', N'Quantity', 4, NULL, NULL, NULL, 0, N'1', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'df_dt31_SoLuong', @formatSoLuong, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'GiaNT' and sysTableID = @sysTable)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTable, N'GiaNT', 1, NULL, NULL, NULL, NULL, 8, N'Giá bán nguyên tệ', N'Original selling price', 5, NULL, NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'df_dt31_giant', @formatDonGiaNT, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'Gia' and sysTableID = @sysTable)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTable, N'Gia', 1, NULL, NULL, NULL, NULL, 8, N'Giá bán', N'Selling price', 6, N'@GiaNT*@TyGia', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'df_dt31_gia', @formatDonGia, 0, NULL)

Update sysField set [TabIndex] = 7, [Formula] = N'@GiaNT*@SoLuong'
where FieldName = 'PsNT' and sysTableID = @sysTable

Update sysField set [TabIndex] = 8, [Formula] = N'@Gia*@SoLuong'
where FieldName = 'Ps' and sysTableID = @sysTable

Update sysField set [TabIndex] = 9
where FieldName = 'ChiuThueTTDB' and sysTableID = @sysTable

Update sysField set [TabIndex] = 10
where FieldName = 'MaKHCt' and sysTableID = @sysTable

Update sysField set [TabIndex] = 11
where FieldName = 'TenKHCt' and sysTableID = @sysTable

Update sysField set [TabIndex] = 12
where FieldName = 'DienGiaiCt' and sysTableID = @sysTable

Update sysField set [TabIndex] = 13
where FieldName = 'MaBP' and sysTableID = @sysTable

Update sysField set [TabIndex] = 14
where FieldName = 'MaPhi' and sysTableID = @sysTable

Update sysField set [TabIndex] = 15
where FieldName = 'MaVV' and sysTableID = @sysTable

Update sysField set [TabIndex] = 16
where FieldName = 'MaCongTrinh' and sysTableID = @sysTable

Update sysField set [TabIndex] = 17
where FieldName = 'TyleCK' and sysTableID = @sysTable

Update sysField set [TabIndex] = 18
where FieldName = 'TienCKNT' and sysTableID = @sysTable

Update sysField set [TabIndex] = 19
where FieldName = 'TienCK' and sysTableID = @sysTable