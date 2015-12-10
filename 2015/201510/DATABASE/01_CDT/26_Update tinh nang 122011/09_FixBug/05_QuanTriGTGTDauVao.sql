use [CDT]

-- Quản trị chứng từ thuế GTGT mua vào
Update sysReport Set Query = N'Select  ngayct, ngayhd, SoSeries, Sohoadon,vatin.Tenkh,dmkh.mst, DienGiai, Sum(Ttien) TTien, ThueSuat as ThueSuat, Sum(Thue) Thue, '''' as GhiChu, Type, MaCT,MTID
from Vatin,dmkh
where vatin.makh *= dmkh.makh
    and @@ps and (Ngayct between @@ngayct1 and @@ngayct2)
group by ngayhd, Type,Sohoadon,soseries,ngayct,vatin.tenkh,dmkh.mst,diengiai,thuesuat,MaCT, MTID
order by Ngayhd,Sohoadon'
where ReportName = N'Quản trị chứng từ thuế GTGT mua vào'

-- Quản trị chứng từ thuế GTGT bán ra
Update sysReport Set Query = N'Select  SoSerie,Sohoadon,ngayct,vatout.Tenkh,  dmkh.mst, diengiai,  Sum(Ttien) as TTien,vatout.ThueSuat as ThueSuat,Sum(Thue) as Thue, '''' as GhiChu, MaThue, MaCT, MTID
from vatout, dmkh
where vatout.makh *= dmkh.makh and (ngayct between @@ngayct1 and @@ngayct2) and @@ps 
group by Sohoadon, Soserie, ngayct, vatout.tenkh, ghichu, diengiai, nhomdk, dmkh.mst, vatout.thuesuat, MaThue, MaCT,mtid
order by  ngayct,sohoadon'
where ReportName = N'Quản trị chứng từ thuế GTGT bán ra'