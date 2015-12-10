USE [CDT]

DECLARE @sysTableID AS INT

-- DT23
SELECT @sysTableID = sysTableID FROM sysTable
WHERE TableName = 'DT23'

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TyleCK')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TyleCK', 1, NULL, NULL, NULL, NULL, 8, N'Tỷ lệ chiết khấu', N'Discount rate', 28, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_dt23_tyleck', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TienCKNT')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TienCKNT', 1, NULL, NULL, NULL, NULL, 8, N'Tiền chiết khấu nguyên tệ', N'Original discount amount', 29, N'@PsNT*@TyleCK/100', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_dt23_tiencknt', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TienCK')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TienCK', 1, NULL, NULL, NULL, NULL, 8, N'Tiền chiết khấu', N'Discount amount', 30, N'@Ps*@TyleCK/100', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_dt23_tienck', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TienNKNT')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TienNKNT', 1, NULL, NULL, NULL, NULL, 8, N'Giá nhập kho nguyên tệ', N'Orginal price warehousing', 31, N'@PsNT+@CtThueNkNT+@CPCtNT-@TienCKNT', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_dt23_tiennktn', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TienNK')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TienNK', 1, NULL, NULL, NULL, NULL, 8, N'Giá nhập kho', N'Price warehousing', 32, N'@Ps+@CtThueNk+@CPCt-@TienCK', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_dt23_tiennk', N'### ### ### ##0', 0, NULL)

UPDATE [sysField] SET [TabIndex] = 1 WHERE [sysTableID] = @sysTableID AND FieldName = 'DT23ID'
UPDATE [sysField] SET [TabIndex] = 2 WHERE [sysTableID] = @sysTableID AND FieldName = 'MT23ID'
UPDATE [sysField] SET [TabIndex] = 3 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaVT'
UPDATE [sysField] SET [TabIndex] = 4 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaDVT'
UPDATE [sysField] SET [TabIndex] = 5 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaKho'
UPDATE [sysField] SET [TabIndex] = 6 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoLuong'
UPDATE [sysField] SET [TabIndex] = 7 WHERE [sysTableID] = @sysTableID AND FieldName = 'GiaNT'
UPDATE [sysField] SET [TabIndex] = 8 WHERE [sysTableID] = @sysTableID AND FieldName = 'Gia'
UPDATE [sysField] SET [TabIndex] = 9 WHERE [sysTableID] = @sysTableID AND FieldName = 'PsNT'
UPDATE [sysField] SET [TabIndex] = 10 WHERE [sysTableID] = @sysTableID AND FieldName = 'Ps'
UPDATE [sysField] SET [TabIndex] = 11 WHERE [sysTableID] = @sysTableID AND FieldName = 'TKNo'
UPDATE [sysField] SET [TabIndex] = 12 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaThueNkCt'
UPDATE [sysField] SET [TabIndex] = 13 WHERE [sysTableID] = @sysTableID AND FieldName = 'ThueSuatNk'
UPDATE [sysField] SET [TabIndex] = 14 WHERE [sysTableID] = @sysTableID AND FieldName = 'CtThueNkNT'
UPDATE [sysField] SET [TabIndex] = 15 WHERE [sysTableID] = @sysTableID AND FieldName = 'CtThueNk'
UPDATE [sysField] SET [TabIndex] = 16 WHERE [sysTableID] = @sysTableID AND FieldName = 'CPCtNT'
UPDATE [sysField] SET [TabIndex] = 17 WHERE [sysTableID] = @sysTableID AND FieldName = 'CPCt'
UPDATE [sysField] SET [TabIndex] = 18 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaBP'
UPDATE [sysField] SET [TabIndex] = 19 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaPhi'
UPDATE [sysField] SET [TabIndex] = 20 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaVV'
UPDATE [sysField] SET [TabIndex] = 21 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaCongTrinh'
UPDATE [sysField] SET [TabIndex] = 22 WHERE [sysTableID] = @sysTableID AND FieldName = 'GhiChu'
UPDATE [sysField] SET [TabIndex] = 23 WHERE [sysTableID] = @sysTableID AND FieldName = 'TyleCK'
UPDATE [sysField] SET [TabIndex] = 24 WHERE [sysTableID] = @sysTableID AND FieldName = 'TienCKNT'
UPDATE [sysField] SET [TabIndex] = 25 WHERE [sysTableID] = @sysTableID AND FieldName = 'TienCK'
UPDATE [sysField] SET [TabIndex] = 26 WHERE [sysTableID] = @sysTableID AND FieldName = 'TienNKNT'
UPDATE [sysField] SET [TabIndex] = 27 WHERE [sysTableID] = @sysTableID AND FieldName = 'TienNK'

