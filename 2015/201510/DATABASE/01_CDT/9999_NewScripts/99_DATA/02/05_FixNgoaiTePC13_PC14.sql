USE [CDT]

-- Fix các báo cáo không hiển thị ngoại tệ nếu tỷ giá = 1 (trường hợp PC13, PC14 lúc nào cũng lưu ngoại tệ)

-- 1) Bảng cân đối phát sinh công nợ
Update sysReport
set Query = N'declare @tk nvarchar(16)
declare @ngayCt datetime
declare @ngayCt1 datetime
declare @dk nvarchar(256)
declare @sql nvarchar (4000)
set @tk=@@TK
set @ngayCt=@@ngayct1
set @ngayCt1=dateadd(hh,23,@@ngayct2)
--lấy số dư đầu
set @sql=''create view wsodu as select makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by makh''
exec (@sql)
set @sql=''create view wsotk as select makh, sum(case when TyGia = 1 then 0 else psnont end) as dunont,sum(psno)as duno, sum(case when TyGia = 1 then 0 else pscont end) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by makh ''
exec (@sql)
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wdudau as select makh,
nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,
codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,
0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi from wG1 group by makh''

exec (@sql)

--lấy số phát sinh

set @sql=''create view wsops as select makh,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
sum(case when TyGia = 1 then 0 else psnont end)as psnont,sum(psno)as psno, sum(case when TyGia = 1 then 0 else pscont end) as pscont, sum(psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) and cast('''''' + convert(nvarchar,@ngayCt1) + '''''' as datetime) and '' + @@ps + '' group by makh''

exec (@sql)
--lấy số dư cuối
set @sql =''create view wG2 as select * from wdudau union all select * from wsops''
exec (@sql)

set @sql=''create view wkq as 
select makh, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
from wG2  group by makh ''
exec (@sql)
select a.makh,case when @@lang = 1 then b.tenkh2 else b.tenkh end as tenkh,a.nodaunt as [Nợ đầu nguyên tệ],a.nodau as [Nợ đầu],a.codaunt as [Có đầu nguyên tệ],a.codau as [Có đầu],a.psnont,a.psno,a.pscont,a.psco,a.nocuoint as [Nợ cuối nguyên tệ], a.nocuoi as [Nợ cuối],a.cocuoint as [Có cuối nguyên tệ],a.cocuoi as [Có cuối] from wkq a left join dmkh b on  a.makh=b.makh
where a.nodau <> 0 or a.codau <> 0 or a.psno <>0 or a.psco <> 0 or a.nocuoi <>0 or a.cocuoi <>0

drop view wsodu
drop view wsotk
drop view wG1
drop view wsops
drop view wdudau
drop view wG2
drop view wkq'
where ReportName = N'Bảng cân đối phát sinh công nợ'