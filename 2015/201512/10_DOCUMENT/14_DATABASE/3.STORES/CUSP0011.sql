IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CUSP0011]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[CUSP0011]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Thống kê phụ tùng
---- Báo cáo đặc thù cho khách hàng Đông Quang

-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 20/06/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 20/06/2013 by 
-- <Example>
---- EXEC CUSP0011 'AS', 'ADMIN', 2013
CREATE PROCEDURE CUSP0011
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranYear AS INT
) 
AS 

--SELECT AnaName FROM AT1011 WHERE AnaTypeID = 'A05' ORDER BY AnaName

DECLARE @cursor CURSOR,
		@TranMonth INT,
		@AnaID NVARCHAR(50),
		@sSQL AS NVARCHAR(MAX),
		@sSQL1 AS NVARCHAR(MAX),
		@sFROM AS NVARCHAR(MAX),
		@sGROUPBY AS NVARCHAR(MAX),
		@sWHERE AS NVARCHAR(MAX),
		@sSQL2 AS NVARCHAR(MAX)
		

SET @sSQL1 = ''
SET @sSQL = ''
SET @sSQL2 = ''
SET @sWHERE = ''

SET @cursor = CURSOR FORWARD_ONLY FOR

SELECT		DISTINCT TranMonth , OT3002.Ana05ID
FROM		OT3002 
LEFT JOIN	OT3001 ON OT3001.DivisionID = OT3002.DivisionID AND OT3001.POrderID = OT3002.POrderID
WHERE		OT3002.DivisionID = @DivisionID AND TranYear = @TranYear
			AND ISNULL(OT3002.Ana05ID, '') <> ''
ORDER BY TranMonth, OT3002.Ana05ID

OPEN @cursor
FETCH NEXT FROM @cursor INTO @TranMonth, @AnaID

WHILE @@FETCH_STATUS = 0
BEGIN
	--SELECT (@AnaID)
	--SELECT (@TranMonth)
	SET @sSQL1 = @sSQL1 + ' , CASE WHEN O2.TranMonth = '+STR(@TranMonth)+' AND O1.Ana05ID = '''+@AnaID+''' THEN O1.OrderQuantity ELSE 0 END AS Quantity'+CONVERT(VARCHAR(2),@TranMonth)+''+@AnaID+'
						, CASE WHEN O2.TranMonth = '+STR(@TranMonth)+' AND O1.Ana05ID = '''+@AnaID+''' THEN O1.PurchasePrice ELSE 0 END AS Price'+CONVERT(VARCHAR(2),@TranMonth)+''+@AnaID+'
						, CASE WHEN O2.TranMonth = '+STR(@TranMonth)+' AND O1.Ana05ID = '''+@AnaID+''' THEN O1.OriginalAmount ELSE 0 END AS OriginalAmount'+CONVERT(VARCHAR(2),@TranMonth)+''+@AnaID+'
						, CASE WHEN O2.TranMonth = '+STR(@TranMonth)+' AND O1.Ana05ID = '''+@AnaID+''' THEN O1.ConvertedAmount ELSE 0 END AS ConvertedAmount'+CONVERT(VARCHAR(2),@TranMonth)+''+@AnaID+' '
						
	--PRINT(@sSQL1)
	SET @sWHERE = @sWHERE + N'
		OR ISNULL(Quantity'+CONVERT(VARCHAR(2),@TranMonth)+''+@AnaID+',0) <> 0
		OR ISNULL(Price'+CONVERT(VARCHAR(2),@TranMonth)+''+@AnaID+',0) <> 0
		OR ISNULL(OriginalAmount'+CONVERT(VARCHAR(2),@TranMonth)+''+@AnaID+',0) <> 0
		OR ISNULL(ConvertedAmount'+CONVERT(VARCHAR(2),@TranMonth)+''+@AnaID+',0) <> 0 
	'
  FETCH NEXT FROM @cursor INTO @TranMonth, @AnaID
END 


CLOSE @cursor
DEALLOCATE @cursor
SET @sSQL = N'
SELECT	O1.DivisionID, O1.POrderID, O1.InventoryID, O1.UnitID, O2.TranMonth, O1.Ana05ID, 
		O2.ContractNo, O2.CurrencyID, O1.PurchasePrice AS Price
'
SET @sFROM = N'
INTO	#TAM
FROM	OT3002 O1
LEFT JOIN	OT3001 O2 ON O1.DivisionID = O2.DivisionID AND O1.POrderID = O2.POrderID
WHERE		O1.DivisionID = '''+@DivisionID+''' AND O2.TranYear = '+STR(@TranYear)+'
			AND ISNULL(O1.Ana05ID, '''') <> ''''
'
SET @sSQL2 = '
SELECT * FROM #TAM
WHERE	DivisionID = '''+@DivisionID+'''
'
PRINT (@sSQL)
PRINT(@sSQL1)
PRINT(@sFROM)
PRINT (@sSQL2)
PRINT(@sWHERE)

EXEC (@sSQL+@sSQL1+@sFROM+@sSQL2+@sWHERE)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

