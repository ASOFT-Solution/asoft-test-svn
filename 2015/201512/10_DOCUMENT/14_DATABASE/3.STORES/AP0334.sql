IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0334]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0334]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- LOAD DANH MỤC TỜ KHAI THUẾ NHÀ THẦU - AF0317
-- <History>
---- Create on 12/11/2015 by Trương Ngọc Phương Thảo
-- <Example>
/*
EXEC AP0334 'GS', 10, 2015, 10, 2015, NULL, NULL, 0, ''
*/

CREATE PROCEDURE [dbo].[AP0334] 	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT, -- 1: ngày, 0: kỳ
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sWHERE NVARCHAR(MAX) = ''
	
IF (@IsDate = 1)
BEGIN
	SET @sWhere = 'AND (AT0317.TaxReturnDate BETWEEN '''+Convert(Varchar(20),@FromDate,101)+''' AND '''+Convert(Varchar(20),@ToDate,101)+''')'
END
ELSE
BEGIN
	SET @sWhere = 'AND (AT0317.TranMonth + AT0317.TranYear*100 BETWEEN '+STR(@FromMonth+@FromYear*100)+' AND '+STR(@ToMonth+@ToYear*100)+')'
END
	
SET @sSQL1 = '
SELECT *   
FROM AT0317 
WHERE DivisionID = '''+@DivisionID+''' '+@sWHERE+'
ORDER BY IsPeriodTax DESC, TranYear, TranMonth, TaxReturnDate, ReturnTime
'
EXEC (@sSQL1)
--PRINT (@sSQL1)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

