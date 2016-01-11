IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0302]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0302]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Load truy vấn tài khoản
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on 17/09/2014
---- Modified on Quốc Tuấn On 19/08/2015 bổ sung thêm đối tượng đối ứng với Bút toán tổng hợp
---- Modified on 
-- <Example>
/*
	 AP0302 @DivisionID='LG',@UserID='ASOFTADMIN', @AccountID='112',@CurrencyID='%',@Ana01ID='%',@ObjectID='%',
	 @FromDate='2015-01-01 08:47:20',@ToDate='2015-03-31 08:47:20.220',@IsGeneral = 0
*/

 CREATE PROCEDURE AP0302
(
	@DivisionID VARCHAR(50),
    @UserID VARCHAR(50),
    @AccountID VARCHAR(50),
	@CurrencyID VARCHAR(50), 
	@Ana01ID VARCHAR(50),
	@ObjectID VARCHAR(50),
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsGeneral TINYINT
)
AS
DECLARE @sSQL NVARCHAR(MAX), @sSQL1 VARCHAR(10) = '', @sGroup NVARCHAR(MAX) = '', @sSQL2 NVARCHAR(MAX), @sSQL3 NVARCHAR(MAX)
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME = 'AT0300Tam' AND xtype = 'U') DROP TABLE AT0300Tam

