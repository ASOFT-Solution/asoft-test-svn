Use CDT

-- [ACC_VIETMY] Mã vật tư không sắp xếp theo thứ tự trong báo cáo tồn theo kho
Update sysReport set Query = N'DECLARE @sql NVARCHAR (4000)
--phần cân đối tk thường
SET @sql=''create view wthuong as 
 select makho, mavt,Madvt,0.0 as sldk,0.0 as nodau,sum(soluong) as sln, sum(soluong_x) as slx,sum(psno) as psno,sum(psco) as psco from blvt where ngayCt <=  cast('''''' + CONVERT(NVARCHAR, @@ngayCt) + '''''' as datetime) and  '' + ''@@ps'' + '' group by makho, mavt,Madvt
 union all
 select makho, mavt,Madvt,sum(soluong) as sldk,sum(dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco from obvt where  '' + ''@@ps'' + '' group by makho, mavt,Madvt
 union all
 select makho, mavt,Madvt,sum(soluong) as sldk,sum(dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco from obntxt where  '' + ''@@ps'' + '' group by makho, mavt,Madvt''

EXEC (@sql)

SET @sql=''create view wthuong1 as
 select makho, mavt,Madvt,sum(sldk) as sldk, sum(nodau) as dudau, sum(sln) as sln,sum(slx) as slx, sum(psno) as psno, sum(psco) as psco from wthuong group by makho, mavt,Madvt''

EXEC (@sql)

SET @sql=''create view wthuong2 as
 select makho, mavt,Madvt,sldk,  dudau, sln,slx, psno,  psco, sldk+sln-slx as slck,   ducuoi = dudau+psno-psco  from wthuong1 ''

EXEC (@sql)

SELECT a.makho,
       a.MaVT,
       a.Madvt,
       CASE
         WHEN @@lang = 1
         THEN dmvt.TenVT2
         ELSE dmvt.TenVT
       END    AS TenVT,
       CASE
         WHEN @@lang = 1
         THEN dmdvt.TenDVT2
         ELSE dmdvt.TenDVT
       END    AS TenDVT,
       slck   N''Tồn Cuối'',
       ducuoi N''Dư Cuối''
  FROM wthuong2 a,
       dmvt,
       dmdvt
 WHERE (slck <> 0 OR ducuoi <> 0)
   AND a.MaVT = dmvt.MaVT
   AND a.MaDVT = dmdvt.MaDVT
 Order by a.makho, a.mavt

DROP VIEW wthuong

DROP VIEW wthuong1

DROP VIEW wthuong2 '
where ReportName = N'Báo cáo tồn kho'
