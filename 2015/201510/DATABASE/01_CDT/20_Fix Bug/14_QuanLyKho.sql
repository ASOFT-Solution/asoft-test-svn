use [CDT]

-- Bảng kê hàng nhập kho
Update sysReport
set Query = N'
select x.*, c.TenKH, b.TenVT, d.TenDVT, b.Nhom, n.TenNhom, h.TenVV
from
(Select  mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH,
	mt.DienGiai, dt.MaKho, mt.TotalGNK Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.TienNK as [Thành tiền], dt.MaVV
from mt22 mt, dt22 dt
where mt.mt22id = dt.mt22id

union all

Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.TotalGNK Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.TienNK as [Thành tiền], dt.MaVV
from mt23 mt, dt23 dt
where mt.mt23id = dt.mt23id

union all

--Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
--	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
--	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps as [Thành tiền], dt.MaVV
--from mt41 mt, dt41 dt
--where mt.mt41id = dt.mt41id

--union

Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps as [Thành tiền], dt.MaVV
from mt42 mt, dt42 dt
where mt.mt42id = dt.mt42id

union all

Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, mt.MaKhoN, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps as [Thành tiền], dt.MaVV
from mt44 mt, dt44 dt
where mt.mt44id = dt.mt44id

union all

Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps as [Thành tiền], dt.MaVV
from mt33 mt, dt33 dt
where mt.mt33id = dt.mt33id
)x, DMKH c, DMVT b, DMDVT d, DMNhomVT n, DMVuViec h
where x.MaKH = c.MaKH and x.MaVT = b.MaVT and b.MaDVT = d.MaDVT and b.Nhom *= n.MaNhomVT and x.MaVV *= h.MaVV and [Ngày chứng từ] between @@NgayCT1 and @@NgayCT2 and @@PS
order by x.[Ngày chứng từ], x.SoCT, x.MaKho, x.MaVT'
where ReportName = N'Bảng kê hàng nhập kho'


-- In phiếu mua hàng có chi phí
Update sysReport
set Query = N'select * from
(
	select * from
	(
		select dt22.*,mt22.Tthue as ThueHang ,dmvt.tenvt,mt22.ngayhd,mt22.sohoadon,mt22.soseri , mt22.tkco,dmkh.tenkh,dmkh.diachi, mt22.MaNT, dmnt.TenNT, dmnt.TenNT2 from dt22 ,dmvt,mt22,dmkh, dmnt where dmvt.mavt=dt22.mavt and mt22.mt22id=dt22.mt22id and dmkh.makh=mt22.makh and mt22.MaNT = dmnt.MaNT
	)y inner join
	(
		select mtiddt,soct,ngayct,dongia as dongiacocp,ongba as nguoigiaohang,psno as thanhtien from blvt 
		inner join  dt22 on dt22.dt22id=blvt.mtiddt where @@ps
	)x on y.dt22id=x.mtiddt
)y1 left join
(
	--Thuế có chi phí
	select sum(mt25.Tthue*dt25.ps/mt25.TtienH) as thueCP,dt25.mt22id  from mt25 inner join dt25 on mt25.mt25id =dt25.mt25id 
	where dt25.mt22id  in (select mt22id from mt22 where @@ps) group by dt25.mt22id--)
)x1 on y1.mt22id=x1.mt22id'
where ReportName = N'In phiếu mua hàng có chi phí'

