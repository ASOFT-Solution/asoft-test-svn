USE [CDT]

-- Sửa kiểu số liệu để lên số lẻ chính xác
Update sysReport set Query = N'select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.CachTinh, fr.LoaiCT, fr.InBaoCao,iscn
	,999999999999999.000000  as [Đầu năm]
	,999999999999999.000000 as [Cuối kỳ]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID
	order by Stt
declare @ngayCt1 datetime
declare @ngayCt2 datetime
	set @ngayCt1=@@NgayCt1
	set @ngayCt2=DATEADD(hh,23,@@NgayCt2)
set @ngayCt1= dateadd(hh,-1,@ngayCt1)
declare cur cursor for select Maso,cachtinh,loaiCt,tk,tkdu,iscn,[Đầu năm],[Cuối kỳ] from t
	open cur
declare @Maso nvarchar (50)
declare @Cachtinh nvarchar(256)
declare @LoaiCt int
declare @tk nvarchar (16)
declare @tkdu nvarchar (16)
declare @iscn bit 
declare @daunam float
declare @cuoiky float
--Tính các ch? tiêu
declare @duno float
declare @duco float
declare @duno1 float
declare @duco1 float
fetch cur  into @Maso,@Cachtinh,@LoaiCt,@tk,@tkdu,@iscn,@daunam,@cuoiky
while @@fetch_status=0
begin
	--L?y s? d?u nam
	if @tk is not null and @loaiCt<>0
	begin
		
		exec sodutaikhoan @tk, @ngayCt1, DEFAULT, @duno OUTPUT , @duco OUTPUT 
		if @iscn=1
			begin	
				set @daunam=0
				if @loaiCt=5 set @daunam=@duno
				if @loaiCt=6 set @daunam=@duco
			end
		if @iscn=0
			begin	
				set @duno1= @duno-@duco 
				set @duco1= @duco-@duno 
				set @daunam=0
				if @loaiCt=5 set @daunam=@duno1
				if @loaiCt=6 set @daunam=@duco1
			end
		

		--L?y s? cu?i k?
		exec sodutaikhoan @tk, @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
	 	if @iscn=1
			begin	
				set @cuoiky=0
				if @loaiCt=5 set @cuoiky=@duno
				if @loaiCt=6 set @cuoiky=@duco
			end
		if @iscn=0
			begin	
				set @duno1= @duno-@duco 
				set @duco1= @duco-@duno 
					set @cuoiky=0
				if @loaiCt=5 set @cuoiky=@duno1
				if @loaiCt=6 set @cuoiky=@duco1
			end

		UPDATE t SET [Đầu năm]=@daunam where Maso=@Maso
		UPDATE t SET [Cuối kỳ]=@cuoiky where Maso=@Maso
		
	end
	fetch cur  into @Maso,@cachtinh, @LoaiCt,@tk,@tkdu,@iscn,@daunam,@cuoiky
end
close cur
deallocate cur
update t set [Đầu năm]=0,[Cuối kỳ]=0 where loaict=0
select * from t
drop table t'
where ReportName = N'Bảng cân đối kế toán'

-- Sửa kiểu số liệu để lên số lẻ chính xác
Update sysReport set Query = N'select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.CachTinh, fr.LoaiCT, fr.InBaoCao
	,999999999999999.000000  as [Kỳ trước]
	,999999999999999.000000 as [Kỳ này]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID
	order by Stt

declare @ngayCt1 datetime
declare @ngayCt2 datetime
declare @ngayCt3 datetime
declare @ngayCt4 datetime
	set @ngayCt1=@@NgayCt1--''03/01/2008''
	--set @ngayCt1= dateadd(day,-1,@ngayCt1)
	set @ngayCt2=DATEADD(hh,23,@@NgayCt2)--''01/01/2009''
	set @ngayCt3=@@Ngaydktruoc1--''01/01/2008''
	--set @ngayCt3= dateadd(day,-1,@ngayCt3)
	set @ngayCt4=DATEADD(hh,23,@@Ngaydktruoc2)
declare cur cursor for select Maso,loaiCt,tk,tkdu,[Kỳ trước],[Kỳ này] from t
	open cur
