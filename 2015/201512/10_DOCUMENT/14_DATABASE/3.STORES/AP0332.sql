IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0332]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0332]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Lấy dữ liệu mặc định tờ khai thuế nhà thầu
-- <History>
---- Create on 12/11/2015 by Phương Thảo
-- <Example>
/*
exec AP0332 @DivisionID = 'vg', @TranMonth = 1, @TranYear = 2015, @ReturnDate = '2014-10-07', @IsPeriodTax = 1
*/

CREATE PROCEDURE [dbo].[AP0332] 	
	@DivisionID NVARCHAR(50),
	@TranMonth INT,
	@TranYear INT,	
	@ReturnDate DATETIME,
	@IsPeriodTax TINYINT	
AS
DECLARE	@sSQL NVARCHAR(4000) = '',
		@sSQL1 NVARCHAR(4000) = '',
		@sWhere NVARCHAR(4000) = ''


IF (@IsPeriodTax = 0)
BEGIN
	SET @sWhere = 'AND (AT9000.VoucherDate = '''+Convert(Varchar(20),@ReturnDate,101)+''')'
END
ELSE
BEGIN
	SET @sWhere = 'AND (AT9000.TranMonth + AT9000.TranYear*100 = '+STR(@TranMonth+@TranYear*100)+')'
END

SET @sSQL = N'
SELECT	AT9000.VoucherID, AT9000.BatchID, AT9000.DivisionID,
		AT1101.VATNO AS WTNo,
		AT9000.TDescription AS WTDescription, AT9000.ObjectID, AT9000.VoucherNo, AT9000.InvoiceNo, AT9000.Serial, 
		-- Doanh Thu tinh thue VND (len bao cao theo HTKK)
		AT9000.TaxBaseAmount, 
		-- Doanh thu chua bao gom thue VND (len bao cao theo HTKK)
		Convert(money,0) AS NetPayAmount,		
		-- Doanh thu chua bao gom thue NT (len bao cao dac thu KH)
		Convert(money,0) AS OAmount,  
		-- Doanh thu chua bao gom thue QD (len bao cao dac thu KH)
		Convert(money,0) AS CAmount,
		-- Doanh thu tinh thue NT (len bao cao dac thu KH)
		CASE WHEN WTCOperator = 0 THEN TaxBaseAmount/WTCExchangeRate ELSE TaxBaseAmount*WTCExchangeRate END AS AfterTaxOAmount,
		-- Convert(money,0) AS AfterTaxOAmount,  
		-- Doanh thu tinh thue QD (len bao cao dac thu KH)
		Convert(money,0) AS AfterTaxCAmount,

		AT9000.CurrencyID, AT9000.ExchangeRate,
		WTCExchangeRate,
		WTCOperator,
		
		-- Chi co gia tri khi phat sinh thue nha thau ben Ban (tam thoi chua xu ly)
		Convert(money,0) AS VATTaxBaseAmount ,
		0 AS VATRate, 0 as TaxableTurnoverRate, 0 as VATAmount,		
		AT9000.InvoiceDate AS PaymentDate, 
		AT9000.VATGroupID AS WTGroupID, 
		AT1010.VATRate  AS CITRate, 0 AS CITReduce,
		AT9000.OriginalAmount AS CITAmount, AT9000.OriginalAmount AS TotalAmount,
		AT9000.TVoucherID, AT9000.TBatchID
INTO	#AP0332
FROM	AT9000 
INNER JOIN AT1010 on AT9000.DivisionID = AT1010.DivisionID and AT9000.VATGroupID = AT1010.VATGroupID
INNER JOIN AT1101 ON AT9000.DivisionID = AT1101.DivisionID
WHERE AT9000.DivisionID = '''+@DivisionID+'''   AND TransactionTypeID = ''T43''

 ' + @sWhere

SET @sSQL1 = '
UPDATE T1
SET		T1.NetPayAmount = CASE WHEN T1.WTCOperator = 0 THEN T2.OAmount * T1.WTCExchangeRate ELSE  T2.OAmount / T1.WTCExchangeRate END,
		T1.OAmount = T2.OAmount,
		T1.CAmount = T2.CAmount,
		T1.AfterTaxCAmount = CASE WHEN T2.Operator = 0 THEN T1.AfterTaxOAmount * T2.ExchangeRate ELSE T1.AfterTaxOAmount / T2.ExchangeRate END
FROM #AP0332 T1
INNER JOIN 
(
SELECT	AT9000.VoucherID, AT9000.BatchID, AT9000.DivisionID, AT9000.CurrencyID, AT9000.ExchangeRate, AT1004.Operator,
		-- Tien truoc thue NT
		SUM(CASE WHEN ISNULL(AT1010.VATRate,0) <> 0  THEN AT9000.OriginalAmount/(1+ AT1010.VATRate/100) ELSE AT9000.OriginalAmount END) AS OAmount, 
		-- Tien truoc thue QD
		SUM(CASE WHEN ISNULL(AT1010.VATRate,0) <> 0 THEN AT9000.ConvertedAmount/(1+AT1010.VATRate/100) ELSE AT9000.ConvertedAmount END) AS CAmount,
		AT9000.TVoucherID, AT9000.TBatchID
FROM AT9000 
INNER JOIN AT1004 ON AT9000.CurrencyID = AT1004.CurrencyID AND AT9000.DivisionID = AT1004.DivisionID
LEFT JOIN AT1010 on AT9000.DivisionID = AT1010.DivisionID and AT9000.VATGroupID = AT1010.VATGroupID
WHERE AT9000.TransactionTypeID in (''T02'',''T22'')
GROUP BY AT9000.VoucherID, AT9000.BatchID, AT9000.DivisionID, AT9000.CurrencyID, AT9000.ExchangeRate,AT1004.Operator, AT9000.TVoucherID, AT9000.TBatchID
) T2
ON T1.VoucherID = T2.VoucherID AND T1.DivisionID = T2.DivisionID 
AND T1.TVoucherID = T2.TVoucherID AND T1.TBatchID = T2.TBatchID

SELECT * FROM #AP0332 ORDER BY PaymentDate, VoucherNo
'

--PRINT (@sSQL)
--PRINT (@sSQL1)
EXEC (@sSQL + @sSQL1)





GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

