Use CDT

-- Sổ chi tiết vật tư
Update sysReport set Query = N'declare @ngayct1 datetime, 
  @ngayct2 datetime
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)
declare @sln decimal(28,6),
  @gtnhap decimal(28,6),
  @slx decimal(28,6), 
  @gtxuat decimal(28,6),
  @slton decimal(28,6),
  @gtton decimal(28,6), 
  @id int,
  @mavt [varchar](16), 
  @madvt [varchar](16),
  @makho [varchar](16),
  @tmp decimal(28,6), 
  @tmp1 decimal(28,6),
  @mavtLoop [varchar](16), 
  @makhoLoop [varchar](16),
  @madvtLoop [varchar](16)
DECLARE @Ton TABLE
(
  NgayCT smalldatetime,
  MACT nvarchar(512),
  MTID uniqueidentifier,
  SoCT [nvarchar](512),
  TenKH [nvarchar](512),
  DienGiai [nvarchar](512),
  DonGia [decimal](28, 6),
  mavt [varchar](16),
  madvt [varchar](16),
  makho [varchar](16),
  SoLuong [decimal](28, 6),
  gtn [decimal](28, 6),
  SoLuong_X [decimal](28, 6),
  gtx [decimal](28, 6),
  SlTon [decimal](28, 6),
  gtt [decimal](28, 6)
)
DECLARE @t TABLE
(
 [blvtID] [int]   NULL , 
 [sln] [decimal](28, 6) NULL ,
 [gtnhap] [decimal](28, 6) NULL ,
 [slx] [decimal](28, 6) NULL ,
 [gtxuat] [decimal](28, 6) NULL ,
 [slton] [decimal](28, 6) NULL ,
 [gtton] [decimal](28, 6) NULL ,
 --mavt [varchar](16), 
 makho [varchar](16)
)
-- Lấy giá trị tồn kho
insert into @Ton(NgayCT, MACT, MTID, SoCT, TenKH, DienGiai, DonGia, mavt,madvt, makho, SoLuong, gtn, SoLuong_X, gtx, SlTon, gtt)
select null, null, null, null , null , case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end, null, MaVT,madvt, MaKho, null, null, null , null , Sum(Soluong) - Sum(SoLuong_x), sum(psno) - sum(psco)
 from(
 select soluong, soluong_x, psno, psco, MaVT,madvt, MaKho from blvt t where NgayCT < @ngayct1 and @@ps
 union all
 select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco, MaVT,madvt, MaKho from obvt t where @@ps
 union all
 select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco, MaVT,madvt, MaKho from obntxt t where @@ps
 ) x
 group by MaKho, MaVT, madvt
-- Lấy số phát sinh
insert into @t select blvtid, soluong,psno, soluong_x,psco, 0.0 as slton, 0.0 as gtton, makho
from blvt t
where NgayCT between @ngayct1 and @ngayct2 and @@ps
order by makho, mavt, madvt,NgayCT, SoCT


