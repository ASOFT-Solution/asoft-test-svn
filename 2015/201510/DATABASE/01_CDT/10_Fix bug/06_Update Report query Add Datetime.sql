use [CDT]

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
union select '''',''ZZZ'',N''Tổng cộng'','''',@tsldk,@tdudau,@tsln,
@tpsno,@tslx,@tpsco,@tslck,@tducuoi
end 
else 
begin 
select b.Nhom, a.mavt,b.tenvt,c.tendvt, a.sldk as N''Tồn đầu'', a.DuDau as N''Dư đầu'', a.sln as N''Số lượng nhập'', a.psno as N''Giá trị nhập'', a.slx as N''Số lượng xuất'', a.psco as N''Giá trị xuất'', a.slck as N''Tồn cuối'', a.DuCuoi as N''Dư cuối'' from wthuong2 a, dmvt b, dmdvt c where a.mavt =b.mavt and b.madvt = c.madvt and  b.nhom=@@nhom
union  all
select '''',''ZZZ'',N''Tổng cộng'','''',@tsldk,@tdudau,@tsln,
@tpsno,@tslx,@tpsco,@tslck,@tducuoi
end

drop view wthuong
drop view wthuong1
drop view wthuong2'
where ReportName = N'Bảng cân đối nhập xuất tồn'


Update sysReport set Query = N'declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @ngayct1=@@ngayct1
set @ngayct2=@@ngayct2

select w.*,dmvt.tenvt ,dmvt.madvt,dt45.mabp from 
(
	select z.mact,z.soct,z.makh,diengiai,y.*  from 
	(select j.*, k.[Tiền phân bổ trong kỳ],k.[Tiền đã phân bổ],j.ps-k.[Tiền phân bổ trong kỳ]- k.[Tiền đã phân bổ]as [Tiền còn lại] from 
		(

			SELECT max(ngayCt) as ngayCt,mt45id,dt45id,sum(soluong) as soluong,sum(slH) as slHong,sum(slHTruoc) as [Số lượng hỏng trước kỳ], sum(ps) as ps,max(tkno) as tkno,max(tkcp) as tkcp, max(mavt) as mavt,max(mabp) as mabp,max(maphi) as maphi,max(mavv) as mavv,sum(kypb) as kypb,sum(soky) as soky from 	
			(	--lấy tất cả các vật tư mà :
				--xuất trong kỳ
				--xuất trước kỳ nhưng thời điểm phân bổ vẫn còn trong kỳ

				select b.ngayCt,a.MT45ID ,DT45ID,a.soluong,0 as slH,0 as slHTruoc,a.mavt,a.ps,a.tkno,a.tkcp,a.mabp,a.maphi,a.mavv,kypb,soky from dt45 a inner join mt45 b on a.mt45id=b.mt45id 
				where (@ngayCt1  between dbo.layngaydauthang(ngayct) and dbo.layngayghiso(dateadd(mm,a.kypb*a.soky-1,b.ngayct))  	
					or
					@ngayCt2  between dbo.layngaydauthang(ngayct) and dbo.layngayghiso(dateadd(mm,a.kypb*a.soky-1,b.ngayct))  	
					or 
					ngayct between @Ngayct1 and @ngayct2)
				union all
				select ''01/01/1900'' as ngayct,MTid as mt45id, dt45id,0 as soluong,slHong as slH,0 as slHTruoc,null as mavt,0.0 as ps,null as tkno, null as tkcp,null as mabp,null as maphi,null as mavv,0 as kypb,0 as soky  from InvHongcc 	
				where ngayct between @ngayct1 and @ngayct2  	
				union all
				select ''01/01/1900'' as ngayct,MTid as mt45id, dt45id,0 as soluong, 0 as slH,slHong as slHTruoc,null as mavt,0.0 as ps,null as tkno,null as tkcp,null as mabp,null as maphi,null as mavv,0 as kypb,0 as soky from InvHongcc	
				where ngayct < @ngayct1  
			) x group by mt45id,dt45id
		) j full join 
		(	
			select mt45id = case when m.mt45id is null then n.mt45id else m.mt45id end, dt45id = case when m.dt45id is null then n.dt45id else m.dt45id end,
				[Tiền phân bổ trong kỳ]= case when  m.[Tiền phân bổ trong kỳ] is null then 0 else m.[Tiền phân bổ trong kỳ] end  ,[Tiền đã phân bổ]= case when  n.[Tiền đã phân bổ] is null then 0 else n.[Tiền đã phân bổ] end from
			(
				select mtid as mt45id, mtiddt as dt45id, sum(psno) as [Tiền phân bổ trong kỳ] from bltk
				where (ngayct between @ngayct1 and @ngayct2) and nhomdk=''PBC'' group by mtid, mtiddt
			)m full join 
			(	select mt45id, dt45id, sum([Tiền đã phân bổ]) as [Tiền đã phân bổ] from
				(
					
					select m.mt45id, d.dt45id, [Tiền đã phân bổ] = case when datediff(month,ngayct,''01/01/2009'') < soky*kypb then round(ps/soky * (datediff(month,ngayct,''01/01/2009'')/kypb),0) else ps end
					from mt45 m inner join dt45 d on m.mt45id = d.mt45id where dodang = 1
					union
					select mtid as mt45id, mtiddt as dt45id, psno as [Tiền đã phân bổ] from bltk
					where (ngayct < @ngayct1 ) and nhomdk=''PBC''
				)x group by mt45id, dt45id
			)n on m.dt45id=n.dt45id
		) k on j.dt45id = k.dt45id
	) y inner join mt45 z on y.mt45id=z.mt45id where soluong>=slHong+[Số lượng hỏng trước kỳ]


)w inner join dmvt on w.mavt=dmvt.mavt
inner join dt45 on w.dt45id=dt45.dt45id
order by ngayct, soct
'
where ReportName = N'Báo cáo chi tiết phân bổ công cụ dụng cụ'


Update sysReport set Query = N'declare @nodauky float
declare @codauky float

declare @nocuoiky float
declare @cocuoiky float

declare @Tongpsno float
declare @Tongpsco float

declare @tungay datetime
declare @denngay datetime 

set @tungay = @@Ngayct1
set @denngay = dateadd(hh,23,@@Ngayct2)

declare @datetemp datetime
set @datetemp = dateadd(d,1,@denngay)
declare @datetemptungay datetime
set @datetemptungay = dateadd(hh,-1,@tungay)
declare @tk varchar(10)
set @tk = @@tk

execute Sodutaikhoan @tk,@datetemptungay,''@@ps'',@nodauky output,@codauky output

execute Sodutaikhoan @tk,@denngay,''@@ps'',@nocuoiky output, @cocuoiky output

execute Sopstaikhoan @tk,@tungay,@denngay,''@@ps'',@Tongpsno output,@Tongpsco output

	(
	Select null as MaCT, null as [Ngày ghi sổ], '''' as SoCT,null  as NgayCT, N''Đầu kỳ'' as DienGiai, ''''as Tkdu, @nodauky as PsNo,@codauky as Psco,'''' as Ghichu, 0 as Stt
	)
union all
	(
	Select mact, dbo.LayNgayGhiSo(NgayCT) as [Ngày ghi sổ], SoCt, NgayCT, DienGiai, Tkdu, PsNo, Psco, '''' as Ghichu,1
	from bltk
	where left(tk,len(@tk)) = @tk and  (NgayCt between @tungay and       @denngay) 
	)
