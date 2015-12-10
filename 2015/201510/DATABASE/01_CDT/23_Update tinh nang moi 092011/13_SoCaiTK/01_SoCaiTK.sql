use [CDT]

declare @sysReportID int,
		@sysFieldID int,
		@sysSiteIDPRO int,
		@sysSiteIDSTD int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = 'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = 'STD'

-- 1) Update menu name
-- PRO
Update sysMenu set MenuName = N'Sổ cái'
where MenuName = N'Sổ cái CTGS'
and sysSiteID = @sysSiteIDPRO

-- STD
Update sysMenu set MenuName = N'Sổ cái'
where MenuName = N'Sổ cái CTGS'
and sysSiteID = @sysSiteIDSTD

select @sysReportID = sysReportID from sysReport where ReportName = N'Sổ cái CTGS' and sysPackageID = 8

-- 2) Set Allow null for TK
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TK'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

Update sysReportFilter set AllowNull = 1, FilterCond = N'TKMe is null'
where sysFieldID = @sysFieldID and sysReportID = @sysReportID and AllowNull = 0 and FilterCond is null 

-- 3) Add SoHieuCTGS condition
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'SoHieu'
				and sysTableID = (select sysTableID from sysTable where TableName = 'wFilterControl')
				
if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 4, 1, 0, 1, NULL)

-- 4) Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportName = N'Hình thức chứng từ ghi sổ')
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Hình thức chứng từ ghi sổ', N'SCCTGS', N'Recording Vouchers', NULL)

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportName = N'Hình thức nhật ký chung')
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Hình thức nhật ký chung', N'SC_HT_NKC', N'Common Diaries', NULL)

if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID and ReportName = N'Mẫu quản trị')
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Mẫu quản trị', N'SC_HT_ADMIN', N'Administrative', NULL)

-- 5) Report query
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
	[psno] decimal(20,6) null,
	[psco] decimal(20,6) null,
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
deallocate cur_tk'
where sysReportID = @sysReportID