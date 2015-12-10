Use CDT


-- Update filter
declare @sysReportID int,
		@sysFieldID int

-- Tờ khai thuế GTGT (Theo tháng)
select @sysReportID = sysReportID from sysReport
where ReportName = N'Tờ khai thuế GTGT (Theo tháng)'

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'KyToKhai'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MToKhai')
				
Update [sysReportFilter] set SpecialCond = 1
where [sysFieldID] = @sysFieldID and sysReportID = @sysReportID and SpecialCond = 0

-- Update Report Query
Update sysReport set Query = N'declare @ky int
set @ky = @@KyToKhai
select mst.KyToKhai, mst.NamToKhai, mst.InLanDau, mst.SoLanIn, dt.Stt, dt.ChiTieu, dt.CodeGT, dt.GTHHDV , dt.CodeThue, dt.ThueGTGT
from DToKhai dt inner join MToKhai mst on mst.MToKhaiID = dt.MToKhaiID
where mst.KyToKhai = @ky and mst.NamToKhai = @@NAM 
Order by dt.SortOrder'
where sysReportID = @sysReportID

-- Update XML Query
Update sysReport set HasExportXML = 1, XMLTemplate = N'01_GTGT_xml', OutputXMLFileNamePattern = '@@NopThueInfor_ThueCuc_ShortName,@@MaSoThue,01_GTGT,M@KyToKhai@@NamLamViec,L00', QueryXML = N'
-- To Khai
declare @ky int
set @ky = @@KyToKhai
select mst.KyToKhai, mst.NamToKhai, 
case when mst.KyToKhai < 10 then ''0'' + convert(varchar(2), mst.KyToKhai) + ''/'' + convert(varchar(5), mst.NamToKhai) 
else convert(varchar(2), mst.KyToKhai) + ''/'' + convert(varchar(5), mst.NamToKhai) end as kyKKhai, 
convert(datetime, convert(varchar(5), mst.NamToKhai) + ''/'' + convert(varchar(2), mst.KyToKhai) + ''/01'') as beginDate,
DATEADD(DAY, -(DAY(DATEADD(MONTH, 1, convert(datetime, convert(varchar(5), mst.NamToKhai) + ''/'' + convert(varchar(2), mst.KyToKhai) + ''/01'')))),
            DATEADD(MONTH, 1, convert(datetime, convert(varchar(5), mst.NamToKhai) + ''/'' + convert(varchar(2), mst.KyToKhai) + ''/01''))) as endDate,
			mst.InLanDau, mst.SoLanIn, dt.Stt, dt.ChiTieu, dt.CodeGT, dt.GTHHDV , dt.CodeThue, dt.ThueGTGT
from DToKhai dt inner join MToKhai mst on mst.MToKhaiID = dt.MToKhaiID
where mst.KyToKhai = @ky and mst.NamToKhai = @@NAM 
Order by dt.SortOrder

-- BK Ban Ra
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATOutTemp'') AND type in (N''U''))
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
	[KyBKBR] int NULL, 
	[NamBKBR] int NULL,
	[NgayBKBR] smalldatetime NULL
)
END

delete from #VATOutTemp

declare @ngayBKBR as smalldatetime

Select @ngayBKBR = mst.NgayBKBR
 from MVATOut mst inner join DVATOut dt on mst.MVATOutID = dt.MVATOutID
 where mst.KyBKBR = @ky and mst.NamBKBR = @@NAM

-- Insert cac dong trong vao bang DVATOut de len bao cao
if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where mst.KyBKBR = @ky and mst.NamBKBR = @@NAM and dt.MaThue = ''KT'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''KT'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where mst.KyBKBR = @ky and mst.NamBKBR = @@NAM and dt.MaThue = ''00'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''00'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where mst.KyBKBR = @ky and mst.NamBKBR = @@NAM and dt.MaThue = ''05'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''05'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where mst.KyBKBR = @ky and mst.NamBKBR = @@NAM and dt.MaThue = ''10'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''10'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where mst.KyBKBR = @ky and mst.NamBKBR = @@NAM and dt.MaThue = ''NHOM5'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''NHOM5'', @ky, @@NAM, @ngayBKBR)