union all
	(
	Select null as  mact,null  as [Ngày ghi sổ], '''',null , N''Tổng phát sinh'' as DienGiai, ''''as Tkdu,@Tongpsno as PsNo,@Tongpsco as Psco,'''' as Ghichu,2
	)
union all
	(
	Select null as  mact,null , '''',null , N''Cuối kỳ'' as DienGiai, ''''as Tkdu,@nocuoiky as PsNo,@cocuoiky as Psco,'''' as Ghichu,3
	)
order by stt, ngayct, soct'
where ReportName = N'Sổ cái CTGS'

Update sysReport set Query = N'declare @tkrp nvarchar(20)
declare @dauky float,@daukynt float
declare @thu float,@thunt float
declare @chi float,@chint float
declare @ton float
declare @tonnt float
declare @id int
declare @tungayCt datetime,@ngaydk datetime
declare @denngayCt datetime
set @tuNgayCt=@@NgayCT1
set @denNgayCt=dateadd(hh,23,@@NgayCT2)
set @ngaydk=dateadd(hh,-1,@tungayct)
set @tkrp=@@TK

declare @nodk float,@nodknt float
declare @codk float,@codknt float
	exec sodutaikhoannt @tkrp,@ngaydk,''@@ps'',@Nodk output, @Codk output,@NoDkNt output, @CoDkNt output
set @dauky = @nodk
set @daukynt = @nodknt
declare cur cursor for 
SELECT min(bltkID) as  bltkID, sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(PsNoNt) as TienThuNt, sum(PsCoNt) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS group by MTID, NgayCT,SoCT order by NgayCT,SoCT

create table #t
 (
	[bltkID] [int]   NULL ,	
	[Thu] [decimal](18, 3) NULL ,
	[Chi] [decimal](18, 3) NULL ,
	[ThuNt] [decimal](18, 3) NULL ,
	[ChiNt] [decimal](18, 3) NULL ,
	[ton] [decimal](18, 3) NULL,
	[tonNt] [decimal](18, 3) NULL  
) ON [PRIMARY]

insert into #t select min(bltkID) as bltkID,sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(PsNoNt) as TienThuNt, sum(PsCoNt) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS group by MTID, NgayCT,SoCT order by ngayCT,SoCT
declare @tmp float,@tmpnt float
set @tmp=@dauky
set @tmpnt = @daukynt
open cur
fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt
while @@fetch_status=0
begin
	set @ton=@tmp+@thu-@chi
	set @tmp=@ton
	set @tonnt=@tmpnt+@thunt-@chint
	set @tmpnt=@tonnt
	UPDATE #t SET ton=@ton,tonnt=@tonnt where bltkid=@id
	fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt
	
end
close cur
deallocate cur

