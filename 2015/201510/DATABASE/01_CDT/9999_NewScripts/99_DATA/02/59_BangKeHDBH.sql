Use CDT

-- [ACC_MAXPRO] Bảng kê hóa đơn bán hàng tổng theo hóa đơn
Update sysReport set Query = N'select mt.ngayct,mt.soct,mt.sohoadon,mt.DienGiai,mt.MaKH,
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as [Tên khách hàng],mt.tkNo, dt.mavt,
case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end as [Tên vật tư],dt.madvt,dt.makho,
dt.soluong,dt.Giant,dt.gia,dt.psnt,dt.ps, v.ThueNT as ThueNT,v.Thue as Thue, dt.cknt,dt.ck,isnull(dt.psnt,0)+isnull(v.ThueNT,0)-isnull(dt.cknt,0) as [Tổng tiền nt], isnull(dt.ps,0)+isnull(v.Thue,0)-isnull(dt.ck,0) as [Tổng tiền],dt.giavon,dt.tienvon, dt.GhiChu
 	from mt32 mt, dt32 dt,dmkh,dmvt, vatout v
	where  mt.mt32id=dt.mt32id and mt.makh=dmkh.makh and dt.mavt=dmvt.mavt and dt.mt32id *= v.mtid and dt.dt32id *= v.mtiddt and @@ps
order by mt.ngayct,mt.soct,dt.stt'
where ReportName = N'Bảng kê hóa đơn bán hàng'