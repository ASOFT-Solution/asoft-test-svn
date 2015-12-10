use [CDT]

-- Bảng cân đối số phát sinh
Update sysReport set Query=N'declare @ngayct datetime
declare @ngayCt1 datetime
declare @sql nvarchar (4000)
declare @gradeTK1 int
declare @gradeTK2 int
set @ngayct=@@ngayCt1
set @gradeTK1 = @@GradeTK1
set @gradeTK2 = @@GradeTK2
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
select tk,case when MaNT <> ''''VND'''' then sum(dunont) else sum(duno) end as nodau,sum(duco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi  from obtk where tk in(select tk from dmtk where tkcongno<>1) group by tk, MaNT
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
declare @tnodk decimal(28,6), @cnodk decimal(28,6)
declare @tcodk decimal(28,6), @ccodk decimal(28,6)
declare @tpsno decimal(28,6), @cpsno decimal(28,6)
declare @tpsco decimal(28,6), @cpsco decimal(28,6)
declare @tlkno decimal(28,6), @clkno decimal(28,6)
declare @tlkco decimal(28,6), @clkco decimal(28,6)
declare @tnock decimal(28,6), @cnock decimal(28,6)
declare @tcock decimal(28,6), @ccock decimal(28,6)
select @tnodk= sum([Nợ đầu]), @tcodk = sum([Có đầu]),
	@tpsno = sum(psno), @tpsco = sum(psco),
	@tlkno = sum([Lũy kế nợ]), @tlkco = sum([Lũy kế có]),
	@tnock = sum([Nợ cuối]), @tcock = sum([Có cuối]) from wthuong2
select @cnodk= sum([Nợ đầu]), @ccodk = sum([Có đầu]),
	@cpsno = sum(psno), @cpsco = sum(psco),
	@clkno = sum([Lũy kế nợ]), @clkco = sum([Lũy kế có]),
	@cnock = sum([Nợ cuối]), @ccock = sum([Có cuối]) from wcongno3

select b.TkMe,a.Tk, case when @@lang = 1 then b.tentk2 else b.tentk end as tentk,b.GradeTK,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wcongno3 a inner join dmtk b on a.tk = b.tk
union all
select b.TkMe,a.Tk, case when @@lang = 1 then b.tentk2 else b.tentk end as tentk,b.GradeTK,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wthuong2  a  inner join dmtk b on a.tk = b.tk
union all
select '''' as TkMe,''T'' as Tk,case when @@lang = 1 then N''Total'' else N''Tổng cộng'' end as tentk,999 as GradeTK, @tnodk + @cnodk as nodau, @tcodk + @ccodk as codau,@tpsno + @cpsno as psno, @tpsco + @cpsco as psco, @tlkno + @clkno as lkno, @tlkco + @clkco as lkco,@tnock + @cnock as nocuoi, @tcock + @ccock as cocuoi
order by tkme, a.tk

drop view wcongno
drop view wcongno1
drop view wcongno2
drop view wcongno3
drop view wthuong
drop view wthuong1
drop view wthuong2
'
where ReportName = N'Bảng cân đối số phát sinh'


-- Sổ cái CTGS
Update sysReport set Query=N'declare @nodauky float
declare @codauky float

declare @nocuoiky float
declare @cocuoiky float

declare @Tongpsno float
declare @Tongpsco float

declare @tungay datetime
declare @denngay datetime 

declare @TKNhom varchar(16) 
declare @TenTKNhom nvarchar(128) 
declare @SoHieu nvarchar(128)
declare @DKMaCT nvarchar(128)
declare @FilterCondition nvarchar(4000)
declare @MaCT varchar(16)
declare @sql nvarchar(4000)

IF OBJECT_ID(''tempdb..#resultTemp'') IS NOT NULL
BEGIN
	DROP TABLE #resultTemp
END

create table #resultTemp
(
	[MaCT] nvarchar(128) null,
	[NgayGhiSo] datetime null,
	[soct] nvarchar(128) null,
	[NgayCT] smalldatetime null,
	[diengiai] nvarchar(512) null,
	[tkdu] varchar (16) null,
	[psno] decimal(28,6) null,
	[psco] decimal(28,6) null,
	[GhiChu] nvarchar(128) null,
	[Stt] int null,
	[TKNhom] varchar(16) null,
	[TenTKNhom] nvarchar(128) null,
	[TK] varchar(16) null
)

set @tungay = @@Ngayct1
set @denngay = dateadd(hh,23,@@Ngayct2)

declare @datetemp datetime
set @datetemp = dateadd(d,1,@denngay)
declare @datetemptungay datetime
set @datetemptungay = dateadd(hh,-1,@tungay)
declare @tk varchar(10)
set @tk = @@tk

set @SoHieu = @@SoHieu
set @DKMaCT = ''''

