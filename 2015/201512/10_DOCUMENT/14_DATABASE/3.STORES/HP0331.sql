IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0331]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0331]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kiểm tra hủy tất cả hồ sơ nhân viên
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 22/11/2013 by Nguyễn Thanh Sơn
-- <Example>
---- EXEC HP0331 'SAS','',9,2013
CREATE PROCEDURE HP0331
( 
		@DivisionID NVARCHAR(50),
		@UserID NVARCHAR(50),
		@TranMonth INT,
		@TranYear INT
) 
AS 

SET NOCOUNT ON
DECLARE @Status AS TINYINT,
		@Message AS NVARCHAR(100)
		
SET @Status = 0
SET @Message = ''

IF EXISTS (SELECT TOP 1 1 FROM HT3400 WHERE DivisionID = @DivisionID AND TranMonth =  @TranMonth AND TranYear = @TranYear)
	BEGIN
		SET @Status = 1
		SET @Message = 'HFML000475'
		GOTO ENDMESS
	END
	
-----------------------Kiểm tra trong bảng chấm công-----------------------------------------------------------------------	

IF EXISTS (SELECT TOP 1 1 FROM HT2401 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth  AND TranYear = @TranYear)
	BEGIN
		SET @Status = 1
		SET @Message = 'HFML000203'
		GOTO ENDMESS
	END
	
IF EXISTS (SELECT TOP 1 1 FROM HT2402 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth  AND TranYear = @TranYear)
	BEGIN
		SET @Status = 1
		SET @Message = 'HFML000203'
		GOTO ENDMESS
	END
---Chấm công ca---
IF EXISTS (SELECT TOP 1 1 FROM HT0284 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth  AND TranYear = @TranYear)
	BEGIN
		SET @Status = 1
		SET @Message = 'HFML000203'
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

