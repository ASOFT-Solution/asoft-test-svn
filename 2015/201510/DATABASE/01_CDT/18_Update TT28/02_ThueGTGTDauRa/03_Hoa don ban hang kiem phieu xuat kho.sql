USE [CDT]

DECLARE @sysTableID AS INT

-- MT32
SELECT @sysTableID = sysTableID FROM sysTable
WHERE TableName = 'MT32'

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'MaLoaiHD')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaLoaiHD', 0, N'MaLoaiHD', N'DMLHD', NULL, NULL, 1, N'Loại hóa đơn', N'Invoice type', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT32_DMLHD', NULL, NULL, 0, NULL)

UPDATE [sysField] SET [AllowNull] = 0 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoSeri'

UPDATE [sysField] SET [TabIndex] = 1 WHERE [sysTableID] = @sysTableID AND FieldName = 'MT32ID'
UPDATE [sysField] SET [TabIndex] = 2 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaCT'
UPDATE [sysField] SET [TabIndex] = 3 WHERE [sysTableID] = @sysTableID AND FieldName = 'NgayCT'
UPDATE [sysField] SET [TabIndex] = 4 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoCT'
UPDATE [sysField] SET [TabIndex] = 5 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaLoaiHD'
UPDATE [sysField] SET [TabIndex] = 6 WHERE [sysTableID] = @sysTableID AND FieldName = 'NgayHD'
UPDATE [sysField] SET [TabIndex] = 7 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoHoaDon'
UPDATE [sysField] SET [TabIndex] = 8 WHERE [sysTableID] = @sysTableID AND FieldName = 'Soseri'
UPDATE [sysField] SET [TabIndex] = 9 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaKH'
UPDATE [sysField] SET [TabIndex] = 10 WHERE [sysTableID] = @sysTableID AND FieldName = 'TenKH'
UPDATE [sysField] SET [TabIndex] = 11 WHERE [sysTableID] = @sysTableID AND FieldName = 'DiaChi'
UPDATE [sysField] SET [TabIndex] = 12 WHERE [sysTableID] = @sysTableID AND FieldName = 'OngBa'
UPDATE [sysField] SET [TabIndex] = 13 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaNV'
UPDATE [sysField] SET [TabIndex] = 14 WHERE [sysTableID] = @sysTableID AND FieldName = 'DienGiai'
UPDATE [sysField] SET [TabIndex] = 15 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaNT'
UPDATE [sysField] SET [TabIndex] = 16 WHERE [sysTableID] = @sysTableID AND FieldName = 'TyGia'
UPDATE [sysField] SET [TabIndex] = 17 WHERE [sysTableID] = @sysTableID AND FieldName = 'TKNo'
UPDATE [sysField] SET [TabIndex] = 18 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaThue'
UPDATE [sysField] SET [TabIndex] = 19 WHERE [sysTableID] = @sysTableID AND FieldName = 'TKThue'
UPDATE [sysField] SET [TabIndex] = 20 WHERE [sysTableID] = @sysTableID AND FieldName = 'TtienHNT'
UPDATE [sysField] SET [TabIndex] = 21 WHERE [sysTableID] = @sysTableID AND FieldName = 'TtienH'
UPDATE [sysField] SET [TabIndex] = 22 WHERE [sysTableID] = @sysTableID AND FieldName = 'TKCK'
UPDATE [sysField] SET [TabIndex] = 23 WHERE [sysTableID] = @sysTableID AND FieldName = 'TCKNT'
UPDATE [sysField] SET [TabIndex] = 24 WHERE [sysTableID] = @sysTableID AND FieldName = 'TCK'
UPDATE [sysField] SET [TabIndex] = 25 WHERE [sysTableID] = @sysTableID AND FieldName = 'TthueNT'
UPDATE [sysField] SET [TabIndex] = 26 WHERE [sysTableID] = @sysTableID AND FieldName = 'Tthue'
UPDATE [sysField] SET [TabIndex] = 27 WHERE [sysTableID] = @sysTableID AND FieldName = 'TtienNT'
UPDATE [sysField] SET [TabIndex] = 28 WHERE [sysTableID] = @sysTableID AND FieldName = 'Ttien'
UPDATE [sysField] SET [TabIndex] = 29 WHERE [sysTableID] = @sysTableID AND FieldName = 'HanTT'
UPDATE [sysField] SET [TabIndex] = 30 WHERE [sysTableID] = @sysTableID AND FieldName = 'DaTtNT'
UPDATE [sysField] SET [TabIndex] = 32 WHERE [sysTableID] = @sysTableID AND FieldName = 'DaTt'
UPDATE [sysField] SET [TabIndex] = 32 WHERE [sysTableID] = @sysTableID AND FieldName = 'Saleman'