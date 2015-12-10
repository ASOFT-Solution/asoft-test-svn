use [CDT]

declare @sysTableID int

-- DMVTLR
select @sysTableID = sysTableID from sysTable
where TableName = 'DMVTLR'

Update sysField set RefTable = N'wDMDVTQD', DynCriteria = N'MaVT=@MaVTLR'
where sysTableID = @sysTableID
and FieldName = 'MaDVT'


DECLARE @sysSiteIDPRO AS INT
DECLARE @sysSiteIDSTD AS INT
DECLARE @sysMenuModuleID INT
DECLARE @sysMenuParentID INT
DECLARE @sysMenuID INT

SELECT @sysSiteIDPRO = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'PRO'

IF Isnull(@sysSiteIDPRO, '') <> ''
BEGIN
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Quản lý kho' and sysSiteID = @sysSiteIDPRO
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Danh Mục' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID

Select @sysMenuID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Danh mục vật tư lắp ráp, tháo dỡ' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuParentID
IF Isnull(@sysMenuID, '') <> ''
	Update sysMenu set menuname = N'Vật tư lắp ráp, tháo dỡ',MenuName2 = N'Materials and assembly, dismantling'
	Where sysMenuId = @sysMenuID
END

--Xóa các menu trùng
delete from sysMenu 
	where sysMenuID not in (select top 1 n.sysMenuID from sysMenu n
								WHERE  n.menuname = N'Vật tư lắp ráp, tháo dỡ' 
								and n.sysSiteID = @sysSiteIDPRO 
								order by n.sysMenuID desc)
	and  menuname = N'Vật tư lắp ráp, tháo dỡ' and sysSiteID = @sysSiteIDPRO


SELECT @sysSiteIDSTD = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'STD'

IF Isnull(@sysSiteIDSTD, '') <> ''
BEGIN
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Quản lý kho' and sysSiteID = @sysSiteIDSTD
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Danh Mục' and sysSiteID = @sysSiteIDSTD And sysMenuParent = @sysMenuModuleID

Select @sysMenuID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Danh mục vật tư lắp ráp, tháo dỡ' and sysSiteID = @sysSiteIDSTD And sysMenuParent = @sysMenuParentID
IF Isnull(@sysMenuID, '') <> ''
	Update sysMenu set menuname = N'Vật tư lắp ráp, tháo dỡ',MenuName2 = N'Materials and assembly, dismantling'
	Where sysMenuId = @sysMenuID


--Xóa các menu trùng
delete from sysMenu 
	where sysMenuID not in (select top 1 n.sysMenuID from sysMenu n
								WHERE  n.menuname = N'Vật tư lắp ráp, tháo dỡ' 
								and n.sysSiteID = @sysSiteIDSTD 
								order by n.sysMenuID desc)
	and  menuname = N'Vật tư lắp ráp, tháo dỡ' and sysSiteID = @sysSiteIDSTD

END


