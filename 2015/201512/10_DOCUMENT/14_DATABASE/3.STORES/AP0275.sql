IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0275]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0275]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




---- Created by: Khanh Van
---- Date: 08/03/2013
---- Purpose: Loc danh sach cong no phai thu/phai tra dau ky
---- Edit by: Dang Le Bao Quynh; 01/04/2013; Sua loi sub query tra ra nhieu row bang cau Select Top 1
---- Modify on 08/04/2013 by Bao Anh: Bo sung 10 MPT
---- Modify on 27/05/2013 by Khanh Van: Lay len cac phieu T99
---- Modify on 20/09/2013 by Khanh Van: Update lai store nham cai thien toc do
---- Modify on 04/12/2014 by Thanh Sơn: Bổ sung thêm điều kiện RetransactionID
CREATE PROCEDURE AP0275
(	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
  	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,  
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT, ----0 theo ky, 1 theo ngày
	@Mode TINYINT,---0 cong no phai thu, 1 cong no phai tra
	@ObjectID NVARCHAR(50),
	@TransactionTypeID NVARCHAR (50), 
	@ConditionVT NVARCHAR(1000),
	@IsUsedConditionVT NVARCHAR(1000),
	@ConditionOB NVARCHAR(1000),
	@IsUsedConditionOB NVARCHAR(1000)
)			
AS
DECLARE @sqlSelect NVARCHAR(MAX),
		@sqlSelect1 NVARCHAR(MAX),
		@sqlWhere  NVARCHAR(MAX)

IF @IsDate = 0 SET  @sqlWhere = '
	AND TranMonth + TranYear * 100 BETWEEN '+STR(@FromMonth + @FromYear * 100)+' AND '+STR(@ToMonth + @ToYear * 100)+' '
ELSE SET @sqlWhere = N'
	AND CONVERT(VARCHAR, VoucherDate, 112) BETWEEN '''+CONVERT(VARCHAR, @FromDate, 112)+''' AND '''+CONVERT(VARCHAR, @ToDate, 112)+''' '
	
IF @Mode = 0
BEGIN
	SET @sqlSelect1 = '