select x.*,dmkh.tenkh
from
((
select '''' as bltkid ,'''' as soct,null as ngayct,'''' as ongba , '''' as maKH, N''Đầu kỳ'' as diengiai, '''' as tkdu,'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt)
union all
(SELECT a.bltkid, a.SoCT, a.NgayCT,a.OngBa as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1
from bltk a, #t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by stt, ngayct,soct
drop table #t'
where ReportName = N'Sổ quỹ tiền mặt'

Update sysReport set Query = N'declare @tkrp nvarchar(20)
declare @dauky float,@daukynt float

declare @thu float,@thunt float
declare @chi float,@chint float
declare @ton float
declare @tonnt float
declare @id int
declare @tungayCt datetime,@ngaydk datetime
declare @denngayCt datetime
set @tuNgayCt=@@NgayCT1
set @denNgayCt=dateadd(hh,23,@@NgayCT2)
set @ngaydk=dateadd(hh,-1,@tungayct)
set @tkrp=@@TK

declare @nodk float,@nodknt float
declare @codk float,@codknt float
	exec sodutaikhoannt @tkrp,@ngaydk,''@@ps'',@Nodk output, @Codk output,@NoDkNt output, @CoDkNt output
set @dauky = @nodk
set @daukynt = @nodknt
declare cur cursor for 
SELECT bltkID, PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS order by NgayCT,SoCT

create table #t
 (
	[bltkID] [int]   NULL ,	
	[Thu] [decimal](18, 3) NULL ,
	[Chi] [decimal](18, 3) NULL ,
	[ThuNt] [decimal](18, 3) NULL ,
	[ChiNt] [decimal](18, 3) NULL ,
	[ton] [decimal](18, 3) NULL,
	[tonNt] [decimal](18, 3) NULL  
) ON [PRIMARY]

insert into #t select bltkID ,PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS order by ngayCT,SoCT
declare @tmp float,@tmpnt float
set @tmp=@dauky
set @tmpnt = @daukynt
open cur
fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt
while @@fetch_status=0
begin
	set @ton=@tmp+@thu-@chi
	set @tmp=@ton
	set @tonnt=@tmpnt+@thunt-@chint
	set @tmpnt=@tonnt
	UPDATE #t SET ton=@ton,tonnt=@tonnt where bltkid=@id
	fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt
	
end
close cur
deallocate cur

select x.*,dmkh.tenkh
from
((
select '''' as bltkid ,'''' as soct,null as ngayct,'''' as ongba , '''' as maKH, N''Đầu kỳ'' as diengiai, '''' as tkdu,'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt )
union all
(SELECT a.bltkid, a.SoCT, a.NgayCT,a.OngBa as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1
from bltk a, #t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by Stt, ngayct,soct
drop table #t'
where ReportName = N'Sổ tiền gởi ngân hàng'

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

select y.tenvt,z.tenkho, x.* from (
                select null NgayCT, null SoCT, null TenKH, N''Tồn đầu kỳ'' DienGiai, null DonGia,@mavt mavt,@makho makho,
		 null SoLuong, @gtdk as [Giá trị nhập], null SoLuong_X, null [Giá trị xuất], @dk as SlTon
	union all
	Select NgayCT, SoCT, dmkh.TenKH , DienGiai, DonGia,@mavt mavt,@makho makho,
		SoLuongN = #t.sln, GiaTriN = case when PsNo > 0 then PsNo else null end,
		SoLuongX = #t.slx, GiaTriX = case when PsCo > 0 then PsCo else null end, SlTon = #t.SlTon
	from blvt, dmkh, #t
	where #t.blvtid = blvt.blvtid and blvt.MaKH *= dmkh.MaKH and NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and MaVT = @mavt) x, dmvt y,dmkho z
where x.mavt =y.mavt and x.makho=z.makho
order by NgayCT, SoCT

drop table #t'
where ReportName = N'Thẻ Kho'

Update sysReport set Query = N'declare @tk varchar(16)
declare @codauky float
declare @nodauky float

declare @cocuoiky float
declare @nocuoiky float

declare @tungay datetime
declare @denngay datetime 
declare @datetemp datetime
declare @ngaydk datetime
declare @dauky float
declare @cuoiky float

set @tungay = @@ngayct1
set @denngay = dateadd(hh,23,@@ngayct2)

set @datetemp = dateadd(hh,1,@denngay)
set @ngaydk=dateadd(hh,-1,@tungay)
set @tk = @@TK

    execute Sodutaikhoan @tk,@ngaydk,''@@ps'',@nodauky output,@codauky       output

    execute Sodutaikhoan @tk,@datetemp,''@@ps'',@nocuoiky output, @cocuoiky        output
select tkdu, TenTk, psno, psco from
(
select 0 as stt, '''' as Tkdu, N''Đầu kỳ'' as TenTK ,@nodauky as PsNo,@codauky as Psco
union all
(
Select 1 as stt, bltk.Tkdu,dmtk.Tentk as TenTK, Sum(PsNo), Sum(PsCo)
from bltk,dmtk
where bltk.Tkdu *= dmtk.tk and  left(bltk.tk,len(@tk)) = @tk and (NgayCt between @tungay and       @denngay) 
group by bltk.tkdu, dmtk.tentk
)
union all
select 2 as stt, '''' as Tkdu, N''Cuối kỳ'' as TenTK, @nocuoiky as psno,@cocuoiky as psco) x order by stt
'
where ReportName = N'Tổng hợp chữ T 1 tài khoản'

Update sysReport set Query = N'declare @tk nvarchar(16)
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
set @sql=''create view wsotk as select makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by makh ''
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
sum(psnont)as psnont,sum(psno)as psno, sum(pscont) as pscont, sum(psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) and cast('''''' + convert(nvarchar,dateadd(d,1,@ngayCt1)) + '''''' as datetime) and '' + @@ps + '' group by makh''

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
select a.makh,b.tenkh,a.nodaunt as [Nợ đầu nguyên tệ],a.nodau as [Nợ đầu],a.codaunt as [Có đầu nguyên tệ],a.codau as [Có đầu],a.psnont,a.psno,a.pscont,a.psco,a.nocuoint as [Nợ cuối nguyên tệ], a.nocuoi as [Nợ cuối],a.cocuoint as [Có cuối nguyên tệ],a.cocuoi as [Có cuối] from wkq a left join dmkh b on  a.makh=b.makh
drop view wsodu
drop view wsotk
drop view wG1
drop view wsops
drop view wdudau
drop view wG2
drop view wkq
'
where ReportName = N'Bảng cân đối phát sinh công nợ'

Update sysReport set Query = N'select fr.Stt, fr.ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.ChiTieu2, fr.CachTinh, fr.LoaiCT, fr.InBaoCao,iscn
	,999999999999999.0  as [Đầu năm]
	,999999999999999.0 as [Cuối kỳ]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID
	order by Stt
declare @ngayCt1 datetime
declare @ngayCt2 datetime
	set @ngayCt1=@@NgayCt1
	set @ngayCt2=DATEADD(hh,23,@@NgayCt2)
set @ngayCt1= dateadd(hh,-1,@ngayCt1)
declare cur cursor for select Maso,cachtinh,loaiCt,tk,tkdu,iscn,[Đầu năm],[Cuối kỳ] from t
	open cur
declare @Maso nvarchar (50)
declare @Cachtinh nvarchar(256)
declare @LoaiCt int
declare @tk nvarchar (16)
declare @tkdu nvarchar (16)
declare @iscn bit 
declare @daunam float
declare @cuoiky float
--Tính các ch? tiêu
declare @duno float
declare @duco float
declare @duno1 float
declare @duco1 float
fetch cur  into @Maso,@Cachtinh,@LoaiCt,@tk,@tkdu,@iscn,@daunam,@cuoiky
while @@fetch_status=0
begin
	--L?y s? d?u nam
	if @tk is not null and @loaiCt<>0
	begin
		
		exec sodutaikhoan @tk, @ngayCt1, DEFAULT, @duno OUTPUT , @duco OUTPUT 
		if @iscn=1
			begin	
				set @daunam=0
				if @loaiCt=5 set @daunam=@duno
				if @loaiCt=6 set @daunam=@duco
			end
		if @iscn=0
			begin	
				set @duno1= @duno-@duco 
				set @duco1= @duco-@duno 
				set @daunam=0
				if @loaiCt=5 set @daunam=@duno1
				if @loaiCt=6 set @daunam=@duco1
			end
		

		--L?y s? cu?i k?
		exec sodutaikhoan @tk, @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
	 	if @iscn=1
			begin	
				set @cuoiky=0
				if @loaiCt=5 set @cuoiky=@duno
				if @loaiCt=6 set @cuoiky=@duco
			end
		if @iscn=0
			begin	
				set @duno1= @duno-@duco 
				set @duco1= @duco-@duno 
					set @cuoiky=0
				if @loaiCt=5 set @cuoiky=@duno1
				if @loaiCt=6 set @cuoiky=@duco1
			end

		UPDATE t SET [Đầu năm]=@daunam where Maso=@Maso
		UPDATE t SET [Cuối kỳ]=@cuoiky where Maso=@Maso
		
	end
	fetch cur  into @Maso,@cachtinh, @LoaiCt,@tk,@tkdu,@iscn,@daunam,@cuoiky
end
close cur
deallocate cur
update t set [Đầu năm]=0,[Cuối kỳ]=0 where loaict=0
select * from t
drop table t

'
where ReportName = N'Bảng cân đối kế toán'

Update sysReport set Query = N'select fr.Stt, fr.ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.ChiTieu2, fr.CachTinh, fr.LoaiCT, fr.InBaoCao
	,999999999999999.0  as [Kỳ trước]
	,999999999999999.0 as [Kỳ này]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID
	order by Stt

declare @ngayCt1 datetime
declare @ngayCt2 datetime
declare @ngayCt3 datetime
declare @ngayCt4 datetime
	set @ngayCt1=@@NgayCt1--''03/01/2008''
	--set @ngayCt1= dateadd(day,-1,@ngayCt1)
	set @ngayCt2=DATEADD(hh,23,@@NgayCt2)--''01/01/2009''
	set @ngayCt3=@@Ngaydktruoc1--''01/01/2008''
	--set @ngayCt3= dateadd(day,-1,@ngayCt3)
	set @ngayCt4=DATEADD(hh,23,@@Ngaydktruoc2)
declare cur cursor for select Maso,loaiCt,tk,tkdu,[Kỳ trước],[Kỳ này] from t
	open cur
declare @Maso nvarchar (50)
declare @LoaiCt int
declare @tk nvarchar (256)
declare @tkdu nvarchar (256)
declare @KyTruoc float
declare @KyNay float
--Tính các ch? tiêu
declare @psno float
declare @psco float
fetch cur  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
while @@fetch_status=0
begin
	--Lay so phat sinh ky truoc
	if @tk is not null and @loaiCt<>0
	begin
		if @tkdu is not null 
		begin		
			set @tkdu = replace(@tkdu,'' '','''')
			set @tkdu='' tkdu like'''''' +replace(@tkdu,'','',''%'''' or tkdu like'''''') + ''%'''''' 
			exec sopstaikhoan @tk, @ngayCt3,@ngayCt4,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
		else exec sopstaikhoan @tk, @ngayCt3,@ngayCt4, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		
		if @loaiCt=3 set @KyTruoc=@psno
		if @loaiCt=4 set @KyTruoc=@psco

		--L?y s? cu?i k?
if @tkdu is not null 
		begin					
			exec sopstaikhoan @tk, @ngayCt1,@ngayCt2,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
else 		exec sopstaikhoan @tk, @ngayCt1,@ngayCt2, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		if @loaiCt=3 set @KyNay=@psno
		if @loaiCt=4 set @KyNay=@psco

		UPDATE t SET [Kỳ trước]=@KyTruoc where Maso=@Maso
		UPDATE t SET [Kỳ này]=@KyNay where Maso=@Maso
		
	end
fetch cur  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
end
close cur
deallocate cur
update t set [Kỳ trước]=0,[Kỳ này]=0 where loaict=0
select * from t
drop table t
drop table t
--update t set daunam=0.1
'
where ReportName = N'Báo cáo kết quả kinh doanh'

Update sysReport set Query = N'select fr.Stt, fr.ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.ChiTieu2, fr.CachTinh, fr.LoaiCT, fr.InBaoCao
	,999999999999999.0  as [Kỳ trước]
	,999999999999999.0 as [Kỳ này]
	into t
	from sysFormReport fr
	where fr.sysReportID = @@sysReportID
	order by Stt

declare @ngayCt1 datetime
declare @ngayCt2 datetime
declare @ngayCt3 datetime
declare @ngayCt4 datetime
	set @ngayCt1=@@NgayCt1--''03/01/2008''
	--set @ngayCt1= dateadd(day,-1,@ngayCt1)
	set @ngayCt2=dateadd(hh,23,@@NgayCt2)
	set @ngayCt3=@@Ngaydktruoc1--''01/01/2008''
	--set @ngayCt3= dateadd(day,-1,@ngayCt3)
	set @ngayCt4=dateadd(hh,23,@@Ngaydktruoc2)
declare cur cursor for select Maso,loaiCt,tk,tkdu,[Kỳ trước],[Kỳ này] from t
	open cur
declare @Maso nvarchar (50)
declare @LoaiCt int
declare @tk nvarchar (1000)
declare @tkdu nvarchar (1000)
declare @KyTruoc float
declare @KyNay float
--Tính các ch? tiêu
declare @psno float
declare @psco float
fetch cur  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
while @@fetch_status=0
begin
	--Lay so phat sinh ky truoc
	if @tk is not null and @loaiCt<>0
	begin
		if @tkdu is not null 
		begin		
			set @tkdu = replace(@tkdu,'' '','''')
			set @tkdu='' tkdu like'''''' +replace(@tkdu,'','',''%'''' or tkdu like'''''') + ''%'''''' 
			exec sopstaikhoan @tk, @ngayCt3,@ngayCt4,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
		else exec sopstaikhoan @tk, @ngayCt3,@ngayCt4, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		
		if @loaiCt=3 set @KyTruoc=@psno
		if @loaiCt=4 set @KyTruoc=@psco

		if @loaict = 1 or @loaict = 2
		begin
			declare @ngayCt datetime
			set @ngayCt= dateadd(hh,-1,@ngayCt3)
			exec sodutaikhoan @tk, @ngayCt, DEFAULT, @PSNO OUTPUT , @PSCO OUTPUT 
			if @loaict = 1 set @KyTruoc = @psno
			if @loaict = 2 set @KyTruoc = @psco
		end
		--L?y s? cu?i k?
if @tkdu is not null 
		begin					
			exec sopstaikhoan @tk, @ngayCt1,@ngayCt2,@tkdu , @psno OUTPUT , @psco OUTPUT 
		end
else 		exec sopstaikhoan @tk, @ngayCt1,@ngayCt2, DEFAULT, @psno OUTPUT , @psco OUTPUT 
		if @loaiCt=3 set @KyNay=@psno
		if @loaiCt=4 set @KyNay=@psco

		if @loaict = 1 or @loaict = 2
		begin
			set @ngayCt= dateadd(hh,-1,@ngayCt1)
			exec sodutaikhoan @tk, @ngayCt, DEFAULT, @PSNO OUTPUT , @PSCO OUTPUT 
			if @loaict = 1 set @KyNay = @psno
			if @loaict = 2 set @KyNay = @psco
		end
		UPDATE t SET [Kỳ trước]=@KyTruoc where Maso=@Maso
		UPDATE t SET [Kỳ này]=@KyNay where Maso=@Maso
		
	end
fetch cur  into @Maso,@LoaiCt,@tk,@tkdu,@KyTruoc,@KyNay
end
close cur
deallocate cur
update t set [Kỳ trước]=0,[Kỳ này]=0 where loaict=0
select * from t
drop table t
--update t set daunam=0.1
'
where ReportName = N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp'

Update sysReport set Query = N'declare @tkrp varchar(16)
set @tkrp=@@TK
declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @NgayCt1=@@NgayCt1
set @NgayCt2=dateadd(hh,23,@@NgayCt2)
set @ngayct1=dateadd(hh,-1,@ngayct1)
--L?y s? d?u k?
declare @nodk float
declare @codk float
	exec sodutaikhoan @tkrp,@ngayCt1,''@@ps'',@nodk output, @codk output
set @ngayct1=dateadd(hh,1,@ngayct1)
--L?y s?  phát sinh
declare @nock float
declare @cock float
	exec sodutaikhoan @tkrp,@ngayCt2,''@@ps'',@nock output, @cock output
declare @nophatsinh float
declare @phatsinhco float
select @nophatsinh=sum(psno) from bltk where ngayct between @@ngayct1 and @@ngayct2 and tk like @@tk+''%'' and @@ps
select @phatsinhco=sum(psco) from bltk where ngayct between @@ngayct1 and @@ngayct2 and tk like @@tk+''%'' and @@ps
select null as ngayct,null as MTID,null as MaCT,null as soct, N''Đầu kỳ'' as diengiai,
null as tkdu,@nodk as psno,@codk as psco, null as makh, null  as tenkh, 0 as Stt
union  all
select a.ngayCt,MTID, a.mact, a.SoCt, a.diengiai, a.tkdu, a.psno, a.psco, a.maKH, b.tenkh, 1 
from bltk a, dmkh b 
where a.makh*=b.makh and  left(a.tk,len(@tkrp))=@tkrp and (a.ngayCt between @ngayCT1 and @ngayCT2 ) and @@ps
union all
select null as ngayct,null as MTID, null as mact, null as soct, N''Tổng phát sinh'' diengiai,
   null as tkdu, @nophatsinh as psno, @phatsinhco  as psco, null as makh, null as tenkh, 2
union all
select null as ngayct,null as MTID, null as mact, null as soct, N''Cuối kỳ'' as Diengiai,
   null as tkdu, @nock as psno, @cock as psco, null as makh, null as tenkh, 3
order by Stt,Ngayct,mact desc'
where ReportName = N'Sổ chi tiết tài khoản'

Update sysReport set Query = N'declare @ngayct datetime
declare @ngayCt1 datetime
declare @sql nvarchar (4000)
set @ngayct=@@ngayCt1
set @ngayct1=dateadd(hh,23,@@ngayCt2)

--phần cân đối công nợ
set @sql=''create view wcongno as 
select tk,makh,0.0 as nodau, 0.0 as codau,sum(psno) as psno,sum(psco) as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno=1) and ngayCt  between cast('''''' + convert(nvarchar,@ngayCt) + '''''' as datetime) and  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) group by tk,makh
union all
select tk,makh,0.0 as nodau, 0.0 as codau,0.0 as psno,0.0 as psco, sum(psno) as lkno, sum(psco) as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno=1) and ngayCt  <=  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) and year(ngayct) = year(cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime)) group by tk,makh
union all
select tk,makh,sum(duno) as nodau,sum(duco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from obkh group by tk, makh
union all
select tk,makh,sum(psno)as nodau, sum(psco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno=1) and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by tk, makh''

exec (@sql)
set @sql=''create view wcongno1 as
select tk,sum(nodau) as nodau, sum(codau) as codau, sum(psno) as psno, sum(psco) as psco, sum(lkno) as lkno, sum(lkco) as lkco, sum(nocuoi) as nocuoi,sum(cocuoi) as cocuoi from wcongno group by tk''
exec (@sql)
set @sql=''create view wcongno2 as
select tk, nodau,  codau, psno,  psco, lkno, lkco,   nocuoi = case when nodau+psno-codau-psco >0 then nodau+psno-codau-psco else 0 end, cocuoi = case when nodau+psno-codau-psco <0 then abs(nodau+psno-codau-psco) else 0 end from wcongno1 ''
exec (@sql)
set @sql=N''create view wcongno3 as 
select tk,  [Nợ đầu] = case when nodau-codau>=0 then nodau-codau else 0 end,  
[Có đầu] = case when nodau-codau<0 then codau-nodau else 0 end, psno,  psco, lkno as [Lũy kế nợ], lkco as [Lũy kế có], [Nợ cuối] = case when nodau+psno-codau-psco >0 then nodau+psno-codau-psco else 0 end, [Có cuối] = case when nodau+psno-codau-psco <0 then abs(nodau+psno-codau-psco) else 0 end from wcongno1''

exec (@sql)
--phần cân đối tk thường
set @sql=''create view wthuong as 
select tk,0.0 as nodau, 0.0 as codau,sum(psno) as psno,sum(psco) as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt between cast('''''' + convert(nvarchar,@ngayCt) + '''''' as datetime) and  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) group by tk
union all
select tk,0.0 as nodau, 0.0 as codau,0.0 as psno,0.0 as psco, sum(psno) as lkno, sum(psco) as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt  <=  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) and year(ngayct) = year(cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime)) group by tk
union all
select tk,sum(duno) as nodau,sum(duco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi  from obtk where tk in(select tk from dmtk where tkcongno<>1) group by tk
union all
select tk,sum(psno) as nodau,sum(psco) as codau,0.0 as psno, 0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt < cast('''''' + convert(nvarchar,@ngayCt) + '''''' as datetime) group by tk''
exec (@sql)
set @sql=''create view wthuong1 as
select tk, sum(nodau) as nodau, sum(codau) as codau, sum(psno) as psno, sum(psco) as psco, sum(lkno) as lkno, sum(lkco) as lkco, sum(nocuoi) as nocuoi,sum(cocuoi) as cocuoi from wthuong group by tk''
exec (@sql)
set @sql=N''create view wthuong2 as
select tk,  [Nợ đầu] = case when nodau-codau>=0 then nodau-codau else 0 end,  
[Có đầu] = case when nodau-codau<0 then codau-nodau else 0 end, psno,  psco, lkno as [Lũy kế nợ], lkco as [Lũy kế có], [Nợ cuối] = case when nodau+psno-codau-psco >0 then nodau+psno-codau-psco else 0 end, [Có cuối] = case when nodau+psno-codau-psco <0 then abs(nodau+psno-codau-psco) else 0 end from wthuong1 ''
exec (@sql)
declare @tnodk decimal(20,6), @cnodk decimal(20,6)
declare @tcodk decimal(20,6), @ccodk decimal(20,6)
declare @tpsno decimal(20,6), @cpsno decimal(20,6)
declare @tpsco decimal(20,6), @cpsco decimal(20,6)
declare @tlkno decimal(20,6), @clkno decimal(20,6)
declare @tlkco decimal(20,6), @clkco decimal(20,6)
declare @tnock decimal(20,6), @cnock decimal(20,6)
declare @tcock decimal(20,6), @ccock decimal(20,6)
select @tnodk= sum([Nợ đầu]), @tcodk = sum([Có đầu]),
	@tpsno = sum(psno), @tpsco = sum(psco),
	@tlkno = sum([Lũy kế nợ]), @tlkco = sum([Lũy kế có]),
	@tnock = sum([Nợ cuối]), @tcock = sum([Có cuối]) from wthuong2
select @cnodk= sum([Nợ đầu]), @ccodk = sum([Có đầu]),
	@cpsno = sum(psno), @cpsco = sum(psco),
	@clkno = sum([Lũy kế nợ]), @clkco = sum([Lũy kế có]),
	@cnock = sum([Nợ cuối]), @ccock = sum([Có cuối]) from wcongno3

select b.TkMe,a.Tk,b.tentk,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wcongno3 a inner join dmtk b on a.tk = b.tk
union all
select b.TkMe,a.Tk,b.tentk,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wthuong2  a  inner join dmtk b on a.tk = b.tk
union all
select '''' as TkMe,''T'' as Tk, N''Tổng cộng'' as tentk, @tnodk + @cnodk as nodau, @tcodk + @ccodk as codau,@tpsno + @cpsno as psno, @tpsco + @cpsco as psco, @tlkno + @clkno as lkno, @tlkco + @clkco as lkco,@tnock + @cnock as nocuoi, @tcock + @ccock as cocuoi
order by tkme, a.tk

drop view wcongno
drop view wcongno1
drop view wcongno2
drop view wcongno3
drop view wthuong
drop view wthuong1
drop view wthuong2'
where ReportName = N'Bảng cân đối số phát sinh'

Update sysReport set Query = N'declare @TuThang int
declare @DenThang int
set @TuThang = @@Thang1
set @DenThang = @@Thang2

Declare @TuNgay datetime
Declare @DenNgay datetime

set @TuNgay  = cast((Convert(nvarchar,@tuThang) +''/01''+ ''/@@Nam'') as Datetime)
set @DenNgay = cast((Convert(nvarchar,@DenThang) + ''/01'' + ''/@@Nam'') as Datetime)
set @DenNgay = Dateadd(d,-1,DateAdd(m,1,@DenNgay))

Select x.TK TKKH, dmtk1.TenTK [Tên tài khoản], x.TKDu TKCP, dmtk2.TenTK [Tên tài khoản chi phí], Sum(x.PsCo) as [Khấu hao]
from
(
select TK, TKDu, PSCo from bltk where nhomdk = ''khts'' and ngayct between 
         @TuNgay and @DenNgay
) as x, dmtk dmtk1, dmtk dmtk2
where x.TK = dmtk1.TK and x.TKDu = dmtk2.TK
group by x.TK, x.TKDu, dmtk1.TenTK, dmtk2.TenTk
having Sum(PsCo) > 0'
where ReportName = N'Bảng phân bổ khấu hao TSCD'

Update sysReport set Query = N'declare @TuThang int
declare @DenThang int
set @TuThang = @@thang1
set @DenThang =@@thang2

Declare @TuNgay datetime
Declare @DenNgay datetime
set @TuNgay  = cast((Convert(nvarchar,@TuThang) +''/01'' + ''/@@nam'') as  Datetime)
set @DenNgay = cast((Convert(nvarchar,@DenThang) + ''/01'' + ''/@@nam'') as  Datetime)
set @DenNgay = Dateadd(d,-1,DateAdd(m,1,@DenNgay))
SELECT xy.MaTS, TenTS, TKKH, NgayKH, SoThang, NguyenGia as  [Nguyên giá đầu kỳ], KHTruocKy as [Đã khấu hao đầu kỳ], [Giá trị còn lại đầu kỳ] = NguyenGia - KHTruocKy,
 	KHTrongKy as [Khấu hao],[Hao mòn lũy kế]=KHTruocKy+KHTrongKy,
	[Nguyên giá cuối kỳ] = NguyenGia + (case when t.NguyenGiaT is null then 0.0 else t.NguyenGiaT end) , 
	[Giá trị còn lại cuối kỳ] = NguyenGia + (case when t.NguyenGiaT is null then 0.0 else t.NguyenGiaT end) - KHTruocKy  - KHTrongKy
	from
	(select MaTS,NguyenGiaT = sum(NguyenGia1 + NguyenGia2 + NguyenGia3 + NguyenGia4)
			from FaNguyenGia 
			where NgayCT between @TuNgay and @DenNgay group by mats) t,
	(
 		Select x.MaTS, TenTS, TKKH, NgayKH, SoThang, NguyenGia, KHTruocKy = case when y.DaKH is null then x.DaKH  else x.DaKH + y.DaKH end
   		from
  		(
			Select dmtscd.MaTS, TenTS, TKKH, SoThang, NguyenGia = NguyenGia1 + NguyenGia2 + NguyenGia3 + NguyenGia4 
    			+ case when x.nguyengiaT is null then 0.0 else nguyengiaT end
				,DaKH = DaKH1 + DaKH2 + DaKH3 + DaKH4, NgayKH
    			from dmtscd, (Select mats, nguyengiaT = Nguyengia1 + nguyengia2 + nguyengia3 + NguyenGia4 from FaNguyenGia       
				where FaNguyenGia.NgayCT < @TuNgay) x
   			where x.MaTS =* dmtscd.mats and NgayTangTS < @DenNgay
		) as x,
  		(Select SoCT as MaTS,Sum(PSCo) as DaKH
     				from bltk
     				where nhomdk = ''khts'' and ngayct < @TuNgay and PSCo <> 0
    				group by SoCT
		) as y
    		where x.MaTS *= y.MaTS and x.MaTS not in(Select MaTS from FaGiamTS where ngayct < @TuNgay)
		
	) as xy,

	(Select SoCT as MaTS, Sum(PsCo) as KHTrongKy
		from bltk
		where ngayct between @TuNgay and @DenNgay and nhomdk = ''khts'' and PSCo <> 0 
		group by SoCT
	) as z
	where xy.MaTS = z.MaTS and xy.mats *= t.mats
'
where ReportName = N'Bảng tính khấu hao TSCD'

Update sysReport set Query = N'declare @ngayct datetime
declare @MaYT nvarchar(16)
set @ngayct=''@@thang/01/@@Nam''
set @MaYT=@@MaYT
declare @tungay datetime
declare @denngay datetime
declare @tk nvarchar (16)
declare @BangDM nvarchar (256)
declare @TruongSP nvarchar (256)
declare @Mavt nvarchar (256)
declare @Heso nvarchar (256)
declare @manhom varchar (16)
--lấy các thông tin
set @tungay = dbo.LayngayDauthang(@ngayct)
set @denngay = dateadd(hh,23,dbo.LayngayGhiso(@ngayct))
declare cur cursor for select bangdm,truongsp,mavt,heso,tk from dmytgt where rtrim(mayt)=@MaYT
open cur
fetch cur  into @BangDM,@truongSP,@maVT,@heso,@tk

close cur
deallocate cur

declare cur cursor for select manhom from codtgt where rtrim(mayt)=@MaYT

open cur
fetch cur  into @manhom

close cur
deallocate cur
if (@manhom is not null)
begin
	--tạo bảng định mức cố định từ các bảng định mức động
	declare @sql nvarchar (256)
	set @sql=''create view vdfnvl as select '' + @TruongSP + '' as MaSP,'' +   @Mavt + '' as MaVT,''+ @Heso + '' as SoLuong from '' + @BangDM 
	set @sql= @sql + '' where ngayCt between cast('''''' + convert(nvarchar(40),@tungay) + '''''' as datetime) and cast('''''' + convert(nvarchar(40),@denngay) + '''''' as datetime)''
	exec (@sql)

select k.mavt as [Vật tư], dmvt.tenvt, soluongdddk as [Số lượng dở dang đầu kỳ], soluongdm as [Số lượng định mức],soluongddck as [Số lượng dở dang cuối kỳ],soluongx as [Số lượng xuất], psco as [Giá trị xuất],soluongx-soluongdm+soluongdddk-soluongddck as [Số lượng hao hụt], [Đơn giá] = case when soluongx>0 then psco/soluongx else 0 end,[Giá trị hao hụt]=case when soluongx>0 then psco*(soluongx-soluongdm+soluongdddk-soluongddck)/soluongx else 0 end from 
(
	select q.*, soluongddck=case when  r.soluongddck is not null then  r.soluongddck else 0 end from 
	(
		select h.*,soluongdddk=case when  m.soluongdddk is not null then  m.soluongdddk else 0 end  from
		(
			select j.Mavt,j.TongNVL as soluongdm, soluongx=case when i.soluongx is not null then i.soluongx else 0 end ,psco= case when i.psco is not null then i.psco else 0 end from 
				(--Nguyên vật liệu xuất
					select mavt,Sum(soluong_x-soluong) as soluongx, sum(psco-psno) as psco from blvt 
							where cast(mtid as nvarchar(36)) +  cast(mtiddt as nvarchar(36)) in 
								(select cast(mtid as nvarchar(36))+  cast(mtiddt as nvarchar(36))  from bltk 
									where  left(tk,len(@tk))=@tk
									and ngayct between @tungay and @denngay
					
								) 
							 group by mavt
				)i full join 
				(--Nguyên vật liệu định mức
					select x.mavt,sum(soluongxDM) as Tongnvl from 
					(	select a.masp,a.soluongN, b.mavt, b.soluong,a.soluongN*b.soluong as soluongxDM from
						(
							(
								select mavt as masp,sum(soluong) as soluongN from blvt 
								where mavt in(select mavt from dmvt where loaivt=4 and nhomgt=@manhom ) and mact=''NSX'' 
									and (ngayct between @tungay and @denngay)
								group by mavt	
							) a inner join 
							( 	
								select masp,mavt,soluong from vdfnvl
							) b on a.masp=b.masp
						)
					) x group by mavt
				)j on i.mavt=j.mavt
		) h left join 
		(--Dở dang đầu kỳ
			select sum(soluong) as soluongdddk, mavt from coNVLDD  where ngayct between dateadd(MM,-1,@tungay) and dateadd(MM,-1,@denngay) group by mavt
		)m on h.mavt=m.mavt 	
	) q left join 
	(--Dở dang cuối kỳ
		select sum(soluong) as soluongddck, mavt from coNVLDD  where ngayct between @tungay and @denngay group by mavt
	) r on q.mavt=r.mavt
) k inner join dmvt on k.mavt=dmvt.mavt
	set @sql=''drop view vdfnvl ''
	exec (@sql)
end'
where ReportName = N'Hao hụt nguyên vật liệu'

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
EXEC @cpc = sopsKetChuyen @tk, @ngayCt, @ngayCt1, @dk
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

Update sysReport set Query = N'declare @ngayct1 datetime
set @ngayct1=@@Ngayct1
declare @ngayct2 datetime
set @ngayct2=dateadd(hh,23,@@Ngayct2)
select z.macongtrinh,b.TenCongtrinh, sum(tiendd) as [Dở dang đầu kỳ], sum(vl) as [Chi phí nguyên vật liệu] , sum(nc) as [Chi phí nhân công trực tiếp], sum(mtc) as [Chi phí máy thi công], sum(ttp) as [Chi phí thuê thầu phụ],sum(cpc) as [Chi phí sản xuất chung], sum(vl+nc+mtc+ttp+cpc) as [Tổng chi phí], sum(vl+nc+mtc+ttp+cpc+tiendd) as [Giá thành công trình],sum(vl+nc+mtc+ttp+cpc+tiendd) as [Dở dang cuối kỳ] from
(
	select macongtrinh, sum(tien) as tiendd,0.0 as vl,0.0 as nc, 0.0 as mtc, 0.0 as ttp, 0.0 as cpc from
	(
		select macongtrinh ,sum(tien) as tien from cocongtrinhdd group by macongtrinh
		union all
		select macongtrinh ,sum(psno)as tien from bltk where ( left(tk,3) =''621'' or left(tk,3) =''622'' 
			or left(tk,3) =''623'' or left(tk,3) =''627'' ) and macongtrinh is not null and ngayct<@ngayct1
			group by macongtrinh
	)x group by macongtrinh
	union all
	select macongtrinh,sum(tiendd) as tiendd, sum(vl) as vl, sum(nc) as nc, sum(mtc) as mtc, sum(ttp) as ttp,
		sum(cpc) as cpc from 
	( 
		select macongtrinh, 0.0 as tiendd,sum(psno) as vl,0.0 as nc, 0.0 as mtc, 0.0 as ttp, 0.0 as cpc from bltk 
			where left(tk,3) =''621''and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
		union all
		select macongtrinh, 0.0 as tiendd,0.0 as vl,sum(psno) as nc, 0.0 as mtc, 0.0 as ttp, 0.0 as cpc from bltk 
			where left(tk,3) =''622''and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
		union all
		select macongtrinh, 0.0 as tiendd,0.0 as vl,0.0 as nc,sum(psno)  as mtc, 0.0 as ttp, 0.0 as cpc from bltk 
			where left(tk,3) =''623''and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
		union all
		select macongtrinh, 0.0 as tiendd,0.0 as vl,0.0 as nc,0.0  as mtc, sum(psno) as ttp, 0.0 as cpc from bltk 
			where left(tk,4) =''6278''and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
		union all
		select macongtrinh, 0.0 as tiendd,0.0 as vl,0.0 as nc,0.0  as mtc, 0.0 as ttp,sum(psno)  as cpc from bltk 
			where left(tk,3) =''627'' and left(tk,4) <>''6278''   and ngayct between @ngayct1 and @ngayct2 and macongtrinh is not null group by macongtrinh
	)y group by macongtrinh
)z inner join dmcongtrinh b on z.macongtrinh=b.macongtrinh where @@ps
group by z.macongtrinh,b.tencongtrinh'
where ReportName = N'Bảng Chi phí và Giá thành Công trình'

Update sysReport set Query = N'declare @ngayct1  datetime
declare @ngayct2 datetime
declare @ngaydaunam datetime
set  @ngayct1=@@ngayct1
set  @ngayct2=dateadd(hh,23,@@ngayct2)
declare @gtsx float 
declare @gtsx2 float
declare @gtsx3 float
declare @cpbanhang float
declare @cpquanly float
declare @cpquanly2 float
declare @cpquanly3 float
declare @cpbanhang2 float
declare @cpbanhang3 float
declare @gttoanbo1 float
declare @dtthuan1 float
declare @dtthuan2 float
declare @dtthuan3 float
declare @lailo1  float
declare @gttoanbo2 float
declare @gttoanbo3 float
declare @lailo2 float
declare @lailo3 float

declare @macongtrinh  nvarchar(50)
declare @tencongtrinh  nvarchar(50)
declare  curtemp cursor for
select macongtrinh,tencongtrinh from dmcongtrinh where @@ps



create  table #tam
 (
	[macongtrinh] [nvarchar]  (50) NULL ,	
                [tencongtrinh] [nvarchar]  (50) NULL ,
	[giathanhsx]  [decimal] (18,3) null,
	[cpbanhang] [decimal](18, 3) null,
	[cpquanly] [decimal](18, 3) NULL ,
	[giathanhtoanbo] [decimal](18, 3) NULL,
	[dtthuan1] [decimal](18,3) null,
	[lailo1] [decimal](18,3) null,
	[gttbdaunam]  [decimal] (18,3) null,
	[dtthuan2]  [decimal] (18,3) null,
	[lailo2]  [decimal] (18,3) null,
	[gtkhoicong]  [decimal] (18,3) null,
	[dtthuan3]  [decimal] (18,3) null,
	[lailo3]  [decimal] (18,3) null
) ON [PRIMARY]


OPEN curtemp

FETCH NEXT FROM curtemp INTO @macongtrinh,@tencongtrinh
WHILE @@FETCH_STATUS = 0
BEGIN
select @gtsx=sum(psno)from bltk where ( left(tk,3) =''621'' or left(tk,3) =''622''  
			or left(tk,3) =''623'' or left(tk,3) =''627'' ) and macongtrinh=@macongtrinh and ngayct between @ngayct1 and @ngayct2
select @cpbanhang=sum(psno) from bltk where left(tk,3)=''641'' and macongtrinh=@macongtrinh  and ngayct between @ngayct1 and @ngayct2
select @cpquanly=sum(psno) from bltk where left(tk,3)=''642'' and macongtrinh=@macongtrinh and  ngayct between @ngayct1 and @ngayct2
select @dtthuan1=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh  and ngayct between @ngayct1 and @ngayct2 
if @gtsx is null set @gtsx=0.0
if @cpbanhang is null set @cpbanhang=0.0
if @cpquanly is null set @cpquanly=0.0
if @dtthuan1 is null set @dtthuan1=0.0

set @gttoanbo1=@gtsx+@cpbanhang+@cpquanly
set @lailo1=@dtthuan1-@gttoanbo1

--luy ke tu dau nam den cuoi ky  (them dk ngayct between ngaydaunam and ngayct2)

set @ngaydaunam= convert(datetime,''01/01''+''/''+ convert(nvarchar(4), year(@ngayct1)))
select @gtsx2=sum(psno)from bltk where ( left(tk,3) =''621'' or left(tk,3) =''622''  
			or left(tk,3) =''623'' or left(tk,3) =''627'' ) and macongtrinh=@macongtrinh and ngayct between @ngaydaunam and @ngayct2
select @cpbanhang2=sum(psno) from bltk where left(tk,3)=''641'' and macongtrinh=@macongtrinh  and ngayct between @ngaydaunam and @ngayct2
select @cpquanly2=sum(psno) from bltk where left(tk,3)=''642'' and macongtrinh=@macongtrinh and  ngayct between @ngaydaunam and @ngayct2

select @dtthuan2=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh and  ngayct between @ngaydaunam and @ngayct2
if @gtsx2 is null set @gtsx2=0.0
if @cpbanhang2 is null set @cpbanhang2=0.0
if @cpquanly2 is null set @cpquanly2=0.0
if @dtthuan2 is null set @dtthuan2=0.0

set @gttoanbo2=@gtsx2+@cpbanhang2+@cpquanly2
set @lailo2=@dtthuan2-@gttoanbo2

---luy ke tu luc khoi cong 
declare  @dudau float
declare  @sx  float
select @dudau=tien from cocongtrinhdd where macongtrinh=@macongtrinh

select @sx=sum(psno)from bltk where ( left(tk,3) =''621'' or left(tk,3) =''622''  
			or left(tk,3) =''623'' or left(tk,3) =''627'' ) and macongtrinh=@macongtrinh and ngayct <= @ngayct2
select @cpbanhang3=sum(psno) from bltk where left(tk,3)=''641'' and macongtrinh=@macongtrinh  and ngayct <= @ngayct2
select @cpquanly3=sum(psno) from bltk where left(tk,3)=''642'' and macongtrinh=@macongtrinh and  ngayct <= @ngayct2

select @dtthuan3=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh and  ngayct<= @ngayct2

if @cpbanhang3 is null set @cpbanhang3=0.0
if @cpquanly3 is null set @cpquanly3=0.0
if @dtthuan3 is null set @dtthuan3=0.0
if @dudau is null set @dudau=0
if @sx is null set @sx=0
set @gtsx3=@sx+@dudau
set @gttoanbo3=@gtsx3+@cpbanhang3+@cpquanly3
set @lailo3=@dtthuan3-@gttoanbo3



insert into #tam (macongtrinh,tencongtrinh,giathanhsx,cpbanhang,cpquanly,giathanhtoanbo,dtthuan1,lailo1,gttbdaunam,dtthuan2,lailo2,gtkhoicong,dtthuan3,lailo3) values (@macongtrinh,@tencongtrinh,@gtsx,@cpbanhang,@cpquanly,@gttoanbo1,@dtthuan1,@lailo1,@gttoanbo2,@dtthuan2,@lailo2,@gttoanbo3,@dtthuan3,@lailo3)
FETCH NEXT FROM curtemp INTO @macongtrinh,@tencongtrinh
END

CLOSE curtemp
DEALLOCATE curtemp
select macongtrinh,tencongtrinh,giathanhsx [Giá thành công trình], cpbanhang [Chi phí bán hàng], cpquanly [Chi phí quản lý], dtthuan1 [Doanh thu thuần], lailo1 [Lãi lỗ], gttbdaunam [Giá thành lũy kế năm], dtthuan2 [Doanh thu lũy kế năm], lailo2 [Lãi lỗ lũy kế năm], giathanhtoanbo [Giá thành toàn bộ], dtthuan3 [Doanh thu toàn bộ], lailo3 [Lãi lỗ toàn bộ] from #tam

drop table #tam'
where ReportName = N'Báo cáo kết quả kinh doanh theo công trình xây lắp'

Update sysReport set Query = N'declare @tungay datetime
declare @denngay datetime 

set @tungay = @@Ngayct1
set @denngay = DATEADD(hh,23,@@Ngayct2)

Select mact, dbo.LayNgayGhiSo(NgayCT) as [Ngày ghi sổ], SoCt, NgayCT, DienGiai, Tk, Tkdu, PsNo, Psco, '''' as [Ghi chú]
from bltk
where NgayCt between @tungay and @denngay'
where ReportName = N'Sổ nhật ký chung'

Update sysReport set Query = N'DECLARE @NGAYCT1 DATETIME
DECLARE @NGAYCT2 DATETIME
SET @NGAYCT1 = @@NGAYCT1
SET @NGAYCT2 =dateadd(hh,23, @@NGAYCT2)
declare @duno float
declare @duco float
declare @psno float
declare @psco float

exec sodutaikhoan ''111'', @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
declare @111 float
set @111 = @duno - @duco

exec sodutaikhoan ''112'', @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
declare @112 float
set @112 = @duno - @duco

declare @11 float
set @11 = @111 + @112

exec sopstaikhoan ''51,71'', @ngayCt1,@ngayCt2,DEFAULT , @psno OUTPUT , @psco OUTPUT 
declare @51_71 float
set @51_71 = @psco

exec sopstaikhoan ''52,53'', @ngayCt1,@ngayCt2,DEFAULT , @psno OUTPUT , @psco OUTPUT 
declare @52_53 float
set @52_53 = @psno

declare @dt float
set @dt = @51_71 - @52_53

exec sopstaikhoan ''63,64,811'', @ngayCt1,@ngayCt2,DEFAULT , @psno OUTPUT , @psco OUTPUT 
declare @cp float
set @cp = @psno

declare @lntt float
set @lntt = @dt - @cp

exec sopstaikhoan ''3334'', @ngayCt1,@ngayCt2,DEFAULT , @psno OUTPUT , @psco OUTPUT 
declare @3334 float
set @3334 = @psno - @psco

declare @lrtt float
set @lrtt = @lntt - @3334

exec sodutaikhoan ''131'', @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
declare @131 float
set @131 = @duno - @duco

exec sodutaikhoan ''331'', @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
declare @331 float
set @331 = @duco - @duno

select 1 as #, N''Tiền mặt'' as N''Chỉ tiêu'', @111 as N''Số tiền''
union select 2, N''Tiền gửi'', @112
union select 3, N''Tổng tiền'', @11
union select 4, N''Doanh thu'', @dt
union select 5, N''Chi phí'', @cp
union select 6, N''LN trước thuế'', @lntt
union select 7, N''LRòng tạm tính'', @lrtt
union select 8, N''Phải thu'', @131
union select 9, N''Phải trả'', @331'
where ReportName = N'Số liệu tài chính tổng hợp'

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
bltk.tenkh as tkh, 
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
where '' + @@ps 
exec (@sql) 

select * from wTHCNPTHU 

if exists (select distinct name from sys.all_views where name = ''sddk'') drop view sddk 
if exists (select distinct name from sys.all_views where name = ''pstk'') drop view pstk 
if exists (select distinct name from sys.all_views where name = ''sdck'') drop view sdck 
if exists (select distinct name from sys.all_views where name = ''wTHCNPTHU'') drop view wTHCNPTHU
'
where ReportName = N'Tổng hợp công nợ phải thu'

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
bltk.tenkh as tncc, 
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
where '' + @@ps 
exec (@sql) 

select * from wTHCNPTRA 

if exists (select distinct name from sys.all_views where name = ''sddk'') drop view sddk 
if exists (select distinct name from sys.all_views where name = ''pstk'') drop view pstk 
if exists (select distinct name from sys.all_views where name = ''sdck'') drop view sdck 
if exists (select distinct name from sys.all_views where name = ''wTHCNPTRA'') drop view wTHCNPTRA'
where ReportName = N'Tổng hợp công nợ phải trả'
