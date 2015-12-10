-- [ACC_MAXPRO] Không xem được nhóm khách hàng trong báo cáo công nợ
USE [CDT]

-- Tổng hợp công nợ phải thu
Update sysReport
set RpType = 1, 
mtAlias = 'b', 
LinkTableAlias = 'b',
TreeData = N'select MaNhomkh, MaNhomkhMe, case when @@lang  = 1 then TenNhom2 else TenNhom end from DMNhomKH', 
Query = N'declare @tk nvarchar(16),@ngayCt datetime,@ngayCt1 datetime, @sql nvarchar (4000)
set @tk=@@TK
set @ngayCt=@@ngayct1
set @ngayCt1=dateadd(hh,23,@@ngayct2)

if exists (select distinct name from sys.all_views where name = ''wsodu'') drop view wsodu 
if exists (select distinct name from sys.all_views where name = ''wsotk'') drop view wsotk
if exists (select distinct name from sys.all_views where name = ''wG1'') drop view wG1
if exists (select distinct name from sys.all_views where name = ''wsops'') drop view wsops
if exists (select distinct name from sys.all_views where name = ''wdudau'') drop view wdudau
if exists (select distinct name from sys.all_views where name = ''wG2'') drop view wG2
if exists (select distinct name from sys.all_views where name = ''wkq'') drop view wkq

