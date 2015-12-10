Use CDT
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
SELECT @sysTableBLTKID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'BLTK'
SELECT @sysTableMTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'MT46'
SELECT @sysTableDTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'DT46'

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR5' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, @sysTableDTID, N'PTR5', N'MTID', 1, 'MT46.LoaiCT = 1', N'MTIDDT')

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR6' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, @sysTableDTID, N'PTR6', N'MTID', 1, 'MT46.LoaiCT = 1', N'MTIDDT')

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR7' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, NULL, N'PTR7', N'MTID', 1, 'MT46.LoaiCT = 1', NULL)

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR8' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, NULL, N'PTR8', N'MTID', 1, 'MT46.LoaiCT = 1', NULL)


IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR9' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, @sysTableDTID, N'PTR9', N'MTID', 1, 'MT46.LoaiCT = 0', N'MTIDDT')

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR10' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, @sysTableDTID, N'PTR10', N'MTID', 1, 'MT46.LoaiCT = 0', N'MTIDDT')

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR11' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, NULL, N'PTR11', N'MTID', 1, 'MT46.LoaiCT = 0', NULL)

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfig] WHERE [NhomDK] = 'PTR12' and [sysTableID] = @sysTableBLTKID)
INSERT [dbo].[sysDataConfig]([sysTableID], [mtTableID], [dtTableID], [NhomDK], [RootIDName], [EditSync], [Condition], [DTID])
VALUES(@sysTableBLTKID, @sysTableMTID, NULL, N'PTR12', N'MTID', 1, 'MT46.LoaiCT = 0', NULL)

-- Cấu hình chi tiết dòng dữ liệu
declare @blConfigID INT,
@blFieldID INT,
@mtFieldID INT,
@dtFieldID INT


------PTR5
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR5'

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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TK'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TK'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TKKho2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaSP'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaSP'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

------PTR6
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR6'

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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TKKho2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TK'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TK'
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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaSP'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaSP'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

------PTR7
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR7'

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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TK'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TKKho1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TK'
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

------PTR8
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR8'

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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TK'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TK'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TKKho1'
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

------PTR9
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR9'

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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TK'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TK'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TKKho2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaSP'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaSP'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

------PTR10
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR10'

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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'TKKho2'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TK'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TK'
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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'MaSP'
SELECT @dtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableDTID AND [FieldName] = N'MaSP'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, NULL, @dtFieldID, NULL)

------PTR11
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR11'

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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TK'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TK'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TKKho1'
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

------PTR12
SELECT @blConfigID = [blConfigID] FROM [sysDataConfig] WHERE [NhomDK] = N'PTR12'

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

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TK'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TKKho1'
IF NOT EXISTS(SELECT TOP 1 1 FROM [sysDataConfigDt] WHERE [blConfigID] = @blConfigID AND [blFieldID] = @blFieldID)
INSERT [dbo].[sysDataConfigDt]([blConfigID], [blFieldID], [mtFieldID], [dtFieldID], [Formula])
VALUES(@blConfigID, @blFieldID, @mtFieldID, NULL, NULL)

SELECT @blFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableBLTKID AND [FieldName] = N'TKDu'
SELECT @mtFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableID] = @sysTableMTID AND [FieldName] = N'TK'
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
