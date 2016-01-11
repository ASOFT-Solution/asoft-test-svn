IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0269]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0269]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kiểm tra Phương án lương
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 23/05/2013 by Lê Thị Thu Hiền 
---- 
---- Modified on 23/05/2013 by 
-- <Example>
---- 
CREATE PROCEDURE HP0269
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@SalaryPlanID AS NVARCHAR(50),
		@IsDelete AS TINYINT 
) 
AS 
SET NOCOUNT ON 
DECLARE @Status AS TINYINT,
		@Message AS NVARCHAR(100)
		
SET @Status = 0
SET @Message = ''

--IF @IsDelete = 1
--BEGIN
----------Đơn giá phương án
--	IF EXISTS (Select Top 1 1 FROM PST1021 Where DivisionID = @DivisionID And SubPlanID = @SubPlanID)
--	BEGIN
--		SET @Status = 1
--		SET @Message = 'PSFML000023'
--		GOTO ENDMESS
--	END
----------

--END

ENDMESS:

SELECT @Status AS Status, @Message AS Message 
SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

