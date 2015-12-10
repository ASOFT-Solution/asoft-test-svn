USE [CDT]

DECLARE 
@sysSiteID INT,
@sysPackageID INT,
@sysTableId INT,
@query nvarchar(max),
@sysReportID INT,
@sysMenuParent INT,
@sysMenuParentReport INT,
@sysFieldID INT

SELECT @sysPackageID = 8
SELECT @sysTableId = [sysTableID] FROM [sysTable] WHERE [TableName] = 'MVATin'

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- Báo cáo
--
--------------------------------------------------------------------------------------------------------------------------------------------
--delete [sysReport] WHERE [sysPackageID] = @sysPackageID AND [ReportName] = N'Bảng phân bổ thuế được khấu trừ tháng'

set @query = N'
declare @sql nvarchar(max)  
declare @thang int 
declare @a decimal(20,6)
declare @a1 decimal(20,6)
declare @a2 decimal(20,6)
declare @a3 decimal(20,6)
declare @b1 decimal(20,6)
declare @b2 decimal(20,6)
declare @b3 decimal(20,6)
declare @b4 decimal(20,6)
declare @b5 decimal(20,6)

set @thang = @@kybkmv 

if exists (select top 1 1 from sys.all_views where name = ''wTempVATIn'') drop view wTempVATIn 
if exists (select top 1 1 from sys.all_views where name = ''wTempVATOut'') drop view wTempVATOut

set @sql = ''
create view wTempVATIn as 
select Thue, MaLoaiThue
from MVATIn inner join DVATIn on MVATIn.MVATInID = DVATIn.MVATInID and MVATIn.KyBKMV = '' + str(@thang)
exec (@sql) 
 
set @sql = ''
create view wTempVATOut as 
select TTien, MaThue
from MVATOut inner join DVATOut on MVATOut.MVATOutID = DVATOut.MVATOutID and MVATOut.KyBKBR = '' + str(@thang)
exec (@sql) 

select @a1 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 1
select @a2 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 2
select @a3 = isnull(sum(isnull(Thue, 0)), 0) from wTempVATIn where MaLoaiThue = 3
set @a = @a1 + @a2 + @a3
select @b1 = isnull(sum(isnull(TTien, 0)), 0) from wTempVATOut where MaThue in (''KT'', ''00'', ''05'', ''10'')
select @b2 = isnull(sum(isnull(TTien, 0)), 0) from wTempVATOut where MaThue in (''00'', ''05'', ''10'')
if(@b1 <> 0) set @b3 = (@b2 * 100) / @b1  else set @b3 = 0
select @b4 = @a3
select @b5 = (@b4 * @b3) / 100

select 
@thang as [Kỳ kế toán], 
@a as [Chỉ tiêu A], 
@a1 as [Chỉ tiêu A1], 
@a2 as [Chỉ tiêu A2], 
@a3 as [Chỉ tiêu A3], 
@b1 as [Chỉ tiêu B1], 
@b2 as [Chỉ tiêu B2], 
@b3 as [Chỉ tiêu B3], 
@b4 as [Chỉ tiêu B4], 
@b5 as [Chỉ tiêu B5]

if exists (select distinct name from sys.all_views where name = ''wTempVATIn'') drop view wTempVATIn 
if exists (select top 1 1 from sys.all_views where name = ''wTempVATOut'') drop view wTempVATOut 
'

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysReport] WHERE [sysPackageID] = @sysPackageID AND [ReportName] = N'Bảng phân bổ thuế được khấu trừ tháng')
INSERT [dbo].[sysReport]([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData])
VALUES(N'Bảng phân bổ thuế được khấu trừ tháng', 0, @sysTableId, NULL, @query, N'01-4B', N'Deductible VAT allocation by month', NULL, NULL, NULL, NULL, NULL, NULL, NULL, @sysPackageID, NULL, NULL, NULL)

--select * from [sysReport] WHERE [sysPackageID] = @sysPackageID AND [ReportName] = N'Bảng phân bổ thuế được khấu trừ tháng'

SELECT @sysReportID = [sysReportID] FROM [sysReport] WHERE [sysPackageID] = @sysPackageID AND [ReportName] = N'Bảng phân bổ thuế được khấu trừ tháng'

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- Điều kiện lọc báo cáo
--
--------------------------------------------------------------------------------------------------------------------------------------------

--delete [sysReportFilter] WHERE [sysReportID] = @sysReportID AND [sysFieldID] = @sysFieldID

SELECT @sysFieldID = [sysFieldID] FROM [sysField] WHERE [sysTableId] = @sysTableId AND [FieldName] = N'KyBKMV'
IF NOT EXISTS (SELECT TOP 1 1 FROM [sysReportFilter] WHERE [sysReportID] = @sysReportID AND [sysFieldID] = @sysFieldID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond])
VALUES (@sysFieldID, 0, NULL, @sysReportID, 0, 0, 1, 1, 1, NULL)	

--select * from [sysReportFilter] WHERE [sysReportID] = @sysReportID AND [sysFieldID] = @sysFieldID

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- Menu
--
--------------------------------------------------------------------------------------------------------------------------------------------
-- PRO
SELECT @sysSiteID = [sysSiteID], @sysPackageID = [sysPackageID] FROM [sysSite] WHERE [SiteCode] = N'PRO'
SELECT @sysMenuParent = [sysMenuID] FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND MenuName = N'Thuế GTGT'
SELECT @sysMenuParentReport = [sysMenuID] FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParent AND MenuName = N'Báo cáo'

--delete [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng phân bổ thuế được khấu trừ tháng'

if isnull(@sysSiteID,'') <> ''
BEGIN

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng phân bổ thuế được khấu trừ tháng')
INSERT [dbo].[sysMenu]([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image])
VALUES(N'Bảng phân bổ thuế được khấu trừ tháng', N'Deductible VAT allocation by month', @sysSiteID, NULL, NULL, @sysReportID, 7, NULL, @sysMenuParentReport, NULL, NULL, 5, NULL)

END

--select * from [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng phân bổ thuế được khấu trừ tháng'

-- STD
SELECT @sysSiteID = [sysSiteID], @sysPackageID = [sysPackageID] FROM [sysSite] WHERE [SiteCode] = N'STD'
SELECT @sysMenuParent = [sysMenuID] FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND MenuName = N'Thuế GTGT'
SELECT @sysMenuParentReport = [sysMenuID] FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParent AND MenuName = N'Báo cáo'

--delete [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng phân bổ thuế được khấu trừ tháng'

if isnull(@sysSiteID,'') <> ''
BEGIN

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng phân bổ thuế được khấu trừ tháng')
INSERT [dbo].[sysMenu]([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image])
VALUES(N'Bảng phân bổ thuế được khấu trừ tháng', N'Deductible VAT allocation by month', @sysSiteID, NULL, NULL, @sysReportID, 7, NULL, @sysMenuParentReport, NULL, NULL, 5, NULL)

END
--select * from [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] = @sysMenuParentReport AND MenuName = N'Bảng phân bổ thuế được khấu trừ tháng'
