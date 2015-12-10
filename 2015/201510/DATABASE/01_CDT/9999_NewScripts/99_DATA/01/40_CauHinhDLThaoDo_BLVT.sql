USE CDT
----------Cấu hình luồng dữ liệu------------------------

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

-- Cấu hình dòng dữ liệu
SELECT @sysTableBLTKID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'BLVT'
SELECT @sysTableMTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'MT46'
SELECT @sysTableDTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'DT46'

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR1' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, NULL, N'PTR1', N'MTID', 1, 'MT46.LoaiCT = 1', NULL)

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR2' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, @sysTableDTID, N'PTR2', N'MTID', 1, 'MT46.LoaiCT = 1', N'MTIDDT')

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR3' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, @sysTableDTID, N'PTR3', N'MTID', 1, 'MT46.LoaiCT = 0', N'MTIDDT')

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR4' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, NULL, N'PTR4', N'MTID', 1, 'MT46.LoaiCT = 0', NULL)
-- Cấu hình chi tiết dòng dữ liệu
declare @blConfigID INT,
@blFieldID INT,
@mtFieldID INT,
@dtFieldID INT

------PTR1
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR1'

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaCT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTID'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MT46ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'SoCT1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'NgayCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'NgayCT1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DienGiai'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'DienGiai1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKH'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaKH1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsNo'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Ps1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsNoNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Ps1NT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TyGia'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TyGia'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaVT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaVT1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKho'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaKho1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoLuong'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'SoLuong1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGia'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Gia1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGiaNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Gia1NT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)


SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoluongQD'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Soluong1QD'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGiaQD'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Gia1QD'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGiaQDNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Gia1QDNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DVTQDID'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'DVTQDID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

------PTR2
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR2'

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaCT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTID'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MT46ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'SoCT2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'NgayCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'NgayCT2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DienGiai'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'DienGiai2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKH'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaKH2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsCo'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Ps2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

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
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Ps2NT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaNT'
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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaVT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaVT2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKho'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaKho2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGia'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Gia2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGiaNT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Gia2NT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoLuong_x'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'SoLuong2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTIDDT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'DT46ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCongTrinh'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaCongTrinh'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoCTDT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'SoCTDT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'LotNumber'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'ExpireDate'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTIDDoiTru'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MTIDDoiTru'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoLuong_xQD'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Soluong2QD'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DongiaQDNT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Gia2QDNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DongiaQD'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Gia2QD'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DVTQDID'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'DVTQDID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

------PTR3
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR3'

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaCT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTID'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MT46ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'SoCT2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'NgayCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'NgayCT2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DienGiai'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'DienGiai2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKH'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaKH2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsNo'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Ps2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

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
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Ps2NT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaNT'
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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaVT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaVT2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKho'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaKho2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoLuong'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'SoLuong2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGia'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Gia2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGiaNT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Gia2NT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTIDDT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'DT46ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCongTrinh'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaCongTrinh'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'LotNumber'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'ExpireDate'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTIDDoiTru'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MTIDDoiTru'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoLuong_xQD'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Soluong2QD'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGiaQDNT'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Gia2QDNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGiaQD'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'Gia2QD'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DVTQDID'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'DVTQDID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)
------PTR4

SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR4'

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaCT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MTID'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MT46ID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'SoCT1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'NgayCT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'NgayCT1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DienGiai'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'DienGiai1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKH'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaKH1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsCo'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Ps1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'PsCoNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Ps1NT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TyGia'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TyGia'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaVT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaVT1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaKho'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'MaKho1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoLuong_x'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'SoLuong1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGia'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Gia1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGiaNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Gia1NT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoCTDT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'SoCTDT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'LotNumber'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'LotNumber'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'ExpireDate'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'ExpireDate'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'SoluongQD_x'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Soluong1QD'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGiaQD'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Gia1QD'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DonGiaQDNT'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'Gia1QDNT'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'DVTQDID'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'DVTQDID'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)


