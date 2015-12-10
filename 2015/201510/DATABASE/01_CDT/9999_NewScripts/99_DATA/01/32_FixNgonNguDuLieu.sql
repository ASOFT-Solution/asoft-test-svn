USE CDT

--Phải thu của khách hàng
Update sysReport set Query = N'DECLARE @tk NVARCHAR(16)
DECLARE @ngayCt DATETIME
DECLARE @dk NVARCHAR(256)
DECLARE @sql NVARCHAR (4000)

SET @tk=''131''
SET @ngayCt=@@NgayCT
SET @sql=''create view wsodu as select makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))='''''' + @tk + '''''' group by makh''

EXEC (@sql)

SET @sql=''create view wsotk as select makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))='''''' + @tk + '''''' and ngayct<=cast('''''' + CONVERT(NVARCHAR, @ngayct) + '''''' as datetime) group by makh ''

EXEC (@sql)

SET @sql=''create view wG1 as select * from wsodu union all select * from wsotk''

EXEC (@sql)

SET @sql=''create view wducuoi as select makh,  dunont=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,  duno=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,  ducont=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,  duco=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end  from wG1 group by makh''

EXEC (@sql)

DECLARE @tongcong FLOAT

SELECT @tongcong = Sum(duno - duco)
FROM   wducuoi

SELECT *
FROM   (SELECT case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end AS ''Tên khách hàng'',
               a.duno - a.duco AS ''Số phải thu''
        FROM   wducuoi a,
               dmkh
        WHERE  a.makh = dmkh.makh
        UNION ALL
        SELECT case when @@lang = 1 then N''Total'' else N''Tổng cộng'' end,
               @tongcong) t

DROP VIEW wsodu

DROP VIEW wsotk

DROP VIEW wG1

DROP VIEW wducuoi '
where ReportName = N'Phải thu của khách hàng'

--Phải thu của khách hàng
Update sysReport set Query = N'DECLARE @tk NVARCHAR(16)
DECLARE @ngayCt DATETIME
DECLARE @dk NVARCHAR(256)
DECLARE @sql NVARCHAR (4000)

SET @tk=''331''
SET @ngayCt=@@NgayCT
SET @sql=''create view wsodu as select makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))='''''' + @tk + '''''' group by makh''

EXEC (@sql)

SET @sql=''create view wsotk as select makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))='''''' + @tk + '''''' and ngayct<=cast('''''' + CONVERT(NVARCHAR, @ngayct) + '''''' as datetime) group by makh ''

EXEC (@sql)

SET @sql=''create view wG1 as select * from wsodu union all select * from wsotk''

EXEC (@sql)

SET @sql=''create view wducuoi as select makh,  dunont=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,  duno=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,  ducont=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,  duco=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end  from wG1 group by makh''

EXEC (@sql)

DECLARE @tongcong FLOAT

SELECT @tongcong = Sum(duco - duno)
FROM   wducuoi

SELECT *
FROM   (SELECT case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as N''Nhà cung cấp'',
               a.duco - a.duno AS N''Số phải trả''
        FROM   wducuoi a,
               dmkh
        WHERE  a.makh *= dmkh.makh
        UNION ALL
        SELECT case when @@lang = 1 then N''Total'' else N''Tổng cộng'' end ,
               @tongcong) t

DROP VIEW wsodu

DROP VIEW wsotk

DROP VIEW wG1

DROP VIEW wducuoi 
'
where ReportName = N'Phải trả nhà cung cấp'

--Tờ khai Thuế TNDN tạm tính 1A
Update sysReport set Query = N'select dt.Stt1,  case when @@lang = 1 then dt.TenChiTieu2 else dt.TenChiTieu end as TenChiTieu, dt.MaCode, dt.TTien, mst.Quy, mst.Nam1, mst.InLanDau, mst.SoLanIn, mst.PhuThuoc, mst.DienGiai from MVATTNDN mst inner join DVATTNDN dt on mst.MVATTNDNID = dt.MVATTNDNID
where mst.MauBaoCao = N''1A/TNDN-TT28'' and @@ps order by dt.SortOrder'
where ReportName = N'Tờ khai Thuế TNDN tạm tính 1A'


--Tờ khai Thuế TNDN tạm tính 1B
Update sysReport set Query = N'select dt.Stt1, dt.Stt2, case when @@lang = 1 then dt.TenChiTieu2 else dt.TenChiTieu end as TenChiTieu, dt.MaCode, dt.TTien, mst.Quy, mst.Nam1, mst.InLanDau, mst.SoLanIn, mst.PhuThuoc, mst.DienGiai from MVATTNDN mst inner join DVATTNDN dt on mst.MVATTNDNID = dt.MVATTNDNID
where mst.MauBaoCao = N''1B/TNDN-TT28'' and @@ps order by dt.SortOrder'
where ReportName = N'Tờ khai Thuế TNDN tạm tính 1B'

--Tình hình thực hiện nghĩa vụ nộp thuế               
Update sysReport set Query = N'declare @ngayct datetime
declare @ngayCt1 datetime
declare @sql nvarchar (4000)
declare @gradeTK1 int
declare @gradeTK2 int

set @ngayct=@@Ngayct1
set @ngayCt1=@@Ngayct2

create table #NghiaVuNT
 ( [STT] int null,
 [ChiTieu] nvarchar(128) NULL,
 [ChiTieu2] nvarchar(128) NULL,
 [MaSo] varchar(50),
 [TaiKhoan] varchar(16) COLLATE database_default NULL,
 [DauKy] [decimal](28, 3) NULL,
 [PhaiNop] [decimal](28, 3) NULL,
 [DaNop] [decimal](28, 3) NULL,
 [CuoiKy] [decimal](28, 3) NULL
 ) 
-- Insert các dòng cố định vào trong bảng tạm
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''0'',N''I – Thuế'',N''I – Tax'', ''01'', NULL, NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''1'',N''1. Thuế GTGT hàng bán nội địa'',N''1. VAT to domestic sales'', ''02'', ''33311'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''2'',N''2. Thuế GTGT hàng nhập khẩu'',N''2. Imported VAT'', ''03'', ''33312'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''3'',N''3. Thuế tiêu thụ đặc biệt'',N''3. Excise tax'', ''04'', ''3332'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''4'',N''4. Thuế xuất, nhập khẩu'', N''4. Export and import'',''05'', ''3333'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''5'',N''5. Thuế thu nhập doanh nghiệp'',N''5. Corporate Income Tax'', ''06'', ''3334'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''6'',N''6. Thuế thu nhập cá nhân'',N''6. Personal Income Tax'', ''07'', ''3335'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''7'',N''7. Thuế tài nguyên'', N''7. Royalties'',''08'', ''3336'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''8'',N''8. Thuế nhà đất, tiền thuê đất'',N''8. Land tax, land rent'', ''09'', ''3337'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''9'',N''9. Các loại thuế khác'', N''9. Other taxes'',''10'', ''3338'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''10'',N''II – Các khoản phải nộp khác'',N''II – The other payables'', ''20'', NULL, NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''11'',N''1. Các khoản phụ thu'', N''1. The surcharge'',''21'', NULL, NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''12'',N''2. Các khoản phí, lệ phí'',N''2. The fees and charges'', ''22'', NULL, NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''13'',N''3. Các khoản khác'',N''3. Other sources'', ''23'', ''3339'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[ChiTieu2],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''14'',N''Tổng cộng'',N''Total'', ''30'', '''', NULL, NULL, NULL, NULL)

--Truy vấn số liệu đầu kỳ, phát sinh trong kỳ và tính số cuối kỳ từ bảng OBTK, OBKH
--Tài khoản công nợ
set @sql=''create view wcongno as 
select tk,makh,0.0 as nodau, 0.0 as codau,sum(psno) as psno,sum(psco) as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno=1) and ngayCt  between cast('''''' + convert(nvarchar,@ngayCt) + '''''' as datetime) and  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) group by tk,makh
union all
select tk,makh,0.0 as nodau, 0.0 as codau,0.0 as psno,0.0 as psco, sum(psno) as lkno, sum(psco) as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno=1) and ngayCt  <=  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) and year(ngayct) = year(cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime)) group by tk,makh
union all
select tk,makh,sum(duno) as nodau,sum(duco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from obkh group by tk, makh
union all
select tk,makh,sum(psno)as nodau, sum(psco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno=1) and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by tk, makh''

exec (@sql)
set @sql=''create view wcongno1 as
select tk,sum(nodau) as nodau, sum(codau) as codau, sum(psno) as psno, sum(psco) as psco, sum(lkno) as lkno, sum(lkco) as lkco, sum(nocuoi) as nocuoi,sum(cocuoi) as cocuoi from wcongno group by tk''
exec (@sql)
set @sql=''create view wcongno2 as
select tk, nodau,  codau, psno,  psco, lkno, lkco,   nocuoi = case when nodau+psno-codau-psco >0 then nodau+psno-codau-psco else 0 end, cocuoi = case when nodau+psno-codau-psco <0 then abs(nodau+psno-codau-psco) else 0 end from wcongno1 ''
exec (@sql)
set @sql=N''create view wcongno3 as 
select tk,  [Nợ đầu] = case when nodau-codau>=0 then nodau-codau else 0 end,  
[Có đầu] = case when nodau-codau<0 then codau-nodau else 0 end, psno,  psco, lkno as [Lũy kế nợ], lkco as [Lũy kế có], [Nợ cuối] = case when nodau+psno-codau-psco >0 then nodau+psno-codau-psco else 0 end, [Có cuối] = case when nodau+psno-codau-psco <0 then abs(nodau+psno-codau-psco) else 0 end from wcongno1''

exec (@sql)
--tài khoản thường
set @sql=''create view wthuong as 
select tk,0.0 as nodau, 0.0 as codau,sum(psno) as psno,sum(psco) as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt between cast('''''' + convert(nvarchar,@ngayCt) + '''''' as datetime) and  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) group by tk
union all
select tk,0.0 as nodau, 0.0 as codau,0.0 as psno,0.0 as psco, sum(psno) as lkno, sum(psco) as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt  <=  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) and year(ngayct) = year(cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime)) group by tk
union all
select tk, sum(duno) as nodau,sum(duco) as codau,0.0 as psno,0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi  from obtk where tk in(select tk from dmtk where tkcongno<>1) group by tk, MaNT
union all
select tk,sum(psno) as nodau,sum(psco) as codau,0.0 as psno, 0.0 as psco, 0.0 as lkno, 0.0 as lkco,0.0 as nocuoi, 0.0 as cocuoi from bltk where tk in(select tk from dmtk where tkcongno<>1) and ngayCt < cast('''''' + convert(nvarchar,@ngayCt) + '''''' as datetime) group by tk''
exec (@sql)
set @sql=''create view wthuong1 as
select tk, sum(nodau) as nodau, sum(codau) as codau, sum(psno) as psno, sum(psco) as psco, sum(lkno) as lkno, sum(lkco) as lkco, sum(nocuoi) as nocuoi,sum(cocuoi) as cocuoi from wthuong group by tk''
exec (@sql)
set @sql=N''create view wthuong2 as
select tk,  [Nợ đầu] = case when nodau-codau>=0 then nodau-codau else 0 end,  
[Có đầu] = case when nodau-codau<0 then codau-nodau else 0 end, psno,  psco, lkno as [Lũy kế nợ], lkco as [Lũy kế có], [Nợ cuối] = case when nodau+psno-codau-psco >0 then nodau+psno-codau-psco else 0 end, [Có cuối] = case when nodau+psno-codau-psco <0 then abs(nodau+psno-codau-psco) else 0 end from wthuong1 ''
exec (@sql)
declare @tnodk decimal(28,6), @cnodk decimal(28,6)
declare @tcodk decimal(28,6), @ccodk decimal(28,6)
declare @tpsno decimal(28,6), @cpsno decimal(28,6)
declare @tpsco decimal(28,6), @cpsco decimal(28,6)
declare @tlkno decimal(28,6), @clkno decimal(28,6)
declare @tlkco decimal(28,6), @clkco decimal(28,6)
declare @tnock decimal(28,6), @cnock decimal(28,6)
declare @tcock decimal(28,6), @ccock decimal(28,6)
select @tnodk= sum([Nợ đầu]), @tcodk = sum([Có đầu]),
 @tpsno = sum(psno), @tpsco = sum(psco),
 @tlkno = sum([Lũy kế nợ]), @tlkco = sum([Lũy kế có]),
 @tnock = sum([Nợ cuối]), @tcock = sum([Có cuối]) from wthuong2 where tk like ''333%''
select @cnodk= sum([Nợ đầu]), @ccodk = sum([Có đầu]),
 @cpsno = sum(psno), @cpsco = sum(psco),
 @clkno = sum([Lũy kế nợ]), @clkco = sum([Lũy kế có]),
 @cnock = sum([Nợ cuối]), @ccock = sum([Có cuối]) from wcongno3 where tk like ''333%''
Select N.Stt, case when @@lang = 1 then N.ChiTieu2 else N.ChiTieu end as [Chỉ tiêu], N.MaSo as [Mã số], N.TaiKhoan as [Tài khoản], K.[Có đầu]-K.[Nợ đầu] as [Đầu kỳ], K.[PsCo] as [Số phải nộp],K.[PsNo] as [Số đã nộp],K.[Lũy kế có] as [Phải nộp lũy kế],K.[Lũy kế nợ] as [Đã nộp lũy kế],K.[Có đầu]-K.[Nợ đầu]+K.[PsCo]-K.[PsNo] as [Cuối kỳ] from 
(select a.Tk, case when 0 = 1 then b.tentk2 else b.tentk end as tentk,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wcongno3 a inner join dmtk b on a.tk = b.tk
union all
select a.Tk, case when 0 = 1 then b.tentk2 else b.tentk end as tentk,a.[Nợ đầu],a.[Có đầu],a.[PsNo],a.[PsCo],a.[Lũy kế nợ],a.[Lũy kế có],a.[Nợ cuối],a.[Có cuối] from wthuong2  a  inner join dmtk b on a.tk = b.tk
union all
select '''' as Tk,case when 0 = 1 then N''Total'' else N''Tổng cộng'' end as tentk, isnull(@tnodk,0) + isnull(@cnodk,0) as nodau, isnull(@tcodk,0) + isnull(@ccodk,0) as codau, isnull(@tpsno,0) + isnull(@cpsno,0) as psno, isnull(@tpsco,0) + isnull(@cpsco,0) as psco, isnull(@tlkno,0) + isnull(@clkno,0) as lkno, isnull(@tlkco,0) + isnull(@clkco,0) as lkco, isnull(@tnock,0) + isnull(@cnock,0) as nocuoi, isnull(@tcock,0) + isnull(@ccock,0) as cocuoi
) as K right join  #NghiaVuNT as N on K.Tk=N.Taikhoan

