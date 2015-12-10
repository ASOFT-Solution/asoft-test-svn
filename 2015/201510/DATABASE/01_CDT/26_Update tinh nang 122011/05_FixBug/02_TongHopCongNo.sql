use [CDT]

-- Tổng hợp công nợ phải trả
Update sysReport set Query = N'
declare @sql nvarchar (4000) 
declare @ngayct1 datetime 
declare @ngayct2 datetime 

set @ngayct1 = @@ngayct1 
set @ngayct2 = dateadd(hh,23,@@ngayct2 )

if exists (select distinct name from sys.all_views where name = ''sddk'') drop view sddk 
if exists (select distinct name from sys.all_views where name = ''pstk'') drop view pstk 
if exists (select distinct name from sys.all_views where name = ''sdck'') drop view sdck 
if exists (select distinct name from sys.all_views where name = ''wTHCNPTRA'') drop view wTHCNPTRA 

set @sql = '' 
create view sddk as 
select makh, tk, sum (psno) - sum (psco) as dk from bltk 
where ngayct < cast ('''''' + convert (nvarchar,@ngayct1) + '''''' as datetime) '' +'' 
group by tk, makh'' 
exec (@sql) 

set @sql = '' 
create view pstk as select makh, tk, sum (isnull (psno,0)) as psn, sum (isnull (psco,0)) as psc from bltk 
where ngayct between cast ('''''' + convert (nvarchar,@ngayct1) + '''''' as datetime) and cast ('''''' + convert (nvarchar,@ngayct2) + '''''' as datetime) '' +'' 
group by tk, makh'' 
exec (@sql) 

set @sql = '' 
create view sdck as select makh, tk, sum (psno) - sum (psco) as ck from bltk 
where ngayct <= cast ('''''' + convert (nvarchar,@ngayct2) + '''''' as datetime) '' +'' 
group by tk, makh'' 
exec (@sql) 

set @sql = '' 
create view wTHCNPTRA as 
select distinct 
bltk.makh as mncc, 
kh.tenkh as tncc, 
bltk.tk, 
case when dk > 0 then dk else 0 end as dndk, 
case when dk < 0 then -dk else 0 end as dcdk, 
isnull (pstk.psn,0) as psn, 
isnull (pstk.psc,0) as psc, 
case when ck > 0 then ck else 0 end as dnck, 
case when ck < 0 then -ck else 0 end as dcck 
from bltk left join sddk on sddk.makh = bltk.makh and sddk.tk = bltk.tk 
left join pstk on pstk.makh = bltk.makh and pstk.tk = bltk.tk 
left join sdck on sdck.makh = bltk.makh and sdck.tk = bltk.tk 
left join DMKH kh on kh.makh = bltk.makh
where '' + @@ps 
exec (@sql) 

select * from wTHCNPTRA 

if exists (select distinct name from sys.all_views where name = ''sddk'') drop view sddk 
if exists (select distinct name from sys.all_views where name = ''pstk'') drop view pstk 
if exists (select distinct name from sys.all_views where name = ''sdck'') drop view sdck 
if exists (select distinct name from sys.all_views where name = ''wTHCNPTRA'') drop view wTHCNPTRA
'
Where ReportName = N'Tổng hợp công nợ phải trả'

-- Tổng hợp công nợ phải thu
Update sysReport set Query = N'
declare @sql nvarchar (4000) 
declare @ngayct1 datetime 
declare @ngayct2 datetime 

set @ngayct1 = @@ngayct1 
set @ngayct2 = dateadd(hh,23,@@ngayct2 )

if exists (select distinct name from sys.all_views where name = ''sddk'') drop view sddk 
if exists (select distinct name from sys.all_views where name = ''pstk'') drop view pstk 
if exists (select distinct name from sys.all_views where name = ''sdck'') drop view sdck 
if exists (select distinct name from sys.all_views where name = ''wTHCNPTHU'') drop view wTHCNPTHU 

set @sql = '' 
create view sddk as 
select makh, tk, sum (psno) - sum (psco) as dk from bltk 
where ngayct < cast ('''''' + convert (nvarchar,@ngayct1) + '''''' as datetime) '' +'' 
group by tk, makh'' 
exec (@sql) 

set @sql = '' 
create view pstk as select makh, tk, sum (isnull (psno,0)) as psn, sum (isnull (psco,0)) as psc from bltk 
where ngayct between cast ('''''' + convert (nvarchar,@ngayct1) + '''''' as datetime) and cast ('''''' + convert (nvarchar,@ngayct2) + '''''' as datetime) '' +'' 
group by tk, makh'' 
exec (@sql) 

set @sql = '' 
create view sdck as select makh, tk, sum (psno) - sum (psco) as ck from bltk 
where ngayct <= cast ('''''' + convert (nvarchar,@ngayct2) + '''''' as datetime) '' +'' 
group by tk, makh'' 
exec (@sql) 

set @sql = '' 
create view wTHCNPTHU as 
select distinct 
bltk.makh as mkh, 
kh.tenkh as tkh, 
bltk.tk, 
case when dk > 0 then dk else 0 end as dndk, 
case when dk < 0 then -dk else 0 end as dcdk, 
isnull (pstk.psn,0) as psn, 
isnull (pstk.psc,0) as psc, 
case when ck > 0 then ck else 0 end as dnck, 
case when ck < 0 then -ck else 0 end as dcck 
from bltk 
left join sddk on sddk.makh = bltk.makh and sddk.tk = bltk.tk 
left join pstk on pstk.makh = bltk.makh and pstk.tk = bltk.tk 
left join sdck on sdck.makh = bltk.makh and sdck.tk = bltk.tk 
left join DMKH kh on kh.makh = bltk.makh
where '' + @@ps 
exec (@sql) 

select * from wTHCNPTHU 

if exists (select distinct name from sys.all_views where name = ''sddk'') drop view sddk 
if exists (select distinct name from sys.all_views where name = ''pstk'') drop view pstk 
if exists (select distinct name from sys.all_views where name = ''sdck'') drop view sdck 
if exists (select distinct name from sys.all_views where name = ''wTHCNPTHU'') drop view wTHCNPTHU
'
Where ReportName = N'Tổng hợp công nợ phải thu'