SELECT AT9000.DivisionID, AT9000.VoucherID, AT9000.TransactionID, ISNULL(OriginalAmount, 0) - ISNULL(OriginalAmountPT, 0) EndOriginalAmount,
ISNULL(ConvertedAmount, 0) - ISNULL(ConvertedAmountPT, 0) EndConvertedAmount
INTO #Temp
FROM
(
	(
		SELECT AT9000.DivisionID, TranMonth, TranYear, VoucherID, VoucherDate, BatchID, Invoiceno, TransactionID, TransactionTypeID,
		(CASE WHEN (TransactionTypeID = ''T99'' AND CreditAccountID IN 
				(SELECT AccountID FROM AT1005 WHERE GroupID = ''G03'' AND IsObject = 1 AND AT9000.DivisionID = AT1005.DivisionID))
			  THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) ObjectID,
		(CASE WHEN CreditAccountID IN 
				(SELECT AccountID FROM AT1005 WHERE GroupID = ''G03'' AND IsObject = 1 AND AT9000.DivisionID = AT1005.DivisionID)
			  THEN CreditAccountID ELSE DebitAccountID END) AS DebitAccountID,
		ISNULL(SUM(AT9000.OriginalAmount), 0) OriginalAmount,
		ISNULL(SUM(AT9000.ConvertedAmount), 0) ConvertedAmount
	FROM AT9000 
	WHERE TransactionTypeID = '''+@TransactionTypeID+'''
		AND (CASE WHEN TransactionTypeID IN (''T01'',''T21'') THEN AT9000.CreditAccountID ELSE DebitAccountID END)
			IN (SELECT AccountID FROM AT1005 WHERE GroupID = ''G03'' AND IsObject = 1 AND AT9000.DivisionID = AT1005.DivisionID)
	GROUP BY AT9000.DivisionID, TranMonth, TranYear, VoucherID, VoucherDate, BatchID, Invoiceno, TransactionID,
		TransactionTypeID, AT9000.CreditObjectID , AT9000.ObjectID , AT9000.DebitAccountID, CreditAccountID
	) AT9000
LEFT JOIN
	(
		SELECT AT9000.DivisionID, AT9000.TVoucherID, TBatchID, ReTransactionID, SUM(AT9000.OriginalAmount) OriginalAmountPT,
			(CASE WHEN CreditAccountID IN (SELECT AccountID FROM AT1005 WHERE GroupID =	''G03'' AND IsObject = 1 AND AT9000.DivisionID = AT1005.DivisionID)
					THEN CreditAccountID ELSE DebitAccountID END) CreditaccountID,
			SUM(AT9000.ConvertedAmount) ConvertedAmountPT, InvoiceNo,
			(CASE WHEN (TransactionTypeID = ''T99'' AND CreditAccountID IN 
						(SELECT AccountID FROM AT1005 WHERE GroupID = ''G03'' and IsObject = 1 AND AT9000.DivisionID = AT1005.DivisionID))
				    THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) ObjectID
		FROM AT9000 
		WHERE TransactionTypeID IN (''T01'',''T21'',''T99'',''T02'',''T22'') AND ISNULL(TVoucherID, '''') <> ''''
		GROUP BY DivisionID, TVoucherID, TBatchID, ReTransactionID, InvoiceNo, TransactionTypeID, CreditObjectID, ObjectID, CreditAccountID, DebitAccountID
	) K ON AT9000.DivisionID = K.DivisionID AND AT9000.VoucherID = K.TVoucherID AND AT9000.TransactionID = K.ReTransactionID
			AND AT9000.BatchID = K.TBatchID AND AT9000.ObjectID = K.ObjectID AND CreditAccountID = DebitAccountID AND ISNULL(AT9000.InvoiceNo,'''') = ISNULL(K.InvoiceNo,''''))
WHERE AT9000.DivisionID = '''+@DivisionID+ ''' '+@sqlWhere
	
	SET @sqlSelect = '
SELECT CONVERT(TINYINT, 0) AS [Choose], AT9000.DivisionID, AT9000.VoucherTypeID, AT9000.VoucherID, AT9000.BatchID, VoucherDate, VoucherNo,
	Serial, InvoiceNo, InvoiceDate, TransactionID, TransactionTypeID, VDescription, BDescription, AT9000.ObjectID, ObjectName, AT1202.VATNo,
	AT1202.IsUpdateName, AT9000.CurrencyID, ExchangeRate,
	(CASE WHEN TransactionTypeID IN (''T01'',''T21'') THEN AT9000.CreditAccountID ELSE DebitAccountID END) AccountID,
	(CASE WHEN TransactionTypeID IN (''T01'',''T21'') THEN AT9000.DebitAccountID ELSE CreditAccountID END) AccountID2,
	MAX(AT9000.Ana01ID) Ana01ID, MAX(AT9000.Ana02ID) Ana02ID, MAX(AT9000.Ana03ID) Ana03ID, MAX(AT9000.Ana04ID) Ana04ID, MAX(AT9000.Ana05ID) Ana05ID,
	MAX(AT9000.Ana06ID) Ana06ID, MAX(AT9000.Ana07ID) Ana07ID, MAX(AT9000.Ana08ID) Ana08ID, MAX(AT9000.Ana09ID) Ana09ID, MAX(AT9000.Ana10ID) Ana10ID,
	SUM(OriginalAmount) OriginalAmount, SUM(ConvertedAmount) ConvertedAmount,
	(SELECT TOP 1 EndOriginalAmount FROM #Temp 
		WHERE DivisionID = AT9000.DivisionID AND VoucherID = AT9000.VoucherID AND TransactionID = AT9000.TransactionID) EndOriginalAmount,
	(SELECT TOP 1 EndConvertedAmount FROM #Temp
		WHERE DivisionID = AT9000.DivisionID AND VoucherID = AT9000.VoucherID AND TransactionID = AT9000.TransactionID) EndConvertedAmount,
	InvoiceCode, InvoiceSign
FROM AT9000
	LEFT JOIN AT1202 ON AT1202.DivisionID = AT9000.DivisionID AND AT1202.ObjectID = AT9000.ObjectID
WHERE AT9000.DivisionID = '''+@DivisionID+ ''' 
	AND AT9000.ObjectID LIKE '''+@ObjectID+ '''
	AND TransactionID IN (SELECT TransactionID FROM #Temp WHERE DivisionID = '''+@DivisionID+''' AND EndOriginalAmount > 0)
	AND TransactionTypeID = '''+@TransactionTypeID+''' '
	SET @sqlWhere = @sqlWhere + '
	AND (ISNULL(AT9000.VoucherTypeID,''#'') IN '+@ConditionVT+' OR '+@IsUsedConditionVT+')
	AND (ISNULL(AT9000.ObjectID,''#'') IN '+@ConditionOB+' OR '+@IsUsedConditionOB+')'

	SET @sqlWhere = @sqlWhere + '		
GROUP BY AT9000.DivisionID, AT9000.VoucherTypeID, AT9000.VoucherID, AT9000.BatchID, VoucherDate, VoucherNo,
	Serial, InvoiceNo, InvoiceCode, InvoiceSign, InvoiceDate, TransactionId,TransactionTypeID, VDescription,
	BDescription, AT9000.ObjectID, ObjectName, AT1202.VATNo, AT1202.IsUpdateName, AT9000.CurrencyID, ExchangeRate,
	(CASE WHEN TransactionTypeID IN (''T01'',''T21'') THEN AT9000.CreditAccountID ELSE DebitAccountID END),
	(CASE WHEN TransactionTypeID in (''T01'',''T21'') THEN AT9000.DebitAccountID ELSE CreditAccountID END)'
END			
ELSE
BEGIN
	SET @sqlSelect1 = '
SELECT AT9000.DivisionID, AT9000.VoucherID, AT9000.TransactionID, (ISNULL(OriginalAmount, 0) - ISNULL(OriginalAmountPT, 0)) EndOriginalAmount,
	(ISNULL(ConvertedAmount, 0) - ISNULL(ConvertedAmountPT, 0)) EndConvertedAmount
INTO #Temp
FROM
	(
		(
			SELECT AT9000.DivisionID, TranMonth, TranYear, VoucherID, VoucherDate, BatchID, Invoiceno, TransactionID,
				(CASE WHEN (TransactionTypeID = ''T99'' AND CreditAccountID IN 
							(SELECT AccountID FROM AT1005 WHERE GroupID = ''G04'' AND IsObject = 1 AND AT9000.DivisionID= AT1005.DivisionID))
					  THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) ObjectID,
				(CASE WHEN CreditAccountID IN
							(SELECT AccountID FROM AT1005 WHERE GroupID = ''G04'' AND IsObject = 1 AND AT9000.DivisionID = AT1005.DivisionID)
				  THEN CreditAccountID ELSE DebitAccountID END) CreditAccountID,
				ISNULL(SUM(AT9000.OriginalAmount), 0) OriginalAmount, ISNULL(SUM(AT9000.ConvertedAmount), 0) ConvertedAmount
			FROM AT9000 
			WHERE TransactionTypeID = '''+@TransactionTypeID+'''
				AND (CASE WHEN TransactionTypeID IN (''T02'',''T22'') THEN AT9000.DebitAccountID ELSE CreditAccountID END) IN
							(SELECT AccountID FROM AT1005 WHERE GroupID = ''G04'' AND IsObject = 1 AND AT9000.DivisionID = AT1005.DivisionID)
			GROUP BY AT9000.DivisionID, TranMonth, TranYear, VoucherID, VoucherDate, BatchID, Invoiceno, TransactionID, TransactionTypeID,
				AT9000.CreditObjectID, AT9000.ObjectID, AT9000.DebitAccountID, CreditAccountID
		) AT9000
	LEFT JOIN
		(
			SELECT DivisionID, TVoucherID, TBatchID, ReTransactionID, SUM(OriginalAmount) OriginalAmountPT,
				(CASE WHEN CreditAccountID IN 
						(SELECT AccountID FROM AT1005 WHERE GroupID = ''G04'' AND IsObject = 1 AND AT9000.DivisionID = AT1005.DivisionID)
					  THEN CreditAccountID ELSE DebitAccountID END)DebitAccountID,
				SUM(ConvertedAmount) ConvertedAmountPT, InvoiceNo,
				(CASE WHEN (TransactionTypeID = ''T99'' AND CreditAccountID IN 
						(SELECT AccountID FROM AT1005 WHERE GroupID = ''G04'' AND IsObject = 1 AND AT9000.DivisionID= AT1005.DivisionID))
					  THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) ObjectID
			FROM AT9000
			WHERE TransactionTypeID IN (''T02'',''T22'',''T99'',''T01'',''T21'') AND ISNULL(TVoucherID, '''') <> ''''
			GROUP BY DivisionID, TVoucherID, TBatchID, InvoiceNo, ReTransactionID, TransactionTypeID, CreditObjectID, ObjectID, CreditAccountID, DebitAccountID 
			)K ON AT9000.DivisionID = K.DivisionID AND AT9000.VoucherID = K.TVoucherID AND AT9000.BatchID = K.TBatchID AND AT9000.TransactionID = K.ReTransactionID
					AND AT9000.ObjectID = K.ObjectID AND CreditAccountID = DebitAccountID AND ISNULL(AT9000.InvoiceNo, '''') = ISNULL(K.InvoiceNo, ''''))
	WHERE	AT9000.DivisionID =N'''+@DivisionID+N''''+@sqlWhere
--Print @sqlSelect1 +@sqlWhere
	SET @sqlSelect = '
		SELECT CONVERT(TINYINT, 0) AS [Choose], AT9000.DivisionID, AT9000.VoucherTypeID, AT9000.VoucherID, AT9000.BatchID, VoucherDate,
			VoucherNo, Serial, InvoiceNo, InvoiceDate, TransactionID, TransactionTypeID, VDescription, BDescription,
			(CASE WHEN TransactionTypeID = ''T99'' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) ObjectID,
			ObjectName, AT1202.VATNo, AT1202.IsUpdateName, AT9000.CurrencyID, ExchangeRate,
			(CASE WHEN TransactionTypeID IN (''T02'',''T22'') THEN AT9000.CreditAccountID ELSE DebitAccountID END) AccountID2,
			(CASE WHEN TransactionTypeID IN (''T02'',''T22'') THEN AT9000.DebitAccountID ELSE CreditAccountID END) AccountID,
			MAX(AT9000.Ana01ID) Ana01ID, MAX(AT9000.Ana02ID) Ana02ID, MAX(AT9000.Ana03ID) Ana03ID, MAX(AT9000.Ana04ID) Ana04ID, MAX(AT9000.Ana05ID) Ana05ID,
			MAX(AT9000.Ana06ID) Ana06ID, MAX(AT9000.Ana07ID) Ana07ID, MAX(AT9000.Ana08ID) Ana08ID, MAX(AT9000.Ana09ID) Ana09ID, MAX(AT9000.Ana10ID) Ana10ID,
			SUM(OriginalAmount) OriginalAmount, SUM(ConvertedAmount) ConvertedAmount, 
			(SELECT TOP 1 EndOriginalAmount FROM #Temp 
				WHERE DivisionID = '''+@DivisionID+''' AND VoucherID = AT9000.VoucherID AND TransactionID = AT9000.TransactionID) EndOriginalAmount,
			(SELECT TOP 1 EndConvertedAmount From #Temp 
				WHERE DivisionID = '''+@DivisionID+''' And VoucherID = AT9000.VoucherID And TransactionID = AT9000.TransactionID) as EndConvertedAmount
		,InvoiceCode,InvoiceSign
		FROM AT9000 
		LEFT JOIN AT1202 ON AT1202.DivisionID = AT9000.DivisionID AND AT1202.ObjectID = (CASE WHEN TransactionTypeID = ''T99'' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END)
		WHERE AT9000.DivisionID = '''+@DivisionID+'''
		AND (CASE WHEN TransactionTypeID = ''T99'' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) LIKE '''+@ObjectID+'''
		AND TransactionID IN (SELECT TransactionID FROM #Temp WHERE DivisionID = '''+@DivisionID+''' AND EndOriginalAmount > 0)'
--	 and TransactionTypeID = '''+@TransactionTypeID+''''
	SET @sqlWhere = @sqlWhere + '
	AND (ISNULL(AT9000.VoucherTypeID,''#'') IN '+@ConditionVT+' OR '+@IsUsedConditionVT+')
	AND (ISNULL(AT9000.ObjectID,''#'') IN '+@ConditionOB+' OR '+@IsUsedConditionOB+')'
					
	SET @sqlWhere = @sqlWhere + '
	GROUP BY AT9000.DivisionID, AT9000.VoucherTypeID, AT9000.VoucherID, AT9000.BatchID, VoucherDate, VoucherNo,
		Serial, InvoiceNo,InvoiceCode,InvoiceSign, InvoiceDate, Transactionid,TransactionTypeID, VDescription, BDescription,
		(CASE WHEN TransactionTypeID = ''T99'' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END),
		ObjectName, AT1202.VATNo, AT1202.IsUpdateName, AT9000.CurrencyID, ExchangeRate,
		(CASE WHEN TransactionTypeID in (''T02'',''T22'') THEN AT9000.CreditAccountID ELSE DebitAccountID END),
		(CASE WHEN TransactionTypeID in (''T02'',''T22'') THEN AT9000.DebitAccountID ELSE CreditAccountID END)'
END

EXEC (@sqlSelect1 + @sqlSelect + @sqlWhere)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
