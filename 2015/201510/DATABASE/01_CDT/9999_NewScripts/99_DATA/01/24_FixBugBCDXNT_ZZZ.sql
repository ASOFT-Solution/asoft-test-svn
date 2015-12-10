USE [CDT]
--------------Bảng cân đối nhập xuất tồn----------------------
Update sysReport set Query = N'declare @ngayct datetime
declare @ngayCt1 datetime
declare @sql nvarchar (4000)
set @ngayct=@@ngayct1
set @ngayct1=dateadd(hh,23,@@ngayct2)

--phần cân đối tk thường
set @sql=''create view wthuong as 
select mavt,0.0 as sldk,0.0 as nodau,sum(soluong) as sln, sum(soluong_x) as slx,sum(psno) as psno,sum(psco) as psco from blvt where ngayCt between cast('''''' 
+ convert(nvarchar,@ngayCt) + '''''' as datetime) and  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) and  ''+''@@ps''+'' group by mavt
union all
select mavt,sum(soluong - soluong_x) as sldk,sum(psno - psco) as nodau,0.0 as sln, 0.0 as slx,0.0 as psno,0.0 as psco from blvt where ngayCt < cast(''''''+ convert(nvarchar,@ngayCt) + '''''' as datetime) and  ''+''@@ps''+'' group by mavt
union all
select mavt,sum(soluong) as sldk,sum(dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco from obvt where  ''+''@@ps''+'' group by mavt
union all
select mavt,sum(soluong) as sldk,sum(dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco from obNTXT where  ''+''@@ps''+'' group by mavt''
exec (@sql)
set @sql=''create view wthuong1 as
select mavt,sum(sldk) as sldk, sum(nodau) as dudau, sum(sln) as sln,sum(slx) as slx, sum(psno) as psno, sum(psco) as psco from wthuong group by mavt''
exec (@sql)
set @sql=''create view wthuong2 as
select mavt,sldk,  dudau, sln, psno, slx,  psco, sldk+sln-slx as slck,   ducuoi = dudau+psno-psco  from wthuong1 ''
exec (@sql)
declare @tsldk decimal(22,6),@tdudau decimal(22,6)
declare @tsln decimal(22,6),@tpsno decimal(22,6)
declare @tslx decimal(22,6),@tpsco decimal(22,6)
declare @tslck decimal(22,6),@tducuoi decimal(22,6)
select @tsldk=sum(sldk),@tdudau=sum(dudau),
@tsln=sum(sln),@tpsno=sum(psno),@tslx=sum(slx),
@tpsco=sum(psco),@tslck=sum(slck),@tducuoi=sum(ducuoi) from wthuong2
if @@nhom='''' 
begin
select b.Nhom, a.mavt,b.tenvt,c.tendvt, a.sldk as N''Tồn đầu'', a.DuDau as N''Dư đầu'', a.sln as N''Số lượng nhập'', a.psno as N''Giá trị nhập'', a.slx as N''Số lượng xuất'', a.psco as N''Giá trị xuất'', a.slck as N''Tồn cuối'', a.DuCuoi as N''Dư cuối'' from wthuong2 a, dmvt b, dmdvt c where a.mavt =b.mavt and b.madvt = c.madvt
union select '''','''',N''Tổng cộng'','''',@tsldk,@tdudau,@tsln,
@tpsno,@tslx,@tpsco,@tslck,@tducuoi
end 
else 
begin 
select b.Nhom, a.mavt,b.tenvt,c.tendvt, a.sldk as N''Tồn đầu'', a.DuDau as N''Dư đầu'', a.sln as N''Số lượng nhập'', a.psno as N''Giá trị nhập'', a.slx as N''Số lượng xuất'', a.psco as N''Giá trị xuất'', a.slck as N''Tồn cuối'', a.DuCuoi as N''Dư cuối'' from wthuong2 a, dmvt b, dmdvt c where a.mavt =b.mavt and b.madvt = c.madvt and  b.nhom=@@nhom
union  all
select '''','''',N''Tổng cộng'','''',@tsldk,@tdudau,@tsln,
@tpsno,@tslx,@tpsco,@tslck,@tducuoi
end

drop view wthuong
drop view wthuong1
drop view wthuong2'
where ReportName = N'Bảng cân đối nhập xuất tồn'