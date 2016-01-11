IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP03202]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP03202]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load danh sách phiếu mua hàng - Phân bổ chi phí mua hàng[Customize LAVO]
-- <History>
---- Create on 03/03/2015 by Lê Thị Hạnh 
---- Modified on 17/04/2015 by Lê Thị Hạnh: Loại các phiếu mua hàng đã nhập chi phí mua hàng T23
-- <Example>
/*
 AP03202 @DivisionID = 'LV', @FromMonth=01,@FromYear=2015,@ToMonth=03,@ToYear=2015, 
 @FromDate = '2015-01-01', @ToDate = '2015-03-10', @IsDate = 0, @CurrencyID = '%', @ObjectID = '%'
 */

CREATE PROCEDURE [dbo].[AP03202] 	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,	
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT,
	@CurrencyID NVARCHAR(50),
	@ObjectID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX) = '',
		@sWHERE NVARCHAR(MAX) = ''

IF LTRIM((@IsDate)) = 1	SET @sWHERE = @sWHERE + '
AND CONVERT(VARCHAR(10),AT90.VoucherDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
IF LTRIM((@IsDate)) = 0	SET @sWHERE = @sWHERE + '
AND (AT90.TranYear*12 + AT90.TranMonth) BETWEEN '+LTRIM((@FromYear*12 + @FromMonth))+' AND '+LTRIM((@ToYear*12 + @ToMonth))+' '

SET @sSQL1 = '
SELECT AT90.VoucherID, AT90.BatchID, AT90.VoucherDate, AT90.VoucherTypeID, AT90.VoucherNo, 
	   AT90.ObjectID, AT12.ObjectName, AT90.VATTypeID, AT90.InvoiceNo, AT90.InvoiceDate,
	   AT90.Serial, AT90.VDescription,  
	   SUM(ISNULL(AT90.OriginalAmount,0)) AS OriginalAmount, 
	   SUM(ISNULL(AT90.ConvertedAmount,0)) AS ConvertedAmount, 
	   AT90.CurrencyID, ISNULL(AT90.ExchangeRate,0) AS ExchangeRate, 
	   ISNULL(AT90.IsStock,0) AS IsStock, 
	   ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal, CONVERT(TINYINT,0) AS [Check]
FROM AT9000 AT90
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = AT90.DivisionID AND AT12.ObjectID = AT90.ObjectID
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = AT90.DivisionID AND AT14.CurrencyID = AT90.CurrencyID
WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.TransactionTypeID IN (''T03'')
	  AND AT90.CurrencyID LIKE '''+@CurrencyID+''' 
	  AND AT90.ObjectID LIKE '''+@ObjectID+''' 
	  AND AT90.VoucherID NOT IN (SELECT DISTINCT VoucherID
	                             FROM AT9000 WHERE DivisionID = '''+@DivisionID+''' AND TransactionTypeID IN (''T23''))
	  AND AT90.VoucherID NOT IN (SELECT DISTINCT AT321.POVoucherID
	                             FROM AT0321 AT321 WHERE AT321.DivisionID = '''+@DivisionID+''')	                       
	  '+@sWHERE+'
GROUP BY AT90.VoucherID, AT90.BatchID, AT90.VoucherDate, AT90.VoucherTypeID, AT90.VoucherNo, 
	     AT90.ObjectID, AT12.ObjectName, AT90.VATTypeID, AT90.InvoiceNo, AT90.InvoiceDate,
	     AT90.Serial, AT90.VDescription, AT90.CurrencyID, AT90.ExchangeRate, AT90.IsStock,
	     AT14.ExchangeRateDecimal
ORDER BY AT90.VoucherDate
'
EXEC (@sSQL1)
--PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
