USE [CDT]

DECLARE 
@sysSiteID INT,
@sysPackageID INT,
@sysMenuID INT,
@sysTableMTID INT,
@sysTableDTID INT,
@sysTableBLTKID INT,
@sysTableVWID INT,
@blConfigID INT,
@blFieldID INT,
@mtFieldID INT,
@dtFieldID INT

set @sysPackageID = 8 

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- wKyDaLapBK
--
--------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysTable] WHERE [sysPackageID] = @sysPackageID AND [TableName] = 'wKyDaLapBK')
INSERT [dbo].[sysTable]([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType])
VALUES(N'wKyDaLapBK', N'View danh sách kỳ đã lập đầy đủ bảng kê', NULL, N'Ky',NULL, NULL, 1, N'Ky', NULL, 0, NULL, @sysPackageID, NULL, -1)

SELECT @sysTableVWID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'wKyDaLapBK'

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'Ky')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'Ky', 0, NULL, NULL, NULL, NULL, 1, N'Kỳ', N'Period', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'Nam')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'Nam', 0, NULL, NULL, NULL, NULL, 1, N'Năm', N'Year', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'ThueMVNT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'ThueMVNT', 1, NULL, NULL, NULL, NULL, 8, N'Thuế mua vào nguyên tệ', N'Original VAT In', 3, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'ThueMV')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'ThueMV', 1, NULL, NULL, NULL, NULL, 8, N'Thuế mua vào', N'VAT In', 4, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'ThueBRNT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'ThueBRNT', 1, NULL, NULL, NULL, NULL, 8, N'Thuế bán ra nguyên tệ', N'Original VAT Out', 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableVWID AND FieldName = 'ThueBR')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableVWID, N'ThueBR', 1, NULL, NULL, NULL, NULL, 8, N'Thuế bán ra', N'VAT Out', 6, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0', 0, NULL)

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- MT36
--
--------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysTable] WHERE [sysPackageID] = @sysPackageID AND [TableName] = 'MT36')
INSERT [dbo].[sysTable]([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType])
VALUES(N'MT36', N'Chứng từ khấu trừ, điều chỉnh và hoàn thuế', NULL, N'MT36ID', NULL, NULL, 0, N'Stt', NULL, 0, NULL, @sysPackageID, NULL, 1)

