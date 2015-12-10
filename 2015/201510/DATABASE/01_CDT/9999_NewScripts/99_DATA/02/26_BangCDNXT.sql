USE [CDT]

---Update filter
declare @sysReportID int,
		@sysFieldMaKho int

select @sysReportID = sysReportID from sysReport
where ReportName = N'Bảng cân đối nhập xuất tồn'

select @sysFieldMaKho = sysFieldID from SysField
				where FieldName = 'MaKho'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLVT')

--Update report filter			
Update [sysReportFilter] set SpecialCond = 1
where [sysFieldID] = @sysFieldMaKho and sysReportID = @sysReportID and SpecialCond = 0

Update sysReport set Query = N'DECLARE @ngayct DATETIME
DECLARE @ngayCt1 DATETIME
DECLARE @sql NVARCHAR (4000)
SET @ngayct= @@ngayct1
SET @ngayct1=Dateadd(hh, 23, @@ngayct2)
--phần cân đối tk thường
SET @sql=''create view wthuong as 
select t.mavt,t.Madvt,0.0 as sldk,0.0 as nodau,sum(t.soluong) as sln, sum(t.soluong_x) as slx,sum(t.psno) as psno,sum(t.psco) as psco 
from blvt t left join dmvt dm on t.mavt = dm.mavt 
where t.ngayCt between cast('''''' 
+ CONVERT(NVARCHAR, @ngayCt) + '''''' as datetime) and  cast('''''' + CONVERT(NVARCHAR, @ngayCt1) + '''''' as datetime) and  '' + ''@@ps''

IF @@nhom <> ''''
	set @sql = @sql + '' and dm.nhom=''@@nhom''''

IF @@MaKho <> ''''
	set @sql = @sql + '' and t.MaKho=''@@MaKho''''
	
set @sql = @sql + '' group by t.mavt, t.MaDvt
union all
select t.mavt,t.Madvt,sum(t.soluong - t.soluong_x) as sldk,sum(t.psno - t.psco) as nodau,0.0 as sln, 0.0 as slx,0.0 as psno,0.0 as psco 
from blvt t left join dmvt dm on t.mavt = dm.mavt where ngayCt < cast('''''' + CONVERT(NVARCHAR, @ngayCt) + '''''' as datetime) and  '' + ''@@ps'' 

IF @@nhom <> ''''
	set @sql = @sql + '' and dm.nhom=''@@nhom''''

IF @@MaKho <> ''''
	set @sql = @sql + '' and t.MaKho=''@@MaKho''''
	
set @sql = @sql +  '' group by t.mavt, t.MaDvt
union all
select t.mavt,t.Madvt,sum(t.soluong) as sldk,sum(t.dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco 
from obvt t left join dmvt dm on t.mavt = dm.mavt where  '' + ''@@ps'' 

IF @@nhom <> ''''
	set @sql = @sql + '' and dm.nhom=''@@nhom''''

IF @@MaKho <> ''''
	set @sql = @sql + '' and t.MaKho=''@@MaKho''''
	
set @sql = @sql + '' group by t.mavt, t.MaDvt
union all
select t.mavt,t.Madvt,sum(t.soluong) as sldk,sum(t.dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco 
from obNTXT t left join dmvt dm on t.mavt = dm.mavt where  '' + ''@@ps'' 

IF @@nhom <> ''''
	set @sql = @sql + '' and dm.nhom=''@@nhom''''

IF @@MaKho <> ''''
	set @sql = @sql + '' and t.MaKho=''@@MaKho''''
	
set @sql = @sql + '' group by t.mavt, t.MaDvt''

EXEC (@sql)
SET @sql=''create view wthuong1 as
select mavt,Madvt,sum(sldk) as sldk, sum(nodau) as dudau, sum(sln) as sln,sum(slx) as slx, sum(psno) as psno, sum(psco) as psco, ''@@MaKho'' as MaKho from wthuong group by mavt, MaDvt''
EXEC (@sql)
SET @sql=''create view wthuong2 as
select mavt,Madvt,sldk,  dudau, sln, psno, slx,  psco, sldk+sln-slx as slck,   ducuoi = dudau+psno-psco, MaKho  from wthuong1 ''
EXEC (@sql)
DECLARE @tsldk  DECIMAL(28, 6),
        @tdudau DECIMAL(28, 6)
DECLARE @tsln  DECIMAL(28, 6),
        @tpsno DECIMAL(28, 6)
DECLARE @tslx  DECIMAL(28, 6),
        @tpsco DECIMAL(28, 6)
DECLARE @tslck   DECIMAL(28, 6),
        @tducuoi DECIMAL(28, 6)
SELECT @tsldk = Sum(sldk),
       @tdudau = Sum(dudau),
       @tsln = Sum(sln),
       @tpsno = Sum(psno),
       @tslx = Sum(slx),
       @tpsco = Sum(psco),
       @tslck = Sum(slck),
       @tducuoi = Sum(ducuoi)
  FROM wthuong2
IF @@nhom = ''''
BEGIN
SELECT b.Nhom,a.mavt, CASE WHEN @@lang = 1 THEN tenvt2 ELSE tenvt END AS tenvt, a.MaDvt , CASE WHEN @@lang = 1 THEN c.tendvt2 ELSE c.tendvt END AS tendvt, a.sldk AS N''Tồn đầu'', a.DuDau AS N''Dư đầu'', a.sln AS N''Số lượng nhập'', a.psno AS N''Giá trị nhập'', a.slx AS N''Số lượng xuất'', a.psco AS N''Giá trị xuất'', a.slck AS N''Tồn cuối'', a.DuCuoi AS N''Dư cuối'', a.MaKho FROM wthuong2 a, dmvt b, dmdvt c WHERE a.mavt = b.mavt AND a.madvt = c.madvt
UNION ALL
SELECT '''','''', CASE WHEN @@lang = 1 THEN ''Total'' ELSE N''Tổng cộng'' END, '''', '''', @tsldk, @tdudau, @tsln,@tpsno,@tslx,@tpsco,@tslck,@tducuoi, @@MaKho
END
ELSE
  BEGIN
      SELECT b.Nhom, a.mavt,CASE WHEN @@lang = 1 THEN tenvt2 ELSE tenvt END AS tenvt, a.madvt,CASE WHEN @@lang = 1 THEN c.tendvt2 ELSE c.tendvt END AS tendvt, a.sldk AS N''Tồn đầu'', a.DuDau AS N''Dư đầu'', a.sln AS N''Số lượng nhập'', a.psno AS N''Giá trị nhập'', a.slx AS N''Số lượng xuất'', a.psco AS N''Giá trị xuất'', a.slck AS N''Tồn cuối'', a.DuCuoi AS N''Dư cuối'', a.MaKho FROM wthuong2 a, dmvt b, dmdvt c WHERE a.mavt = b.mavt AND a.madvt = c.madvt AND b.nhom=@@nhom
      UNION ALL
      SELECT '''','''',CASE WHEN @@lang = 1 THEN ''Total'' ELSE N''Tổng cộng'' END,'''','''',@tsldk,@tdudau,@tsln,@tpsno,@tslx,@tpsco,@tslck,@tducuoi, @@MaKho
  END
DROP VIEW wthuong
DROP VIEW wthuong1
DROP VIEW wthuong2'
where sysReportID = @sysReportID