Select dt.SoSeries, dt.Sohoadon, dt.NgayHd, dt.Tenkh,  dt.mst, dt.diengiai  as [Tên mặt hàng],  Sum(Ttien) as TTien, dt.ThueSuat/100 as ThueSuat,
Sum(dt.Thue) as Thue, dt.GhiChu as GhiChu, dt.MaThue, mst.KyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt, dt.FormID, dt.FormSymbol
from MVATOut mst inner join DVATOut dt on mst.MVATOutID = dt.MVATOutID inner join DMThueSuat ts on dt.MaThue = ts.MaThue
 where mst.KyBKBR = @ky and mst.NamBKBR = @@NAM
group by dt.Sohoadon, dt.Soseries, dt.NgayHd, dt.tenkh, dt.ghichu, dt.diengiai, dt.mst, dt.thuesuat, dt.MaThue, mst.KyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt, dt.FormID, dt.FormSymbol
union
Select [SoSeries], [Sohoadon], [NgayHd], [TenKH], [MST], [DienGiai],[TTien],[ThueSuat], [Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR], [Stt], NULL, NULL
from #VATOutTemp
order by ts.Stt, Ngayhd, Sohoadon
 
drop table #VATOutTemp

-- BK Mua Vao
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATInTemp'') AND type in (N''U''))
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
	[KyBKMV] int NULL, 
	[NamBKMV] int NULL,
	[NgayBKMV] smalldatetime NULL
)
END

delete from #VATInTemp

declare @maLoaiThue int,
		@ngayBKMV as smalldatetime

Select @ngayBKMV = mst.NgayBKMV
 from MVATIn mst inner join DVATIn dt on mst.MVATInID = dt.MVATInID
 where mst.KyBKMV = @ky and mst.NamBKMV = @@NAM
 
declare cur_LThue cursor for
select MaLoaiThue from DMLThue order by MaLoaiThue

open cur_LThue
fetch next from cur_LThue into @maLoaiThue

WHILE @@FETCH_STATUS = 0
BEGIN

-- Insert cac dong trong vao bang DVATIn de len bao cao
if not exists (select top 1 1 from DVATIn dt inner join MVATIn mst on mst.MVATInID = dt.MVATInID where mst.KyBKMV = @ky and mst.NamBKMV = @@NAM and dt.MaLoaiThue = @maLoaiThue)
INSERT INTO #VATInTemp ([NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaLoaiThue],[KyBKMV],[NamBKMV], [NgayBKMV]) 
VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @maLoaiThue, @ky, @@NAM, @ngayBKMV)

fetch next from cur_LThue into @maLoaiThue

END

close cur_LThue
deallocate cur_LThue

Select dt.NgayCt as [Ngày HT VAT], dt.NgayHd, dt.SoSeries, dt.Sohoadon, dt.TenKH, dt.MST, dt.DienGiai as [Tên mặt hàng], Sum(dt.TTien) TTien, dt.ThueSuat as ThueSuat,
Sum(dt.Thue) Thue, dt.GhiChu as GhiChu, dt.MaLoaiThue as [Loại thuế], mst.KyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.MaThue, dt.FormID, dt.FormSymbol
 from MVATIn mst inner join DVATIn dt on mst.MVATInID = dt.MVATInID
 where mst.KyBKMV = @ky and mst.NamBKMV = @@NAM
 group by dt.ngayhd, dt.MaLoaiThue, dt.Sohoadon, dt.soseries, dt.ngayct, dt.TenKH, dt.MST, dt.DienGiai, dt.MaThue, dt.ThueSuat, mst.KyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.GhiChu, dt.FormID, dt.FormSymbol
