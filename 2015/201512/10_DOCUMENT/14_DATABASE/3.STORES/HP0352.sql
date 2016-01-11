IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0352]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0352]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kiểm tra sửa xóa công trình
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 16/10/2014 by Mai Trí Thiện
---- 					
---- Modified on
-- <Example>
---- 
CREATE PROCEDURE HP0352
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@TranMonth AS INT, 
	@TranYear AS INT,
	@ProjectID AS NVARCHAR(50)
) 
AS 

 DECLARE @Status AS tinyint, 
		@EngMessage as NVARCHAR(2000), 
		@VieMessage as NVARCHAR(2000)

SELECT 	@Status = 0, 
		@EngMessage = '',
		@VieMessage = ''

------->>>> Chấm công công trình theo tháng
IF EXISTS(	SELECT TOP 1 1 FROM HT2432 
          	WHERE DivisionID = @DivisionID 
			AND ProjectID = @ProjectID
		)
BEGIN
      
     SELECT	@Status = 1, 
			@VieMessage = 'HFML000497',
			@EngMessage =N'You do not edit/delete'
                           
                       
    GOTO LB_RESULT
END

------->>>> Chấm công công trình theo ca
IF EXISTS(	SELECT TOP 1 1 FROM HT2416
          	WHERE DivisionID = @DivisionID 
			AND ProjectID = @ProjectID 
		)
BEGIN
      
     SELECT	@Status = 1, 
			@VieMessage = 'HFML000496',
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