IF @IsGeneral = 0
BEGIN
	SET @sSQL1 = 'SUM'
	SET @sGroup = 'GROUP BY A90.VoucherID, A90.VoucherNo, A90.TransactionTypeID, A90.VoucherDate, A90.VoucherTypeID, A90.TDescription,
	A90.CreditAccountID, A90.DebitAccountID, A90.Ana02ID, A02.AnaName,
	A90.InvoiceNo, A90.InvoiceDate, A12.ObjectName, A90.TableID, A90.EmployeeID, A90.RefNo01, A90.RefNo02, A90.BatchID, A90.TranMonth, A90.TranYear,
	(CASE WHEN A90.DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' THEN A90.ObjectID ELSE ISNULL(A90.CreditObjectID, A90.ObjectID) END), A12.ObjectName, A90.CurrencyID, A90.DivisionID,
	A90.ObjectID, A90.CreditObjectID, A90.VATObjectName,A90.CreditObjectName'
END

SET @sSQL = '
DECLARE @TotalAmount DECIMAL(28,8), @OriginalTotalAmount DECIMAL(28,8), @i INT = 2, @Increase DECIMAL(28,8) = 0, @OriginalIncrease DECIMAL(28,8)
SET @TotalAmount =
ISNULL(
	(SELECT SUM(ISNULL(ConvertedAmount, 0)) FROM AT9000 WHERE DivisionID = '''+@DivisionID+''' AND DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%''
		AND (CONVERT(VARCHAR, VoucherDate, 112) < '''+CONVERT(VARCHAR, @FromDate, 112)+''' OR TransactionTypeID = ''T00'')
		AND CurrencyID LIKE '''+ISNULL(@CurrencyID,'%')+'''
		AND ISNULL(Ana02ID,'''') LIKE '''+ISNULL(@Ana01ID,'%')+''' AND ISNULL(ObjectID,'''') LIKE '''+ISNULL(@ObjectID,'%')+'''), 0)
-
ISNULL(
	(SELECT SUM(ISNULL(ConvertedAmount,0)) FROM AT9000 WHERE DivisionID = '''+@DivisionID+''' AND ISNULL(CreditAccountID,'''') LIKE '''+ISNULL(@AccountID,'')+'%''
		AND (CONVERT(VARCHAR, VoucherDate, 112) < '''+CONVERT(VARCHAR, @FromDate, 112)+''' OR TransactionTypeID = ''T00'')
		AND CurrencyID LIKE '''+ISNULL(@CurrencyID,'%')+'''
		AND ISNULL(Ana02ID,'''') LIKE '''+ISNULL(@Ana01ID,'%')+''' AND ISNULL(ObjectID,'''') LIKE '''+ISNULL(@ObjectID,'%')+'''), 0)
		
SET @OriginalTotalAmount =
ISNULL(
	(SELECT SUM(ISNULL(OriginalAmount, 0)) FROM AT9000 WHERE DivisionID = '''+@DivisionID+''' AND DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%''
		AND (CONVERT(VARCHAR, VoucherDate, 112) < '''+CONVERT(VARCHAR, @FromDate, 112)+''' OR TransactionTypeID = ''T00'')
		AND (CurrencyID LIKE '''+ISNULL(@CurrencyID,'%')+''' AND CurrencyID <> ''VND'')
		AND ISNULL(Ana02ID,'''') LIKE '''+ISNULL(@Ana01ID,'%')+''' AND ISNULL(ObjectID,'''') LIKE '''+ISNULL(@ObjectID,'%')+'''), 0)
-
ISNULL(
	(SELECT SUM(ISNULL(OriginalAmount,0)) FROM AT9000 WHERE DivisionID = '''+@DivisionID+''' AND ISNULL(CreditAccountID,'''') LIKE '''+ISNULL(@AccountID,'')+'%''
		AND (CONVERT(VARCHAR, VoucherDate, 112) < '''+CONVERT(VARCHAR, @FromDate, 112)+''' OR TransactionTypeID = ''T00'')
		AND (CurrencyID LIKE '''+ISNULL(@CurrencyID,'%')+''' AND CurrencyID <> ''VND'')
		AND ISNULL(Ana02ID,'''') LIKE '''+ISNULL(@Ana01ID,'%')+''' AND ISNULL(ObjectID,'''') LIKE '''+ISNULL(@ObjectID,'%')+'''), 0)'
		
SET @sSQL2 = '
BEGIN
	WITH Temp
	AS
	(
		SELECT  1 AS RowNum, NULL VoucherID, NULL TableID, NULL EmployeeID, NULL RefNo01, NULL RefNo02, NULL BatchID,
			NULL TransactionTypeID, NULL VoucherDate, NULL VoucherTypeID, NULL VoucherNo, NULL TranMonth, NULL TranYear,
			N'''+N'Dư đầu kỳ 初期余额'+''' Description, 
			'''+@AccountID+''' AccountID, NULL RecAccountID, NULL OriginalDebitAmount, NULL OriginalCreditAmount,
			CASE WHEN @OriginalTotalAmount >= 0 THEN @OriginalTotalAmount ELSE 0 END OriginalTotalDebitAmount,
			CASE WHEN @OriginalTotalAmount < 0 THEN -1 * @OriginalTotalAmount ELSE 0 END OriginalTotalCreditAmount,
			NULL DebitAmount, NULL CreditAmount,
			CASE WHEN @TotalAmount >= 0 THEN @TotalAmount ELSE 0 END TotalDebitAmount,
			CASE WHEN @TotalAmount < 0 THEN -1 * @TotalAmount ELSE 0 END TotalCreditAmount,
			NULL Ana02ID, NULL Ana02Name,
			NULL InvoiceNo, NULL InvoiceDate, NULL ObjectID, NULL ObjectName, NULL CurrencyID, 0 ExchangeRateDecimal
		UNION ALL
		SELECT ROW_NUMBER() OVER (ORDER BY VoucherDate, VoucherTypeID, VoucherNo) + 1 AS RowNum, A90.VoucherID, A90.TableID, A90.EmployeeID, A90.RefNo01, A90.RefNo02, A90.BatchID,
			TransactionTypeID, A90.VoucherDate, A90.VoucherTypeID, A90.VoucherNo, A90.TranMonth, A90.TranYear, A90.TDescription Description,
			(CASE WHEN A90.DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' THEN A90.DebitAccountID ELSE A90.CreditAccountID END) AccountID,
			(CASE WHEN A90.DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' THEN A90.CreditAccountID ELSE A90.DebitAccountID END) RecAccountID,			
			'+@sSQL1+'(CASE WHEN A90.DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' AND A90.CurrencyID <> ''VND'' THEN A90.OriginalAmount ELSE 0 END) OriginalDebitAmount,
			'+@sSQL1+'(CASE WHEN A90.CreditAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' AND A90.CurrencyID <> ''VND'' THEN A90.OriginalAmount ELSE 0 END) OriginalCreditAmount,
			NULL OriginalTotalDebitAmount, NULL OriginalTotalCreditAmount,				
			'+@sSQL1+'(CASE WHEN A90.DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' THEN A90.ConvertedAmount ELSE 0 END) DebitAmount,
			'+@sSQL1+'(CASE WHEN A90.CreditAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' THEN A90.ConvertedAmount ELSE 0 END) CreditAmount,
			NULL TotalDebitAmount, NULL TotalCreditAmount, A90.Ana02ID, A02.AnaName Ana02Name, A90.InvoiceNo, A90.InvoiceDate,
			(CASE WHEN A90.DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' THEN A90.ObjectID ELSE (CASE WHEN A90.TransactionTypeID = ''T99'' THEN A90.CreditObjectID ELSE ISNULL(A90.CreditObjectID, A90.ObjectID) END) END) ObjectID,
			(CASE WHEN A90.TransactionTypeID = ''T99'' 
				  THEN (CASE WHEN A90.DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' THEN ISNULL(A90.VATObjectName, A12.ObjectName) ELSE 
			                (CASE WHEN A90.ObjectID = A90.CreditObjectID THEN ISNULL(A90.CreditObjectName,A12.ObjectName) ELSE A12.ObjectName END) END)
			ELSE ISNULL(A90.VATObjectName, A12.ObjectName) END) ObjectName,
			
			--A12.ObjectName,
			--(CASE WHEN A90.DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' THEN ISNULL(A90.VATObjectName, A12.ObjectName) ELSE
			--	  (CASE WHEN A90.ObjectID = A90.CreditObjectID THEN A90.VATObjectName ELSE A12.ObjectName END) END) ObjectName,'
SET @sSQL3 = '
			A90.CurrencyID,
			(SELECT TOP 1 ExchangeRateDecimal FROM AT1004 WHERE DivisionID = A90.DivisionID AND CurrencyID = A90.CurrencyID) ExchangeRateDecimal
		FROM AT9000 A90
		LEFT JOIN AT1202 A12 ON A12.DivisionID = A90.DivisionID AND A12.ObjectID = (CASE WHEN A90.DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' THEN A90.ObjectID ELSE (CASE WHEN A90.TransactionTypeID = ''T99'' THEN A90.CreditObjectID ELSE ISNULL(A90.CreditObjectID, A90.ObjectID) END) END)
		LEFT JOIN AT1011 A01 ON A01.DivisionID = A90.DivisionID AND A01.AnaID = A90.Ana01ID
		LEFT JOIN AT1011 A02 ON A02.DivisionID = A90.DivisionID AND A02.AnaID = A90.Ana02ID
		LEFT JOIN AT1011 A03 ON A03.DivisionID = A90.DivisionID AND A03.AnaID = A90.Ana03ID
		WHERE A90.DivisionID = '''+@DivisionID+'''
		AND (A90.DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' OR ISNULL(A90.CreditAccountID, '''') LIKE '''+ISNULL(@AccountID,'')+'%'' )
		AND A90.CurrencyID LIKE '''+ISNULL(@CurrencyID,'%')+'''
		AND ISNULL(A90.Ana02ID,'''') LIKE '''+ISNULL(@Ana01ID,'%')+''' 
		AND (CASE WHEN A90.DebitAccountID LIKE '''+ISNULL(@AccountID,'')+'%'' THEN A90.ObjectID ELSE (CASE WHEN A90.TransactionTypeID = ''T99'' THEN A90.CreditObjectID ELSE ISNULL(A90.CreditObjectID, A90.ObjectID) END) END) LIKE '''+ISNULL(@ObjectID,'%')+'''		
		AND CONVERT(VARCHAR, VoucherDate, 112) BETWEEN '''+CONVERT(VARCHAR, @FromDate, 112)+''' AND '''+CONVERT(VARCHAR, @ToDate, 112)+'''
		AND A90.TransactionTypeID <> ''T00'' -- không tính những phiếu nhập dư nợ kỳ đầu tiên
		'+@sGroup+'
	) 

	SELECT * INTO AT0300Tam FROM Temp
END

WHILE @i <= (SELECT COUNT(*) FROM AT0300Tam)
	BEGIN
		SET @Increase = (SELECT TOP 1 (TotalDebitAmount - TotalCreditAmount) FROM AT0300Tam WHERE RowNum = @i - 1)
		SET @OriginalIncrease = (SELECT TOP 1 (OriginalTotalDebitAmount - OriginalTotalCreditAmount) FROM AT0300Tam WHERE RowNum = @i - 1)
		
		UPDATE AT0300Tam SET TotalDebitAmount = (Case when DebitAmount - CreditAmount + @Increase >= 0 THEN DebitAmount - CreditAmount + @Increase ELSE 0 END),
							 TotalCreditAmount = (Case when DebitAmount - CreditAmount + @Increase >= 0 THEN 0 ELSE -(DebitAmount - CreditAmount + @Increase) END),
							 OriginalTotalDebitAmount = (Case when OriginalDebitAmount - OriginalCreditAmount + @OriginalIncrease >= 0 THEN OriginalDebitAmount - OriginalCreditAmount + @OriginalIncrease ELSE 0 END),
							 OriginalTotalCreditAmount = (Case when OriginalDebitAmount - OriginalCreditAmount + @OriginalIncrease >= 0 THEN 0 ELSE -(OriginalDebitAmount - OriginalCreditAmount + @OriginalIncrease) END)
		WHERE RowNum = @i
		SET @i = @i + 1
	END
SELECT * FROM 
(
SELECT * FROM AT0300Tam

UNION ALL
SELECT (SELECT MAX(RowNum) FROM AT0300Tam) + 1 RowNum, NULL VoucherID, NULL TableID, NULL EmployeeID, NULL RefNo01, NULL RefNo02, NULL BatchID,
	NULL TransactionTypeID, NULL VoucherDate, NULL VoucherTypeID, NULL VoucherNo, NULL TranMonth, NULL TranYear,
	N'''+N'Tổng cộng 合计'+''' Description, 
	'''+@AccountID+''' AccountID, NULL RecAccountID,	
	SUM(ISNULL(OriginalDebitAmount,0)) OriginalDebitAmount, SUM(ISNULL(OriginalCreditAmount,0)) OriginalCreditAmount,	
	NULL OriginalTotalDebitAmount, NULL OriginalTotalCreditAmount,	
	SUM(ISNULL(DebitAmount,0)) DebitAmount, SUM(ISNULL(CreditAmount,0)) CreditAmount,	
	NULL TotalDebitAmount, NULL TotalCreditAmount,	
	NULL Ana02ID, NULL Ana02Name,
	NULL InvoiceNo, NULL InvoiceDate, NULL ObjectID, NULL ObjectName, NULL CurrencyID, 0 ExchangeRateDecimal
FROM AT0300Tam

UNION ALL
SELECT (RowNum + 2) RowNum, NULL VoucherID, NULL TableID, NULL EmployeeID, NULL RefNo01, NULL RefNo02, NULL BatchID,
	NULL TransactionTypeID, NULL VoucherDate, NULL VoucherTypeID, NULL VoucherNo, NULL TranMonth, NULL TranYear,
	N'''+N'Dư cuối kỳ 末期余额'+''' Description,
	'''+@AccountID+''' AccountID, NULL RecAccountID, NULL OriginalDebitAmount, NULL OriginalCreditAmount,	
	CASE WHEN OriginalTotalDebitAmount > OriginalTotalCreditAmount THEN OriginalTotalDebitAmount ELSE NULL END OriginalTotalDebitAmount,
	CASE WHEN OriginalTotalDebitAmount <= OriginalTotalCreditAmount THEN OriginalTotalCreditAmount ELSE NULL END OriginalTotalCreditAmount,	
	NULL DebitAmount, NULL CreditAmount,
	CASE WHEN TotalDebitAmount > TotalCreditAmount THEN TotalDebitAmount ELSE NULL END TotalDebitAmount,
	CASE WHEN TotalDebitAmount <= TotalCreditAmount THEN TotalCreditAmount ELSE NULL END TotalCreditAmount,	
	NULL Ana02ID, NULL Ana02Name,
	NULL InvoiceNo, NULL InvoiceDate, NULL ObjectID, NULL ObjectName, NULL CurrencyID, 0 ExchangeRateDecimal
FROM AT0300Tam
WHERE RowNum = (SELECT MAX(RowNum) FROM AT0300Tam)
) A '
EXEC (@sSQL + @sSQL2 + @sSQL3)
PRINT (@sSQL)
PRINT (@sSQL2)
PRINT (@sSQL3)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
