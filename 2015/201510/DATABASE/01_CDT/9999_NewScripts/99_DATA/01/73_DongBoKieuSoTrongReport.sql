use [CDT]

-- Update tất cả các biến float thành decimal(28,6)

declare @reportName nvarchar(50)

-- Sổ cái CTGS
set @reportName = N'Sổ cái CTGS'
Update sysReport set Query = N'declare @nodauky decimal(28,6)
declare @codauky decimal(28,6)

declare @nocuoiky decimal(28,6)
declare @cocuoiky decimal(28,6)

declare @Tongpsno decimal(28,6)
declare @Tongpsco decimal(28,6)

declare @tungay datetime
declare @denngay datetime 

declare @TKNhom varchar(16) 
declare @TenTKNhom nvarchar(128) 
declare @SoHieu nvarchar(128)
declare @DKMaCT nvarchar(128)
declare @FilterCondition nvarchar(4000)
declare @MaCT varchar(16)
declare @sql nvarchar(4000)

declare @dif decimal(28,6)


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

	-- Lấy lại số dư đầu kỳ
	if @TKNhom like ''1%'' or @TKNhom like ''2%'' or @TKNhom like ''3%'' or @TKNhom like ''4%''
	BEGIN
		if @nodauky > 0 And @codauky > 0
		BEGIN
			set @dif = @nodauky - @codauky
			if @dif > 0 
			BEGIN
				set @nodauky = @dif
				set @codauky = 0
			END
			else
			BEGIN
				set @codauky = abs(@dif)
				set @nodauky = 0
			END
		END
	END
	
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
	
	-- Lấy lại số dư cuối kỳ
	if @TKNhom like ''1%'' or @TKNhom like ''2%''
	BEGIN
		if @nodauky > 0
		BEGIN
			set @nocuoiky = @nodauky + @Tongpsno - @Tongpsco
			set @cocuoiky = 0
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END
		END
		
		if @codauky > 0
		BEGIN
			set @cocuoiky = @codauky + @Tongpsco - @Tongpsno
			set @nocuoiky = 0
			
			if @cocuoiky < 0 
			BEGIN
				set @nocuoiky = abs(@cocuoiky)
				set @cocuoiky = 0
			END
		END

		if isnull(@nodauky,0) = 0 And isnull(@codauky,0) = 0
		BEGIN
			set @cocuoiky = 0
			set @nocuoiky = isnull(@Tongpsno,0) - isnull(@Tongpsco,0)
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END
		END
	END
	
	if @TKNhom like ''3%'' or @TKNhom like ''4%''
	BEGIN
		if @nodauky > 0
		BEGIN
			set @nocuoiky = @nodauky + @Tongpsno - @Tongpsco
			set @cocuoiky = 0
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END	
		END
		
		if @codauky > 0
		BEGIN
			set @cocuoiky = @codauky + @Tongpsco - @Tongpsno
			set @nocuoiky = 0
			
			if @cocuoiky < 0 
			BEGIN
				set @nocuoiky = abs(@cocuoiky)
				set @cocuoiky = 0
			END	
		END

		if isnull(@nodauky,0) = 0 And isnull(@codauky,0) = 0
		BEGIN
			set @cocuoiky = 0
			set @nocuoiky = @Tongpsno - @Tongpsco
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END	
		END
	END

	insert into #resultTemp([MaCT],[NgayGhiSo],[soct],[NgayCT],[diengiai],[tkdu],[psno],[psco],[GhiChu],[Stt],[TKNhom],[TenTKNhom])
	Select null as  mact,null , '''',null , case when @@lang = 1 then N''End of Period'' else N''Số dư cuối kỳ'' end as DienGiai, ''''as Tkdu,@nocuoiky as PsNo,@cocuoiky as Psco,'''' as Ghichu,3, @TKNhom,@TenTKNhom

	fetch next from cur_tk into @TKNhom
END

select * from #resultTemp
order by TKNhom, stt, ngayct, soct

IF OBJECT_ID(''tempdb..#psTemp'') IS NOT NULL
BEGIN
	DROP TABLE #psTemp
END

close cur_tk
deallocate cur_tk'
where ReportName = @reportName

-- Sổ chi tiết công nợ khách hàng
set @reportName = N'Sổ chi tiết công nợ khách hàng'
Update sysReport set Query = N'declare @kh varchar(16)
declare @tkrp varchar(16)
declare @nocodk bit
declare @nocock bit
set @tkrp=@@TK
set @kh=@@MaKH
declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @NgayCt1=cast(@@ngayct1 as datetime)
set @NgayCt2=cast(@@ngayct2 as datetime)
declare @dauky decimal(28,6), @daukynt decimal(28,6)
--tìm số dư đầu kỳ=Số dư đầu năm + số phát sinh trước ngàyCt1
	
	declare @daunam decimal(28,6), @daunamnt decimal(28,6)
	declare @count1 int 
	--Số phát inh đầu năm
	set @daunamnt=(SELECT sum(Dunont-Ducont) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunam=(SELECT sum(Duno-Duco) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @count1=(select count(*) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunamnt = case when @count1<>0 then @daunamnt else 0 end
	set @daunam = case when @count1<>0 then @daunam else 0 end
	set @daukynt=(select sum(psNont)-sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @dauky=(select sum(psNo)-sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @daukynt=case when @count1>0 then @daukynt else 0 end
	set @dauky=case when @count1>0 then @dauky else 0 end

	set @daukynt=@daukynt + @daunamnt
	set @dauky=@dauky + @daunam
	set @nocodk = case when @dauky>=0 then 1 else 0 end

--tìm số dư cuối kỳ
	declare @psNo decimal(28,6), @psNont decimal(28,6)
	declare @psCo decimal(28,6), @psCont decimal(28,6)
	declare @cuoiky decimal(28,6), @cuoikynt decimal(28,6)
	set @psNont=(select sum(psNont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCont=(select sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNo=(select sum(psNo)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCo=(select sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNont=case when @count1>0 then @psNont else 0 end
	set @psCont=case when @count1>0 then @psCont else 0 end
	set @psNo=case when @count1>0 then @psNo else 0 end
	set @psCo=case when @count1>0 then @psCo else 0 end
	set @cuoikynt=@daukynt + @psNont-@psCont
	set @cuoiky=@dauky + @psNo-@psCo
	set @nocock = case when @cuoiky>=0 then 1 else 0 end

--Lấy số phát sinh

declare @nophatsinh decimal(28,6), @nophatsinhnt decimal(28,6)
declare @phatsinhco decimal(28,6), @phatsinhcont decimal(28,6)
select @nophatsinhnt=sum(psnont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhcont=sum(pscont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @nophatsinh=sum(psno) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhco=sum(psco) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps

select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Beginning amount'' else N''Số dư đầu kỳ'' end as diengiai,
null as tkdu,psnont=case when @nocodk=0 then 0 else @daukynt end,psno=case when @nocodk=0 then 0 else @dauky end,
pscont=case when @nocodk=0 then abs(@daukynt) else 0 end,psco=case when @nocodk=0 then abs(@dauky) else 0 end, null as makh, null as tenkh, 0 as Stt
union  all
select ngayCt,MTID, maCT,SoCt,diengiai,tkdu,psnont,psno,pscont,psco ,maKH, 
(select case when @@lang = 1 then dm.TenKH2 else dm.TenKH end as tenkh from dmkh dm where dm.makh = bltk.maKH) as tenkh ,1 from bltk
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Total of arinsing'' else N''Tổng phát sinh'' end as diengiai,
null as tkdu,@nophatsinhnt as sopsnt,@nophatsinh as sops,@phatsinhcont as pscont,@phatsinhco as psco, null as makh, null as tenkh,2
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Closing amount'' else N''Số dư cuối kỳ'' end as diengiai,
null as tkdu,sopsnt=case when @nocock=0 then 0 else @cuoikynt end,sops=case when @nocock=0 then 0 else @cuoiky end,
pscont=case when @nocock=0 then abs(@cuoikynt) else 0 end, psco=case when @nocock=0 then abs(@cuoiky) else 0 end, null as makh, null as tenkh, 3
order by stt,ngayCt, soct, tkdu'
where ReportName = @reportName

-- Sổ quỹ tiền mặt
set @reportName = N'Sổ quỹ tiền mặt'
Update sysReport set Query = N'declare @tkrp nvarchar(20)
declare @dauky decimal(28,6),@daukynt decimal(28,6)
declare @thu decimal(28,6),@thunt decimal(28,6)
declare @chi decimal(28,6),@chint decimal(28,6)
declare @ton decimal(28,6)
declare @tonnt decimal(28,6)
declare @id int
declare @stt int
declare @tungayCt datetime,@ngaydk datetime
declare @denngayCt datetime
set @tuNgayCt=@@NgayCT1
set @denNgayCt=dateadd(hh,23,@@NgayCT2)
set @ngaydk=dateadd(hh,-1,@tungayct)
set @tkrp=@@TK

declare @nodk decimal(28,6),@nodknt decimal(28,6)
declare @codk decimal(28,6),@codknt decimal(28,6)
	exec sodutaikhoannt @tkrp,@ngaydk,''@@ps'',@Nodk output, @Codk output,@NoDkNt output, @CoDkNt output
set @dauky = @nodk
set @daukynt = @nodknt
declare cur cursor for 
SELECT min(bltkID) as  bltkID, sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(PsNoNt) as TienThuNt, sum(PsCoNt) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint,
case when sum(PsNo) != 0 then 1 else 2 end as STT
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
group by MTID, NgayCT,SoCT 
order by NgayCT,STT, SoCT

create table #t
 (
	[bltkID] [int]   NULL ,	
	[Thu] decimal(28, 6) NULL ,
	[Chi] decimal(28, 6) NULL ,
	[ThuNt] decimal(28, 6) NULL ,
	[ChiNt] decimal(28, 6) NULL ,
	[ton] decimal(28, 6) NULL,
	[tonNt] decimal(28, 6) NULL, 
	[STT] int null
) ON [PRIMARY]

insert into #t select min(bltkID) as bltkID,sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(PsNoNt) as TienThuNt, sum(PsCoNt) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint, 
case when sum(PsNo) != 0 then 1 else 2 end as STT
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
group by MTID, NgayCT,SoCT 
order by ngayCT,Stt, SoCT
declare @tmp decimal(28,6),@tmpnt decimal(28,6)
set @tmp=@dauky
set @tmpnt = @daukynt
open cur
fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt, @stt
while @@fetch_status=0
begin
	set @ton=@tmp+@thu-@chi
	set @tmp=@ton
	set @tonnt=@tmpnt+@thunt-@chint
	set @tmpnt=@tonnt
	UPDATE #t SET ton=@ton,tonnt=@tonnt where bltkid=@id
	fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt, @stt
	
end
close cur
deallocate cur

select x.bltkid, x.SoCT,x.NgayCT,
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as ongba,
 x.maKH, x.diengiai, x.tkdu, x.MaNt, x.TyGia,x.[Ps nợ],x.[Ps có],x.[Số dư],x.[Ps nợ nt], x.[PS có nt],x.[Số dư nt],x.Stt,
 case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh
from
((
select N'''' as bltkid ,N'''' as soct,null as ngayct,N'''' as ongba , N'''' as maKH, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as diengiai, N'''' as tkdu,N'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt, 0 as STT2)
union all
(SELECT a.bltkid, a.SoCT, a.NgayCT,a.OngBa as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1,case when b.Thu != 0 then 1 else 2 end
from bltk a, #t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by stt, ngayct, stt2, soct
drop table #t'
where ReportName = @reportName

-- Sổ tiền gởi ngân hàng
set @reportName = N'Sổ tiền gởi ngân hàng'
Update sysReport set Query = N'declare @tkrp nvarchar(20)
declare @dauky decimal(28,6),@daukynt decimal(28,6)

declare @thu decimal(28,6),@thunt decimal(28,6)
declare @chi decimal(28,6),@chint decimal(28,6)
declare @ton decimal(28,6)
declare @tonnt decimal(28,6)
declare @id int
declare @tungayCt datetime,@ngaydk datetime
declare @denngayCt datetime
declare @stt int
set @tuNgayCt=@@NgayCT1
set @denNgayCt=dateadd(hh,23,@@NgayCT2)
set @ngaydk=dateadd(hh,-1,@tungayct)
set @tkrp=@@TK

declare @nodk decimal(28,6),@nodknt decimal(28,6)
declare @codk decimal(28,6),@codknt decimal(28,6)
	exec sodutaikhoannt @tkrp,@ngaydk,''@@ps'',@Nodk output, @Codk output,@NoDkNt output, @CoDkNt output
set @dauky = @nodk
set @daukynt = @nodknt
declare cur cursor for 
SELECT bltkID, PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint, 
case when PsNo != 0 then 1 else 2 end as STT

FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
order by NgayCT,STT,SoCT

create table #t
 (
	[bltkID] [int]   NULL ,	
	[Thu] [decimal](28, 6) NULL ,
	[Chi] [decimal](28, 6) NULL ,
	[ThuNt] [decimal](28, 6) NULL ,
	[ChiNt] [decimal](28, 6) NULL ,
	[ton] [decimal](28, 6) NULL,
	[tonNt] [decimal](28, 6) NULL,
	[stt] [int] null
) ON [PRIMARY]

insert into #t select bltkID ,PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint, case when PsNo != 0 then 1 else 2 end as STT
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
order by ngayCT,STT, SoCT
declare @tmp decimal(28,6),@tmpnt decimal(28,6)
set @tmp=@dauky
set @tmpnt = @daukynt
open cur
fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt, @stt
while @@fetch_status=0
begin
	set @ton=@tmp+@thu-@chi
	set @tmp=@ton
	set @tonnt=@tmpnt+@thunt-@chint
	set @tmpnt=@tonnt
	UPDATE #t SET ton=@ton,tonnt=@tonnt where bltkid=@id
	fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt, @stt
	
end
close cur
deallocate cur

select x.*, (select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as tenkh
from
((
select N'''' as bltkid ,N'''' as soct,null as ngayct,N'''' as ongba , N'''' as maKH, case when @@lang = 1 then N''Begin of Period'' else N''Số dư đầu kỳ'' end as diengiai, N'''' as tkdu,N'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt, 0 as Stt2)
union all
(SELECT a.bltkid, a.SoCT, a.NgayCT,
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = a.makh) as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1, b.stt as Stt2
from bltk a, #t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by Stt, ngayct, stt2, soct
drop table #t'
where ReportName = @reportName

-- Tổng hợp chữ T 1 tài khoản
set @reportName = N'Tổng hợp chữ T 1 tài khoản'
Update sysReport set Query = N'declare @tk varchar(16)
declare @codauky decimal(28,6)
declare @nodauky decimal(28,6)

declare @cocuoiky decimal(28,6)
declare @nocuoiky decimal(28,6)

declare @tungay datetime
declare @denngay datetime 
--declare @datetemp datetime
declare @ngaydk datetime
declare @dauky decimal(28,6)
declare @cuoiky decimal(28,6)

declare @Tongpsno decimal(28,6)
declare @Tongpsco decimal(28,6)

declare @dif decimal(28,6)

set @tungay = @@ngayct1
set @denngay = dateadd(hh,23,@@ngayct2)

--set @datetemp = dateadd(hh,1,@denngay)
set @ngaydk=dateadd(hh,-1,@tungay)
set @tk = @@TK

    execute Sodutaikhoan @tk,@ngaydk,''@@ps'',@nodauky output,@codauky       output
	
	-- Lấy lại số dư đầu kỳ
	if @tk like ''1%'' or @tk like ''2%'' or @tk like ''3%'' or @tk like ''4%''
	BEGIN
		if @nodauky > 0 And @codauky > 0
		BEGIN
			set @dif = @nodauky - @codauky
			if @dif > 0 
			BEGIN
				set @nodauky = @dif
				set @codauky = 0
			END
			else
			BEGIN
				set @codauky = abs(@dif)
				set @nodauky = 0
			END
		END
	END
	
    execute Sodutaikhoan @tk,@denngay,''@@ps'',@nocuoiky output, @cocuoiky        output
		
    execute Sopstaikhoan @tk,@tungay,@denngay,''@@ps'',@Tongpsno output,@Tongpsco output
    
    -- Lấy lại số dư cuối kỳ
	if @tk like ''1%'' or @tk like ''2%''
	BEGIN
		if @nodauky > 0
		BEGIN
			set @nocuoiky = @nodauky + @Tongpsno - @Tongpsco
			set @cocuoiky = 0
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END
		END
		
		if @codauky > 0
		BEGIN
			set @cocuoiky = @codauky + @Tongpsco - @Tongpsno
			set @nocuoiky = 0
			
			if @cocuoiky < 0 
			BEGIN
				set @nocuoiky = abs(@cocuoiky)
				set @cocuoiky = 0
			END
		END

		if isnull(@nodauky,0) = 0 And isnull(@codauky,0) = 0
		BEGIN
			set @cocuoiky = 0
			set @nocuoiky = isnull(@Tongpsno,0) - isnull(@Tongpsco,0)
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END
		END
	END
	
	if @tk like ''3%'' or @tk like ''4%''
	BEGIN
		if @nodauky > 0
		BEGIN
			set @nocuoiky = @nodauky + @Tongpsno - @Tongpsco
			set @cocuoiky = 0
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END	
		END
		
		if @codauky > 0
		BEGIN
			set @cocuoiky = @codauky + @Tongpsco - @Tongpsno
			set @nocuoiky = 0
			
			if @cocuoiky < 0 
			BEGIN
				set @nocuoiky = abs(@cocuoiky)
				set @cocuoiky = 0
			END	
		END

		if isnull(@nodauky,0) = 0 And isnull(@codauky,0) = 0
		BEGIN
			set @cocuoiky = 0
			set @nocuoiky = @Tongpsno - @Tongpsco
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END	
		END
	END
    
select tkdu, TenTk, psno, psco from
(
select 0 as stt, '''' as Tkdu,  case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as TenTK ,@nodauky as PsNo,@codauky as Psco
union all
(
Select 1 as stt, bltk.Tkdu, case when @@lang = 1 then dmtk.Tentk2 else dmtk.Tentk end as TenTK, Sum(PsNo), Sum(PsCo)
from bltk,dmtk
where bltk.Tkdu *= dmtk.tk and  left(bltk.tk,len(@tk)) = @tk and (NgayCt between @tungay and       @denngay) 
group by bltk.tkdu, case when @@lang = 1 then dmtk.Tentk2 else dmtk.Tentk end
)
union all
Select 2 as stt, '''' as Tkdu, case when @@lang = 1 then N''Total'' else N''Tổng cộng'' end as TenTK,@Tongpsno as psno,@Tongpsco as psco

union all
select 3 as stt, '''' as Tkdu, case when @@lang = 1 then N''End of Period'' else N''Cuối kỳ'' end as TenTK, @nocuoiky as psno,@cocuoiky as psco) x order by stt
'
where ReportName = @reportName

-- Bảng cân đối kế toán
set @reportName = N'Bảng cân đối kế toán'
Update sysReport set Query = N'select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.CachTinh, fr.LoaiCT, fr.InBaoCao,iscn
	,999999999999999.000000  as [Đầu năm]
	,999999999999999.000000 as [Cuối kỳ]
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
declare @daunam decimal(28,6)
declare @cuoiky decimal(28,6)
--Tính các ch? tiêu
declare @duno decimal(28,6)
declare @duco decimal(28,6)
declare @duno1 decimal(28,6)
declare @duco1 decimal(28,6)
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
drop table t'
where ReportName = @reportName

-- Báo cáo kết quả kinh doanh
set @reportName = N'Báo cáo kết quả kinh doanh'
Update sysReport set Query = N'select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh, fr.CachTinh, fr.LoaiCT, fr.InBaoCao
	,999999999999999.000000  as [Kỳ trước]
	,999999999999999.000000 as [Kỳ này]
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
declare @KyTruoc decimal(28,6)
declare @KyNay decimal(28,6)
--Tính các ch? tiêu
declare @psno decimal(28,6)
declare @psco decimal(28,6)
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
--update t set daunam=0.1'
where ReportName = @reportName

-- Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp
set @reportName = N'Báo cáo lưu chuyển tiền tệ - Phương pháp trực tiếp'
Update sysReport set Query = N'select fr.Stt, case when @@lang = 1 then fr.ChiTieu2 else fr.ChiTieu end as ChiTieu,tk,tkdu, fr.MaSo, fr.ThuyetMinh,  fr.CachTinh, fr.LoaiCT, fr.InBaoCao
	,999999999999999.000000  as [Kỳ trước]
	,999999999999999.000000 as [Kỳ này]
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
declare @KyTruoc decimal(28,6)
declare @KyNay decimal(28,6)
--Tính các ch? tiêu
declare @psno decimal(28,6)
declare @psco decimal(28,6)
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
--update t set daunam=0.1'
where ReportName = @reportName

-- Sổ chi tiết tài khoản
set @reportName = N'Sổ chi tiết tài khoản'
Update sysReport set Query = N'declare @tkrp varchar(16) -- Tài khoản lọc
declare @capLoc int -- Cấp lọc
declare @capTK int -- Cấp thực tế của TK lọc
declare @TKNhom varchar(16) 
declare @TenTKNhom nvarchar(128) 
declare @sql nvarchar(4000) 

declare @nodk decimal(28,6) -- Nợ đầu kỳ
declare @codk decimal(28,6) -- Có đầu kỳ

declare @nock decimal(28,6) -- Nợ cuối kỳ
declare @cock decimal(28,6) -- Có cuối kỳ

declare @nophatsinh decimal(28,6) -- Nợ phát sinh
declare @phatsinhco decimal(28,6) -- Có phát sinh

declare @ngayCt1 datetime
declare @ngayCt1h datetime
declare @ngayCt2 datetime

declare @dif decimal(28,6)

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
	
	-- Lấy lại số dư đầu kỳ
	if @tkrp like ''1%'' or @tkrp like ''2%'' or @tkrp like ''3%'' or @tkrp like ''4%''
	BEGIN
		if isnull(@nodk,0) > 0 And isnull(@codk,0) > 0
		BEGIN
			set @dif = isnull(@nodk,0) - isnull(@codk,0)
			if @dif > 0 
			BEGIN
				set @nodk = isnull(@dif,0)
				set @codk = 0
			END
			else
			BEGIN
				set @codk = abs(@dif)
				set @nodk = 0
			END
		END
	END
	
	--Lấy số dư cuối kỳ
	exec sodutaikhoan @tkrp,@ngayCt2, ''@@ps'' ,@nock output, @cock output
		
	--Lấy số phát sinh
	select @nophatsinh=sum(psno) from bltk where ngayct between @@ngayct1 and @@ngayct2 and tk like @@tk+''%'' and @@ps
	select @phatsinhco=sum(psco) from bltk where ngayct between @@ngayct1 and @@ngayct2 and tk like @@tk+''%'' and @@ps

	-- Lấy lại số dư cuối kỳ
	if @tkrp like ''1%'' or @tkrp like ''2%''
	BEGIN
		if isnull(@nodk,0) > 0
		BEGIN
			set @nock = isnull(@nodk,0) + isnull(@nophatsinh,0) - isnull(@phatsinhco,0)
			set @cock = 0
			
			if isnull(@nock,0) < 0 
			BEGIN
				set @cock = abs(@nock)
				set @nock = 0
			END
		END
		
		if isnull(@codk,0) > 0
		BEGIN
			set @cock = isnull(@codk,0) + isnull(@phatsinhco,0) - isnull(@nophatsinh,0)
			set @nock = 0
			
			if isnull(@cock,0) < 0 
			BEGIN
				set @nock = abs(@cock)
				set @cock = 0
			END
		END

		if isnull(@nodk,0) = 0 And isnull(@codk,0) = 0
		BEGIN
			set @cock = 0
			set @nock = isnull(@nophatsinh,0) - isnull(@phatsinhco,0)
			
			if isnull(@nock,0) < 0 
			BEGIN
				set @cock = abs(@nock)
				set @nock = 0
			END
		END
	END
	
	if @tkrp like ''3%'' or @tkrp like ''4%''
	BEGIN
		if isnull(@nodk,0) > 0
		BEGIN
			set @nock = isnull(@nodk,0) + isnull(@nophatsinh,0) - isnull(@phatsinhco,0)
			set @cock = 0
			
			if isnull(@nock,0) < 0 
			BEGIN
				set @cock = abs(@nock)
				set @nock = 0
			END	
		END
		
		if isnull(@codk,0) > 0
		BEGIN
			set @cock = isnull(@codk,0) + isnull(@phatsinhco,0) - isnull(@nophatsinh,0)
			set @nock = 0
			
			if isnull(@cock,0) < 0 
			BEGIN
				set @nock = abs(@cock)
				set @cock = 0
			END	
		END

		if isnull(@nodk,0) = 0 And isnull(@codk,0) = 0
		BEGIN
			set @cock = 0
			set @nock = isnull(@nophatsinh,0) - isnull(@phatsinhco,0)
			
			if isnull(@nock,0) < 0 
			BEGIN
				set @cock = abs(@nock)
				set @nock = 0
			END	
		END
	END
	
	-- Nếu không có nghiệp vụ phát sinh thì không lên số liệu
	if (isnull(@nodk,0) <> 0 OR isnull(@codk,0)<> 0 OR isnull(@cock,0) <> 0 OR isnull(@nock,0) <> 0 OR isnull(@nophatsinh,0) <> 0 OR isnull(@phatsinhco,0) <> 0)
	BEGIN
	insert into #resultTemp([NgayCT],[MTID],[MaCT],[soct],[diengiai],[tkdu],[psno],[psco],[maKH],[tenkh],[Stt],[TKNhom], [TenTKNhom])

	select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as diengiai,
	null as tkdu,@nodk as psno,@codk as psco, null as makh, null  as tenkh, 0 as Stt, @tkrp as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
	union  all

	select a.ngayCt,MTID, a.mact, a.SoCt, a.diengiai, a.tkdu, a.psno, a.psco, a.maKH, case when @@lang = 1 then b.tenkh2 else b.tenkh end as tenkh, 1 , @tkrp as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
	from bltk a, dmkh b 
	where a.makh*=b.makh and  left(a.tk,len(@tkrp))=@tkrp and (a.ngayCt between @ngayCt1h and @ngayCT2 ) 
		and a.mact not in (select MACT from dmKetchuyen) and @@ps
		
	union all
	
	-- Bút toán kết chuyển để dưới cùng
	select a.ngayCt,MTID, a.mact, a.SoCt, a.diengiai, a.tkdu, a.psno, a.psco, a.maKH, case when @@lang = 1 then b.tenkh2 else b.tenkh end as tenkh, 2 , @tkrp as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
	from bltk a, dmkh b 
	where a.makh*=b.makh and  left(a.tk,len(@tkrp))=@tkrp and (a.ngayCt between @ngayCt1h and @ngayCT2 ) 
		and a.mact in (select MACT from dmKetchuyen) and @@ps

	union all
	select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''Arising Total'' else N''Tổng phát sinh'' end as diengiai,
	   null as tkdu, @nophatsinh as psno, @phatsinhco  as psco, null as makh, null as tenkh, 3 , @tkrp as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]

	union all

	select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''End of Period'' else N''Cuối kỳ'' end as Diengiai,
	   null as tkdu, @nock as psno, @cock as psco, null as makh, null as tenkh, 4 , @tkrp as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
	order by Stt,Ngayct, SoCT,[Tài khoản nhóm] desc
	END
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
		-- Không lọc bậc -> Lấy các tài khoản bậc 2 và các tài khoản không có con (bậc 1)
		if (@capLoc = 0)
		BEGIN
			declare cur_tkCon CURSOR FOR
			select TK from DMTK where GradeTK = 2
			union
			select TK from DMTK where TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe) and GradeTK = 1
		END
		ELSE
		BEGIN
			declare cur_tkCon CURSOR FOR
			select TK from DMTK where GradeTK = @capLoc
		END
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
		
		-- Lấy lại số dư đầu kỳ
		if @tkrp like ''1%'' or @tkrp like ''2%'' or @tkrp like ''3%'' or @tkrp like ''4%''
		BEGIN
			if isnull(@nodk,0) > 0 And isnull(@codk,0) > 0
			BEGIN
				set @dif = isnull(@nodk,0) - isnull(@codk,0)
				if isnull(@dif,0) > 0 
				BEGIN
					set @nodk = isnull(@dif,0)
					set @codk = 0
				END
				else
				BEGIN
					set @codk = abs(@dif)
					set @nodk = 0
				END
			END
		END
		
		--Lấy số dư cuối kỳ
		exec sodutaikhoan @TKNhom,@ngayCt2, ''@@ps'' ,@nock output, @cock output
	
		--Lấy số phát sinh
		set @sql = ''insert into #psTemp select sum(psno) from bltk where ngayct between ''@@ngayct1'' and ''@@ngayct2'' and tk like '''''' + @TKNhom + ''%'''' and '' + ''@@ps''
		exec(@sql)
		select @nophatsinh = ps from #psTemp
		
		set @sql = ''insert into #psTemp select sum(psco) from bltk where ngayct between ''@@ngayct1'' and ''@@ngayct2'' and tk like ''''''+ @TKNhom + ''%'''' and '' + ''@@ps''
		exec(@sql)
		select @phatsinhco = ps from #psTemp

		-- Lấy lại số dư cuối kỳ
		if @TKNhom like ''1%'' or @TKNhom like ''2%''
		BEGIN
			if isnull(@nodk,0) > 0
			BEGIN
				set @nock = isnull(@nodk,0) + isnull(@nophatsinh,0) - isnull(@phatsinhco,0)
				set @cock = 0
				
				if isnull(@nock,0) < 0 
				BEGIN
					set @cock = abs(@nock)
					set @nock = 0
				END
			END
			
			if isnull(@codk,0) > 0
			BEGIN
				set @cock = isnull(@codk,0) + isnull(@phatsinhco,0) - isnull(@nophatsinh,0)
				set @nock = 0
				
				if isnull(@cock,0) < 0 
				BEGIN
					set @nock = abs(@cock)
					set @cock = 0
				END
			END

			if isnull(@nodk,0) = 0 And isnull(@codk,0) = 0
			BEGIN
				set @cock = 0
				set @nock = isnull(@nophatsinh,0) - isnull(@phatsinhco,0)
				
				if isnull(@nock,0) < 0 
				BEGIN
					set @cock = abs(@nock)
					set @nock = 0
				END
			END
		END
		
		if @TKNhom like ''3%'' or @TKNhom like ''4%''
		BEGIN
			if isnull(@nodk,0) > 0
			BEGIN
				set @nock = isnull(@nodk,0) + isnull(@nophatsinh,0) - isnull(@phatsinhco,0)
				set @cock = 0
				
				if isnull(@nock,0) < 0 
				BEGIN
					set @cock = abs(@nock)
					set @nock = 0
				END	
			END
			
			if isnull(@codk,0) > 0
			BEGIN
				set @cock = isnull(@codk,0) + isnull(@phatsinhco,0) - isnull(@nophatsinh,0)
				set @nock = 0
				
				if isnull(@cock,0) < 0 
				BEGIN
					set @nock = abs(@cock)
					set @cock = 0
				END	
			END

			if isnull(@nodk,0) = 0 And isnull(@codk,0) = 0
			BEGIN
				set @cock = 0
				set @nock = isnull(@nophatsinh,0) - isnull(@phatsinhco,0)
				
				if isnull(@nock,0) < 0 
				BEGIN
					set @cock = abs(@nock)
					set @nock = 0
				END	
			END
		END
		
		-- Nếu không có nghiệp vụ phát sinh thì không lên số liệu
		if (isnull(@nodk,0) <> 0 OR isnull(@codk,0)<> 0 OR isnull(@cock,0) <> 0 OR isnull(@nock,0) <> 0 OR isnull(@nophatsinh,0) <> 0 OR isnull(@phatsinhco,0) <> 0)
		BEGIN
		insert into #resultTemp([NgayCT],[MTID],[MaCT],[soct],[diengiai],[tkdu],[psno],[psco],[maKH],[tenkh],[Stt],[TKNhom],[TenTKNhom])

		select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as diengiai,
		null as tkdu,@nodk as psno,@codk as psco, null as makh, null  as tenkh, 0 as Stt, @TKNhom as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
		union  all

		select a.ngayCt,MTID, a.mact, a.SoCt, a.diengiai, a.tkdu, a.psno, a.psco, a.maKH, case when @@lang = 1 then b.tenkh2 else b.tenkh end as tenkh, 1 , @TKNhom as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
		from bltk a, dmkh b 
		where a.makh*=b.makh and  left(a.tk,len(@TKNhom))=@TKNhom and (a.ngayCt between @ngayCt1h and @ngayCT2 ) 
				and a.mact not in (select MACT from dmKetchuyen) and @@ps
				
		union  all
		
		-- Bút toán kết chuyển để dưới cùng
		select a.ngayCt,MTID, a.mact, a.SoCt, a.diengiai, a.tkdu, a.psno, a.psco, a.maKH, case when @@lang = 1 then b.tenkh2 else b.tenkh end as tenkh, 2 , @TKNhom as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
		from bltk a, dmkh b 
		where a.makh*=b.makh and  left(a.tk,len(@TKNhom))=@TKNhom and (a.ngayCt between @ngayCt1h and @ngayCT2 ) 
				and a.mact in (select MACT from dmKetchuyen) and @@ps

		union all
		select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''Arising Total'' else N''Tổng phát sinh'' end as diengiai,
		   null as tkdu, @nophatsinh as psno, @phatsinhco  as psco, null as makh, null as tenkh, 3 , @TKNhom as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]

		union all

		select null as ngayct,null as MTID, null as mact, null as soct, case when @@lang = 1 then N''End of Period'' else N''Cuối kỳ'' end as Diengiai,
		   null as tkdu, @nock as psno, @cock as psco, null as makh, null as tenkh, 4 , @TKNhom as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
		order by Stt,Ngayct, SoCT,[Tài khoản nhóm] desc
		END
		
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
END'
where ReportName = @reportName

-- Giá thành định mức
set @reportName = N'Giá thành định mức'
Update sysReport set Query = N'DECLARE @cpc decimal(28,6)
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
	sln decimal(28, 6) null,
	dddk decimal(28, 6) null,
	nvl decimal(28, 6) null,
	Luong decimal(28, 6) null,
	cpc decimal(28, 6) null,
	ddck decimal(28, 6) null,
	Gia decimal(28, 6) null
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
declare @tongHS decimal(28,6)
declare @HSCPC decimal(28,6)
select @tonghs=sum(NVL+Luong) from #t
set @hsCPC=0
if @tonghs>0
begin
	set @HSCPC =@cpc/@tongHS
end
--update #t set cpc =(NVL+Luong) * @HSCPC
--declare @tongHSDC decimal(28,6)
--select @tongHSDC=sum(r.Heso*(t.NVL+t.LUONG))   from #t t inner join dfcpc r on t.masp= r.masp where r.ngayct between @ngayct and @ngayct1
--update #t set cpc=@CPC* r.heso*(t.NVL+t.LUONG)/@tongHSDC from #t t inner join dfcpc r on t.masp= r.masp where r.ngayct between @ngayct and @ngayct1

update #t set gia=(dddk+nvl+luong+cpc-ddck)/sln where  sln>0
select masp as [Mã sản phẩm],case when @@lang = 1 then  dmvt.tenvt2 else dmvt.tenvt end as [Tên sản phẩm],sln as [Số lượng nhập kho], dddk as [Dở dang đầu kỳ],nvl as [Chi phí nguyên vật liệu], luong as [Chi phí nhân công trực tiếp], CPC as [Chi phí sản xuất chung], ddck as [Dở dang cuối kỳ], gia as [Giá thành] from #t inner join dmvt on #t.masp = dmvt.mavt
drop table #t'
where ReportName = @reportName

-- Báo cáo kết quả kinh doanh theo công trình xây lắp
set @reportName = N'Báo cáo kết quả kinh doanh theo công trình xây lắp'
Update sysReport set Query = N'declare @ngayct1  datetime
declare @ngayct2 datetime
declare @ngaydaunam datetime
set  @ngayct1=@@ngayct1
set  @ngayct2=dateadd(hh,23,@@ngayct2)
declare @gtsx decimal(28,6) 
declare @gtsx2 decimal(28,6)
declare @gtsx3 decimal(28,6)
declare @cpbanhang decimal(28,6)
declare @cpquanly decimal(28,6)
declare @cpquanly2 decimal(28,6)
declare @cpquanly3 decimal(28,6)
declare @cpbanhang2 decimal(28,6)
declare @cpbanhang3 decimal(28,6)
declare @gttoanbo1 decimal(28,6)
declare @dtthuan1 decimal(28,6)
declare @dtthuan2 decimal(28,6)
declare @dtthuan3 decimal(28,6)
declare @lailo1  decimal(28,6)
declare @gttoanbo2 decimal(28,6)
declare @gttoanbo3 decimal(28,6)
declare @lailo2 decimal(28,6)
declare @lailo3 decimal(28,6)

declare @macongtrinh  nvarchar(50)
declare @tencongtrinh  nvarchar(50)
declare  curtemp cursor for

select macongtrinh,tencongtrinh from dmcongtrinh where @@ps
create  table #tam
 (
	[macongtrinh] [nvarchar]  (50) NULL ,	
    [tencongtrinh] [nvarchar]  (50) NULL ,
	[giathanhsx]  decimal(28, 6) null,
	[cpbanhang] decimal(28, 6) null,
	[cpquanly] decimal(28, 6) NULL ,
	[giathanhtoanbo] decimal(28, 6) NULL,
	[dtthuan1] decimal(28, 6) null,
	[lailo1] decimal(28, 6) null,
	[gttbdaunam]  decimal(28, 6) null,
	[dtthuan2]  decimal(28, 6) null,
	[lailo2]  decimal(28, 6) null,
	[gtkhoicong]  decimal(28, 6) null,
	[dtthuan3]  decimal(28, 6) null,
	[lailo3]  decimal(28, 6) null
) ON [PRIMARY]


OPEN curtemp
DECLARE @SOQD NVARCHAR(50)
DECLARE @DBname NVARCHAR(10)
Set @SOQD = ''''
Set @DBname = @@DBName
SELECT @SOQD = _Value  FROM [CDT].[dbo].[sysConfig] WHERE _key=''SOQD'' and DBname = @DBname
FETCH NEXT FROM curtemp INTO @macongtrinh,@tencongtrinh
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @SOQD = N''15/2006/QĐ-BTC'' -- Nếu là quyết định 15
		BEGIN
			select @gtsx=sum(psno)from bltk where ( left(tk,3) =''621'' or left(tk,3) =''622'' or left(tk,3) =''623'' or left(tk,3) =''627'' ) and macongtrinh=@macongtrinh and ngayct between @ngayct1 and @ngayct2
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
			select @gtsx2=sum(psno)from bltk where ( left(tk,3) =''621'' or left(tk,3) =''622'' or left(tk,3) =''623'' or left(tk,3) =''627'' ) and macongtrinh=@macongtrinh and ngayct between @ngaydaunam and @ngayct2
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
			declare  @dudau15 decimal(28,6)
			declare  @sx15  decimal(28,6)
			select @dudau15=tien from cocongtrinhdd where macongtrinh=@macongtrinh

			select @sx15=sum(psno)from bltk where ( left(tk,3) =''621'' or left(tk,3) =''622'' or left(tk,3) =''623'' or left(tk,3) =''627'' ) and macongtrinh=@macongtrinh and ngayct <= @ngayct2
			select @cpbanhang3=sum(psno) from bltk where left(tk,3)=''641'' and macongtrinh=@macongtrinh  and ngayct <= @ngayct2
			select @cpquanly3=sum(psno) from bltk where left(tk,3)=''642'' and macongtrinh=@macongtrinh and  ngayct <= @ngayct2

			select @dtthuan3=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh and  ngayct<= @ngayct2

			if @cpbanhang3 is null set @cpbanhang3=0.0
			if @cpquanly3 is null set @cpquanly3=0.0
			if @dtthuan3 is null set @dtthuan3=0.0
			if @dudau15 is null set @dudau15=0
			if @sx15 is null set @sx15=0
			set @gtsx3=@sx15+@dudau15
			set @gttoanbo3=@gtsx3+@cpbanhang3+@cpquanly3
			set @lailo3=@dtthuan3-@gttoanbo3

	END 
	Else IF @SOQD = N''48/2006/QĐ-BTC'' -- Nếu là quyết định 48
		BEGIN
			select @gtsx=sum(psno)from bltk where ( left(tk,5) =''15411'' or left(tk,5) =''15412'' or left(tk,5) =''15413'' or left(tk,5) =''15417'' ) and macongtrinh=@macongtrinh and ngayct between @ngayct1 and @ngayct2
			select @cpbanhang=sum(psno) from bltk where left(tk,4)=''6421'' and macongtrinh=@macongtrinh  and ngayct between @ngayct1 and @ngayct2
			select @cpquanly=sum(psno) from bltk where left(tk,4)=''6422'' and macongtrinh=@macongtrinh and  ngayct between @ngayct1 and @ngayct2
			select @dtthuan1=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh  and ngayct between @ngayct1 and @ngayct2 
			if @gtsx is null set @gtsx=0.0
			if @cpbanhang is null set @cpbanhang=0.0
			if @cpquanly is null set @cpquanly=0.0
			if @dtthuan1 is null set @dtthuan1=0.0

			set @gttoanbo1=@gtsx+@cpbanhang+@cpquanly
			set @lailo1=@dtthuan1-@gttoanbo1

			--luy ke tu dau nam den cuoi ky  (them dk ngayct between ngaydaunam and ngayct2)

			set @ngaydaunam= convert(datetime,''01/01''+''/''+ convert(nvarchar(4), year(@ngayct1)))
			select @gtsx2=sum(psno)from bltk where ( left(tk,5) =''15411'' or left(tk,5) =''15412'' or left(tk,5) =''15413'' or left(tk,5) =''15417'' ) and macongtrinh=@macongtrinh and ngayct between @ngaydaunam and @ngayct2
			select @cpbanhang2=sum(psno) from bltk where left(tk,4)=''6421'' and macongtrinh=@macongtrinh  and ngayct between @ngaydaunam and @ngayct2
			select @cpquanly2=sum(psno) from bltk where left(tk,4)=''6422'' and macongtrinh=@macongtrinh and  ngayct between @ngaydaunam and @ngayct2

			select @dtthuan2=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh and  ngayct between @ngaydaunam and @ngayct2
			if @gtsx2 is null set @gtsx2=0.0
			if @cpbanhang2 is null set @cpbanhang2=0.0
			if @cpquanly2 is null set @cpquanly2=0.0
			if @dtthuan2 is null set @dtthuan2=0.0

			set @gttoanbo2=@gtsx2+@cpbanhang2+@cpquanly2
			set @lailo2=@dtthuan2-@gttoanbo2

			--luy ke tu luc khoi cong 
			declare  @dudau48 decimal(28,6)
			declare  @sx48  decimal(28,6)
			select @dudau48=tien from cocongtrinhdd where macongtrinh=@macongtrinh

			select @sx48=sum(psno)from bltk where ( left(tk,5) =''15411'' or left(tk,5) =''15412'' or left(tk,5) =''15413'' or left(tk,5) =''15417'' ) and macongtrinh=@macongtrinh and ngayct <= @ngayct2
			select @cpbanhang3=sum(psno) from bltk where left(tk,4)=''6421'' and macongtrinh=@macongtrinh  and ngayct <= @ngayct2
			select @cpquanly3=sum(psno) from bltk where left(tk,4)=''6422'' and macongtrinh=@macongtrinh and  ngayct <= @ngayct2

			select @dtthuan3=sum(psco) from bltk where left(tk,3)=''511'' and macongtrinh=@macongtrinh and  ngayct<= @ngayct2

			if @cpbanhang3 is null set @cpbanhang3=0.0
			if @cpquanly3 is null set @cpquanly3=0.0
			if @dtthuan3 is null set @dtthuan3=0.0
			if @dudau48 is null set @dudau48=0
			if @sx48 is null set @sx48=0
			set @gtsx3=@sx48+@dudau48
			set @gttoanbo3=@gtsx3+@cpbanhang3+@cpquanly3
			set @lailo3=@dtthuan3-@gttoanbo3

		END
insert into #tam (macongtrinh,tencongtrinh,giathanhsx,cpbanhang,cpquanly,giathanhtoanbo,dtthuan1,lailo1,gttbdaunam,dtthuan2,lailo2,gtkhoicong,dtthuan3,lailo3) values (@macongtrinh,@tencongtrinh,@gtsx,@cpbanhang,@cpquanly,@gttoanbo1,@dtthuan1,@lailo1,@gttoanbo2,@dtthuan2,@lailo2,@gttoanbo3,@dtthuan3,@lailo3)
FETCH NEXT FROM curtemp INTO @macongtrinh,@tencongtrinh
END
CLOSE curtemp
DEALLOCATE curtemp
select macongtrinh,tencongtrinh,giathanhsx [Giá thành công trình], cpbanhang [Chi phí bán hàng], cpquanly [Chi phí quản lý], dtthuan1 [Doanh thu thuần], lailo1 [Lãi lỗ], gttbdaunam [Giá thành lũy kế năm], dtthuan2 [Doanh thu lũy kế năm], lailo2 [Lãi lỗ lũy kế năm], giathanhtoanbo [Giá thành toàn bộ], dtthuan3 [Doanh thu toàn bộ], lailo3 [Lãi lỗ toàn bộ] from #tam
drop table #tam'
where ReportName = @reportName

-- Nhật ký - sổ cái
set @reportName = N'Nhật ký - sổ cái'
Update sysReport set Query = N'--Dòng tổng cộng
DECLARE @TK nvarchar(512)
DECLARE @LoaiTK nvarchar(512)
DECLARE @MaxRecord int

declare @codauky decimal(28,6)
declare @nodauky decimal(28,6)

declare @cocuoiky decimal(28,6)
declare @nocuoiky decimal(28,6)

declare @tungay datetime
declare @denngay datetime 
declare @datetemp datetime
declare @ngaydk datetime
declare @dauky decimal(28,6)
declare @cuoiky decimal(28,6)

declare @Tongpsno decimal(28,6)
declare @Tongpsco decimal(28,6)

declare @dif decimal(28,6)

set @tungay = @@ngayct1
set @denngay = dateadd(hh,23,@@ngayct2)

set @datetemp = dateadd(hh,1,@denngay)
set @ngaydk=dateadd(hh,-1,@tungay)


Select @MaxRecord =  count (BLTKID) FROM wNKSC where psno + psco > 0  and NgayCt between @tungay and  @denngay and  @@ps
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#NKSC'') AND type in (N''U''))
BEGIN
CREATE TABLE #NKSC(
	ThuTu [int],
	[BLTKID] [int],
	[SoCT] [nvarchar](512) NULL,
	[NgayCT] [smalldatetime] NULL,
	[DienGiai] nvarchar(512) COLLATE database_default NULL,
	[TKNo] [varchar](16) COLLATE database_default NULL,
	[TKCo] [varchar](16) COLLATE database_default NULL,
	[RPs] [decimal](28, 6) NULL, --Row
	[CPs] [decimal](28, 6) NULL, --Col
	[TK] [nvarchar](512) COLLATE database_default NULL,
	[LoaiTK] [nvarchar](512) COLLATE database_default NULL
)
END

DECLARE nksc_cursor CURSOR FOR 
 SELECT DISTINCT TK
 FROM   wNKSC
 WHERE  psno + psco > 0 and (NgayCt between @tungay and  @denngay)  and  @@ps
 
OPEN nksc_cursor

fetch nksc_cursor  into @TK

WHILE @@FETCH_STATUS = 0
BEGIN
    -------------------------------Lấy số dư-------------------------------
    execute Sodutaikhoan @tk,@ngaydk,''@@ps'',@nodauky output,@codauky  output
	
	-- Lấy lại số dư đầu kỳ
	if @tk like ''1%'' or @tk like ''2%'' or @tk like ''3%'' or @tk like ''4%''
	BEGIN
		if @nodauky > 0 And @codauky > 0
		BEGIN
			set @dif = @nodauky - @codauky
			if @dif > 0 
			BEGIN
				set @nodauky = @dif
				set @codauky = 0
			END
			else
			BEGIN
				set @codauky = abs(@dif)
				set @nodauky = 0
			END
		END
	END
	
    execute Sodutaikhoan @tk,@datetemp,''@@ps'',@nocuoiky output, @cocuoiky        output
		
    execute Sopstaikhoan @tk,@tungay,@datetemp,''@@ps'',@Tongpsno output,@Tongpsco output
    
    -- Lấy lại số dư cuối kỳ
	if @tk like ''1%'' or @tk like ''2%''
	BEGIN
		if @nodauky > 0
		BEGIN
			set @nocuoiky = @nodauky + @Tongpsno - @Tongpsco
			set @cocuoiky = 0
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END
		END
		
		if @codauky > 0
		BEGIN
			set @cocuoiky = @codauky + @Tongpsco - @Tongpsno
			set @nocuoiky = 0
			
			if @cocuoiky < 0 
			BEGIN
				set @nocuoiky = abs(@cocuoiky)
				set @cocuoiky = 0
			END
		END

		if isnull(@nodauky,0) = 0 And isnull(@codauky,0) = 0
		BEGIN
			set @cocuoiky = 0
			set @nocuoiky = isnull(@Tongpsno,0) - isnull(@Tongpsco,0)
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END
		END
	END
	
	if @tk like ''3%'' or @tk like ''4%''
	BEGIN
		if @nodauky > 0
		BEGIN
			set @nocuoiky = @nodauky + @Tongpsno - @Tongpsco
			set @cocuoiky = 0
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END	
		END
		
		if @codauky > 0
		BEGIN
			set @cocuoiky = @codauky + @Tongpsco - @Tongpsno
			set @nocuoiky = 0
			
			if @cocuoiky < 0 
			BEGIN
				set @nocuoiky = abs(@cocuoiky)
				set @cocuoiky = 0
			END	
		END

		if isnull(@nodauky,0) = 0 And isnull(@codauky,0) = 0
		BEGIN
			set @cocuoiky = 0
			set @nocuoiky = @Tongpsno - @Tongpsco
			
			if @nocuoiky < 0 
			BEGIN
				set @cocuoiky = abs(@nocuoiky)
				set @nocuoiky = 0
			END	
		END
	END
    --Số dư đầu kỳ
    if (@nodauky > 0) 
		set @LoaiTK = N''Có''
	else 
		set @LoaiTK = N''Nợ''
	INSERT INTO #NKSC (ThuTu,BLTKID,[NgayCT],[SoCT],[DienGiai], [TKNo],[TKCo],[RPs],[TK],LoaiTK) Values (1,NULL,NULL,NULL, case when @@lang = 1 then N''Begin of Period'' else N''Số dư đầu kỳ'' end,NULL,NULL,@nodauky + @codauky,@TK,@LoaiTK)
    --Tổng cộng	
    if (@Tongpsno > 0) 
		set @LoaiTK = N''Có''
	else 
		set @LoaiTK = N''Nợ''
		
    INSERT INTO #NKSC (ThuTu,BLTKID,[NgayCT],[SoCT],[DienGiai], [TKNo],[TKCo],[RPs],[TK],LoaiTK) Values (@MaxRecord+2,NULL,NULL,NULL,case when @@lang = 1 then N''Total'' else N''Cộng số phát sinh'' end,NULL,NULL,@Tongpsno + @Tongpsco,@TK,@LoaiTK)	
    --Số dư cuối kỳ
     if (@nocuoiky > 0) 
		set @LoaiTK = N''Có''
	else 
		set @LoaiTK = N''Nợ''
    INSERT INTO #NKSC (ThuTu,BLTKID,[NgayCT],[SoCT],[DienGiai], [TKNo],[TKCo],[RPs],[TK],LoaiTK) Values (@MaxRecord+3,NULL,NULL,NULL,case when @@lang = 1 then N''End of Period'' else N''Số dư cuối kỳ'' end,NULL,NULL,@nocuoiky + @cocuoiky,@TK,@LoaiTK)	
	fetch nksc_cursor  into @TK
END 
CLOSE nksc_cursor
DEALLOCATE nksc_cursor
--Thêm dữ liệu
INSERT INTO #NKSC ( ThuTu,BLTKID,[NgayCT],[SoCT],[DienGiai], [TKNo],[TKCo],[RPs],[CPs],[TK],LoaiTK)
select (ROW_NUMBER() OVER(ORDER BY ngayct,soct) + 1),  BLTKID, NgayCT, SoCT, diengiai, [Tài khoản đối ứng Nợ] = case when psco>0 then TkDu else '''' end, [Tài khoản đối ứng Có] = case when psno>0 then TkDu else '''' end,psno + psco,psno + psco,TK, LoaiTK
from wNKSC where psno+psco>0 and (NgayCt between @tungay and @denngay) and @@ps
order by ngayct,soct

-- Thêm dòng cuối
select ThuTu,BLTKID, ngayct as [Ngày tháng CT], SoCT as [Số hiệu CT], ngayct as [Ngày tháng ghi sổ], DienGiai as  [Diễn giải],[TKNo] as  [Tài khoản đối ứng Nợ],[TKCo] as [Tài khoản đối ứng Có],[CPs] as [Số tiền phát sinh],[RPs] as [Số tiền],TK, LoaiTK as [Loại TK] from #NKSC
order by ThuTu,ngayct,soct
drop table #NKSC'
where ReportName = @reportName

-- Phải thu của khách hàng
set @reportName = N'Phải thu của khách hàng'
Update sysReport set Query = N'DECLARE @tk NVARCHAR(16)
DECLARE @ngayCt DATETIME
DECLARE @dk NVARCHAR(256)
DECLARE @sql NVARCHAR (4000)

SET @tk=''131''
SET @ngayCt=@@NgayCT
SET @sql=''create view wsodu as select makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))='''''' + @tk + '''''' group by makh''

EXEC (@sql)

SET @sql=''create view wsotk as select makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))='''''' + @tk + '''''' and ngayct<=cast('''''' + CONVERT(NVARCHAR, @ngayct) + '''''' as datetime) group by makh ''

EXEC (@sql)

SET @sql=''create view wG1 as select * from wsodu union all select * from wsotk''

EXEC (@sql)

SET @sql=''create view wducuoi as select makh,  dunont=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,  duno=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,  ducont=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,  duco=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end  from wG1 group by makh''

EXEC (@sql)

DECLARE @tongcong decimal(28,6)

SELECT @tongcong = Sum(duno - duco)
FROM   wducuoi

SELECT *
FROM   (SELECT case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end AS ''Tên khách hàng'',
               a.duno - a.duco AS ''Số phải thu''
        FROM   wducuoi a,
               dmkh
        WHERE  a.makh = dmkh.makh
        UNION ALL
        SELECT case when @@lang = 1 then N''Total'' else N''Tổng cộng'' end,
               @tongcong) t

DROP VIEW wsodu

DROP VIEW wsotk

DROP VIEW wG1

DROP VIEW wducuoi '
where ReportName = @reportName

-- Phải trả nhà cung cấp
set @reportName = N'Phải trả nhà cung cấp'
Update sysReport set Query = N'DECLARE @tk NVARCHAR(16)
DECLARE @ngayCt DATETIME
DECLARE @dk NVARCHAR(256)
DECLARE @sql NVARCHAR (4000)

SET @tk=''331''
SET @ngayCt=@@NgayCT
SET @sql=''create view wsodu as select makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))='''''' + @tk + '''''' group by makh''

EXEC (@sql)

SET @sql=''create view wsotk as select makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))='''''' + @tk + '''''' and ngayct<=cast('''''' + CONVERT(NVARCHAR, @ngayct) + '''''' as datetime) group by makh ''

EXEC (@sql)

SET @sql=''create view wG1 as select * from wsodu union all select * from wsotk''

EXEC (@sql)

SET @sql=''create view wducuoi as select makh,  dunont=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,  duno=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,  ducont=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,  duco=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end  from wG1 group by makh''

EXEC (@sql)

DECLARE @tongcong decimal(28,6)

SELECT @tongcong = Sum(duco - duno)
FROM   wducuoi

SELECT *
FROM   (SELECT case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as N''Nhà cung cấp'',
               a.duco - a.duno AS N''Số phải trả''
        FROM   wducuoi a,
               dmkh
        WHERE  a.makh *= dmkh.makh
        UNION ALL
        SELECT case when @@lang = 1 then N''Total'' else N''Tổng cộng'' end ,
               @tongcong) t

DROP VIEW wsodu

DROP VIEW wsotk

DROP VIEW wG1

DROP VIEW wducuoi '
where ReportName = @reportName

-- Số liệu tài chính tổng hợp
set @reportName = N'Số liệu tài chính tổng hợp'
Update sysReport set Query = N'DECLARE @NGAYCT1 DATETIME
DECLARE @NGAYCT2 DATETIME
SET @NGAYCT1 = @@NGAYCT1
SET @NGAYCT2 =dateadd(hh,23, @@NGAYCT2)
declare @duno decimal(28,6)
declare @duco decimal(28,6)
declare @psno decimal(28,6)
declare @psco decimal(28,6)

exec sodutaikhoan ''111'', @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
declare @111 decimal(28,6)
set @111 = @duno - @duco

exec sodutaikhoan ''112'', @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
declare @112 decimal(28,6)
set @112 = @duno - @duco

declare @11 decimal(28,6)
set @11 = @111 + @112

exec sopstaikhoan ''51,71'', @ngayCt1,@ngayCt2,DEFAULT , @psno OUTPUT , @psco OUTPUT 
declare @51_71 decimal(28,6)
set @51_71 = @psco

exec sopstaikhoan ''52,53'', @ngayCt1,@ngayCt2,DEFAULT , @psno OUTPUT , @psco OUTPUT 
declare @52_53 decimal(28,6)
set @52_53 = @psno

declare @dt decimal(28,6)
set @dt = @51_71 - @52_53

exec sopstaikhoan ''63,64,811'', @ngayCt1,@ngayCt2,DEFAULT , @psno OUTPUT , @psco OUTPUT 
declare @cp decimal(28,6)
set @cp = @psno

declare @lntt decimal(28,6)
set @lntt = @dt - @cp

exec sopstaikhoan ''3334'', @ngayCt1,@ngayCt2,DEFAULT , @psno OUTPUT , @psco OUTPUT 
declare @3334 decimal(28,6)
set @3334 = @psno - @psco

declare @lrtt decimal(28,6)
set @lrtt = @lntt - @3334

exec sodutaikhoan ''131'', @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
declare @131 decimal(28,6)
set @131 = @duno - @duco

exec sodutaikhoan ''331'', @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
declare @331 decimal(28,6)
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
where ReportName = @reportName

-- Sổ chi tiết công nợ nhà cung cấp
set @reportName = N'Sổ chi tiết công nợ nhà cung cấp'
Update sysReport set Query = N'declare @kh varchar(16)
declare @tkrp varchar(16)
declare @nocodk bit
declare @nocock bit
set @tkrp=@@TK
set @kh=@@MaKH
declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @NgayCt1=cast(@@ngayct1 as datetime)
set @NgayCt2=cast(@@ngayct2 as datetime)
declare @dauky decimal(28,6), @daukynt decimal(28,6)
--tìm số dư đầu kỳ=Số dư đầu năm + số phát sinh trước ngàyCt1
	
	declare @daunam decimal(28,6), @daunamnt decimal(28,6)
	declare @count1 int 
	--Số phát inh đầu năm
	set @daunamnt=(SELECT sum(Dunont-Ducont) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunam=(SELECT sum(Duno-Duco) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @count1=(select count(*) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunamnt = case when @count1<>0 then @daunamnt else 0 end
	set @daunam = case when @count1<>0 then @daunam else 0 end
	set @daukynt=(select sum(psNont)-sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @dauky=(select sum(psNo)-sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @daukynt=case when @count1>0 then @daukynt else 0 end
	set @dauky=case when @count1>0 then @dauky else 0 end

	set @daukynt=@daukynt + @daunamnt
	set @dauky=@dauky + @daunam
	set @nocodk = case when @dauky>=0 then 1 else 0 end

--tìm số dư cuối kỳ
	declare @psNo decimal(28,6), @psNont decimal(28,6)
	declare @psCo decimal(28,6), @psCont decimal(28,6)
	declare @cuoiky decimal(28,6), @cuoikynt decimal(28,6)
	set @psNont=(select sum(psNont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCont=(select sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNo=(select sum(psNo)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCo=(select sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNont=case when @count1>0 then @psNont else 0 end
	set @psCont=case when @count1>0 then @psCont else 0 end
	set @psNo=case when @count1>0 then @psNo else 0 end
	set @psCo=case when @count1>0 then @psCo else 0 end
	set @cuoikynt=@daukynt + @psNont-@psCont
	set @cuoiky=@dauky + @psNo-@psCo
	set @nocock = case when @cuoiky>=0 then 1 else 0 end

--Lấy số phát sinh

declare @nophatsinh decimal(28,6), @nophatsinhnt decimal(28,6)
declare @phatsinhco decimal(28,6), @phatsinhcont decimal(28,6)
select @nophatsinhnt=sum(psnont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhcont=sum(pscont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @nophatsinh=sum(psno) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhco=sum(psco) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps

select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Beginning amount'' else N''Số dư đầu kỳ'' end as diengiai,
null as tkdu,psnont=case when @nocodk=0 then 0 else @daukynt end,psno=case when @nocodk=0 then 0 else @dauky end,
pscont=case when @nocodk=0 then abs(@daukynt) else 0 end,psco=case when @nocodk=0 then abs(@dauky) else 0 end, null as makh, null as tenkh, 0 as Stt
union  all
select ngayCt,MTID, maCT,SoCt,diengiai,tkdu,psnont,psno,pscont,psco ,maKH,(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = b.makh) as TenKH, 1 from bltk b
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Total of arinsing'' else N''Tổng phát sinh'' end as diengiai,
null as tkdu,@nophatsinhnt as sopsnt,@nophatsinh as sops,@phatsinhcont as pscont,@phatsinhco as psco, null as makh, null as tenkh,2
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Closing amount'' else N''Số dư cuối kỳ'' end as diengiai,
null as tkdu,sopsnt=case when @nocock=0 then 0 else @cuoikynt end,sops=case when @nocock=0 then 0 else @cuoiky end,
pscont=case when @nocock=0 then abs(@cuoikynt) else 0 end, psco=case when @nocock=0 then abs(@cuoiky) else 0 end, null as makh, null as tenkh, 3
order by stt,ngayCt, soct, tkdu'
where ReportName = @reportName

-- Nhật ký chứng từ số 02
set @reportName = N'Nhật ký chứng từ số 02'
Update sysReport set Query = N'DECLARE @TK nvarchar(512)
DECLARE @TKDu nvarchar(512)
DECLARE @LoaiTK nvarchar(512)
declare @tungay datetime
declare @denngay datetime
DECLARE @MaxRecord int
declare @Tongpsno decimal(28,6)
declare @Tongpsco decimal(28,6)

set @tungay = @@ngayct1
set @denngay = dateadd(hh,23,@@ngayct2)

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#NKCT'') AND type in (N''U''))
BEGIN
CREATE TABLE #NKCT(
    ThuTu int,
    BLTKID int,
    SoCT nvarchar(512) NULL,
    NgayCT smalldatetime NULL,
	DienGiai nvarchar(512) COLLATE database_default NULL,
	TKNo varchar(16) COLLATE database_default NULL,
	TKCo varchar(16) COLLATE database_default NULL,
	Psno decimal(28, 6) NULL, --Hiện theo hàng ngang
	Psco decimal(28, 6) NULL, --Hiện theo cột
	TK nvarchar(512) COLLATE database_default NULL,
	TKDu nvarchar(512) COLLATE database_default NULL,
	LoaiTK nvarchar(512) COLLATE database_default NULL
     )
END
--Lấy dữ liệu phát sinh
INSERT INTO #NKCT ( ThuTu, BLTKID, NgayCT, SoCT, DienGiai, TKNo, TKCo, Psno, Psco, TK,TKDu, LoaiTK )
   select ROW_NUMBER() OVER(ORDER BY ngayct,soct) ,
     BLTKID, 
     NgayCT, 
     SoCT, 
     diengiai, 
     [Tài khoản đối ứng Nợ] = case when psco>0 then TkDu else '''' end, 
     [Tài khoản đối ứng Có] = case when psno>0 then TkDu else '''' end,
     psno + psco,
     psno + psco,
     TK, 
	 TKDu,
     LoaiTK
   From wNKSC c where psno+psco>0 and (NgayCt between @tungay and @denngay) and @@ps
   and TKDu = (select TkDu from wNKSC w where psno>0 and c.BLTKID = w.BLTKID and TKdu like N''11%'')
   Order by ngayct,soct
       
Select @MaxRecord = count (BLTKID)  FROM #NKCT 
 where Psno + Psco > 0 and NgayCt between @tungay and @denngay and @@ps

DECLARE nkct_cursor CURSOR FOR
SELECT DISTINCT TK,TKDu FROM #NKCT
WHERE Psno + Psco > 0 and (NgayCt between @tungay and @denngay) and @@ps

OPEN nkct_cursor

fetch nkct_cursor into @TK,@TKDu

WHILE @@FETCH_STATUS = 0
BEGIN
    
--Lấy Dòng tổng cộng
/*execute Sopstaikhoan @tk,@tungay,@denngay,''@@ps'',@Tongpsno output,@Tongpsco output
 IF (@Tongpsno > 0)
  Set @LoaiTK = N''Nợ''
 Else
  Set @LoaiTK = N''Có''
INSERT INTO #NKCT ( ThuTu, BLTKID, NgayCT, SoCT, DienGiai, TKNo, TKCo, Psno, Psco, TK,TKDu, LoaiTK )
 Values (@MaxRecord+1,NULL,NULL,NULL,case when @@lang = 1 then N''Total'' else N''Tổng cộng'' end,@TK ,@TKDu,@Tongpsno,NULL,@TK,@TKDu,@LoaiTK)
*/
fetch nkct_cursor into @TK,@TKDu

END

CLOSE nkct_cursor
DEALLOCATE nkct_cursor

select ThuTu,SUBSTRING(TKCo, 1, 3) as TKDU, BLTKID, ngayct as [Ngày tháng CT], SoCT as [Số hiệu CT], DienGiai as [Diễn giải],[TKCo],
(select case when @@lang = 1 then dm.TenTK2  else dm.TenTK end from dmtk dm where dm.tk = SUBSTRING(TKCo, 1, 3)) as [Tên TK],
[Psno] as [Số tiền],TK from #NKCT
Where LoaiTK like N''%Nợ%'' and (TKCo like N''11%'' or tkco is null) 
order by ThuTu,ngayct,soct

drop table #NKCT'
where ReportName = @reportName

-- Tình hình thực hiện nghĩa vụ nộp thuế
set @reportName = N'Tình hình thực hiện nghĩa vụ nộp thuế'
Update sysReport set Query = N'declare @ngayct datetime
declare @ngayCt1 datetime
declare @sql nvarchar (4000)
declare @gradeTK1 int
declare @gradeTK2 int

set @ngayct=@@Ngayct1
set @ngayCt1=@@Ngayct2

create table #NghiaVuNT
 ( [STT] int null,
 [ChiTieu] nvarchar(128) NULL,
 [ChiTieu2] nvarchar(128) NULL,
 [MaSo] varchar(50),
 [TaiKhoan] varchar(16) COLLATE database_default NULL,
 [DauKy] [decimal](28, 6) NULL,
 [PhaiNop] [decimal](28, 6) NULL,
 [DaNop] [decimal](28, 6) NULL,
 [CuoiKy] [decimal](28, 6) NULL
 ) 
-- Insert các dòng cố định vào trong bảng tạm
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''0'',N''I – Thuế'',N''I – Tax'', ''01'', NULL, NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''1'',N''1. Thuế GTGT hàng bán nội địa'',N''1. VAT to domestic sales'', ''02'', ''33311'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''2'',N''2. Thuế GTGT hàng nhập khẩu'',N''2. Imported VAT'', ''03'', ''33312'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''3'',N''3. Thuế tiêu thụ đặc biệt'',N''3. Excise tax'', ''04'', ''3332'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''4'',N''4. Thuế xuất, nhập khẩu'', N''4. Export and import'',''05'', ''3333'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''5'',N''5. Thuế thu nhập doanh nghiệp'',N''5. Corporate Income Tax'', ''06'', ''3334'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''6'',N''6. Thuế thu nhập cá nhân'',N''6. Personal Income Tax'', ''07'', ''3335'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''7'',N''7. Thuế tài nguyên'', N''7. Royalties'',''08'', ''3336'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''8'',N''8. Thuế nhà đất, tiền thuê đất'',N''8. Land tax, land rent'', ''09'', ''3337'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''9'',N''9. Các loại thuế khác'', N''9. Other taxes'',''10'', ''3338'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''10'',N''II – Các khoản phải nộp khác'',N''II – The other payables'', ''20'', NULL, NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''11'',N''1. Các khoản phụ thu'', N''1. The surcharge'',''21'', NULL, NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''12'',N''2. Các khoản phí, lệ phí'',N''2. The fees and charges'', ''22'', NULL, NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''13'',N''3. Các khoản khác'',N''3. Other sources'', ''23'', ''3339'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''14'',N''Tổng cộng'',N''Total'', ''30'', '''', NULL, NULL, NULL, NULL)

--Truy vấn số liệu đầu kỳ, phát sinh trong kỳ và tính số cuối kỳ từ bảng OBTK, OBKH
--Tài khoản công nợ
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
--tài khoản thường
set @sql=''create view wthuong as 
select tk,0.0 as nodau, 0.0 as codau,sum(psno) as psno,sum(psco) as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt between cast('''''' + convert(nvarchar,@ngayCt) + '''''' as datetime) and  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) group by tk
union all
select tk,0.0 as nodau, 0.0 as codau,0.0 as psno,0.0 as psco, sum(psno) as lkno, sum(psco) as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt  <=  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) and year(ngayct) = year(cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime)) group by tk
union all
select tk, sum(duno) as nodau,sum(duco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi  from obtk where tk in(select tk from dmtk where tkcongno<>1) group by tk, MaNT
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
 @tnock = sum([Nợ cuối]), @tcock = sum([Có cuối]) from wthuong2 where tk like ''333%''
select @cnodk= sum([Nợ đầu]), @ccodk = sum([Có đầu]),
 @cpsno = sum(psno), @cpsco = sum(psco),
 @clkno = sum([Lũy kế nợ]), @clkco = sum([Lũy kế có]),
 @cnock = sum([Nợ cuối]), @ccock = sum([Có cuối]) from wcongno3 where tk like ''333%''
Select N.Stt, case when @@lang = 1 then N.ChiTieu2 else N.ChiTieu end as [Chỉ tiêu], N.MaSo as [Mã số], N.TaiKhoan as [Tài khoản], K.[Có đầu]-K.[Nợ đầu] as [Đầu kỳ], K.[PsCo] as [Số phải nộp],K.[PsNo] as [Số đã nộp],K.[Lũy kế có] as [Phải nộp lũy kế],K.[Lũy kế nợ] as [Đã nộp lũy kế],K.[Có đầu]-K.[Nợ đầu]+K.[PsCo]-K.[PsNo] as [Cuối kỳ] from 
(select a.Tk, case when 0 = 1 then b.tentk2 else b.tentk end as tentk,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wcongno3 a inner join dmtk b on a.tk = b.tk
union all
select a.Tk, case when 0 = 1 then b.tentk2 else b.tentk end as tentk,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wthuong2  a  inner join dmtk b on a.tk = b.tk
union all
select '''' as Tk,case when 0 = 1 then N''Total'' else N''Tổng cộng'' end as tentk, isnull(@tnodk,0) + isnull(@cnodk,0) as nodau, isnull(@tcodk,0) + isnull(@ccodk,0) as codau, isnull(@tpsno,0) + isnull(@cpsno,0) as psno, isnull(@tpsco,0) + isnull(@cpsco,0) as psco, isnull(@tlkno,0) + isnull(@clkno,0) as lkno, isnull(@tlkco,0) + isnull(@clkco,0) as lkco, isnull(@tnock,0) + isnull(@cnock,0) as nocuoi, isnull(@tcock,0) + isnull(@ccock,0) as cocuoi
) as K right join  #NghiaVuNT as N on K.Tk=N.Taikhoan

drop view wcongno
drop view wcongno1
drop view wcongno2
drop view wcongno3
drop view wthuong
drop view wthuong1
drop view wthuong2
drop table #NghiaVuNT'
where ReportName = @reportName