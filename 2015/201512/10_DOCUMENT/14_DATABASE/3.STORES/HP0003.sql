IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0003]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0003]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Create on 14/11/2013 by Thanh Sơn 
---- Nội dung: Load danh sách các kì lương để chấm công
---- EXEC HP0003 'SAS',''

CREATE PROCEDURE HP0003
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50)
)    
AS 
DECLARE @sSQL NVARCHAR(MAX), @PeriodID VARCHAR(50)

SELECT @PeriodID = PeriodID FROM HT0007 WHERE DivisionID = @DivisionID

IF (@PeriodID IS NULL OR @PeriodID = '%') SET @sSQL = N'
SELECT PeriodID FROM HT6666 WHERE DivisionID = '''+@DivisionID+''' '
ELSE SET @sSQL = N'
SELECT PeriodID FROM HT6666 WHERE DivisionID = '''+@DivisionID+''' AND PeriodID = '''+@PeriodID+'''  '

EXEC (@sSQL)
PRINT (@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

