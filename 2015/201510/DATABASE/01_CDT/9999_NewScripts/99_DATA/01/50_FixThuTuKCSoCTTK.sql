Use CDT

-- Sửa thứ tự bút toán kết chuyển sao cho nằm dưới cùng
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
	order by Stt,Ngayct,[Tài khoản nhóm] desc
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
		order by Stt,Ngayct,[Tài khoản nhóm] desc
		
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