-- Bảng kê phiếu nhập khẩu
Update sysReport
set Query = N'if @@nhom=''''
begin
	select mt.*,dt.*,v.thueNT as ThueNT, v.Thue as Thue, dt.TienNK as TPs, dt.TienNKNT as TPsNT, dmkh.makh,dmvt.tenvt,dmvt.nhom, ttdb.TienTTDB
	from MT23 mt, dt23 dt, dmkh, dmvt, VatIn v, TTDBIn ttdb
	where @@ps and mt.mt23id = dt.mt23id and mt.makh = dmkh.makh and dt.mavt = dmvt.mavt and dt.mt23id *= v.mtid and dt.dt23id *= v.mtiddt and dt.mt23id *= ttdb.mtid and dt.dt23id *= ttdb.mtiddt
end

else 
begin
	select mt.*,dt.*,v.thueNT as ThueNT, v.Thue as Thue, dt.TienNK as TPs, dt.TienNKNT as TPsNT, dmkh.makh,dmvt.tenvt,dmvt.nhom, ttdb.TienTTDB
	from MT23 mt, dt23 dt, dmkh, dmvt, VatIn v, TTDBIn ttdb
	where @@ps and mt.mt23id = dt.mt23id and mt.makh = dmkh.makh and dt.mavt = dmvt.mavt and dt.mt23id *= v.mtid and dt.dt23id *= v.mtiddt and dt.mt23id *= ttdb.mtid and dt.dt23id *= ttdb.mtiddt and  dt.mavt in (select mavt from dmvt where nhom =@@nhom)
end'
where ReportName = N'Bảng kê phiếu nhập khẩu'

-- In phiếu nhập khẩu có chi phí
Update sysReport
set Query = N'select * from
(
	select * from
	(
		select dt23.*,mt23.Tthue as ThueHang ,dmvt.tenvt,mt23.ngayhd,mt23.sohoadon,mt23.soseri , mt23.tkco,dmkh.tenkh,dmkh.diachi, mt23.MaNT, dmnt.TenNT, dmnt.TenNT2 from dt23 ,dmvt,mt23,dmkh,dmnt  where dmvt.mavt=dt23.mavt and mt23.mt23id=dt23.mt23id and dmkh.makh=mt23.makh and mt23.MaNT = dmnt.MaNT
	)y inner join
	(
		select mtiddt,soct,ngayct,dongia as dongiacocp,ongba as nguoigiaohang,psno as thanhtien from blvt 
		inner join  dt23 on dt23.dt23id=blvt.mtiddt where @@ps
	)x on y.dt23id=x.mtiddt
)y1 left join
(
	--Thuế có chi phí
	select sum(mt25.Tthue*dt25.ps/mt25.TtienH) as thueCP,dt25.mt22id  from mt25 inner join dt25 on mt25.mt25id =dt25.mt25id
	where dt25.mt22id  in (select mt23id from mt23 where @@ps) group by dt25.mt22id--)
)x1 on y1.mt23id=x1.mt22id'
where ReportName = N'In phiếu nhập khẩu có chi phí'

-- Bảng kê phiếu mua hàng
Update sysReport
set Query = N'select [NgayCT], [SoCT], [SoHoaDon], dmkh.[MaKH],dmkh.tenkh as [Tên khách hàng], [DienGiai], [MaNT], [TyGia], [TKCo], v.[MaVT], v.TenVT as [Tên vật tư], v.[MaDVT], [MaKho], [TKNo], 
[SoLuong], [GiaNT], [Gia], [PsNT], [Ps],  [ThueNT] , [Thue], [CPCtNT], [CPCt], [TienNKNT] + ThueNT as TPsNTCP, [TienNK] + Thue as TPsCP, [TienTTDB], [TienTTDBNT], [TienCK], [TienCKNT]
 from
(select mt.mact,mt.ngayct, mt.soct, mt.ngayhd,mt.sohoadon,mt.soseri,mt.makh,mt.diachi,mt.ongba, mt.manv,
mt.diengiai,mt.mant,mt.tygia,mt.tkco,mt.mathue,mt.tkthue,mt.TtienH,mt.TtienHNT,mt.cpnt,mt.cp,mt.TThueNt,mt.TThue,mt.Ttien,mt.TtienNT,
	 dt.*, v.ThueNT as ThueNT, v.Thue as Thue, ttdb.TienTTDB, ttdb.TienTTDBNT
	from MT22 mt, DT22 dt, VatIn v, TTDBIn ttdb
where mt.mt22id = dt.mt22id and dt.mt22id *= v.mtid and dt.dt22id *= v.mtiddt and dt.mt22id *= ttdb.mtid and dt.dt22id *= ttdb.mtiddt and @@ps
)x, dmkh, dmvt v where x.makh = dmkh.makh
and x.mavt = v.mavt 
order by ngayct,soct,x.stt'
where ReportName = N'Bảng kê phiếu mua hàng'