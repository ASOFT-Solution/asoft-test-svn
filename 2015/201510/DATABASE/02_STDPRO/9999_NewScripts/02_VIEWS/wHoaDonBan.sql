IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wHoaDonBan]'))
DROP VIEW [dbo].[wHoaDonBan]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE              VIEW [dbo].[wHoaDonBan] 
as
SELECT [MT31].[MT31ID], MaCT, [SoCT], [SoHoaDon], [NgayCT], [MaKH], [Saleman], [NgayTT] = case when HanTT is not null then dateadd(day,HanTT,NgayBatDauTT) end, [DienGiai], [TKNO], [MaNT], [TyGia], [Ttien], [TtienNT], [ConLaiNT] = [TTienNT] - [DaTTNT], [ConLai] = [Ttien] - [DaTT], HanTT, MaBP, MaVV, MaPhi, MaCongTrinh 
FROM [MT31] inner join [DT31] on MT31.MT31ID = DT31.MT31ID
WHERE TKNO IN (SELECT TK FROM DMTK WHERE TKCONGNO = 1)
union
SELECT [MT32].[MT32ID], MaCT, [SoCT], [SoHoaDon], [NgayCT], [MaKH], [Saleman], [NgayTT] = case when HanTT is not null then dateadd(day,HanTT,NgayBatDauTT) end, [DienGiai], [TKNO], [MaNT], [TyGia], [Ttien], [TtienNT], [ConLaiNT] = [TTienNT] - [DaTTNT], [ConLai] = [Ttien] - [DaTT] , HanTT, MaBP, MaVV, MaPhi, MaCongTrinh
FROM [MT32] inner join [DT32] on MT32.MT32ID = DT32.MT32ID
WHERE TKNO IN (SELECT TK FROM DMTK WHERE TKCONGNO = 1)
union
SELECT [MT33].[MT33ID], MaCT, [SoCT], [SoHoaDon], [NgayCT], [MaKH], [Saleman], [NgayTT] = case when HanTT is not null then dateadd(day,HanTT,NgayBatDauTT) end, [DienGiai], [TKCO], [MaNT], [TyGia], -[Ttien], -[TtienNT], [ConLaiNT] = -[TTienNT] - [DaTTNT], [ConLai] = -[Ttien] - [DaTT] , HanTT, MaBP, MaVV, MaPhi, MaCongTrinh
FROM [MT33] inner join [DT33] on MT33.MT33ID = DT33.MT33ID
WHERE TKCO IN (SELECT TK FROM DMTK WHERE TKCONGNO = 1)