drop view wcongno
drop view wcongno1
drop view wcongno2
drop view wcongno3
drop view wthuong
drop view wthuong1
drop view wthuong2
drop table #NghiaVuNT'
where ReportName = N'Tình hình thực hiện nghĩa vụ nộp thuế'

--Bảng cân đối nhập xuất tồn
Update sysReport set Query = N'declare @ngayct datetime
declare @ngayCt1 datetime
declare @sql nvarchar (4000)
set @ngayct=@@ngayct1
set @ngayct1=dateadd(hh,23,@@ngayct2)

--phần cân đối tk thường
set @sql=''create view wthuong as 
select mavt,0.0 as sldk,0.0 as nodau,sum(soluong) as sln, sum(soluong_x) as slx,sum(psno) as psno,sum(psco) as psco from blvt where ngayCt between cast('''''' 
+ convert(nvarchar,@ngayCt) + '''''' as datetime) and  cast(''''''+ convert(nvarchar,@ngayCt1) + '''''' as datetime) and  ''+''@@ps''+'' group by mavt
union all
select mavt,sum(soluong - soluong_x) as sldk,sum(psno - psco) as nodau,0.0 as sln, 0.0 as slx,0.0 as psno,0.0 as psco from blvt where ngayCt < cast(''''''+ convert(nvarchar,@ngayCt) + '''''' as datetime) and  ''+''@@ps''+'' group by mavt
union all
select mavt,sum(soluong) as sldk,sum(dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco from obvt where  ''+''@@ps''+'' group by mavt
union all
select mavt,sum(soluong) as sldk,sum(dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco from obNTXT where  ''+''@@ps''+'' group by mavt''
exec (@sql)
set @sql=''create view wthuong1 as
select mavt,sum(sldk) as sldk, sum(nodau) as dudau, sum(sln) as sln,sum(slx) as slx, sum(psno) as psno, sum(psco) as psco from wthuong group by mavt''
exec (@sql)
set @sql=''create view wthuong2 as
select mavt,sldk,  dudau, sln, psno, slx,  psco, sldk+sln-slx as slck,   ducuoi = dudau+psno-psco  from wthuong1 ''
exec (@sql)
declare @tsldk decimal(22,6),@tdudau decimal(22,6)
declare @tsln decimal(22,6),@tpsno decimal(22,6)
declare @tslx decimal(22,6),@tpsco decimal(22,6)
declare @tslck decimal(22,6),@tducuoi decimal(22,6)
select @tsldk=sum(sldk),@tdudau=sum(dudau),
@tsln=sum(sln),@tpsno=sum(psno),@tslx=sum(slx),
@tpsco=sum(psco),@tslck=sum(slck),@tducuoi=sum(ducuoi) from wthuong2
if @@nhom='''' 
begin
select b.Nhom, a.mavt,case when @@lang = 1 then tenvt2 else tenvt end as tenvt,case when @@lang = 1 then c.tendvt2 else c.tendvt end as tendvt, a.sldk as N''Tồn đầu'', a.DuDau as N''Dư đầu'', a.sln as N''Số lượng nhập'', a.psno as N''Giá trị nhập'', a.slx as N''Số lượng xuất'', a.psco as N''Giá trị xuất'', a.slck as N''Tồn cuối'', a.DuCuoi as N''Dư cuối'' from wthuong2 a, dmvt b, dmdvt c where a.mavt =b.mavt and b.madvt = c.madvt
union select '''','''',case when @@lang = 1 then ''Total'' else N''Tổng cộng'' end,'''',@tsldk,@tdudau,@tsln,
@tpsno,@tslx,@tpsco,@tslck,@tducuoi
end 
else 
begin 
select b.Nhom, a.mavt,case when @@lang = 1 then tenvt2 else tenvt end as tenvt,case when @@lang = 1 then c.tendvt2 else c.tendvt end as tendvt, a.sldk as N''Tồn đầu'', a.DuDau as N''Dư đầu'', a.sln as N''Số lượng nhập'', a.psno as N''Giá trị nhập'', a.slx as N''Số lượng xuất'', a.psco as N''Giá trị xuất'', a.slck as N''Tồn cuối'', a.DuCuoi as N''Dư cuối'' from wthuong2 a, dmvt b, dmdvt c where a.mavt =b.mavt and b.madvt = c.madvt and  b.nhom=@@nhom
union  all
select '''','''',case when @@lang = 1 then ''Total'' else N''Tổng cộng'' end,'''',@tsldk,@tdudau,@tsln,
@tpsno,@tslx,@tpsco,@tslck,@tducuoi
end

drop view wthuong
drop view wthuong1
drop view wthuong2', 
TreeData =N'select MaNhomVT, MaNhomVTMe, case when @@lang = 1 then TenNhom2 else TenNhom end from DMNhomVT'

where ReportName = N'Bảng cân đối nhập xuất tồn'

--Báo cáo tồn kho-----------
Update sysReport set Query = N'	declare @sql nvarchar (4000)
	--phần cân đối tk thường
	set @sql=''create view wthuong as 
	select makho, mavt,0.0 as sldk,0.0 as nodau,sum(soluong) as sln, sum(soluong_x) as slx,sum(psno) as psno,sum(psco) as psco from blvt where ngayCt <=  cast('''''' + convert(nvarchar,@@ngayCt) + '''''' as datetime) and  ''+''@@ps''+'' group by makho, mavt
	union all
	select makho, mavt,sum(soluong) as sldk,sum(dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco from obvt where  ''+''@@ps''+'' group by makho, mavt
	union all
	select makho, mavt,sum(soluong) as sldk,sum(dudau) as nodau,0.0 as sln,0.0 as slx,0.0 as psno,0.0 as psco from obntxt where  ''+''@@ps''+'' group by makho, mavt''
	exec (@sql)
	set @sql=''create view wthuong1 as
	select makho, mavt,sum(sldk) as sldk, sum(nodau) as dudau, sum(sln) as sln,sum(slx) as slx, sum(psno) as psno, sum(psco) as psco from wthuong group by makho, mavt''
	exec (@sql)
	set @sql=''create view wthuong2 as
	select makho, mavt,sldk,  dudau, sln,slx, psno,  psco, sldk+sln-slx as slck,   ducuoi = dudau+psno-psco  from wthuong1 ''
	exec (@sql)
 Select a.makho, a.MaVT, case when @@lang = 1 then dmvt.TenVT2 else dmvt.TenVT end as TenVT, case when @@lang = 1 then dmdvt.TenDVT2 else dmdvt.TenDVT end as TenDVT , slck N''Tồn Cuối'', ducuoi N''Dư Cuối''
 From wthuong2 a, dmvt, dmdvt
 where slck <> 0 and ducuoi <> 0 and a.MaVT = dmvt.MaVT and dmvt.MaDVT = dmdvt.MaDVT
	
	drop view wthuong
	drop view wthuong1
	drop view wthuong2'

where ReportName = N'Báo cáo tồn kho'
-----------Bảng kê phiếu xuất CCDC------------
Update sysReport set Query = N'if @@nhom=''''
begin
select mt.*, dt.*, case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt from
Mt45 mt inner join dt45 dt on mt.mt45id =dt.mt45id left join dmkh on mt.makh=dmkh.makh, dmvt v 
where dt.mavt = v.mavt and @@ps
end
else 
begin
select mt.*, dt.*,case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt from
Mt45 mt inner join dt45 dt on mt.mt45id =dt.mt45id left join dmkh on mt.makh=dmkh.makh, dmvt v 
where dt.mavt = v.mavt and dt.mavt in (select mavt from dmvt where nhom like @@nhom + ''%'')
end'
where ReportName = N'Bảng kê phiếu xuất CCDC'
------------Bảng kê phiếu nhập kho từ sản xuất----------
Update sysReport set Query = N'if @@nhom=''''
begin
select mt.mt41id, mt.mact, mt.NgayCT, mt.SoCT, mt.MaKH, mt.DiaChi, mt.MaNV,
mt.DienGiai, mt.MaNT, mt.TyGia, mt.TtienNT, mt.Ttien,mt.STT, 
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.makh) as TenKH,
mt.NhapTB, dt.DT41ID, dt.MaVT,dt.MaDVT, dt.MaKho, dt.SoLuong, dt.GiaNT, dt.Gia,dt.PsNT, dt.Ps, dt.TkCo,
dt.TkNo, dt.MaBP, dt.MaPhi, dt.MaVV, dt.Stt, dt.MaCongTrinh, dt.LotNumber, dt.ExpireDate
from Mt41 mt inner join dt41 dt on mt.mt41id =dt.mt41id left join dmkh on mt.makh=dmkh.makh 
where @@ps
end
else 
begin
select mt.mt41id, mt.mact, mt.NgayCT, mt.SoCT, mt.MaKH, mt.DiaChi, mt.MaNV,
mt.DienGiai, mt.MaNT, mt.TyGia, mt.TtienNT, mt.Ttien,mt.STT, 
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.makh) as TenKH,
mt.NhapTB, dt.DT41ID, dt.MaVT,dt.MaDVT, dt.MaKho, dt.SoLuong, dt.GiaNT, dt.Gia,dt.PsNT, dt.Ps, dt.TkCo,
dt.TkNo, dt.MaBP, dt.MaPhi, dt.MaVV, dt.Stt, dt.MaCongTrinh, dt.LotNumber, dt.ExpireDate 
from Mt41 mt inner join dt41 dt on mt.mt41id =dt.mt41id left join dmkh on mt.makh=dmkh.makh 
where @@ps and  dt.mavt in (select mavt from dmvt where nhom like @@nhom + ''%'')
end'
where ReportName = N'Bảng kê phiếu nhập kho từ sản xuất'
----------Bảng kê phiếu nhập kho-----------
Update sysReport set Query = N'select mt.MT42ID,mt.MaCT,mt.NgayCT,mt.SoCT,mt.MaKH,mt.DiaChi,mt.MaNV,mt.DienGiai,mt.MaNT,mt.TyGia,mt.TtienNT,mt.Ttien,mt.Stt,mt.NhapTB,mt.NXT,
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.makh) as TenKH,
dt.DT42ID,dt.MaVT,dt.MaDVT,dt.MaKho,dt.SoLuong,dt.GiaNT,dt.Gia,dt.PsNT,dt.Ps,dt.TkCo,dt.TkNo,dt.MaPhi,dt.MaVV,dt.MaBP,dt.Stt,dt.MaCongTrinh,dt.LotNumber,dt.ExpireDate,
case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt from 
Mt42 mt inner join dt42 dt on mt.mt42id =dt.mt42id left join dmkh on mt.makh=dmkh.makh, dmvt v
where dt.mavt = v.mavt and @@ps
order by mt.NgayCT, mt.SoCT, dt.MaKho, dt.MaVT'
where ReportName = N'Bảng kê phiếu nhập kho'
------------Bảng kê phiếu điều chuyển kho-----------
Update sysReport set Query = N'if @@nhom=''''
begin
select mt.MT44ID,mt.MaCT,mt.NgayCT,mt.SoCT,mt.MaKH,mt.DiaChi,mt.MaNV,mt.DienGiai,mt.MaNT,mt.TyGia,mt.TtienNT,mt.Ttien,mt.Stt,mt.MaKho,mt.MaKhoN,
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.makh) as TenKH,
dt.DT44ID,dt.MaVT,dt.MaDVT,dt.SoLuong,dt.GiaNT,dt.Gia,dt.PsNT,dt.Ps,dt.TkCo,dt.TkNo,dt.MaPhi,dt.MaVV,dt.MaBP,dt.Stt,dt.MaCongTrinh,dt.SoCTDT,dt.LotNumber,dt.ExpireDate,dt.MTIDDoiTru,
case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt from
Mt44 mt inner join dt44 dt on mt.mt44id =dt.mt44id left join dmkh on mt.makh=dmkh.makh, dmvt v 
where dt.mavt = v.mavt and @@ps
end
else 
begin
select mt.MT44ID,mt.MaCT,mt.NgayCT,mt.SoCT,mt.MaKH,mt.DiaChi,mt.MaNV,mt.DienGiai,mt.MaNT,mt.TyGia,mt.TtienNT,mt.Ttien,mt.Stt,mt.MaKho,mt.MaKhoN,
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.makh) as TenKH,
dt.DT44ID,dt.MaVT,dt.MaDVT,dt.SoLuong,dt.GiaNT,dt.Gia,dt.PsNT,dt.Ps,dt.TkCo,dt.TkNo,dt.MaPhi,dt.MaVV,dt.MaBP,dt.Stt,dt.MaCongTrinh,dt.SoCTDT,dt.LotNumber,dt.ExpireDate,dt.MTIDDoiTru,
case when @@lang = 1 then v.tenvt2 else v.tenvt end as tenvt from
Mt44 mt inner join dt44 dt on mt.mt44id =dt.mt44id left join dmkh on mt.makh=dmkh.makh, dmvt v 
where dt.mavt = v.mavt and dt.mavt in (select mavt from dmvt where nhom like @@nhom + ''%'')
end'
where ReportName = N'Bảng kê phiếu điều chuyển kho'
-------Báo cáo chi tiết phân bổ công cụ dụng cụ----------
Update sysReport set Query = N'declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @ngayct1=@@ngayct1
set @ngayct2=@@ngayct2
SELECT x.*,case when @@lang = 1 then vt.tenvt2 else vt.tenvt end as tenvt, TConLai as [Tiền còn lại], TPhanBo as [Tiền phân bổ trong kỳ] ,case when SLHong <> 0 then (soluong - SLConLai) else 0 end as [Số lượng hỏng trước kỳ]
FROM   (
SELECT m.ngayct as [Ngày xuất], b.mact,  m.soct, m.makh,  m.diengiai,  b.ngayct, d.mt45id, d.dt45id, 
			   b.SLHong, b.SLConLai, ps, tkno, tkcp, b.mabp, b.maphi,manv,TienHong,
               kypb,soky,d.soluong, b.TPhanBo, (SELECT Count (*)
               FROM   LSPBO tt
               WHERE  nhomdk = ''PBC''
               AND tt.soct = b.soct AND psno >= 0
               AND tt.mtiddt = b.mtiddt
			   AND tt.mtid = b.mtid
               AND tt.ngayct <= b.ngayct) as [Phân bổ lần thứ],
               TDaPhanBo as [Tiền đã phân bổ],
               TConLai,
               d.mavt,
               madvt
        FROM   mt45 m INNER JOIN dt45 d ON m.mt45id = d.mt45id 
				INNER JOIN LSPBO b ON b.mtid = m.mt45id AND b.mtiddt = d.dt45id
        WHERE  ( b.ngayct BETWEEN dbo.Layngaydauthang(@ngayct1) AND dbo.Layngayghiso(@ngayct2) )
               AND b.nhomdk = ''PBC''
               AND psno >= 0) x
       INNER JOIN dmvt vt
         ON x.mavt = vt.mavt
