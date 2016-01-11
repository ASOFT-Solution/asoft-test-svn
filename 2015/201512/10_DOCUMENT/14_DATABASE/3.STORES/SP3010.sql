IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[SP3010]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[SP3010]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- In bao cao don hang ban
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 22/11/2011 by Le Thi Thu Hien
---- 
---- Modified on 28/12/2011 by Le Thi Thu Hien : Bo AND OrderID = A.OrderID
-- <Example>
---- EXEC SP3010 'AS', '243355677', 'CD.0001', 1, 2, NULL, NULL, 1, 2011, 12, 2012 

CREATE PROCEDURE SP3010
( 
		@DivisionID AS NVARCHAR(50),
		@FromObjectID AS NVARCHAR(50),
		@ToObjectID AS NVARCHAR(50),
		@Mode AS INT,	-- 1 : Bao cao toa hang
						-- 2 : Bao cao khuyen mai
		@TypeD AS INT,
		@FromDate AS DATETIME,
		@ToDate AS DATETIME,
		@FromMonth AS INT,
		@FromYear AS INT,
		@ToMonth AS INT,
		@ToYear AS INT
) 
AS 

DECLARE @sSQL AS nvarchar(max);
DECLARE @sSQL1 AS nvarchar(max);
DECLARE @sSQLWHERE AS nvarchar(max);
DECLARE @sWHERE AS nvarchar(max);
DECLARE @SQL2 AS NVARCHAR(MAX);
DECLARE @SQLOrder AS NVARCHAR(MAX);

IF @TypeD = 1	
BEGIN
	SET @sSQLWHERE = N'
		AND CONVERT(nvarchar(10),A.VoucherDate,101)  BETWEEN ''' + CONVERT(nvarchar(10),@FromDate,101) + ''' AND ''' + CONVERT(nvarchar(10),@ToDate,101) + '''
	'
	SET @sWHERE = N'
		AND CONVERT(nvarchar(10),AT9000.VoucherDate,101)  BETWEEN ''' + CONVERT(nvarchar(10),@FromDate,101) + ''' AND ''' + CONVERT(nvarchar(10),@ToDate,101) + '''
	'
	SET @SQL2 = N'
			AND CONVERT(nvarchar(10),A.VoucherDate,101)   < ''' + CONVERT(nvarchar(10),@FromDate,101) + ''' 
	'	
END

IF @TypeD = 2
BEGIN
	SET @sSQLWHERE = N'
		AND A.TranYear*100 + A.TranMonth BETWEEN '+STR(@FromYear*100+@FromMonth)+' AND '+STR(@ToYear*100+@ToMonth)+'
	'
	SET @sWHERE = N'
		AND AT9000.TranYear*100 + AT9000.TranMonth BETWEEN '+STR(@FromYear*100+@FromMonth)+' AND '+STR(@ToYear*100+@ToMonth)+'
	'
	SET @SQL2 = N'
			AND A.TranYear*100 + A.TranMonth < '+STR(@FromYear*100+@FromMonth)+' 
	'
END

IF @TypeD = 3
BEGIN
	SET @sSQLWHERE = N'
		AND A.TranYear BETWEEN '+STR(@FromYear)+' AND '+STR(@ToYear)+'
	'
	SET @sWHERE = N'
		AND AT9000.TranYear BETWEEN '+STR(@FromYear)+' AND '+STR(@ToYear)+'
	'
	SET @SQL2 = N'
		AND A.TranYear < '+STR(@FromYear)+' 
	'
END

IF @Mode = 1 --Bao cao chi tiet don hang ban
BEGIN
	
	SET @sSQL = N'
SELECT	A.DivisionID,  
		A.VoucherNo, A.VoucherDate AS OrderDate, 
		A.ObjectID, A5.ObjectName, A5.Address, A5.Tel,
		A5.O01ID,	A5.O02ID,	A5.O03ID,	A5.O04ID,	A5.O05ID,
		O01.AnaName AS O01Name, 
		O02.AnaName AS O02Name, 
		O03.AnaName AS O03Name, 
		O04.AnaName AS O04Name, 
		O05.AnaName AS O05Name, 		
		A.InventoryID, A3.InventoryName,
		A.UnitID, A4.UnitName, A.Quantity AS OrderQuantity, 
		A.UnitPrice AS SalesPrice,
		CASE WHEN A2.Operator = 0 OR A.ExchangeRate = 0 THEN A.UnitPrice*A.ExchangeRate ELSE A.UnitPrice/A.ExchangeRate END AS SalePriceConverted,
		A.DiscountAmount AS DiscountOriginalAmount,
		CASE WHEN A2.Operator = 0 OR A.ExchangeRate = 0 THEN A.DiscountAmount*A.ExchangeRate ELSE A.DiscountAmount/A.ExchangeRate END AS DiscountConvertedAmount,
		A.OriginalAmount, A.ConvertedAmount,
		A.CurrencyID, A.CurrencyIDCN, A.ExchangeRate,
		ISNULL(A1.BeginOriginalAmount, 0) AS BeginOriginalAmount, 
		ISNULL(A1.BeginConvertedAmount, 0) AS BeginConvertedAmount,
		ReceivedAmount = ISNULL((	SELECT SUM(ConvertedAmount) 
									FROM AT9000 
		                         	WHERE ObjectID = A.ObjectID 
		                         	AND DivisionID = A.DivisionID 
		                         	AND CreditAccountID in (SELECT AccountID FROM AT1005 WHERE GroupID = ''G03'')
		                         	--AND OrderID = A.OrderID
		                         	'+@sWHERE+'
		                         	),0),
		A.OrderID,
		A6.SumOriginalAmount,	A6.SumConvertedAmount

