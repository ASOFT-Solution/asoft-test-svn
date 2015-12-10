USE CDT
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteMenuDu]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteMenuDu]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
 * Xóa nhiều menu trùng
**/
CREATE PROCEDURE [dbo].[DeleteMenuDu]
	-- Add the parameters for the function here
	@sysSiteIDPROPara int, 
	@sysMenuParentIDPara int,
	@menuNamePara nvarchar(250)
AS
BEGIN
	delete from sysMenu 
	where sysMenuID in (select X.sysMenuID from (
								select ROW_NUMBER() OVER (ORDER BY n.sysMenuID) AS Row,n.sysMenuID
								from sysMenu n
								WHERE  n.menuname = @menuNamePara 
								and n.sysSiteID = @sysSiteIDPROPara
								and n.sysMenuParent = @sysMenuParentIDPara
								and not exists (select * from sysUserMenu ms 
															where ms.sysMenuID = n.sysMenuID)) as X
							  where X.Row > 1)
	and  menuname = @menuNamePara and sysSiteID = @sysSiteIDPROPara
END