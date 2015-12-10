-- [ACC_THỊNH PHÁT] Dòng trống trong báo cáo Tổng hợp công nợ phải thu/phải trả
USE [CDT]

Update sysReport
set Query = N'declare @tk nvarchar(16),@ngayCt datetime,@ngayCt1 datetime, @sql nvarchar (4000)
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
set @sql=''create view wsodu as select tk, makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư đầu bảng BLTK
set @sql=''create view wsotk as select tk, makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by tk, makh ''
exec (@sql)
--Lấy số dư đầu kỳ từ hai bảng OBKH và BLTK
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wdudau as select tk, makh,nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi from wG1 group by tk, makh''
exec (@sql)
--lấy số phát sinh trong kỳ
set @sql=''create view wsops as select tk, makh,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
sum(psnont)as psnont,sum(psno)as psno, sum(pscont) as pscont, sum(psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) and cast('''''' + convert(nvarchar, @ngayCt1) + '''''' as datetime) and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư cuối
set @sql =''create view wG2 as select * from wdudau union all select * from wsops''
exec (@sql)
set @sql=''create view wkq as 
select tk, makh, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
from wG2  group by tk, makh ''
exec (@sql)
select a.makh as mkh,case when @@lang = 1 then b.tenkh2 else b.tenkh end as tkh, a.tk,
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


Update sysReport
set Query = N'declare @tk nvarchar(16),@ngayCt datetime,@ngayCt1 datetime, @sql nvarchar (4000)
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
set @sql=''create view wsodu as select tk, makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư đầu bảng BLTK
set @sql=''create view wsotk as select tk, makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by tk, makh ''
exec (@sql)
--Lấy số dư đầu kỳ từ hai bảng OBKH và BLTK
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wdudau as select tk, makh,nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi from wG1 group by tk, makh''
exec (@sql)
--lấy số phát sinh trong kỳ
set @sql=''create view wsops as select tk, makh,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
sum(psnont)as psnont,sum(psno)as psno, sum(pscont) as pscont, sum(psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) and cast('''''' + convert(nvarchar, @ngayCt1) + '''''' as datetime) and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư cuối
set @sql =''create view wG2 as select * from wdudau union all select * from wsops''
exec (@sql)
set @sql=''create view wkq as 
select tk, makh, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
from wG2  group by tk, makh ''
exec (@sql)
select a.makh as mncc,case when @@lang = 1 then b.tenkh2 else b.tenkh end as tncc, a.tk,
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