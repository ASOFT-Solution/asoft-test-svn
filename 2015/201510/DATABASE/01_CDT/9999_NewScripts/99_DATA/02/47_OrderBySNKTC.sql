Use CDT

-- Thêm Order by Sổ nhật ký thu tiền và Sổ nhật ký chi tiền

Update sysReport set Query = N'Select * from 
(Select SoCt, NgayCt,  DienGiai, B.MaKH, 
case when @@lang = 1 then KH.TenKH2 else KH.TenKH end as TenKH, B.TK, 
case when @@lang = 1 then TK.TenTK2 else TK.TenTK end as TenTK,
TKDu, PsNo, PsCo, 
B.MaPhi,case when @@lang = 1 then P.Tenphi2 else P.Tenphi end as Tenphi,
B.MaVV, case when @@lang = 1 then VV.TenVV2 else VV.TenVV end as TenVV, 
B.MaBP, case when @@lang = 1 then PB.TenBP2 else PB.TenBP end as TenBP, MaNT, TyGia 
From BLTK as B left join DMPhi as P on B.MaPhi=P.MaPhi
  left join DMVuViec as VV on B.MaVV=VV.MaVV
  left join DMBoPhan as PB on B.MaBP=PB.MaBP
  left join DMKH as KH on B.MaKH=KH.MaKH
  left join DMTK as TK on B.TK=TK.TK
where B.TK like ''11%'' and psno > 0) x 
where @@ps
Order by NgayCt, SoCt
'
where ReportName = N'Sổ nhật ký thu tiền'

Update sysReport set Query = N'
Select * from 
(Select SoCt, NgayCt,  DienGiai, 
B.MaKH, case when @@lang = 1 then KH.TenKH2 else KH.TenKH end as TenKH, 
B.TK,case when @@lang = 1 then TK.TenTK2 else TK.TenTK end as TenTK,
TKDu, PsNo, PsCo, 
B.MaPhi,case when @@lang = 1 then P.Tenphi2 else P.Tenphi end as Tenphi, 
B.MaVV, case when @@lang = 1 then VV.TenVV2 else VV.TenVV end as TenVV, 
B.MaBP, PB.TenBP, 
MaNT, TyGia 
From BLTK as B left join DMPhi as P on B.MaPhi=P.MaPhi
  left join DMVuViec as VV on B.MaVV=VV.MaVV
  left join DMBoPhan as PB on B.MaBP=PB.MaBP
  left join DMKH as KH on B.MaKH=KH.MaKH
  left join DMTK as TK on B.TK=TK.TK
where B.TK like ''11%'' and psco > 0) x
where @@ps
Order by NgayCt, SoCt
'
where ReportName = N'Sổ nhật ký chi tiền'