-- Tính toán lại giá trị tồn kho
declare cur cursor for 
select blvtid, soluong,psno, soluong_x,psco, 0.0 as slton, 0.0 as gtton, mavt,madvt, makho
from blvt t
where NgayCT between @ngayct1 and @ngayct2 and @@ps
order by makho, mavt, madvt,NgayCT, SoCT
open cur
fetch cur  into @ID,@sln,@gtnhap, @slx,@gtxuat, @slton, @gtton, @mavt,@madvt, @makho
set @mavtLoop = ''''
set @makhoLoop = ''''
Set @madvtLoop = ''''
while @@fetch_status=0
begin
 -- Tính qua vật tư khác hoặc kho khác
 if @makhoLoop <> @makho or @mavtLoop <> @mavt  or @madvtLoop <> @madvt
 BEGIN
  set @makhoLoop = @makho
  set @tmp1 = 0
  set @mavtLoop = @mavt
  set @madvtLoop = @madvt
  set @tmp = 0
  select @tmp1 = isnull(gtt,0), @tmp = isnull(SlTon,0) from @Ton where MaKho = @makho and MaVT = @mavt and madvt = @madvt
 END
 set @slton=@tmp+@sln-@slx
 set @tmp=@slton
 set @gtton=@tmp1+@gtnhap-@gtxuat
 set @tmp1=@gtton
  UPDATE @t SET slton=@slton, gtton=@gtton where blvtid=@id
 fetch cur  into @ID,@sln,@gtnhap, @slx,@gtxuat, @slton, @gtton, @mavt,@madvt, @makho
end
close cur
deallocate cur

-- Lấy kết quả
select  x.*, 
case when @@lang = 1 then y.tenvt2 else y.tenvt end as tenvt,
case when @@lang = 1 then t.tendvt2 else t.tendvt end as tendvt,
case when @@lang = 1 then z.tenkho2 else z.tenkho end as tenkho
from (
  -- Bảng các vật tư có giá trị tồn
   select NgayCT, MACT, MTID, SoCT, TenKH, DienGiai, DonGia,mavt,madvt, makho, SoLuong, gtn as [Giá trị nhập], SoLuong_X, gtx as [Giá trị xuất],SlTon, gtt as [Giá trị tồn]
     from @Ton
   union all
  -- Insert dòng tồn đầu kỳ = 0 cho các vật tư không có giá trị tồn
   Select distinct null, null, null, null, null ,  case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end, null, mavt,madvt, makho,null, null, null, null, 0, 0
     from blvt t
     where t.NgayCT between @ngayct1 and @ngayct2 and @@ps 
     and not exists(select * from @Ton ton where t.Makho = ton.Makho and t.Mavt = ton.Mavt and t.Madvt = ton.Madvt)
   union all
  -- Bảng nhập xuất
   Select NgayCT, MACT, MTID, SoCT, case when @@lang = 1 then dmkh.TenKH2 else dmkh.TenKH end as TenKH , DienGiai, DonGia, t.mavt,t.madvt, tmp.makho, tmp.sln, case when PsNo > 0 then PsNo else null end, tmp.slx, case when PsCo > 0 then PsCo else null end, tmp.SlTon, tmp.gtton
     from blvt t, dmkh, @t tmp
     where tmp.blvtid = t.blvtid and t.MaKH *= dmkh.MaKH and NgayCT between @ngayct1 and @ngayct2 and @@ps
 ) x, dmvt y,dmkho z, dmdvt t 
where x.mavt =y.mavt and x.makho=z.makho and x.madvt = t.madvt
order by x.makho, x.mavt, x.madvt,  NgayCT, SoCT'
where ReportName = N'Sổ chi tiết vật tư'

-- Bảng cân đối nhập xuất tồn
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
	
set @sql = @sql + '' group by t.mavt, t.MaDvt
union all
select t.mavt,t.Madvt,sum(t.soluong - t.soluong_x) as sldk,sum(t.psno - t.psco) as nodau,0.0 as sln, 0.0 as slx,0.0 as psno,0.0 as psco 
from blvt t left join dmvt dm on t.mavt = dm.mavt where ngayCt < cast('''''' + CONVERT(NVARCHAR, @ngayCt) + '''''' as datetime) and  '' + ''@@ps'' 

IF @@nhom <> ''''
	set @sql = @sql + '' and dm.nhom=''@@nhom''''
	
set @sql = @sql +  '' group by t.mavt, t.MaDvt
union all
select t.mavt,t.Madvt,sum(t.soluong) as sldk,sum(t.dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco 
from obvt t left join dmvt dm on t.mavt = dm.mavt where  '' + ''@@ps'' 

IF @@nhom <> ''''
	set @sql = @sql + '' and dm.nhom=''@@nhom''''
	
set @sql = @sql + '' group by t.mavt, t.MaDvt
union all
select t.mavt,t.Madvt,sum(t.soluong) as sldk,sum(t.dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco 
from obNTXT t left join dmvt dm on t.mavt = dm.mavt where  '' + ''@@ps'' 

IF @@nhom <> ''''
	set @sql = @sql + '' and dm.nhom=''@@nhom''''
	
set @sql = @sql + '' group by t.mavt, t.MaDvt''

EXEC (@sql)
SET @sql=''create view wthuong1 as
select mavt,Madvt,sum(sldk) as sldk, sum(nodau) as dudau, sum(sln) as sln,sum(slx) as slx, sum(psno) as psno, sum(psco) as psco from wthuong group by mavt, MaDvt''
EXEC (@sql)
SET @sql=''create view wthuong2 as
select mavt,Madvt,sldk,  dudau, sln, psno, slx,  psco, sldk+sln-slx as slck,   ducuoi = dudau+psno-psco  from wthuong1 ''
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
SELECT b.Nhom,a.mavt, CASE WHEN @@lang = 1 THEN tenvt2 ELSE tenvt END AS tenvt, a.MaDvt , CASE WHEN @@lang = 1 THEN c.tendvt2 ELSE c.tendvt END AS tendvt, a.sldk AS N''Tồn đầu'', a.DuDau AS N''Dư đầu'', a.sln AS N''Số lượng nhập'', a.psno AS N''Giá trị nhập'', a.slx AS N''Số lượng xuất'', a.psco AS N''Giá trị xuất'', a.slck AS N''Tồn cuối'', a.DuCuoi AS N''Dư cuối'' FROM wthuong2 a, dmvt b, dmdvt c WHERE a.mavt = b.mavt AND a.madvt = c.madvt
UNION ALL
SELECT '''','''', CASE WHEN @@lang = 1 THEN ''Total'' ELSE N''Tổng cộng'' END, '''', '''', @tsldk, @tdudau, @tsln,@tpsno,@tslx,@tpsco,@tslck,@tducuoi
END
ELSE
  BEGIN
      SELECT b.Nhom, a.mavt,CASE WHEN @@lang = 1 THEN tenvt2 ELSE tenvt END AS tenvt, a.madvt,CASE WHEN @@lang = 1 THEN c.tendvt2 ELSE c.tendvt END AS tendvt, a.sldk AS N''Tồn đầu'', a.DuDau AS N''Dư đầu'', a.sln AS N''Số lượng nhập'', a.psno AS N''Giá trị nhập'', a.slx AS N''Số lượng xuất'', a.psco AS N''Giá trị xuất'', a.slck AS N''Tồn cuối'', a.DuCuoi AS N''Dư cuối'' FROM wthuong2 a, dmvt b, dmdvt c WHERE a.mavt = b.mavt AND a.madvt = c.madvt AND b.nhom=@@nhom
      UNION ALL
      SELECT '''','''',CASE WHEN @@lang = 1 THEN ''Total'' ELSE N''Tổng cộng'' END,'''','''',@tsldk,@tdudau,@tsln,@tpsno,@tslx,@tpsco,@tslck,@tducuoi
  END
DROP VIEW wthuong
DROP VIEW wthuong1
DROP VIEW wthuong2', mtAlias = 't'
where ReportName = N'Bảng cân đối nhập xuất tồn'

-- Báo cáo tồn kho
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
 WHERE slck <> 0
   AND ducuoi <> 0
   AND a.MaVT = dmvt.MaVT
   AND a.MaDVT = dmdvt.MaDVT

DROP VIEW wthuong

DROP VIEW wthuong1

DROP VIEW wthuong2 '
where ReportName = N'Báo cáo tồn kho'

-- Thẻ Kho
Update sysReport set Query = N'declare @mavt  VARCHAR(16),@madvt VARCHAR(16),@makho VARCHAR(16),
  @sln decimal(28,6), @slx decimal(28,6), @slton decimal(28,6),
  @tmp decimal(28,6), 
  @mavtLoop [varchar](16), 
  @makhoLoop [varchar](16),
  @madvtLoop [varchar](16),
  @id int,@ngayct1 datetime, @ngayct2 datetime
set @mavt = @@mavt
set @makho = @@makho
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)
--Bảng tồn giá trị đầu
DECLARE @Ton TABLE (
     mavt      [VARCHAR](16),
     madvt     [VARCHAR](16),
     makho     [VARCHAR](16),
     SlTon     [DECIMAL](28, 6),
     gtton      [DECIMAL](28, 6)
     )
INSERT INTO @Ton (mavt, madvt, makho, SlTon, gtton )
 select Mavt, MaDvt, Makho, Sum(Soluong) - Sum(SoLuong_x) as Slton, sum(psno) - sum(psco) as gtton
 from(
   select mavt, makho, madvt, soluong, soluong_x, psno, psco from blvt where NgayCT < @ngayct1 and MaKho=@makho and  MaVT = @mavt
   union all
   select mavt, makho, madvt, soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco from obvt where MaKho=@makho and  MaVT = @mavt
   union all
   select mavt, makho, madvt, soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco from obntxt where MaKho=@makho and  MaVT = @mavt) x
 Group by Mavt, MaDvt, Makho
     
--Tạo bảng lưu giá trị nhập xuất 
create table #t
 (
 [blvtID] [int]   NULL , 
 [makho] [varchar] (16) NULL,
 [mavt] [varchar] (16) NULL,
 [madvt] [varchar] (16) NULL,
 [sln] [decimal](28, 6) NULL ,
 [slx] [decimal](28, 6) NULL ,
 [slton] [decimal](28, 6) NULL
 
) ON [PRIMARY]
insert into #t 
select blvtid, makho, mavt, madvt,soluong, soluong_x, 0.0 as slton
from blvt
where NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and MaVT = @mavt
order by NgayCT, SoCT, makho, Mavt, Madvt

-- Tính toán lại giá trị tồn kho
declare cur cursor for 
select blvtid, soluong,soluong_x, 0.0 as slton, mavt,madvt, makho
from blvt t
where NgayCT between @ngayct1 and @ngayct2 and t.MaVT = @mavt  and  t.MaKho = @makho 
order by makho, mavt, madvt,NgayCT, SoCT
open cur
fetch cur  into @ID,@sln, @slx, @slton, @mavt,@madvt, @makho
set @mavtLoop = ''''
set @makhoLoop = ''''
Set @madvtLoop = ''''
while @@fetch_status=0
begin
 -- Tính qua vật tư khác hoặc kho khác
 if @makhoLoop <> @makho or @mavtLoop <> @mavt  or @madvtLoop <> @madvt
  BEGIN
   set @makhoLoop = @makho
   set @mavtLoop = @mavt
   set @madvtLoop = @madvt
   set @tmp = 0
   select  @tmp = isnull(SlTon,0) from @Ton where MaKho = @makho and MaVT = @mavt and madvt = @madvt 
  END
 set @slton=@tmp+@sln-@slx
 set @tmp=@slton
 UPDATE #t SET slton=@slton where blvtid=@id
 fetch cur  into @ID,@sln, @slx, @slton,  @mavt,@madvt, @makho
