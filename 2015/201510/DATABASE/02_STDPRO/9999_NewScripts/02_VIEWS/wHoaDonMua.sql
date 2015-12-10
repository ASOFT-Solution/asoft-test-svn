IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wHoaDonMua]'))
DROP VIEW [dbo].[wHoaDonMua]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[wHoaDonMua] 
as
SELECT [MT21].[MT21ID], MaCT, [SoCT], [SoHoaDon], [NgayCT], [MaKH], [Saleman], [NgayTT] = case when HanTT is not null then dateadd(day,HanTT,NgayBatDauTT) end, [DienGiai], [TKCO], [MaNT], [TyGia], [Ttien], [TtienNT], [ConLaiNT] = [TTienNT] - [DaTTNT], [ConLai] = [Ttien] - [DaTT], HanTT, MaBP, MaVV, MaPhi, MaCongTrinh 
FROM [MT21] inner join [DT21] on MT21.MT21ID = DT21.MT21ID
WHERE TKCO IN (SELECT TK FROM DMTK WHERE TKCONGNO = 1)
union
SELECT [MT22].[MT22ID], MaCT, [SoCT], [SoHoaDon], [NgayCT], [MaKH], [Saleman], [NgayTT] = case when HanTT is not null then dateadd(day,HanTT,NgayBatDauTT) end, [DienGiai], [TKCO], [MaNT], [TyGia], [Ttien], [TtienNT], [ConLaiNT] = [TTienNT] - [DaTTNT], [ConLai] = [Ttien] - [DaTT] , HanTT, MaBP, MaVV, MaPhi, MaCongTrinh
FROM [MT22] inner join [DT22] on MT22.MT22ID = DT22.MT22ID
WHERE TKCO IN (SELECT TK FROM DMTK WHERE TKCONGNO = 1)
union
SELECT [MT23].[MT23ID], MaCT, [SoCT], [SoHoaDon], [NgayCT], [MaKH], [Saleman], [NgayTT] = case when HanTT is not null then dateadd(day,HanTT,NgayBatDauTT) end, [DienGiai], [TKCO], [MaNT], [TyGia], [Ttien], [TtienNT], [ConLaiNT] = [TTienNT] - [DaTTNT], [ConLai] = [Ttien] - [DaTT], HanTT, MaBP, MaVV, MaPhi, MaCongTrinh
FROM [MT23] inner join [DT23] on MT23.MT23ID = DT23.MT23ID
WHERE TKCO IN (SELECT TK FROM DMTK WHERE TKCONGNO = 1)
union
SELECT [MT24].[MT24ID], MaCT, [SoCT], [SoHoaDon], [NgayCT], [MaKH], [Saleman], [NgayTT] = case when HanTT is not null then dateadd(day,HanTT,NgayBatDauTT) end, [DienGiai], [TKNO], [MaNT], [TyGia], -[Ttien], -[TtienNT], [ConLaiNT] = -[TTienNT] - [DaTTNT], [ConLai] = -[Ttien] - [DaTT] , HanTT, MaBP, MaVV, MaPhi, MaCongTrinh
FROM [MT24] inner join [DT24] on MT24.MT24ID = DT24.MT24ID
WHERE TKNO IN (SELECT TK FROM DMTK WHERE TKCONGNO = 1)
union
SELECT [MT25].[MT25ID], MaCT, [SoCT], [SoHoaDon], [NgayCT], [MaKH], [Saleman], [NgayTT] = case when HanTT is not null then dateadd(day,HanTT,NgayBatDauTT) end, [DienGiai], [TKCO], [MaNT], [TyGia], [Ttien], [TtienNT], [ConLaiNT] = [TTienNT] - [DaTTNT], [ConLai] = [Ttien] - [DaTT] , HanTT, MaBP, MaVV, MaPhi, MaCongTrinh 
FROM [MT25] inner join [DT25] on MT25.MT25ID = DT25.MT25ID
WHERE TKCO IN (SELECT TK FROM DMTK WHERE TKCONGNO = 1)