declare @Maso nvarchar (50)
declare @LoaiCt int
declare @tk nvarchar (256)
declare @tkdu nvarchar (256)
declare @KyTruoc float
declare @KyNay float
--Tính các ch? tiêu
declare @psno float
declare @psco float
fetch cur  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
while @@fetch_status=0
begin
	--Lay so phat sinh ky truoc
	if @tk is not null and @loaiCt<>0
	begin
		if @tkdu is not null 
		begin		
			set @tkdu = replace(@tkdu,'' '','''')
			set @tkdu='' tkdu like'''''' +replace(@tkdu,'','',''%'''' or tkdu like'''''') + ''%'''''' 
			exec sopstaikhoan @tk, @ngayCt3,@ngayCt4,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
		else exec sopstaikhoan @tk, @ngayCt3,@ngayCt4, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		
		if @loaiCt=3 set @KyTruoc=@psno
		if @loaiCt=4 set @KyTruoc=@psco

		--L?y s? cu?i k?
if @tkdu is not null 
		begin					
			exec sopstaikhoan @tk, @ngayCt1,@ngayCt2,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
else 		exec sopstaikhoan @tk, @ngayCt1,@ngayCt2, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		if @loaiCt=3 set @KyNay=@psno
		if @loaiCt=4 set @KyNay=@psco

		UPDATE t SET [Kỳ trước]=@KyTruoc where Maso=@Maso
		UPDATE t SET [Kỳ này]=@KyNay where Maso=@Maso
		
	end
fetch cur  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
end
close cur
deallocate cur
update t set [Kỳ trước]=0,[Kỳ này]=0 where loaict=0
select * from t
drop table t
drop table t
--update t set daunam=0.1'
where ReportName = N'Báo cáo kết quả kinh doanh'

-- Sửa kiểu số liệu để lên số lẻ chính xác
Update sysReport set Query = N'select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh,  fr.CachTinh, fr.LoaiCT, fr.InBaoCao
	,999999999999999.000000  as [Kỳ trước]
	,999999999999999.000000 as [Kỳ này]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID
	order by Stt

declare @ngayCt1 datetime
declare @ngayCt2 datetime
declare @ngayCt3 datetime
declare @ngayCt4 datetime
	set @ngayCt1=@@NgayCt1--''03/01/2008''
	--set @ngayCt1= dateadd(day,-1,@ngayCt1)
	set @ngayCt2=dateadd(hh,23,@@NgayCt2)
	set @ngayCt3=@@Ngaydktruoc1--''01/01/2008''
	--set @ngayCt3= dateadd(day,-1,@ngayCt3)
	set @ngayCt4=dateadd(hh,23,@@Ngaydktruoc2)
declare cur cursor for select Maso,loaiCt,tk,tkdu,[Kỳ trước],[Kỳ này] from t
	open cur
declare @Maso nvarchar (50)
declare @LoaiCt int
declare @tk nvarchar (1000)
declare @tkdu nvarchar (1000)
declare @KyTruoc float
declare @KyNay float
--Tính các ch? tiêu
declare @psno float
declare @psco float
fetch cur  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
while @@fetch_status=0
begin
	--Lay so phat sinh ky truoc
	if @tk is not null and @loaiCt<>0
	begin
		if @tkdu is not null 
		begin		
			set @tkdu = replace(@tkdu,'' '','''')
			set @tkdu='' tkdu like'''''' +replace(@tkdu,'','',''%'''' or tkdu like'''''') + ''%'''''' 
			exec sopstaikhoan @tk, @ngayCt3,@ngayCt4,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
		else exec sopstaikhoan @tk, @ngayCt3,@ngayCt4, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		
		if @loaiCt=3 set @KyTruoc=@psno
		if @loaiCt=4 set @KyTruoc=@psco

		if @loaict = 1 or @loaict = 2
		begin
			declare @ngayCt datetime
			set @ngayCt= dateadd(hh,-1,@ngayCt3)
			exec sodutaikhoan @tk, @ngayCt, DEFAULT, @PSNO OUTPUT , @PSCO OUTPUT 
			if @loaict = 1 set @KyTruoc = @psno
			if @loaict = 2 set @KyTruoc = @psco
		end
		--L?y s? cu?i k?
if @tkdu is not null 
		begin					
			exec sopstaikhoan @tk, @ngayCt1,@ngayCt2,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
else 		exec sopstaikhoan @tk, @ngayCt1,@ngayCt2, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		if @loaiCt=3 set @KyNay=@psno
		if @loaiCt=4 set @KyNay=@psco

		if @loaict = 1 or @loaict = 2
		begin
			set @ngayCt= dateadd(hh,-1,@ngayCt1)
			exec sodutaikhoan @tk, @ngayCt, DEFAULT, @PSNO OUTPUT , @PSCO OUTPUT 
			if @loaict = 1 set @KyNay = @psno
			if @loaict = 2 set @KyNay = @psco
		end
		UPDATE t SET [Kỳ trước]=@KyTruoc where Maso=@Maso
		UPDATE t SET [Kỳ này]=@KyNay where Maso=@Maso
		
	end
fetch cur  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
end
close cur
deallocate cur
update t set [Kỳ trước]=0,[Kỳ này]=0 where loaict=0
select * from t
drop table t
--update t set daunam=0.1'
where ReportName = N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp'