end
close cur
deallocate cur

select case when @@lang = 1 then y.tenvt2 else y.tenvt end as tenvt, 
case when @@lang = 1 then z.tenkho2 else z.tenkho end as tenkho, x.*
from (
 -- Insert dòng tồn đầu kỳ <> 0 cho các vật tư có giá trị tồn
  select null as NgayCT, null as SoCT,null as TenKH,case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end as DienGiai, mavt,madvt, makho, null as Dongia ,null SoLuong, gtton as [Giá trị nhập] ,NULL SoLuong_X, NULL [Giá trị xuất] , SlTon
  from @Ton
  
  union all
  
  -- Insert dòng tồn đầu kỳ = 0 cho các vật tư không có giá trị tồn
   Select distinct null, null, null, case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end, mavt,madvt, makho,null, null, null, null, 0, 0
     from blvt t
     where t.NgayCT between @ngayct1 and @ngayct2
     and not exists(select * from @Ton ton where t.Makho = ton.Makho and t.Mavt = ton.Mavt and t.Madvt = ton.Madvt)
     and t.MaKho=@makho and t.MaVT = @mavt
  
  union all
  
 -- Insert số phát sinh nhập xuất
  Select NgayCT, SoCT,case when @@lang = 1 then dmkh.TenKH2 else dmkh.TenKH end as TenKH,DienGiai, @mavt mavt,blvt.madvt,@makho makho, Dongia ,
   SoLuongN = #t.sln,GiaTriN = case when PsNo > 0 then PsNo else null end, 
   SoLuongX = #t.slx,GiaTriX = case when PsCo > 0 then PsCo else null end, 
   SlTon = #t.SlTon
  from blvt, #t, dmkh
  where #t.blvtid = blvt.blvtid and blvt.MaKH *= dmkh.MaKH and NgayCT between @ngayct1 and @ngayct2 and #t.MaKho=@makho and #t.MaVT = @mavt and #t.madvt = blvt.madvt
 ) x, dmvt y,dmkho z, dmdvt d
where x.mavt =y.mavt and x.makho=z.makho and x.madvt = d.madvt
order by NgayCT, SoCT, x.makho, x.mavt, x.madvt
drop table #t'
where ReportName = N'Thẻ Kho'

-- Bảng giá trung bình tháng
Update sysReport set Query = N'select a.MaKho, a.MaVT, case when @@lang = 1 then b.TenVT2 else b.TenVT end as TenVT, a.Madvt,
case when @@lang = 1 then c.TenDVT2 else c.TenDVT end as TenDVT, a.DonGia, a.DonGiaQD
from BangGiaTB a, DMVT b, DMDVT c
where a.MaVT = b.MaVT and a.MaDVT = c.MaDVT and month(a.NgayCT) = @@Thang and @@ps'
where ReportName = N'Bảng giá trung bình tháng'

-- Tổng hợp hàng xuất kho
Update sysReport set Query = N'select x.*, 
  case when @@lang = 1 then dmnhomvt.tennhom2 else dmnhomvt.tennhom end as tennhom 
