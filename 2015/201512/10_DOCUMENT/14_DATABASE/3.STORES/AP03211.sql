IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP03211]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP03211]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load lưới chi phí mua hàng - Cập nhật phân bổ chi phí mua hàng[Customize LAVO] TH VIEW/EDIT
-- <History>
---- Create on 03/03/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
 AP03211 @DivisionID = 'LV', @VoucherID = null, @VoucherIDList = 'AV201500000064'',''AVcdec0d61-8530-405b-9eae-f91424eb58c6'
 */

CREATE PROCEDURE [dbo].[AP03211] 	
	@DivisionID NVARCHAR(50),
	@VoucherID NVARCHAR(50),
	@VoucherIDList NVARCHAR(MAX)
AS
DECLARE @sSQL1 NVARCHAR(MAX) = '',
		@sWHERE NVARCHAR(MAX) = ''

IF ISNULL(@VoucherID,'') <> '' -- Trường hợp Load form gọi từ AF0302
	BEGIN
/*
SELECT AT21.POCVoucherID AS VoucherID, AT90.BatchID, AT90.InvoiceNo, AT90.VoucherDate, AT90.VoucherNo, AT90.VoucherTypeID, 
	   AT90.VDescription, 
	   SUM(ISNULL(AT90.OriginalAmount,0)) AS OriginalAmount, 
	   SUM(ISNULL(AT90.ConvertedAmount,0)) AS ConvertedAmount, 
	   AT90.CurrencyID, ISNULL(AT90.ExchangeRate,0) AS ExchangeRate, 
	   ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal
FROM AT0321 AT21
LEFT JOIN AT9000 AT90 ON AT90.DivisionID = AT21.DivisionID AND AT90.VoucherID = AT21.POCVoucherID
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = AT90.DivisionID AND AT14.CurrencyID = AT90.CurrencyID
WHERE AT35.DivisionID = '''+@DivisionID+''' AND AT35.VoucherID = '''+@VoucherID+''' 
	  AND AT90.TransactionTypeID IN (''T99'',''T22'',''T02'') AND ISNULL(AT90.IsPOCost,0) = 1
GROUP BY AT21.POCVoucherID, AT90.BatchID, AT90.TransactionTypeID, AT90.InvoiceNo, 
	     AT90.VoucherDate, AT90.VoucherNo, AT90.VoucherTypeID, 
	     AT90.VDescription, 
	     AT90.CurrencyID, AT90.ExchangeRate, AT14.ExchangeRateDecimal
ORDER BY AT90.VoucherDate
' */
	SET @sSQL1 = '
SELECT AT21.POCVoucherID AS VoucherID, AT90.BatchID, AT90.InvoiceNo, AT90.VoucherDate, AT90.VoucherNo, AT90.VoucherTypeID, 
	   AT90.VDescription, 
	   ISNULL(AT90.OriginalAmount,0) AS OriginalAmount, 
	   ISNULL(AT90.ConvertedAmount,0) AS ConvertedAmount, 
	   AT90.CurrencyID, ISNULL(AT90.ExchangeRate,0) AS ExchangeRate, 
	   ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal
FROM AT0321 AT21
LEFT JOIN 
(
	SELECT AT90.DivisionID, AT90.TransactionTypeID, AT90.VoucherID, AT90.BatchID, AT90.InvoiceNo, 
		   AT90.VoucherDate, AT90.VoucherNo, AT90.VoucherTypeID, AT90.VDescription, 
		   SUM(ISNULL(AT90.OriginalAmount,0)) AS OriginalAmount, 
		   SUM(ISNULL(AT90.ConvertedAmount,0)) AS ConvertedAmount, 
		   AT90.CurrencyID, ISNULL(AT90.ExchangeRate,0) AS ExchangeRate
	FROM AT9000 AT90
	WHERE AT90.DivisionID = '''+@DivisionID+'''
		  AND AT90.TransactionTypeID IN (''T99'',''T22'',''T02'') AND ISNULL(AT90.IsPOCost,0) = 1 AND AT90.DebitAccountID NOT LIKE ''1331%''
	GROUP BY  AT90.DivisionID, AT90.TransactionTypeID, AT90.VoucherID, AT90.BatchID, AT90.InvoiceNo, 
		      AT90.VoucherDate, AT90.VoucherNo, AT90.VoucherTypeID, AT90.VDescription, 
	          AT90.CurrencyID, AT90.ExchangeRate
) AS AT90 ON AT90.DivisionID = AT21.DivisionID AND AT90.VoucherID = AT21.POCVoucherID
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = AT90.DivisionID AND AT14.CurrencyID = AT90.CurrencyID
WHERE AT21.DivisionID = '''+@DivisionID+''' AND AT21.VoucherID = '''+@VoucherID+''' 
GROUP BY AT21.POCVoucherID , AT90.BatchID, AT90.InvoiceNo, AT90.VoucherDate, AT90.VoucherNo, AT90.VoucherTypeID, 
	   AT90.VDescription, AT90.CurrencyID, AT90.ExchangeRate, 
	   AT90.OriginalAmount, AT90.ConvertedAmount, AT14.ExchangeRateDecimal
ORDER BY AT90.VoucherDate
'

	END
ELSE -- Trường hợp Load form gọi từ AF0300
	BEGIN
	SET @sSQL1 = '
SELECT AT90.VoucherID, AT90.BatchID, AT90.InvoiceNo, AT90.VoucherDate, AT90.VoucherNo, AT90.VoucherTypeID, 
	   AT90.VDescription, 
	   SUM(ISNULL(AT90.OriginalAmount,0)) AS OriginalAmount, 
	   SUM(ISNULL(AT90.ConvertedAmount,0)) AS ConvertedAmount, 
	   AT90.CurrencyID, ISNULL(AT90.ExchangeRate,0) AS ExchangeRate, ISNULL(AT14.ExchangeRateDecimal,0) AS ExchangeRateDecimal
FROM AT9000 AT90
LEFT JOIN AT1004 AT14 ON AT14.DivisionID = AT90.DivisionID AND AT14.CurrencyID = AT90.CurrencyID
WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.TransactionTypeID IN (''T99'',''T22'',''T02'')
	  AND AT90.VoucherID IN ('''+@VoucherIDList+''')
	  AND ISNULL(AT90.IsPOCost,0) = 1 AND AT90.DebitAccountID NOT LIKE ''1331%''
GROUP BY AT90.VoucherID, AT90.BatchID, AT90.TransactionTypeID, AT90.InvoiceNo, 
	     AT90.VoucherDate, AT90.VoucherNo, AT90.VoucherTypeID, 
	     AT90.VDescription, 
	     AT90.CurrencyID, AT90.ExchangeRate, AT14.ExchangeRateDecimal
ORDER BY AT90.VoucherDate
'
	END

EXEC (@sSQL1)
--PRINT @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
