use [CDT]

-- Tổng hợp chữ T 1 tài khoản
Update sysReport set Query = N'declare @tk varchar(16)
declare @codauky float
declare @nodauky float

declare @cocuoiky float
declare @nocuoiky float

declare @tungay datetime
declare @denngay datetime 
declare @datetemp datetime
declare @ngaydk datetime
declare @dauky float
declare @cuoiky float

set @tungay = @@ngayct1
set @denngay = dateadd(hh,23,@@ngayct2)

set @datetemp = dateadd(hh,1,@denngay)
set @ngaydk=dateadd(hh,-1,@tungay)
set @tk = @@TK

    execute Sodutaikhoan @tk,@ngaydk,''@@ps'',@nodauky output,@codauky       output

    execute Sodutaikhoan @tk,@datetemp,''@@ps'',@nocuoiky output, @cocuoiky        output
select tkdu, TenTk, psno, psco from
(
select 0 as stt, '''' as Tkdu,  case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as TenTK ,@nodauky as PsNo,@codauky as Psco
union all
(
Select 1 as stt, bltk.Tkdu, case when @@lang = 1 then dmtk.Tentk2 else dmtk.Tentk end as TenTK, Sum(PsNo), Sum(PsCo)
from bltk,dmtk
where bltk.Tkdu *= dmtk.tk and  left(bltk.tk,len(@tk)) = @tk and (NgayCt between @tungay and       @denngay) 
group by bltk.tkdu, case when @@lang = 1 then dmtk.Tentk2 else dmtk.Tentk end
)
union all
select 2 as stt, '''' as Tkdu, case when @@lang = 1 then N''End of Period'' else N''Cuối kỳ'' end as TenTK, @nocuoiky as psno,@cocuoiky as psco) x order by stt
'
where ReportName = N'Tổng hợp chữ T 1 tài khoản'

declare @sysTableID as int

select @sysTableID = sysTableID from sysTable
where TableName = 'DMTK'

Update sysField set SmartView = 1
where sysTableID = @sysTableID and FieldName = 'TenTK2'


-- Tổng hợp số dư tài khoản cuối kỳ
Update sysReport set Query = N'declare @ngayct datetime
declare @TK varchar(16)
declare @sql nvarchar (4000)
set @ngayct=@@ngayCt
set @TK=@@TK + ''%''
--phần cân đối công nợ
set @sql=''create view wcongno as 
select tk,makh,sum(dunont) as nodaunt,sum(duno) as nodau,sum(ducont) as codaunt,sum(duco) as codau from obkh where '' + @@ps + '' group by tk, makh having tk like '''''' + @TK + ''''''
union all
select tk,makh,sum(psnont)as nodaunt,sum(psno)as nodau, sum(pscont) as codaunt, sum(psco) as codau from bltk where tk in(select tk from dmtk where tkcongno=1) and ngayct<=cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) and '' + @@ps + '' group by tk, makh having tk like '''''' + @TK + ''''''''

exec (@sql)
set @sql=''create view wcongno1 as
select tk,makh, 
nodaunt=case when sum(nodaunt)-sum(codaunt)>0 then sum(nodaunt)-sum(codaunt) else 0 end ,
nodau=case when sum(nodau)-sum(codau)>0 then sum(nodau)-sum(codau) else 0 end ,
codaunt=case when sum(nodaunt)-sum(codaunt)<0 then sum(codaunt)-sum(nodaunt) else 0 end ,
codau=case when sum(nodau)-sum(codau)<0 then sum(codau)-sum(nodau) else 0 end
from wcongno group by tk, makh''
exec (@sql)
set @sql=''create view wcongno3 as 
select tk, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau from wcongno1 group by tk''
exec (@sql)
--phần cân đối tk thường
set @sql=''create view wthuong as 
select tk,sum(dunont) as nodaunt,sum(duno) as nodau,sum(ducont) as codaunt,sum(duco) as codau from obtk where tk in(select tk from dmtk where tkcongno<>1) and '' + @@ps + '' group by tk having tk like '''''' + @TK + ''''''
union all
select tk,sum(psnont)as nodaunt,sum(psno)as nodau, sum(pscont) as codaunt,sum(psco) as codau from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt <= cast('''''' + convert(nvarchar,@ngayCt) + '''''' as datetime) and '' + @@ps + '' group by tk having tk like '''''' + @TK + ''''''''
exec (@sql)
set @sql=''create view wthuong1 as
select tk, 
nodaunt=case when sum(nodaunt)-sum(codaunt)>0 then sum(nodaunt)-sum(codaunt) else 0 end ,
nodau=case when sum(nodau)-sum(codau)>0 then sum(nodau)-sum(codau) else 0 end ,
codaunt=case when sum(nodaunt)-sum(codaunt)<0 then sum(codaunt)-sum(nodaunt) else 0 end ,
codau=case when sum(nodau)-sum(codau)<0 then sum(codau)-sum(nodau) else 0 end from wthuong group by tk''
exec (@sql)
--lấy số liệu
select b.TkMe as N''TK mẹ'', a.tk as ''Mã tk'', case when @@lang = 1 then b.tentk2 else b.tentk end as N''Tên tài khoản'', a.nodaunt as N''Dư nợ nguyên tệ'', a.nodau as N''Dư nợ'', a.codaunt as N''Dư có nguyên tệ'', a.codau as N''Dư có'' from wcongno3 a inner join dmtk b on a.tk = b.tk
union all
select b.TkMe, a.tk,case when @@lang = 1 then b.tentk2 else b.tentk end, a.nodaunt as nocuoint, a.nodau as nocuoi, a.codaunt as cocuoint, a.codau as cocuoi from wthuong1  a  inner join dmtk b on a.tk = b.tk
order by tkme, a.tk

drop view wcongno
drop view wcongno1
drop view wcongno3
drop view wthuong
drop view wthuong1'
where ReportName = N'Tổng hợp số dư tài khoản cuối kỳ'

-- Bảng cân đối số phát sinh
Update sysReport set Query = N'declare @ngayct datetime
declare @ngayCt1 datetime
declare @sql nvarchar (4000)
set @ngayct=@@ngayCt1
set @ngayct1=dateadd(hh,23,@@ngayCt2)