if @SoHieu <> ''''
BEGIN
select @MaCT = MaCT from CTGS where SoHieu = @SoHieu

set @DKMaCT = '' And MaCT='''''' + @MaCT + ''''''''
END

set @FilterCondition = ''@@ps'' + @DKMaCT

if @tk <> ''''
BEGIN
	declare cur_tk cursor for 
	select @tk
END
else -- Không lọc tài khoản, lấy các tài khoản cấp 1
BEGIN
	declare cur_tk cursor for
	select TK from DMTK where TKMe is null
END

open cur_tk
fetch next from cur_tk into @TKNhom

while @@fetch_status = 0
BEGIN
	set @TenTKNhom = (select case when @@lang = 1 then TenTK2 else TenTK end as tenTKNhom from DMTK where TK = @TKNhom)

	execute Sodutaikhoan @TKNhom,@datetemptungay,@FilterCondition,@nodauky output,@codauky output

	execute Sodutaikhoan @TKNhom,@denngay,@FilterCondition,@nocuoiky output, @cocuoiky output

	execute Sopstaikhoan @TKNhom,@tungay,@denngay,@FilterCondition,@Tongpsno output,@Tongpsco output
	
	insert into #resultTemp([MaCT],[NgayGhiSo],[soct],[NgayCT],[diengiai],[tkdu],[psno],[psco],[GhiChu],[Stt],[TKNhom],[TenTKNhom],[TK])
	Select null as MaCT, null as [Ngày ghi sổ], '''' as SoCT,null  as NgayCT, case when @@lang = 1 then N''Begin of Period'' else N''Số dư đầu kỳ'' end as DienGiai, ''''as Tkdu, @nodauky as PsNo,@codauky as Psco,'''' as Ghichu, 0 as Stt, @TKNhom,@TenTKNhom,'''' as TK
	
	set @sql = N''Select mact, dbo.LayNgayGhiSo(NgayCT) as [Ngày ghi sổ], SoCt, NgayCT, DienGiai, Tkdu, PsNo, Psco, '''''''' as Ghichu,1,''''''+ @TKNhom + '''''',N'''''' + @TenTKNhom + '''''', tk ''
	set @sql = @sql + N'' from bltk where left(tk,len(''''''+ @TKNhom + '''''')) = '''''' + @TKNhom + '''''' and  (NgayCt between convert(datetime,''''''+ convert(nvarchar,@tungay) + '''''') and convert(datetime,'''''' + convert(nvarchar,@denngay) + '''''')) and '' + @FilterCondition
	
	insert into #resultTemp([MaCT],[NgayGhiSo],[soct],[NgayCT],[diengiai],[tkdu],[psno],[psco],[GhiChu],[Stt],[TKNhom],[TenTKNhom],[TK])
	exec(@sql)
	
	insert into #resultTemp([MaCT],[NgayGhiSo],[soct],[NgayCT],[diengiai],[tkdu],[psno],[psco],[GhiChu],[Stt],[TKNhom],[TenTKNhom])
	Select null as  mact,null  as [Ngày ghi sổ], '''',null , case when @@lang = 1 then N''Arising Total'' else N''Số phát sinh trong kỳ'' end as DienGiai, ''''as Tkdu,@Tongpsno as PsNo,@Tongpsco as Psco,'''' as Ghichu,2, @TKNhom,@TenTKNhom
	
	insert into #resultTemp([MaCT],[NgayGhiSo],[soct],[NgayCT],[diengiai],[tkdu],[psno],[psco],[GhiChu],[Stt],[TKNhom],[TenTKNhom])
	Select null as  mact,null , '''',null , case when @@lang = 1 then N''End of Period'' else N''Số dư cuối kỳ'' end as DienGiai, ''''as Tkdu,@nocuoiky as PsNo,@cocuoiky as Psco,'''' as Ghichu,3, @TKNhom,@TenTKNhom

	fetch next from cur_tk into @TKNhom
END

select distinct * from #resultTemp
order by TKNhom, stt, ngayct, soct