union
Select [NgayCt] as [Ngày HT VAT],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien], [ThueSuat],[Thue],[GhiChu],[MaLoaiThue],[KyBKMV],[NamBKMV], [NgayBKMV], NULL, NULL, NULL
from #VATInTemp
order by MaLoaiThue, Ngayhd, Sohoadon
 
drop table #VATInTemp'
where sysReportID = @sysReportID

-- Tờ khai thuế GTGT (Theo Quý)
select @sysReportID = sysReportID from sysReport
where ReportName = N'Tờ khai thuế GTGT (Theo quý)'

select @sysFieldID = sysFieldID from SysField
				where FieldName = 'QuyToKhai'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MToKhai')
				
Update [sysReportFilter] set SpecialCond = 1
where [sysFieldID] = @sysFieldID and sysReportID = @sysReportID and SpecialCond = 0

-- Update Report Query
Update sysReport set Query = N'declare @quy int
set @quy = @@QuyToKhai
select mst.QuyToKhai, mst.NamToKhai, mst.InLanDau, mst.SoLanIn, dt.Stt, dt.ChiTieu, dt.CodeGT, dt.GTHHDV , dt.CodeThue, dt.ThueGTGT
from DToKhai dt inner join MToKhai mst on mst.MToKhaiID = dt.MToKhaiID
where mst.QuyToKhai = @quy and mst.NamToKhai = @@NAM 
Order by dt.SortOrder'
where sysReportID = @sysReportID

-- Update XML Query
Update sysReport set HasExportXML = 1, XMLTemplate = N'01_GTGT_Q_xml', OutputXMLFileNamePattern = '@@NopThueInfor_ThueCuc_ShortName,@@MaSoThue,01_GTGT,Q@QuyToKhai@@NamLamViec,L00', QueryXML = N'
-- To Khai
declare @quy int
set @quy = @@QuyToKhai
select mst.QuyToKhai, mst.NamToKhai, 
convert(varchar(2), mst.QuyToKhai) + ''/'' + convert(varchar(5), mst.NamToKhai) as kyKKhai, 
dateadd(M, (mst.QuyToKhai-1)*3, CONVERT(datetime, CONVERT(varchar(5),mst.NamToKhai)+''-1-1'')) as beginDate,
dateadd(D,-1,dateadd(M, 3*mst.QuyToKhai, CONVERT(datetime, CONVERT(varchar(5),mst.NamToKhai)+''-1-1''))) as endDate,
			mst.InLanDau, mst.SoLanIn, dt.Stt, dt.ChiTieu, dt.CodeGT, dt.GTHHDV , dt.CodeThue, dt.ThueGTGT
from DToKhai dt inner join MToKhai mst on mst.MToKhaiID = dt.MToKhaiID
where mst.QuyToKhai = @quy and mst.NamToKhai = @@NAM 
Order by dt.SortOrder

-- BK Ban Ra
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATOutTemp'') AND type in (N''U''))
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

declare @ngayBKBR as smalldatetime

Select @ngayBKBR = mst.NgayBKBR
 from MVATOut mst inner join DVATOut dt on mst.MVATOutID = dt.MVATOutID
 where mst.QuyBKBR = @quy and mst.NamBKBR = @@NAM

-- Insert cac dong trong vao bang DVATOut de len bao cao
if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where mst.QuyBKBR = @quy and mst.NamBKBR = @@NAM and dt.MaThue = ''KT'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''KT'', @quy, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where mst.QuyBKBR = @quy and mst.NamBKBR = @@NAM and dt.MaThue = ''00'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''00'', @quy, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where mst.QuyBKBR = @quy and mst.NamBKBR = @@NAM and dt.MaThue = ''05'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''05'', @quy, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where mst.QuyBKBR = @quy and mst.NamBKBR = @@NAM and dt.MaThue = ''10'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''10'', @quy, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where mst.QuyBKBR = @quy and mst.NamBKBR = @@NAM and dt.MaThue = ''NHOM5'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''NHOM5'', @quy, @@NAM, @ngayBKBR)


