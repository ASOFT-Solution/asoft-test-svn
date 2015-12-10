Use CDT

-- Sửa điều kiện đến ngày do lấy lên sai tổng cộng số phát sinh
Update sysReport set Query = N'declare @tk varchar(16)
declare @codauky float
declare @nodauky float

declare @cocuoiky float
declare @nocuoiky float

declare @tungay datetime
declare @denngay datetime 
--declare @datetemp datetime
declare @ngaydk datetime
declare @dauky float
declare @cuoiky float

declare @Tongpsno float
declare @Tongpsco float

declare @dif float

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
where ReportName = N'Tổng hợp chữ T 1 tài khoản'