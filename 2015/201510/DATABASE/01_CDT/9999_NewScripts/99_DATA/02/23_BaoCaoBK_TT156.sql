USE [CDT]

-- Bảng kê thuế GTGT mua vào (Theo tháng)
Update sysReport set Query = N'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATInTemp'') AND type in (N''U''))
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
		@ky as int,
		@ngayBKMV as smalldatetime

Select @ky = mst.KyBKMV, @ngayBKMV = mst.NgayBKMV
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
INSERT INTO #VATInTemp ([NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaLoaiThue],[KyBKMV],[NamBKMV], [NgayBKMV]) 
VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @maLoaiThue, @ky, @@NAM, @ngayBKMV)

fetch next from cur_LThue into @maLoaiThue

END

close cur_LThue
deallocate cur_LThue

Select dt.NgayCt as [Ngày HT VAT], dt.NgayHd, dt.SoSeries, dt.Sohoadon, dt.TenKH, dt.MST, dt.DienGiai as [Tên mặt hàng], Sum(dt.TTien) TTien, dt.ThueSuat as ThueSuat,
Sum(dt.Thue) Thue, dt.GhiChu as GhiChu, dt.MaLoaiThue as [Loại thuế], mst.KyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.MaThue, dt.FormID, dt.FormSymbol
 from MVATIn mst inner join DVATIn dt on mst.MVATInID = dt.MVATInID
 where @@ps and mst.NamBKMV = @@NAM
 group by dt.ngayhd, dt.MaLoaiThue, dt.Sohoadon, dt.soseries, dt.ngayct, dt.TenKH, dt.MST, dt.DienGiai, dt.MaThue, dt.ThueSuat, mst.KyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.GhiChu, dt.FormID, dt.FormSymbol
union
Select [NgayCt] as [Ngày HT VAT],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien], [ThueSuat],[Thue],[GhiChu],[MaLoaiThue],[KyBKMV],[NamBKMV], [NgayBKMV], NULL, NULL, NULL
from #VATInTemp
order by MaLoaiThue, Ngayhd, Sohoadon
 
drop table #VATInTemp'
where ReportName = N'Bảng kê thuế GTGT mua vào (Theo tháng)'

-- Bảng kê thuế GTGT mua vào (Theo quý)
Update sysReport set Query = N'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATInTemp'') AND type in (N''U''))
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
Sum(dt.Thue) Thue, dt.GhiChu as GhiChu, dt.MaLoaiThue as [Loại thuế], mst.QuyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.MaThue, dt.FormID, dt.FormSymbol
 from MVATIn mst inner join DVATIn dt on mst.MVATInID = dt.MVATInID
 where @@ps and mst.NamBKMV = @@NAM
 group by dt.ngayhd, dt.MaLoaiThue, dt.Sohoadon, dt.soseries, dt.ngayct, dt.TenKH, dt.MST, dt.DienGiai, dt.MaThue, dt.ThueSuat, mst.QuyBKMV, mst.NamBKMV, mst.NgayBKMV, dt.GhiChu, dt.FormID, dt.FormSymbol
union
Select [NgayCt] as [Ngày HT VAT],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien], [ThueSuat],[Thue],[GhiChu],[MaLoaiThue],[QuyBKMV],[NamBKMV], [NgayBKMV], NULL, NULL, NULL
from #VATInTemp
order by MaLoaiThue, Ngayhd, Sohoadon
 
drop table #VATInTemp'
where ReportName = N'Bảng kê thuế GTGT mua vào (Theo quý)'

-- Bảng kê thuế GTGT bán ra (Theo tháng)
Update sysReport set Query = N'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATOutTemp'') AND type in (N''U''))
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

declare @ky as int,
		@ngayBKBR as smalldatetime

Select @ky = mst.KyBKBR, @ngayBKBR = mst.NgayBKBR
 from MVATOut mst inner join DVATOut dt on mst.MVATOutID = dt.MVATOutID
 where @@ps and mst.NamBKBR = @@NAM

-- Insert cac dong trong vao bang DVATOut de len bao cao
if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''KT'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''KT'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''00'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''00'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''05'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''05'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''10'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''10'', @ky, @@NAM, @ngayBKBR)

if not exists (select top 1 1 from DVATOut dt inner join MVATOut mst on mst.MVATOutID = dt.MVATOutID where @@ps and mst.NamBKBR = @@NAM and dt.MaThue = ''NHOM5'')
INSERT INTO #VATOutTemp ([Stt], [NgayCt],[NgayHd],[SoSeries],[Sohoadon],[TenKH],[MST],[DienGiai],[TTien],[ThueSuat],[Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR]) 
VALUES (5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, ''NHOM5'', @ky, @@NAM, @ngayBKBR)


Select dt.SoSeries, dt.Sohoadon, dt.NgayHd, dt.Tenkh,  dt.mst, dt.diengiai  as [Tên mặt hàng],  Sum(Ttien) as TTien, dt.ThueSuat/100 as ThueSuat,
Sum(dt.Thue) as Thue, dt.GhiChu as GhiChu, dt.MaThue, mst.KyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt, dt.FormID, dt.FormSymbol
from MVATOut mst inner join DVATOut dt on mst.MVATOutID = dt.MVATOutID inner join DMThueSuat ts on dt.MaThue = ts.MaThue
 where @@ps and mst.NamBKBR = @@NAM
group by dt.Sohoadon, dt.Soseries, dt.NgayHd, dt.tenkh, dt.ghichu, dt.diengiai, dt.mst, dt.thuesuat, dt.MaThue, mst.KyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt, dt.FormID, dt.FormSymbol
union
Select [SoSeries], [Sohoadon], [NgayHd], [TenKH], [MST], [DienGiai],[TTien],[ThueSuat], [Thue],[GhiChu],[MaThue],[KyBKBR],[NamBKBR], [NgayBKBR], [Stt], NULL, NULL
from #VATOutTemp
order by ts.Stt, Ngayhd, Sohoadon
 
drop table #VATOutTemp'
where ReportName = N'Bảng kê thuế GTGT bán ra (Theo tháng)'

-- Bảng kê thuế GTGT bán ra (Theo quý)
Update sysReport set Query = N'IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#VATOutTemp'') AND type in (N''U''))
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
Sum(dt.Thue) as Thue, dt.GhiChu as GhiChu, dt.MaThue, mst.QuyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt, dt.FormID, dt.FormSymbol
from MVATOut mst inner join DVATOut dt on mst.MVATOutID = dt.MVATOutID inner join DMThueSuat ts on dt.MaThue = ts.MaThue
 where @@ps and mst.NamBKBR = @@NAM
group by dt.Sohoadon, dt.Soseries, dt.NgayHd, dt.tenkh, dt.ghichu, dt.diengiai, dt.mst, dt.thuesuat, dt.MaThue, mst.QuyBKBR, mst.NamBKBR, mst.NgayBKBR, ts.Stt, dt.FormID, dt.FormSymbol
union
Select [SoSeries], [Sohoadon], [NgayHd], [TenKH], [MST], [DienGiai],[TTien],[ThueSuat], [Thue],[GhiChu],[MaThue],[QuyBKBR],[NamBKBR], [NgayBKBR], [Stt], NULL, NULL
from #VATOutTemp
order by ts.Stt, Ngayhd, Sohoadon
 
drop table #VATOutTemp'
where ReportName = N'Bảng kê thuế GTGT bán ra (Theo quý)'