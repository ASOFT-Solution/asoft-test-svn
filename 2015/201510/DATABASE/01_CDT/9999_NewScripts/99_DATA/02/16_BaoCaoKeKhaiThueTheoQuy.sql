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
		
-- Update Bảng kê chứng từ thuế GTGT mua vào -> Bảng kê chứng từ thuế GTGT mua vào (Theo tháng)
Update sysMenu set MenuName = N'Bảng kê chứng từ thuế GTGT mua vào (Theo tháng)', MenuName2 = N'VAT input voucher report (By period)'
where MenuName = N'Bảng kê chứng từ thuế GTGT mua vào'
and not exists (select sysMenuID from sysMenu where MenuName = N'Bảng kê chứng từ thuế GTGT mua vào (Theo tháng)')

Update sysReport set ReportName = N'Bảng kê thuế GTGT mua vào (Theo tháng)', ReportName2 = N'Sheet of in VAT tax (By period)'
where ReportName = N'Bảng kê thuế GTGT mua vào'
and not exists (select sysReportID from sysReport where ReportName = N'Bảng kê thuế GTGT mua vào (Theo tháng)')

-- Update Bảng kê chứng từ thuế GTGT bán ra -> Bảng kê chứng từ thuế GTGT bán ra (Theo tháng)
Update sysMenu set MenuName = N'Bảng kê chứng từ thuế GTGT bán ra (Theo tháng)', MenuName2 = N'VAT output voucher report (By period)'
where MenuName = N'Bảng kê chứng từ thuế GTGT bán ra'
and not exists (select sysMenuID from sysMenu where MenuName = N'Bảng kê chứng từ thuế GTGT bán ra (Theo tháng)')

Update sysReport set ReportName = N'Bảng kê thuế GTGT bán ra (Theo tháng)', ReportName2 = N'Sheet of out VAT tax (By period)'
where ReportName = N'Bảng kê thuế GTGT bán ra'
and not exists (select sysReportID from sysReport where ReportName = N'Bảng kê thuế GTGT bán ra (Theo tháng)')

-- Update Tờ khai thuế GTGT -> Tờ khai thuế GTGT (Theo tháng)
Update sysMenu set MenuName = N'Tờ khai thuế GTGT (Theo tháng)', MenuName2 = N'VAT Return (By period)'
where MenuName = N'Tờ khai thuế GTGT'
and not exists (select sysMenuID from sysMenu where MenuName = N'Tờ khai thuế GTGT (Theo tháng)')

Update sysReport set ReportName = N'Tờ khai thuế GTGT (Theo tháng)', ReportName2 = N'VAT Return (By period)'
where ReportName = N'Tờ khai thuế GTGT'
and not exists (select sysReportID from sysReport where ReportName = N'Tờ khai thuế GTGT (Theo tháng)')

-- Thêm 3 báo cáo mới theo quý
-- 1) =============================== Bảng kê thuế GTGT mua vào (Theo quý) ===============================
select @mtTableID = sysTableID from sysTable
where TableName = 'MVATIn' and sysPackageID = 8

