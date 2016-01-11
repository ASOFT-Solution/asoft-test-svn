IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[FP0050]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[FP0050]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Báo cáo theo dõi XDCB dở dang
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 16/11/2015 by Phương Thảo
---- Modified on ... by ...
-- <Example>
---- EXEC FP0050 'GS', 0, '2015-12-31','2015-12-31', 11, 2015, 11, 2015 
CREATE PROCEDURE FP0050
( 		
   @DivisionID Varchar(50),
   @IsTime Tinyint, -- 0: Ngày, 1: Kỳ
   @FromDate Datetime,
   @ToDate Datetime,
   @FromMonth Tinyint,
   @FromYear Int,
   @ToMonth Tinyint,
   @ToYear Int
)
AS
DECLARE	@sSQL1 NVARCHAR(4000) = '',
		@sSQL2 NVARCHAR(4000) = '',
		@sWhere NVARCHAR(4000) = ''

IF (@IsTime = 0)
BEGIN
	SET @sWhere = 'AND (AT9000.VoucherDate Between '''+Convert(Varchar(20),@FromDate,101)+''' AND '''+Convert(Varchar(20),@ToDate,101)+''')'
END
ELSE
BEGIN
	SET @sWhere = 'AND (AT9000.TranMonth + AT9000.TranYear*100 Between '+STR(@FromMonth+@FromYear*100)+' AND '+STR(@ToMonth+@ToYear*100)+')'
END

SET @sSQL1 = N'
SELECT	AT9000.VoucherID, AT9000.TransactionID, AT9000.DivisionID,
		AT9000.ObjectID, AT1202.ObjectName, AT9000.VoucherDate, AT9000.VoucherNo,		
		AT9000.TranMonth, AT9000.TranYear,
		AT9000.Ana01ID AS TaskID, AT1011.AnaName AS TaskName,		
		OriginalAmount, ConvertedAmount,
		Convert(Decimal(28,8),0) AS AddCostAmount, 
		Convert(Datetime,null) as AddCostDate,
		Convert(Tinyint,0) AS IsCIP,
		Convert(Tinyint,0) AS IsFA, 
		Convert(Decimal(28,8),0) AS FAAmount,
		Convert(NVarchar(50),'''') AS ContractNo
INTO	#FP0050_AT9000
FROM	AT9000 
INNER JOIN AT1011 ON AT9000.Ana01ID = AT1011.AnaID and AT1011.AnaTypeID = ''A01''
INNER JOIN AT1202 ON AT9000.ObjectID = AT1202.ObjectID 
WHERE AT9000.DivisionID = '''+@DivisionID+'''   AND IsInheritFA = 1
 ' + @sWhere 


SET @sSQL2 = N'
UPDATE #FP0050_AT9000
SET		IsCIP = 1
WHERE	NOT EXISTS (SELECT TOP 1 1 FROM AT1533 WHERE AT1533.ReVoucherID = #FP0050_AT9000.VoucherID AND AT1533.RetransactionID = #FP0050_AT9000.TransactionID)

UPDATE #FP0050_AT9000
SET		IsFA = 1
WHERE	EXISTS (SELECT TOP 1 1 FROM AT1533 WHERE AT1533.ReVoucherID = #FP0050_AT9000.VoucherID AND AT1533.RetransactionID = #FP0050_AT9000.TransactionID)

UPDATE	T1
SET		FAAmount = T2.ConvertedAmount
FROM	#FP0050_AT9000 T1
INNER JOIN (SELECT DivisionID, ReVoucherID, RetransactionID, ConvertedAmount  FROM AT1533 ) T2 
			ON  T1.DivisionID = T2.DivisionID AND T1.VoucherID = T2.ReVoucherID AND T1.TransactionID = T2.RetransactionID

UPDATE	T1
SET		T1.AddCostAmount = T2.ConvertedAmount,
		T1.AddCostDate = T2.VoucherDate
FROM	#FP0050_AT9000 T1
INNER JOIN 
(	SELECT	DivisionID, TranMonth, TranYear, Ana01ID, ObjectID,
			MAX(VoucherDate) AS VoucherDate,
			SUM(CASE WHEN DebitAccountID LIKE ''241%'' THEN  OriginalAmount ELSE OriginalAmount * (-1) END) AS OriginalAmount, 
			SUM(CASE WHEN DebitAccountID LIKE ''241%'' THEN  ConvertedAmount ELSE ConvertedAmount * (-1) END) AS ConvertedAmount
	FROM	AT9000 
	WHERE	IsFACost = 1 AND (DebitAccountID LIKE ''241%'' OR CreditAccountID LIKE ''241%'')
	GROUP BY DivisionID, TranMonth, TranYear, Ana01ID, ObjectID
	) T2 ON T1.DivisionID = T2.DivisionID AND T1.TranMonth = T2.TranMonth 
		AND T1.TranYear = T2.TranYear AND T1.TaskID = T2.Ana01ID
		AND T1.ObjectID = T2.ObjectID
--WHERE IsCIP = 1


--UPDATE T1
--SET		T1.AddCostAmount = T3.ResidualNewValue  - ResidualOldValue,
--		T1.AddCostDate = T4.VoucherDate
--FROM	#FP0050_AT9000 T1
--INNER JOIN AT1533 T2 ON T1.DivisionID = T2.DivisionID AND T1.VoucherID = T2.ReVoucherID AND T1.TransactionID = T2.RetransactionID
--INNER JOIN AT1506 T3 ON T2.DivisionID = T3.DivisionID AND T1.TranMonth = T3.TranMonth AND T1.TranYear = T3.TranYear and T2.AssetID = T3.AssetID
--INNER JOIN (SELECT DivisionID, MAX(VoucherDate) AS VoucherDate, VoucherID FROM AT1590 GROUP BY DivisionID, VoucherID) T4 ON T3.DivisionID = T4.DivisionID AND T3.RevaluateID = T4.VoucherID
--WHERE IsFA = 1

select * from #FP0050_AT9000 
'



--PRINT (@sSQL1)
--PRINT (@sSQL2)
EXEC (@sSQL1+ @sSQL2)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

