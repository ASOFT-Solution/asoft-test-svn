USE [CDT]

DECLARE 
@sysSiteID INT,
@sysPackageID INT,
@sysMenuOrderTax INT

SELECT @sysSiteID = [sysSiteID], @sysPackageID = [sysPackageID] FROM [sysSite] WHERE [SiteCode] = N'PRO'

--------------------------------------------------------------------------------------------------------------------------------------------
--
-- Menu: Thuế khác
--
--------------------------------------------------------------------------------------------------------------------------------------------
-- PRO
SELECT @sysSiteID = [sysSiteID] FROM [sysSite] WHERE [SiteCode] = N'PRO'
--delete [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] IS NULL AND MenuName = N'Thuế khác' AND [UIType] = 3

if isnull(@sysSiteID, '') <> ''
BEGIN

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] IS NULL AND MenuName = N'Thuế khác' AND [UIType] = 3)
INSERT [dbo].[sysMenu]([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image])
VALUES(N'Thuế khác', N'Other tax', @sysSiteID, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, 3, NULL)

UPDATE [sysMenu] SET [MenuOrder] = 11 WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] IS NULL AND MenuName = N'Tổng hợp' AND [UIType] = 3

END

-- STD
SELECT @sysSiteID = [sysSiteID] FROM [sysSite] WHERE [SiteCode] = N'STD'
--delete [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] IS NULL AND MenuName = N'Thuế khác' AND [UIType] = 3

if isnull(@sysSiteID, '') <> ''
BEGIN

IF NOT EXISTS(SELECT TOP 1 1 FROM [sysMenu] WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] IS NULL AND MenuName = N'Thuế khác' AND [UIType] = 3)
INSERT [dbo].[sysMenu]([MenuName], [MenuName2], [sysSiteID], [CustomType], [sysTableID], [sysReportID], [MenuOrder], [ExtraSql], [sysMenuParent], [MenuPluginID], [PluginName], [UIType], [Image])
VALUES(N'Thuế khác', N'Other tax', @sysSiteID, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, 3, NULL)

UPDATE [sysMenu] SET [MenuOrder] = 11 WHERE [sysSiteID] = @sysSiteID AND [sysMenuParent] IS NULL AND MenuName = N'Tổng hợp' AND [UIType] = 3

END