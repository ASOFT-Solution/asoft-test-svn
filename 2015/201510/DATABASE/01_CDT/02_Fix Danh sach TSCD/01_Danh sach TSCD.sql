use [CDT]

-- Cập nhật report
update sysReport 
set Query = N'
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
	                select mats,sum((NguyenGia1+NguyenGia2+NguyenGia3+NguyenGia4)/sothang) as KHCBTK 
	                from faNguyenGia where ngayct between @tungay and @denngay group by Mats
	            ) q on r.mats=q.mats 
	left join DMNhomTS nts on r.NhomTS = nts.NhomTS
) as k left join DmBoPhan n on k.mabp = n.mabp, DMTK m 
where k.tkts = m.tk 
and @@ps
order by k.mats
',
mtAlias = 'k'
where ReportName = N'Báo cáo chi tiết TSCD'


-- Cập nhật report filter
update sysReportFilter
set Visible = 0
where sysReportFilterID in
(
    select sysReportFilterID
    from sysReportFilter rf
    left join sysReport r on rf.sysReportID = r.sysReportID
    left join sysField f on rf.sysFieldID = f.sysFieldID
    where ReportName = N'Báo cáo chi tiết TSCD'
    and FieldName = N'Thang'
)


-- Cập nhật từ điển                
if not exists (select top 1 1 from Dictionary where Content = N'Giá trị còn lại')
                insert Dictionary (Content, Content2) values (N'Giá trị còn lại', N'Remaining amount')
                
if not exists (select top 1 1 from Dictionary where Content = N'Mức khấu hao/năm')
                insert Dictionary (Content, Content2) values (N'Mức khấu hao/năm', N'Depreciation expense/year')
                