if not exists (select top 1 1 from sysReport where ReportName = N'Bảng kê thuế GTGT mua vào (Theo quý)' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Bảng kê thuế GTGT mua vào (Theo quý)', 0, @mtTableID, NULL, N'', 
N'GTGTTHMVAOTT28_Q', N'VAT input voucher report (By quarter)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, null, NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Bảng kê thuế GTGT mua vào (Theo quý)' and sysPackageID = 8

Update sysReport
set Query = N'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATInTemp'') AND type in (N''U''))
BEGIN
create table #VATInTemp
 (
	[NgayCt] smalldatetime NULL,
	[NgayHd] smalldatetime NULL,
	[SoSeries] nvarchar(128) COLLATE database_default NULL,
	[Sohoadon] nvarchar(128) COLLATE database_default NULL,
	[TenKH] nvarchar(128) COLLATE database_default NULL,
	[MST] nvarchar(128) COLLATE database_default NULL,
	[DienGiai] nvarchar(128) COLLATE database_default NULL,
	[TTien] decimal(28,6) NULL, 
	[ThueSuat] decimal(28,6) NULL,
	[Thue] decimal(28,6) NULL,
	[GhiChu] nvarchar(128) COLLATE database_default NULL,
	[MaLoaiThue] int NULL, 
	[QuyBKMV] int NULL, 
	[NamBKMV] int NULL,
	[NgayBKMV] smalldatetime NULL
)
END

delete from #VATInTemp

declare @maLoaiThue int,
		@quy as int,
		@ngayBKMV as smalldatetime

Select @quy = mst.QuyBKMV, @ngayBKMV = mst.NgayBKMV
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
INSERT INTO #VATInTemp ([NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaLoaiThue],[QuyBKMV],[NamBKMV], [NgayBKMV]) 
VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @maLoaiThue, @quy, @@NAM, @ngayBKMV)

fetch next from cur_LThue into @maLoaiThue

END

close cur_LThue
deallocate cur_LThue

Select dt.NgayCt as [Ngày HT VAT], dt.NgayHd, dt.SoSeries, dt.Sohoadon, dt.TenKH, dt.MST, dt.DienGiai as [Tên mặt hàng], Sum(dt.TTien) TTien, dt.ThueSuat as ThueSuat,
Sum(dt.Thue) Thue, dt.GhiChu as GhiChu, dt.MaLoaiThue as [Loại thuế], mst.QuyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.MaThue
 from MVATIn mst inner join DVATIn dt on mst.MVATInID = dt.MVATInID
 where @@ps and mst.NamBKMV = @@NAM
 group by dt.ngayhd, dt.MaLoaiThue, dt.Sohoadon, dt.soseries, dt.ngayct, dt.TenKH, dt.MST, dt.DienGiai, dt.MaThue, dt.ThueSuat, mst.QuyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.GhiChu
union
Select [NgayCt] as [Ngày HT VAT],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien], [ThueSuat],[Thue],[GhiChu],[MaLoaiThue],[QuyBKMV],[NamBKMV], [NgayBKMV], NULL
from #VATInTemp
order by MaLoaiThue, Ngayhd, Sohoadon
 
drop table #VATInTemp'
where sysReportID = @sysReportID


-- Step 2: Tham số báo cáo
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'QuyBKMV'
AND sysTableID = (select sysTableID from sysTable where TableName = 'MVATIn')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 0, 0, 1, 1, 0, NULL)

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Bảng kê thuế GTGT mua vào (Theo quý)', N'GTGTTHMVAOTT28_Q', N'VAT input voucher report (By quarter)', NULL)

-- Step 4: Tạo menu
-- PRO
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Thuế GTGT' and sysSiteID = @sysSiteIDPRO and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDPRO and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN

