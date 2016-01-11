IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP0080]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP0080]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- Created on 24/09/2013 by Bảo Anh
--- Truy vấn bút toán mua hàng
--- Modified by Thanh Sơn on 28/07/2014: Cải tiến tốc độ truy vấn cho Thuận Lợi
--- EXEC AP0080 'TL','07/01/2013','07/01/2013','%','((''''))', '((0 = 0))', '((''''))', '((0 = 0))', '((''''))', '((0 = 0))'

CREATE PROCEDURE AP0080
	@DivisionID NVARCHAR(50),
	@FromDate DATETIME,
	@ToDate DATETIME,
	@ObjectID NVARCHAR(50),
	@ConditionVT NVARCHAR(MAX),
	@IsUsedConditionVT NVARCHAR(20),
	@ConditionOB NVARCHAR(MAX),
	@IsUsedConditionOB NVARCHAR(20),
	@ConditionWA NVARCHAR(MAX),
	@IsUsedConditionWA NVARCHAR(20)
AS
Declare @_Cur CURSOR,
		@VoucherID NVARCHAR(50),
		@SQL VARCHAR(MAX),
		@sWhere NVARCHAR(500),
		@CustomerName INT
		
SET @sWhere = 'T.WOrderID'		
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)	

IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#TAM')) 
DROP TABLE #TAM
	
--- Đưa dữ liệu AT9000 cần truy vấn sang bảng tạm
SELECT * INTO #TAM FROM 
	(SELECT * FROM AT9000
		WHERE DivisionID = @DivisionID
		AND (VoucherDate BETWEEN @FromDate AND @ToDate)
		AND ObjectID LIKE @ObjectID
		AND TransactionTypeID = 'T03'
	) A

IF @CustomerName <> 12 -- nếu là Thuận Lợi thì không chạy đoạn này
 --- Update OrderID cho từng VoucherID
BEGIN
	SET @sWhere = '(CASE WHEN AT2006.VoucherID = T.VoucherID THEN T.VoucherID ELSE T.WOrderID END)'
	SET @_Cur = CURSOR SCROLL KEYSET FOR
	SELECT VoucherID FROM #TAM 	
	OPEN @_Cur
	FETCH NEXT FROM @_Cur INTO @VoucherID

	WHILE @@FETCH_STATUS = 0		
		BEGIN		
			UPDATE #TAM SET OrderID = LTRIM(STUFF((SELECT DISTINCT ', ' + OrderID FROM #TAM WHERE VoucherID = @VoucherID FOR XML PATH('')),1,1,''))
			WHERE VoucherID = @VoucherID		
			FETCH NEXT FROM @_Cur INTO @VoucherID
		END
	CLOSE @_Cur
END	

--- Trả ra dữ liệu
SET @SQL = '
SELECT * FROM 
(SELECT  #TAM.DivisionID, #Tam.VoucherID, #Tam.TranMonth, #Tam.TranYear, #Tam.BatchID,#Tam. VoucherTypeID, #Tam.VoucherNo,
#Tam.VoucherDate, #Tam.Serial, #Tam.InvoiceNo, #Tam.InvoiceDate, #TAM.CurrencyID, #Tam.ExchangeRate, #Tam.VDescription, #Tam.VDescription [Description],
#TAM.ObjectID, ObjectName, #Tam.OrderID, #Tam.VATTypeID,-- A.WareHouseID,
(CASE WHEN ISNULL(IsStock,0) = 1 THEN 
	(SELECT TOP 1 WareHouseID 
	FROM AT2006 INNER JOIN #TAM T ON AT2006.DivisionID = T.DivisionID AND AT2006.DivisionID = ''' + @DivisionID + '''
		AND (AT2006.VoucherID = '+@sWhere+')
	 WHERE T.DivisionID = #TAM.DivisionID AND T.VoucherID = #TAM.VoucherID
	) 
ELSE '''' END) WareHouseID,
[Status],
---(Case when ISNULL(WOrderID, '''') = '''' Then IsStock Else 1 End) As IsStock,
IsStock,
SUM(ISNULL(#Tam.DiscountAmount, 0)) AS DiscountAmount,
SUM(ISNULL(#Tam.ImTaxOriginalAmount, 0)) AS ImTaxOriginalAmount,
SUM(ISNULL(#Tam.ImTaxConvertedAmount, 0)) AS ImTaxConvertedAmount,
SUM(ISNULL(#Tam.OriginalAmount, 0)) AS OriginalAmount,
SUM(ISNULL(#Tam.ConvertedAmount, 0)) AS ConvertedAmount, #TAM.CreateUserID 
FROM #TAM 
--LEFT JOIN (SELECT DivisionID, VoucherID, WareHouseID FROM AT2006) A ON A.DivisionID = #Tam.DivisionID AND A.VoucherID = (CASE WHEN A.VoucherID = #Tam.VoucherID THEN #TAM.VoucherID ELSE #Tam.WOrderID END)
LEFT JOIN AT1202 ON AT1202.DivisionID = #TAM.DivisionID AND AT1202.ObjectID = #TAM.ObjectID
GROUP BY #TAM.DivisionID, #TAM.VoucherID, #Tam.TranMonth, #Tam.TranYear, #Tam.BatchID, #Tam.VoucherNo,#Tam.VoucherTypeID,
#Tam.VoucherDate, #Tam.Serial, #Tam.InvoiceNo, #Tam.InvoiceDate, #TAM.CurrencyID, #Tam.ExchangeRate, #Tam.VDescription, #TAM.ObjectID,
ObjectName, #Tam.OrderID, VATTypeID, #Tam.Status, #Tam.IsStock, #TAM.CreateUserID)A 
WHERE (ISNULL(VoucherTypeID, ''#'') IN (' + @ConditionVT + ') Or ' + @IsUsedConditionVT + ')
AND (ISNULL(ObjectID, ''#'') IN (' + @ConditionOB + ') Or ' + @IsUsedConditionOB + ')
AND (ISNULL(WareHouseID, ''#'') IN (' + @ConditionWA + ') Or ' + @IsUsedConditionWA + ') ' + 'Order by VoucherDate, VoucherNo'

EXEC(@SQL)
PRINT (@SQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON


