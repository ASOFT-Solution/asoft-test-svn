USE [CDT]

DECLARE @mtTableID AS INT
DECLARE @dtTableID AS INT
DECLARE @sysPackageID INT
DECLARE @reportID INT

SELECT @mtTableID = sysTableID
FROM   [sysTable]
WHERE  TableName = N'BLTK'

SELECT @sysPackageID = sysPackageID
FROM   [sysPackage]
WHERE  Package = N'HTA'

--1.Tạo report Tổng hợp công nợ theo nhân viên----------------------
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReport]
               WHERE  [ReportName] = N'Tổng hợp công nợ theo nhân viên')
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
  VALUES (N'Tổng hợp công nợ theo nhân viên',
          0,
          @mtTableID,
          --@dtTableID,
          NULL,
          N'declare @sql nvarchar (4000)
          declare @ngayct1 datetime
          declare @ngayct2 datetime
          set @ngayct1=@@ngayct1
          set @ngayct2=@@ngayct2
          
if exists (select distinct name from sys.all_views where name = ''VSoduOBKH'') drop view VSoduOBKH 
if exists (select distinct name from sys.all_views where name = ''VSoduBLTK'') drop view VSoduBLTK
if exists (select distinct name from sys.all_views where name = ''VView1'') drop view VView1
if exists (select distinct name from sys.all_views where name = ''VSodu'') drop view VSodu
if exists (select distinct name from sys.all_views where name = ''VDudau'') drop view VDudau
if exists (select distinct name from sys.all_views where name = ''VView2'') drop view VView2
if exists (select distinct name from sys.all_views where name = ''VKetqua'') drop view VKetqua
--lấy số dư OBKH
set @sql=''create view VSoduOBKH as select tk, makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where '' +  @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư BLTK
set @sql=''create view VSoduBLTK as select tk, makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where ngayct<cast('''''' + convert(nvarchar,@ngayct1) + '''''' as datetime) and '' + @@ps +'' group by tk, makh ''
exec (@sql)
--Lấy số dư OBKH và BLTK
set @sql=''create view VView1 as select * from VSoduOBKH union all select * from VSoduBLTK''
exec (@sql)
set @sql=''create view VDudau as select tk, makh,nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi from VView1 group by tk, makh''
exec (@sql)
--lấy số phát sinh
set @sql=''create view VSodu as select tk, makh,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
sum(psnont)as psnont,sum(psno)as psno, sum(pscont) as pscont, sum(psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk where ngayct between cast('''''' + convert(nvarchar,@ngayct1) + '''''' as datetime) and cast('''''' + convert(nvarchar, @ngayct2) + '''''' as datetime) and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư cuối
set @sql =''create view VView2 as select * from VDudau union all select * from VSodu''
exec (@sql)
set @sql=''create view VKetqua as 
select tk, makh, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
from VView2  group by tk, makh ''
exec (@sql)
-- In kết quả báo cáo
select a.makh as [Mã khách hàng],case when @@lang = 1 then b.tenkh2 else b.tenkh end as [Tên khách hàng], a.tk as [Tài khoản],case when @@lang = 1 then  t.TenTK2 else t.TenTK end as [Tên tài khoản], a.nodau as [Nợ đầu],a.codau as [Có đầu],a.psno as [Phát sinh nợ],a.psco as [Phát sinh có],a.nocuoi as [Nợ cuối],a.cocuoi as [Có cuối],
a.nodaunt as [Nợ đầu nguyên tệ],a.codaunt as [Có đầu nguyên tệ],a.psnont as [Phát sinh nợ nguyên tệ],a.pscont as [Phát sinh có nguyên tệ],a.nocuoint as [Nợ cuối nguyên tệ], a.cocuoint as [Có cuối nguyên tệ]
from VKetqua a left join dmkh b on  a.makh=b.makh left join dmtk t on a.tk = t.tk 
where a.makh is not null and (a.nodau <> 0 or a.codau <> 0 or a.psno <> 0 or a.psco <> 0 or a.nocuoi <> 0 or a.cocuoi <> 0)
drop view VSoduOBKH
drop view VSoduBLTK
drop view VView1
drop view VSodu
drop view VDudau
drop view VView2
drop view VKetqua',
          N'CNNV',
          N'Aggregate liabilities under employee',
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          @sysPackageID,
          NULL,
          NULL,
          NULL)

--Get reportID
SELECT @reportID = sysReportID
FROM   [sysReport]
WHERE  ReportName = N'Tổng hợp công nợ theo nhân viên'

--2.Thêm Report Filter---------------------------------------------
DECLARE @sysFieldID AS INT
--Fixbug Delete tất cả fiel trong sysReportFilter
DELETE  FROM   [sysReportFilter]  WHERE  [sysReportID] = @reportID
--Ngày chứng từ
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'NgayCT'
AND sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReportFilter]
               WHERE  [sysFieldID] = @sysFieldID
                      AND [sysReportID] = @reportID)
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
          0,
          NULL,
          @reportID,
          1,
          0,
          1,
          1,
          1,
          NULL)