from 
 (
  Select a.MaKho, 
    a.MaVT, 
    case when @@lang = 1 then b.TenVT2 else b.TenVT end as TenVT,
    case when @@lang = 1 then c.TenDVT2 else c.TenDVT end as TenDVT, 
    Sum(SoLuong_x) N''Số Lượng'' , 
    Sum(PsCo) N''Tiền'',
    b.nhom nhom
  from blvt a, dmvt b, dmdvt c
  where a.MaVT = b.MaVT and a.MaDVT = c.MaDVT and SoLuong_x > 0 and @@ps
  group by a.MaKho, a.MaVT, b.TenVT,b.TenVT2, c.TenDVT,c.TenDVT2,b.nhom
 ) 
 x left join dmnhomvt on x.nhom=dmnhomvt.manhomvt'
where ReportName = N'Tổng hợp hàng xuất kho'

-- Tổng hợp hàng nhập kho
Update sysReport set Query = N'select x.*, 
  case when @@lang = 1 then dmnhomvt.tennhom2 else dmnhomvt.tennhom end as tennhom 
from 
 (
  Select a.MaKho, 
    a.MaVT, 
    case when @@lang = 1 then  b.TenVT2 else b.TenVT end as TenVT, 
    case when @@lang = 1 then c.TenDVT2 else c.TenDVT end as TenDVT, 
    Sum(SoLuong) N''Số Lượng'' , 
    Sum(PsNo) N''Tiền'', 
    b.nhom nhom
  from blvt a, dmvt b, dmdvt c
  where a.MaVT = b.MaVT and a.MaDVT = c.MaDVT and SoLuong > 0 and @@PS
  group by a.MaKho, a.MaVT, b.TenVT, b.TenVT2, c.TenDVT,c.TenDVT2, b.nhom
 )
 x left join dmnhomvt on x.nhom = dmnhomvt.manhomvt'
where ReportName = N'Tổng hợp hàng nhập kho'

-- Bảng kê hàng nhập kho
Update sysReport set Query = N'select x.*, case when @@lang = 1 then c.TenKH2 else c.TenKH end as TenKH, 
   case when @@lang = 1 then b.TenVT2 else b.TenVT end as TenVT,
   case when @@lang = 1 then  d.TenDVT2 else  d.TenDVT end as TenDVT, b.Nhom, 
   case when @@lang = 1 then n.TenNhom2 else n.TenNhom end as TenNhom,
   case when @@lang = 1 then h.TenVV2 else h.TenVV end as TenVV
from
 (
  Select  mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH,
    mt.DienGiai, dt.MaKho, mt.TotalGNK Ttien, dt.MaVT,dt.Madvt,
    dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.TienNK as [Thành tiền], dt.MaVV
  from mt22 mt, dt22 dt
  where mt.mt22id = dt.mt22id

  union all

  Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
    mt.DienGiai, dt.MaKho, mt.TotalGNK Ttien, dt.MaVT,dt.Madvt,
    dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.TienNK as [Thành tiền], dt.MaVV
  from mt23 mt, dt23 dt
  where mt.mt23id = dt.mt23id

  union all

  Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
    mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,dt.Madvt,
    dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps as [Thành tiền], dt.MaVV
  from mt42 mt, dt42 dt
  where mt.mt42id = dt.mt42id

  union all

  Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
    mt.DienGiai, mt.MaKhoN, mt.Ttien, dt.MaVT,dt.Madvt,
    dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps as [Thành tiền], dt.MaVV
  from mt44 mt, dt44 dt
  where mt.mt44id = dt.mt44id

  union all

  Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
    mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,dt.Madvt,
    dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps as [Thành tiền], dt.MaVV
  from mt33 mt, dt33 dt
  where mt.mt33id = dt.mt33id
 )
 x, DMKH c, DMVT b, DMDVT d, DMNhomVT n, DMVuViec h
where x.MaKH = c.MaKH and x.MaVT = b.MaVT and x.MaDVT = d.MaDVT and b.Nhom *= n.MaNhomVT and x.MaVV *= h.MaVV and [Ngày chứng từ] between @@NgayCT1 and @@NgayCT2 and @@PS
order by x.[Ngày chứng từ], x.SoCT, x.MaKho, x.MaVT'
where ReportName = N'Bảng kê hàng nhập kho'

-- Bảng kê hàng xuất kho
Update sysReport set Query = N'select x.*,case when @@lang = 1 then c.TenKH2 else c.TenKH end as TenKH,
   case when @@lang = 1 then b.TenVT2 else b.TenVT end as TenVT, 
   case when @@lang = 1 then d.TenDVT2 else d.TenDVT end as TenDVT, b.Nhom, 
   case when @@lang = 1 then n.TenNhom2 else n.TenNhom end as TenNhom, h.TenVV
from
 ( Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT as [Số phiếu xuất], mt.MaKH,
    mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT, dt.Madvt,
    dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps [Thành tiền], dt.MaVV
  from mt24 mt, dt24 dt
  where mt.mt24id *= dt.mt24id
  union all
  Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
    mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT, dt.Madvt,
    dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps [Thành tiền], dt.MaVV
  from mt32 mt, dt32 dt
  where mt.mt32id *= dt.mt32id
  union all
  Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
    mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT, dt.Madvt,
    dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps [Thành tiền], dt.MaVV
  from mt43 mt, dt43 dt
  where mt.mt43id *= dt.mt43id
  union all
  Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
    mt.DienGiai, mt.MaKho MaKho, mt.Ttien, dt.MaVT, dt.Madvt,
    dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps [Thành tiền], dt.MaVV
  from mt44 mt, dt44 dt
  where mt.mt44id *= dt.mt44id
  union all
  Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
    mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT, dt.Madvt,
    dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps [Thành tiền], dt.MaVV
  from mt45 mt, dt45 dt
  where mt.mt45id *= dt.mt45id
 )
 x, DMKH c, DMVT b, DMDVT d, DMNhomVT n, DMVuViec h