SELECT @sysTableMTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'MT36'

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'MT36ID')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'MT36ID', 0, NULL, NULL, NULL, NULL, 6, N'Khóa chính', N'Primary key', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'NgayCt')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'NgayCt', 0, NULL, NULL, NULL, NULL, 9, N'Ngày chứng từ', N'Voucher date', 2, NULL, NULL, NULL, NULL, NULL, N'Ngày cuối tháng của kỳ kế toán', NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'SoCt')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'SoCt', 0, NULL, NULL, NULL, NULL, 2, N'Số chứng từ', N'Voucher No', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 1, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'MaLCTThue')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'MaLCTThue', 0, N'MaLCTThue', N'DMLCTThue', N'TenLCTThue', NULL, 4, N'Loại chứng từ thuế', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT36_DMLCTThue11', NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'MaNT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'MaNT', 0, N'MaNT', N'DMNT', NULL, NULL, 1, N'Mã ngoại tệ', N'Currency ID', 5, NULL, NULL, NULL, NULL, N'VND', NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT36_DMNT7', N'DF_MT36_MaNT', NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'TyGia')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'TyGia', 1, NULL, NULL, NULL, NULL, 8, N'Tỷ giá', NULL, 6, NULL, N'MaNT.TyGia', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'### ### ### ##0.##', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'MaKH')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'MaKH', 1, N'MaKH', N'DMKH', NULL, NULL, 1, N'Mã đối tượng', N'Object ID', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT36_DMKH4', NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'TenKH')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'TenKH', 1, NULL, NULL, NULL, NULL, 2, N'Tên đối tượng', N'Object name', 8, NULL, N'MaKH.TenKH', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'DienGiai')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'DienGiai', 0, NULL, NULL, NULL, NULL, 2, N'Diễn giải', N'Description', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'KyKTT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'KyKTT', 0, N'Ky', N'wKyDaLapBK', N'Ky', NULL, 4, N'Kỳ khấu trừ', NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'TThueKyTruocNT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'TThueKyTruocNT', 1, NULL, NULL, NULL, NULL, 8, N'Tổng tiền thuế kỳ trước nguyên tệ', NULL, 11, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT36_TThueKyTruocNT', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'TThueKyTruoc')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'TThueKyTruoc', 1, NULL, NULL, NULL, NULL, 8, N'Tổng tiền thuế kỳ trước', NULL, 12, N'@TThueKyTruocNT*@TyGia', NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT36_TThueKyTruoc', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'TThueBKMVNT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'TThueBKMVNT', 1, NULL, NULL, NULL, NULL, 8, N'Tổng tiền thuế mua vào nguyên tệ', NULL, 13, NULL, N'KyKTT.ThueMVNT', NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT36_TThueBKMVNT', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'TThueBKMV')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'TThueBKMV', 1, NULL, NULL, NULL, NULL, 8, N'Tổng tiền thuế mua vào', NULL, 14, NULL, N'KyKTT.ThueMV', NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT36_TThueBKMV', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'TThueBKBRNT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'TThueBKBRNT', 1, NULL, NULL, NULL, NULL, 8, N'Tổng tiền thuế bán ra nguyên tệ', NULL, 15, NULL, N'KyKTT.ThueBRNT', NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT36_TThueBKBRNT', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'TThueBKBR')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'TThueBKBR', 1, NULL, NULL, NULL, NULL, 8, N'Tổng tiền thuế bán ra', NULL, 16, NULL, N'KyKTT.ThueBR', NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT36_TThueBKBR', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'TotalPsNT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'TotalPsNT', 1, NULL, NULL, NULL, NULL, 8, N'Tổng tiền nguyên tệ', N'Total original amount', 17, N'Sum(@PsNT)', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'DF_MT36_TotalPsNT', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'TotalPs')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'TotalPs', 0, NULL, NULL, NULL, NULL, 8, N'Tổng tiền', N'Total amount', 18, N'Sum(@Ps)', NULL, NULL, NULL, 0, NULL, NULL, 1, 1, 0, 0, 1, NULL, N'DF_MT36_TotalPs', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableMTID AND FieldName = 'MaCt')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableMTID, N'MaCt', 1, NULL, NULL, NULL, NULL, 2, N'Mã chứng từ', N'Voucher ID', 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- DT36
--
--------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysTable] WHERE [sysPackageID] = @sysPackageID AND [TableName] = 'DT36')
INSERT [dbo].[sysTable]([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType])
VALUES(N'DT36', N'Chi tiết chứng từ khấu trừ, điều chỉnh và hoàn thuế', N'Detail', N'DT36ID', N'MT36ID', N'MT36', 3, N'Stt', NULL, 0, N'KTT', @sysPackageID, NULL, 1)

SELECT @sysTableDTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'DT36'

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'DT36ID')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'DT36ID', 0, NULL, NULL, NULL, NULL, 6, N'Khóa chính', N'Primary key', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'MT36ID')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'MT36ID', 0, N'MT36ID', N'MT36', NULL, NULL, 7, N'Khóa ngoại', N'Foreign key', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, N'FK_DT36_MT362', NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'TK')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'TK', 0, N'TK', N'DMTK', NULL, N'TK not in (select TK = case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)', 1, N'Tài khoản nợ', N'Debit account', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DT36_DMTK3', NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'TKDU')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'TKDU', 0, N'TK', N'DMTK', NULL, N'TK not in (select TK = case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)', 1, N'Tài khoản có', N'Credit account', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DT36_DMTK4', NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'PsNT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'PsNT', 1, NULL, NULL, NULL, NULL, 8, N'Tiền nguyên tệ', N'Original amount', 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DT36_PsNT', N'### ### ### ##0.##', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'Ps')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'Ps', 0, NULL, NULL, NULL, NULL, 8, N'Tiền', N'Amount', 6, N'@PsNT*@TyGia', NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DT36_Ps', N'### ### ### ##0', 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'DienGiai')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'DienGiai', 0, NULL, NULL, NULL, NULL, 2, N'Diễn giải', N'Description', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'MaKH')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'MaKH', 1, N'MaKH', N'DMKH', NULL, NULL, 1, N'Mã đối tượng', N'Object ID', 8, NULL, N'MaKH', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DT36_DMKH4', NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'TenKH')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'TenKH', 1, NULL, NULL, NULL, NULL, 2, N'Tên đối tượng', N'Object name', 9, NULL, N'MaKH.TenKH', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'MaVV')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'MaVV', 1, N'MaVV', N'DMVuViec', NULL, NULL, 1, N'Mã vụ việc', NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, N'FK_DT36_DMVuViec10', NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'MaPhi')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'MaPhi', 1, N'MaPhi', N'DMPhi', NULL, NULL, 1, N'Mã phí', NULL, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, N'FK_DT36_DMPhi11', NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'MaBP')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'MaBP', 1, N'MaBP', N'DMBoPhan', NULL, NULL, 1, N'Mã bộ phận', NULL, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, N'FK_DT36_DMBoPhan12', NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'MaSP')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'MaSP', 1, N'MaVT', N'DMVT', NULL, NULL, 1, N'Mã sản phẩm', NULL, 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, N'FK_DT36_DMVT13', NULL, NULL, 0, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM sysField WHERE sysTableID = @sysTableDTID AND FieldName = 'MaCongTrinh')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableDTID, N'MaCongTrinh', 1, N'MaCongTrinh', N'dmCongtrinh', NULL, NULL, 1, N'Mã công trình', NULL, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, N'FK_DT36_dmCongtrinh14', NULL, NULL, 0, NULL)

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- Menu
--
--------------------------------------------------------------------------------------------------------------------------------------------
-- PRO
SELECT @sysSiteID = [sysSiteID], @sysPackageID = [sysPackageID] FROM [sysSite] WHERE [SiteCode] = N'PRO'
SELECT @sysMenuID = [sysMenuID] FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND MenuName = N'Thuế GTGT'

