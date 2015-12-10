use [CDT]
declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int
DECLARE @sysMenuModuleID INT
DECLARE @sysMenuParentID INT

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

-- PRO
if isnull(@sysSiteIDPRO,'') <> ''
BEGIN
	--Quản lý kho
	SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Quản lý kho' and sysSiteID = @sysSiteIDPRO and sysMenuParent is null

	--Số dư
	SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Số dư' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID

	Update sysMenu set UIType = 2, sysMenuParent = @sysMenuParentID, MenuOrder = 3
	Where MenuName = N'Số dư đầu kỳ bình quân và đích danh' and sysSiteID = @sysSiteIDPRO and sysMenuParent <> @sysMenuParentID and UIType <> 2
END

-- STD
if isnull(@sysSiteIDSTD,'') <> ''
BEGIN
	--Quản lý kho
	SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Quản lý kho' and sysSiteID = @sysSiteIDSTD and sysMenuParent is null

	--Số dư
	SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Số dư' and sysSiteID = @sysSiteIDSTD And sysMenuParent = @sysMenuModuleID

	Update sysMenu set UIType = 2, sysMenuParent = @sysMenuParentID, MenuOrder = 3
	Where MenuName = N'Số dư đầu kỳ bình quân và đích danh' and sysSiteID = @sysSiteIDSTD and sysMenuParent <> @sysMenuParentID and UIType <> 2
END


