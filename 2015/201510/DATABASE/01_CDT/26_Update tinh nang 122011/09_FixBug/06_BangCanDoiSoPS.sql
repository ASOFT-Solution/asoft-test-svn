use [CDT]

-- Bảng cân đối số phát sinh
Update sysReport Set Query = N'declare @ngayct datetime
declare @ngayCt1 datetime
declare @sql nvarchar (4000)
declare @gradeTK1 int
declare @gradeTK2 int
set @ngayct=@@ngayCt1
set @gradeTK1 = @@GradeTK1
set @gradeTK2 = @@GradeTK2
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
select tk, sum(duno) as nodau,sum(duco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi  from obtk where tk in(select tk from dmtk where tkcongno<>1) group by tk, MaNT
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
declare @tnodk decimal(28,6), @cnodk decimal(28,6)
declare @tcodk decimal(28,6), @ccodk decimal(28,6)
declare @tpsno decimal(28,6), @cpsno decimal(28,6)
declare @tpsco decimal(28,6), @cpsco decimal(28,6)
declare @tlkno decimal(28,6), @clkno decimal(28,6)
declare @tlkco decimal(28,6), @clkco decimal(28,6)
declare @tnock decimal(28,6), @cnock decimal(28,6)
declare @tcock decimal(28,6), @ccock decimal(28,6)
select @tnodk= sum([Nợ đầu]), @tcodk = sum([Có đầu]),
	@tpsno = sum(psno), @tpsco = sum(psco),
	@tlkno = sum([Lũy kế nợ]), @tlkco = sum([Lũy kế có]),
	@tnock = sum([Nợ cuối]), @tcock = sum([Có cuối]) from wthuong2
select @cnodk= sum([Nợ đầu]), @ccodk = sum([Có đầu]),
	@cpsno = sum(psno), @cpsco = sum(psco),
	@clkno = sum([Lũy kế nợ]), @clkco = sum([Lũy kế có]),
	@cnock = sum([Nợ cuối]), @ccock = sum([Có cuối]) from wcongno3

select b.TkMe,a.Tk, case when @@lang = 1 then b.tentk2 else b.tentk end as tentk,b.GradeTK,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wcongno3 a inner join dmtk b on a.tk = b.tk
union all
select b.TkMe,a.Tk, case when @@lang = 1 then b.tentk2 else b.tentk end as tentk,b.GradeTK,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wthuong2  a  inner join dmtk b on a.tk = b.tk
union all
select '''' as TkMe,''T'' as Tk,case when @@lang = 1 then N''Total'' else N''Tổng cộng'' end as tentk,999 as GradeTK, isnull(@tnodk,0) + isnull(@cnodk,0) as nodau, isnull(@tcodk,0) + isnull(@ccodk,0) as codau, isnull(@tpsno,0) + isnull(@cpsno,0) as psno, isnull(@tpsco,0) + isnull(@cpsco,0) as psco, isnull(@tlkno,0) + isnull(@clkno,0) as lkno, isnull(@tlkco,0) + isnull(@clkco,0) as lkco, isnull(@tnock,0) + isnull(@cnock,0) as nocuoi, isnull(@tcock,0) + isnull(@ccock,0) as cocuoi
order by tkme, a.tk

drop view wcongno
drop view wcongno1
drop view wcongno2
drop view wcongno3
drop view wthuong
drop view wthuong1
drop view wthuong2'
where ReportName = N'Bảng cân đối số phát sinh'

