USE [CDT]

DECLARE @mtTableID AS INT
DECLARE @dtTableID AS INT
DECLARE @sysPackageID INT
DECLARE @reportID INT

SELECT @mtTableID = sysTableID
FROM   [sysTable]
WHERE  TableName = N'MVATTNDN'

SELECT @dtTableID = sysTableID
FROM   [sysTable]
WHERE  TableName = N'DVATTNDN'

SELECT @sysPackageID = sysPackageID
FROM   [sysPackage]
WHERE  Package = N'HTA'

--------------Tờ khai Quyết toán thuế TNDN 03 - TT28----------------------
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReport]
               WHERE  [ReportName] = N'Tờ khai Quyết toán thuế TNDN 03 - TT28')
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
  VALUES (N'Tờ khai Quyết toán thuế TNDN 03 - TT28',
          0,
          @mtTableID,
          @dtTableID,
          N'select dt.Stt1, case when @@lang = 1 then dt.TenChiTieu2 else dt.TenChiTieu end as TenChiTieu, dt.MaCode, dt.TTien, mst.Nam1, mst.TuKy, mst.DenKy, mst.Ngay, mst.TaiLieu1, mst.TaiLieu2, mst.TaiLieu3, mst.TaiLieu4, mst.TaiLieu5, mst.TaiLieu6, mst.Giahan, mst.Quy, mst.Nam1, mst.InLanDau, mst.SoLanIn, mst.PhuThuoc from MVATTNDN mst inner join DVATTNDN dt on mst.MVATTNDNID = dt.MVATTNDNID
where mst.MauBaoCao = N''03/TNDN-TT28'' and @@ps order by dt.SortOrder',
          N'03-TNDN-TT28',
          N'VAT return 03 - Circular No.28 - Income of business',
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          @sysPackageID,
          N'mst',
          N'dt',
          NULL)

--Get reportID
SELECT @reportID = sysReportID
FROM   [sysReport]
WHERE  ReportName = N'Tờ khai Quyết toán thuế TNDN 03 - TT28'

UPDATE sysMenu
SET    sysReportId = @reportID,
       menuName = N'Tờ khai Quyết toán thuế TNDN 03 - TT28'
WHERE  menuName = N'Tờ khai Quyết toán thuế TNDN 03 - TT60' 

--Xóa các tờ khai khác
DECLARE @sysSiteIDPRO AS INT
DECLARE @sysSiteIDSTD AS INT


SELECT @sysSiteIDPRO = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'PRO'

IF Isnull(@sysSiteIDPRO, '') <> ''
BEGIN
  -- Xóa bảng kê chứng từ khác
	delete from sysMenu where sysMenuID not in (select top 1 n.sysMenuID 
												from sysMenu n
												WHERE  n.menuname = N'Tờ khai Quyết toán thuế TNDN 03 - TT28' 
												and n.sysSiteID = @sysSiteIDPRO 
												order by n.sysMenuID desc)
						and  menuname = N'Tờ khai Quyết toán thuế TNDN 03 - TT28' and sysSiteID = @sysSiteIDPRO
END

SELECT @sysSiteIDSTD = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'STD'

IF Isnull(@sysSiteIDSTD, '') <> ''
BEGIN
  -- Xóa bảng kê chứng từ khác
	delete from sysMenu where sysMenuID not in (select top 1 n.sysMenuID 
												from sysMenu n
												WHERE  n.menuname = N'Tờ khai Quyết toán thuế TNDN 03 - TT28' 
												and n.sysSiteID = @sysSiteIDSTD 
												order by n.sysMenuID desc)
						and  menuname = N'Tờ khai Quyết toán thuế TNDN 03 - TT28' and sysSiteID = @sysSiteIDSTD
END
						
DECLARE @sysFieldID AS INT

--- Thêm Report Filter
--Năm
SELECT @sysFieldID = sysFieldID from sysField where FieldName = N'Nam1'
AND sysTableID = (select sysTableID from sysTable where TableName = 'MVATTNDN')

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
        0,
        0,
        1,
        1,
        0,
        NULL)
--Từ Kỳ
SELECT @sysFieldID = sysFieldID from sysField where FieldName = N'TuKy'
AND sysTableID = (select sysTableID from sysTable where TableName = 'MVATTNDN')

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
        N'0',
        @reportID,
        0,
        1,
        1,
        1,
        0,
        NULL)
--Đến Kỳ
SELECT @sysFieldID = sysFieldID from sysField where FieldName = N'DenKy'
AND sysTableID = (select sysTableID from sysTable where TableName = 'MVATTNDN')

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
        N'0',
        @reportID,
        0,
        2,
        1,
        1,
        0,
        NULL) 

--Update ngôn ngữ
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Gia hạn nộp theo QĐ 21/2011/QĐ-TTg; QĐ 54/2011/QĐ-TTg' )
INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
VALUES (N'Gia hạn nộp theo QĐ 21/2011/QĐ-TTg; QĐ 54/2011/QĐ-TTg', N'Extension of payment under Decision 21/2011/QĐ-TTg; QĐ 54/2011/QĐ-TTg')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'F. Ngoài các phụ lục của tờ khai này, chúng tôi gửi kèm theo các tài liệu sau:' )
INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
VALUES (N'F. Ngoài các phụ lục của tờ khai này, chúng tôi gửi kèm theo các tài liệu sau:', N'F. In addition to the annex to this declaration, we enclose the following documents:')
		
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tên tài liệu' )
INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
VALUES (N'Tên tài liệu', N'Document Name')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tờ khai thuế GTGT tạo thành công.' )
INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
VALUES (N'Tờ khai thuế GTGT tạo thành công.', N'VAT declarations successfully.')

if not exists (select top 1 1 from [Dictionary] where [Content] = N'Cập nhật tờ khai thuế GTGT thành công.' )
INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
VALUES (N'Cập nhật tờ khai thuế GTGT thành công.', N'Update VAT declarations successfully.')


