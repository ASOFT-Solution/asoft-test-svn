IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[ADDMENUCUSTOMER]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[ADDMENUCUSTOMER]
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
	exec AddMenuCustomer 'ASoftCI','1,11,52','MenuA','CF0100'
*/
CREATE PROCEDURE AddMenuCustomer
(
	@ModuleID CHAR(50),
	@CustomerIndexList NVARCHAR(500),
	@CommandMenu NVARCHAR(500),
	@ScreenID NVARCHAR (50)
)
AS 
DECLARE 
@int INT = 0,
@dem INT = 0,
@so INT = 1

--xóa bảng A0004_1
DELETE A00004_1 WHERE ModuleID=@ModuleID AND ScreenID=@ScreenID AND CommandMenu=@CommandMenu
--insert vào bảng tạm
SELECT * INTO #Tam FROM SPLIT(@CustomerIndexList,',')
INSERT INTO A00004_1 (ModuleID, ScreenID, CommandMenu,CustomerIndex)
SELECT @ModuleID,@ScreenID,@CommandMenu,Data
FROM #Tam
DROP TABLE #Tam

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
