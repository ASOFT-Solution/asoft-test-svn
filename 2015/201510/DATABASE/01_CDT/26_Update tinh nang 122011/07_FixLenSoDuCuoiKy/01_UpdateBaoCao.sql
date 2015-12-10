use [CDT]

-- Sổ cái CTGS
Update sysReport set Query = N'declare @nodauky float
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

declare @dif float


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

select distinct * from #resultTemp
order by TKNhom, stt, ngayct, soct

IF OBJECT_ID(''tempdb..#psTemp'') IS NOT NULL
BEGIN
	DROP TABLE #psTemp
END

close cur_tk
deallocate cur_tk'
where ReportName = N'Sổ cái CTGS'

-- Sổ chi tiết tài khoản
Update sysReport set Query = N'declare @tkrp varchar(16) -- Tài khoản lọc
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

declare @dif float

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
		if @nodk > 0 And @codk > 0
		BEGIN
			set @dif = @nodk - @codk
			if @dif > 0 
			BEGIN
				set @nodk = @dif
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
		if @nodk > 0
		BEGIN
			set @nock = @nodk + @nophatsinh - @phatsinhco
			set @cock = 0
			
			if @nock < 0 
			BEGIN
				set @cock = abs(@nock)
				set @nock = 0
			END
		END
		
		if @codk > 0
		BEGIN
			set @cock = @codk + @phatsinhco - @nophatsinh
			set @nock = 0
			
			if @cock < 0 
			BEGIN
				set @nock = abs(@cock)
				set @cock = 0
			END
		END

		if isnull(@nodk,0) = 0 And isnull(@codk,0) = 0
		BEGIN
			set @cock = 0
			set @nock = isnull(@nophatsinh,0) - isnull(@phatsinhco,0)
			
			if @nock < 0 
			BEGIN
				set @cock = abs(@nock)
				set @nock = 0
			END
		END
	END
	
	if @tkrp like ''3%'' or @tkrp like ''4%''
	BEGIN
		if @nodk > 0
		BEGIN
			set @nock = @nodk + @nophatsinh - @phatsinhco
			set @cock = 0
			
			if @nock < 0 
			BEGIN
				set @cock = abs(@nock)
				set @nock = 0
			END	
		END
		
		if @codk > 0
		BEGIN
			set @cock = @codk + @phatsinhco - @nophatsinh
			set @nock = 0
			
			if @cock < 0 
			BEGIN
				set @nock = abs(@cock)
				set @cock = 0
			END	
		END

		if isnull(@nodk,0) = 0 And isnull(@codk,0) = 0
		BEGIN
			set @cock = 0
			set @nock = @nophatsinh - @phatsinhco
			
			if @nock < 0 
			BEGIN
				set @cock = abs(@nock)
				set @nock = 0
			END	
		END
	END
	
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
		
		-- Lấy lại số dư đầu kỳ
		if @tkrp like ''1%'' or @tkrp like ''2%'' or @tkrp like ''3%'' or @tkrp like ''4%''
		BEGIN
			if @nodk > 0 And @codk > 0
			BEGIN
				set @dif = @nodk - @codk
				if @dif > 0 
				BEGIN
					set @nodk = @dif
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
			if @nodk > 0
			BEGIN
				set @nock = @nodk + @nophatsinh - @phatsinhco
				set @cock = 0
				
				if @nock < 0 
				BEGIN
					set @cock = abs(@nock)
					set @nock = 0
				END
			END
			
			if @codk > 0
			BEGIN
				set @cock = @codk + @phatsinhco - @nophatsinh
				set @nock = 0
				
				if @cock < 0 
				BEGIN
					set @nock = abs(@cock)
					set @cock = 0
				END
			END

			if isnull(@nodk,0) = 0 And isnull(@codk,0) = 0
			BEGIN
				set @cock = 0
				set @nock = isnull(@nophatsinh,0) - isnull(@phatsinhco,0)
				
				if @nock < 0 
				BEGIN
					set @cock = abs(@nock)
					set @nock = 0
				END
			END
		END
		
		if @TKNhom like ''3%'' or @TKNhom like ''4%''
		BEGIN
			if @nodk > 0
			BEGIN
				set @nock = @nodk + @nophatsinh - @phatsinhco
				set @cock = 0
				
				if @nock < 0 
				BEGIN
					set @cock = abs(@nock)
					set @nock = 0
				END	
			END
			
			if @codk > 0
			BEGIN
				set @cock = @codk + @phatsinhco - @nophatsinh
				set @nock = 0
				
				if @cock < 0 
				BEGIN
					set @nock = abs(@cock)
					set @cock = 0
				END	
			END

			if isnull(@nodk,0) = 0 And isnull(@codk,0) = 0
			BEGIN
				set @cock = 0
				set @nock = @nophatsinh - @phatsinhco
				
				if @nock < 0 
				BEGIN
					set @cock = abs(@nock)
					set @nock = 0
				END	
			END
		END
		
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
END'
where ReportName = N'Sổ chi tiết tài khoản'

-- Tổng hợp chữ T 1 tài khoản
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

declare @Tongpsno float
declare @Tongpsco float

declare @dif float

set @tungay = @@ngayct1
set @denngay = dateadd(hh,23,@@ngayct2)

set @datetemp = dateadd(hh,1,@denngay)
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
where ReportName = N'Tổng hợp chữ T 1 tài khoản'