if isnull(@sysSiteID, '') <> ''
BEGIN

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuID AND MenuName = N'Khấu trừ, điều chỉnh, hoàn thuế')
INSERT [dbo].[sysMenu]([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image])
VALUES(N'Khấu trừ, điều chỉnh, hoàn thuế', N'Tax deduction, adjustment, refund', @sysSiteID, 3, @sysTableDTID, NULL, 1, NULL, @sysMenuID, NULL, NULL, 4, NULL)

END
-- STD
SELECT @sysSiteID = [sysSiteID], @sysPackageID = [sysPackageID] FROM [sysSite] WHERE [SiteCode] = N'STD'
SELECT @sysMenuID = [sysMenuID] FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND MenuName = N'Thuế GTGT'

if isnull(@sysSiteID, '') <> ''
BEGIN

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuID AND MenuName = N'Khấu trừ, điều chỉnh, hoàn thuế')
INSERT [dbo].[sysMenu]([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image])
VALUES(N'Khấu trừ, điều chỉnh, hoàn thuế', N'Tax deduction, adjustment, refund', @sysSiteID, 3, @sysTableDTID, NULL, 1, NULL, @sysMenuID, NULL, NULL, 4, NULL)

END
--------------------------------------------------------------------------------------------------------------------------------------------
--
-- Config
--
--------------------------------------------------------------------------------------------------------------------------------------------
SELECT @sysTableBLTKID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'BLTK'

-- TKK1
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'KTT1')
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, @sysTableDTID, N'KTT1', N'MTID', 1, NULL, N'MTIDDT')

SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'KTT1'

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaCt'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTID'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MT36ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'SoCt'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'NgayCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'NgayCt'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DienGiai'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'DienGiai'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKH'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaKH'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TenKH'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TenKH'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TK'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TK'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TKDU'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsNo'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Ps'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsCo'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'NhomDk'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaPhi'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaPhi'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaVV'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaVV'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsNoNT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'PsNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsCoNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'OngBa'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaBP'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaBP'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TyGia'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TyGia'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTIDDT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'DT36ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaSP'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaSP'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCongTrinh'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaCongTrinh'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)


-- TKK2
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'KTT2')
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, @sysTableDTID, N'KTT2', N'MTID', 1, NULL, N'MTIDDT')

SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'KTT2'

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaCt'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTID'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MT36ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'SoCt'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'NgayCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'NgayCt'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DienGiai'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'DienGiai'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKH'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaKH'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TenKH'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TenKH'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TK'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TKDU'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TK'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsNo'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsCo'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Ps'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'NhomDk'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaPhi'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaPhi'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaVV'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaVV'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsNoNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsCoNT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'PsNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'OngBa'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaBP'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaBP'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TyGia'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TyGia'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTIDDT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'DT36ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaSP'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaSP'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCongTrinh'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaCongTrinh'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)
