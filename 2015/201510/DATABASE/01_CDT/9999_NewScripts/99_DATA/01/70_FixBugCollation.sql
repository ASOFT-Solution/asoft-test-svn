USE [CDT]

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
 [makho] [varchar] (16) COLLATE database_default NULL,
 [mavt] [varchar] (16) COLLATE database_default NULL,
 [madvt] [varchar] (16) COLLATE database_default NULL,
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

-- Giá thành định mức
Update sysReport set Query = N'DECLARE @cpc float
DECLARE @tk nvarchar(16)
DECLARE @ngayCt datetime
DECLARE @ngayCt1 datetime
DECLARE @dk nvarchar(256)
declare @nhom nvarchar(256)
set @nhom=@@nhomgt
SELECT @tk = N''627''
SELECT @ngayCt =@@ngayct1
SELECT @ngayCt1 = dateadd(hh,23,@@ngayct2)
SELECT @dk = ''@@ps''
EXEC sopsKetChuyen @tk, @ngayCt, @ngayCt1, @dk, @cpc output
create table #t (
	masp nvarchar (50) COLLATE database_default null,
	sln decimal (20,5) null,
	dddk decimal (20,5) null,
	nvl decimal (20,5) null,
	Luong decimal (20,5) null,
	cpc decimal (20,5) null,
	ddck decimal (20,5) null,
	Gia decimal (20,5) null
) on [Primary]
insert into #t 
select c.mavt,d.slN,0 as dddk,d.NVL, c.Luong*d.slN as Luong,0 as cpc,0 as ddck, 0 as gia from 
(
	select * from dfkhac where ngayct between @ngayct and @ngayct1
) c inner join
(
	select masp,avg(slN) as slN,sum(NVL) as NVL from 
	(
		select a.masp,b.slN,b.slN*a.soluong*a.gia as NVL from 
		(
			select mavt as masp, soluong,gia from dfNvl where ngayct between @ngayct and @ngayct1 
		)a inner join
		(
			select mavt as masp, sum(soluong) as slN from blvt where mact=''NSX'' and  ngayct between @ngayct and @ngayct1  group by mavt
		) b on a.masp=b.masp 
	) k  group by masp
)d on c.mavt=d.masp where c.mavt in (select mavt from dmvt where nhomgt=@nhom)
update #t set dddk =t.tien from cotiendd t where t.masp=#t.masp and t.ngayct between dateadd(m,-1,@ngayct) and dateadd(m,-1,@ngayct1)
update #t set ddck =t.tien from cotiendd t where t.masp=#t.masp and t.ngayct between @ngayct and @ngayct1
declare @tongHS float
declare @HSCPC float
select @tonghs=sum(NVL+Luong) from #t
set @hsCPC=0
if @tonghs>0
begin
	set @HSCPC =@cpc/@tongHS
end
--update #t set cpc =(NVL+Luong) * @HSCPC
--declare @tongHSDC float
--select @tongHSDC=sum(r.Heso*(t.NVL+t.LUONG))   from #t t inner join dfcpc r on t.masp= r.masp where r.ngayct between @ngayct and @ngayct1
--update #t set cpc=@CPC* r.heso*(t.NVL+t.LUONG)/@tongHSDC from #t t inner join dfcpc r on t.masp= r.masp where r.ngayct between @ngayct and @ngayct1

update #t set gia=(dddk+nvl+luong+cpc-ddck)/sln where  sln>0
select masp as [Mã sản phẩm],case when @@lang = 1 then  dmvt.tenvt2 else dmvt.tenvt end as [Tên sản phẩm],sln as [Số lượng nhập kho], dddk as [Dở dang đầu kỳ],nvl as [Chi phí nguyên vật liệu], luong as [Chi phí nhân công trực tiếp], CPC as [Chi phí sản xuất chung], ddck as [Dở dang cuối kỳ], gia as [Giá thành] from #t inner join dmvt on #t.masp = dmvt.mavt
drop table #t'
where ReportName = N'Giá thành định mức'