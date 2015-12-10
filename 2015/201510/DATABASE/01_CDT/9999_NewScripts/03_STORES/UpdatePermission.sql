USE CDT
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePermission]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdatePermission]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
 * Xóa nhiều menu trùng
**/
CREATE PROCEDURE [dbo].[UpdatePermission]
	-- Add the parameters for the function here
	@menuName nvarchar(max)
AS
BEGIN
	DECLARE @menuId int
	DECLARE @sysUserSiteID int
	DECLARE @sysSiteId int
	DECLARE @sysMenuParentID int
	DECLARE @cur CURSOR

	SET @cur = CURSOR
	FOR SELECT DISTINCT  sysUserSiteID, sysSiteID  FROM  sysUserSite
	WHERE  isAdmin = 0
	OPEN @cur
	FETCH NEXT FROM @cur INTO @sysUserSiteID, @sysSiteId
	WHILE @@FETCH_STATUS = 0
	  BEGIN
	     select @menuId =  sysMenuId from sysMenu
	     where MenuName =  @menuName
	     and sysSiteID = @sysSiteId
	     
	     select @sysMenuParentID =  sysMenuParent from sysMenu
	     where MenuName =  @menuName
	     and sysSiteID = @sysSiteId
	     
	   --sysUserMenu
			IF NOT EXISTS (SELECT TOP 1 1
               FROM   sysUserMenu
               WHERE  sysUserSiteID = @sysUserSiteID
                      AND sysMenuID = @menuId)
                      INSERT INTO [CDT].[dbo].[sysUserMenu]
					   ([sysMenuID]
					   ,[Executable]
					   ,[sysUserSiteID]
					   ,[sysMenuParentID])
				 VALUES
					   (@menuId
					   ,0
					   ,@sysUserSiteID
					   ,@sysMenuParentID)
		  FETCH NEXT FROM @cur INTO @sysUserSiteID, @sysSiteId
	  END
	CLOSE @cur 
END