Select dt.SoSeries, dt.Sohoadon, dt.NgayHd, dt.Tenkh,  dt.mst, dt.diengiai  as [Tên mặt hàng],  Sum(Ttien) as TTien, dt.ThueSuat/100 as ThueSuat,
Sum(dt.Thue) as Thue, dt.GhiChu as GhiChu, dt.MaThue, mst.QuyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt, dt.FormID, dt.FormSymbol
from MVATOut mst inner join DVATOut dt on mst.MVATOutID = dt.MVATOutID inner join DMThueSuat ts on dt.MaThue = ts.MaThue
 where mst.QuyBKBR = @quy and mst.NamBKBR = @@NAM
group by dt.Sohoadon, dt.Soseries, dt.NgayHd, dt.tenkh, dt.ghichu, dt.diengiai, dt.mst, dt.thuesuat, dt.MaThue, mst.QuyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt, dt.FormID, dt.FormSymbol
union
Select [SoSeries], [Sohoadon], [NgayHd], [TenKH], [MST], [DienGiai],[TTien],[ThueSuat], [Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR], [Stt], NULL, NULL
from #VATOutTemp
order by ts.Stt, Ngayhd, Sohoadon
 
drop table #VATOutTemp

-- BK Mua Vao
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATInTemp'') AND type in (N''U''))
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
		@ngayBKMV as smalldatetime

Select @ngayBKMV = mst.NgayBKMV
 from MVATIn mst inner join DVATIn dt on mst.MVATInID = dt.MVATInID
 where mst.QuyBKMV = @quy and mst.NamBKMV = @@NAM
 
declare cur_LThue cursor for
select MaLoaiThue from DMLThue order by MaLoaiThue

open cur_LThue
fetch next from cur_LThue into @maLoaiThue

WHILE @@FETCH_STATUS = 0
BEGIN

-- Insert cac dong trong vao bang DVATIn de len bao cao
if not exists (select top 1 1 from DVATIn dt inner join MVATIn mst on mst.MVATInID = dt.MVATInID where mst.QuyBKMV = @quy and mst.NamBKMV = @@NAM and dt.MaLoaiThue = @maLoaiThue)
INSERT INTO #VATInTemp ([NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaLoaiThue],[QuyBKMV],[NamBKMV], [NgayBKMV]) 
VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @maLoaiThue, @quy, @@NAM, @ngayBKMV)

fetch next from cur_LThue into @maLoaiThue

END

close cur_LThue
deallocate cur_LThue

Select dt.NgayCt as [Ngày HT VAT], dt.NgayHd, dt.SoSeries, dt.Sohoadon, dt.TenKH, dt.MST, dt.DienGiai as [Tên mặt hàng], Sum(dt.TTien) TTien, dt.ThueSuat as ThueSuat,
Sum(dt.Thue) Thue, dt.GhiChu as GhiChu, dt.MaLoaiThue as [Loại thuế], mst.QuyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.MaThue, dt.FormID, dt.FormSymbol
 from MVATIn mst inner join DVATIn dt on mst.MVATInID = dt.MVATInID
 where mst.QuyBKMV = @quy and mst.NamBKMV = @@NAM
 group by dt.ngayhd, dt.MaLoaiThue, dt.Sohoadon, dt.soseries, dt.ngayct, dt.TenKH, dt.MST, dt.DienGiai, dt.MaThue, dt.ThueSuat, mst.QuyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.GhiChu, dt.FormID, dt.FormSymbol
union
Select [NgayCt] as [Ngày HT VAT],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien], [ThueSuat],[Thue],[GhiChu],[MaLoaiThue],[QuyBKMV],[NamBKMV], [NgayBKMV], NULL, NULL, NULL
from #VATInTemp
order by MaLoaiThue, Ngayhd, Sohoadon
 
drop table #VATInTemp'
where sysReportID = @sysReportID