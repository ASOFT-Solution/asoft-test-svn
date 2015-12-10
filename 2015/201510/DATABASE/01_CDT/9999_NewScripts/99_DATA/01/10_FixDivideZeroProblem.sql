use [CDT]
declare @sysTableBLID int,
		@sysTableID int,
		@sysFieldId int,
		@sysDataConfigID int

-- I) Update sysDataConfigDt

select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'

-- HDB4
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'HDB4'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLID
and FieldName = 'PsCoNT'

Update sysDataConfigDt set Formula = N'case when MT32.TyGia = 0 then 0 else TienVon/MT32.TyGia end'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula = N'TienVon/MT32.TyGia'

-- HDB3
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'HDB3'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLID
and FieldName = 'PsNoNT'

Update sysDataConfigDt set Formula = N'case when MT32.TyGia = 0 then 0 else TienVon/MT32.TyGia end'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula = N'TienVon/MT32.TyGia'

select @sysTableID = sysTableID from sysTable where TableName = 'MT12'

-- PC13
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PC13'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLID
and FieldName = 'PsNoNT'

Update sysDataConfigDt set Formula = N'case when MT12.TyGia = 0 then 0 else TTThue/MT12.TyGia end'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula = N'TTThue/MT12.TyGia'

-- PC14
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PC14'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLID
and FieldName = 'PsCoNT'

Update sysDataConfigDt set Formula = N'case when MT12.TyGia = 0 then 0 else TTThue/MT12.TyGia end'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula = N'TTThue/MT12.TyGia'

-- II) Update report
-- In phiếu mua hàng có chi phí
Update sysReport set Query = N'select * from
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
	select sum(case when mt25.Tthue*dt25.ps/NULLIF(mt25.TtienH,0) is null then 0 else mt25.Tthue*dt25.ps/mt25.TtienH end) as thueCP, 
	sum(case when mt25.TthueNT*dt25.psNT/NULLIF(mt25.TtienHNT,0) is null then 0 else mt25.TthueNT*dt25.psNT/mt25.TtienHNT end) as thueCPNT ,dt25.mt22id  
	from mt25 inner join dt25 on mt25.mt25id =dt25.mt25id 
	where dt25.mt22id  in (select mt22id from mt22 where @@ps) group by dt25.mt22id--)
)x1 on y1.mt22id=x1.mt22id'
where ReportName = N'In phiếu mua hàng có chi phí'

-- In phiếu nhập khẩu có chi phí
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
	select sum(case when mt25.Tthue*dt25.ps/nullif(mt25.TtienH,0) is null then 0 else mt25.Tthue*dt25.ps/mt25.TtienH end) as thueCP, 
			sum(case when mt25.TthueNT*dt25.psNT/nullif(mt25.TtienHNT,0) is null then 0 else mt25.TthueNT*dt25.psNT/mt25.TtienHNT end ) as thueCPNT,dt25.mt22id  from mt25 inner join dt25 on mt25.mt25id =dt25.mt25id
	where dt25.mt22id  in (select mt23id from mt23 where @@ps) group by dt25.mt22id--)
)x1 on y1.mt23id=x1.mt22id'
where ReportName = N'In phiếu nhập khẩu có chi phí'