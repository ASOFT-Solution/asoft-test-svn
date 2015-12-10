use [CDT]

-- Phai tra
Update [sysReport] set [Query] = N'select hd.[NgayCT], hd.[SoCT], hd.[SoHoaDon], hd.[MaKH], kh.TenKH, hd.[NgayTT], hd.[DienGiai], hd.[TKCO], hd.[MaNT], hd.[TyGia], hd.[Ttien], hd.[TtienNT], hd.[ConLaiNT], hd.[ConLai], hd.[HanTT],
mt.[SoCt] as [Số CT TT], mt.[NgayCt] as [Ngày CT TT], mt.[DienGiai] as [Diễn giải TT], mt.[MaNT] as [Mã NT TT], mt.[TyGia] as [Tỷ giá TT], 
tt.[TTNT], tt.[TT], tt.[CLTG], tt.[MaVV], tt.[MaBP], tt.[MaPhi], tt.mt21id
from wHoaDonMua hd, DT26 tt, MT26 mt, DMKH kh
where hd.mt21id = tt.mt21id and mt.mt26id = tt.mt26id and hd.MaKH = kh.MaKH and (@@logic = 1 or (@@logic = 0 and (hd.conlai <> 0 or hd.conlaiNT <> 0))) and @@ps
union all
select hd.[NgayCT], hd.[SoCT], hd.[SoHoaDon], hd.[MaKH], kh.TenKH, hd.[NgayTT], hd.[DienGiai], hd.[TKCO], hd.[MaNT], hd.[TyGia], hd.[Ttien], hd.[TtienNT], hd.[ConLaiNT], hd.[ConLai], hd.[HanTT],
'''',null,'''','''',0,0,0,0,'''','''','''',null
from wHoaDonMua hd, DMKH kh
where hd.MaKH = kh.MaKH and hd.ConLai = hd.TTien and hd.ConLaiNT = hd.TTienNT and @@ps'
where ReportName = N'Bảng kê chi tiết công nợ phải trả theo hóa đơn'

-- Phai thu
Update [sysReport] set [Query] = N'select hd.[NgayCT], hd.[SoCT], hd.[SoHoaDon], hd.[MaKH], kh.TenKH, hd.[NgayTT], hd.[DienGiai], hd.[TKNO], hd.[MaNT], hd.[TyGia], hd.[Ttien], hd.[TtienNT], hd.[ConLaiNT], hd.[ConLai], hd.[HanTT],
mt.[SoCt] as [Số CT TT], mt.[NgayCt] as [Ngày CT TT], mt.[DienGiai] as [Diễn giải TT], mt.[MaNT] as [Mã NT TT], mt.[TyGia] as [Tỷ giá TT], 
tt.[TTNT], tt.[TT], tt.[CLTG], tt.[MaVV], tt.[MaBP], tt.[MaPhi], tt.mt31id
from wHoaDonBan hd, DT34 tt, MT34 mt, DMKH kh
where hd.mt31id = tt.mt31id and mt.mt34id = tt.mt34id and hd.MaKH = kh.MaKH and (@@logic = 1 or (@@logic = 0 and (hd.conlai <> 0 or hd.conlaiNT <> 0))) and @@ps
union all
select hd.[NgayCT], hd.[SoCT], hd.[SoHoaDon], hd.[MaKH], kh.TenKH, hd.[NgayTT], hd.[DienGiai], hd.[TKNO], hd.[MaNT], hd.[TyGia], hd.[Ttien], hd.[TtienNT], hd.[ConLaiNT], hd.[ConLai], hd.[HanTT],
'''',null,'''','''',0,0,0,0,'''','''','''',null
from wHoaDonBan hd, DMKH kh
where hd.MaKH = kh.MaKH and hd.ConLai = hd.TTien and hd.ConLaiNT = hd.TTienNT and @@ps'
where ReportName = N'Bảng kê chi tiết công nợ phải thu theo hóa đơn'