'

SET @sSQL1 = N'
FROM	AT9000 A 
-------So du dau ky
LEFT JOIN (SELECT		SUM(ISNULL(B.ConvertedAmount,0)) AS BeginConvertedAmount, 
						SUM(ISNULL(B.OriginalAmount,0)) AS BeginOriginalAmount,
						B.ObjectID
           FROM			(SELECT ISNULL(A.ConvertedAmount,0) AS ConvertedAmount, 
								ISNULL(A.OriginalAmount,0) AS OriginalAmount,
								A.ObjectID
               			 FROM  AT9000 A
						 WHERE	A.TransactionTypeID IN( ''T21'', ''T01'',''T04'')
								AND DebitAccountID in (SELECT AccountID FROM AT1005 WHERE GroupID = ''G03'')
								AND A.DivisionID = N''' + ISNULL(@DivisionID,'') + N'''
								AND A.ObjectID BETWEEN N'''+@FromObjectID+''' AND N'''+@ToObjectID+'''
								'+@SQL2+'
						UNION ALL
						SELECT	ISNULL(A.ConvertedAmount,0)*(-1) AS ConvertedAmount, 
								ISNULL(A.OriginalAmount,0)*(-1) AS OriginalAmount,
								A.ObjectID
               			 FROM  AT9000 A
						 WHERE	A.TransactionTypeID IN( ''T21'', ''T01'',''T04'')
								AND CreditAccountID in (SELECT AccountID FROM AT1005 WHERE GroupID = ''G03'')
								AND A.DivisionID = N''' + ISNULL(@DivisionID,'') + N'''
								AND A.ObjectID BETWEEN N'''+@FromObjectID+''' AND N'''+@ToObjectID+'''
								'+@SQL2+'
						UNION ALL
						SELECT ISNULL(A.ConvertedAmount,0) AS ConvertedAmount, 
								ISNULL(A.OriginalAmount,0) AS OriginalAmount,
								A.ObjectID
               			 FROM  AT9000 A
						 WHERE	A.TransactionTypeID IN( ''T00'')
								AND DebitAccountID in (SELECT AccountID FROM AT1005 WHERE GroupID = ''G03'')
								AND A.DivisionID = N''' + ISNULL(@DivisionID,'') + N'''
								AND A.ObjectID BETWEEN N'''+@FromObjectID+''' AND N'''+@ToObjectID+'''

						UNION ALL
						SELECT	ISNULL(A.ConvertedAmount,0)*(-1) AS ConvertedAmount, 
								ISNULL(A.OriginalAmount,0)*(-1) AS OriginalAmount,
								A.ObjectID
               			 FROM  AT9000 A
						 WHERE	A.TransactionTypeID IN( ''T00'')
								AND CreditAccountID in (SELECT AccountID FROM AT1005 WHERE GroupID = ''G03'')
								AND A.DivisionID = N''' + ISNULL(@DivisionID,'') + N'''
								AND A.ObjectID BETWEEN N'''+@FromObjectID+''' AND N'''+@ToObjectID+'''
						)B
           GROUP BY		B.ObjectID
           )A1
    ON A1.ObjectID = A.ObjectID
    
--------SUM tien phat sinh
LEFT JOIN (SELECT	SUM(ISNULL(AT9000.ConvertedAmount,0)) AS SumConvertedAmount, 
					SUM(ISNULL(AT9000.OriginalAmount,0)) AS SumOriginalAmount,
					AT9000.ObjectID
           FROM		AT9000
           WHERE	AT9000.TransactionTypeID = ''T04''
					AND AT9000.DivisionID = N''' + ISNULL(@DivisionID,'') + N'''
					AND AT9000.ObjectID BETWEEN N'''+@FromObjectID+''' AND N'''+@ToObjectID+'''	
           GROUP BY AT9000.ObjectID
			)A6
	ON		A6.ObjectID = A.ObjectID
	
