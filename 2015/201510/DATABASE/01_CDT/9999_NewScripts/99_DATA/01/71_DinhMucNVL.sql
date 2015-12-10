USE [CDT]

DECLARE @sysSiteIDPRO AS INT
DECLARE @sysSiteIDSTD AS INT
DECLARE @sysMenuModuleID INT
DECLARE @sysMenuParentID INT
DECLARE @sysMenuID INT
DECLARE @menuName nvarchar (250)

SELECT @sysSiteIDPRO = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'PRO'

IF Isnull(@sysSiteIDPRO, '') <> ''
BEGIN


-------------Chi phí giá thành--------
SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Chi phí giá thành' and sysSiteID = @sysSiteIDPRO
SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Giá thành định mức' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID

--Định mức nguyên vật liệu
Select @sysMenuID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Định mức nguyên vật liệu' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuParentID
IF Isnull(@sysMenuID, '') <> ''
Update sysMenu set ExtraSQL = 'NhomGT is not null and LoaiVT=4'
Where sysMenuId = @sysMenuID

END



--02--- Lọc nguyên liệu trong định mức nguyên vật liệu

declare @sysTableID int

-- DMTSCD
select @sysTableID = sysTableID from sysTable
where TableName = 'DFNVL'


--MaNVL
Update sysField set RefCriteria = N'loaivt=1 or loaivt=2 or loaivt=4 or loaivt=9'
where sysTableID = @sysTableID
and FieldName = 'MaNVL'
