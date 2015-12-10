USE [CDT]

-- [CRM:TT9688]: Sửa lại thứ tự sắp xếp dòng thuế và dòng nghiệp vụ

-- 1) Sổ cái CTGS
Update sysReport
set Query = N'declare @nodauky decimal(28,6)
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
	[TK] varchar(16) null,
	MTID uniqueidentifier
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
	
	set @sql = N''Select mact, dbo.LayNgayGhiSo(NgayCT) as [Ngày ghi sổ], SoCt, NgayCT, DienGiai, Tkdu, PsNo, Psco, '''''''' as Ghichu,1,''''''+ @TKNhom + '''''',N'''''' + @TenTKNhom + '''''', tk, MTID ''
	set @sql = @sql + N'' from bltk where left(tk,len(''''''+ @TKNhom + '''''')) = '''''' + @TKNhom + '''''' and  (NgayCt between convert(datetime,''''''+ convert(nvarchar,@tungay) + '''''') and convert(datetime,'''''' + convert(nvarchar,@denngay) + '''''')) and '' + @FilterCondition + '' Order by NgayCT,MTID, NhomDK''
	
	insert into #resultTemp([MaCT],[NgayGhiSo],[soct],[NgayCT],[diengiai],[tkdu],[psno],[psco],[GhiChu],[Stt],[TKNhom],[TenTKNhom],[TK],MTID)
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
where ReportName = N'Sổ cái CTGS'