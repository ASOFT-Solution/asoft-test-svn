IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1407]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1407]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Xu ly du lieu phan quyen khi them hoac xoa nhom nguoi dung
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create by Dang Le Bao Quynh
-----Edit by: Dang Le Bao Quynh; Date: 27/08/2007
-----Edited by: [GS] [Việt Khánh] [29/07/2010]
-----Edit by: Huynh Tan Phu; Date: 06/02/2012: Toi uu hoa sql phan quyen. Fix bug 0015776
-----Purpose: Bo sung them truong DataType
---- Modified on 21/03/2012 by Nguyễn Bình Minh: Sửa phần khi thêm nhóm, không copy các phân quyền qua nhóm mới
---- Modified on 13/11/2012 by Lê Thị Thu Hiền : Bổ sung thêm lưu bàng AT1412
---- <Example>
---- 
CREATE PROCEDURE [dbo].[AP1407] 
( 
	@DivisionID NVARCHAR(50),
    @GroupID NVARCHAR(50), 
    @Status char(1)
) 
AS 
SET NOCOUNT OFF

IF @Status = 'A' 
    BEGIN
        /*
        INSERT INTO AT1406 (DivisionID, ModuleID, GroupID, DataID, DataType, BeginChar, Permission, CreateDate, CreateUserID)
        SELECT DISTINCT AT1407.DivisionID, AT1407.ModuleID, AT1401.GroupID, AT1407.DataID, DataType,DataName, 1 AS Expr1, GETDATE() AS Expr2, 'ASOFTADMIN' AS Expr3 
        FROM AT1407 CROSS JOIN AT1401
        WHERE AT1407.DivisionID + ModuleID + GroupID + DataID + DataType NOT IN (SELECT DivisionID + ModuleID + GroupID + DataID + DataType FROM AT1406 where DivisionID = @DivisionID)
		and AT1407.DivisionID = @DivisionID   */
		--INSERT INTO AT1406 (DivisionID, ModuleID, GroupID, DataID, DataType, BeginChar, Permission, CreateDate, CreateUserID)
		--SELECT DISTINCT AT1407.DivisionID, AT1407.ModuleID, AT1401.GroupID, AT1407.DataID, DataType,DataName, 1 AS Expr1, GETDATE() AS Expr2,
		--'ASOFTADMIN' AS Expr3
		--FROM AT1407 CROSS JOIN AT1401
		--WHERE NOT EXISTS(SELECT TOP 1 1 FROM AT1406
		--WHERE AT1406.DivisionID = AT1407.DivisionID
		--		AND AT1406.ModuleID = AT1407.ModuleID AND AT1406.GroupID = AT1401.GroupID
		--		AND AT1406.DataID = AT1407.DataID AND AT1406.DataType = AT1407.DataType
		--		AND AT1406.GroupID = @GroupID)
		--	AND AT1407.DivisionID = @DivisionID
		INSERT INTO AT1406 (DivisionID, ModuleID, GroupID, DataID, DataType, BeginChar, Permission, CreateDate, CreateUserID)			
			SELECT	DISTINCT AT1407.DivisionID, AT1407.ModuleID, @GroupID, AT1407.DataID, DataType,DataName, 1 AS Expr1, GETDATE() AS Expr2, 'ASOFTADMIN' AS Expr3 
			FROM	AT1407
			WHERE	NOT EXISTS(	SELECT TOP 1 1 FROM AT1406
								WHERE	AT1406.DivisionID = @DivisionID
										AND AT1406.DivisionID = AT1407.DivisionID
										AND AT1406.ModuleID = AT1407.ModuleID
										AND AT1406.DataID = AT1407.DataID AND AT1406.DataType = AT1407.DataType
										AND AT1406.GroupID = @GroupID
										)
					AND AT1407.DivisionID = @DivisionID		
					
		INSERT INTO AT1412 (DivisionID, ModuleID, GroupID, DataTypeID, Permission, CreateDate, CreateUserID)			
			SELECT	DISTINCT AT1408.DivisionID, A00004.ModuleID, @GroupID, DataTypeID, 1 AS Expr1, GETDATE() AS Expr2, 'ASOFTADMIN' AS Expr3 
			FROM	AT1408
			LEFT JOIN A00004 ON A00004.DivisionID = AT1408.DivisionID
			WHERE	NOT EXISTS(	SELECT TOP 1 1 FROM AT1412
								WHERE	AT1412.DivisionID = @DivisionID
										AND AT1412.DivisionID = AT1408.DivisionID
										AND AT1412.ModuleID = A00004.ModuleID
										AND AT1412.DataTypeID = AT1408.DataTypeID
										AND AT1412.GroupID = @GroupID
										)
					AND AT1408.DivisionID = @DivisionID	
					AND AT1408.DataTypeID IN ('AC', 'DE', 'IV', 'OB', 'VT', 'WA')	
    END

IF @Status = 'D' 
    BEGIN
        DELETE FROM AT1406 WHERE GroupID = @GroupID and DivisionID = @DivisionID 
        DELETE FROM AT1412 WHERE GroupID = @GroupID and DivisionID = @DivisionID 
    END

SET NOCOUNT ON



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

