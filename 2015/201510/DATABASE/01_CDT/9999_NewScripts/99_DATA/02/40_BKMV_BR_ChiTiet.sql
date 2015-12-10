USE [CDT]

-- Fix bug không lấy lên ghi chú
Update sysReport
set Query = N'Select SoSerie, Sohoadon, ngayct, ngayhd,vatout.makh, 
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as Tenkh,
dmkh.mst, TkThue, TkDu,
vatout.mavt, ''DienGiai'' = case when (vatout.mavt is null) then DienGiai else case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end end, 
Ttien, ThueSuat/100 as ThueSuat, Thue, GhiChu, MaThue, MaCT
from vatout, dmkh, dmvt
where vatout.makh *= dmkh.makh and (ngayct between @@ngayct1 and @@ngayct2) and vatout.mavt *= dmvt.mavt and @@ps
order by ngayct, sohoadon'
where ReportName = N'Bảng kê thuế GTGT bán ra (chi tiết)'

Update sysReport
set Query = N'Select ngayct, ngayhd, Type, SoSeries, Sohoadon,vatin.makh, TkThue, TkDu, 
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as Tenkh,dmkh.mst ,vatin.mavt,  ''DienGiai'' = case when (vatin.mavt is null) then DienGiai else case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end end,
 Ttien, ThueSuat/100 as ThueSuat, Thue, GhiChu, MaCT
from Vatin, dmkh, dmvt
where vatin.makh *= dmkh.makh and (ngayct between @@ngayct1 and @@ngayct2) and vatin.mavt *= dmvt.mavt and @@ps
order by ngayct, sohoadon'
where ReportName = N'Bảng kê thuế GTGT mua vào (chi tiết)'