where x.MaKH = c.MaKH and x.MaVT = b.MaVT and x.MaDVT = d.MaDVT and b.Nhom *= n.MaNhomVT and x.MaVV *= h.MaVV and [Ngày chứng từ] between @@NgayCT1 and @@NgayCT2 and @@PS
order by x.[Ngày chứng từ], x.[Số phiếu xuất], x.MaKho, x.MaVT'
where ReportName = N'Bảng kê hàng xuất kho'

-- Bảng kê phiếu điều chuyển kho
Update sysReport set Query = N'if @@nhom=''''
begin
select mt.MT44ID,mt.MaCT,mt.NgayCT,mt.SoCT,mt.MaKH,mt.DiaChi,mt.MaNV,mt.DienGiai,mt.MaNT,mt.TyGia,mt.TtienNT,
  mt.Ttien,mt.Stt,mt.MaKho,mt.MaKhoN,
  (select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.makh) as TenKH,
  dt.DT44ID,dt.MaVT,dt.MaDVT,dt.SoLuong,dt.GiaNT,dt.Gia,dt.PsNT,dt.Ps,dt.TkCo,dt.TkNo,dt.MaPhi,dt.MaVV,
  dt.MaBP,dt.Stt,dt.MaCongTrinh,dt.SoCTDT,dt.LotNumber,dt.ExpireDate,dt.MTIDDoiTru,
  case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt, 
  case when @@lang = 1 then d.tendvt2 else d.tendvt end as tendvt
from Mt44 mt inner join dt44 dt on mt.mt44id =dt.mt44id left join dmkh on mt.makh=dmkh.makh, dmvt v , dmdvt d
where dt.mavt = v.mavt and dt.madvt = d.madvt and @@ps
Order by mt.NgayCT,mt.SoCT
end
else 
begin
select mt.MT44ID,mt.MaCT,mt.NgayCT,mt.SoCT,mt.MaKH,mt.DiaChi,mt.MaNV,mt.DienGiai,mt.MaNT,mt.TyGia,mt.TtienNT,
  mt.Ttien,mt.Stt,mt.MaKho,mt.MaKhoN,
  (select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.makh) as TenKH,
  dt.DT44ID,dt.MaVT,dt.MaDVT,dt.SoLuong,dt.GiaNT,dt.Gia,dt.PsNT,dt.Ps,dt.TkCo,dt.TkNo,dt.MaPhi,dt.MaVV,
  dt.MaBP,dt.Stt,dt.MaCongTrinh,dt.SoCTDT,dt.LotNumber,dt.ExpireDate,dt.MTIDDoiTru,
  case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt, 
  case when @@lang = 1 then d.tendvt2 else d.tendvt end as tendvt 
from Mt44 mt inner join dt44 dt on mt.mt44id =dt.mt44id left join dmkh on mt.makh=dmkh.makh, dmvt v , dmdvt d
where dt.mavt = v.mavt and dt.madvt = d.madvt and dt.mavt in (select mavt from dmvt where nhom like @@nhom + ''%'') and @@ps
Order by mt.NgayCT,mt.SoCT
end'
where ReportName = N'Bảng kê phiếu điều chuyển kho'

-- Bảng kê phiếu nhập khẩu
Update sysReport set Query = N'if @@nhom=''''
begin
 select mt.*,dt.*,v.thueNT as ThueNT, v.Thue as Thue, dt.TienNK as TPs, dt.TienNKNT as TPsNT, dmkh.makh,
 (select case when @@lang = 1 then k.tenkh2 else k.tenkh end from dmkh k where k.makh = dmkh.makh) as TenKH1,
   case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end as tenvt,
   case when @@lang = 1 then dmdvt.tendvt2 else dmdvt.tendvt end as tendvt,
   dmvt.nhom, ttdb.TienTTDB
 from MT23 mt, dt23 dt, dmkh, dmvt, dmdvt, VatIn v, TTDBIn ttdb
 where @@ps and mt.mt23id = dt.mt23id and mt.makh = dmkh.makh and dt.mavt = dmvt.mavt  and dt.madvt = dmdvt.madvt
        and dt.mt23id *= v.mtid and dt.dt23id *= v.mtiddt 
        and dt.mt23id *= ttdb.mtid and dt.dt23id *= ttdb.mtiddt
end

else 
begin
 select mt.*,dt.*,v.thueNT as ThueNT, v.Thue as Thue, dt.TienNK as TPs, dt.TienNKNT as TPsNT, dmkh.makh,
 (select case when @@lang = 1 then k.tenkh2 else k.tenkh end from dmkh k where k.makh = dmkh.makh) as TenKH1,
   case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end as tenvt,
   case when @@lang = 1 then dmdvt.tendvt2 else dmdvt.tendvt end as tendvt,
   dmvt.nhom, ttdb.TienTTDB
 from MT23 mt, dt23 dt, dmkh, dmvt,dmdvt, VatIn v, TTDBIn ttdb
 where @@ps and mt.mt23id = dt.mt23id and mt.makh = dmkh.makh and dt.mavt = dmvt.mavt and dt.madvt = dmdvt.madvt 
        and dt.mt23id *= v.mtid and dt.dt23id *= v.mtiddt 
        and dt.mt23id *= ttdb.mtid and dt.dt23id *= ttdb.mtiddt 
        and  dt.mavt in (select mavt from dmvt where nhom =@@nhom)
end'
where ReportName = N'Bảng kê phiếu nhập khẩu'

-- Bảng kê phiếu nhập kho
Update sysReport set Query = N'select mt.MT42ID,mt.MaCT,mt.NgayCT,mt.SoCT,mt.MaKH,mt.DiaChi,mt.MaNV,mt.DienGiai,mt.MaNT,mt.TyGia,
  mt.TtienNT,mt.Ttien,mt.Stt,mt.NhapTB,mt.NXT,
  (select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.makh) as TenKH,
  dt.DT42ID,dt.MaVT,dt.MaDVT,dt.MaKho,dt.SoLuong,dt.GiaNT,dt.Gia,dt.PsNT,dt.Ps,dt.TkCo,dt.TkNo,dt.MaPhi,
  dt.MaVV,dt.MaBP,dt.Stt,dt.MaCongTrinh,dt.LotNumber,dt.ExpireDate,
  case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt, 
  case when @@lang = 1 then d.tendvt2 else d.tendvt end as tendvt
