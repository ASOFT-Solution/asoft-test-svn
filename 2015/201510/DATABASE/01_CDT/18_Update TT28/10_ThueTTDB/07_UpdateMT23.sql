USE [CDT]
declare @sysTableID as int
declare @sysFieldID as int
declare @MenuThueKhacID as int
declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int
declare @sysTableBLTKID as int
declare @sysTableMTID as int
declare @sysTableDTID as int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

-- MT23
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'

if not exists (select top 1 1 from sysField where FieldName = 'ToTalTienTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ToTalTienTTDB', 0, NULL, NULL, NULL, NULL, 8, N'Tổng tiền thuế TTDB', N'Total special consumption tax', 28, N'sum(@TienTTDB)', NULL, NULL, NULL, N'0', NULL, NULL, 1, 1, 0, 0, 1, NULL, N'DF_MT23_ToTalTienTTDB', N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ToTalTienTTDBNT' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ToTalTienTTDBNT', 0, NULL, NULL, NULL, NULL, 8, N'Tổng tiền thuế TTDB nguyên tệ', N'Original total special consumption tax', 29, N'sum(@TienTTDBNT)', NULL, NULL, NULL, N'0', NULL, NULL, 1, 1, 0, 0, 1, NULL, N'DF_MT23_ToTalTienTTDBNT', N'### ### ### ##0', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MaNhomTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaNhomTTDB', 1, N'MaNhomTTDB', N'DMThueTTDB', NULL, N'ThueSuatTTDB > 0', 1, N'Mã thuế nhóm TTDB', N'Special consumption tax group code', 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, N'FK_MT23_DMThueTTDB15', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'TkTTTDB' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'TkTTTDB', 1, N'TK', N'DMTK', NULL, N'TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)', 1, N'Tk thuế TTDB', N'Special consumption account', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'fk_MT23_TkTTTDB', NULL, N'&', 0, NULL)

-- Mua hàng nhập khẩu - Tab VAT
select @sysTableID = sysTableID from sysTable where TableName = 'VATIn'

-- Tiền thuế
select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'Thue'
Update sysField set [Formula] = N'@TTien*@ThueSuat/100'
where sysFieldID = @sysFieldID

-- Tiền thuế nguyên tệ
select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'ThueNT'
Update sysField set [Formula] = N'@TTienNT*@ThueSuat/100'
where sysFieldID = @sysFieldID

-- Tổng tiền
select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TTien'
Update sysField set [Formula] = N'@Ps - @TienCK + @CtThueNk + @TienTTDB'
where sysFieldID = @sysFieldID

-- Tổng tiền NT
select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TTienNT'
Update sysField set [Formula] = N'@PsNT - @TienCKNT + @CtThueNkNT + @TienTTDBNT'
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'SoLuong'
Update sysField set [Visible] = 0
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'DonGia'
Update sysField set [Visible] = 0
where sysFieldID = @sysFieldID

-- Mua hàng nhập khẩu - Tab detail
select @sysTableID = sysTableID from sysTable where TableName = 'DT23'

-- Giá nhập kho
select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TienNK'
Update sysField set [Formula] = N'@Ps - @TienCK + @CtThueNk + @TienTTDB + @CPCt'
where sysFieldID = @sysFieldID

-- Giá nhập kho
select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TienNKNT'
Update sysField set [Formula] = N'@PsNT - @TienCKNT + @CtThueNkNT + @TienTTDBNT + @CPCtNT'
where sysFieldID = @sysFieldID

-- MT23 Tổng tiền
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'Ttien'
Update sysField set [Formula] = N'@TtienH - @TotalCK + @CP'
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TtienNT'
Update sysField set [Formula] = N'@TtienHNT - @TotalCKNT + @CPNT'
where sysFieldID = @sysFieldID

-- MT23 Reset Tab index
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TotalCKNT'
Update sysField set [TabIndex] = 26
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TotalCK'
Update sysField set [TabIndex] = 27
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'ThueNKNT'
Update sysField set [TabIndex] = 28
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'ThueNK'
Update sysField set [TabIndex] = 29
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'ToTalTienTTDBNT'
Update sysField set [TabIndex] = 30
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'ToTalTienTTDB'
Update sysField set [TabIndex] = 31
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TthueNT'
Update sysField set [TabIndex] = 32, [LabelName] = N'Tổng tiền thuế VAT nguyên tệ'
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'Tthue'
Update sysField set [TabIndex] = 33, [LabelName] = N'Tổng tiền thuế VAT'
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'CPNT'
Update sysField set [TabIndex] = 34
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'CP'
Update sysField set [TabIndex] = 35
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TtienNT'
Update sysField set [TabIndex] = 36
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'Ttien'
Update sysField set [TabIndex] = 37
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TotalGNKNT'
Update sysField set [TabIndex] = 38, [LabelName] = N'Giá trị hàng nhập kho nguyên tệ'
where sysFieldID = @sysFieldID

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TotalGNK'
Update sysField set [TabIndex] = 39, [LabelName] = N'Giá trị hàng nhập kho'
where sysFieldID = @sysFieldID

-- Cấu hình dòng dữ liệu
SELECT @sysTableBLTKID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'BLTK'
SELECT @sysTableMTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'MT23'
SELECT @sysTableDTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'DT23'

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PNK7' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, @sysTableDTID, N'PNK7', N'MTID', 1, '(DT23.ChiuThueTTDB = 1 and MT23.ToTalTienTTDB > 0)', N'MTIDDT')

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PNK8' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, @sysTableDTID, N'PNK8', N'MTID', 1, '(DT23.ChiuThueTTDB = 1 and MT23.ToTalTienTTDB > 0)', N'MTIDDT')

-- Cấu hình chi tiết dòng dữ liệu
declare @blConfigID INT,
@blFieldID INT,
@mtFieldID INT,
@dtFieldID INT

-- PNK7
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PNK7'

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaCT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTID'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MT23ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'SoCT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'NgayCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'NgayCT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DienGiai'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'DienGiai'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKH'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaKH'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'Tk'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TKNo'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TkTTTDB'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsNo'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'ToTalTienTTDB'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

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
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'ToTalTienTTDBNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'OngBa'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'OngBa'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

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
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'DT23ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TenKH'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TenKH'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCongTrinh'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaCongTrinh'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

-- PNK8
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PNK8'

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaCT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTID'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MT23ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'SoCT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'NgayCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'NgayCT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DienGiai'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'DienGiai'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKH'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaKH'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'Tk'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TkTTTDB'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TkNo'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsCo'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'ToTalTienTTDB'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsCoNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'ToTalTienTTDBNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'OngBa'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'OngBa'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

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
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'DT23ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TenKH'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TenKH'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCongTrinh'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaCongTrinh'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)