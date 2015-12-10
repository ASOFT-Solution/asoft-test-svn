use [CDT]

-- Báo cáo chi tiết TSCD
Update sysReport set Query = N'
--declare @TuThang int 
--declare @DenThang int 

--set @TuThang =@@Thang1 
--set @DenThang =@@Thang2 

Declare @TuNgay datetime 
Declare @DenNgay datetime 

--set @TuNgay = cast((Convert(nvarchar,@tuThang) +''/01''+ ''/@@nam'') as Datetime) 
--set @DenNgay = cast((Convert(nvarchar,@DenThang) + ''/01'' + ''/@@nam'') as Datetime) 
set @TuNgay = ''01/01/1900''
set @DenNgay = ''01/01/2900''

--danh mục tài sản 
SELECT 
m.tentk, 
n.tenbp,
K.*,
[Mức khấu hao năm] = KHThang * 12,
[Khấu hao cơ bản đầu kỳ] = case when [Khấu hao] = 0 then 0 else [Khấu hao] - [Khấu hao cơ bản] end 
FROM 
(
	select 
	R.MaBP,
	R.TKTS,
	r.mats,
	r.tents,
	r.nhomts,
	nts.tents [Tên nhóm tài sản],
	ngaykh,
	sothang,
	nguyengia + NguyengiaT as [Nguyên giá đầu kỳ],
	GTCL + NguyengiaT - KHTruocky as [Giá trị còn lại đầu kỳ], 
	DaKH + KHTruocKy as [Đã khấu hao đầu kỳ],
	case when NguyenGiaTTk>0 then NguyenGiaTTk else 0.0 end as [Tăng nguyên giá], 
	case when NguyenGiaTTk<0 then abs(NguyenGiaTTk) else 0.0 end as [Giảm nguyên giá],
	KHTrongKy as [Khấu hao], 
	nguyengia + nguyengiaT + nguyengiaTTk as [Nguyên giá cuối kỳ], 
	GTCL + nguyengiaT + nguyengiaTTk - KHTruocKy - KHTrongKy as [Giá trị còn lại cuối kỳ], 
	DaKH + KHTruocKy + KHTrongKy as [Đã khấu hao cuối kỳ],
	KHThang,
	case when q.KHCBTK is not null then q.KHCBTK else 0 end as [Khấu hao cơ bản] 
	from
	(
		select
		xyz.*,
		KHTrongKy = case when t.KHTrongKy is null then 0.0 else t.KHTrongKy end 
		from
		(
			select 
			x.*, 
			KHTruocKy = case when y.KHTruocKy is null then 0.0 else y.KHTruocKy end, 
			nguyengiaTTk = case when z.nguyengia is null then 0.0 else z.nguyengia end 
			from
			(
				select 
				a.mats, 
				a.mabp, 
				a.tkts, 
				tents,
				nhomts,
				ngaykh,
				a.sothang,
				(a.nguyengia1 + a.nguyengia2 + a.nguyengia3 + a.nguyengia4) as nguyengia,
				(GTCL1 + GTCL2 + GTCL3 + GTCL4) as GTCL,
				(DaKH1 + DaKH2 + DaKH3 + DaKH4) as DaKH, 
				(KHThang1 + KHThang2 + KHThang3 + KHThang4) as KHThang, 
				nguyengiaT = case when b.nguyengia > 0 then b.nguyengia else 0.0 end 
				from dmtscd a 
				left join   (
				                select mats, sum(nguyengia1 + nguyengia2 + nguyengia3 + nguyengia4) as nguyengia 
							    from FaNguyenGia where ngayct <@Tungay group by mats
				            ) b on a.mats=b.mats 
			) as x 
			left join   (
			                select soct as mats,case when sum(psco)>0 then sum(psco) else 0.0 end as KHTruocKy 
						    from bltk where ngayct<@Tungay and nhomdk=''KHTS'' group by soct
						) as y on x.mats=y.mats 
			left join   (
			                select mats, sum(nguyengia1 + nguyengia2 + nguyengia3 + nguyengia4) as nguyengia 
						    from FaNguyenGia where ngayct between @Tungay and @Denngay group by mats
						)as z on x.mats=z.mats
		) as xyz 
		left join   (
		                select soct as mats,case when sum(psco)>0 then sum(psco) else 0.0 end as KHTrongKy 
		                from bltk where ngayct between @Tungay and @Denngay and nhomdk=''KHTS'' group by soct
		            ) as t on xyz.mats=t.mats 
	)as r 
	left join   (
	                select mats,sum((NguyenGia1+NguyenGia2+NguyenGia3+NguyenGia4)/(case when sothang = 0 then 1 else sothang end)) as KHCBTK 
	                from faNguyenGia where ngayct between @tungay and @denngay group by Mats
	            ) q on r.mats=q.mats 
	left join DMNhomTS nts on r.NhomTS = nts.NhomTS
) as k left join DmBoPhan n on k.mabp = n.mabp, DMTK m 
where k.tkts = m.tk 
and @@ps
order by k.mats'
where ReportName = N'Báo cáo chi tiết TSCD'