from Mt42 mt inner join dt42 dt on mt.mt42id =dt.mt42id left join dmkh on mt.makh=dmkh.makh, dmvt v, dmdvt d
where dt.mavt = v.mavt and dt.madvt = d.madvt and @@ps
order by mt.NgayCT, mt.SoCT, dt.MaKho, dt.MaVT'
where ReportName = N'Bảng kê phiếu nhập kho'

-- Bảng kê phiếu xuất kho
Update sysReport set Query = N'declare @ngayct1 datetime, 
		@ngayct2 datetime
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)
if @@nhom=''''
begin
select mt.*, dt.*, 
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh,
case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt,
case when @@lang = 1 then d.tendvt2 else d.tendvt end as tendvt
from Mt43 mt inner join dt43 dt on mt.mt43id =dt.mt43id left join dmkh on mt.makh=dmkh.makh, dmvt v , dmdvt d
where dt.mavt = v.mavt and dt.madvt = d.madvt and @@ps
and mt.NgayCT between @ngayct1 and @ngayct2
order by mt.NgayCT, mt.SoCT, dt.MaKho, dt.MaVT
end
else 
begin
select mt.*, dt.*, 
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh,
case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt, 
case when @@lang = 1 then d.tendvt2 else d.tendvt end as tendvt
from Mt43 mt inner join dt43 dt on mt.mt43id =dt.mt43id left join dmkh on mt.makh=dmkh.makh, dmvt v , dmdvt d
where dt.mavt = v.mavt and dt.madvt = d.madvt and @@ps 
and  dt.mavt in (select mavt from dmvt where nhom like @@nhom + ''%'')
and mt.NgayCT between @ngayct1 and @ngayct2
order by mt.NgayCT, mt.SoCT, dt.MaKho, dt.MaVT
end'
where ReportName = N'Bảng kê phiếu xuất kho'

-- Bảng kê phiếu nhập kho từ sản xuất
Update sysReport set Query = N'if @@nhom=''''
begin
select mt.mt41id, mt.mact, mt.NgayCT, mt.SoCT, mt.MaKH, mt.DiaChi, mt.MaNV,
  mt.DienGiai, mt.MaNT, mt.TyGia, mt.TtienNT, mt.Ttien,mt.STT, 
  (select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.makh) as TenKH,
  mt.NhapTB, dt.DT41ID, dt.MaVT,dt.MaDVT, dt.MaKho, dt.SoLuong, dt.GiaNT, dt.Gia,dt.PsNT, dt.Ps, dt.TkCo,
  dt.TkNo, dt.MaBP, dt.MaPhi, dt.MaVV, dt.Stt, dt.MaCongTrinh, dt.LotNumber, dt.ExpireDate, case when @@lang = 1 then d.Tendvt2 else d.Tendvt end as Tendvt,
  case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt
from Mt41 mt inner join dt41 dt on mt.mt41id =dt.mt41id left join dmkh on mt.makh=dmkh.makh left join dmdvt d on dt.madvt = d.madvt left join dmvt v on v.mavt = dt.mavt
where @@ps

end
else 
begin
select mt.mt41id, mt.mact, mt.NgayCT, mt.SoCT, mt.MaKH, mt.DiaChi, mt.MaNV,
  mt.DienGiai, mt.MaNT, mt.TyGia, mt.TtienNT, mt.Ttien,mt.STT, 
  (select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.makh) as TenKH,
  mt.NhapTB, dt.DT41ID, dt.MaVT,dt.MaDVT, dt.MaKho, dt.SoLuong, dt.GiaNT, dt.Gia,dt.PsNT, dt.Ps, dt.TkCo,
  dt.TkNo, dt.MaBP, dt.MaPhi, dt.MaVV, dt.Stt, dt.MaCongTrinh, dt.LotNumber, dt.ExpireDate, case when @@lang = 1 then d.Tendvt2 else d.Tendvt end as Tendvt,
  case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt
from Mt41 mt inner join dt41 dt on mt.mt41id =dt.mt41id left join dmkh on mt.makh=dmkh.makh left join dmdvt d on dt.madvt = d.madvt left join dmvt v on v.mavt = dt.mavt
where @@ps and  dt.mavt in (select mavt from dmvt where nhom like @@nhom + ''%'')
end'
where ReportName = N'Bảng kê phiếu nhập kho từ sản xuất'

