USE [CDT]

DECLARE @sysTableID AS INT

-- DT31
SELECT @sysTableID = sysTableID FROM sysTable
WHERE TableName = 'DT31'

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TyleCK')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TyleCK', 1, NULL, NULL, NULL, NULL, 8, N'Tỷ lệ chiết khấu', N'Discount rate', 13, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_dt31_tyleck', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TienCKNT')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TienCKNT', 1, NULL, NULL, NULL, NULL, 8, N'Tiền chiết khấu nguyên tệ', N'Original discount amount', 14, N'@PsNT*@TyleCK/100', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_dt31_tiencknt', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'TienCK')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TienCK', 1, NULL, NULL, NULL, NULL, 8, N'Tiền chiết khấu', N'Discount amount', 15, N'@Ps*@TyleCK/100', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'df_dt31_tienck', N'### ### ### ##0', 0, NULL)

UPDATE [sysField] SET [TabIndex] = 1 WHERE [sysTableID] = @sysTableID AND FieldName = 'DT31ID'
UPDATE [sysField] SET [TabIndex] = 2 WHERE [sysTableID] = @sysTableID AND FieldName = 'MT31ID'
UPDATE [sysField] SET [TabIndex] = 3 WHERE [sysTableID] = @sysTableID AND FieldName = 'PsNT'
UPDATE [sysField] SET [TabIndex] = 4 WHERE [sysTableID] = @sysTableID AND FieldName = 'Ps'
UPDATE [sysField] SET [TabIndex] = 5 WHERE [sysTableID] = @sysTableID AND FieldName = 'TKNo'
UPDATE [sysField] SET [TabIndex] = 6 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaKHCt'
UPDATE [sysField] SET [TabIndex] = 7 WHERE [sysTableID] = @sysTableID AND FieldName = 'TenKHCt'
UPDATE [sysField] SET [TabIndex] = 8 WHERE [sysTableID] = @sysTableID AND FieldName = 'DienGiaiCt'
UPDATE [sysField] SET [TabIndex] = 9 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaBP'
UPDATE [sysField] SET [TabIndex] = 10 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaPhi'
UPDATE [sysField] SET [TabIndex] = 11 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaVV'
UPDATE [sysField] SET [TabIndex] = 12 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaCongTrinh'
UPDATE [sysField] SET [TabIndex] = 13 WHERE [sysTableID] = @sysTableID AND FieldName = 'TyleCK'
UPDATE [sysField] SET [TabIndex] = 14 WHERE [sysTableID] = @sysTableID AND FieldName = 'TienCKNT'
UPDATE [sysField] SET [TabIndex] = 15 WHERE [sysTableID] = @sysTableID AND FieldName = 'TienCK'

-- MT31
SELECT @sysTableID = sysTableID FROM sysTable
WHERE TableName = 'MT31'

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'MaLoaiHD')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaLoaiHD', 0, N'MaLoaiHD', N'DMLHD', NULL, NULL, 1, N'Loại hóa đơn', N'Invoice type', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT31_DMLHD', NULL, NULL, 0, NULL)

UPDATE [sysField] SET [AllowNull] = 0 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoSeri'

UPDATE [sysField] SET [Formula] = 'Sum(@TienCKNT)' WHERE [sysTableID] = @sysTableID AND FieldName = 'TCKNT'
UPDATE [sysField] SET [Formula] = 'Sum(@TienCK)' WHERE [sysTableID] = @sysTableID AND FieldName = 'TCK'

UPDATE [sysField] SET [TabIndex] = 1 WHERE [sysTableID] = @sysTableID AND FieldName = 'MT31ID'
UPDATE [sysField] SET [TabIndex] = 2 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaCT'
UPDATE [sysField] SET [TabIndex] = 3 WHERE [sysTableID] = @sysTableID AND FieldName = 'NgayCT'
UPDATE [sysField] SET [TabIndex] = 4 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoCT'
UPDATE [sysField] SET [TabIndex] = 5 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaLoaiHD'
UPDATE [sysField] SET [TabIndex] = 6 WHERE [sysTableID] = @sysTableID AND FieldName = 'NgayHd'
UPDATE [sysField] SET [TabIndex] = 7 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoHoaDon'
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
UPDATE [sysField] SET [TabIndex] = 18 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaThue'
UPDATE [sysField] SET [TabIndex] = 19 WHERE [sysTableID] = @sysTableID AND FieldName = 'TKThue'
UPDATE [sysField] SET [TabIndex] = 20 WHERE [sysTableID] = @sysTableID AND FieldName = 'TtienHNT'
UPDATE [sysField] SET [TabIndex] = 31 WHERE [sysTableID] = @sysTableID AND FieldName = 'TtienH'
UPDATE [sysField] SET [TabIndex] = 22 WHERE [sysTableID] = @sysTableID AND FieldName = 'TthueNT'
UPDATE [sysField] SET [TabIndex] = 23 WHERE [sysTableID] = @sysTableID AND FieldName = 'Tthue'
UPDATE [sysField] SET [TabIndex] = 24 WHERE [sysTableID] = @sysTableID AND FieldName = 'TtienNT'
UPDATE [sysField] SET [TabIndex] = 25 WHERE [sysTableID] = @sysTableID AND FieldName = 'Ttien'
UPDATE [sysField] SET [TabIndex] = 26 WHERE [sysTableID] = @sysTableID AND FieldName = 'HanTT'
UPDATE [sysField] SET [TabIndex] = 27 WHERE [sysTableID] = @sysTableID AND FieldName = 'DaTTNT'
UPDATE [sysField] SET [TabIndex] = 28 WHERE [sysTableID] = @sysTableID AND FieldName = 'DaTT'