--Từ tài khoản
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'TK'
AND sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReportFilter]
               WHERE  [sysFieldID] = @sysFieldID
                      AND [sysReportID] = @reportID)
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
          @reportID,
          1,
          1,
          1,
          1,
          0,
          N'TkCongNo = 1')

--Đối tượng (Nhân viên)
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'MaKH'
AND sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReportFilter]
               WHERE  [sysFieldID] = @sysFieldID
                      AND [sysReportID] = @reportID)
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
          @reportID,
          1,
          2,
          1,
          1,
          0,
          N'isNV=1')

--Mã phí
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'MaPhi'
AND sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReportFilter]
               WHERE  [sysFieldID] = @sysFieldID
                      AND [sysReportID] = @reportID)
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
          @reportID,
          0,
          3,
          1,
          1,
          0,
          NULL)

--Mã vụ việc
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'MaVV'
AND sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReportFilter]
               WHERE  [sysFieldID] = @sysFieldID
                      AND [sysReportID] = @reportID)
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
          @reportID,
          0,
          4,
          1,
          1,
          0,
          NULL)

--Mã NT
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'MaNT'
AND sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')


IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReportFilter]
               WHERE  [sysFieldID] = @sysFieldID
                      AND [sysReportID] = @reportID)
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
          @reportID,
          0,
          5,
          1,
          1,
          0,
          NULL)

--Mã MaBP
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'MaBP'
AND sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')


IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReportFilter]
               WHERE  [sysFieldID] = @sysFieldID
                      AND [sysReportID] = @reportID)
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
          @reportID,
          0,
          6,
          1,
          1,
          0,
          NULL)

SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'MaCongTrinh'
AND sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')


IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReportFilter]
               WHERE  [sysFieldID] = @sysFieldID
                      AND [sysReportID] = @reportID)
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
          @reportID,
          0,
          7,
          1,
          1,
          0,
          NULL)

--3. Tạo menu Báo cáo công nợ theo nhân viên
DECLARE @sysSiteIDPRO AS INT
DECLARE @sysSiteIDSTD AS INT
DECLARE @sysMenuParentID INT

SELECT @sysSiteIDPRO = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'PRO'

SELECT @sysSiteIDSTD = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'STD'

--STD
IF Isnull(@sysSiteIDSTD, '') <> ''
  BEGIN
      SELECT @sysMenuParentID = sysMenuID
      FROM   sysMenu
      WHERE  menuname = N'Báo cáo'
             AND sysMenuParent = (SELECT sysMenuId
                                  FROM   sysMenu
                                  WHERE  menuname = N'Quản lý tiền'
                                         AND sysSiteID = @sysSiteIDSTD)

      IF NOT EXISTS (SELECT TOP 1 1
                     FROM   [sysMenu]
                     WHERE  menuName = N'Tổng hợp công nợ theo nhân viên'
                            AND sysMenuParent = @sysMenuParentID
                            AND sysSiteID = @sysSiteIDSTD)
        BEGIN
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
            VALUES (N'Tổng hợp công nợ theo nhân viên',
                    N'Aggregate liabilities under employee',
                    @sysSiteIDSTD,
                    NULL,
                    NULL,
                    @reportID,
                    7,
                    NULL,
                    @sysMenuParentID,
                    NULL,
                    NULL,
                    5,
                    NULL)
        END
  END

--PRO
IF Isnull(@sysSiteIDPRO, '') <> ''
  BEGIN
      SELECT @sysMenuParentID = sysMenuID
      FROM   sysMenu
      WHERE  menuname = N'Báo cáo'
             AND sysMenuParent = (SELECT sysMenuId
                                  FROM   sysMenu
                                  WHERE  menuname = N'Quản lý tiền'
                                         AND sysSiteID = @sysSiteIDPRO)

      IF NOT EXISTS (SELECT TOP 1 1
                     FROM   [sysMenu]
                     WHERE  menuName = N'Tổng hợp công nợ theo nhân viên'
                            AND sysMenuParent = @sysMenuParentID
                            AND sysSiteID = @sysSiteIDPRO)
        BEGIN
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
            VALUES (N'Tổng hợp công nợ theo nhân viên',
                    N'Aggregate liabilities under employee',
                    @sysSiteIDPRO,
                    NULL,
                    NULL,
                    @reportID,
                    7,
                    NULL,
                    @sysMenuParentID,
                    NULL,
                    NULL,
                    5,
                    NULL)
        END
  END 

--04.Ngôn ngữ

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Mã nhân viên' )
INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
VALUES (N'Mã nhân viên', N'Employee Code')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Cộng (theo tài khoản)' )
INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
VALUES (N'Cộng (theo tài khoản)', N'Total(by account)')