IF OBJECT_ID(''tempdb..#psTemp'') IS NOT NULL
BEGIN
	DROP TABLE #psTemp
END

close cur_tk
deallocate cur_tk
'
where ReportName = N'Sổ cái CTGS'

-- Bảng kê thuế GTGT bán ra
Update sysReport set Query=N'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATOutTemp'') AND type in (N''U''))
BEGIN
create table #VATOutTemp
 (
	[Stt] int NULL,
	[NgayCt] smalldatetime NULL,
	[NgayHd] smalldatetime NULL,
	[SoSeries] nvarchar(128) NULL,
	[Sohoadon] nvarchar(128) NULL,
	[TenKH] nvarchar(128) NULL,
	[MST] nvarchar(128) NULL,
	[DienGiai] nvarchar(128) NULL,
	[TTien] decimal(28,6) NULL, 
	[ThueSuat] decimal(28,6) NULL,
	[Thue] decimal(28,6) NULL,
	[GhiChu] nvarchar(128) NULL,
	[MaThue] varchar(16) NULL,
	[KyBKBR] int NULL, 
	[NamBKBR] int NULL,
	[NgayBKBR] smalldatetime NULL
)
END

delete from #VATOutTemp

declare @ky as int,
		@ngayBKBR as smalldatetime

Select @ky = mst.KyBKBR, @ngayBKBR = mst.NgayBKBR
 from MVATOut mst inner join DVATOut dt on mst.MVATOutID = dt.MVATOutID
 where @@ps and mst.NamBKBR = @@NAM

-- Insert cac dong trong vao bang DVATOut de len bao cao
if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''KT'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''KT'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''00'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''00'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''05'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''05'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''10'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''10'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''NHOM5'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''NHOM5'', @ky, @@NAM, @ngayBKBR)


Select dt.SoSeries, dt.Sohoadon, dt.NgayHd, dt.Tenkh,  dt.mst, dt.diengiai  as [Tên mặt hàng],  Sum(Ttien) as TTien, dt.ThueSuat/100 as ThueSuat,
Sum(dt.Thue) as Thue, dt.GhiChu as GhiChu, dt.MaThue, mst.KyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt 
from MVATOut mst inner join DVATOut dt on mst.MVATOutID = dt.MVATOutID inner join DMThueSuat ts on dt.MaThue = ts.MaThue
 where @@ps and mst.NamBKBR = @@NAM
group by dt.Sohoadon, dt.Soseries, dt.NgayHd, dt.tenkh, dt.ghichu, dt.diengiai, dt.mst, dt.thuesuat, dt.MaThue, mst.KyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt
union
Select [SoSeries], [Sohoadon], [NgayHd], [TenKH], [MST], [DienGiai],[TTien],[ThueSuat], [Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR], [Stt]
from #VATOutTemp
order by ts.Stt, Ngayhd, Sohoadon
 
drop table #VATOutTemp
'
where ReportName = N'Bảng kê thuế GTGT bán ra'

-- Sổ chi tiết tài khoản
Update sysReport set Query=N'declare @tkrp varchar(16) -- Tài khoản lọc
declare @capLoc int -- Cấp lọc
declare @capTK int -- Cấp thực tế của TK lọc
declare @TKNhom varchar(16) 
declare @TenTKNhom nvarchar(128) 
declare @sql nvarchar(4000) 

declare @nodk float -- Nợ đầu kỳ
declare @codk float -- Có đầu kỳ

declare @nock float -- Nợ cuối kỳ
declare @cock float -- Có cuối kỳ

declare @nophatsinh float -- Nợ phát sinh
declare @phatsinhco float -- Có phát sinh

declare @ngayCt1 datetime
declare @ngayCt1h datetime
declare @ngayCt2 datetime

IF OBJECT_ID(''tempdb..#resultTemp'') IS NOT NULL
BEGIN
	DROP TABLE #resultTemp
END

IF OBJECT_ID(''tempdb..#psTemp'') IS NOT NULL
BEGIN
	DROP TABLE #psTemp
END
		
create table #resultTemp
(
	[NgayCT] smalldatetime null,
	[MTID] uniqueidentifier null,
	[MaCT] nvarchar(128) null,
	[soct] nvarchar(128) null,
	[diengiai] nvarchar(512) null,
	[tkdu] varchar (16) null,
	[psno] decimal(28,6) null,
	[psco] decimal(28,6) null,
	[maKH] varchar(16) null,
	[tenkh] nvarchar(128) null,
	[Stt] int null,
	[TKNhom] varchar(16) null,
	[TenTKNhom] nvarchar(128) null
)

create table #psTemp
(
	[ps] decimal(28,6) NULL,	
)
		
set @tkrp=@@TK
set @capLoc=@@GradeTK

set @NgayCt1=@@NgayCt1
set @NgayCt2=dateadd(hh,23,@@NgayCt2)
set @ngayct1=dateadd(hh,-1,@ngayct1)

set @ngayCt1h=dateadd(hh,1,@ngayct1)

set @capTK = -1
if @tkrp <> ''''
	select @capTK = GradeTK from DMTK where TK = @tkrp

-- TH1: 1)Lọc tài khoản, lọc bậc = 0 ; 2) Bậc thực tế = bậc lọc
if (@capLoc = 0 and @tkrp <> '''') or @capTK = @capLoc
BEGIN
	set @TenTKNhom = (select case when @@lang = 1 then TenTK2 else TenTK end as tenTKNhom from DMTK where TK = @tkrp)
	
	--Lấy số dư đầu kỳ
	exec sodutaikhoan @tkrp,@ngayCt1, ''@@ps'' ,@nodk output, @codk output
	
	--Lấy số dư cuối kỳ
	exec sodutaikhoan @tkrp,@ngayCt2, ''@@ps'' ,@nock output, @cock output
	
	--Lấy số phát sinh
	select @nophatsinh=sum(psno) from bltk where ngayct between @@ngayct1 and @@ngayct2 and tk like @@tk+''%'' and @@ps
	select @phatsinhco=sum(psco) from bltk where ngayct between @@ngayct1 and @@ngayct2 and tk like @@tk+''%'' and @@ps

	insert into #resultTemp([NgayCT],[MTID],[MaCT],[soct],[diengiai],[tkdu],[psno],[psco],[maKH],[tenkh],[Stt],[TKNhom], [TenTKNhom])

	select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as diengiai,
	null as tkdu,@nodk as psno,@codk as psco, null as makh, null  as tenkh, 0 as Stt, @tkrp as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
	union  all

	select a.ngayCt,MTID, a.mact, a.SoCt, a.diengiai, a.tkdu, a.psno, a.psco, a.maKH, b.tenkh, 1 , @tkrp as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
	from bltk a, dmkh b 
	where a.makh*=b.makh and  left(a.tk,len(@tkrp))=@tkrp and (a.ngayCt between @ngayCt1h and @ngayCT2 ) and @@ps

	union all
	select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''Arising Total'' else N''Tổng phát sinh'' end as diengiai,
	   null as tkdu, @nophatsinh as psno, @phatsinhco  as psco, null as makh, null as tenkh, 2 , @tkrp as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]

	union all

	select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''End of Period'' else N''Cuối kỳ'' end as Diengiai,
	   null as tkdu, @nock as psno, @cock as psco, null as makh, null as tenkh, 3 , @tkrp as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
	order by Stt,Ngayct,mact,[Tài khoản nhóm] desc
END
-- TH2: Cấp lọc nhỏ hơn cấp thực tế của TK lọc
else if @capLoc < @capTK 
BEGIN

	-- Không hiển thị số liệu
	insert into #resultTemp([NgayCT],[MTID],[MaCT],[soct],[diengiai],[tkdu],[psno],[psco],[maKH],[tenkh],[Stt],[TKNhom])
	
	select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as diengiai,
	   null as tkdu, null as psno, null as psco, null as makh, null as tenkh, 0 as STT, @tkrp as [Tài khoản nhóm]
	   
	union all 

	select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''Arising Total'' else N''Tổng phát sinh'' end as diengiai,
	   null as tkdu, null as psno, null as psco, null as makh, null as tenkh, 2 , @tkrp as [Tài khoản nhóm]
	   
	union all 

	select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''End of Period'' else N''Cuối kỳ'' end as Diengiai,
	   null as tkdu, null as psno, null as psco, null as makh, null as tenkh, 3 , @tkrp as [Tài khoản nhóm]   
	order by Stt,Ngayct,mact,[Tài khoản nhóm] desc

END
else 
BEGIN
	
	-- Không lọc tài khoản
	if @tkrp = ''''
	BEGIN
		-- Không lọc bậc -> Lấy các tài khoản bậc 2
		if (@capLoc = 0)
			set @capLoc = 2
		
		declare cur_tkCon CURSOR FOR
		select TK from DMTK where GradeTK = @capLoc
	END
	else
	BEGIN
		declare cur_tkCon CURSOR FOR
		select TK from dbo.LayTkConTheoBac(@tkrp,@capLoc)
	END
		
	open cur_tkCon
	fetch next from cur_tkCon into @TKNhom
	while @@fetch_status = 0
	BEGIN
		set @TenTKNhom = (select case when @@lang = 1 then TenTK2 else TenTK end as tenTKNhom from DMTK where TK = @TKNhom)
		
		-- Xử lý giống TH1
		delete from #psTemp
	
		--Lấy số dư đầu kỳ
		exec sodutaikhoan @TKNhom,@ngayCt1, ''@@ps'' ,@nodk output, @codk output
		
		--Lấy số dư cuối kỳ
		exec sodutaikhoan @TKNhom,@ngayCt2, ''@@ps'' ,@nock output, @cock output
		
		--Lấy số phát sinh
		set @sql = ''insert into #psTemp select sum(psno) from bltk where ngayct between ''@@ngayct1'' and ''@@ngayct2'' and tk like '''''' + @TKNhom + ''%'''' and '' + ''@@ps''
		exec(@sql)
		select @nophatsinh = ps from #psTemp
		
		set @sql = ''insert into #psTemp select sum(psco) from bltk where ngayct between ''@@ngayct1'' and ''@@ngayct2'' and tk like ''''''+ @TKNhom + ''%'''' and '' + ''@@ps''
		exec(@sql)
		select @phatsinhco = ps from #psTemp

		insert into #resultTemp([NgayCT],[MTID],[MaCT],[soct],[diengiai],[tkdu],[psno],[psco],[maKH],[tenkh],[Stt],[TKNhom],[TenTKNhom])

		select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as diengiai,
		null as tkdu,@nodk as psno,@codk as psco, null as makh, null  as tenkh, 0 as Stt, @TKNhom as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
		union  all

		select a.ngayCt,MTID, a.mact, a.SoCt, a.diengiai, a.tkdu, a.psno, a.psco, a.maKH, b.tenkh, 1 , @TKNhom as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
		from bltk a, dmkh b 
		where a.makh*=b.makh and  left(a.tk,len(@TKNhom))=@TKNhom and (a.ngayCt between @ngayCt1h and @ngayCT2 ) and @@ps

		union all
		select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''Arising Total'' else N''Tổng phát sinh'' end as diengiai,
		   null as tkdu, @nophatsinh as psno, @phatsinhco  as psco, null as makh, null as tenkh, 2 , @TKNhom as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]

		union all

		select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''End of Period'' else N''Cuối kỳ'' end as Diengiai,
		   null as tkdu, @nock as psno, @cock as psco, null as makh, null as tenkh, 3 , @TKNhom as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
		order by Stt,Ngayct,mact,[Tài khoản nhóm] desc
		
		fetch next from cur_tkCon into @TKNhom	
	END
	
	close cur_tkCon
	deallocate cur_tkCon
END

select * from #resultTemp

IF OBJECT_ID(''tempdb..#psTemp'') IS NOT NULL
BEGIN
	DROP TABLE #psTemp
END

IF OBJECT_ID(''tempdb..#resultTemp'') IS NOT NULL
BEGIN
	DROP TABLE #resultTemp
END
'
where ReportName = N'Sổ chi tiết tài khoản'

-- Bảng kê thuế GTGT mua vào
Update sysReport set Query=N'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATInTemp'') AND type in (N''U''))
BEGIN
create table #VATInTemp
 (
	[NgayCt] smalldatetime NULL,
	[NgayHd] smalldatetime NULL,
	[SoSeries] nvarchar(128) NULL,
	[Sohoadon] nvarchar(128) NULL,
	[TenKH] nvarchar(128) NULL,
	[MST] nvarchar(128) NULL,
	[DienGiai] nvarchar(128) NULL,
	[TTien] decimal(28,6) NULL, 
	[ThueSuat] decimal(28,6) NULL,
	[Thue] decimal(28,6) NULL,
	[GhiChu] nvarchar(128) NULL,
	[MaLoaiThue] int NULL, 
	[KyBKMV] int NULL, 
	[NamBKMV] int NULL,
	[NgayBKMV] smalldatetime NULL
)
END

delete from #VATInTemp

declare @maLoaiThue int,
		@ky as int,
		@ngayBKMV as smalldatetime

Select @ky = mst.KyBKMV, @ngayBKMV = mst.NgayBKMV
 from MVATIn mst inner join DVATIn dt on mst.MVATInID = dt.MVATInID
 where @@ps and mst.NamBKMV = @@NAM
 
declare cur_LThue cursor for
select MaLoaiThue from DMLThue order by MaLoaiThue

open cur_LThue
fetch next from cur_LThue into @maLoaiThue

WHILE @@FETCH_STATUS = 0
BEGIN

-- Insert cac dong trong vao bang DVATIn de len bao cao
if not exists (select top 1 1 from DVATIn dt inner join MVATIn mst on mst.MVATInID = dt.MVATInID where @@ps and mst.NamBKMV = @@NAM and dt.MaLoaiThue = @maLoaiThue)
INSERT INTO #VATInTemp ([NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaLoaiThue],[KyBKMV],[NamBKMV], [NgayBKMV]) 
VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @maLoaiThue, @ky, @@NAM, @ngayBKMV)

fetch next from cur_LThue into @maLoaiThue

END

close cur_LThue
deallocate cur_LThue

Select dt.NgayCt as [Ngày HT VAT], dt.NgayHd, dt.SoSeries, dt.Sohoadon, dt.TenKH, dt.MST, dt.DienGiai as [Tên mặt hàng], Sum(dt.TTien) TTien, dt.ThueSuat as ThueSuat,
Sum(dt.Thue) Thue, dt.GhiChu as GhiChu, dt.MaLoaiThue as [Loại thuế], mst.KyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.MaThue
 from MVATIn mst inner join DVATIn dt on mst.MVATInID = dt.MVATInID
 where @@ps and mst.NamBKMV = @@NAM
 group by dt.ngayhd, dt.MaLoaiThue, dt.Sohoadon, dt.soseries, dt.ngayct, dt.TenKH, dt.MST, dt.DienGiai, dt.MaThue, dt.ThueSuat, mst.KyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.GhiChu
union
Select [NgayCt] as [Ngày HT VAT],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien], [ThueSuat],[Thue],[GhiChu],[MaLoaiThue],[KyBKMV],[NamBKMV], [NgayBKMV], NULL
from #VATInTemp
order by MaLoaiThue, Ngayhd, Sohoadon
 
drop table #VATInTemp
'
where ReportName = N'Bảng kê thuế GTGT mua vào'

-- Bảng phân bổ thuế được khấu trừ tháng
Update sysReport set Query=N'
declare @sql nvarchar(max)  
declare @thang int 
declare @a decimal(28,6)
declare @a1 decimal(28,6)
declare @a2 decimal(28,6)
declare @a3 decimal(28,6)
declare @b1 decimal(28,6)
declare @b2 decimal(28,6)
declare @b3 decimal(28,6)
declare @b4 decimal(28,6)
declare @b5 decimal(28,6)

set @thang = @@kybkmv 

if exists (select top 1 1 from sys.all_views where name = ''wTempVATIn'') drop view wTempVATIn 
if exists (select top 1 1 from sys.all_views where name = ''wTempVATOut'') drop view wTempVATOut

set @sql = ''
create view wTempVATIn as 
select Thue, MaLoaiThue
from MVATIn inner join DVATIn on MVATIn.MVATInID = DVATIn.MVATInID and MVATIn.KyBKMV = '' + str(@thang)
exec (@sql) 
 
set @sql = ''
create view wTempVATOut as 
select TTien, MaThue
from MVATOut inner join DVATOut on MVATOut.MVATOutID = DVATOut.MVATOutID and MVATOut.KyBKBR = '' + str(@thang)
exec (@sql) 

select @a1 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 1
select @a2 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 2
select @a3 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 3
set @a = @a1 + @a2 + @a3
select @b1 = isnull(sum(isnull(TTien, 0)), 0) from wTempVATOut where MaThue in (''KT'', ''00'', ''05'', ''10'')
select @b2 = isnull(sum(isnull(TTien, 0)), 0) from wTempVATOut where MaThue in (''00'', ''05'', ''10'')
if(@b1 <> 0) set @b3 = (@b2 * 100) / @b1  else set @b3 = 0
select @b4 = @a3
select @b5 = (@b4 * @b3) / 100

select 
@thang as [Kỳ kế toán], 
@a as [Chỉ tiêu A], 
@a1 as [Chỉ tiêu A1], 
@a2 as [Chỉ tiêu A2], 
@a3 as [Chỉ tiêu A3], 
@b1 as [Chỉ tiêu B1], 
@b2 as [Chỉ tiêu B2], 
@b3 as [Chỉ tiêu B3], 
@b4 as [Chỉ tiêu B4], 
@b5 as [Chỉ tiêu B5]

if exists (select distinct name from sys.all_views where name = ''wTempVATIn'') drop view wTempVATIn 
if exists (select top 1 1 from sys.all_views where name = ''wTempVATOut'') drop view wTempVATOut 
'
where ReportName = N'Bảng phân bổ thuế được khấu trừ tháng'

-- Bảng phân bổ thuế được khấu trừ năm
Update sysReport set Query=N'
declare @sql nvarchar(max)  
declare @nam int 
declare @a decimal(28,6)
declare @a1 decimal(28,6)
declare @a2 decimal(28,6)
declare @a3 decimal(28,6)
declare @b1 decimal(28,6)
declare @b2 decimal(28,6)
declare @b3 decimal(28,6)
declare @b4 decimal(28,6)
declare @b5 decimal(28,6)
declare @b6 decimal(28,6)
declare @b7 decimal(28,6)

set @nam = @@nambkmv

if exists (select top 1 1 from sys.all_views where name = ''wTempVATIn'') drop view wTempVATIn 
if exists (select top 1 1 from sys.all_views where name = ''wTempVATOut'') drop view wTempVATOut

set @sql = ''
create view wTempVATIn as 
select Thue, MaLoaiThue
from MVATIn inner join DVATIn on MVATIn.MVATInID = DVATIn.MVATInID and MVATIn.NamBKMV = '' + str(@nam)
exec (@sql) 
 
set @sql = ''
create view wTempVATOut as 
select TTien, MaThue
from MVATOut inner join DVATOut on MVATOut.MVATOutID = DVATOut.MVATOutID and MVATOut.NamBKBR = '' + str(@nam)
exec (@sql) 

select @a1 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 1
select @a2 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 2
select @a3 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 3
set @a = @a1 + @a2 + @a3
select @b1 = isnull(sum(isnull(TTien, 0)), 0) from wTempVATOut where MaThue in (''KT'', ''00'', ''05'', ''10'')
select @b2 = isnull(sum(isnull(TTien, 0)), 0) from wTempVATOut where MaThue in (''00'', ''05'', ''10'')
if(@b1 <> 0) set @b3 = (@b2 * 100) / @b1  else set @b3 = 0
set @b4 = @a3
set @b5 = (@b4 * @b3) / 100
select @b6 = isnull(sum(isnull(TotalPs, 0)), 0) from MT36 inner join DT36 on MT36.MT36ID = DT36.MT36ID and year(MT36.NgayCt) = @nam
set @b7 = @b5 - @b6

select 
@a as [Chỉ tiêu A], 
@a1 as [Chỉ tiêu A1], 
@a2 as [Chỉ tiêu A2], 
@a3 as [Chỉ tiêu A3], 
@b1 as [Chỉ tiêu B1], 
@b2 as [Chỉ tiêu B2], 
@b3 as [Chỉ tiêu B3], 
@b4 as [Chỉ tiêu B4], 
@b5 as [Chỉ tiêu B5],
@b6 as [Chỉ tiêu B6], 
@b7 as [Chỉ tiêu B7]

if exists (select distinct name from sys.all_views where name = ''wTempVATIn'') drop view wTempVATIn 
if exists (select top 1 1 from sys.all_views where name = ''wTempVATOut'') drop view wTempVATOut 
'
where ReportName = N'Bảng phân bổ thuế được khấu trừ năm'

-- Bảng kê số lượng xe ôtô, xe gắn máy bán ra
Update sysReport set Query=N'
declare @sql nvarchar(max)  
declare @thang int 
declare @nam int 
declare @a decimal(28,6)
declare @a1 decimal(28,6)
declare @a2 decimal(28,6)
declare @a3 decimal(28,6)
declare @b1 decimal(28,6)
declare @b2 decimal(28,6)
declare @b3 decimal(28,6)
declare @b4 decimal(28,6)
declare @b5 decimal(28,6)

set @thang = @@KyBKMV
set @nam = @@NamBKMV

if exists (select top 1 1 from sys.all_views where name = ''wTempVATIn'') drop view wTempVATIn 
if exists (select top 1 1 from sys.all_views where name = ''wTempVATOut'') drop view wTempVATOut
if exists (select top 1 1 from sys.all_views where name = ''wTempCommon'') drop view wTempCommon
if exists (select top 1 1 from sys.all_views where name = ''wTempVT7'') drop view wTempVT7 
if exists (select top 1 1 from sys.all_views where name = ''wTempVT8'') drop view wTempVT8 

set @sql = ''
create view wTempVATIn as 
select Thue, MaLoaiThue
from MVATIn inner join DVATIn on MVATIn.MVATInID = DVATIn.MVATInID and MVATIn.KyBKMV = '' + str(@thang)
exec (@sql) 
 
set @sql = ''
create view wTempVATOut as 
select TTien, MaThue
from MVATOut inner join DVATOut on MVATOut.MVATOutID = DVATOut.MVATOutID and MVATOut.KyBKBR = '' + str(@thang)
exec (@sql) 

select @a1 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 1
select @a2 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 2
select @a3 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 3
set @a = @a1 + @a2 + @a3
select @b1 = isnull(sum(isnull(TTien, 0)), 0) from wTempVATOut where MaThue in (''KT'', ''00'', ''05'', ''10'')
select @b2 = isnull(sum(isnull(TTien, 0)), 0) from wTempVATOut where MaThue in (''00'', ''05'', ''10'')
if(@b1 <> 0) set @b3 = (@b2 * 100) / @b1  else set @b3 = 0
select @b4 = @a3
select @b5 = (@b4 * @b3) / 100

set @sql = N''create view wTempCommon as select 
N'''''' + convert(nvarchar(256), @thang) + N'''''' as  [Kỳ kế toán],
N'''''' + convert(nvarchar(256), @nam) + N'''''' as  [Năm kế toán]''
exec (@sql) 

set @sql = N''create view wTempVT7 as
select 
1 as [STT],
N''''Xe ôtô'''' as [Tên loại vật tư],
DMVT.TenVT as [Tên vật tư], 
DMDVT.TenDVT as [Tên ĐVT], 
sum(DT32.SoLuong) as [Số lượng],
sum(DT32.Ps) as [Tổng tiền], 
MT32.DienGiai as [Diễn giải]
from MT32 
inner join DT32 on MT32.MT32ID = DT32.MT32ID 
left join DMVT on DMVT.MaVT = DT32.MaVT
left join DMDVT on DMDVT.MaDVT = DT32.MaDVT
where month(MT32.NgayCt) = '' + convert(nvarchar(10), @thang) + '' and year(MT32.NgayCt) = '' + convert(nvarchar(10), @nam) + ''
and DMVT.LoaiVt = 7 
group by DMVT.TenVT, DMDVT.TenDVT, DMVT.LoaiVt, MT32.DienGiai
''
exec (@sql) 

set @sql = N''create view wTempVT8 as
select 
2 as [STT],
N''''Xe hai bánh gắn máy'''' as [Tên loại vật tư],
DMVT.TenVT as [Tên vật tư], 
DMDVT.TenDVT as [Tên ĐVT], 
sum(DT32.SoLuong) as [Số lượng],
sum(DT32.Ps) as [Tổng tiền], 
MT32.DienGiai as [Diễn giải]
from MT32 
inner join DT32 on MT32.MT32ID = DT32.MT32ID 
left join DMVT on DMVT.MaVT = DT32.MaVT
left join DMDVT on DMDVT.MaDVT = DT32.MaDVT
where month(MT32.NgayCt) = '' + convert(nvarchar(10), @thang) + '' and year(MT32.NgayCt) = '' + convert(nvarchar(10), @nam) + ''
and DMVT.LoaiVt = 8 
group by DMVT.TenVT, DMDVT.TenDVT, DMVT.LoaiVt, MT32.DienGiai
''
exec (@sql) 

select * from wTempCommon, wTempVT7 
union all
select * from wTempCommon, wTempVT8

if exists (select distinct name from sys.all_views where name = ''wTempVATIn'') drop view wTempVATIn 
if exists (select top 1 1 from sys.all_views where name = ''wTempVATOut'') drop view wTempVATOut 
if exists (select top 1 1 from sys.all_views where name = ''wTempCommon'') drop view wTempCommon 
if exists (select top 1 1 from sys.all_views where name = ''wTempVT7'') drop view wTempVT7 
if exists (select top 1 1 from sys.all_views where name = ''wTempVT8'') drop view wTempVT8 
'
where ReportName = N'Bảng kê số lượng xe ôtô, xe gắn máy bán ra'