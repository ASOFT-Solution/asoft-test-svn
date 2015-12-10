USE CDT            

               
                              
--01. Tạo report
DECLARE @sysTableID INT

SELECT @sysTableID = sysTableID from sysTable where TableName = N'BLTK'
IF NOT EXISTS (SELECT TOP 1 1
               FROM   sysReport
               WHERE  ReportName = N'Tình hình thực hiện nghĩa vụ nộp thuế')
  INSERT [dbo].[sysReport]
         ([ReportName],
          [RpType],
          [mtTableID],
          [dtTableID],
          [Query],
          [ReportFile],
          [ReportName2],
          [ReportFile2],
          [sysReportParentID],
          [LinkField],
          [ColField],
          [ChartField1],
          [ChartField2],
          [ChartField3],
          [sysPackageID],
          [mtAlias],
          [dtAlias],
          [TreeData])
  VALUES (N'Tình hình thực hiện nghĩa vụ nộp thuế',
          0,
          @sysTableID,
          NULL,
          N'declare @ngayct datetime
declare @ngayCt1 datetime
declare @sql nvarchar (4000)
declare @gradeTK1 int
declare @gradeTK2 int

set @ngayct=@@Ngayct1
set @ngayCt1=@@Ngayct2

create table #NghiaVuNT
 ( [STT] int null,
 [ChiTieu] nvarchar(128) NULL,
 [MaSo] varchar(50),
 [TaiKhoan] varchar(16) COLLATE database_default NULL,
 [DauKy] [decimal](28, 3) NULL,
 [PhaiNop] [decimal](28, 3) NULL,
 [DaNop] [decimal](28, 3) NULL,
 [CuoiKy] [decimal](28, 3) NULL
 ) 
-- Insert các dòng cố định vào trong bảng tạm
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''0'',N''I – Thuế'', ''01'', NULL, NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''1'',N''1. Thuế GTGT hàng bán nội địa'', ''02'', ''33311'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''2'',N''2. Thuế GTGT hàng nhập khẩu'', ''03'', ''33312'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''3'',N''3. Thuế tiêu thụ đặc biệt'', ''04'', ''3332'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''4'',N''4. Thuế xuất, nhập khẩu'', ''05'', ''3333'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''5'',N''5. Thuế thu nhập doanh nghiệp'', ''06'', ''3334'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''6'',N''6. Thuế thu nhập cá nhân'', ''07'', ''3335'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''7'',N''7. Thuế tài nguyên'', ''08'', ''3336'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''8'',N''8. Thuế nhà đất, tiền thuê đất'', ''09'', ''3337'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''9'',N''9. Các loại thuế khác'', ''10'', ''3338'', NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''10'',N''II – Các khoản phải nộp khác'', ''20'', NULL, NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''11'',N''1. Các khoản phụ thu'', ''21'', NULL, NULL, NULL, NULL, NULL)
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''12'',N''2. Các khoản phí, lệ phí'', ''22'', NULL, NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''13'',N''3. Các khoản khác'', ''23'', ''3339'', NULL, NULL, NULL, NULL )
INSERT INTO #NghiaVuNT ([STT],[ChiTieu],[MaSo],[TaiKhoan],[DauKy],[PhaiNop],[DaNop],[CuoiKy]) 
VALUES (''14'',N''Tổng cộng'', ''30'', '''', NULL, NULL, NULL, NULL)

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
Select N.Stt, N.ChiTieu as [Chỉ tiêu], N.MaSo as [Mã số], N.TaiKhoan as [Tài khoản], K.[Có đầu]-K.[Nợ đầu] as [Đầu kỳ], K.[PsCo] as [Số phải nộp],K.[PsNo] as [Số đã nộp],K.[Lũy kế có] as [Phải nộp lũy kế],K.[Lũy kế nợ] as [Đã nộp lũy kế],K.[Có đầu]-K.[Nợ đầu]+K.[PsCo]-K.[PsNo] as [Cuối kỳ] from 
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
drop table #NghiaVuNT',
          N'BCTHNOPTHUENN',
          N'The implementation of the tax obligation on state budget',
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          8,
          NULL,
          NULL,
          NULL)

--02 - Report Filter
DECLARE @sysReportID INT,
        @sysFieldID  INT

SELECT @sysReportID = sysReportID
               FROM   sysReport
               WHERE  ReportName = N'Tình hình thực hiện nghĩa vụ nộp thuế'

SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'NgayCT'
       AND sysTableID = (SELECT sysTableID
                         FROM   sysTable
                         WHERE  TableName = N'BLTK') 


IF NOT EXISTS (SELECT TOP 1 1
               FROM   sysReportFilter
               WHERE  sysReportID = @sysReportID
               AND    sysFieldID = @sysFieldID)
	INSERT [dbo].[sysReportFilter]
           ([sysFieldID],
            [AllowNull],
            [DefaultValue],
            [sysReportID],
            [IsBetween],
            [TabIndex],
            [Visible],
            [IsMaster],
            [SpecialCond],
            [FilterCond])
    VALUES (@sysFieldID,
            1,
            NULL,
            @sysReportID,
            1,
            1,
            1,
            1,
            1,
            NULL) 

declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int
DECLARE @sysMenuID INT

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = 'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = 'STD'

if isnull(@sysSiteIDPRO,'') <> ''
BEGIN

SELECT @sysMenuID = sysMenuID from sysMenu 
	where sysMenuParent = (select sysMenuID from sysMenu where MenuName = N'Thuế khác' and sysSiteID = @sysSiteIDPRO)            
	and MenuName = N'Báo cáo'

--03. Tạo menu
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysMenu]
               WHERE  MenuName = N'Tình hình thực hiện nghĩa vụ nộp thuế' and sysSiteID = @sysSiteIDPRO)
INSERT [dbo].[sysMenu]
       ([MenuName],
        [MenuName2],
        [sysSiteID],
        [CustomType],
        [sysTableID],
        [sysReportID],
        [MenuOrder],
        [ExtraSql],
        [sysMenuParent],
        [MenuPluginID],
        [PluginName],
        [UIType],
        [Image])
VALUES (N'Tình hình thực hiện nghĩa vụ nộp thuế',
        N'The implementation of the tax obligation',
        @sysSiteIDPRO,
        NULL,
        NULL,
        @sysReportID,
        4,
        NULL,
        @sysMenuID,
        NULL,
        NULL,
        5,
        NULL) 

END

if isnull(@sysSiteIDSTD,'') <> ''
BEGIN

SELECT @sysMenuID = sysMenuID from sysMenu 
	where sysMenuParent = (select sysMenuID from sysMenu where MenuName = N'Thuế khác' and sysSiteID = @sysSiteIDSTD)            
	and MenuName = N'Báo cáo'

--03. Tạo menu
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysMenu]
               WHERE  MenuName = N'Tình hình thực hiện nghĩa vụ nộp thuế' and sysSiteID = @sysSiteIDSTD)
INSERT [dbo].[sysMenu]
       ([MenuName],
        [MenuName2],
        [sysSiteID],
        [CustomType],
        [sysTableID],
        [sysReportID],
        [MenuOrder],
        [ExtraSql],
        [sysMenuParent],
        [MenuPluginID],
        [PluginName],
        [UIType],
        [Image])
VALUES (N'Tình hình thực hiện nghĩa vụ nộp thuế',
        N'The implementation of the tax obligation',
        @sysSiteIDSTD,
        NULL,
        NULL,
        @sysReportID,
        4,
        NULL,
        @sysMenuID,
        NULL,
        NULL,
        5,
        NULL) 

END

--04. Ngôn ngữ
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Tình hình thực hiện nghĩa vụ nộp thuế vào ngân sách nhà nước')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Tình hình thực hiện nghĩa vụ nộp thuế vào ngân sách nhà nước',
               N'The implementation of the tax obligation on state budget')


IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Số đã nộp')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Số đã nộp',
               N'Has paid')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Số phải nộp')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Số phải nộp',
               N'Should paid')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Phải nộp lũy kế')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Phải nộp lũy kế',
               N'Has Accumulated paid')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Đã nộp lũy kế')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Đã nộp lũy kế',
               N'Should Accumulated paid')                              
               

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Số còn lại phải nộp  Kỳ trước chuyển sang')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Số còn lại phải nộp  Kỳ trước chuyển sang',
               N'The remainder pay to trans')                              

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Số phát sinh trong kỳ')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Số phát sinh trong kỳ',
               N'The number in the period')    

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Số còn lại nộp cuối kỳ')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Số còn lại nộp cuối kỳ',
               N'The remaining final payment')    