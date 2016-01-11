IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0202]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0202]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra kết chuyển, xóa, xóa tất cả 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 023/09/2013 by Nguyễn Thanh Sơn
---- Modify on 07/12/2015 by Bảo Anh: Bổ sung thêm @DepartmentID,@TeamID,@EmployeeID,@TableID
-- <Example>
---- 
CREATE PROCEDURE HP0202
( 
		@DivisionID NVARCHAR(50),		
		@TranMonth INT,
		@TranYear INT,
		@DepartmentID nvarchar(50),
		@TeamID nvarchar(50),
		@EmployeeID nvarchar(50),
		@TableID nvarchar(50)
) 
AS 

SET NOCOUNT ON 
DECLARE @Status AS TINYINT,
		@Message AS NVARCHAR(100)
		
SET @Status = 0
SET @Message = ''

IF @TableID = 'HT2402' --- kiểm tra đã tính lương chưa
BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM HT3400 WHERE DivisionID=@DivisionID AND TranMonth=@TranMonth AND TranYear=@TranYear
				AND DepartmentID = @DepartmentID AND Isnull(TeamID,'') = @TeamID AND EmployeeID = @EmployeeID)
		BEGIN
			SET @Status = 1
			SET @Message = 'HFML000475'
			GOTO ENDMESS
		END
END


ENDMESS:

SELECT @Status AS Status, @Message AS Message 
SET NOCOUNT OFF


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON