IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0036]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP0036]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra bỏ tập hợp chi phí( theo yêu cầu bug 0017324)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 04/10/2013 by Nguyễn Thanh Sơn
----
-- <Example>
---- 
CREATE PROCEDURE MP0036
( 
		@DivisionID NVARCHAR(50),
		@TransactionID NVARCHAR(50)
)
AS 

SET NOCOUNT ON 
DECLARE @Status AS TINYINT,
		@Message AS NVARCHAR(100)
		
SET @Status = 0
SET @Message = ''

--- 2. Kiểm tra đã phân bổ chi phí hay chưa hay chưa?
IF EXISTS (SELECT TOP 1 1 FROM AT9000
           WHERE IsCost = 1 
           AND TransactionID = @TransactionID 
           AND DivisionID=@DivisionID)
    BEGIN
        SET @Status = 1 
        SET @Message = N'MFML000270'
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

