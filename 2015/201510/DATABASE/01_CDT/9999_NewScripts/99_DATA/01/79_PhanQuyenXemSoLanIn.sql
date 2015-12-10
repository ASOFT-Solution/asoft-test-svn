use [CDT]

-- Phân quyền xem số lần in hóa đơn trong báo cáo [Xem thông tin lưu vết người dùng]
Update sysReport set Query = N'declare @menuNhatKy int,
		@sysUserSiteID int

select @menuNhatKy = sysMenuID 
from sysMenu
where MenuName = N''Tổng hợp nhật ký in hóa đơn'' 
and [sysSiteID] is null
and sysMenuParent = (select sysMenuID from sysMenu where MenuName = N''Bảo mật số liệu'' and sysSiteID is null and sysMenuParent is null)

select @sysUserSiteID=sysUserSiteID from sysUserSite
where sysSiteID = @@sysSiteID and sysUserID = @@sysUserID and IsAdmin=0

-- Không có quyền xem số lần in hóa đơn
if exists(select 1 from sysUserMenu where sysMenuID = @menuNhatKy and Executable = 0 and sysUserSiteID = @sysUserSiteID)
BEGIN
	SELECT u.UserName,
		   m.MenuName,
		   h.*
	FROM   sysHistory h,
		   sysUser u,
		   sysMenu m
	WHERE  u.sysUserID =* h.sysUserID
		   AND h.sysMenuID *= m.sysMenuID
		   AND h.sysMenuID <> @menuNhatKy
		   AND h.sysUserID = (case when @sysUserSiteID is not null then @@sysUserID else h.sysUserID end) -- Giới hạn user k phải Admin chỉ được xem của chính mình
		   AND h.DbName = @@DbName
		   AND @@ps
	ORDER  BY h.hDateTime 
END
ELSE -- Có quyền xem số lần in hóa đơn
BEGIN
	SELECT u.UserName,
		   m.MenuName,
		   h.*
	FROM   sysHistory h,
		   sysUser u,
		   sysMenu m
	WHERE  u.sysUserID =* h.sysUserID
		   AND h.sysMenuID *= m.sysMenuID
		   AND (h.sysUserID = (case when @sysUserSiteID is not null then @@sysUserID else h.sysUserID end) or h.sysMenuID=@menuNhatKy) -- Giới hạn user k phải Admin chỉ được xem của chính mình
		   AND h.DbName = @@DbName
		   AND @@ps
	ORDER  BY h.hDateTime 
END '
where ReportName = N'Xem thông tin lưu vết người dùng'
and sysPackageID = 5