-- Báo cáo doanh số bán hàng
Update sysReport set Query = N'select x. ngayct, x.sohoadon, x.makh, x.tenkh, x.mavt, x.tenvt, x.soluong, x.gia, x.ps, x.ck, x.ps - x.ck as [Doanh số], vo.thue, x.mabp, b.tenbp from
(select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, mabp
from mt32, dt32, dmvt v
where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
union all
select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, mabp
from mt33, dt33, dmvt v
where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt
union all
select dt31id, ngayhd, sohoadon, makhct, tenkhct,'''', diengiaict, 0.0, 0.0, ps, case when ttienh <> 0 then tck*ps/ttienh else 0 end, mabp
from mt31, dt31
where mt31.mt31id = dt31.mt31id) x, vatout vo, dmbophan b
where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps
order by x.ngayct, x.sohoadon, x.mavt'
where ReportName = N'Báo cáo doanh số bán hàng'

-- Doanh số bán hàng
Update sysReport set Query = N'select x.tenvt as [Mặt hàng], sum(x.ps - x.ck) as [Doanh số] from
(select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, mabp
from mt32, dt32, dmvt v
where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
union all
select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, mabp
from mt33, dt33, dmvt v
where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt
union all
select dt31id, ngayhd, sohoadon, makhct, tenkhct,'''', diengiaict, 0.0, 0.0, ps, case when ttienh <> 0 then tck*ps/ttienh else 0 end, mabp
from mt31, dt31
where mt31.mt31id = dt31.mt31id) x, vatout vo, dmbophan b
where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps
group by x.tenvt
order by x.tenvt'
where ReportName = N'Doanh số bán hàng'

-- Báo cáo doanh số bán hàng theo nhân viên
Update sysReport set Query = N'select x. ngayct, x.sohoadon, x.makh, x.tenkh, x.mavt, x.tenvt, x.soluong, x.gia, x.ps, x.ck, x.ps - x.ck as [Doanh số], vo.thue, x.saleman, (select tenkh from dmkh where x.saleman = dmkh.makh ) as sales
from
	(select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, saleman
	from mt32, dt32, dmvt v
	where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
union all
	select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, saleman
	from mt33, dt33, dmvt v
	where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt
union all
	select dt43id, ngayct, soct, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, 0.0, saleman
	from mt43, dt43, dmvt v
	where mt43.mt43id = dt43.mt43id and dt43.mavt = v.mavt and (left(tkno,3) = ''131'' or left(tkno,3) = ''111'' )
union all
select dt31id, ngayct, sohoadon, makhct, tenkhct,'''', diengiaict, 0.0, 0.0, ps, case when ttienh <> 0 then tck*ps/ttienh else 0 end, saleman
from mt31, dt31
where mt31.mt31id = dt31.mt31id) x, vatout vo, dmkh b
where dt32id *= vo.mtiddt and x.saleman *= b.makh and @@ps
order by x.ngayct, x.sohoadon, x.mavt'
where ReportName = N'Báo cáo doanh số bán hàng theo nhân viên'

ALTER TABLE sysDataConfigDt ALTER COLUMN  Formula [nvarchar](512) NULL
GO

declare @sysTableTHID int,
		@sysTableID int,
		@sysFieldId int,
		@sysDataConfigID int
		
-- 1) Phiếu mua hàng nhập kho
select @sysTableID = sysTableID from sysTable where TableName = 'DT22'
select @sysTableTHID = sysTableID from sysTable where TableName = 'BLVT'

-- Update sysDataConfigDt
-- DonGia
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableTHID and dtTableID = @sysTableID and NhomDK = 'PNM1'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'DonGia'

Update sysDataConfigDt set Formula = N'case when DT22.SoLuong=0 then 0 else ((DT22.Ps-isnull(DT22.TienCK,0)+isnull(TTDBin.TienTTDB,0)+DT22.CPCt)/DT22.SoLuong) end'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula = N'((DT22.Ps - isnull(DT22.TienCK,0) + isnull(TTDBin.TienTTDB,0) + DT22.CPCt)/DT22.SoLuong)'

-- DonGiaNT
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'DonGiaNT'

Update sysDataConfigDt set Formula = N'case when DT22.SoLuong=0 then 0 else ((DT22.PsNT-isnull(DT22.TienCKNT,0)+isnull(TTDBin.TienTTDBNT,0)+DT22.CPCtNT)/DT22.SoLuong) end'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula = N'((DT22.PsNT - isnull(DT22.TienCKNT,0) + isnull(TTDBin.TienTTDBNT,0) + DT22.CPCtNT)/DT22.SoLuong)'

-- 2) Phiếu mua hàng nhập khẩu
select @sysTableID = sysTableID from sysTable where TableName = 'DT23'
select @sysTableTHID = sysTableID from sysTable where TableName = 'BLVT'

-- DonGia
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableTHID and dtTableID = @sysTableID and NhomDK = 'PNK1'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'DonGia'

Update sysDataConfigDt set Formula = N'case when DT23.SoLuong = 0 then 0 else ((DT23.Ps - isnull(DT23.TienCK,0) + isnull(TTDBin.TienTTDB,0) + DT23.CPCt + DT23.CtThueNk)/DT23.SoLuong) end'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula = N'((DT23.Ps - isnull(DT23.TienCK,0) + isnull(TTDBin.TienTTDB,0) + DT23.CPCt + DT23.CtThueNk)/DT23.SoLuong)'

-- DonGiaNT
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'DonGiaNT'

Update sysDataConfigDt set Formula = N'case when DT23.SoLuong = 0 then 0 else ((DT23.Ps - isnull(DT23.TienCK,0) + isnull(TTDBin.TienTTDB,0) + DT23.CPCt + DT23.CtThueNk)/(DT23.SoLuong*MT23.TyGia)) end'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula = N'((DT23.Ps - isnull(DT23.TienCK,0) + isnull(TTDBin.TienTTDB,0) + DT23.CPCt + DT23.CtThueNk)/(DT23.SoLuong*MT23.TyGia))'