--phần cân đối công nợ
set @sql=''create view wcongno as 
select tk,makh,0.0 as nodau, 0.0 as codau,sum(psno) as psno,sum(psco) as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno=1) and ngayCt  between cast('''''' + convert(nvarchar,@ngayCt) + '''''' as datetime) and  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) group by tk,makh
union all
select tk,makh,0.0 as nodau, 0.0 as codau,0.0 as psno,0.0 as psco, sum(psno) as lkno, sum(psco) as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno=1) and ngayCt  <=  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) and year(ngayct) = year(cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime)) group by tk,makh
union all
select tk,makh,sum(duno) as nodau,sum(duco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from obkh group by tk, makh
union all
select tk,makh,sum(psno)as nodau, sum(psco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno=1) and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by tk, makh''

exec (@sql)
set @sql=''create view wcongno1 as
select tk,sum(nodau) as nodau, sum(codau) as codau, sum(psno) as psno, sum(psco) as psco, sum(lkno) as lkno, sum(lkco) as lkco, sum(nocuoi) as nocuoi,sum(cocuoi) as cocuoi from wcongno group by tk''
exec (@sql)
set @sql=''create view wcongno2 as
select tk, nodau,  codau, psno,  psco, lkno, lkco,   nocuoi = case when nodau+psno-codau-psco >0 then nodau+psno-codau-psco else 0 end, cocuoi = case when nodau+psno-codau-psco <0 then abs(nodau+psno-codau-psco) else 0 end from wcongno1 ''
exec (@sql)
set @sql=N''create view wcongno3 as 
select tk,  [Nợ đầu] = case when nodau-codau>=0 then nodau-codau else 0 end,  
[Có đầu] = case when nodau-codau<0 then codau-nodau else 0 end, psno,  psco, lkno as [Lũy kế nợ], lkco as [Lũy kế có], [Nợ cuối] = case when nodau+psno-codau-psco >0 then nodau+psno-codau-psco else 0 end, [Có cuối] = case when nodau+psno-codau-psco <0 then abs(nodau+psno-codau-psco) else 0 end from wcongno1''

exec (@sql)
--phần cân đối tk thường
set @sql=''create view wthuong as 
select tk,0.0 as nodau, 0.0 as codau,sum(psno) as psno,sum(psco) as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt between cast('''''' + convert(nvarchar,@ngayCt) + '''''' as datetime) and  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) group by tk
union all
select tk,0.0 as nodau, 0.0 as codau,0.0 as psno,0.0 as psco, sum(psno) as lkno, sum(psco) as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt  <=  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) and year(ngayct) = year(cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime)) group by tk
union all
select tk,sum(duno) as nodau,sum(duco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi  from obtk where tk in(select tk from dmtk where tkcongno<>1) group by tk
union all
select tk,sum(psno) as nodau,sum(psco) as codau,0.0 as psno, 0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt < cast('''''' + convert(nvarchar,@ngayCt) + '''''' as datetime) group by tk''
exec (@sql)
set @sql=''create view wthuong1 as
select tk, sum(nodau) as nodau, sum(codau) as codau, sum(psno) as psno, sum(psco) as psco, sum(lkno) as lkno, sum(lkco) as lkco, sum(nocuoi) as nocuoi,sum(cocuoi) as cocuoi from wthuong group by tk''
exec (@sql)
set @sql=N''create view wthuong2 as
select tk,  [Nợ đầu] = case when nodau-codau>=0 then nodau-codau else 0 end,  
[Có đầu] = case when nodau-codau<0 then codau-nodau else 0 end, psno,  psco, lkno as [Lũy kế nợ], lkco as [Lũy kế có], [Nợ cuối] = case when nodau+psno-codau-psco >0 then nodau+psno-codau-psco else 0 end, [Có cuối] = case when nodau+psno-codau-psco <0 then abs(nodau+psno-codau-psco) else 0 end from wthuong1 ''
exec (@sql)
declare @tnodk decimal(20,6), @cnodk decimal(20,6)
declare @tcodk decimal(20,6), @ccodk decimal(20,6)
declare @tpsno decimal(20,6), @cpsno decimal(20,6)
declare @tpsco decimal(20,6), @cpsco decimal(20,6)
declare @tlkno decimal(20,6), @clkno decimal(20,6)
declare @tlkco decimal(20,6), @clkco decimal(20,6)
declare @tnock decimal(20,6), @cnock decimal(20,6)
declare @tcock decimal(20,6), @ccock decimal(20,6)
select @tnodk= sum([Nợ đầu]), @tcodk = sum([Có đầu]),
	@tpsno = sum(psno), @tpsco = sum(psco),
	@tlkno = sum([Lũy kế nợ]), @tlkco = sum([Lũy kế có]),
	@tnock = sum([Nợ cuối]), @tcock = sum([Có cuối]) from wthuong2
select @cnodk= sum([Nợ đầu]), @ccodk = sum([Có đầu]),
	@cpsno = sum(psno), @cpsco = sum(psco),
	@clkno = sum([Lũy kế nợ]), @clkco = sum([Lũy kế có]),
	@cnock = sum([Nợ cuối]), @ccock = sum([Có cuối]) from wcongno3

select b.TkMe,a.Tk,case when @@lang = 1 then b.tentk2 else b.tentk end as tentk,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wcongno3 a inner join dmtk b on a.tk = b.tk
union all
select b.TkMe,a.Tk,case when @@lang = 1 then b.tentk2 else b.tentk end as tentk,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wthuong2  a  inner join dmtk b on a.tk = b.tk
union all
select '''' as TkMe,''T'' as Tk, case when @@lang = 1 then N''Total'' else N''Tổng cộng'' end as tentk, @tnodk + @cnodk as nodau, @tcodk + @ccodk as codau,@tpsno + @cpsno as psno, @tpsco + @cpsco as psco, @tlkno + @clkno as lkno, @tlkco + @clkco as lkco,@tnock + @cnock as nocuoi, @tcock + @ccock as cocuoi
order by tkme, a.tk

drop view wcongno
drop view wcongno1
drop view wcongno2
drop view wcongno3
drop view wthuong
drop view wthuong1
drop view wthuong2'
where ReportName = N'Bảng cân đối số phát sinh'

Update sysReport set TreeData = N'select Tk, TkMe, case when @@lang = 1 then TenTk2 else TenTk end as TenTk from DMTK'
where ReportName = N'Bảng cân đối số phát sinh'

-- Bảng cân đối kế toán
Update sysReport set Query = N'select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.CachTinh, fr.LoaiCT, fr.InBaoCao,iscn
	,999999999999999.0  as [Đầu năm]
	,999999999999999.0 as [Cuối kỳ]
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
drop table t
'
where ReportName = N'Bảng cân đối kế toán'

-- Báo cáo kết quả kinh doanh
Update sysReport set Query = N'select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.CachTinh, fr.LoaiCT, fr.InBaoCao
	,999999999999999.0  as [Kỳ trước]
	,999999999999999.0 as [Kỳ này]
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
--update t set daunam=0.1
'
where ReportName = N'Báo cáo kết quả kinh doanh'

-- Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp
Update sysReport set Query = N'select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh,  fr.CachTinh, fr.LoaiCT, fr.InBaoCao
	,999999999999999.0  as [Kỳ trước]
	,999999999999999.0 as [Kỳ này]
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
--update t set daunam=0.1
'
where ReportName = N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp'

-- Sổ quỹ tiền mặt
Update sysReport set Query = N'declare @tkrp nvarchar(20)
declare @dauky float,@daukynt float
declare @thu float,@thunt float
declare @chi float,@chint float
declare @ton float
declare @tonnt float
declare @id int
declare @tungayCt datetime,@ngaydk datetime
declare @denngayCt datetime
set @tuNgayCt=@@NgayCT1
set @denNgayCt=dateadd(hh,23,@@NgayCT2)
set @ngaydk=dateadd(hh,-1,@tungayct)
set @tkrp=@@TK

declare @nodk float,@nodknt float
declare @codk float,@codknt float
	exec sodutaikhoannt @tkrp,@ngaydk,''@@ps'',@Nodk output, @Codk output,@NoDkNt output, @CoDkNt output
set @dauky = @nodk
set @daukynt = @nodknt
declare cur cursor for 
SELECT min(bltkID) as  bltkID, sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(PsNoNt) as TienThuNt, sum(PsCoNt) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS group by MTID, NgayCT,SoCT order by NgayCT,SoCT

create table #t
 (
	[bltkID] [int]   NULL ,	
	[Thu] [decimal](18, 3) NULL ,
	[Chi] [decimal](18, 3) NULL ,
	[ThuNt] [decimal](18, 3) NULL ,
	[ChiNt] [decimal](18, 3) NULL ,
	[ton] [decimal](18, 3) NULL,
	[tonNt] [decimal](18, 3) NULL  
) ON [PRIMARY]

insert into #t select min(bltkID) as bltkID,sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(PsNoNt) as TienThuNt, sum(PsCoNt) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS group by MTID, NgayCT,SoCT order by ngayCT,SoCT
declare @tmp float,@tmpnt float
set @tmp=@dauky
set @tmpnt = @daukynt
open cur
fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt
while @@fetch_status=0
begin
	set @ton=@tmp+@thu-@chi
	set @tmp=@ton
	set @tonnt=@tmpnt+@thunt-@chint
	set @tmpnt=@tonnt
	UPDATE #t SET ton=@ton,tonnt=@tonnt where bltkid=@id
	fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt
	
end
close cur
deallocate cur

select x.*,dmkh.tenkh
from
((
select '''' as bltkid ,'''' as soct,null as ngayct,'''' as ongba , '''' as maKH, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as diengiai, '''' as tkdu,'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt)
union all
(SELECT a.bltkid, a.SoCT, a.NgayCT,a.OngBa as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1
from bltk a, #t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by stt, ngayct,soct
drop table #t'
where ReportName = N'Sổ quỹ tiền mặt'

-- Sổ tiền gởi ngân hàng
Update sysReport set Query = N'declare @tkrp nvarchar(20)
declare @dauky float,@daukynt float

declare @thu float,@thunt float
declare @chi float,@chint float
declare @ton float
declare @tonnt float
declare @id int
declare @tungayCt datetime,@ngaydk datetime
declare @denngayCt datetime
set @tuNgayCt=@@NgayCT1
set @denNgayCt=dateadd(hh,23,@@NgayCT2)
set @ngaydk=dateadd(hh,-1,@tungayct)
set @tkrp=@@TK

declare @nodk float,@nodknt float
declare @codk float,@codknt float
	exec sodutaikhoannt @tkrp,@ngaydk,''@@ps'',@Nodk output, @Codk output,@NoDkNt output, @CoDkNt output
set @dauky = @nodk
set @daukynt = @nodknt
declare cur cursor for 
SELECT bltkID, PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS order by NgayCT,SoCT

create table #t
 (
	[bltkID] [int]   NULL ,	
	[Thu] [decimal](18, 3) NULL ,
	[Chi] [decimal](18, 3) NULL ,
	[ThuNt] [decimal](18, 3) NULL ,
	[ChiNt] [decimal](18, 3) NULL ,
	[ton] [decimal](18, 3) NULL,
	[tonNt] [decimal](18, 3) NULL  
) ON [PRIMARY]

insert into #t select bltkID ,PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS order by ngayCT,SoCT
declare @tmp float,@tmpnt float
set @tmp=@dauky
set @tmpnt = @daukynt
open cur
fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt
while @@fetch_status=0
begin
	set @ton=@tmp+@thu-@chi
	set @tmp=@ton
	set @tonnt=@tmpnt+@thunt-@chint
	set @tmpnt=@tonnt
	UPDATE #t SET ton=@ton,tonnt=@tonnt where bltkid=@id
	fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt
	
end
close cur
deallocate cur

select x.*,dmkh.tenkh
from
((
select '''' as bltkid ,'''' as soct,null as ngayct,'''' as ongba , '''' as maKH, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as diengiai, '''' as tkdu,'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt )
union all
(SELECT a.bltkid, a.SoCT, a.NgayCT,a.OngBa as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1
from bltk a, #t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by Stt, ngayct,soct
drop table #t'
where ReportName = N'Sổ tiền gởi ngân hàng'

-- Sổ chi tiết công nợ khách hàng
Update sysReport set Query = N'declare @kh varchar(16)
declare @tkrp varchar(16)
declare @nocodk bit
declare @nocock bit
set @tkrp=@@TK
set @kh=@@MaKH
declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @NgayCt1=cast(@@ngayct1 as datetime)
set @NgayCt2=cast(@@ngayct2 as datetime)
declare @dauky float, @daukynt float
--tìm số dư đầu kỳ=Số dư đầu năm + số phát sinh trước ngàyCt1
	
	declare @daunam float, @daunamnt float
	declare @count1 int 
	--Số phát inh đầu năm
	set @daunamnt=(SELECT sum(Dunont-Ducont) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunam=(SELECT sum(Duno-Duco) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @count1=(select count(*) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunamnt = case when @count1<>0 then @daunamnt else 0 end
	set @daunam = case when @count1<>0 then @daunam else 0 end
	set @daukynt=(select sum(psNont)-sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @dauky=(select sum(psNo)-sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @daukynt=case when @count1>0 then @daukynt else 0 end
	set @dauky=case when @count1>0 then @dauky else 0 end

	set @daukynt=@daukynt + @daunamnt
	set @dauky=@dauky + @daunam
	set @nocodk = case when @dauky>=0 then 1 else 0 end

--tìm số dư cuối kỳ
	declare @psNo float, @psNont float
	declare @psCo float, @psCont float
	declare @cuoiky float, @cuoikynt float
	set @psNont=(select sum(psNont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCont=(select sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNo=(select sum(psNo)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCo=(select sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNont=case when @count1>0 then @psNont else 0 end
	set @psCont=case when @count1>0 then @psCont else 0 end
	set @psNo=case when @count1>0 then @psNo else 0 end
	set @psCo=case when @count1>0 then @psCo else 0 end
	set @cuoikynt=@daukynt + @psNont-@psCont
	set @cuoiky=@dauky + @psNo-@psCo
	set @nocock = case when @cuoiky>=0 then 1 else 0 end

--Lấy số phát sinh

declare @nophatsinh float, @nophatsinhnt float
declare @phatsinhco float, @phatsinhcont float
select @nophatsinhnt=sum(psnont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhcont=sum(pscont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @nophatsinh=sum(psno) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhco=sum(psco) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps

select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Beginning amount'' else N''Số dư đầu kỳ'' end as diengiai,
null as tkdu,psnont=case when @nocodk=0 then 0 else @daukynt end,psno=case when @nocodk=0 then 0 else @dauky end,
pscont=case when @nocodk=0 then abs(@daukynt) else 0 end,psco=case when @nocodk=0 then abs(@dauky) else 0 end, null as makh, null as tenkh, 0 as Stt
union  all
select ngayCt,MTID, maCT,SoCt,diengiai,tkdu,psnont,psno,pscont,psco ,maKH,tenkh,1 from bltk
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Total of arinsing'' else N''Tổng phát sinh'' end as diengiai,
null as tkdu,@nophatsinhnt as sopsnt,@nophatsinh as sops,@phatsinhcont as pscont,@phatsinhco as psco, null as makh, null as tenkh,2
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Closing amount'' else N''Số dư cuối kỳ'' end as diengiai,
null as tkdu,sopsnt=case when @nocock=0 then 0 else @cuoikynt end,sops=case when @nocock=0 then 0 else @cuoiky end,
pscont=case when @nocock=0 then abs(@cuoikynt) else 0 end, psco=case when @nocock=0 then abs(@cuoiky) else 0 end, null as makh, null as tenkh, 3
order by stt,ngayCt, soct, tkdu'
where ReportName = N'Sổ chi tiết công nợ khách hàng'

-- Thẻ Kho
Update sysReport set Query = N'declare @mavt varchar(16), @makho varchar(16), @ngayct1 datetime, @ngayct2 datetime
set @mavt = @@mavt
set @makho = @@makho
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)

declare @sln decimal(18,3), @slx decimal(18,3), @slton decimal(18,3), @dk decimal(18,3), @gtdk decimal(18,3), @id int

select @dk = Sum(Soluong) - Sum(SoLuong_x), @gtdk = sum(psno) - sum(psco)
	from(
	select soluong, soluong_x, psno, psco from blvt where NgayCT < @ngayct1 and MaKho=@makho and  MaVT = @mavt
	union all
	select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco from obvt where MaKho=@makho and  MaVT = @mavt
	union all
	select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco from obntxt where MaKho=@makho and  MaVT = @mavt) x

declare cur cursor for 
select blvtid, soluong, soluong_x, 0.0 as slton
from blvt
where NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and MaVT = @mavt
order by NgayCT, SoCT
create table #t
 (
	[blvtID] [int]   NULL ,	
	[sln] [decimal](18, 3) NULL ,
	[slx] [decimal](18, 3) NULL ,
	[slton] [decimal](18, 3) NULL 
) ON [PRIMARY]

insert into #t select blvtid, soluong, soluong_x, 0.0 as slton
from blvt
where NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and MaVT = @mavt
order by NgayCT, SoCT

declare @tmp decimal(18,3)
if (@dk is not null)
	set @tmp = @dk
else
	set @tmp = 0
open cur
fetch cur  into @ID,@sln,@slx,@slton
while @@fetch_status=0
begin
	set @slton=@tmp+@sln-@slx
	set @tmp=@slton
	UPDATE #t SET slton=@slton where blvtid=@id
	fetch cur  into @ID,@sln,@slx,@slton
	
end
close cur
deallocate cur

select y.tenvt,z.tenkho, x.* from (
                select null NgayCT, null SoCT, null TenKH, case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end as DienGiai, null DonGia,@mavt mavt,@makho makho,
		 null SoLuong, @gtdk as [Giá trị nhập], null SoLuong_X, null [Giá trị xuất], @dk as SlTon
	union all
	Select NgayCT, SoCT, dmkh.TenKH , DienGiai, DonGia,@mavt mavt,@makho makho,
		SoLuongN = #t.sln, GiaTriN = case when PsNo > 0 then PsNo else null end,
		SoLuongX = #t.slx, GiaTriX = case when PsCo > 0 then PsCo else null end, SlTon = #t.SlTon
	from blvt, dmkh, #t
	where #t.blvtid = blvt.blvtid and blvt.MaKH *= dmkh.MaKH and NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and MaVT = @mavt) x, dmvt y,dmkho z
where x.mavt =y.mavt and x.makho=z.makho
order by NgayCT, SoCT

drop table #t'
where ReportName = N'Thẻ Kho'

-- Sổ chi tiết vật tư
Update sysReport set Query = N'declare @pstk float
declare @sltk float
set @sltk=(select sum(soluong)-sum(soluong_X) from blvt where NGAYCT < @@ngayct1 AND  MAVT = @@mavt  AND @@ps)
 set @sltk=case when @sltk is  null then 0 else @sltk end
set @pstk=(select sum(psno)-sum(psco) from blvt where NGAYCT < @@ngayct1 AND  MAVT = @@mavt  AND @@ps)
 set @pstk=case when @pstk is  null then 0 else @pstk end
declare @psdk float, @psdk1 float
declare @sldk float, @sldk1 float

set @sldk=(select sum(soluong) from obvt where   MAVT = @@mavt  AND @@ps) 
set @sldk1=(select sum(soluong) from obntxt where   MAVT = @@mavt  AND @@ps)
 set @sldk=case when @sldk is  null then 0 else @sldk end + case when @sldk1 is  null then 0 else @sldk1 end
set @psdk=(select sum(dudau) from obvt where  MAVT = @@mavt  AND @@ps)
set @psdk1=(select sum(dudau) from obntxt where  MAVT = @@mavt  AND @@ps)
 set @psdk=case when @psdk is  null then 0 else @psdk end + case when @psdk1 is  null then 0 else @psdk1 end
select y.tenvt, x.* from (

SELECT NULL NGAYCT,null as MACT, NULL AS MTID, NULL SOCT, NULL TENKH, case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end as DIENGIAI, NULL DONGIA, @@mavt mavt,
	 @sltk + @sldk soluong, @pstk+@psdk [Giá trị nhập], NULL SOLUONG_X, NULL [Giá trị xuất]
UNION all
SELECT NGAYCT,MACT,MTID, SOCT, DMKH.TENKH , DIENGIAI, DONGIA,   @@mavt mavt,
	SOLUONGN = CASE WHEN SOLUONG > 0 THEN SOLUONG ELSE NULL END, GIATRIN = CASE WHEN PSNO > 0 THEN PSNO ELSE NULL END,
	SOLUONGX = CASE WHEN SOLUONG_X > 0 THEN SOLUONG_X ELSE NULL END, GIATRIX = CASE WHEN PSCO > 0 THEN PSCO ELSE NULL END
FROM BLVT, DMKH
WHERE BLVT.MAKH *= DMKH.MAKH AND NGAYCT BETWEEN @@ngayct1 AND @@ngayct2 AND   MAVT = @@mavt AND @@ps) x, dmvt y 
where x.mavt=y.mavt
'
where ReportName = N'Sổ chi tiết vật tư'

-- Sổ cái CTGS
Update sysReport set Query = N'declare @nodauky float
declare @codauky float

declare @nocuoiky float
declare @cocuoiky float

declare @Tongpsno float
declare @Tongpsco float

declare @tungay datetime
declare @denngay datetime 

set @tungay = @@Ngayct1
set @denngay = dateadd(hh,23,@@Ngayct2)

declare @datetemp datetime
set @datetemp = dateadd(d,1,@denngay)
declare @datetemptungay datetime
set @datetemptungay = dateadd(hh,-1,@tungay)
declare @tk varchar(10)
set @tk = @@tk

execute Sodutaikhoan @tk,@datetemptungay,''@@ps'',@nodauky output,@codauky output

execute Sodutaikhoan @tk,@denngay,''@@ps'',@nocuoiky output, @cocuoiky output

execute Sopstaikhoan @tk,@tungay,@denngay,''@@ps'',@Tongpsno output,@Tongpsco output

	(
	Select null as MaCT, null as [Ngày ghi sổ], '''' as SoCT,null  as NgayCT, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as DienGiai, ''''as Tkdu, @nodauky as PsNo,@codauky as Psco,'''' as Ghichu, 0 as Stt
	)
union all
	(
	Select mact, dbo.LayNgayGhiSo(NgayCT) as [Ngày ghi sổ], SoCt, NgayCT, DienGiai, Tkdu, PsNo, Psco, '''' as Ghichu,1
	from bltk
	where left(tk,len(@tk)) = @tk and  (NgayCt between @tungay and       @denngay) 
	)
union all
	(
	Select null as  mact,null  as [Ngày ghi sổ], '''',null , case when @@lang = 1 then N''Arising Total'' else N''Tổng phát sinh'' end as DienGiai, ''''as Tkdu,@Tongpsno as PsNo,@Tongpsco as Psco,'''' as Ghichu,2
	)
union all
	(
	Select null as  mact,null , '''',null , case when @@lang = 1 then N''End of Period'' else N''Cuối kỳ'' end as DienGiai, ''''as Tkdu,@nocuoiky as PsNo,@cocuoiky as Psco,'''' as Ghichu,3
	)
order by stt, ngayct, soct'
where ReportName = N'Sổ cái CTGS'

-- Sổ chi tiết tài khoản
Update sysReport set Query = N'declare @tkrp varchar(16)
set @tkrp=@@TK
declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @NgayCt1=@@NgayCt1
set @NgayCt2=dateadd(hh,23,@@NgayCt2)
set @ngayct1=dateadd(hh,-1,@ngayct1)
--L?y s? d?u k?
declare @nodk float
declare @codk float
	exec sodutaikhoan @tkrp,@ngayCt1,''@@ps'',@nodk output, @codk output
set @ngayct1=dateadd(hh,1,@ngayct1)
--L?y s?  phát sinh
declare @nock float
declare @cock float
	exec sodutaikhoan @tkrp,@ngayCt2,''@@ps'',@nock output, @cock output
declare @nophatsinh float
declare @phatsinhco float
select @nophatsinh=sum(psno) from bltk where ngayct between @@ngayct1 and @@ngayct2 and tk like @@tk+''%'' and @@ps
select @phatsinhco=sum(psco) from bltk where ngayct between @@ngayct1 and @@ngayct2 and tk like @@tk+''%'' and @@ps
select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as diengiai,
null as tkdu,@nodk as psno,@codk as psco, null as makh, null  as tenkh, 0 as Stt
union  all
select a.ngayCt,MTID, a.mact, a.SoCt, a.diengiai, a.tkdu, a.psno, a.psco, a.maKH, b.tenkh, 1 
from bltk a, dmkh b 
where a.makh*=b.makh and  left(a.tk,len(@tkrp))=@tkrp and (a.ngayCt between @ngayCT1 and @ngayCT2 ) and @@ps
union all
select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''Arising Total'' else N''Tổng phát sinh'' end as diengiai,
   null as tkdu, @nophatsinh as psno, @phatsinhco  as psco, null as makh, null as tenkh, 2
union all
select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''End of Period'' else N''Cuối kỳ'' end as Diengiai,
   null as tkdu, @nock as psno, @cock as psco, null as makh, null as tenkh, 3
order by Stt,Ngayct,mact desc'
where ReportName = N'Sổ chi tiết tài khoản'

-- Dictionary
if not exists (select top 1 1 from Dictionary where Content = N'F2-Tạo bút toán')
	Insert into Dictionary(Content,Content2) Values (N'F2-Tạo bút toán', N'F2-Post to ledger')

if not exists (select top 1 1 from Dictionary where Content = N'F4-Xóa bút toán')	
	Insert into Dictionary(Content,Content2) Values (N'F4-Xóa bút toán', N'F4-Delete posted')
	
if not exists (select 1 from Dictionary where Content = N'Họ và tên người nhận tiền :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Họ và tên người nhận tiền :', N'Received from :');
if not exists (select 1 from Dictionary where Content = N'Địa chỉ :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Địa chỉ :', N'Address :');
if not exists (select 1 from Dictionary where Content = N'Lý do chi :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Lý do chi :', N'Description :');
if not exists (select 1 from Dictionary where Content = N'Kèm theo ') INSERT INTO Dictionary (Content, Content2) VALUES (N'Kèm theo ', N'Attached :');
if not exists (select 1 from Dictionary where Content = N'( Viết bằng chữ ) :') INSERT INTO Dictionary (Content, Content2) VALUES (N'( Viết bằng chữ ) :', N'( In words ) :');
if not exists (select 1 from Dictionary where Content = N'Chứng từ gốc') INSERT INTO Dictionary (Content, Content2) VALUES (N'Chứng từ gốc', N'Original voucher');
if not exists (select 1 from Dictionary where Content = N'( Ký, họ tên, đóng dấu )') INSERT INTO Dictionary (Content, Content2) VALUES (N'( Ký, họ tên, đóng dấu )', N'(Sign, full name, Seal)');
if not exists (select 1 from Dictionary where Content = N'( Ký, họ tên )') INSERT INTO Dictionary (Content, Content2) VALUES (N'( Ký, họ tên )', N'(Signature, full name)');
if not exists (select 1 from Dictionary where Content = N'Đã nhận đủ số tiền ( viết bằng chữ ) :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Đã nhận đủ số tiền ( viết bằng chữ ) :', N'Received amount (in words) :');
if not exists (select 1 from Dictionary where Content = N'+ Tỷ giá ngoại tệ ( vàng bạc, đá quý ):') INSERT INTO Dictionary (Content, Content2) VALUES (N'+ Tỷ giá ngoại tệ ( vàng bạc, đá quý ):', N'Exchange Rate (gold, Silver, Precious stones) :');
if not exists (select 1 from Dictionary where Content = N'+ Số tiền quy đổ :') INSERT INTO Dictionary (Content, Content2) VALUES (N'+ Số tiền quy đổ :', N'Equivalent amount :');
if not exists (select 1 from Dictionary where Content = N'năm') INSERT INTO Dictionary (Content, Content2) VALUES (N'năm', N'year');
if not exists (select 1 from Dictionary where Content = N'Quyển số :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Quyển số :', N'Volume number :');
if not exists (select 1 from Dictionary where Content = N'Số :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Số :', N'No :');
if not exists (select 1 from Dictionary where Content = N'Nợ :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Nợ :', N'Debit :');
if not exists (select 1 from Dictionary where Content = N'Có :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Có :', N'Credit :');
if not exists (select 1 from Dictionary where Content = N'Mẫu số 02 - TT') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mẫu số 02 - TT', N'Form no 02-TT');
if not exists (select 1 from Dictionary where Content = N'( Liên gửi ra ngoài phải đóng dấu )') INSERT INTO Dictionary (Content, Content2) VALUES (N'( Liên gửi ra ngoài phải đóng dấu )', N'(To be sent out to seal)');
if not exists (select 1 from Dictionary where Content = N'Mẫu số 01 - TT') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mẫu số 01 - TT', N'Form no 01-TT');
if not exists (select 1 from Dictionary where Content = N'Lý do nộp :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Lý do nộp :', N'Reason :');
if not exists (select 1 from Dictionary where Content = N'PHIẾU THU') INSERT INTO Dictionary (Content, Content2) VALUES (N'PHIẾU THU', N'RECEIPT VOUCHER');
if not exists (select 1 from Dictionary where Content = N'Họ và tên người nộp tiền :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Họ và tên người nộp tiền :', N'Received from :');
if not exists (select 1 from Dictionary where Content = N' - Sổ này có') INSERT INTO Dictionary (Content, Content2) VALUES (N' - Sổ này có', N'This book has');
if not exists (select 1 from Dictionary where Content = N'trang, đánh số từ trang ') INSERT INTO Dictionary (Content, Content2) VALUES (N'trang, đánh số từ trang ', N'page, from page');
if not exists (select 1 from Dictionary where Content = N'đến trang') INSERT INTO Dictionary (Content, Content2) VALUES (N'đến trang', N'to page');
if not exists (select 1 from Dictionary where Content = N' - Ngày mở Sổ') INSERT INTO Dictionary (Content, Content2) VALUES (N' - Ngày mở Sổ', N'Opening date :');
if not exists (select 1 from Dictionary where Content = N'(Ký, họ tên, đóng dấu)') INSERT INTO Dictionary (Content, Content2) VALUES (N'(Ký, họ tên, đóng dấu)', N'(Sign, full name, Seal)');
if not exists (select 1 from Dictionary where Content = N'..................., ngày.......tháng.......năm 20.....') INSERT INTO Dictionary (Content, Content2) VALUES (N'..................., ngày.......tháng.......năm 20.....', N'……………, date……month…..year 20…');
if not exists (select 1 from Dictionary where Content = N'Tổng cộng phát sinh nợ') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tổng cộng phát sinh nợ', N'Arising debit total');
if not exists (select 1 from Dictionary where Content = N'Tổng cộng phát sinh có') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tổng cộng phát sinh có', N'Arising credit total');
if not exists (select 1 from Dictionary where Content = N'Số dư cuối') INSERT INTO Dictionary (Content, Content2) VALUES (N'Số dư cuối', N'Closing value');
if not exists (select 1 from Dictionary where Content = N'- Họ và tên người giao :') INSERT INTO Dictionary (Content, Content2) VALUES (N'- Họ và tên người giao :', N' - Name of inventory deliverer :');
if not exists (select 1 from Dictionary where Content = N'Nhập tại kho :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Nhập tại kho :', N'To put stock :');
if not exists (select 1 from Dictionary where Content = N'Mẫu số 01 - VT') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mẫu số 01 - VT', N'Form no 01-VT');
if not exists (select 1 from Dictionary where Content = N'địa điểm') INSERT INTO Dictionary (Content, Content2) VALUES (N'địa điểm', N'Location');
if not exists (select 1 from Dictionary where Content = N'Theo  chứng từ') INSERT INTO Dictionary (Content, Content2) VALUES (N'Theo  chứng từ', N'According voucher');
if not exists (select 1 from Dictionary where Content = N'Thực  nhập') INSERT INTO Dictionary (Content, Content2) VALUES (N'Thực  nhập', N'Net inward');
if not exists (select 1 from Dictionary where Content = N'Tên, nhãn hiệu, quy cách, phẩm chất vật tư, dụng cụ sản phẩm, hàng hóa') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tên, nhãn hiệu, quy cách, phẩm chất vật tư, dụng cụ sản phẩm, hàng hóa', N'The name, brand,specifications, quality of materials and tools products and goods');
if not exists (select 1 from Dictionary where Content = N'Cộng') INSERT INTO Dictionary (Content, Content2) VALUES (N'Cộng', N'Sub Total');

if not exists (select 1 from Dictionary where Content = N'Thủ kho') INSERT INTO Dictionary (Content, Content2) VALUES (N'Thủ kho', N'Storekeeper');
if not exists (select 1 from Dictionary where Content = N'Liên 1') INSERT INTO Dictionary (Content, Content2) VALUES (N'Liên 1', N'Copy 1');
if not exists (select 1 from Dictionary where Content = N'Liên 2') INSERT INTO Dictionary (Content, Content2) VALUES (N'Liên 2', N'Copy 2');
if not exists (select 1 from Dictionary where Content = N'Trang') INSERT INTO Dictionary (Content, Content2) VALUES (N'Trang', N'Page');
if not exists (select 1 from Dictionary where Content = N'Đơn vị :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Đơn vị :', N'Company :');
if not exists (select 1 from Dictionary where Content = N'………., ngày…..tháng…..năm 20…') INSERT INTO Dictionary (Content, Content2) VALUES (N'………., ngày…..tháng…..năm 20…', N'………., date…..month…..year 20…');
if not exists (select 1 from Dictionary where Content = N'Theo chứng từ') INSERT INTO Dictionary (Content, Content2) VALUES (N'Theo chứng từ', N'According voucher');
if not exists (select 1 from Dictionary where Content = N'Thực nhập') INSERT INTO Dictionary (Content, Content2) VALUES (N'Thực nhập', N'Net inward');
if not exists (select 1 from Dictionary where Content = N' - Tổng Số tiền ( viết bằng chữ )') INSERT INTO Dictionary (Content, Content2) VALUES (N' - Tổng Số tiền ( viết bằng chữ )', N'In words');
if not exists (select 1 from Dictionary where Content = N' - Số chứng từ gốc kèm Theo') INSERT INTO Dictionary (Content, Content2) VALUES (N' - Số chứng từ gốc kèm Theo', N'Original refno following');
if not exists (select 1 from Dictionary where Content = N'Tổng cộng trang') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tổng cộng trang', N'Page total');
if not exists (select 1 from Dictionary where Content = N' - Lý do xuất kho') INSERT INTO Dictionary (Content, Content2) VALUES (N' - Lý do xuất kho', N' - Reason warehousing');
if not exists (select 1 from Dictionary where Content = N' - xuất tại kho (ngăn lô)') INSERT INTO Dictionary (Content, Content2) VALUES (N' - xuất tại kho (ngăn lô)', N' - Pay out stock (Lot, compartment)');
if not exists (select 1 from Dictionary where Content = N'Địa chỉ (bộ phận) :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Địa chỉ (bộ phận) :', N'Address (department):');
if not exists (select 1 from Dictionary where Content = N'Mẫu số 02 - VT') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mẫu số 02 - VT', N'Form no 02-VT');
if not exists (select 1 from Dictionary where Content = N'Yêu cầu') INSERT INTO Dictionary (Content, Content2) VALUES (N'Yêu cầu', N'Request');
if not exists (select 1 from Dictionary where Content = N'Thực xuất') INSERT INTO Dictionary (Content, Content2) VALUES (N'Thực xuất', N'Real outward');
if not exists (select 1 from Dictionary where Content = N'Họ và tên người nhận hàng :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Họ và tên người nhận hàng :', N'Full name of receiver :');
if not exists (select 1 from Dictionary where Content = N'- Người giao dịch :') INSERT INTO Dictionary (Content, Content2) VALUES (N'- Người giao dịch :', N' - Traders ');
if not exists (select 1 from Dictionary where Content = N'- Đơn vị') INSERT INTO Dictionary (Content, Content2) VALUES (N'- Đơn vị', N' - Company');
if not exists (select 1 from Dictionary where Content = N'- Địa chỉ') INSERT INTO Dictionary (Content, Content2) VALUES (N'- Địa chỉ', N' - Address');
if not exists (select 1 from Dictionary where Content = N'- Số hóa Đơn') INSERT INTO Dictionary (Content, Content2) VALUES (N'- Số hóa Đơn', N' - No Voucher');
if not exists (select 1 from Dictionary where Content = N'Đơn vị bán hàng:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Đơn vị bán hàng:', N'Company name:');
if not exists (select 1 from Dictionary where Content = N'Địa chỉ:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Địa chỉ:', N'Address :');
if not exists (select 1 from Dictionary where Content = N'Số tài khoản:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Số tài khoản:', N'Account No: ');
if not exists (select 1 from Dictionary where Content = N'Họ và tên người  mua hàng :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Họ và tên người  mua hàng :', N'Full name of buyer');
if not exists (select 1 from Dictionary where Content = N'Đơn vị:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Đơn vị:', N'Customer name :');
if not exists (select 1 from Dictionary where Content = N'. Ngân hàng:') INSERT INTO Dictionary (Content, Content2) VALUES (N'. Ngân hàng:', N'. Bank name :');
if not exists (select 1 from Dictionary where Content = N'Tên hàng hóa dịch vụ') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tên hàng hóa dịch vụ', N'Description ');
if not exists (select 1 from Dictionary where Content = N'Cộng tiền hàng:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Cộng tiền hàng:', N'Total :');
if not exists (select 1 from Dictionary where Content = N'Tiền thuế GTGT:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tiền thuế GTGT:', N'VAT Amount :');
if not exists (select 1 from Dictionary where Content = N'Tiền chiết khấu:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tiền chiết khấu:', N'Discount amount :');
if not exists (select 1 from Dictionary where Content = N'Tổng tiền thanh toán:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tổng tiền thanh toán:', N'Total payment :');
if not exists (select 1 from Dictionary where Content = N'Thuế suất GTGT:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Thuế suất GTGT:', N'VAT Rate : ');
if not exists (select 1 from Dictionary where Content = N'Hình thức thanh toán:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Hình thức thanh toán:', N'Forms of payment:');
if not exists (select 1 from Dictionary where Content = N'Mẫu số: 01 GTKT - 3LL') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mẫu số: 01 GTKT - 3LL', N'Form no: 01 GTKT-3LL');
if not exists (select 1 from Dictionary where Content = N'Ký hiệu:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Ký hiệu:', N'Series:');
if not exists (select 1 from Dictionary where Content = N'Số:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Số:', N'No :');
if not exists (select 1 from Dictionary where Content = N'HÓA ĐƠN GIÁ TRỊ GIA TĂNG') INSERT INTO Dictionary (Content, Content2) VALUES (N'HÓA ĐƠN GIÁ TRỊ GIA TĂNG', N'SALES INVOICES');
if not exists (select 1 from Dictionary where Content = N'Kế toán') INSERT INTO Dictionary (Content, Content2) VALUES (N'Kế toán', N'Accountant');
if not exists (select 1 from Dictionary where Content = N'(Ký, ghi rõ họ tên)') INSERT INTO Dictionary (Content, Content2) VALUES (N'(Ký, ghi rõ họ tên)', N'(Signature, full name)');
if not exists (select 1 from Dictionary where Content = N'(Ký, ghi rõ họ tên)') INSERT INTO Dictionary (Content, Content2) VALUES (N'(Ký, ghi rõ họ tên)', N'(Signature, full name)');
if not exists (select 1 from Dictionary where Content = N'(Ký tên, đóng dấu)') INSERT INTO Dictionary (Content, Content2) VALUES (N'(Ký tên, đóng dấu)', N'(Sign, full name, Seal)');
if not exists (select 1 from Dictionary where Content = N'(Cần kiểm tra đối chiếu khi lập, giao, nhận hóa đơn)') INSERT INTO Dictionary (Content, Content2) VALUES (N'(Cần kiểm tra đối chiếu khi lập, giao, nhận hóa đơn)', N'(Need to check and compare the formulation, delivery, billing)');
if not exists (select 1 from Dictionary where Content = N'. MST:') INSERT INTO Dictionary (Content, Content2) VALUES (N'. MST:', N'. Tax Code :');
if not exists (select 1 from Dictionary where Content = N'Liên:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Liên:', N'Copy :');
if not exists (select 1 from Dictionary where Content = N'Người lập biểu') INSERT INTO Dictionary (Content, Content2) VALUES (N'Người lập biểu', N'Prepared by');
if not exists (select 1 from Dictionary where Content = N'- Theo') INSERT INTO Dictionary (Content, Content2) VALUES (N'- Theo', N'- According');
if not exists (select 1 from Dictionary where Content = N'của') INSERT INTO Dictionary (Content, Content2) VALUES (N'của', N'of');
if not exists (select 1 from Dictionary where Content = N'Trang') INSERT INTO Dictionary (Content, Content2) VALUES (N'Trang', N'Page');
if not exists (select 1 from Dictionary where Content = N'Tiền mặt') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tiền mặt', N'Cash');
if not exists (select 1 from Dictionary where Content = N'Tổng cộng trang') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tổng cộng trang', N'Page total');
if not exists (select 1 from Dictionary where Content = N'Đơn vị tính :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Đơn vị tính :', N'Unit:');
if not exists (select 1 from Dictionary where Content = N'Việt Nam Đồng') INSERT INTO Dictionary (Content, Content2) VALUES (N'Việt Nam Đồng', N'VND');
if not exists (select 1 from Dictionary where Content = N'Lập,  ngày...........tháng...........năm 20.......') INSERT INTO Dictionary (Content, Content2) VALUES (N'Lập,  ngày...........tháng...........năm 20.......', N'Created, date ….. Month ….. Year 20…');
if not exists (select 1 from Dictionary where Content = N'BÁO CÁO LƯU CHUYỂN TIỀN TỆ ') INSERT INTO Dictionary (Content, Content2) VALUES (N'BÁO CÁO LƯU CHUYỂN TIỀN TỆ ', N'CASHFLOW REPORT ');
if not exists (select 1 from Dictionary where Content = N'Phiếu kế toán') INSERT INTO Dictionary (Content, Content2) VALUES (N'Phiếu kế toán', N'ACCOUNTING VOUCHER');
if not exists (select 1 from Dictionary where Content = N'Phát sinh nợ') INSERT INTO Dictionary (Content, Content2) VALUES (N'Phát sinh nợ', N'Arise debit');
if not exists (select 1 from Dictionary where Content = N'Phát sinh có') INSERT INTO Dictionary (Content, Content2) VALUES (N'Phát sinh có', N'Arise credit');
if not exists (select 1 from Dictionary where Content = N'Người lập biểu') INSERT INTO Dictionary (Content, Content2) VALUES (N'Người lập biểu', N'Creator');
if not exists (select 1 from Dictionary where Content = N'Bảng kê chứng từ') INSERT INTO Dictionary (Content, Content2) VALUES (N'Bảng kê chứng từ', N'List of voucher');
if not exists (select 1 from Dictionary where Content = N'Tên khách') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tên khách', N'Buyer name');
if not exists (select 1 from Dictionary where Content = N'Người lập') INSERT INTO Dictionary (Content, Content2) VALUES (N'Người lập', N'Created User');
if not exists (select 1 from Dictionary where Content = N'TK Công Nợ') INSERT INTO Dictionary (Content, Content2) VALUES (N'TK Công Nợ', N'Debt account');
if not exists (select 1 from Dictionary where Content = N'TK Sổ Cái') INSERT INTO Dictionary (Content, Content2) VALUES (N'TK Sổ Cái', N'Ledger account');
if not exists (select 1 from Dictionary where Content = N'BẢNG KÊ HÓA ĐƠN, CHỨNG TỪ HÀNG HÓA, DỊCH VỤ MUA VÀO') INSERT INTO Dictionary (Content, Content2) VALUES (N'BẢNG KÊ HÓA ĐƠN, CHỨNG TỪ HÀNG HÓA, DỊCH VỤ MUA VÀO', N' List of purchased invoice , voucher of goods and services');
if not exists (select 1 from Dictionary where Content = N'Mẫu số : 01-2/GTGT') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mẫu số : 01-2/GTGT', N'Form: 01-2/GTGT');
if not exists (select 1 from Dictionary where Content = N'Ban hành kèm theo thông tư số 60/2007/TT-BTC ngày 14/09/2007 của Bộ tài chính') INSERT INTO Dictionary (Content, Content2) VALUES (N'Ban hành kèm theo thông tư số 60/2007/TT-BTC ngày 14/09/2007 của Bộ tài chính', N'(Attached to the Finance Ministry of Circular No. 60/2007/TT-BTC dated  14/09/2007)');
if not exists (select 1 from Dictionary where Content = N'TÊN DOANH NGHIỆP :') INSERT INTO Dictionary (Content, Content2) VALUES (N'TÊN DOANH NGHIỆP :', N'COMPANY NAME:');
if not exists (select 1 from Dictionary where Content = N'Địa chỉ :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Địa chỉ :', N'Address:');
if not exists (select 1 from Dictionary where Content = N'Mã số thuế :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mã số thuế :', N'Tax code:');
if not exists (select 1 from Dictionary where Content = N'Hóa đơn,chứng từ mua') INSERT INTO Dictionary (Content, Content2) VALUES (N'Hóa đơn,chứng từ mua', N'Purchased invoice , voucher ');
if not exists (select 1 from Dictionary where Content = N'Ký hiệu hóa đơn') INSERT INTO Dictionary (Content, Content2) VALUES (N'Ký hiệu hóa đơn', N'Serial');
if not exists (select 1 from Dictionary where Content = N'Tên người bán') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tên người bán', N'Seller name');
if not exists (select 1 from Dictionary where Content = N'Mã số thuế người bán') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mã số thuế người bán', N'Tax code:');
if not exists (select 1 from Dictionary where Content = N'Doanh số mua chưa thuế') INSERT INTO Dictionary (Content, Content2) VALUES (N'Doanh số mua chưa thuế', N'Purchasing turnover');
if not exists (select 1 from Dictionary where Content = N'Tổng doanh sô hàng hóa dịch vụ mua vào') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tổng doanh sô hàng hóa dịch vụ mua vào', N'Collect purchased turnover of goods and services');
if not exists (select 1 from Dictionary where Content = N'Ký tên, đóng dấu (ghi rõ họ tên, chức vụ)') INSERT INTO Dictionary (Content, Content2) VALUES (N'Ký tên, đóng dấu (ghi rõ họ tên, chức vụ)', N'Sign, Seal ( full name, position)');
if not exists (select 1 from Dictionary where Content = N'BẢNG KÊ HÓA ĐƠN, CHỨNG TỪ HÀNG HÓA, DỊCH VỤ BÁN RA') INSERT INTO Dictionary (Content, Content2) VALUES (N'BẢNG KÊ HÓA ĐƠN, CHỨNG TỪ HÀNG HÓA, DỊCH VỤ BÁN RA', N'List of sold invoice, voucher of goods and services ');
if not exists (select 1 from Dictionary where Content = N'Tên người mua') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tên người mua', N'Buyer name');
if not exists (select 1 from Dictionary where Content = N'Mã số thuế người mua') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mã số thuế người mua', N'Tax code');
if not exists (select 1 from Dictionary where Content = N'Tổng doanh sô hàng hóa dịch vụ bán ra') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tổng doanh sô hàng hóa dịch vụ bán ra', N'Collect sold turnover of goods and services');
if not exists (select 1 from Dictionary where Content = N'Mã đối tượng') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mã đối tượng', N'Object code');
if not exists (select 1 from Dictionary where Content = N'SĐT') INSERT INTO Dictionary (Content, Content2) VALUES (N'SĐT', N'Tel');
if not exists (select 1 from Dictionary where Content = N'Loại KH') INSERT INTO Dictionary (Content, Content2) VALUES (N'Loại KH', N'Customer  type');
if not exists (select 1 from Dictionary where Content = N'Nhóm vật tư :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Nhóm vật tư :', N'Material group');
if not exists (select 1 from Dictionary where Content = N'TK giá vốn') INSERT INTO Dictionary (Content, Content2) VALUES (N'TK giá vốn', N'Cost price account');
if not exists (select 1 from Dictionary where Content = N'TK Doanh thu') INSERT INTO Dictionary (Content, Content2) VALUES (N'TK Doanh thu', N'Revenue account');
if not exists (select 1 from Dictionary where Content = N'Mã TS') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mã TS', N'Asset code');
if not exists (select 1 from Dictionary where Content = N'BP Sử Dụng') INSERT INTO Dictionary (Content, Content2) VALUES (N'BP Sử Dụng', N'Department Used');
if not exists (select 1 from Dictionary where Content = N'TK Chi Phí') INSERT INTO Dictionary (Content, Content2) VALUES (N'TK Chi Phí', N'Cost account');
if not exists (select 1 from Dictionary where Content = N'TK Khấu Hao') INSERT INTO Dictionary (Content, Content2) VALUES (N'TK Khấu Hao', N'Discount Account');
if not exists (select 1 from Dictionary where Content = N'TK Tài Sản') INSERT INTO Dictionary (Content, Content2) VALUES (N'TK Tài Sản', N'Asset Account');
if not exists (select 1 from Dictionary where Content = N'Tổng cộng :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tổng cộng :', N'Total:');
if not exists (select 1 from Dictionary where Content = N'HÓA ĐƠN GIÁ TRỊ GIA TĂNG') INSERT INTO Dictionary (Content, Content2) VALUES (N'HÓA ĐƠN GIÁ TRỊ GIA TĂNG', N'VAT INVOICE');
if not exists (select 1 from Dictionary where Content = N'Mẫu số: 01 GTKT - 3LL') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mẫu số: 01 GTKT - 3LL', N'Form:  01 GTKT - 3LL');
if not exists (select 1 from Dictionary where Content = N'Ký hiệu:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Ký hiệu:', N'Serial:');
if not exists (select 1 from Dictionary where Content = N'Số:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Số:', N'No:');
if not exists (select 1 from Dictionary where Content = N'Đơn vị bán hàng:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Đơn vị bán hàng:', N'Seller name:');
if not exists (select 1 from Dictionary where Content = N'Liên:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Liên:', N'Copy:');
if not exists (select 1 from Dictionary where Content = N'Địa chỉ:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Địa chỉ:', N'Address:');
if not exists (select 1 from Dictionary where Content = N'Số tài khoản:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Số tài khoản:', N'Account No:');
if not exists (select 1 from Dictionary where Content = N'. Ngân hàng:') INSERT INTO Dictionary (Content, Content2) VALUES (N'. Ngân hàng:', N'Bank:');
if not exists (select 1 from Dictionary where Content = N'. MST:') INSERT INTO Dictionary (Content, Content2) VALUES (N'. MST:', N'Tax code:');
if not exists (select 1 from Dictionary where Content = N'Họ và tên người  mua hàng :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Họ và tên người  mua hàng :', N'Buyer name:');
if not exists (select 1 from Dictionary where Content = N'Đơn vị:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Đơn vị:', N'Company name:');
if not exists (select 1 from Dictionary where Content = N'Địa chỉ:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Địa chỉ:', N'Address:');
if not exists (select 1 from Dictionary where Content = N'Tên hàng hóa dịch vụ') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tên hàng hóa dịch vụ', N'Name of goods and services');
if not exists (select 1 from Dictionary where Content = N'Cộng tiền hàng:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Cộng tiền hàng:', N'Total of amount:');
if not exists (select 1 from Dictionary where Content = N'Tiền thuế GTGT:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tiền thuế GTGT:', N'Tax amount:');
if not exists (select 1 from Dictionary where Content = N'Tiền chiết khấu:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tiền chiết khấu:', N'Discount amount:');
if not exists (select 1 from Dictionary where Content = N'Tổng tiền thanh toán:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tổng tiền thanh toán:', N'Grand total:');
if not exists (select 1 from Dictionary where Content = N'Thuế suất GTGT:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Thuế suất GTGT:', N'Tax Rate:');
if not exists (select 1 from Dictionary where Content = N'Hình thức thanh toán:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Hình thức thanh toán:', N'Payment method:');
if not exists (select 1 from Dictionary where Content = N'Số tiền viết bằng chữ:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Số tiền viết bằng chữ:', N'Amount in word:');
if not exists (select 1 from Dictionary where Content = N'Kế toán') INSERT INTO Dictionary (Content, Content2) VALUES (N'Kế toán', N'Accountant');
if not exists (select 1 from Dictionary where Content = N'(Ký, ghi rõ họ tên)') INSERT INTO Dictionary (Content, Content2) VALUES (N'(Ký, ghi rõ họ tên)', N'(Sign and full name)');
if not exists (select 1 from Dictionary where Content = N'PHIẾU NHẬP KHO') INSERT INTO Dictionary (Content, Content2) VALUES (N'PHIẾU NHẬP KHO', N'Stock receiving voucher');
if not exists (select 1 from Dictionary where Content = N'Nợ :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Nợ :', N'Debit:');
if not exists (select 1 from Dictionary where Content = N'Có :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Có :', N'Credit:');
if not exists (select 1 from Dictionary where Content = N'Tên, nhãn hiệu, quy cách, phẩm chất vật tư, dụng cụ sản phẩm, hàng hóa') INSERT INTO Dictionary (Content, Content2) VALUES (N'Tên, nhãn hiệu, quy cách, phẩm chất vật tư, dụng cụ sản phẩm, hàng hóa', N'Description');
if not exists (select 1 from Dictionary where Content = N'Nhập tại kho :') INSERT INTO Dictionary (Content, Content2) VALUES (N'Nhập tại kho :', N'Im Warehouse:');
if not exists (select 1 from Dictionary where Content = N'Lý do nhập:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Lý do nhập:', N'Im reason');
if not exists (select 1 from Dictionary where Content = N'Thực nhập') INSERT INTO Dictionary (Content, Content2) VALUES (N'Thực nhập', N'Reality import');
if not exists (select 1 from Dictionary where Content = N'- Tổng số tiền ( viết bằng chữ )') INSERT INTO Dictionary (Content, Content2) VALUES (N'- Tổng số tiền ( viết bằng chữ )', N'- Amount (in word)');
if not exists (select 1 from Dictionary where Content = N'Người lập phiếu') INSERT INTO Dictionary (Content, Content2) VALUES (N'Người lập phiếu', N'Created User');
if not exists (select 1 from Dictionary where Content = N'Thủ kho') INSERT INTO Dictionary (Content, Content2) VALUES (N'Thủ kho', N'WareHouse Guard');
if not exists (select 1 from Dictionary where Content = N'- Đơn vị cá nhân bán hàng') INSERT INTO Dictionary (Content, Content2) VALUES (N'- Đơn vị cá nhân bán hàng', N'- Seller name');
if not exists (select 1 from Dictionary where Content = N'- Địa chỉ') INSERT INTO Dictionary (Content, Content2) VALUES (N'- Địa chỉ', N'- Address');
if not exists (select 1 from Dictionary where Content = N'Thủ trưởng đơn vị') INSERT INTO Dictionary (Content, Content2) VALUES (N'Thủ trưởng đơn vị', N'Director');
if not exists (select 1 from Dictionary where Content = N'(Ban hành theo QĐ số 15/2006/QĐ-BTC Ngày 20/03/2006 của Bộ trưởng BTC)') INSERT INTO Dictionary (Content, Content2) VALUES (N'(Ban hành theo QĐ số 15/2006/QĐ-BTC Ngày 20/03/2006 của Bộ trưởng BTC)', N'(Attached to the Decission No 15/2006/QĐ-BTC dated  20/03/2006 by Ministry of Finance)');
if not exists (select 1 from Dictionary where Content = N'Ban hành theo QĐ số 15/2006/QĐ-BTC Ngày 20/03/2006 của Bộ trưởng BTC') INSERT INTO Dictionary (Content, Content2) VALUES (N'Ban hành theo QĐ số 15/2006/QĐ-BTC Ngày 20/03/2006 của Bộ trưởng BTC', N'Attached to the Decission No 15/2006/QĐ-BTC dated  20/03/2006 by Ministry of Finance');
if not exists (select 1 from Dictionary where Content = N'Số lần in') INSERT INTO Dictionary (Content, Content2) VALUES (N'Số lần in', N'Hits in');
if not exists (select 1 from Dictionary where Content = N'Sổ này có ......... trang, đánh số từ trang số 01 đến trang ............Ngày mở sổ: ....................') INSERT INTO Dictionary (Content, Content2) VALUES (N'Sổ này có ......... trang, đánh số từ trang số 01 đến trang ............Ngày mở sổ: ....................', N'This book ......... page, page numbering from page 01 to open the window ............ Date: .................... ');
if not exists (select 1 from Dictionary where Content = N'Mẫu số S03a-DN') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mẫu số S03a-DN', N'Form S03a-DN');
if not exists (select 1 from Dictionary where Content = N'Kèm theo: ................. chứng từ gốc') INSERT INTO Dictionary (Content, Content2) VALUES (N'Kèm theo: ................. chứng từ gốc', N'Attachments: ................. Original documents ');
if not exists (select 1 from Dictionary where Content = N'( Theo phương pháp trực tiếp)') INSERT INTO Dictionary (Content, Content2) VALUES (N'( Theo phương pháp trực tiếp)', N'(Direct method) ');
if not exists (select 1 from Dictionary where Content = N'Mẫu số B 01- DN') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mẫu số B 01- DN', N'Form B 01- DN');
if not exists (select 1 from Dictionary where Content = N'Mẫu số B 02- DN') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mẫu số B 02- DN', N'Form B 02- DN');
if not exists (select 1 from Dictionary where Content = N'Mẫu số B 03- DN') INSERT INTO Dictionary (Content, Content2) VALUES (N'Mẫu số B 03- DN', N'Form B 03- DN');
