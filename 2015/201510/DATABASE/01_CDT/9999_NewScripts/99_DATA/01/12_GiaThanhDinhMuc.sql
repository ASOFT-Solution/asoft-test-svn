use [CDT]

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
	masp nvarchar (50) null,
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
select masp as [Mã sản phẩm], dmvt.tenvt as [Tên sản phẩm],sln as [Số lượng nhập kho], dddk as [Dở dang đầu kỳ],nvl as [Chi phí nguyên vật liệu], luong as [Chi phí nhân công trực tiếp], CPC as [Chi phí sản xuất chung], ddck as [Dở dang cuối kỳ], gia as [Giá thành] from #t inner join dmvt on #t.masp = dmvt.mavt
drop table #t'
where ReportName = N'Giá thành định mức'