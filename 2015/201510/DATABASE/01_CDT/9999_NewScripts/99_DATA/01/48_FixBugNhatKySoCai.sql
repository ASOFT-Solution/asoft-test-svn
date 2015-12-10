Use CDT
Update sysReport set RpType = 0,LinkField = NULL, Query = N'--Dòng tổng cộng
DECLARE @TK nvarchar(512)
DECLARE @LoaiTK nvarchar(512)
DECLARE @MaxRecord int

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
where ReportName = N'Nhật ký - sổ cái'

---Update filter
declare @sysReportID int,
		@sysFieldID int

select @sysReportID = sysReportID from sysReport
where ReportName = N'Nhật ký - sổ cái'

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'NgayCT'
				and sysTableID = (select sysTableID from sysTable where TableName = 'wNKSC')
				
Update [sysReportFilter] set SpecialCond = 1
where [sysFieldID] = @sysFieldID and sysReportID = @sysReportID

--Insert format string
if not exists (select top 1 1 from sysFormatString where _Key = 'Tien' and Fieldname=N'Số tiền phát sinh') 
 insert into sysFormatString(_Key, Fieldname) Values ('Tien',N'Số tiền phát sinh')
 
 if not exists (select top 1 1 from sysFormatString where _Key = 'Tien' and Fieldname=N'Số tiền') 
 insert into sysFormatString(_Key, Fieldname) Values ('Tien',N'Số tiền')
 ---Ngôn ngữ
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Ngày tháng CT')
		INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
		VALUES (N'Ngày tháng CT', N'Date')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Số hiệu CT')
		INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
		VALUES (N'Số hiệu CT', N'Code')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Thứ tự dòng')
		INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
		VALUES (N'Thứ tự dòng', N'No.')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Thứ tự dòng')
		INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
		VALUES (N'Thứ tự dòng', N'No.')				
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tài khoản đối ứng Nợ')
		INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
		VALUES (N'Tài khoản đối ứng Nợ', N'Debit')				
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tài khoản đối ứng Có')
		INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
		VALUES (N'Tài khoản đối ứng Có', N'Credit')			