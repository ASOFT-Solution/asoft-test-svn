IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0330]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0330]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Lấy dữ liệu mặc định 01/TAIN, 02/TAIN: Nếu @NRTTypeID = 2 thì truyền FromMonthTax,FromYearTax,ToMonthTax,ToYearTax
-- <History>
---- Create on 02/06/2015 by Lê Thị Hạnh 
-- <Example>
/*
AP0330 @DivisionID = 'vg', @TranMonth = 1, @TranYear = 2015, @ReturnDate = '2014-10-07', @IsPeriodTax = 1,
@NRTTypeID = 2, @FromMonthTax = 1, @FromYearTax = 2014, @ToMonthTax = 12, @ToYearTax = 2014
*/

CREATE PROCEDURE [dbo].[AP0330] 	
	@DivisionID NVARCHAR(50),
	@TranMonth INT,
	@TranYear INT,	
	@ReturnDate DATETIME,
	@IsPeriodTax TINYINT,
	@NRTTypeID TINYINT, --1:quyết toán thuế, 2:tờ khai phát sinh
	@FromMonthTax INT,
	@FromYearTax INT,
	@ToMonthTax INT,
	@ToYearTax INT
AS
DECLARE @sSQL1 NVARCHAR(MAX) = '',
		@sSQL2 NVARCHAR(MAX) = '',
		@sWHERE NVARCHAR(MAX) = ''

IF ISNULL(@NRTTypeID,0) = 1
BEGIN
	SET @sSQL1 = '
SELECT AT90.NRTClassifyID, AT34.NRTClassifyName, AT90.NRTUnitID, AT90.NRTConsistID, 
	   ISNULL(AT90.NRTTaxRate,0) AS NRTTaxRate, ISNULL(AT90.NRTTaxAmount,0) AS NRTTaxAmount,
	   SUM(ISNULL(AT90.Quantity,0)) AS Quantity, SUM(ISNULL(AT90.NRTQuantity,0)) AS NRTQuantity, 
	   SUM(ISNULL(AT90.NRTOriginalAmount,0)) AS NRTOriginalAmount, 
	   SUM(ISNULL(AT90.NRTConvertedAmount,0)) AS NRTConvertedAmount,
	   0 AS DeductNRTOriAmount, 0 AS DeductNRTConAmount,
	   SUM(ISNULL(AT90.OriginalAmount,0)) AS DeclareNRTOriAmount, 
	   SUM(ISNULL(AT90.ConvertedAmount,0)) AS DeclareNRTConAmount,
	   SUM(ISNULL(AT90.NRTOriginalAmount,0))/SUM(CASE WHEN ISNULL(AT90.NRTQuantity,1) = 0 THEN 1 ELSE ISNULL(AT90.NRTQuantity,1) END) AS NRTOriPerUnit,
	   SUM(ISNULL(AT90.NRTOriginalAmount,0))/SUM(CASE WHEN ISNULL(AT90.NRTQuantity,1) = 0 THEN 1 ELSE ISNULL(AT90.NRTQuantity,1) END) AS NRTPerUnit,
	   0 AS NRTOriDeclare, 0 AS NRTConDeclare, 0 AS NRTOriValidate, 0 AS NRTConValidate
FROM AT9000 AT90
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
LEFT JOIN AT0134 AT34 ON AT34.DivisionID = AT90.DivisionID AND AT34.NRTClassifyID = AT90.NRTClassifyID
WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.TransactionTypeID = ''T95''
	  AND (AT90.TranYear*12 + AT90.TranMonth) BETWEEN '+LTRIM(STR(@FromYearTax*12 + @FromMonthTax))+' AND '+LTRIM(STR(@ToYearTax*12 + @ToMonthTax))+'
GROUP BY AT90.NRTClassifyID, AT34.NRTClassifyName, AT90.NRTUnitID, AT90.NRTConsistID, AT90.NRTTaxRate, AT90.NRTTaxAmount
ORDER BY AT90.NRTConsistID, AT90.NRTClassifyID
'
EXEC (@sSQL1)
END
IF ISNULL(@NRTTypeID,0) = 2 --AND ISNULL(@IsPeriodTax,0) = 1
BEGIN
IF LTRIM(STR(ISNULL(@IsPeriodTax,0))) = 0	SET @sWHERE = @sWHERE + '
	AND CONVERT(VARCHAR(10),AT90.VoucherDate,112) = '''+CONVERT(VARCHAR(10),@ReturnDate,112)+''' '
IF LTRIM(STR(ISNULL(@IsPeriodTax,0))) = 1	SET @sWHERE = @sWHERE + '
	AND (AT90.TranYear*12 + AT90.TranMonth) = '+LTRIM(STR(@TranYear*12 + @TranMonth))+' '
SET @sSQL1 = '
SELECT AT90.NRTClassifyID, AT34.NRTClassifyName, AT90.NRTUnitID, AT90.NRTConsistID, 
	   ISNULL(AT90.NRTTaxRate,0) AS NRTTaxRate, ISNULL(AT90.NRTTaxAmount,0) AS NRTTaxAmount,
	   SUM(ISNULL(AT90.Quantity,0)) AS Quantity, SUM(ISNULL(AT90.NRTQuantity,0)) AS NRTQuantity, 
	   SUM(ISNULL(AT90.NRTOriginalAmount,0)) AS NRTOriginalAmount, 
	   SUM(ISNULL(AT90.NRTConvertedAmount,0)) AS NRTConvertedAmount,
	   0 AS DeductNRTOriAmount, 0 AS DeductNRTConAmount,
	   SUM(ISNULL(AT90.OriginalAmount,0)) AS DeclareNRTOriAmount, 
	   SUM(ISNULL(AT90.ConvertedAmount,0)) AS DeclareNRTConAmount,
	   SUM(ISNULL(AT90.NRTOriginalAmount,0))/SUM(CASE WHEN ISNULL(AT90.NRTQuantity,1) = 0 THEN 1 ELSE ISNULL(AT90.NRTQuantity,1) END) AS NRTOriPerUnit,
	   SUM(ISNULL(AT90.NRTOriginalAmount,0))/SUM(CASE WHEN ISNULL(AT90.NRTQuantity,1) = 0 THEN 1 ELSE ISNULL(AT90.NRTQuantity,1) END) AS NRTPerUnit
FROM AT9000 AT90
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = AT90.DivisionID AND AT13.InventoryID = AT90.InventoryID
LEFT JOIN AT0134 AT34 ON AT34.DivisionID = AT90.DivisionID AND AT34.NRTClassifyID = AT90.NRTClassifyID
WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.TransactionTypeID = ''T95'' '+@sWHERE+'
GROUP BY AT90.NRTClassifyID, AT34.NRTClassifyName, AT90.NRTUnitID, AT90.NRTConsistID, AT90.NRTTaxRate, AT90.NRTTaxAmount
ORDER BY AT90.NRTConsistID, AT90.NRTClassifyID
'
EXEC (@sSQL1)
END


PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