-- MT23
SELECT @sysTableID = sysTableID FROM sysTable
WHERE TableName = 'MT23'

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'MaLoaiHD')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaLoaiHD', 0, N'MaLoaiHD', N'DMLHD', NULL, NULL, 1, N'Loại hóa đơn', N'Invoice type', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT23_DMLHD', NULL, NULL, 0, NULL)

UPDATE [sysField] SET [TabIndex] = 3 WHERE [sysTableID] = @sysTableID AND [FieldName] = 'NgayHd'
UPDATE [sysField] SET [TabIndex] = 4 WHERE [sysTableID] = @sysTableID AND [FieldName] = 'SoHoaDon'
UPDATE [sysField] SET [TabIndex] = 4 WHERE [sysTableID] = @sysTableID AND [FieldName] = 'MaCT'
UPDATE [sysField] SET [TabIndex] = 5 WHERE [sysTableID] = @sysTableID AND [FieldName] = 'SoSeri'

UPDATE [sysField] SET [AllowNull] = 0 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoSeri'

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TotalCKNT')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TotalCKNT', 1, NULL, NULL, NULL, NULL, 8, N'Tổng tiền chiết khấu nguyên tệ', N'Total original discount', 29, 'Sum(@TienCKNT)', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_mt23_totalcknt', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TotalCK')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TotalCK', 1, NULL, NULL, NULL, NULL, 8, N'Tổng tiền chiết khấu', N'Total discount amount', 30, 'Sum(@TienCK)', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_mt23_totalck', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TotalGNKNT')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TotalGNKNT', 1, NULL, NULL, NULL, NULL, 8, N'Tổng tiền nhập kho nguyên tệ', N'Total original warehousing', 31, 'Sum(@TienNKNT)', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_mt23_totalgnknt', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TotalGNK')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TotalGNK', 1, NULL, NULL, NULL, NULL, 8, N'Tổng tiền nhập kho', N'Total warehousing amount', 32, 'Sum(@TienNK)', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_mt23_totalgnk', N'### ### ### ##0', 0, NULL)

