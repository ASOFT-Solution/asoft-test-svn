use [CDT]

Update sysReport set Query = N'select * from
(
	select * from
	(
		select dt23.*,mt23.Tthue as ThueHang, mt23.TthueNT as ThueHangNT ,dmvt.tenvt,mt23.ngayhd,mt23.sohoadon,mt23.soseri , mt23.tkco,dmkh.tenkh,dmkh.diachi, mt23.MaNT, dmnt.TenNT, dmnt.TenNT2 from dt23 ,dmvt,mt23,dmkh,dmnt  where dmvt.mavt=dt23.mavt and mt23.mt23id=dt23.mt23id and dmkh.makh=mt23.makh and mt23.MaNT = dmnt.MaNT
	)y inner join
	(
		select mtiddt,soct,ngayct,dongia as dongiacocp, dongiaNT as dongiacocpNT,ongba as nguoigiaohang,psno as thanhtien, psnoNT as thanhtienNT from blvt 
		inner join  dt23 on dt23.dt23id=blvt.mtiddt where @@ps
	)x on y.dt23id=x.mtiddt
)y1 left join
(
	--Thuế có chi phí
	select sum(mt25.Tthue*dt25.ps/(case when mt25.TtienH <> 0 then mt25.TtienH else 1 end)) as thueCP, 
			sum(mt25.TthueNT*dt25.psNT/(case when mt25.TtienHNT <> 0 then mt25.TtienHNT else 1 end)) as thueCPNT,dt25.mt22id  from mt25 inner join dt25 on mt25.mt25id =dt25.mt25id
	where dt25.mt22id  in (select mt23id from mt23 where @@ps) group by dt25.mt22id--)
)x1 on y1.mt23id=x1.mt22id
'
where ReportName = N'In phiếu nhập khẩu có chi phí'