IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0285]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0285]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra sửa xóa chấm công ca
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 24/09/2013 by Nguyễn Thanh Sơn
----
-- <Example>
---- 
CREATE PROCEDURE HP0285
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@EmployeeID AS NVARCHAR (50)
) 
AS 

SET NOCOUNT ON 
DECLARE @Status AS TINYINT,
		@Message AS NVARCHAR(100)
		
SET @Status = 0
SET @Message = ''

IF EXISTS 
( 
 SELECT TOP 1 1 FROM HT2401 
 WHERE DivisionID = @DivisionID 
 AND   TranMonth=@TranMonth
 AND   TranYear=@TranYear
 AND   EmployeeID=@EmployeeID
)
	BEGIN
		SET @Status = 1
		SET @Message = 'HFML000476'
		GOTO ENDMESS
	END

ENDMESS:

SELECT @Status AS Status, @Message AS Message 
SET NOCOUNT OFF


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