--lấy số dư đầu bảng OBKH
set @sql=''create view wsodu as select dm.nhom1, b.tk, b.makh, sum(b.dunont) as dunont,sum(b.duno)as duno, sum(b.ducont) as ducont, sum(b.duco) as duco 
			from obkh b left join dmkh dm on b.makh = dm.makh
			where left(b.tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by b.tk, b.makh, dm.nhom1''
exec (@sql)
--lấy số dư đầu bảng BLTK
set @sql=''create view wsotk as select dm.nhom1,b.tk, b.makh, sum(b.psnont) as dunont,sum(b.psno)as duno, sum(b.pscont) as ducont, sum(b.psco) as duco 
								from bltk b left join dmkh dm on b.makh = dm.makh
								where left(b.tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and 
										b.ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by b.tk, b.makh, dm.nhom1 ''
exec (@sql)
--Lấy số dư đầu kỳ từ hai bảng OBKH và BLTK
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wdudau as select nhom1, tk, makh,nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi from wG1 group by tk, makh, nhom1''
exec (@sql)
--lấy số phát sinh trong kỳ
set @sql=''create view wsops as select dm.nhom1, b.tk, b.makh,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
sum(b.psnont)as psnont,sum(b.psno)as psno, sum(b.pscont) as pscont, sum(b.psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk b left join dmkh dm on b.makh = dm.makh
where left(b.tk,len('' + @tk + ''))=''''''+ @tk +'''''' and b.ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) 
		and cast('''''' + convert(nvarchar, @ngayCt1) + '''''' as datetime) and '' + @@ps + '' group by b.tk, b.makh, dm.nhom1''
exec (@sql)
--lấy số dư cuối
set @sql =''create view wG2 as select * from wdudau union all select * from wsops''
exec (@sql)
set @sql=''create view wkq as 
select nhom1, tk, makh, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
from wG2  group by  tk, makh, nhom1 ''
exec (@sql)
select  a.nhom1, a.makh as mkh,case when @@lang = 1 then b.tenkh2 else b.tenkh end as tkh, a.tk,
a.nodau as dndk,a.codau as dcdk,a.psno as psn,a.psco as psc,a.nocuoi as dnck,a.cocuoi as dcck,
a.nodaunt as dndkNT,a.codaunt as dcdkNT,a.psnont as psnNT,a.pscont as pscNT,a.nocuoint as dnckNT, a.cocuoint as dcckNT
from wkq a left join dmkh b on  a.makh=b.makh
where (a.nodau+a.codau+a.psno+a.psco+a.nocuoi+a.cocuoi+a.nodaunt+a.codaunt+a.psnont+a.pscont+a.nocuoint+a.cocuoint) > 0

drop view wsodu
drop view wsotk
drop view wG1
drop view wsops
drop view wdudau
drop view wG2
drop view wkq'
where ReportName = N'Tổng hợp công nợ phải thu'

-- Tổng hợp công nợ phải trả
Update sysReport
set RpType = 1, 
mtAlias = 'b', 
LinkTableAlias = 'b',
TreeData = N'select MaNhomkh, MaNhomkhMe, case when @@lang  = 1 then TenNhom2 else TenNhom end from DMNhomKH', 
Query = N'declare @tk nvarchar(16),@ngayCt datetime,@ngayCt1 datetime, @sql nvarchar (4000)
set @tk=@@TK
set @ngayCt=@@ngayct1
set @ngayCt1=dateadd(hh,23,@@ngayct2)

if exists (select distinct name from sys.all_views where name = ''wsodu'') drop view wsodu 
if exists (select distinct name from sys.all_views where name = ''wsotk'') drop view wsotk
if exists (select distinct name from sys.all_views where name = ''wG1'') drop view wG1
if exists (select distinct name from sys.all_views where name = ''wsops'') drop view wsops
if exists (select distinct name from sys.all_views where name = ''wdudau'') drop view wdudau
if exists (select distinct name from sys.all_views where name = ''wG2'') drop view wG2
if exists (select distinct name from sys.all_views where name = ''wkq'') drop view wkq

--lấy số dư đầu bảng OBKH
set @sql=''create view wsodu as select dm.nhom1, b.tk, b.makh, sum(b.dunont) as dunont,sum(b.duno)as duno, sum(b.ducont) as ducont, sum(b.duco) as duco 
							   from obkh  b left join dmkh dm on b.makh = dm.makh
							   where left(b.tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by b.tk, b.makh, dm.nhom1''
exec (@sql)
--lấy số dư đầu bảng BLTK
set @sql=''create view wsotk as select dm.nhom1, b.tk, b.makh, sum(b.psnont) as dunont,sum(b.psno)as duno, sum(b.pscont) as ducont, sum(b.psco) as duco 
							   from bltk b left join dmkh dm on b.makh = dm.makh
							   where left(b.tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and b.ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' 
							   as datetime) group by b.tk, b.makh, dm.nhom1 ''
exec (@sql)
--Lấy số dư đầu kỳ từ hai bảng OBKH và BLTK
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wdudau as select nhom1, tk, makh,nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi 
from wG1 
group by tk, makh, nhom1 ''
exec (@sql)
--lấy số phát sinh trong kỳ
set @sql=''create view wsops as select dm.nhom1, b.tk, b.makh,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
sum(b.psnont)as psnont,sum(b.psno)as psno, sum(b.pscont) as pscont, sum(b.psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk  b left join dmkh dm on b.makh = dm.makh
where left(b.tk,len('' + @tk + ''))=''''''+ @tk +'''''' and b.ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) 
and cast('''''' + convert(nvarchar, @ngayCt1) + '''''' as datetime) and '' + @@ps + '' group by b.tk, b.makh, dm.nhom1''
exec (@sql)
--lấy số dư cuối
set @sql =''create view wG2 as select * from wdudau union all select * from wsops''
exec (@sql)
set @sql=''create view wkq as 
select nhom1, tk, makh, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
from wG2  group by tk, makh, nhom1 ''
exec (@sql)
select a.nhom1, a.makh as mncc,case when @@lang = 1 then b.tenkh2 else b.tenkh end as tncc, a.tk,
a.nodau as dndk,a.codau as dcdk,a.psno as psn,a.psco as psc,a.nocuoi as dnck,a.cocuoi as dcck,
a.nodaunt as dndkNT,a.codaunt as dcdkNT,a.psnont as psnNT,a.pscont as pscNT,a.nocuoint as dnckNT, a.cocuoint as dcckNT
from wkq a left join dmkh b on  a.makh=b.makh
where (a.nodau+a.codau+a.psno+a.psco+a.nocuoi+a.cocuoi+a.nodaunt+a.codaunt+a.psnont+a.pscont+a.nocuoint+a.cocuoint) > 0

drop view wsodu
drop view wsotk
drop view wG1
drop view wsops
drop view wdudau
drop view wG2
drop view wkq'
where ReportName = N'Tổng hợp công nợ phải trả'

-- Bảng cân đối phát sinh công nợ
Update sysReport
set mtAlias = 'b', 
LinkTableAlias = 'b',
TreeData = N'select MaNhomkh, MaNhomkhMe, case when @@lang  = 1 then TenNhom2 else TenNhom end from DMNhomKH', 
Query = N'declare @tk nvarchar(16)
declare @ngayCt datetime
declare @ngayCt1 datetime
declare @dk nvarchar(256)
declare @sql nvarchar (4000)


set @tk=@@TK
set @ngayCt=@@ngayct1
set @ngayCt1=dateadd(hh,23,@@ngayct2)

--lấy số dư đầu
set @sql=''create view wsodu as select b.makh, dm.nhom1, sum(b.dunont) as dunont,sum(b.duno)as duno, sum(b.ducont) as ducont, sum(b.duco) as duco 
								from obkh b left join dmkh dm on b.makh = dm.makh
								where left(b.tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by b.makh, dm.nhom1''
exec (@sql)
set @sql=''create view wsotk as select b.makh, dm.nhom1, sum(case when b.TyGia = 1 then 0 else b.psnont end) as dunont,
										sum(b.psno)as duno, sum(case when b.TyGia = 1 then 0 else b.pscont end) as ducont, sum(b.psco) as duco 
								from bltk b left join dmkh dm on b.makh = dm.makh
								where left(b.tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and 
								b.ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by b.makh, dm.nhom1 ''
exec (@sql)
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wdudau as select makh, nhom1,
									nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
									nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,
									codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
									codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,
									0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
									0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi 
								from wG1 group by makh, nhom1''

exec (@sql)

--lấy số phát sinh

set @sql=''create view wsops as select b.makh, dm.nhom1,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
									sum(case when b.TyGia = 1 then 0 else b.psnont end)as psnont,sum(b.psno)as psno, 
									sum(case when b.TyGia = 1 then 0 else b.pscont end) as pscont, sum(b.psco) as psco,
									0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
								from bltk b left join dmkh dm on b.makh = dm.makh
								where left(b.tk,len('' + @tk + ''))=''''''+ @tk +'''''' and b.ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) 
										and cast('''''' + convert(nvarchar,@ngayCt1) + '''''' as datetime) and '' + @@ps + '' group by b.makh, dm.nhom1''

exec (@sql)
--lấy số dư cuối
set @sql =''create view wG2 as select * from wdudau union all select * from wsops''
exec (@sql)

set @sql=''create view wkq as 
		select makh, nhom1, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
				sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
				nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
				nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
				cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
				cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
		from wG2  group by makh, nhom1 ''
exec (@sql)

select  a.nhom1, a.makh,case when @@lang = 1 then b.tenkh2 else b.tenkh end as tenkh, case when a.makh is not null then @tk  else null end as BoldRows,
a.nodaunt as [Nợ đầu nguyên tệ],
		a.nodau as [Nợ đầu],a.codaunt as [Có đầu nguyên tệ],a.codau as [Có đầu],a.psnont,a.psno,a.pscont,
		a.psco,a.nocuoint as [Nợ cuối nguyên tệ], a.nocuoi as [Nợ cuối],a.cocuoint as [Có cuối nguyên tệ],a.cocuoi as [Có cuối] 
from wkq a left join dmkh b on  a.makh=b.makh
where a.nodau <> 0 or a.codau <> 0 or a.psno <>0 or a.psco <> 0 or a.nocuoi <>0 or a.cocuoi <>0

drop view wsodu
drop view wsotk
drop view wG1
drop view wsops
drop view wdudau
drop view wG2
drop view wkq'
where ReportName = N'Bảng cân đối phát sinh công nợ'