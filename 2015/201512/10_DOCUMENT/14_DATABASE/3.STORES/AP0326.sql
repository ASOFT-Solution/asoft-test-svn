IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0326]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0326]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Lấy dữ liệu mặc định 01/TTĐB
-- <History>
---- Create on 29/05/2015 by Lê Thị Hạnh 
-- <Example>
/*
AP0326 @DivisionID = 'vg', @TranMonth = 1, @TranYear = 2015, @ReturnDate = '2014-10-07', @IsPeriodTax = 1
*/

CREATE PROCEDURE [dbo].[AP0326] 	
	@DivisionID NVARCHAR(50),
	@TranMonth INT,
	@TranYear INT,	
	@ReturnDate DATETIME,
	@IsPeriodTax TINYINT
AS
DECLARE @sSQL1 NVARCHAR(MAX) = '',
		@sWHERE NVARCHAR(MAX) = ''

IF LTRIM(STR(ISNULL(@IsPeriodTax,0))) = 0	SET @sWHERE = @sWHERE + '
	AND CONVERT(VARCHAR(10),AT90.VoucherDate,112) = '''+CONVERT(VARCHAR(10),@ReturnDate,112)+''' '
IF LTRIM(STR(ISNULL(@IsPeriodTax,0))) = 1	SET @sWHERE = @sWHERE + '
	AND (AT90.TranYear*12 + AT90.TranMonth) = '+LTRIM(STR(@TranYear*12 + @TranMonth))+' '
IF ISNULL(@IsPeriodTax,0) = 1
BEGIN
SET @sSQL1 = '
IF EXISTS (SELECT TOP 1 1 FROM AT9000 AT90 WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.TransactionTypeID = ''T97'' '+@sWHERE+')
BEGIN
SELECT AT90.SETID, AT36.SETName, AT90.SETUnitID, AT90.SETConsistID, AT36.SETClassifyID,
	   SUM(ISNULL(AT90.Quantity,0)) AS Quantity, SUM(ISNULL(AT90.SETQuantity,0)) AS SETQuantity, 
	   SUM(ISNULL(AT90.OriginalAmount,0) + ISNULL(AT90.SETOriginalAmount,0)) AS OriginalAmount, 
	   SUM(ISNULL(AT90.ConvertedAmount,0) + ISNULL(AT90.SETConvertedAmount,0)) AS ConvertedAmount,
	   SUM(ISNULL(AT90.SETOriginalAmount,0)) AS SETOriginalAmount, 
	   SUM(ISNULL(AT90.SETConvertedAmount,0)) AS SETConvertedAmount,
	   0 AS DeductSETOriAmount, 0 AS DeductSETConAmount,
	   SUM(ISNULL(AT90.SETOriginalAmount,0)) AS DeclareSETOriAmount, 
	   SUM(ISNULL(AT90.SETConvertedAmount,0)) AS DeclareSETConAmount
FROM AT9000 AT90
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
LEFT JOIN AT0136 AT36 ON AT36.DivisionID = AT90.DivisionID AND AT36.SETID = AT90.SETID
WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.TransactionTypeID = ''T97'' '+@sWHERE+'
GROUP BY AT90.SETID, AT36.SETName, AT90.SETUnitID, AT90.SETConsistID, AT36.SETClassifyID
ORDER BY AT90.SETConsistID, AT36.SETClassifyID, AT90.SETID
END
ELSE
	SELECT 1 AS IsSETIncur
'
END
EXEC (@sSQL1)
--PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