UPDATE [sysField] SET [TabIndex] = 1 WHERE [sysTableID] = @sysTableID AND FieldName = 'MT23ID'
UPDATE [sysField] SET [TabIndex] = 2 WHERE [sysTableID] = @sysTableID AND FieldName = 'NgayCT'
UPDATE [sysField] SET [TabIndex] = 3 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoCT'
UPDATE [sysField] SET [TabIndex] = 4 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaLoaiHD'
UPDATE [sysField] SET [TabIndex] = 5 WHERE [sysTableID] = @sysTableID AND FieldName = 'NgayHd'
UPDATE [sysField] SET [TabIndex] = 6 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoHoaDon'
UPDATE [sysField] SET [TabIndex] = 7 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaCT'
UPDATE [sysField] SET [TabIndex] = 8 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoSeri'
UPDATE [sysField] SET [TabIndex] = 9 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaKH'
UPDATE [sysField] SET [TabIndex] = 10 WHERE [sysTableID] = @sysTableID AND FieldName = 'TenKH'
UPDATE [sysField] SET [TabIndex] = 11 WHERE [sysTableID] = @sysTableID AND FieldName = 'DiaChi'
UPDATE [sysField] SET [TabIndex] = 12 WHERE [sysTableID] = @sysTableID AND FieldName = 'OngBa'
UPDATE [sysField] SET [TabIndex] = 13 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaNV'
UPDATE [sysField] SET [TabIndex] = 14 WHERE [sysTableID] = @sysTableID AND FieldName = 'DienGiai'
UPDATE [sysField] SET [TabIndex] = 15 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaNT'
UPDATE [sysField] SET [TabIndex] = 16 WHERE [sysTableID] = @sysTableID AND FieldName = 'TyGia'
UPDATE [sysField] SET [TabIndex] = 17 WHERE [sysTableID] = @sysTableID AND FieldName = 'TKCo'
UPDATE [sysField] SET [TabIndex] = 18 WHERE [sysTableID] = @sysTableID AND FieldName = 'HanTT'
UPDATE [sysField] SET [TabIndex] = 19 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaThueNK'
UPDATE [sysField] SET [TabIndex] = 20 WHERE [sysTableID] = @sysTableID AND FieldName = 'TKThueNK'
UPDATE [sysField] SET [TabIndex] = 21 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaThue'
UPDATE [sysField] SET [TabIndex] = 22 WHERE [sysTableID] = @sysTableID AND FieldName = 'TKThue1'
UPDATE [sysField] SET [TabIndex] = 23 WHERE [sysTableID] = @sysTableID AND FieldName = 'TkThue'
UPDATE [sysField] SET [TabIndex] = 24 WHERE [sysTableID] = @sysTableID AND FieldName = 'TtienHNT'
UPDATE [sysField] SET [TabIndex] = 25 WHERE [sysTableID] = @sysTableID AND FieldName = 'TtienH'
UPDATE [sysField] SET [TabIndex] = 26 WHERE [sysTableID] = @sysTableID AND FieldName = 'ThueNKNT'
UPDATE [sysField] SET [TabIndex] = 27 WHERE [sysTableID] = @sysTableID AND FieldName = 'ThueNK'
UPDATE [sysField] SET [TabIndex] = 28 WHERE [sysTableID] = @sysTableID AND FieldName = 'Tthue'
UPDATE [sysField] SET [TabIndex] = 29 WHERE [sysTableID] = @sysTableID AND FieldName = 'TthueNT'
UPDATE [sysField] SET [TabIndex] = 30 WHERE [sysTableID] = @sysTableID AND FieldName = 'CPNT'
UPDATE [sysField] SET [TabIndex] = 31 WHERE [sysTableID] = @sysTableID AND FieldName = 'CP'
UPDATE [sysField] SET [TabIndex] = 32 WHERE [sysTableID] = @sysTableID AND FieldName = 'TtienNT'
UPDATE [sysField] SET [TabIndex] = 33 WHERE [sysTableID] = @sysTableID AND FieldName = 'Ttien'
UPDATE [sysField] SET [TabIndex] = 34 WHERE [sysTableID] = @sysTableID AND FieldName = 'DaTTNT'
UPDATE [sysField] SET [TabIndex] = 35 WHERE [sysTableID] = @sysTableID AND FieldName = 'DaTT'
UPDATE [sysField] SET [TabIndex] = 36 WHERE [sysTableID] = @sysTableID AND FieldName = 'TotalCKNT'
UPDATE [sysField] SET [TabIndex] = 37 WHERE [sysTableID] = @sysTableID AND FieldName = 'TotalCK'
UPDATE [sysField] SET [TabIndex] = 38 WHERE [sysTableID] = @sysTableID AND FieldName = 'TotalGNKNT'
UPDATE [sysField] SET [TabIndex] = 39 WHERE [sysTableID] = @sysTableID AND FieldName = 'TotalGNK'
