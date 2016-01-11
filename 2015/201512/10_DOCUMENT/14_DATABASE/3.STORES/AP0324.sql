IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0324]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0324]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Lấy dữ liệu mặc định PL 01-1/TTĐB: Hàng hoá chịu thuế TTĐB
-- <History>
---- Create on 29/05/2015 by Lê Thị Hạnh 
-- <Example>
/*
AP0324 @DivisionID = 'vg', @TranMonth = 1, @TranYear = 2015, @ReturnDate = '2014-10-07', @IsPeriodTax = 1
*/

CREATE PROCEDURE [dbo].[AP0324] 	
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
SELECT AT90.VoucherID, AT90.Serial, AT90.InvoiceNo, AT90.InvoiceDate, 
	   AT90.InventoryID, AT13.InventoryName, AT90.SETID, AT36.SETName, 
	   ISNULL(AT90.Quantity,0) AS Quantity, ISNULL(AT90.SETQuantity,0) AS SETQuantity, 
	   ISNULL(AT90.UnitPrice,0) AS UnitPrice, ISNULL(AT90.ConvertedPrice,0) AS ConvertedPrice,
	   (ISNULL(AT90.OriginalAmount,0) + ISNULL(AT90.SETOriginalAmount,0))/(CASE WHEN ISNULL(AT90.Quantity,1) = 0 THEN 1 ELSE ISNULL(AT90.Quantity,1) END) AS ApxOriUnitPrice,
	   (ISNULL(AT90.ConvertedAmount,0) + ISNULL(AT90.SETConvertedAmount,0))/(CASE WHEN ISNULL(AT90.Quantity,1) = 0 THEN 1 ELSE ISNULL(AT90.Quantity,1) END) AS ApxUnitPrice,
	   (ISNULL(AT90.OriginalAmount,0) + ISNULL(AT90.SETOriginalAmount,0)) AS SETOriginalAmount, 
	   (ISNULL(AT90.ConvertedAmount,0) + ISNULL(AT90.SETConvertedAmount,0)) AS SETConvertedAmount, 
	   AT90.ObjectID, AT12.ObjectName
FROM AT9000 AT90
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
LEFT JOIN AT0136 AT36 ON AT36.DivisionID = AT90.DivisionID AND AT36.SETID = AT90.SETID
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = AT90.DivisionID AND AT12.ObjectID = AT90.ObjectID
WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.TransactionTypeID = ''T04'' 
	  AND ISNULL(AT90.AssignedSET,0) = 1 '+@sWHERE+'
ORDER BY AT90.InvoiceDate,AT90.Serial, AT90.InvoiceNo, AT90.Orders
'
END
EXEC (@sSQL1)
--PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

