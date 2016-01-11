IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0346]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0346]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kiểm tra sửa xóa Quét dữ liệu chấm công công trình theo ca
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 25/09/2014 by Lê Thị Thu Hiền 
---- 
---- Modified on 25/09/2014 by 
-- <Example>
---- 
CREATE PROCEDURE HP0346
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS INT, 
	@TranYear AS INT,
	@VoucherID AS NVARCHAR(50)
) 
AS 

 DECLARE @Status AS tinyint, 
		@EngMessage as NVARCHAR(2000), 
		@VieMessage as NVARCHAR(2000)

SELECT 	@Status = 0, 
		@EngMessage = '',
		@VieMessage = ''

DECLARE @Project AS NVARCHAR(50)
SET @Project = (SELECT TOP 1 ProjectID FROM HT2416 WHERE APK = @VoucherID)
IF EXISTS(	SELECT TOP 1 1 FROM HT2432 
          	WHERE DivisionID = @DivisionID 
			AND ProjectID = @Project 
			AND TranMonth = @TranMonth 
			AND TranYear = @TranYear
		)
BEGIN
      
     SELECT	@Status = 1, 
			@VieMessage = 'HFML000492',
			@EngMessage =N'You do not edit/delete'
                           
                       
    GOTO LB_RESULT
END



LB_RESULT:
SELECT @Status AS Status, @EngMessage AS EngMessage, @VieMessage as VieMessage

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

