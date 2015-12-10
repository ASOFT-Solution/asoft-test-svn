USE [CDT]

Declare @sysReportID int
Declare @ReportName nvarchar(512)
Declare @NewReportName nvarchar(512)

-- In phiếu mua hàng có chi phí
set @ReportName = N'In phiếu mua hàng có chi phí'
set @NewReportName = @ReportName + N' (Ngoại tệ)'

select @sysReportID = sysReportID from sysReport
where ReportName = @ReportName

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportName = @NewReportName)
INSERT INTO [sysFormReport](sysReportID, [ReportName],[ReportFile],[ReportName2],[ReportFile2])
VALUES (@sysReportID, @NewReportName, 'INPMHANGCOCP_NT', NULL, NULL)

Update sysReport
set Query = N'select * from
(
	select * from
	(
		select dt22.*,mt22.Tthue as ThueHang, mt22.TthueNT as ThueHangNT, dmvt.tenvt,mt22.ngayhd,mt22.sohoadon,mt22.soseri , mt22.tkco,dmkh.tenkh,dmkh.diachi, mt22.MaNT, dmnt.TenNT, dmnt.TenNT2 from dt22 ,dmvt,mt22,dmkh, dmnt where dmvt.mavt=dt22.mavt and mt22.mt22id=dt22.mt22id and dmkh.makh=mt22.makh and mt22.MaNT = dmnt.MaNT
	)y inner join
	(
		select mtiddt,soct,ngayct,dongia as dongiacocp, DongiaNT as dongiacocpNT, ongba as nguoigiaohang,psno as thanhtien, psnoNT as thanhtienNT from blvt 
		inner join  dt22 on dt22.dt22id=blvt.mtiddt where @@ps
	)x on y.dt22id=x.mtiddt
)y1 left join
(
	--Thuế có chi phí
	select sum(mt25.Tthue*dt25.ps/mt25.TtienH) as thueCP, sum(mt25.TthueNT*dt25.psNT/mt25.TtienHNT) as thueCPNT ,dt25.mt22id  from mt25 inner join dt25 on mt25.mt25id =dt25.mt25id 
	where dt25.mt22id  in (select mt22id from mt22 where @@ps) group by dt25.mt22id--)
)x1 on y1.mt22id=x1.mt22id'
where ReportName = @ReportName

-- In phiếu nhập khẩu có chi phí

set @ReportName = N'In phiếu nhập khẩu có chi phí'
set @NewReportName = @ReportName + N' (Ngoại tệ)'

select @sysReportID = sysReportID from sysReport
where ReportName = @ReportName

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportName = @NewReportName)
INSERT INTO [sysFormReport](sysReportID, [ReportName],[ReportFile],[ReportName2],[ReportFile2])
VALUES (@sysReportID, @NewReportName, 'INPNhapKhauCOCP_NT', NULL, NULL)

Update sysReport
set Query = N'select * from
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
	select sum(mt25.Tthue*dt25.ps/mt25.TtienH) as thueCP, sum(mt25.TthueNT*dt25.psNT/mt25.TtienHNT) as thueCPNT,dt25.mt22id  from mt25 inner join dt25 on mt25.mt25id =dt25.mt25id
	where dt25.mt22id  in (select mt23id from mt23 where @@ps) group by dt25.mt22id--)
)x1 on y1.mt23id=x1.mt22id'
where ReportName = @ReportName