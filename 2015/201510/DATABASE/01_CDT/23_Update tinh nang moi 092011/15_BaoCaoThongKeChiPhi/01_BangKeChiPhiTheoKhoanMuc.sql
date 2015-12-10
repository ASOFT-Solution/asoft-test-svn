USE [CDT]

declare @sysTableID int,
		@sysSiteIDPRO int,
		@sysSiteIDSTD int,
		@sysMenuParent int, 
		@sysOtherReport int,
		@mtTableID int,
		@sysReportID int,
		@sysFieldID int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

select @mtTableID = sysTableID from sysTable
where TableName = 'BLTK' and sysPackageID = 8

if not exists (select top 1 1 from sysReport where ReportName = N'Bảng kê chi phí theo khoản mục' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Bảng kê chi phí theo khoản mục', 0, @mtTableID, NULL, N'declare @TK1 varchar(16)
declare @TK2 varchar(16)
declare @TKDU1 varchar(16)
declare @TKDU2 varchar(16)

declare @sql nvarchar(4000)

set @TK1 = @@TK1
set @TK2 = @@TK2
set @TKDU1 = @@TKDU1
set @TKDU2 = @@TKDU2

set @sql = N''
IF OBJECT_ID(''''tempdb..#t'''') IS NOT NULL
BEGIN
	DROP TABLE #t
END

IF OBJECT_ID(''''tempdb..#t2'''') IS NOT NULL
BEGIN
	DROP TABLE #t2
END

select distinct b.mact ,b.SOCT , b.NGAYCT ,b.diengiai, b.MAKH ,b.tenkh ,
b.MAPHI,ph.tenphi , b.mant, b.tygia ,
b.MABP,bp.tenbp ,  b.TK as [Tài khoản nợ], b.TKDU as [Tài khoản có], b.PSNO as [Thành tiền], psnont as [Thành tiền NT] , MTID, MTIDDT
into #t
from bltk  b left join dmphi ph on b.maphi=ph.maphi left join dmbophan bp on b.mabp=bp.mabp 
where mact in (''''PC'''', ''''PBN'''',  ''''MDV'''', ''''PNK'''', ''''PXT'''', ''''MCP'''', ''''PTT'''', ''''PNH'''', ''''PKT'''', ''''PNM'''')AND PSNO<>0
and MTIDDT is not null

select distinct b.mact ,b.SOCT , b.NGAYCT ,b.diengiai, b.MAKH ,b.tenkh ,
t.MAPHI,ph.tenphi , b.mant, b.tygia ,
t.MABP,bp.tenbp ,  b.TK as [Tài khoản nợ], b.TKDU as [Tài khoản có] , vat.Thue as [Thành tiền], vat.ThueNT as [Thành tiền NT], b.MTID, t.MTIDDT
into #t2
from (bltk  b inner join #t t on b.MTID = t.MTID) left join vatin vat on t.MTIDDT = vat.MTIDDT left join dmphi ph on t.maphi=ph.maphi left join dmbophan bp on t.mabp=bp.mabp
where b.mact in (''''PC'''', ''''PBN'''',  ''''MDV'''', ''''PNK'''', ''''PXT'''', ''''MCP'''', ''''PTT'''', ''''PNH'''', ''''PKT'''', ''''PNM'''')AND b.PSNO<>0
and b.MTIDDT is null

select * from (
select mact , SOCT , NGAYCT , diengiai, MAKH ,tenkh ,
MAPHI, tenphi , mant, tygia ,
MABP, tenbp ,  [Tài khoản nợ], [Tài khoản có], [Thành tiền], [Thành tiền NT] 
from #t

union all 

select mact ,SOCT , NGAYCT ,diengiai, MAKH ,tenkh ,
MAPHI, tenphi , mant, tygia ,
MABP, tenbp ,  [Tài khoản nợ], [Tài khoản có], [Thành tiền], [Thành tiền NT] 
from #t2

union all
select distinct b.mact ,b.SOCT , b.NGAYCT ,b.diengiai, b.MAKH ,b.tenkh ,
b.MAPHI,ph.tenphi , b.mant , b.tygia ,
b.MABP,bp.tenbp ,  b.TK as [Tài khoản nợ], b.TKDU as [Tài khoản có], b.PSNO as [Thành tiền], psnont as [Thành tiền NT] 
from bltk  b left join dmphi ph on b.maphi=ph.maphi left join dmbophan bp on b.mabp=bp.mabp where mact = ''''PC2'''' AND PSNO<>0 and b.tkdu like ''''11%''''
union all
select distinct b.mact ,b.SOCT , b.NGAYCT ,b.diengiai, b.MAKH ,b.tenkh ,
b.MAPHI,ph.tenphi , b.mant , b.tygia ,
b.MABP,bp.tenbp ,  b.TK as [Tài khoản nợ], b.TKDU as [Tài khoản có], b.PSNO as [Thành tiền], psnont as [Thành tiền NT] 
from bltk  b left join dmphi ph on b.maphi=ph.maphi left join dmbophan bp on b.mabp=bp.mabp where mact = ''''BN2'''' AND PSNO<>0 and b.tkdu like ''''11%''''
) x
where x.ngayCt between cast('' + ''''@@ngayct1'''' + '' as datetime) and cast('' + ''''@@ngayct2'''' + '' as datetime) and '' + @@ps

if @TK1 <> '''' and @TK2 = ''''
	set @sql = @sql + N'' and left(x.[Tài khoản nợ], '' + convert(varchar(16), len(@TK1)) + '') >= '''''' + @TK1 + ''''''''
else if @TK2 <> '''' and @TK1 = ''''
	set @sql = @sql + N'' and left(x.[Tài khoản nợ], '' + convert(varchar(16), len(@TK2)) + '') <= '''''' + @TK2 + ''''''''
else if @TK1 <> '''' and @TK2 <> ''''
	set @sql = @sql + N'' and left(x.[Tài khoản nợ], '' + convert(varchar(16), len(@TK1)) + '') >= '''''' + @TK1 + ''''''''
					+ N'' and left(x.[Tài khoản nợ], '' + convert(varchar(16), len(@TK2)) + '') <= '''''' + @TK2 + ''''''''

if @TKDU1 <> '''' and @TKDU2 = ''''
	set @sql = @sql + N'' and left(x.[Tài khoản có], '' + convert(varchar(16), len(@TKDU1)) + '') >= '''''' + @TKDU1 + ''''''''
else if @TKDU2 <> '''' and @TKDU1 = ''''
	set @sql = @sql + N'' and left(x.[Tài khoản có], '' + convert(varchar(16), len(@TKDU2)) + '') <= '''''' + @TKDU2 + ''''''''
else if @TKDU1 <> '''' and @TKDU2 <> ''''
	set @sql = @sql + N'' and left(x.[Tài khoản có], '' + convert(varchar(16), len(@TKDU1)) + '') >= '''''' + @TKDU1 + ''''''''
					+ N'' and left(x.[Tài khoản có], '' + convert(varchar(16), len(@TKDU2)) + '') <= '''''' + @TKDU2 + ''''''''
	
set @sql = @sql + '' order by SoCT, ngayCT 
drop table #t
drop table #t2''

exec(@sql)
', N'BKCP_KM', N'List the item cost', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, N'x', null, NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Bảng kê chi phí theo khoản mục' and sysPackageID = 8

-- Step 2: Tham số báo cáo
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'NgayCT'
				and sysTableID = @mtTableID

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 1, 0, 1, 1, 1, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaPhi'
				and sysTableID = (select sysTableID from sysTable where tableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 1, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaBP'
				and sysTableID = (select sysTableID from sysTable where tableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 2, 1, 1, 0, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TK'
				and sysTableID = (select sysTableID from sysTable where tableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 3, 1, 1, 1, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TKDU'
				and sysTableID = (select sysTableID from sysTable where tableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 1, 4, 1, 1, 1, NULL)

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'MaNT'
				and sysTableID = (select sysTableID from sysTable where tableName = 'BLTK')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 1, NULL, @sysReportID, 0, 5, 1, 1, 0, NULL)

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Bảng kê chi phí theo khoản mục', N'BKCP_KM', N'List the item cost', NULL)

-- Step 4: Tạo menu
-- PRO
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Tổng hợp' and sysSiteID = @sysSiteIDPRO and sysMenuParent is null

if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo khác' and [sysSiteID] = @sysSiteIDPRO and [sysMenuParent] = @sysMenuParent)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo khác', N'Other reports', @sysSiteIDPRO, NULL, NULL, NULL, 15, NULL, @sysMenuParent, NULL, NULL, 5, NULL)

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo khác' and sysSiteID = @sysSiteIDPRO and sysMenuParent = @sysMenuParent

if not exists (select top 1 1 from sysMenu where MenuName = N'Bảng kê chi phí theo khoản mục' and [sysSiteID] = @sysSiteIDPRO and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Bảng kê chi phí theo khoản mục', N'List the item cost', @sysSiteIDPRO, NULL, NULL, @sysReportID, 0, NULL, @sysOtherReport, NULL, NULL, 5, NULL)

END

-- STD
if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Tổng hợp' and sysSiteID = @sysSiteIDSTD and sysMenuParent is null

if not exists (select top 1 1 from sysMenu where MenuName = N'Báo cáo khác' and [sysSiteID] = @sysSiteIDSTD and [sysMenuParent] = @sysMenuParent)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Báo cáo khác', N'Other reports', @sysSiteIDSTD, NULL, NULL, NULL, 15, NULL, @sysMenuParent, NULL, NULL, 5, NULL)

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo khác' and sysSiteID = @sysSiteIDSTD and sysMenuParent = @sysMenuParent

if not exists (select top 1 1 from sysMenu where MenuName = N'Bảng kê chi phí theo khoản mục' and [sysSiteID] = @sysSiteIDSTD and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Bảng kê chi phí theo khoản mục', N'List the item cost', @sysSiteIDSTD, NULL, NULL, @sysReportID, 0, NULL, @sysOtherReport, NULL, NULL, 5, NULL)

END