-- Bảng kê phiếu xuất CCDC
Update sysReport set Query = N'if @@nhom=''''
begin
select mt.*, dt.*, case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt
     ,case when @@lang = 1 then d.tendvt2 else d.tendvt end as tendvt
 from
Mt45 mt inner join dt45 dt on mt.mt45id =dt.mt45id left join dmkh on mt.makh=dmkh.makh, dmvt v , dmdvt d
where dt.mavt = v.mavt and dt.madvt = d.madvt  and @@ps
end
else 
begin
select mt.*, dt.*,case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt
    ,case when @@lang = 1 then d.tendvt2 else d.tendvt end as tendvt
from
Mt45 mt inner join dt45 dt on mt.mt45id =dt.mt45id left join dmkh on mt.makh=dmkh.makh, dmvt v , dmdvt d
where dt.mavt = v.mavt and dt.madvt = d.madvt and dt.mavt in (select mavt from dmvt where nhom like @@nhom + ''%'') and @@ps
end'
where ReportName = N'Bảng kê phiếu xuất CCDC'

-- Báo cáo chi tiết phân bổ công cụ dụng cụ
Update sysReport set Query = N'declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @ngayct1=@@ngayct1
set @ngayct2=@@ngayct2
SELECT x.*,case when @@lang = 1 then vt.tenvt2 else vt.tenvt end as tenvt, 
  case when @@lang = 1 then a.tendvt2 else a.tendvt end as tendvt, 
  TConLai as [Tiền còn lại], 
  TPhanBo as [Tiền phân bổ trong kỳ] ,
  case when SLHong <> 0 then (soluong - SLConLai) else 0 end as [Số lượng hỏng trước kỳ]
FROM   (
  SELECT m.ngayct as [Ngày xuất], b.mact,  m.soct, m.makh,  m.diengiai,  b.ngayct, d.mt45id, d.dt45id, 
      b.SLHong, b.SLConLai, ps, tkno, tkcp, b.mabp, b.maphi,manv,TienHong,
               kypb,soky,d.soluong, b.TPhanBo, 
               (SELECT Count (*)FROM   LSPBO tt WHERE  nhomdk = ''PBC'' AND tt.soct = b.soct AND psno >= 0 AND tt.mtiddt = b.mtiddt
    AND tt.mtid = b.mtid AND tt.ngayct <= b.ngayct) as [Phân bổ lần thứ],
    TDaPhanBo as [Tiền đã phân bổ],
    TConLai,
    d.mavt,
    madvt
        FROM   mt45 m INNER JOIN dt45 d ON m.mt45id = d.mt45id INNER JOIN LSPBO b ON b.mtid = m.mt45id AND b.mtiddt = d.dt45id
        WHERE  ( b.ngayct BETWEEN dbo.Layngaydauthang(@ngayct1) AND dbo.Layngayghiso(@ngayct2) )
               AND b.nhomdk = ''PBC'' AND psno >= 0
         ) x
       INNER JOIN dmvt vt ON x.mavt = vt.mavt left JOIN dmdvt a ON x.madvt = a.madvt 
ORDER  BY vt.mavt,x.ngayct, x.soct'
where ReportName = N'Báo cáo chi tiết phân bổ công cụ dụng cụ'

-- Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng
Update sysReport set Query = N'declare @loaiVt int
set @loaiVt = @@Loaivt
select x.ngayct, x.makh as MaKH, 
 (select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as TenKH, 
 x.mavt as MaVT, 
 (select case when @@lang = 1 then k.tenvt2 else k.tenvt end from dmvt k where k.mavt = x.mavt) as TenVT,
 x.soluong as SoLuong, 
 x.ps as DoanhThu, 
 sltl as [Số lượng trả lại], 
 x.ck as ChiecKhau, 
 x.ps - x.ck as [Doanh thu thuần], 
 x.tienvon, 
 x.ps - x.ck - x.tienvon as [Lãi gộp], 
 x.loaivt, x.IsNCC, x.IsKH, x.IsNV, x.MaNT, x.TenDVT
from ( 
  select dt32id, ngayct,  mt32.makh, mt32.tenkh, kh.IsNCC, kh.IsKH, kh.IsNV, v.mavt, tenvt, soluong, 
    ps, ck,  tienvon,  0 ''sltl'', v.loaivt, mt32.MaNT,
    case when @@lang = 1 then dvt.TenDVT2 else dvt.TenDVT end as TenDVT
  from mt32, dt32, dmvt v , dmkh kh, DMDVT dvt
  where mt32.mt32id = dt32.mt32id and dt32.mavt *= v.mavt and mt32.makh *= kh.makh and dt32.MaDVT = dvt.MaDVT
  union all 
  select dt33id, ngayct, mt33.makh, mt33.tenkh, kh.IsNCC, kh.IsKH, kh.IsNV, v.mavt, tenvt, -soluong,
    -ps, 0.0,  -tienvon,  soluong ''sltl'', v.loaivt , mt33.MaNT, 
    case when @@lang = 1 then dvt.TenDVT2 else dvt.TenDVT end as TenDVT
  from mt33, dt33, dmvt v , dmkh kh, DMDVT dvt
  where mt33.mt33id = dt33.mt33id and dt33.mavt *= v.mavt and mt33.makh *= kh.makh and dt33.MaDVT = dvt.MaDVT
 ) x
where (x.loaivt = @loaiVt or @loaiVt = 0) and @@ps'
where ReportName = N'Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng'

-- Bảng kê phiếu mua hàng
Update sysReport set Query = N'select [NgayCT], [SoCT], [SoHoaDon], dmkh.[MaKH],
  case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as [Tên khách hàng], 
  [DienGiai], [MaNT], [TyGia], [TKCo], v.[MaVT], 
  case when @@lang = 1 then v.TenVT2 else v.TenVT end as [Tên vật tư], 
  case when @@lang = 1 then d.TendVT2 else d.TendVT end as [Tên đơn vị tính],
  x.[MaDVT], [MaKho], [TKNo], 
  [SoLuong], [GiaNT], [Gia], [PsNT], [Ps],  [ThueNT] , [Thue], [CPCtNT], [CPCt], 
  [TienNKNT] + ThueNT as TPsNTCP, [TienNK] + Thue as TPsCP, [TienTTDB], [TienTTDBNT], [TienCK], [TienCKNT], GhiChu
from
 ( select mt.mact,mt.ngayct, mt.soct, mt.ngayhd,mt.sohoadon,mt.soseri,mt.makh,mt.diachi,mt.ongba, mt.manv,
   mt.diengiai,mt.mant,mt.tygia,mt.tkco,mt.mathue,mt.tkthue,mt.TtienH,mt.TtienHNT,mt.cpnt,mt.cp,
   mt.TThueNt,mt.TThue,mt.Ttien,mt.TtienNT,
   dt.*, v.ThueNT as ThueNT, v.Thue as Thue, ttdb.TienTTDB, ttdb.TienTTDBNT
  from MT22 mt, DT22 dt, VatIn v, TTDBIn ttdb
  where mt.mt22id = dt.mt22id and dt.mt22id *= v.mtid and dt.dt22id *= v.mtiddt 
         and dt.mt22id *= ttdb.mtid and dt.dt22id *= ttdb.mtiddt and @@ps
 )x, dmkh, dmvt v , dmdvt d 
where x.makh = dmkh.makh and x.mavt = v.mavt and x.madvt = d.madvt 
order by ngayct,soct,x.stt'
where ReportName = N'Bảng kê phiếu mua hàng'

-- Tổng hợp hàng nhập mua
Update sysReport set Query = N'select x.*, case when @@lang = 1 then dmnhomvt.tennhom2 else dmnhomvt.tennhom end as tennhom 
from 
 (Select a.MaKho, a.MaVT, 
   case when @@lang = 1 then b.TenVT2 else b.TenVT end as TenVT, 
   case when @@lang = 1 then c.TenDVT2 else c.TenDVT end as TenDVT, 
   Sum(SoLuong - SoLuong_x) N''Số Lượng'' , 
   Sum(DonGiaGoc*SoLuong) - Sum(DonGia*SoLuong_x) as N''Tiền vật tư'', 
   sum(DonGiaGocNT*SoLuong) - Sum(DonGiaNT*SoLuong_x) as N''Tiền vật tư NT'', 
   sum(PsNo) - Sum(DonGiaGoc*SoLuong) as CP,
   sum(PsNoNT) - Sum(DonGiaGocNT*SoLuong) as CPNT, 
   sum(PsNo) - sum(PsCo) as PsNo, 
   sum(PsNoNT) - sum(PsCoNT) as PsNoNT , 
   b.nhom nhom
 from blvt a, dmvt b, dmdvt c
 where a.MaCT in (''PNM'',''PNK'',''PXT'') and a.MaVT = b.MaVT and a.MaDVT = c.MaDVT and @@PS
 group by a.MaKho, a.MaVT, b.TenVT,b.TenVT2, c.TenDVT,c.TenDVT2, b.nhom
 ) x
left join dmnhomvt on x.nhom = dmnhomvt.manhomvt'
where ReportName = N'Tổng hợp hàng nhập mua'

-- In phiếu mua hàng có chi phí
Update sysReport set Query = N'select * from
(
 select * from
 (
  select dt22.*,mt22.Tthue as ThueHang, mt22.TthueNT as ThueHangNT, 
    case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end as tenvt,
    case when @@lang = 1 then dmdvt.tendvt2 else dmdvt.tendvt end as tendvt,
    mt22.ngayhd,mt22.sohoadon,mt22.soseri , mt22.tkco,
    case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh,
    dmkh.diachi,mt22.MaNT, dmnt.TenNT, dmnt.TenNT2 
     from dt22 ,dmvt,mt22,dmkh, dmnt, dmdvt 
     where dmvt.mavt=dt22.mavt and mt22.mt22id=dt22.mt22id and dmkh.makh=mt22.makh 
         and mt22.MaNT = dmnt.MaNT and dmdvt.madvt = dt22.madvt
     
 )y  inner join
 
   (
  select mtiddt,soct,ngayct,dongia as dongiacocp, DongiaNT as dongiacocpNT, ongba as nguoigiaohang,
    psno as thanhtien, psnoNT as thanhtienNT 
  from blvt inner join  dt22 on dt22.dt22id=blvt.mtiddt where @@ps
 ) x on y.dt22id=x.mtiddt
)y1 left join
 (
 --Thuế có chi phí
 select sum(case when mt25.Tthue*dt25.ps/NULLIF(mt25.TtienH,0) is null then 0 else mt25.Tthue*dt25.ps/mt25.TtienH end) as thueCP, 
 sum(case when mt25.TthueNT*dt25.psNT/NULLIF(mt25.TtienHNT,0) is null then 0 else mt25.TthueNT*dt25.psNT/mt25.TtienHNT end) as thueCPNT ,dt25.mt22id  
 from mt25 inner join dt25 on mt25.mt25id =dt25.mt25id 
 where dt25.mt22id  in (select mt22id from mt22 where @@ps
 ) group by dt25.mt22id
)x1 on y1.mt22id=x1.mt22id'
where ReportName = N'In phiếu mua hàng có chi phí'

-- In phiếu nhập khẩu có chi phí
Update sysReport set Query = N'select * from
(
 select * from
 (
  select dt23.*,mt23.Tthue as ThueHang, mt23.TthueNT as ThueHangNT ,
    case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end as tenvt,
    case when @@lang = 1 then dmdvt.tendvt2 else dmdvt.tendvt end as tendvt,
    mt23.ngayhd,mt23.sohoadon,mt23.soseri , mt23.tkco,
    case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh,
    dmkh.diachi, mt23.MaNT, dmnt.TenNT, dmnt.TenNT2 
  from dt23 ,dmvt,mt23,dmkh,dmnt , dmdvt 
  where dmvt.mavt=dt23.mavt and mt23.mt23id=dt23.mt23id and dmkh.makh=mt23.makh 
         and mt23.MaNT = dmnt.MaNT and dmdvt.madvt = dt23.madvt
 )y inner join
 (
  select mtiddt,soct,ngayct,dongia as dongiacocp, dongiaNT as dongiacocpNT,ongba as nguoigiaohang,psno as thanhtien, psnoNT as thanhtienNT from blvt 
  inner join  dt23 on dt23.dt23id=blvt.mtiddt where @@ps
 )x on y.dt23id=x.mtiddt
)y1 left join
(
 --Thuế có chi phí
 select sum(case when mt25.Tthue*dt25.ps/nullif(mt25.TtienH,0) is null then 0 else mt25.Tthue*dt25.ps/mt25.TtienH end) as thueCP, 
   sum(case when mt25.TthueNT*dt25.psNT/nullif(mt25.TtienHNT,0) is null then 0 else mt25.TthueNT*dt25.psNT/mt25.TtienHNT end ) as thueCPNT,dt25.mt22id  
 from mt25 inner join dt25 on mt25.mt25id =dt25.mt25id
 where dt25.mt22id  in (select mt23id from mt23 where @@ps
 ) 
 group by dt25.mt22id
)x1 on y1.mt23id=x1.mt22id'
where ReportName = N'In phiếu nhập khẩu có chi phí'