if not exists (select top 1 1 from sysMenu where MenuName = N'Bảng kê chứng từ thuế GTGT mua vào (Theo quý)' and [sysSiteID] = @sysSiteIDPRO and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Bảng kê chứng từ thuế GTGT mua vào (Theo quý)', N'VAT input voucher report (By quarter)', @sysSiteIDPRO, NULL, NULL, @sysReportID, 16, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- STD
if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Thuế GTGT' and sysSiteID = @sysSiteIDSTD and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDSTD and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN

if not exists (select top 1 1 from sysMenu where MenuName = N'Bảng kê chứng từ thuế GTGT mua vào (Theo quý)' and [sysSiteID] = @sysSiteIDSTD and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Bảng kê chứng từ thuế GTGT mua vào (Theo quý)', N'VAT input voucher report (By quarter)', @sysSiteIDSTD, NULL, NULL, @sysReportID, 16, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- 2) =============================== Bảng kê thuế GTGT bán ra (Theo quý) ===============================
select @mtTableID = sysTableID from sysTable
where TableName = 'MVATOut' and sysPackageID = 8

if not exists (select top 1 1 from sysReport where ReportName = N'Bảng kê thuế GTGT bán ra (Theo quý)' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Bảng kê thuế GTGT bán ra (Theo quý)', 0, @mtTableID, NULL, N'', 
N'GTGTTHBRATT28_Q', N'VAT output voucher report (By quarter)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, NULL, null, NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Bảng kê thuế GTGT bán ra (Theo quý)' and sysPackageID = 8

Update sysReport
set Query = N'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATOutTemp'') AND type in (N''U''))
BEGIN
create table #VATOutTemp
 (
	[Stt] int NULL,
	[NgayCt] smalldatetime NULL,
	[NgayHd] smalldatetime NULL,
	[SoSeries] nvarchar(128) COLLATE database_default NULL,
	[Sohoadon] nvarchar(128) COLLATE database_default NULL,
	[TenKH] nvarchar(128) COLLATE database_default NULL,
	[MST] nvarchar(128) COLLATE database_default NULL,
	[DienGiai] nvarchar(128) COLLATE database_default NULL,
	[TTien] decimal(28,6) NULL, 
	[ThueSuat] decimal(28,6) NULL,
	[Thue] decimal(28,6) NULL,
	[GhiChu] nvarchar(128) COLLATE database_default NULL,
	[MaThue] varchar(16) COLLATE database_default NULL,
	[QuyBKBR] int NULL, 
	[NamBKBR] int NULL,
	[NgayBKBR] smalldatetime NULL
)
END

delete from #VATOutTemp

declare @quy as int,
		@ngayBKBR as smalldatetime

Select @quy = mst.QuyBKBR, @ngayBKBR = mst.NgayBKBR
 from MVATOut mst inner join DVATOut dt on mst.MVATOutID = dt.MVATOutID
 where @@ps and mst.NamBKBR = @@NAM

-- Insert cac dong trong vao bang DVATOut de len bao cao
if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''KT'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''KT'', @quy, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''00'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''00'', @quy, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''05'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''05'', @quy, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''10'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''10'', @quy, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''NHOM5'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''NHOM5'', @quy, @@NAM, @ngayBKBR)


Select dt.SoSeries, dt.Sohoadon, dt.NgayHd, dt.Tenkh,  dt.mst, dt.diengiai  as [Tên mặt hàng],  Sum(Ttien) as TTien, dt.ThueSuat/100 as ThueSuat,
Sum(dt.Thue) as Thue, dt.GhiChu as GhiChu, dt.MaThue, mst.QuyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt 
from MVATOut mst inner join DVATOut dt on mst.MVATOutID = dt.MVATOutID inner join DMThueSuat ts on dt.MaThue = ts.MaThue
 where @@ps and mst.NamBKBR = @@NAM
group by dt.Sohoadon, dt.Soseries, dt.NgayHd, dt.tenkh, dt.ghichu, dt.diengiai, dt.mst, dt.thuesuat, dt.MaThue, mst.QuyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt
union
Select [SoSeries], [Sohoadon], [NgayHd], [TenKH], [MST], [DienGiai],[TTien],[ThueSuat], [Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR], [Stt]
from #VATOutTemp
order by ts.Stt, Ngayhd, Sohoadon
 
drop table #VATOutTemp'
where sysReportID = @sysReportID


-- Step 2: Tham số báo cáo
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'QuyBKBR'
AND sysTableID = (select sysTableID from sysTable where TableName = 'MVATOut')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 0, 0, 1, 1, 0, NULL)

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Bảng kê thuế GTGT bán ra (Theo quý)', N'GTGTTHBRATT28_Q', N'VAT output voucher report (By quarter)', NULL)

-- Step 4: Tạo menu
-- PRO
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Thuế GTGT' and sysSiteID = @sysSiteIDPRO and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDPRO and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN

if not exists (select top 1 1 from sysMenu where MenuName = N'Bảng kê chứng từ thuế GTGT bán ra (Theo quý)' and [sysSiteID] = @sysSiteIDPRO and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Bảng kê chứng từ thuế GTGT bán ra (Theo quý)', N'VAT output voucher report (By quarter)', @sysSiteIDPRO, NULL, NULL, @sysReportID, 17, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- STD
if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Thuế GTGT' and sysSiteID = @sysSiteIDSTD and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDSTD and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN

if not exists (select top 1 1 from sysMenu where MenuName = N'Bảng kê chứng từ thuế GTGT bán ra (Theo quý)' and [sysSiteID] = @sysSiteIDSTD and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Bảng kê chứng từ thuế GTGT bán ra (Theo quý)', N'VAT output voucher report (By quarter)', @sysSiteIDSTD, NULL, NULL, @sysReportID, 17, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- 3) =============================== Tờ khai thuế GTGT (Theo quý) ===============================
select @mtTableID = sysTableID from sysTable
where TableName = 'MToKhai' and sysPackageID = 8

if not exists (select top 1 1 from sysReport where ReportName = N'Tờ khai thuế GTGT (Theo quý)' and sysPackageID = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Tờ khai thuế GTGT (Theo quý)', 0, @mtTableID, NULL, N'', 
N'ToKhai_Q', N'VAT Return (By quarter)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, N'mst', null, NULL)

select @sysReportID = sysReportID from sysReport where ReportName = N'Tờ khai thuế GTGT (Theo quý)' and sysPackageID = 8

Update sysReport
set Query = N'select mst.QuyToKhai, mst.NamToKhai, mst.InLanDau, mst.SoLanIn, dt.Stt, dt.ChiTieu, dt.CodeGT, dt.GTHHDV , dt.CodeThue, dt.ThueGTGT
from DToKhai dt inner join MToKhai mst on mst.MToKhaiID = dt.MToKhaiID
where @@ps and mst.NamToKhai = @@NAM 
Order by dt.SortOrder'
where sysReportID = @sysReportID


-- Step 2: Tham số báo cáo
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'QuyToKhai'
AND sysTableID = (select sysTableID from sysTable where TableName = 'MToKhai')

if not exists (select top 1 1 from [sysReportFilter] where sysFieldID = @sysFieldID and sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
VALUES (@sysFieldID, 0, NULL, @sysReportID, 0, 0, 1, 1, 0, NULL)

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Tờ khai thuế GTGT (Theo quý)', N'ToKhai_Q', N'VAT Return (By quarter)', NULL)

-- Step 4: Tạo menu
-- PRO
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Thuế GTGT' and sysSiteID = @sysSiteIDPRO and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDPRO and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN

if not exists (select top 1 1 from sysMenu where MenuName = N'Tờ khai thuế GTGT (Theo quý)' and [sysSiteID] = @sysSiteIDPRO and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Tờ khai thuế GTGT (Theo quý)', N'VAT Return (By quarter)', @sysSiteIDPRO, NULL, NULL, @sysReportID, 15, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END

-- STD
if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

select @sysMenuParent = sysMenuID from sysMenu where MenuName = N'Thuế GTGT' and sysSiteID = @sysSiteIDSTD and sysMenuParent is null

select @sysOtherReport = sysMenuID from sysMenu where MenuName = N'Báo cáo' and sysSiteID = @sysSiteIDSTD and sysMenuParent = @sysMenuParent

if (isnull(@sysOtherReport,'') <> '')
BEGIN

if not exists (select top 1 1 from sysMenu where MenuName = N'Tờ khai thuế GTGT (Theo quý)' and [sysSiteID] = @sysSiteIDSTD and [sysMenuParent] = @sysOtherReport)
INSERT [dbo].[sysMenu] ([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image]) 
VALUES (N'Tờ khai thuế GTGT (Theo quý)', N'VAT Return (By quarter)', @sysSiteIDSTD, NULL, NULL, @sysReportID, 15, NULL, @sysOtherReport, NULL, NULL, 5, NULL)
END

END