USE [CDT]

DECLARE @sysTableID AS INT

SELECT @sysTableID = sysTableID FROM sysTable
WHERE TableName = 'VATOut'

IF NOT EXISTS (SELECT TOP 1 1 FROM [sysField] WHERE [sysTableID] = @sysTableID AND FieldName = 'MaLoaiHD')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaLoaiHD', 0, N'MaLoaiHD', N'DMLHD', NULL, NULL, 1, N'Loại hóa đơn', N'Invoice type', 27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_VATOut_DMLHD', NULL, NULL, 0, NULL)

UPDATE [sysField] SET [TabIndex] = 1 WHERE [sysTableID] = @sysTableID AND FieldName = 'VatOutID'
UPDATE [sysField] SET [TabIndex] = 2 WHERE [sysTableID] = @sysTableID AND FieldName = 'NgayHd'
UPDATE [sysField] SET [TabIndex] = 3 WHERE [sysTableID] = @sysTableID AND FieldName = 'Sohoadon'
UPDATE [sysField] SET [TabIndex] = 4 WHERE [sysTableID] = @sysTableID AND FieldName = 'SoSerie'
UPDATE [sysField] SET [TabIndex] = 5 WHERE [sysTableID] = @sysTableID AND FieldName = 'NgayCt'
UPDATE [sysField] SET [TabIndex] = 6 WHERE [sysTableID] = @sysTableID AND FieldName = 'TenKH'
UPDATE [sysField] SET [TabIndex] = 7 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaKH'
UPDATE [sysField] SET [TabIndex] = 8 WHERE [sysTableID] = @sysTableID AND FieldName = 'DiaChi'
UPDATE [sysField] SET [TabIndex] = 9 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaVT'
UPDATE [sysField] SET [TabIndex] = 10 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaLoaiHD'
UPDATE [sysField] SET [TabIndex] = 11 WHERE [sysTableID] = @sysTableID AND FieldName = 'DienGiai'
UPDATE [sysField] SET [TabIndex] = 12 WHERE [sysTableID] = @sysTableID AND FieldName = 'TTien'
UPDATE [sysField] SET [TabIndex] = 13 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaThue'
UPDATE [sysField] SET [TabIndex] = 14 WHERE [sysTableID] = @sysTableID AND FieldName = 'ThueSuat'
UPDATE [sysField] SET [TabIndex] = 15 WHERE [sysTableID] = @sysTableID AND FieldName = 'Thue'
UPDATE [sysField] SET [TabIndex] = 16 WHERE [sysTableID] = @sysTableID AND FieldName = 'TKThue'
UPDATE [sysField] SET [TabIndex] = 17 WHERE [sysTableID] = @sysTableID AND FieldName = 'TKDu'
UPDATE [sysField] SET [TabIndex] = 18 WHERE [sysTableID] = @sysTableID AND FieldName = 'GhiChu'
UPDATE [sysField] SET [TabIndex] = 19 WHERE [sysTableID] = @sysTableID AND FieldName = 'Nhomdk'
UPDATE [sysField] SET [TabIndex] = 20 WHERE [sysTableID] = @sysTableID AND FieldName = 'MTID'
UPDATE [sysField] SET [TabIndex] = 21 WHERE [sysTableID] = @sysTableID AND FieldName = 'MTIDDT'
UPDATE [sysField] SET [TabIndex] = 22 WHERE [sysTableID] = @sysTableID AND FieldName = 'MaCT'
UPDATE [sysField] SET [TabIndex] = 23 WHERE [sysTableID] = @sysTableID AND FieldName = 'ThueNT'
UPDATE [sysField] SET [TabIndex] = 24 WHERE [sysTableID] = @sysTableID AND FieldName = 'TTienNT'