--WHERE  soluong >= slHong + 
ORDER  BY vt.mavt,x.ngayct, x.soct'
where ReportName = N'Báo cáo chi tiết phân bổ công cụ dụng cụ'
---------------------Bảng kê hàng nhập kho-------------------
Update sysReport set Query = N'
select x.*, case when @@lang = 1 then c.TenKH2 else c.TenKH end as TenKH, 
case when @@lang = 1 then b.TenVT2 else b.TenVT end as TenVT,
case when @@lang = 1 then  d.TenDVT2 else  d.TenDVT end as TenDVT, b.Nhom, 
case when @@lang = 1 then n.TenNhom2 else n.TenNhom end as TenNhom,
case when @@lang = 1 then h.TenVV2 else h.TenVV end as TenVV
from
(Select  mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH,
	mt.DienGiai, dt.MaKho, mt.TotalGNK Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.TienNK as [Thành tiền], dt.MaVV
from mt22 mt, dt22 dt
where mt.mt22id = dt.mt22id

union all

Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.TotalGNK Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.TienNK as [Thành tiền], dt.MaVV
from mt23 mt, dt23 dt
where mt.mt23id = dt.mt23id

union all

--Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
--	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
--	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps as [Thành tiền], dt.MaVV
--from mt41 mt, dt41 dt
--where mt.mt41id = dt.mt41id

--union

Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps as [Thành tiền], dt.MaVV
from mt42 mt, dt42 dt
where mt.mt42id = dt.mt42id

union all

Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, mt.MaKhoN, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps as [Thành tiền], dt.MaVV
from mt44 mt, dt44 dt
where mt.mt44id = dt.mt44id

union all

Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT [Thành tiền nguyên tệ], dt.Gia, dt.Ps as [Thành tiền], dt.MaVV
from mt33 mt, dt33 dt
where mt.mt33id = dt.mt33id
)x, DMKH c, DMVT b, DMDVT d, DMNhomVT n, DMVuViec h
where x.MaKH = c.MaKH and x.MaVT = b.MaVT and b.MaDVT = d.MaDVT and b.Nhom *= n.MaNhomVT and x.MaVV *= h.MaVV and [Ngày chứng từ] between @@NgayCT1 and @@NgayCT2 and @@PS
order by x.[Ngày chứng từ], x.SoCT, x.MaKho, x.MaVT'
where ReportName = N'Bảng kê hàng nhập kho'
--------Tổng hợp hàng nhập kho----------------------
Update sysReport set Query = N'select x.*, case when @@lang = 1 then dmnhomvt.tennhom2 else dmnhomvt.tennhom end as tennhom from 
(Select a.MaKho, a.MaVT, case when @@lang = 1 then  b.TenVT2 else b.TenVT end as TenVT, case when @@lang = 1 then c.TenDVT2 else c.TenDVT end as TenDVT, Sum(SoLuong) N''Số Lượng'' , Sum(PsNo) N''Tiền'', b.nhom nhom
from blvt a, dmvt b, dmdvt c
where a.MaVT = b.MaVT and b.MaDVT = c.MaDVT
and SoLuong > 0 and @@PS
group by a.MaKho, a.MaVT, b.TenVT, b.TenVT2, c.TenDVT,c.TenDVT2, b.nhom) x
left join dmnhomvt on x.nhom = dmnhomvt.manhomvt'
where ReportName = N'Tổng hợp hàng nhập kho'
---------------Thẻ Kho-------------------------------
Update sysReport set Query = N'declare @mavt varchar(16), @makho varchar(16), @ngayct1 datetime, @ngayct2 datetime
set @mavt = @@mavt
set @makho = @@makho
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)

declare @sln decimal(18,3), @slx decimal(18,3), @slton decimal(18,3), @dk decimal(18,3), @gtdk decimal(18,3), @id int

select @dk = Sum(Soluong) - Sum(SoLuong_x), @gtdk = sum(psno) - sum(psco)
	from(
	select soluong, soluong_x, psno, psco from blvt where NgayCT < @ngayct1 and MaKho=@makho and  MaVT = @mavt
	union all
	select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco from obvt where MaKho=@makho and  MaVT = @mavt
	union all
	select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco from obntxt where MaKho=@makho and  MaVT = @mavt) x

declare cur cursor for 
select blvtid, soluong, soluong_x, 0.0 as slton
from blvt
where NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and MaVT = @mavt
order by NgayCT, SoCT
create table #t
 (
	[blvtID] [int]   NULL ,	
	[sln] [decimal](18, 3) NULL ,
	[slx] [decimal](18, 3) NULL ,
	[slton] [decimal](18, 3) NULL 
) ON [PRIMARY]

insert into #t select blvtid, soluong, soluong_x, 0.0 as slton
from blvt
where NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and MaVT = @mavt
order by NgayCT, SoCT

declare @tmp decimal(18,3)
if (@dk is not null)
	set @tmp = @dk
else
	set @tmp = 0
open cur
fetch cur  into @ID,@sln,@slx,@slton
while @@fetch_status=0
begin
	set @slton=@tmp+@sln-@slx
	set @tmp=@slton
	UPDATE #t SET slton=@slton where blvtid=@id
	fetch cur  into @ID,@sln,@slx,@slton
	
end
close cur
deallocate cur

