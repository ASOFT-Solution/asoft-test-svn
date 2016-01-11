IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[ADDSCREEN]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[ADDSCREEN]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Insert những menu của khách hàng vào
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Quốc Tuấn [13/07/2015]
---- Modified on 
-- <Example>
/*
	exec AddScreen 'ASoftCI','CF0100','0',N'Nhập đơn hàng','A','menuA','10,12,40'
*/


CREATE PROCEDURE AddScreen
(
    @ModuleID NVARCHAR(4000),
    @ScreenID NVARCHAR(4000),
    @ScreenType TINYINT,-- 1-Báo cáo; 2-Danh mục; 3-Nhập liệu; 4-Khác
    @ScreenName NVARCHAR(4000),
    @ScreenNameE NVARCHAR(4000),
    @CommandMenu NVARCHAR(4000),
	@CustomerIndex NVARCHAR(100)=null --- Nếu chuẩn không cần truyền, chuỗi customer index --- '10,12,40'
																						   --- Mỗi khách hàng cách nhau ,
)
AS

DELETE AT1404STD  WHERE ScreenID = @ScreenID AND ModuleID = @ModuleID
INSERT AT1404STD(ModuleID, ScreenID, ScreenName, ScreenNameE, ScreenType, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
SELECT @ModuleID, @ScreenID, @ScreenName, @ScreenNameE, @ScreenType, GETDATE(), N'ASOFTADMIN', N'ASOFTADMIN', GETDATE()

DELETE AT1403STD  WHERE ScreenID = @ScreenID AND GroupID = N'ADMIN' AND ModuleID = @ModuleID
INSERT AT1403STD(ScreenID, GroupID, ModuleID, IsAddNew, IsUpdate, IsDelete, IsView, IsPrint, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
SELECT @ScreenID, N'ADMIN', @ModuleID, 1, 1, 1, 1, 1, GETDATE(), N'ASOFTADMIN', N'ASOFTADMIN', GETDATE()


IF ISNULL(@CustomerIndex,'') <> ''
	EXEC AddMenuCustomer @ModuleID,@CustomerIndex,@CommandMenu,@ScreenID
ELSE 
	BEGIN
		IF ISNULL(@CommandMenu, '') != ''
		BEGIN
			DELETE A00004_1 WHERE ModuleID=@ModuleID AND ScreenID=@ScreenID AND CommandMenu=@CommandMenu
			DELETE A00004STD WHERE CommandMenu = @CommandMenu And ModuleID = @ModuleID
			INSERT A00004STD(ModuleID, ScreenID, CommandMenu)
			SELECT @ModuleID, @ScreenID, @CommandMenu
		END
	END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
