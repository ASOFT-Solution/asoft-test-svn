use [CDT]
declare @sysReportID int

select @sysReportID = sysReportID from sysReport
where ReportName = N'Thẻ Kho'

-- Report query
Update sysReport set Query = N'declare @mavt varchar(16), @makho varchar(16), @ngayct1 datetime, @ngayct2 datetime
set @mavt = @@mavt
set @makho = @@makho
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)

declare @sln decimal(18,3), @slx decimal(18,3), @slton decimal(18,3), @dk decimal(18,3), @gtdk decimal(18,3), @id int

select @dk = Sum(Soluong) - Sum(SoLuong_x), @gtdk = sum(psno) - sum(psco)
	from(
	select soluong, soluong_x, psno, psco from blvt where NgayCT < @ngayct1 and MaKho=@makho and  MaVT = @mavt
	union all
	select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco from obvt where MaKho=@makho and  MaVT = @mavt
	union all
	select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco from obntxt where MaKho=@makho and  MaVT = @mavt) x

declare cur cursor for 
select blvtid, soluong, soluong_x, 0.0 as slton
from blvt
where NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and MaVT = @mavt
order by NgayCT, SoCT
create table #t
 (
	[blvtID] [int]   NULL ,	
	[sln] [decimal](18, 3) NULL ,
	[slx] [decimal](18, 3) NULL ,
	[slton] [decimal](18, 3) NULL 
) ON [PRIMARY]

insert into #t select blvtid, soluong, soluong_x, 0.0 as slton
from blvt
where NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and MaVT = @mavt
order by NgayCT, SoCT

declare @tmp decimal(18,3)
if (@dk is not null)
	set @tmp = @dk
else
	set @tmp = 0
open cur
fetch cur  into @ID,@sln,@slx,@slton
while @@fetch_status=0
begin
	set @slton=@tmp+@sln-@slx
	set @tmp=@slton
	UPDATE #t SET slton=@slton where blvtid=@id
	fetch cur  into @ID,@sln,@slx,@slton
	
end
close cur
deallocate cur

select y.tenvt, y.madvt,z.tenkho, x.* from (
                select null NgayCT, null SoCT, null TenKH, case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end as DienGiai, null DonGia,@mavt mavt,@makho makho,
		 null SoLuong, @gtdk as [Giá trị nhập], null SoLuong_X, null [Giá trị xuất], @dk as SlTon
	union all
	Select NgayCT, SoCT, dmkh.TenKH , DienGiai, DonGia,@mavt mavt,@makho makho,
		SoLuongN = #t.sln, GiaTriN = case when PsNo > 0 then PsNo else null end,
		SoLuongX = #t.slx, GiaTriX = case when PsCo > 0 then PsCo else null end, SlTon = #t.SlTon
	from blvt, dmkh, #t
	where #t.blvtid = blvt.blvtid and blvt.MaKH *= dmkh.MaKH and NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and MaVT = @mavt) x, dmvt y,dmkho z
where x.mavt =y.mavt and x.makho=z.makho
order by NgayCT, SoCT

drop table #t
'
where sysReportID = @sysReportID