select case when @@lang = 1 then y.tenvt2 else y.tenvt end as tenvt, y.madvt,case when @@lang = 1 then z.tenkho2 else z.tenkho end as tenkho, x.* from (
                select null NgayCT, null SoCT, null TenKH, case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end as DienGiai, null DonGia,@mavt mavt,@makho makho,
		 null SoLuong, @gtdk as [Giá trị nhập], null SoLuong_X, null [Giá trị xuất], @dk as SlTon
	union all
	Select NgayCT, SoCT, case when @@lang = 1 then dmkh.TenKH2 else dmkh.TenKH end as TenKH , DienGiai, DonGia,@mavt mavt,@makho makho,
		SoLuongN = #t.sln, GiaTriN = case when PsNo > 0 then PsNo else null end,
		SoLuongX = #t.slx, GiaTriX = case when PsCo > 0 then PsCo else null end, SlTon = #t.SlTon
	from blvt, dmkh, #t
	where #t.blvtid = blvt.blvtid and blvt.MaKH *= dmkh.MaKH and NgayCT between @ngayct1 and @ngayct2 and MaKho=@makho and MaVT = @mavt) x, dmvt y,dmkho z
where x.mavt =y.mavt and x.makho=z.makho
order by NgayCT, SoCT
drop table #t'
where ReportName = N'Thẻ Kho'
-------------Tổng hợp hàng xuất kho--------------------
Update sysReport set Query = N'select x.*, case when @@lang = 1 then dmnhomvt.tennhom2 else dmnhomvt.tennhom end as tennhom from 
(Select a.MaKho, a.MaVT, 
case when @@lang = 1 then b.TenVT2 else b.TenVT end as TenVT,
case when @@lang = 1 then c.TenDVT2 else c.TenDVT end as TenDVT, Sum(SoLuong_x) N''Số Lượng'' , Sum(PsCo) N''Tiền'',b.nhom nhom
from blvt a, dmvt b, dmdvt c
where a.MaVT = b.MaVT and b.MaDVT = c.MaDVT
 	and SoLuong_x > 0 and @@ps
group by a.MaKho, a.MaVT, b.TenVT,b.TenVT2, c.TenDVT,c.TenDVT2,b.nhom) x
left join dmnhomvt on x.nhom=dmnhomvt.manhomvt'
where ReportName = N'Tổng hợp hàng xuất kho'
------------Bảng kê hàng xuất kho-----------------------
Update sysReport set Query = N'select x.*,case when @@lang = 1 then c.TenKH2 else c.TenKH end as TenKH,
case when @@lang = 1 then b.TenVT2 else b.TenVT end as TenVT, 
case when @@lang = 1 then d.TenDVT2 else d.TenDVT end as TenDVT, b.Nhom, 
case when @@lang = 1 then n.TenNhom2 else n.TenNhom end as TenNhom, h.TenVV
from
(Select mt.NgayCT as [Ngày chứng từ], mt.MaCT, mt.SoCT, mt.MaKH,
	mt.DienGiai, dt.MaKho, mt.Ttien as [Thành tiền], dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT TienNT, dt.Gia, dt.Ps Tien, dt.MaVV
from mt24 mt, dt24 dt
where mt.mt24id *= dt.mt24id
union all
Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT TienNT, dt.Gia, dt.Ps Tien, dt.MaVV
from mt32 mt, dt32 dt
where mt.mt32id *= dt.mt32id
union all
Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT TienNT, dt.Gia, dt.Ps Tien, dt.MaVV
from mt43 mt, dt43 dt
where mt.mt43id *= dt.mt43id
union all
Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, mt.MaKho MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT TienNT, dt.Gia, dt.Ps Tien, dt.MaVV
from mt44 mt, dt44 dt
where mt.mt44id *= dt.mt44id
union all
Select mt.NgayCT, mt.MaCT, mt.SoCT, mt.MaKH, 
	mt.DienGiai, dt.MaKho, mt.Ttien, dt.MaVT,
	dt.SoLuong, dt.GiaNT, dt.PsNT TienNT, dt.Gia, dt.Ps Tien, dt.MaVV
from mt45 mt, dt45 dt
where mt.mt45id *= dt.mt45id
)x, DMKH c, DMVT b, DMDVT d, DMNhomVT n, DMVuViec h
where x.MaKH = c.MaKH and x.MaVT = b.MaVT and b.MaDVT = d.MaDVT and b.Nhom *= n.MaNhomVT and x.MaVV *= h.MaVV and [Ngày chứng từ] between @@NgayCT1 and @@NgayCT2 and @@PS
order by x.[Ngày chứng từ], x.SoCT, x.MaKho, x.MaVT'
where ReportName = N'Bảng kê hàng xuất kho'

----------------------Bảng giá trung bình tháng-----------------------
Update sysReport set Query = N'select a.MaKho, a.MaVT, case when @@lang = 1 then b.TenVT2 else b.TenVT end as TenVT, 
case when @@lang = 1 then c.TenDVT2 else c.TenDVT end as TenDVT, a.DonGia
from BangGiaTB a, DMVT b, DMDVT c
where a.MaVT = b.MaVT and b.MaDVT = c.MaDVT and month(a.NgayCT) = @@Thang and @@ps'
where ReportName = N'Bảng giá trung bình tháng'
---------------------Sổ chi tiết vật tư-----------------
Update sysReport set Query = N'declare @ngayct1 datetime, 
		@ngayct2 datetime
set @ngayct1 = @@ngayct1
set @ngayct2 = dateadd(hh,23,@@ngayct2)

declare @sln decimal(28,6),
		@gtnhap decimal(28,6),
		@slx decimal(28,6), 
		@gtxuat decimal(28,6),
		@slton decimal(28,6),
		@gtton decimal(28,6), 
		@id int,
		@mavt [varchar](16), 
		@makho [varchar](16),
		@tmp decimal(28,6), 
		@tmp1 decimal(28,6),
		@mavtLoop [varchar](16), 
		@makhoLoop [varchar](16)
				
DECLARE @Ton TABLE
(
  NgayCT smalldatetime,
  MACT nvarchar(512),
  MTID uniqueidentifier,
  SoCT [nvarchar](512),
  TenKH [nvarchar](512),
  DienGiai [nvarchar](512),
  DonGia [decimal](28, 6),
  mavt [varchar](16),
  makho [varchar](16),
  SoLuong [decimal](28, 6),
  gtn [decimal](28, 6),
  SoLuong_X [decimal](28, 6),
  gtx [decimal](28, 6),
  SlTon [decimal](28, 6),
  gtt [decimal](28, 6)
)

DECLARE @t TABLE
(
 [blvtID] [int]   NULL , 
 [sln] [decimal](28, 6) NULL ,
 [gtnhap] [decimal](28, 6) NULL ,
 [slx] [decimal](28, 6) NULL ,
 [gtxuat] [decimal](28, 6) NULL ,
 [slton] [decimal](28, 6) NULL ,
 [gtton] [decimal](28, 6) NULL ,
 --mavt [varchar](16), 
 makho [varchar](16)
)

-- Lấy giá trị tồn kho
insert into @Ton(NgayCT, MACT, MTID, SoCT, TenKH, DienGiai, DonGia, mavt, makho, SoLuong, gtn, SoLuong_X, gtx, SlTon, gtt)
select null, null, null, null , null , case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end, null,
		MaVT, MaKho, null, null, null , null , 
		Sum(Soluong) - Sum(SoLuong_x), sum(psno) - sum(psco)
 from(
 select soluong, soluong_x, psno, psco, MaVT, MaKho from blvt t where NgayCT < @ngayct1 and @@ps
 union
 select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco, MaVT, MaKho from obvt t where @@ps
 union
 select soluong, 0.0 as soluong_x, dudau as psno, 0.0 as psco, MaVT, MaKho from obntxt t where @@ps
 ) x
 group by MaKho, MaVT

-- Lấy số phát sinh
insert into @t select blvtid, soluong,psno, soluong_x,psco, 0.0 as slton, 0.0 as gtton, makho
from blvt t
where NgayCT between @ngayct1 and @ngayct2 and @@ps
order by makho, mavt, NgayCT, SoCT

-- Tính toán lại giá trị tồn kho
declare cur cursor for 
select blvtid, soluong,psno, soluong_x,psco, 0.0 as slton, 0.0 as gtton, mavt, makho
from blvt t
where NgayCT between @ngayct1 and @ngayct2 and @@ps
order by makho, mavt, NgayCT, SoCT

open cur
fetch cur  into @ID,@sln,@gtnhap, @slx,@gtxuat, @slton, @gtton, @mavt, @makho

set @mavtLoop = ''''
set @makhoLoop = ''''

while @@fetch_status=0
begin

 -- Tính qua vật tư khác hoặc kho khác
 if @makhoLoop <> @makho or @mavtLoop <> @mavt 
 BEGIN
	 set @makhoLoop = @makho
	 set @tmp1 = 0
	 
	 set @mavtLoop = @mavt
	 set @tmp = 0
	 
	 select @tmp1 = isnull(gtt,0), @tmp = isnull(SlTon,0) from @Ton where MaKho = @makho and MaVT = @mavt
 END

 set @slton=@tmp+@sln-@slx
 set @tmp=@slton
 set @gtton=@tmp1+@gtnhap-@gtxuat
 set @tmp1=@gtton
 
 UPDATE @t SET slton=@slton, gtton=@gtton where blvtid=@id
 fetch cur  into @ID,@sln,@gtnhap, @slx,@gtxuat, @slton, @gtton, @mavt, @makho
 
end
close cur
deallocate cur

-- Lấy kết quả
select case when @@lang = 1 then y.tenvt2 else y.tenvt end as tenvt, case when ngayCT is not null then y.madvt else null end as madvt,
case when @@lang = 1 then z.tenkho2 else z.tenkho end as tenkho, x.* 
from (
	-- Bảng các vật tư có giá trị tồn
	select NgayCT, MACT, MTID, SoCT, TenKH, DienGiai, DonGia,
			mavt, makho, SoLuong, gtn as [Giá trị nhập], SoLuong_X, gtx as [Giá trị xuất], 
			SlTon, gtt as [Giá trị tồn]
	 from @Ton
	 
	union
	 
	 -- Insert dòng tồn đầu kỳ = 0 cho các vật tư không có giá trị tồn
	 Select distinct null, null, null, null, null ,  case when @@lang = 1 then N''Beginning quantity'' else N''Tồn đầu kỳ'' end, null, mavt, makho,
	  null, null, null, null, 0, 0
	 from blvt t
	 where t.NgayCT between @ngayct1 and @ngayct2 and @@ps and
		   (t.MaKho not in (select makho from @Ton)
		   or t.Mavt not in (select mavt from @Ton))
	 
	union
	 
	-- Bảng nhập xuất
	Select NgayCT, MACT, MTID, SoCT, case when @@lang = 1 then dmkh.TenKH2 else dmkh.TenKH end as TenKH , DienGiai, DonGia, t.mavt, tmp.makho,
	  tmp.sln, case when PsNo > 0 then PsNo else null end,
	  tmp.slx, case when PsCo > 0 then PsCo else null end, tmp.SlTon, tmp.gtton
	 from blvt t, dmkh, @t tmp
	 where tmp.blvtid = t.blvtid and t.MaKH *= dmkh.MaKH and 
			NgayCT between @ngayct1 and @ngayct2 and @@ps
 ) x, dmvt y,dmkho z
where x.mavt =y.mavt and x.makho=z.makho
order by x.makho, x.mavt, NgayCT, SoCT
'
where ReportName = N'Sổ chi tiết vật tư'


-----------Sổ chi tiết công nợ khách hàng------(BLTK)-------
Update sysReport set Query = N'declare @kh varchar(16)
declare @tkrp varchar(16)
declare @nocodk bit
declare @nocock bit
set @tkrp=@@TK
set @kh=@@MaKH
declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @NgayCt1=cast(@@ngayct1 as datetime)
set @NgayCt2=cast(@@ngayct2 as datetime)
declare @dauky float, @daukynt float
--tìm số dư đầu kỳ=Số dư đầu năm + số phát sinh trước ngàyCt1
	
	declare @daunam float, @daunamnt float
	declare @count1 int 
	--Số phát inh đầu năm
	set @daunamnt=(SELECT sum(Dunont-Ducont) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunam=(SELECT sum(Duno-Duco) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @count1=(select count(*) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunamnt = case when @count1<>0 then @daunamnt else 0 end
	set @daunam = case when @count1<>0 then @daunam else 0 end
	set @daukynt=(select sum(psNont)-sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @dauky=(select sum(psNo)-sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @daukynt=case when @count1>0 then @daukynt else 0 end
	set @dauky=case when @count1>0 then @dauky else 0 end

	set @daukynt=@daukynt + @daunamnt
	set @dauky=@dauky + @daunam
	set @nocodk = case when @dauky>=0 then 1 else 0 end

--tìm số dư cuối kỳ
	declare @psNo float, @psNont float
	declare @psCo float, @psCont float
	declare @cuoiky float, @cuoikynt float
	set @psNont=(select sum(psNont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCont=(select sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNo=(select sum(psNo)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCo=(select sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNont=case when @count1>0 then @psNont else 0 end
	set @psCont=case when @count1>0 then @psCont else 0 end
	set @psNo=case when @count1>0 then @psNo else 0 end
	set @psCo=case when @count1>0 then @psCo else 0 end
	set @cuoikynt=@daukynt + @psNont-@psCont
	set @cuoiky=@dauky + @psNo-@psCo
	set @nocock = case when @cuoiky>=0 then 1 else 0 end

--Lấy số phát sinh

declare @nophatsinh float, @nophatsinhnt float
declare @phatsinhco float, @phatsinhcont float
select @nophatsinhnt=sum(psnont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhcont=sum(pscont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @nophatsinh=sum(psno) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhco=sum(psco) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps

select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Beginning amount'' else N''Số dư đầu kỳ'' end as diengiai,
null as tkdu,psnont=case when @nocodk=0 then 0 else @daukynt end,psno=case when @nocodk=0 then 0 else @dauky end,
pscont=case when @nocodk=0 then abs(@daukynt) else 0 end,psco=case when @nocodk=0 then abs(@dauky) else 0 end, null as makh, null as tenkh, 0 as Stt
union  all
select ngayCt,MTID, maCT,SoCt,diengiai,tkdu,psnont,psno,pscont,psco ,maKH, 
(select case when @@lang = 1 then dm.TenKH2 else dm.TenKH end as tenkh from dmkh dm where dm.makh = bltk.maKH) as tenkh ,1 from bltk
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Total of arinsing'' else N''Tổng phát sinh'' end as diengiai,
null as tkdu,@nophatsinhnt as sopsnt,@nophatsinh as sops,@phatsinhcont as pscont,@phatsinhco as psco, null as makh, null as tenkh,2
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Closing amount'' else N''Số dư cuối kỳ'' end as diengiai,
null as tkdu,sopsnt=case when @nocock=0 then 0 else @cuoikynt end,sops=case when @nocock=0 then 0 else @cuoiky end,
pscont=case when @nocock=0 then abs(@cuoikynt) else 0 end, psco=case when @nocock=0 then abs(@cuoiky) else 0 end, null as makh, null as tenkh, 3
order by stt,ngayCt, soct, tkdu'
where ReportName = N'Sổ chi tiết công nợ khách hàng'
-----------------------Bảng kê chi tiết công nợ phải thu theo hóa đơn---------------------
Update sysReport set Query = N'select hd.[NgayCT], hd.[SoCT], hd.[SoHoaDon], hd.[MaKH],case when @@lang = 1 then kh.TenKH2 else kh.TenKH end as TenKH, hd.[NgayTT], hd.[DienGiai], hd.[TKNO], hd.[MaNT], hd.[TyGia], hd.[Ttien], hd.[TtienNT], hd.[ConLaiNT], hd.[ConLai], hd.[HanTT],
mt.[SoCt] as [Số CT TT], mt.[NgayCt] as [Ngày CT TT], mt.[DienGiai] as [Diễn giải TT], mt.[MaNT] as [Mã NT TT], mt.[TyGia] as [Tỷ giá TT], 
tt.[TTNT], tt.[TT], tt.[CLTG], tt.[MaVV], tt.[MaBP], tt.[MaPhi], tt.mt31id
from wHoaDonBan hd, DT34 tt, MT34 mt, DMKH kh
where hd.mt31id = tt.mt31id and mt.mt34id = tt.mt34id and hd.MaKH = kh.MaKH and (@@logic = 1 or (@@logic = 0 and (hd.conlai <> 0 or hd.conlaiNT <> 0))) and @@ps
union all
select hd.[NgayCT], hd.[SoCT], hd.[SoHoaDon], hd.[MaKH], case when @@lang = 1 then kh.TenKH2 else kh.TenKH end as TenKH, hd.[NgayTT], hd.[DienGiai], hd.[TKNO], hd.[MaNT], hd.[TyGia], hd.[Ttien], hd.[TtienNT], hd.[ConLaiNT], hd.[ConLai], hd.[HanTT],
'''',null,'''','''',0,0,0,0,'''','''','''',null
from wHoaDonBan hd, DMKH kh
where hd.MaKH = kh.MaKH and hd.ConLai = hd.TTien and hd.ConLaiNT = hd.TTienNT and @@ps'
where ReportName = N'Bảng kê chi tiết công nợ phải thu theo hóa đơn'
---------------------Bảng cân đối phát sinh công nợ-------------------------
Update sysReport set Query = N'declare @tk nvarchar(16)
declare @ngayCt datetime
declare @ngayCt1 datetime
declare @dk nvarchar(256)
declare @sql nvarchar (4000)
set @tk=@@TK
set @ngayCt=@@ngayct1
set @ngayCt1=dateadd(hh,23,@@ngayct2)
--lấy số dư đầu
set @sql=''create view wsodu as select makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by makh''
exec (@sql)
set @sql=''create view wsotk as select makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by makh ''
exec (@sql)
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wdudau as select makh,
nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,
codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,
0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi from wG1 group by makh''

exec (@sql)

--lấy số phát sinh

set @sql=''create view wsops as select makh,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
sum(psnont)as psnont,sum(psno)as psno, sum(pscont) as pscont, sum(psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) and cast('''''' + convert(nvarchar,dateadd(d,1,@ngayCt1)) + '''''' as datetime) and '' + @@ps + '' group by makh''

exec (@sql)
--lấy số dư cuối
set @sql =''create view wG2 as select * from wdudau union all select * from wsops''
exec (@sql)

set @sql=''create view wkq as 
select makh, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
from wG2  group by makh ''
exec (@sql)
select a.makh,case when @@lang = 1 then b.tenkh2 else b.tenkh end as tenkh,a.nodaunt as [Nợ đầu nguyên tệ],a.nodau as [Nợ đầu],a.codaunt as [Có đầu nguyên tệ],a.codau as [Có đầu],a.psnont,a.psno,a.pscont,a.psco,a.nocuoint as [Nợ cuối nguyên tệ], a.nocuoi as [Nợ cuối],a.cocuoint as [Có cuối nguyên tệ],a.cocuoi as [Có cuối] from wkq a left join dmkh b on  a.makh=b.makh
where a.nodau <> 0 or a.codau <> 0 or a.psno <>0 or a.psco <> 0 or a.nocuoi <>0 or a.cocuoi <>0

drop view wsodu
drop view wsotk
drop view wG1
drop view wsops
drop view wdudau
drop view wG2
drop view wkq'
where ReportName = N'Bảng cân đối phát sinh công nợ'
---------------------Tổng hợp số dư công nợ cuối kỳ--------------
Update sysReport set Query = N'declare @tk nvarchar(16)
declare @tkdu nvarchar(16)
declare @ngayCt datetime
declare @dk nvarchar(256)
declare @sql nvarchar (4000)
set @tk=@@TK
set @tkdu=@@TKDu
set @ngayCt=@@NgayCt
set @sql=''create view wsodu as select makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by makh''
exec (@sql)
set @sql=''create view wsotk as select makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and ngayct<=cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime)'' + '' and left(isnull(TKDu,''''''''),len('''''' + @tkdu + ''''''))=''''''+ @tkdu + '''''' group by makh ''
exec (@sql)
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wducuoi as select makh,
dunont=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
duno=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,
ducont=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
duco=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end
from wG1 group by makh''
exec (@sql)

select wducuoi.*, case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh from wducuoi,dmkh where wducuoi.makh *= dmkh.makh 
and (duno <>0 or duco <>0)
drop view wsodu
drop view wsotk
drop view wG1
drop view wducuoi'
where ReportName = N'Tổng hợp số dư công nợ cuối kỳ'
------------Tổng hợp công nợ phải thu------------
Update sysReport set Query = N'declare @tk nvarchar(16),@ngayCt datetime,@ngayCt1 datetime, @sql nvarchar (4000)
set @tk=@@TK
set @ngayCt=@@ngayct1
set @ngayCt1=dateadd(hh,23,@@ngayct2)

if exists (select distinct name from sys.all_views where name = ''wsodu'') drop view wsodu 
if exists (select distinct name from sys.all_views where name = ''wsotk'') drop view wsotk
if exists (select distinct name from sys.all_views where name = ''wG1'') drop view wG1
if exists (select distinct name from sys.all_views where name = ''wsops'') drop view wsops
if exists (select distinct name from sys.all_views where name = ''wdudau'') drop view wdudau
if exists (select distinct name from sys.all_views where name = ''wG2'') drop view wG2
if exists (select distinct name from sys.all_views where name = ''wkq'') drop view wkq

--lấy số dư đầu bảng OBKH
set @sql=''create view wsodu as select tk, makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư đầu bảng BLTK
set @sql=''create view wsotk as select tk, makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by tk, makh ''
exec (@sql)
--Lấy số dư đầu kỳ từ hai bảng OBKH và BLTK
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wdudau as select tk, makh,nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi from wG1 group by tk, makh''
exec (@sql)
--lấy số phát sinh trong kỳ
set @sql=''create view wsops as select tk, makh,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
sum(psnont)as psnont,sum(psno)as psno, sum(pscont) as pscont, sum(psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) and cast('''''' + convert(nvarchar, @ngayCt1) + '''''' as datetime) and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư cuối
set @sql =''create view wG2 as select * from wdudau union all select * from wsops''
exec (@sql)
set @sql=''create view wkq as 
select tk, makh, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
from wG2  group by tk, makh ''
exec (@sql)
select a.makh as mkh,case when @@lang = 1 then b.tenkh2 else b.tenkh end as tkh, a.tk,
a.nodau as dndk,a.codau as dcdk,a.psno as psn,a.psco as psc,a.nocuoi as dnck,a.cocuoi as dcck,
a.nodaunt as dndkNT,a.codaunt as dcdkNT,a.psnont as psnNT,a.pscont as pscNT,a.nocuoint as dnckNT, a.cocuoint as dcckNT
from wkq a left join dmkh b on  a.makh=b.makh
drop view wsodu
drop view wsotk
drop view wG1
drop view wsops
drop view wdudau
drop view wG2
drop view wkq'
where ReportName = N'Tổng hợp công nợ phải thu'

-------------------Tổng hợp công nợ phải trả---------------
Update sysReport set Query = N'declare @tk nvarchar(16),@ngayCt datetime,@ngayCt1 datetime, @sql nvarchar (4000)
set @tk=@@TK
set @ngayCt=@@ngayct1
set @ngayCt1=dateadd(hh,23,@@ngayct2)

if exists (select distinct name from sys.all_views where name = ''wsodu'') drop view wsodu 
if exists (select distinct name from sys.all_views where name = ''wsotk'') drop view wsotk
if exists (select distinct name from sys.all_views where name = ''wG1'') drop view wG1
if exists (select distinct name from sys.all_views where name = ''wsops'') drop view wsops
if exists (select distinct name from sys.all_views where name = ''wdudau'') drop view wdudau
if exists (select distinct name from sys.all_views where name = ''wG2'') drop view wG2
if exists (select distinct name from sys.all_views where name = ''wkq'') drop view wkq

--lấy số dư đầu bảng OBKH
set @sql=''create view wsodu as select tk, makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư đầu bảng BLTK
set @sql=''create view wsotk as select tk, makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by tk, makh ''
exec (@sql)
--Lấy số dư đầu kỳ từ hai bảng OBKH và BLTK
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wdudau as select tk, makh,nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi from wG1 group by tk, makh''
exec (@sql)
--lấy số phát sinh trong kỳ
set @sql=''create view wsops as select tk, makh,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
sum(psnont)as psnont,sum(psno)as psno, sum(pscont) as pscont, sum(psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) and cast('''''' + convert(nvarchar, @ngayCt1) + '''''' as datetime) and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư cuối
set @sql =''create view wG2 as select * from wdudau union all select * from wsops''
exec (@sql)
set @sql=''create view wkq as 
select tk, makh, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
from wG2  group by tk, makh ''
exec (@sql)
select a.makh as mncc,case when @@lang = 1 then b.tenkh2 else b.tenkh end as tncc, a.tk,
a.nodau as dndk,a.codau as dcdk,a.psno as psn,a.psco as psc,a.nocuoi as dnck,a.cocuoi as dcck,
a.nodaunt as dndkNT,a.codaunt as dcdkNT,a.psnont as psnNT,a.pscont as pscNT,a.nocuoint as dnckNT, a.cocuoint as dcckNT
from wkq a left join dmkh b on  a.makh=b.makh
drop view wsodu
drop view wsotk
drop view wG1
drop view wsops
drop view wdudau
drop view wG2
drop view wkq'
where ReportName = N'Tổng hợp công nợ phải trả'
--------------------Bảng kê hóa đơn bán hàng-----------------
Update sysReport set Query = N'	select mt.ngayct,mt.soct,mt.sohoadon,mt.DienGiai,mt.MaKH,
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as [Tên khách hàng],mt.tkNo, dt.mavt,
case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end as [Tên vật tư],dt.madvt,dt.makho,
dt.soluong,dt.Giant,dt.gia,dt.psnt,dt.ps, v.ThueNT as ThueNT,v.Thue as Thue, dt.cknt,dt.ck,dt.psnt+v.ThueNT-dt.cknt as [Tổng tiền nt], dt.ps+v.Thue-dt.ck as [Tổng tiền],dt.giavon,dt.tienvon, dt.GhiChu
 	from mt32 mt, dt32 dt,dmkh,dmvt, vatout v
	where  mt.mt32id=dt.mt32id and mt.makh=dmkh.makh and dt.mavt=dmvt.mavt and dt.mt32id *= v.mtid and dt.dt32id *= v.mtiddt and @@ps
order by mt.ngayct,mt.soct,dt.stt'
where ReportName = N'Bảng kê hóa đơn bán hàng'
--------------------Bảng kê phiếu nhập hàng bán trả lại------------
Update sysReport set Query = N'Select mt.*, dt.*, v.ThueNT as ThueNT, v.Thue as Thue, 
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh, 
case when @@lang = 1 then vt.tenvt2 else vt.tenvt end as tenvt
From MT33 mt, DT33 dt, dmkh, VatOut v, dmvt vt 
where mt.mt33id = dt.mt33id 
and dt.mt33id = v.mtid and dt.dt33id = v.mtiddt
and mt.makh = dmkh.makh
and vt.mavt = dt.mavt and @@ps'
where ReportName = N'Bảng kê phiếu nhập hàng bán trả lại'
-------------------Bảng kê hóa đơn dịch vụ----------------------
Update sysReport set Query = N'Select mt.*, dt.*, v.ThueNT as ThueNT, v.Thue as Thue
From MT31 as mt, DT31 as dt, VatOut v
where mt.mt31id = dt.mt31id 
and dt.mt31ID *= v.mtid and dt.dt31id *= v.mtiddt
and @@ps'
where ReportName = N'Bảng kê hóa đơn dịch vụ'
------------------Báo cáo doanh số bán hàng---------------------
Update sysReport set Query = N'select x. ngayct, x.sohoadon, x.makh, 
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as tenkh, x.mavt, 
(select case when @@lang = 1 then k.tenvt2 else k.tenvt end from dmvt k where k.mavt = x.mavt) as tenvt, x.soluong, x.gia, x.ps, x.ck, x.ps - x.ck as [Doanh số], vo.thue, x.mabp, b.tenbp from
(select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, mabp
from mt32, dt32, dmvt v
where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
union all
select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, mabp
from mt33, dt33, dmvt v
where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt
union all
select dt31id, ngayhd, sohoadon, makhct, tenkhct,'''', diengiaict, 0.0, 0.0, ps, case when ttienh <> 0 then tck*ps/ttienh else 0 end, mabp
from mt31, dt31
where mt31.mt31id = dt31.mt31id) x, vatout vo, dmbophan b
where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps
order by x.ngayct, x.sohoadon, x.mavt'
where ReportName = N'Báo cáo doanh số bán hàng'
-----------------Báo cáo lãi gộp hàng hóa----------------
Update sysReport set Query = N'select x.ngayct, x.sohoadon, x.makh, 
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as tenkh,
x.mavt, x.tenvt, x.soluong, x.gia, x.ps, x.ck, sltl as [Số lượng trả lại], 
 gttl as [Giá trị trả lại], x.ps - x.ck as [Doanh số], vo.thue, x.giavon, x.tienvon,
  x.ps - x.ck - x.tienvon as [Lãi gộp], x.mabp, b.tenbp, x.loaivt, 
  case when x.loaivt=1 then case when @@lang = 1 then N''Goods'' else N''Hàng hóa'' end
	when x.loaivt=2 then case when @@lang = 1 then N''Materials'' else N''Nguyên liệu'' end
	when x.loaivt=3 then case when @@lang = 1 then N''Reference tool'' else N''Công cụ dụng cụ'' end 
	when x.loaivt=4 then case when @@lang = 1 then N''Final product'' else N''The Thành phẩm'' end
	when x.loaivt=5 then case when @@lang = 1 then N''Fixed assets'' else N''TSCĐ'' end
	when x.loaivt=6 then case when @@lang = 1 then N''Services'' else N''Dịch vụ'' end 
	else '''' end N''Tên loại vật tư'' 
from ( select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, 
				case when @@lang = 1 then tenvt2 else tenvt end as tenvt, 
				soluong, gia, ps, ck, giavon, tienvon, mabp, 
				0 ''sltl'', 0 ''gttl'', v.loaivt 
				from mt32, dt32, dmvt v 
				where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt 
		union all 
				select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, 
				case when @@lang = 1 then tenvt2 else tenvt end as tenvt, 
				-soluong, gia, -ps, 0.0, giavon, -tienvon, mabp, 
				soluong ''sltl'', ps ''gttl'', v.loaivt from mt33, dt33, dmvt v 
				where mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt ) x, vatout vo, dmbophan b 
where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps 
order by x.ngayct, x.sohoadon, x.mavt'
where ReportName = N'Báo cáo lãi gộp hàng hóa'
------------------------Báo cáo chi tiết chênh lệch giá vốn và giá bán--------------
Update sysReport set Query = N'BEGIN TRY
	select x.mavt, 
	(select case when @@lang = 1 then k.tenvt2 else k.tenvt end from dmvt k where k.mavt = x.mavt) as tenvt, SUM(x.soluong) as [Số lượng tiêu thụ], SUM(x.tienvon) / SUM(x.soluong) as [Đơn giá (Giá vốn)], SUM(x.tienvon) as [Giá vốn], SUM(x.ps - x.ck) / SUM(x.soluong) as [Đơn giá (Giá bán)], SUM(x.ps - x.ck) as [Giá bán], SUM(x.ps - x.ck - x.tienvon) as [Chênh lệch],  x.loaiVT
	from (select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, giavon, tienvon, mabp, loaiVT
		from mt32, dt32, dmvt v
		where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
		union all
		select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, giavon, -tienvon, mabp, loaiVT
		from mt33, dt33, dmvt v
		where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt) x, 
		vatout vo, dmbophan b
	where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps
	Group by x.mavt, x.tenvt, x.loaiVT
	order by x.mavt
END TRY
BEGIN CATCH
-- Divide by zero
if ERROR_NUMBER() = 8134
BEGIN
	select x.mavt, 
	(select case when @@lang = 1 then k.tenvt2 else k.tenvt end from dmvt k where k.mavt = x.mavt) as tenvt,
	 SUM(x.soluong) as [Số lượng tiêu thụ], 0 as [Đơn giá (Giá vốn)], SUM(x.tienvon) as [Giá vốn], 0 as [Đơn giá (Giá bán)], SUM(x.ps - x.ck) as [Giá bán], SUM(x.ps - x.ck - x.tienvon) as [Chênh lệch],  x.loaiVT
	from (select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, giavon, tienvon, mabp, loaiVT
		from mt32, dt32, dmvt v
		where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
		union all
		select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, giavon, -tienvon, mabp, loaiVT
		from mt33, dt33, dmvt v
		where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt) x, 
		vatout vo, dmbophan b
	where dt32id *= vo.mtiddt and x.mabp *= b.mabp and @@ps
	Group by x.mavt, x.tenvt, x.loaiVT
	order by x.mavt
END

END CATCH
'
where ReportName = N'Báo cáo chi tiết chênh lệch giá vốn và giá bán'
-----------------------Báo cáo doanh số bán hàng theo nhân viên---------------------
Update sysReport set Query = N'select x. ngayct, x.sohoadon, x.makh, 
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as tenkh, 
x.mavt, 
(select case when @@lang = 1 then k.tenvt2 else k.tenvt end from dmvt k where k.mavt = x.mavt) as tenvt, 
x.soluong, x.gia, x.ps, x.ck, x.ps - x.ck as [Doanh số], vo.thue, x.saleman, (select case when @@lang = 1 then tenkh2 else tenkh end as tenkh from dmkh where x.saleman = dmkh.makh ) as sales
from
	(select dt32id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, ck, saleman
	from mt32, dt32, dmvt v
	where mt32.mt32id = dt32.mt32id and dt32.mavt = v.mavt
union all
	select dt33id, ngayct, sohoadon, makh, tenkh, v.mavt, tenvt, -soluong, gia, -ps, 0.0, saleman
	from mt33, dt33, dmvt v
	where  mt33.mt33id = dt33.mt33id and dt33.mavt = v.mavt
union all
	select dt43id, ngayct, soct, makh, tenkh, v.mavt, tenvt, soluong, gia, ps, 0.0, saleman
	from mt43, dt43, dmvt v
	where mt43.mt43id = dt43.mt43id and dt43.mavt = v.mavt and (left(tkno,3) = ''131'' or left(tkno,3) = ''111'' )
union all
select dt31id, ngayct, sohoadon, makhct, tenkhct,'''', diengiaict, 0.0, 0.0, ps, case when ttienh <> 0 then tck*ps/ttienh else 0 end, saleman
from mt31, dt31
where mt31.mt31id = dt31.mt31id) x, vatout vo, dmkh b
where dt32id *= vo.mtiddt and x.saleman *= b.makh and @@ps
order by x.ngayct, x.sohoadon, x.mavt'
where ReportName = N'Báo cáo doanh số bán hàng theo nhân viên'
----------- Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng-----------
Update sysReport set Query = N'declare @loaiVt int
set @loaiVt = @@Loaivt
select x.ngayct, x.makh as MaKH, 
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as TenKH, 
x.mavt as MaVT, 
(select case when @@lang = 1 then k.tenvt2 else k.tenvt end from dmvt k where k.mavt = x.mavt) as TenVT,
x.soluong as SoLuong, x.ps as DoanhThu, 
sltl as [Số lượng trả lại], x.ck as ChiecKhau, x.ps - x.ck as [Doanh thu thuần], 
   x.tienvon, x.ps - x.ck - x.tienvon as [Lãi gộp], x.loaivt, x.IsNCC, x.IsKH, x.IsNV, x.MaNT, x.TenDVT
from ( 
 select dt32id, ngayct,  mt32.makh, mt32.tenkh, kh.IsNCC, kh.IsKH, kh.IsNV, v.mavt, tenvt, soluong, ps, ck,  tienvon,  0 ''sltl'', v.loaivt, mt32.MaNT, 
 case when @@lang = 1 then dvt.TenDVT2 else dvt.TenDVT end as TenDVT
   from mt32, dt32, dmvt v , dmkh kh, DMDVT dvt
   where mt32.mt32id = dt32.mt32id and dt32.mavt *= v.mavt and mt32.makh *= kh.makh and v.MaDVT = dvt.MaDVT
 union all 
 select dt33id, ngayct, mt33.makh, mt33.tenkh, kh.IsNCC, kh.IsKH, kh.IsNV, v.mavt, tenvt, -soluong, -ps, 0.0,  -tienvon,  soluong ''sltl'', v.loaivt , mt33.MaNT, 
 case when @@lang = 1 then dvt.TenDVT2 else dvt.TenDVT end as TenDVT
   from mt33, dt33, dmvt v , dmkh kh, DMDVT dvt
   where mt33.mt33id = dt33.mt33id and dt33.mavt *= v.mavt and mt33.makh *= kh.makh and v.MaDVT = dvt.MaDVT) x
where (x.loaivt = @loaiVt or @loaiVt = 0) and @@ps'
where ReportName = N'Báo cáo tổng hợp bán hàng theo khách hàng và mặt hàng'
-----------------------------Sổ chi tiết công nợ nhà cung cấp----------------------
Update sysReport set Query = N'declare @kh varchar(16)
declare @tkrp varchar(16)
declare @nocodk bit
declare @nocock bit
set @tkrp=@@TK
set @kh=@@MaKH
declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @NgayCt1=cast(@@ngayct1 as datetime)
set @NgayCt2=cast(@@ngayct2 as datetime)
declare @dauky float, @daukynt float
--tìm số dư đầu kỳ=Số dư đầu năm + số phát sinh trước ngàyCt1
	
	declare @daunam float, @daunamnt float
	declare @count1 int 
	--Số phát inh đầu năm
	set @daunamnt=(SELECT sum(Dunont-Ducont) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunam=(SELECT sum(Duno-Duco) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @count1=(select count(*) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunamnt = case when @count1<>0 then @daunamnt else 0 end
	set @daunam = case when @count1<>0 then @daunam else 0 end
	set @daukynt=(select sum(psNont)-sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @dauky=(select sum(psNo)-sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @daukynt=case when @count1>0 then @daukynt else 0 end
	set @dauky=case when @count1>0 then @dauky else 0 end

	set @daukynt=@daukynt + @daunamnt
	set @dauky=@dauky + @daunam
	set @nocodk = case when @dauky>=0 then 1 else 0 end

--tìm số dư cuối kỳ
	declare @psNo float, @psNont float
	declare @psCo float, @psCont float
	declare @cuoiky float, @cuoikynt float
	set @psNont=(select sum(psNont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCont=(select sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNo=(select sum(psNo)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCo=(select sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNont=case when @count1>0 then @psNont else 0 end
	set @psCont=case when @count1>0 then @psCont else 0 end
	set @psNo=case when @count1>0 then @psNo else 0 end
	set @psCo=case when @count1>0 then @psCo else 0 end
	set @cuoikynt=@daukynt + @psNont-@psCont
	set @cuoiky=@dauky + @psNo-@psCo
	set @nocock = case when @cuoiky>=0 then 1 else 0 end

--Lấy số phát sinh

declare @nophatsinh float, @nophatsinhnt float
declare @phatsinhco float, @phatsinhcont float
select @nophatsinhnt=sum(psnont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhcont=sum(pscont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @nophatsinh=sum(psno) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhco=sum(psco) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps

select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Beginning amount'' else N''Số dư đầu kỳ'' end as diengiai,
null as tkdu,psnont=case when @nocodk=0 then 0 else @daukynt end,psno=case when @nocodk=0 then 0 else @dauky end,
pscont=case when @nocodk=0 then abs(@daukynt) else 0 end,psco=case when @nocodk=0 then abs(@dauky) else 0 end, null as makh, null as tenkh, 0 as Stt
union  all
select ngayCt,MTID, maCT,SoCt,diengiai,tkdu,psnont,psno,pscont,psco ,maKH,(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = b.makh) as TenKH, 1 from bltk b
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Total of arinsing'' else N''Tổng phát sinh'' end as diengiai,
null as tkdu,@nophatsinhnt as sopsnt,@nophatsinh as sops,@phatsinhcont as pscont,@phatsinhco as psco, null as makh, null as tenkh,2
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Closing amount'' else N''Số dư cuối kỳ'' end as diengiai,
null as tkdu,sopsnt=case when @nocock=0 then 0 else @cuoikynt end,sops=case when @nocock=0 then 0 else @cuoiky end,
pscont=case when @nocock=0 then abs(@cuoikynt) else 0 end, psco=case when @nocock=0 then abs(@cuoiky) else 0 end, null as makh, null as tenkh, 3
order by stt,ngayCt, soct, tkdu'
where ReportName = N'Sổ chi tiết công nợ nhà cung cấp'
--------------------Bảng kê chi tiết công nợ phải trả theo hóa đơn-----------
Update sysReport set Query = N'select hd.[NgayCT], hd.[SoCT], hd.[SoHoaDon], hd.[MaKH], 
case when @@lang = 1 then kh.TenKH2 else kh.TenKH end as TenKH, hd.[NgayTT], hd.[DienGiai], hd.[TKCO], hd.[MaNT], hd.[TyGia], hd.[Ttien], hd.[TtienNT], hd.[ConLaiNT], hd.[ConLai], hd.[HanTT],
mt.[SoCt] as [Số CT TT], mt.[NgayCt] as [Ngày CT TT], mt.[DienGiai] as [Diễn giải TT], mt.[MaNT] as [Mã NT TT], mt.[TyGia] as [Tỷ giá TT], 
tt.[TTNT], tt.[TT], tt.[CLTG], tt.[MaVV], tt.[MaBP], tt.[MaPhi], tt.mt21id
from wHoaDonMua hd, DT26 tt, MT26 mt, DMKH kh
where hd.mt21id = tt.mt21id and mt.mt26id = tt.mt26id and hd.MaKH = kh.MaKH and (@@logic = 1 or (@@logic = 0 and (hd.conlai <> 0 or hd.conlaiNT <> 0))) and @@ps
union all
select hd.[NgayCT], hd.[SoCT], hd.[SoHoaDon], hd.[MaKH], 
case when @@lang = 1 then kh.TenKH2 else kh.TenKH end as TenKH,
 hd.[NgayTT], hd.[DienGiai], hd.[TKCO], hd.[MaNT], hd.[TyGia], hd.[Ttien], hd.[TtienNT], hd.[ConLaiNT], hd.[ConLai], hd.[HanTT],
'''',null,'''','''',0,0,0,0,'''','''','''',null
from wHoaDonMua hd, DMKH kh
where hd.MaKH = kh.MaKH and hd.ConLai = hd.TTien and hd.ConLaiNT = hd.TTienNT and @@ps'
where ReportName = N'Bảng kê chi tiết công nợ phải trả theo hóa đơn'
-----------------------In phiếu mua hàng có chi phí------------------
Update sysReport set Query = N'select * from
(
	select * from
	(
		select dt22.*,mt22.Tthue as ThueHang, mt22.TthueNT as ThueHangNT, 
		case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end as tenvt,mt22.ngayhd,mt22.sohoadon,mt22.soseri , mt22.tkco,
		case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh,dmkh.diachi, mt22.MaNT, dmnt.TenNT, dmnt.TenNT2 from dt22 ,dmvt,mt22,dmkh, dmnt where dmvt.mavt=dt22.mavt and mt22.mt22id=dt22.mt22id and dmkh.makh=mt22.makh and mt22.MaNT = dmnt.MaNT
	)y inner join
	(
		select mtiddt,soct,ngayct,dongia as dongiacocp, DongiaNT as dongiacocpNT, ongba as nguoigiaohang,psno as thanhtien, psnoNT as thanhtienNT from blvt 
		inner join  dt22 on dt22.dt22id=blvt.mtiddt where @@ps
	)x on y.dt22id=x.mtiddt
)y1 left join
(
	--Thuế có chi phí
	select sum(case when mt25.Tthue*dt25.ps/NULLIF(mt25.TtienH,0) is null then 0 else mt25.Tthue*dt25.ps/mt25.TtienH end) as thueCP, 
	sum(case when mt25.TthueNT*dt25.psNT/NULLIF(mt25.TtienHNT,0) is null then 0 else mt25.TthueNT*dt25.psNT/mt25.TtienHNT end) as thueCPNT ,dt25.mt22id  
	from mt25 inner join dt25 on mt25.mt25id =dt25.mt25id 
	where dt25.mt22id  in (select mt22id from mt22 where @@ps) group by dt25.mt22id--)
)x1 on y1.mt22id=x1.mt22id'
where ReportName = N'In phiếu mua hàng có chi phí'
------------------------------In phiếu nhập khẩu có chi phí--------------------
Update sysReport set Query = N'select * from
(
	select * from
	(
		select dt23.*,mt23.Tthue as ThueHang, mt23.TthueNT as ThueHangNT ,
		case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end as tenvt,
		mt23.ngayhd,mt23.sohoadon,mt23.soseri , mt23.tkco,
		case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh,
		dmkh.diachi, mt23.MaNT, dmnt.TenNT, dmnt.TenNT2 from dt23 ,dmvt,mt23,dmkh,dmnt  where dmvt.mavt=dt23.mavt and mt23.mt23id=dt23.mt23id and dmkh.makh=mt23.makh and mt23.MaNT = dmnt.MaNT
	)y inner join
	(
		select mtiddt,soct,ngayct,dongia as dongiacocp, dongiaNT as dongiacocpNT,ongba as nguoigiaohang,psno as thanhtien, psnoNT as thanhtienNT from blvt 
		inner join  dt23 on dt23.dt23id=blvt.mtiddt where @@ps
	)x on y.dt23id=x.mtiddt
)y1 left join
(
	--Thuế có chi phí
	select sum(case when mt25.Tthue*dt25.ps/nullif(mt25.TtienH,0) is null then 0 else mt25.Tthue*dt25.ps/mt25.TtienH end) as thueCP, 
			sum(case when mt25.TthueNT*dt25.psNT/nullif(mt25.TtienHNT,0) is null then 0 else mt25.TthueNT*dt25.psNT/mt25.TtienHNT end ) as thueCPNT,dt25.mt22id  from mt25 inner join dt25 on mt25.mt25id =dt25.mt25id
	where dt25.mt22id  in (select mt23id from mt23 where @@ps) group by dt25.mt22id--)
)x1 on y1.mt23id=x1.mt22id'
where ReportName = N'In phiếu nhập khẩu có chi phí'
---------------------Bảng kê phiếu mua hàng-----------------
Update sysReport set Query = N'select [NgayCT], [SoCT], [SoHoaDon], dmkh.[MaKH],
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as [Tên khách hàng], [DienGiai], [MaNT], [TyGia], [TKCo], v.[MaVT], 
case when @@lang = 1 then v.TenVT2 else v.TenVT end as [Tên vật tư], v.[MaDVT], [MaKho], [TKNo], 
[SoLuong], [GiaNT], [Gia], [PsNT], [Ps],  [ThueNT] , [Thue], [CPCtNT], [CPCt], [TienNKNT] + ThueNT as TPsNTCP, [TienNK] + Thue as TPsCP, [TienTTDB], [TienTTDBNT], [TienCK], [TienCKNT]
 from
(select mt.mact,mt.ngayct, mt.soct, mt.ngayhd,mt.sohoadon,mt.soseri,mt.makh,mt.diachi,mt.ongba, mt.manv,
mt.diengiai,mt.mant,mt.tygia,mt.tkco,mt.mathue,mt.tkthue,mt.TtienH,mt.TtienHNT,mt.cpnt,mt.cp,mt.TThueNt,mt.TThue,mt.Ttien,mt.TtienNT,
	 dt.*, v.ThueNT as ThueNT, v.Thue as Thue, ttdb.TienTTDB, ttdb.TienTTDBNT
	from MT22 mt, DT22 dt, VatIn v, TTDBIn ttdb
where mt.mt22id = dt.mt22id and dt.mt22id *= v.mtid and dt.dt22id *= v.mtiddt and dt.mt22id *= ttdb.mtid and dt.dt22id *= ttdb.mtiddt and @@ps
)x, dmkh, dmvt v where x.makh = dmkh.makh
and x.mavt = v.mavt 
order by ngayct,soct,x.stt'
where ReportName = N'Bảng kê phiếu mua hàng'
------------------Bảng kê phiếu chi phí mua hàng---------------
Update sysReport set Query = N'select distinct
mact,soct,ngayct,sohoadon,soseri,mt25.makh,
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh,diengiai,ttienh,tthue,ttien,mathue,tkco
from mt25,dmkh,dt25 where mt25.mt25id=dt25.mt25id and mt25.makh=dmkh.makh and @@ps
order by ngayct,sohoadon'
where ReportName = N'Bảng kê phiếu chi phí mua hàng'

------------------Bảng kê phiếu xuất hàng trả nhà cung cấp------------------
Update sysReport set Query = N'select mt.*, dt.*, v.thueNT as thuent, v.thue as thue, 
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as TenKH from
Mt24 mt, dt24 dt, dmkh, vatin v
where mt.makh=dmkh.makh 
and mt.mt24id =dt.mt24id
and dt.mt24id *= v.mtid and dt.dt24id *= v.mtiddt
and @@ps'
where ReportName = N'Bảng kê phiếu xuất hàng trả nhà cung cấp'
-----------------------------------Bảng kê phiếu nhập khẩu-------------------
Update sysReport set Query = N'if @@nhom=''''
begin
	select mt.*,dt.*,v.thueNT as ThueNT, v.Thue as Thue, dt.TienNK as TPs, dt.TienNKNT as TPsNT, dmkh.makh,
	(select case when @@lang = 1 then k.tenkh2 else k.tenkh end from dmkh k where k.makh = dmkh.makh) as TenKH1,
	case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end as tenvt,dmvt.nhom, ttdb.TienTTDB
	from MT23 mt, dt23 dt, dmkh, dmvt, VatIn v, TTDBIn ttdb
	where @@ps and mt.mt23id = dt.mt23id and mt.makh = dmkh.makh and dt.mavt = dmvt.mavt and dt.mt23id *= v.mtid and dt.dt23id *= v.mtiddt and dt.mt23id *= ttdb.mtid and dt.dt23id *= ttdb.mtiddt
end

else 
begin
	select mt.*,dt.*,v.thueNT as ThueNT, v.Thue as Thue, dt.TienNK as TPs, dt.TienNKNT as TPsNT, dmkh.makh,
	(select case when @@lang = 1 then k.tenkh2 else k.tenkh end from dmkh k where k.makh = dmkh.makh) as TenKH1,
	case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end as tenvt,dmvt.nhom, ttdb.TienTTDB
	from MT23 mt, dt23 dt, dmkh, dmvt, VatIn v, TTDBIn ttdb
	where @@ps and mt.mt23id = dt.mt23id and mt.makh = dmkh.makh and dt.mavt = dmvt.mavt and dt.mt23id *= v.mtid and dt.dt23id *= v.mtiddt and dt.mt23id *= ttdb.mtid and dt.dt23id *= ttdb.mtiddt and  dt.mavt in (select mavt from dmvt where nhom =@@nhom)
end'
where ReportName = N'Bảng kê phiếu nhập khẩu'
----------------------------------Tổng hợp hàng nhập mua------------------------
Update sysReport set Query = N'select x.*, case when @@lang = 1 then dmnhomvt.tennhom2 else dmnhomvt.tennhom end as tennhom from 
(Select a.MaKho, a.MaVT, 
case when @@lang = 1 then b.TenVT2 else b.TenVT end as TenVT, 
case when @@lang = 1 then c.TenDVT2 else c.TenDVT end as TenDVT, Sum(SoLuong - SoLuong_x) N''Số Lượng'' , Sum(DonGiaGoc*SoLuong) - Sum(DonGia*SoLuong_x) as N''Tiền vật tư'', sum(DonGiaGocNT*SoLuong) - Sum(DonGiaNT*SoLuong_x) as N''Tiền vật tư NT'', sum(PsNo) - Sum(DonGiaGoc*SoLuong) as CP,sum(PsNoNT) - Sum(DonGiaGocNT*SoLuong) as CPNT, sum(PsNo) - sum(PsCo) as PsNo, sum(PsNoNT) - sum(PsCoNT) as PsNoNT , b.nhom nhom
from blvt a, dmvt b, dmdvt c
where a.MaCT in (''PNM'',''PNK'',''PXT'') and a.MaVT = b.MaVT and b.MaDVT = c.MaDVT and @@PS
group by a.MaKho, a.MaVT, b.TenVT,b.TenVT2, c.TenDVT,c.TenDVT2, b.nhom) x
left join dmnhomvt on x.nhom = dmnhomvt.manhomvt'
where ReportName = N'Tổng hợp hàng nhập mua'
---------------------------------Sổ chi tiết mua hàng theo nhà cung cấp và mặt hàng--------
Update sysReport set Query = N'Select v.makh, 
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = v.makh) as tenkh,
v.NgayCT, v.SoCT, v.MaCT, v.mavt, v.diengiai,
v.gia, v.soluong, v.ps, v.tienck, v.[Giảm giá], v.[Số lượng trả lại], v.[Giá trị trả lại],
v.IsNCC, v.IsKH, v.IsNV, v.MaNT, 
(select case when @@lang = 1 then k.tenvt2 else k.tenvt end from dmvt k where k.mavt = v.mavt) as TenVT
from
(Select  mt22.makh, k.tenkh, NgayCT, SoCT, MACT , dt22.mavt, DienGiai,gia ,soluong , ps , tienck , 
0 as [Giảm giá], 0 as [Số lượng trả lại], 0 as [Giá trị trả lại], k.IsNCC, k.IsKH, k.IsNV, mt22.MaNT, vt.TenVT
from MT22,DT22 , dmkh k, dmvt vt
where  MT22.mt22id = DT22.mt22id and MT22.makh *= k.makh and dt22.MaVT *= vt.MaVT
union all
select mt23.makh, k.tenkh, NgayCT, SoCT, MACT , dt23.mavt, DienGiai,gia,soluong, ps , tienck,
0 as [Giảm giá], 0 as [Số lượng trả lại], 0 as [Giá trị trả lại], k.IsNCC, k.IsKH, k.IsNV, mt23.MaNT, vt.TenVT
from MT23 , DT23 , dmkh k, dmvt vt
where  MT23.mt23id = DT23.mt23id and MT23.makh *= k.makh and dt23.MaVT *= vt.MaVT
union all
select mt24.makh, k.tenkh, NgayCT, SoCT, MACT , dt24.mavt, DienGiai,0 ,0 , 0, 0 ,
0 as [Giảm giá], soluong as [Số lượng trả lại], ps as [Giá trị trả lại], k.IsNCC, k.IsKH, k.IsNV, mt24.MaNT, vt.TenVT
from MT24 , DT24 , dmkh k, dmvt vt
where  MT24.mt24id = DT24.mt24id and MT24.makh *= k.makh and dt24.MaVT *= vt.MaVT
) v
where @@ps'
where ReportName = N'Sổ chi tiết mua hàng theo nhà cung cấp và mặt hàng'
------------------------------------Sổ quỹ tiền mặt------------------------
Update sysReport set Query = N'declare @tkrp nvarchar(20)
declare @dauky float,@daukynt float
declare @thu float,@thunt float
declare @chi float,@chint float
declare @ton float
declare @tonnt float
declare @id int
declare @stt int
declare @tungayCt datetime,@ngaydk datetime
declare @denngayCt datetime
set @tuNgayCt=@@NgayCT1
set @denNgayCt=dateadd(hh,23,@@NgayCT2)
set @ngaydk=dateadd(hh,-1,@tungayct)
set @tkrp=@@TK

declare @nodk float,@nodknt float
declare @codk float,@codknt float
	exec sodutaikhoannt @tkrp,@ngaydk,''@@ps'',@Nodk output, @Codk output,@NoDkNt output, @CoDkNt output
set @dauky = @nodk
set @daukynt = @nodknt
declare cur cursor for 
SELECT min(bltkID) as  bltkID, sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(PsNoNt) as TienThuNt, sum(PsCoNt) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint,
case when sum(PsNo) != 0 then 1 else 2 end as STT
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
group by MTID, NgayCT,SoCT 
order by NgayCT,STT, SoCT

create table #t
 (
	[bltkID] [int]   NULL ,	
	[Thu] [decimal](18, 3) NULL ,
	[Chi] [decimal](18, 3) NULL ,
	[ThuNt] [decimal](18, 3) NULL ,
	[ChiNt] [decimal](18, 3) NULL ,
	[ton] [decimal](18, 3) NULL,
	[tonNt] [decimal](18, 3) NULL, 
	[STT] int null
) ON [PRIMARY]

insert into #t select min(bltkID) as bltkID,sum(PsNo) as TienThu, sum(PsCo) as TienChi,sum(PsNoNt) as TienThuNt, sum(PsCoNt) as TienChiNt,0.0 as toncuoi,0.0 as toncuoint, 
case when sum(PsNo) != 0 then 1 else 2 end as STT
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
group by MTID, NgayCT,SoCT 
order by ngayCT,Stt, SoCT
declare @tmp float,@tmpnt float
set @tmp=@dauky
set @tmpnt = @daukynt
open cur
fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt, @stt
while @@fetch_status=0
begin
	set @ton=@tmp+@thu-@chi
	set @tmp=@ton
	set @tonnt=@tmpnt+@thunt-@chint
	set @tmpnt=@tonnt
	UPDATE #t SET ton=@ton,tonnt=@tonnt where bltkid=@id
	fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt, @stt
	
end
close cur
deallocate cur

select x.bltkid, x.SoCT,x.NgayCT,
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as ongba,
 x.maKH, x.diengiai, x.tkdu, x.MaNt, x.TyGia,x.[Ps nợ],x.[Ps có],x.[Số dư],x.[Ps nợ nt], x.[PS có nt],x.[Số dư nt],x.Stt,
 case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh
from
((
select N'''' as bltkid ,N'''' as soct,null as ngayct,N'''' as ongba , N'''' as maKH, case when @@lang = 1 then N''Begin of Period'' else N''Đầu kỳ'' end as diengiai, N'''' as tkdu,N'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt, 0 as STT2)
union all
(SELECT a.bltkid, a.SoCT, a.NgayCT,a.OngBa as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1,case when b.Thu != 0 then 1 else 2 end
from bltk a, #t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by stt, ngayct
drop table #t'
where ReportName = N'Sổ quỹ tiền mặt'
-----------------------------Sổ tiền gởi ngân hàng-----------------
Update sysReport set Query = N'declare @tkrp nvarchar(20)
declare @dauky float,@daukynt float

declare @thu float,@thunt float
declare @chi float,@chint float
declare @ton float
declare @tonnt float
declare @id int
declare @tungayCt datetime,@ngaydk datetime
declare @denngayCt datetime
declare @stt int
set @tuNgayCt=@@NgayCT1
set @denNgayCt=dateadd(hh,23,@@NgayCT2)
set @ngaydk=dateadd(hh,-1,@tungayct)
set @tkrp=@@TK

declare @nodk float,@nodknt float
declare @codk float,@codknt float
	exec sodutaikhoannt @tkrp,@ngaydk,''@@ps'',@Nodk output, @Codk output,@NoDkNt output, @CoDkNt output
set @dauky = @nodk
set @daukynt = @nodknt
declare cur cursor for 
SELECT bltkID, PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint, 
case when PsNo != 0 then 1 else 2 end as STT

FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
order by NgayCT,STT,SoCT

create table #t
 (
	[bltkID] [int]   NULL ,	
	[Thu] [decimal](18, 3) NULL ,
	[Chi] [decimal](18, 3) NULL ,
	[ThuNt] [decimal](18, 3) NULL ,
	[ChiNt] [decimal](18, 3) NULL ,
	[ton] [decimal](18, 3) NULL,
	[tonNt] [decimal](18, 3) NULL,
	[stt] [int] null
) ON [PRIMARY]

insert into #t select bltkID ,PsNo as TienThu, PsCo as TienChi,PsNoNt as TienThuNt, PsCoNt as TienChiNt,0.0 as toncuoi,0.0 as toncuoint, case when PsNo != 0 then 1 else 2 end as STT
FROM         dbo.BLTK 
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @tungayCT and @denngayCT) and @@PS 
order by ngayCT,STT, SoCT
declare @tmp float,@tmpnt float
set @tmp=@dauky
set @tmpnt = @daukynt
open cur
fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt, @stt
while @@fetch_status=0
begin
	set @ton=@tmp+@thu-@chi
	set @tmp=@ton
	set @tonnt=@tmpnt+@thunt-@chint
	set @tmpnt=@tonnt
	UPDATE #t SET ton=@ton,tonnt=@tonnt where bltkid=@id
	fetch cur  into @ID,@thu,@chi,@thunt,@chint,@ton,@tonnt, @stt
	
end
close cur
deallocate cur

select x.*, (select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = x.makh) as tenkh
from
((
select N'''' as bltkid ,N'''' as soct,null as ngayct,N'''' as ongba , N'''' as maKH, case when @@lang = 1 then N''Begin of Period'' else N''Số dư đầu kỳ'' end as diengiai, N'''' as tkdu,N'''' as MaNt,null as TyGia,null as N''Ps nợ'',null as N''Ps có'', @dauky as  N''Số dư'' ,null as N''Ps nợ nt'',null as N''Ps có nt'', @daukynt as  N''Số dư nt'', 0 as Stt)
union all
(SELECT a.bltkid, a.SoCT, a.NgayCT,
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = a.makh) as N''Người nộp/nhận tiền'' , a.MaKH, a.DienGiai,a.TKDu, a.MaNt,a.TyGia,b.Thu as N''Ps nợ'', b.Chi as N''PS có'',b.ton as N''Số dư'',b.ThuNt as N''Ps nợ nt'', b.ChiNt as N''PS có nt'',b.tonNt as N''Số dư nt'', 1
from bltk a, #t b 
where a.bltkid = b.bltkid and @@ps
))x, dmkh
 where x.makh *= dmkh.makh
order by Stt, ngayct
drop table #t'
where ReportName = N'Sổ tiền gởi ngân hàng'
---------------------Bảng kê phiếu chi----------------
Update sysReport set Query = N'select mt.mt12id, mt.ngayct, mt.mact, mt.SoCt, mt.MaKH, mt.DiaChi,
mt.OngBa,
mt.DienGiai, mt.MaNT, mt.TyGia, mt.TKCo, mt.TtienNt, mt.Ttien, mt.TkThue, mt.TTThue, 
mt.TTienCT, mt.Stt, (select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.makh) as TenKH,
dt.dt12id, dt.mt12id, dt.DienGiaiCt, dt.MaKHCt,dt.PsNT, dt.Ps, dt.TkNo, dt.MaPhi, dt.MaVV, dt.MaBP, dt.stt, dt.MaSP, dt.MaCongTrinh, 
mt.TTienCT, mt.Stt, (select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = dt.MaKHCt) as TenKHCt
from MT12 mt, DT12 dt
where mt.MT12ID = dt.MT12ID and @@ps'
where ReportName = N'Bảng kê phiếu chi'
-----------------Bảng kê phiếu thu------------------------
Update sysReport set Query = N'select mt.MaCT, mt.NgayCT, mt.SoCT, mt.MaKH, mt.DiaChi, mt.OngBa, mt.MaNV,
mt.DienGiai, mt.MaNT, mt.TyGia, mt.TKNo, mt.TtienNt, mt.Ttien, mt.Stt,
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = mt.MaKH) as TenKH,
dt.dt11id, dt.mt11id, dt.DienGiaiCt, dt.MaKHCt, dt.PsNT, dt.Ps,dt.TkCo, dt.MaPhi, dt.maVV, dt.MaBP, dt.Stt, dt.MaSP, dt.MaCongTrinh,
(select case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = dt.MaKHCt) as TenKHCt
from MT11 mt, DT11 dt, dmkh
where mt.MT11ID = dt.MT11ID and dt.makhct  = dmkh.makh  and @@ps'
where ReportName = N'Bảng kê phiếu thu'

----------------Sổ nhật ký thu tiền---------------------
Update sysReport set Query = N'Select * from 
(Select SoCt, NgayCt,  DienGiai, B.MaKH, 
case when @@lang = 1 then KH.TenKH2 else KH.TenKH end as TenKH, B.TK, 
case when @@lang = 1 then TK.TenTK2 else TK.TenTK end as TenTK,
TKDu, PsNo, PsCo, 
B.MaPhi,case when @@lang = 1 then P.Tenphi2 else P.Tenphi end as Tenphi,
B.MaVV, case when @@lang = 1 then VV.TenVV2 else VV.TenVV end as TenVV, 
B.MaBP, case when @@lang = 1 then PB.TenBP2 else PB.TenBP end as TenBP, MaNT, TyGia 
From BLTK as B left join DMPhi as P on B.MaPhi=P.MaPhi
  left join DMVuViec as VV on B.MaVV=VV.MaVV
  left join DMBoPhan as PB on B.MaBP=PB.MaBP
  left join DMKH as KH on B.MaKH=KH.MaKH
  left join DMTK as TK on B.TK=TK.TK
where B.TK like ''11%'' and psno > 0) x 
where @@ps'
where ReportName = N'Sổ nhật ký thu tiền'
----------------Sổ nhật ký chi tiền---------------------
Update sysReport set Query = N'Select * from 
(Select SoCt, NgayCt,  DienGiai, 
B.MaKH, case when @@lang = 1 then KH.TenKH2 else KH.TenKH end as TenKH, 
B.TK,case when @@lang = 1 then TK.TenTK2 else TK.TenTK end as TenTK,
TKDu, PsNo, PsCo, 
B.MaPhi,case when @@lang = 1 then P.Tenphi2 else P.Tenphi end as Tenphi, 
B.MaVV, case when @@lang = 1 then VV.TenVV2 else VV.TenVV end as TenVV, 
B.MaBP, PB.TenBP, 
MaNT, TyGia 
From BLTK as B left join DMPhi as P on B.MaPhi=P.MaPhi
  left join DMVuViec as VV on B.MaVV=VV.MaVV
  left join DMBoPhan as PB on B.MaBP=PB.MaBP
  left join DMKH as KH on B.MaKH=KH.MaKH
  left join DMTK as TK on B.TK=TK.TK
where B.TK like ''11%'' and psco > 0) x
where @@ps'
where ReportName = N'Sổ nhật ký chi tiền'
--------------------Giá thành định mức---------------
Update sysReport set Query = N'DECLARE @cpc float
DECLARE @tk nvarchar(16)
DECLARE @ngayCt datetime
DECLARE @ngayCt1 datetime
DECLARE @dk nvarchar(256)
declare @nhom nvarchar(256)
set @nhom=@@nhomgt
SELECT @tk = N''627''
SELECT @ngayCt =@@ngayct1
SELECT @ngayCt1 = dateadd(hh,23,@@ngayct2)
SELECT @dk = ''@@ps''
EXEC sopsKetChuyen @tk, @ngayCt, @ngayCt1, @dk, @cpc output
create table #t (
	masp nvarchar (50) null,
	sln decimal (20,5) null,
	dddk decimal (20,5) null,
	nvl decimal (20,5) null,
	Luong decimal (20,5) null,
	cpc decimal (20,5) null,
	ddck decimal (20,5) null,
	Gia decimal (20,5) null
) on [Primary]
insert into #t 
select c.mavt,d.slN,0 as dddk,d.NVL, c.Luong*d.slN as Luong,0 as cpc,0 as ddck, 0 as gia from 
(
	select * from dfkhac where ngayct between @ngayct and @ngayct1
) c inner join
(
	select masp,avg(slN) as slN,sum(NVL) as NVL from 
	(
		select a.masp,b.slN,b.slN*a.soluong*a.gia as NVL from 
		(
			select mavt as masp, soluong,gia from dfNvl where ngayct between @ngayct and @ngayct1 
		)a inner join
		(
			select mavt as masp, sum(soluong) as slN from blvt where mact=''NSX'' and  ngayct between @ngayct and @ngayct1  group by mavt
		) b on a.masp=b.masp 
	) k  group by masp
)d on c.mavt=d.masp where c.mavt in (select mavt from dmvt where nhomgt=@nhom)
update #t set dddk =t.tien from cotiendd t where t.masp=#t.masp and t.ngayct between dateadd(m,-1,@ngayct) and dateadd(m,-1,@ngayct1)
update #t set ddck =t.tien from cotiendd t where t.masp=#t.masp and t.ngayct between @ngayct and @ngayct1
declare @tongHS float
declare @HSCPC float
select @tonghs=sum(NVL+Luong) from #t
set @hsCPC=0
if @tonghs>0
begin
	set @HSCPC =@cpc/@tongHS
end
--update #t set cpc =(NVL+Luong) * @HSCPC
--declare @tongHSDC float
--select @tongHSDC=sum(r.Heso*(t.NVL+t.LUONG))   from #t t inner join dfcpc r on t.masp= r.masp where r.ngayct between @ngayct and @ngayct1
--update #t set cpc=@CPC* r.heso*(t.NVL+t.LUONG)/@tongHSDC from #t t inner join dfcpc r on t.masp= r.masp where r.ngayct between @ngayct and @ngayct1

update #t set gia=(dddk+nvl+luong+cpc-ddck)/sln where  sln>0
select masp as [Mã sản phẩm],case when @@lang = 1 then  dmvt.tenvt2 else dmvt.tenvt end as [Tên sản phẩm],sln as [Số lượng nhập kho], dddk as [Dở dang đầu kỳ],nvl as [Chi phí nguyên vật liệu], luong as [Chi phí nhân công trực tiếp], CPC as [Chi phí sản xuất chung], ddck as [Dở dang cuối kỳ], gia as [Giá thành] from #t inner join dmvt on #t.masp = dmvt.mavt
drop table #t'
where ReportName = N'Giá thành định mức'
----------------------Bảng kê thuế GTGT mua vào (chi tiết)------------
Update sysReport set Query = N'Select ngayct, ngayhd, Type, SoSeries, Sohoadon,vatin.makh, TkThue, TkDu, 
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as Tenkh,dmkh.mst ,vatin.mavt,  ''DienGiai'' = case when (vatin.mavt is null) then DienGiai else case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end end,
 Ttien, ThueSuat/100 as ThueSuat, Thue, '''' as GhiChu, MaCT
from Vatin, dmkh, dmvt
where vatin.makh *= dmkh.makh and (ngayct between @@ngayct1 and @@ngayct2) and vatin.mavt *= dmvt.mavt and @@ps
order by ngayct, sohoadon'
where ReportName = N'Bảng kê thuế GTGT mua vào (chi tiết)'

----------------------Bảng kê thuế GTGT bán ra (chi tiết)------------
Update sysReport set Query = N'Select SoSerie, Sohoadon, ngayct, ngayhd,vatout.makh, 
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as Tenkh,
dmkh.mst, TkThue, TkDu,
vatout.mavt, ''DienGiai'' = case when (vatout.mavt is null) then DienGiai else case when @@lang = 1 then dmvt.tenvt2 else dmvt.tenvt end end, 
Ttien, ThueSuat/100 as ThueSuat, Thue, '''' as GhiChu, MaThue, MaCT
from vatout, dmkh, dmvt
where vatout.makh *= dmkh.makh and (ngayct between @@ngayct1 and @@ngayct2) and vatout.mavt *= dmvt.mavt and @@ps
order by ngayct, sohoadon'
where ReportName = N'Bảng kê thuế GTGT bán ra (chi tiết)'
----------------------Sổ chi tiết tài khoản------------
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

		select a.ngayCt,MTID, a.mact, a.SoCt, a.diengiai, a.tkdu, a.psno, a.psco, a.maKH, case when @@lang = 1 then b.tenkh2 else b.tenkh end as tenkh, 1 , @TKNhom as [Tài khoản nhóm], @TenTKNhom as [Tên tài khoản nhóm]
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

--------------------Cập nhật lại thứ tự các bảng danh mục--------------------
---------DMKH--------
UPDATE sysField
SET    SmartView = 1
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMKH')
       AND FieldName = N'TenKH2' 
       
UPDATE sysField
SET    TabIndex = 2
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMKH')
       AND FieldName = N'TenKH2' 
UPDATE sysField
SET    TabIndex = 3
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMKH')
       AND FieldName = N'MST' 
---------DMBoPhan--------
UPDATE sysField
SET    SmartView = 1
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMBoPhan')
       AND FieldName = N'TenBP2' 
---------DMPhi--------
UPDATE sysField
SET    SmartView = 1
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMPhi')
       AND FieldName = N'TenPhi2' 
---------DMNT--------
UPDATE sysField
SET    SmartView = 1
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMNT')
       AND FieldName = N'TenNT2' 
---------DMThue--------
UPDATE sysField
SET    SmartView = 1
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMLThue')
       AND FieldName = N'TenLoaiThue2'        
---------DMNhomKH--------
UPDATE sysField
SET    SmartView = 1
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMNhomKH')
       AND FieldName = N'TenNhom2' 
---------DMThueSuat--------
UPDATE sysField
SET    SmartView = 1
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMThueSuat')
       AND FieldName = N'TenThue2' 
---------DMThueTTDB--------
UPDATE sysField
SET    SmartView = 1
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMThueTTDB')
       AND FieldName = N'TenNhomTTDB2'               

---------DMVT--------
UPDATE sysField
SET    SmartView = 1
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMVT')
       AND FieldName = N'TenVT2' 
       
UPDATE sysField
SET    TabIndex = 2
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMVT')
       AND FieldName = N'TenVT2'  
                    
UPDATE sysField
SET    TabIndex = 3
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMVT')
       AND FieldName = N'MaDVT'                

---------DMKho--------
UPDATE sysField
SET    SmartView = 1
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMKho')
       AND FieldName = N'TenKho2'  
-------DMVuViec----------                                   
UPDATE sysField
SET    SmartView = 1
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMVuViec')
       AND FieldName = N'TenVV2'  
       
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tên nhóm tài sản' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Tên nhóm tài sản', N'Name of group assets')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Mức khấu hao năm' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Mức khấu hao năm', N'The depreciation expense in')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'KHThang' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'KHThang', N'Depreciation month')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'STT' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'STT', N'No.')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Nhập hàng trả lại' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Nhập hàng trả lại', N'Enter returns')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Nhập kho' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Nhập kho', N'Warehousing')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Nhập mua' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Nhập mua', N'Purchase')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Nhập khẩu' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Nhập khẩu', N'Imports')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Xuất bán' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Xuất bán', N'Export sale')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Xuất kho' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Xuất kho', N'Export Warehouse')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Điều chuyển kho' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Điều chuyển kho', N'Transfer of stock')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Chưa xác định' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Chưa xác định', N'not identified')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Giá trị tồn' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Giá trị tồn', N'Inventory Value')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Cộng (Mã vật tư)' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Cộng (Mã vật tư)', N'Total (Materials Code)')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Cộng (Mã kho)' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Cộng (Mã kho)', N'Total (Warehouse Code)')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Mã kho:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Mã kho:', N'Warehouse Code')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Giá trị' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Giá trị', N'Value')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'TenKH1' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'TenKH1', N'Customer')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'&1. Thông tin mặc định' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'&1. Thông tin mặc định', N'Default Config')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Mẫu số S07-DN' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Mẫu số S07-DN', N'Form S07-DN')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Mẫu số S08-DN' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Mẫu số S08-DN', N'Form S08-DN')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Mẫu số S05a-DNN' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Mẫu số S05a-DNN', N'Form S05a-DNN')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Mẫu số S03a1-DNN' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Mẫu số S03a1-DNN', N'Form S03a1-DNN')


if not exists (select top 1 1 from [Dictionary] where [Content] = N'( Ban hành theo QĐ số: 48/2006/QĐ-BTC ngày 14/09/2006 của Bộ trưởng BTC )' )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'( Ban hành theo QĐ số: 48/2006/QĐ-BTC ngày 14/09/2006 của Bộ trưởng BTC )', N'(Issued with Decission No: 48/2006/QĐ-BTC dated march 14/09/2006 by Ministry of Finance)')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Giao diện' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Giao diện', N'Skins')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Mặc định' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Mặc định', N'Default')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Sắp xếp lại số chứng từ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Sắp xếp lại số chứng từ', N'Resort voucher''s code')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'* Từ ngày chứng từ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'* Từ ngày chứng từ', N'* From Date')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'* Đến ngày chứng từ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'* Đến ngày chứng từ', N' * To Date')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tiền tố số chứng từ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Tiền tố số chứng từ', N'Prefix of voucher code')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'* Độ dài phân số chứng từ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'* Độ dài phân số chứng từ', N' * Length of voucher code')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'* Giá trị bắt đầu số chứng từ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'* Giá trị bắt đầu số chứng từ', N' * Begin number of voucher code')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'* Loại chứng từ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'* Loại chứng từ', N' * Voucher type')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Loại Phiếu Lắp Ráp' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Loại Phiếu Lắp Ráp', N'Assembly, dismantled''s type')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Nhập kho' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Nhập kho', N'Export warehouse')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Xuất kho' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Xuất kho', N'Import warehouse')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tên chứng từ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Tên chứng từ', N'Voucher name')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Ngày chứng từ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Ngày chứng từ', N'Voucher Date')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Số chứng từ cũ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Số chứng từ cũ', N'Current Voucher Code')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Số chứng từ mới' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Số chứng từ mới', N'New Voucher Code')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Diễn giải' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Diễn giải', N'Note')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Sắp xếp lại chứng từ' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Sắp xếp lại chứng từ', N'Sort')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Lưu ý:' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Lưu ý:', N'Warning')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Thực hiện chức năng này thì tất cả số chứng từ cũ trước đó sẽ bị thay đổi thành số chứng từ mới. Bạn nên sao lưu số liệu trước khi thực hiện chức năng này' )
	INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Thực hiện chức năng này thì tất cả số chứng từ cũ trước đó sẽ bị thay đổi thành số chứng từ mới. Bạn nên sao lưu số liệu trước khi thực hiện chức năng này', N'Please backup database before running this function.')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tổng số chứng từ tìm được' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Tổng số chứng từ tìm được', N'Total of voucher:')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Vui lòng cung cấp đầy đủ thông tin!' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Vui lòng cung cấp đầy đủ thông tin!', N'Please fill information.')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Độ dài phân số chứng từ chưa hợp lệ.' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Độ dài phân số chứng từ chưa hợp lệ.', N'Fraction Length of voucher is not valid.')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Bạn phải sắp xếp số chứng từ trước.' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Bạn phải sắp xếp số chứng từ trước.', N'Must fill new voucher code first.')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Chứng từ này đã tồn tại.' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Chứng từ này đã tồn tại.', N'Voucher is exit.')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Sắp xếp thứ tự của chứng từ thành công.' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Sắp xếp thứ tự của chứng từ thành công.', N'Update sussesfull')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Sắp xếp thứ tự của chứng từ thất bại. Xin thử lại.' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Sắp xếp thứ tự của chứng từ thất bại. Xin thử lại.', N'Update fail')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Giá trị bắt đầu số chứng từ chưa hợp lệ.' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Giá trị bắt đầu số chứng từ chưa hợp lệ.', N'The first value of voucher is not valid.')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Từ ngày chứng từ không được lớn hơn đến ngày chứng từ.' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Từ ngày chứng từ không được lớn hơn đến ngày chứng từ.', N'From''s Date is not greater than To''s Date.')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'F12-Lưu' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'F12-Lưu', N'F12-Save')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Esc-Quay ra' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Esc-Quay ra', N'Esc-Close')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tên chứng từ 2' )INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) VALUES (N'Tên chứng từ 2', N'Voucher name (eng)')


Update sysTable
Set DienGiai2 = N'Credit note receipt with other currency'
Where TableName = N'MT17' 

Update sysTable
Set DienGiai2 = N'Debit note receipt with other currency'
Where TableName = N'MT18' 

Update sysTable
Set DienGiai2 = N'Withholding documents, adjustment and refund'
Where TableName = N'MT36'












     
               
                              
               