LEFT JOIN AT1004 A2 ON A2.CurrencyID = A.CurrencyID AND A2.DivisionID = A.DivisionID
LEFT JOIN AT1302 A3 ON A3.InventoryID = A.InventoryID AND A3.DivisionID = A.DivisionID
LEFT JOIN AT1304 A4 ON A4.UnitID = A.UnitID AND A4.DivisionID = A.DivisionID
LEFT JOIN AT1202 A5 ON A5.ObjectID = A.ObjectID AND A5.DivisionID = A.DivisionID
LEFT JOIN AT1015 O01 ON O01.AnaID = A5.O01ID AND O01.AnaTypeID = ''O01'' AND O01.DivisionID = A.DivisionID
LEFT JOIN AT1015 O02 ON O02.AnaID = A5.O02ID AND O01.AnaTypeID = ''O02'' AND O02.DivisionID = A.DivisionID
LEFT JOIN AT1015 O03 ON O03.AnaID = A5.O03ID AND O01.AnaTypeID = ''O03'' AND O03.DivisionID = A.DivisionID
LEFT JOIN AT1015 O04 ON O04.AnaID = A5.O04ID AND O01.AnaTypeID = ''O04'' AND O04.DivisionID = A.DivisionID
LEFT JOIN AT1015 O05 ON O05.AnaID = A5.O05ID AND O01.AnaTypeID = ''O05'' AND O05.DivisionID = A.DivisionID

WHERE	A.TransactionTypeID = ''T04''
		AND A.DivisionID = N''' + ISNULL(@DivisionID,'') + N'''
		AND A.ObjectID BETWEEN N'''+@FromObjectID+''' AND N'''+@ToObjectID+'''
		'
SET @SQLOrder = '
		ORDER BY A.ObjectID, A.VoucherDate, A.InventoryID'

END


IF @Mode = 2 --Bao cao khuyen mai cua don hang ban
BEGIN
	
	SET @sSQL = N'
SELECT  A.DivisionID,
		A.OrderID, 		
		A.VoucherTypeID, 		A.VoucherNo, 			A.VoucherDate AS OrderDate, 	
		A.ObjectID,				A5.ObjectName ,			A5.Address,					A5.Tel,
		MAX(A5.O01ID) AS O01ID,	
		MAX(A5.O02ID) AS O02ID,	
		MAX(A5.O03ID) AS O03ID,	
		MAX(A5.O04ID) AS O04ID,	
		MAX(A5.O05ID) AS O05ID,
		MAX(O01.AnaName) AS O01Name, 
		MAX(O02.AnaName) AS O02Name, 
		MAX(O03.AnaName) AS O03Name, 
		MAX(O04.AnaName) AS O04Name, 
		MAX(O05.AnaName) AS O05Name, 
		SUM(ISNULL(A.ConvertedAmount,0)) AS ConvertedAmount, 
		SUM(ISNULL(A.OriginalAmount,0)) AS OriginalAmount, 
		SUM(ISNULL(A.DiscountAmount,0)) AS DiscountOriginalAmount,
		CASE WHEN A2.Operator = 0 OR A.ExchangeRate = 0 THEN SUM(ISNULL(A.DiscountAmount,0))*A.ExchangeRate ELSE SUM(ISNULL(A.DiscountAmount,0))/A.ExchangeRate END AS DiscountConvertedAmount,
		
		MAX(A.TDescription) AS Description,
		MAX(A.BDescription) AS BDescription
'

SET @sSQL1 = N'
FROM	AT9000 A 

LEFT JOIN AT1004 A2 ON A2.CurrencyID = A.CurrencyID AND A2.DivisionID = A.DivisionID
LEFT JOIN AT1202 A5 ON A5.ObjectID = A.ObjectID AND A5.DivisionID = A.DivisionID
LEFT JOIN AT1015 O01 ON O01.AnaID = A5.O01ID AND O01.AnaTypeID = ''O01'' AND O01.DivisionID = A.DivisionID
LEFT JOIN AT1015 O02 ON O02.AnaID = A5.O02ID AND O02.AnaTypeID = ''O02'' AND O02.DivisionID = A.DivisionID
LEFT JOIN AT1015 O03 ON O03.AnaID = A5.O03ID AND O03.AnaTypeID = ''O03'' AND O03.DivisionID = A.DivisionID
LEFT JOIN AT1015 O04 ON O04.AnaID = A5.O04ID AND O04.AnaTypeID = ''O04'' AND O04.DivisionID = A.DivisionID
LEFT JOIN AT1015 O05 ON O05.AnaID = A5.O05ID AND O05.AnaTypeID = ''O05'' AND O05.DivisionID = A.DivisionID

WHERE	A.TransactionTypeID = ''T04''
		AND A.DivisionID = N''' + ISNULL(@DivisionID,'') + N'''
		AND A.ObjectID BETWEEN N'''+@FromObjectID+''' AND N'''+@ToObjectID+'''
		'
SET @SQLOrder = '
GROUP BY	A.DivisionID,
			A.OrderID, 		
			A.VoucherTypeID, 		A.VoucherNo, 			A.VoucherDate, 	
			A.ObjectID,				A5.ObjectName,
			A5.Address,					A5.Tel,
			A2.Operator,			A.CurrencyID,			A.ExchangeRate
			
ORDER BY A.ObjectID, A.VoucherDate, A.OrderID'

END

PRINT(@sSQL)
PRINT(@sSQL1)
PRINT(@sSQLWHERE)
PRINT(@SQLOrder)

EXEC (@sSQL + @sSQL1 +@sSQLWHERE +@SQLOrder)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

