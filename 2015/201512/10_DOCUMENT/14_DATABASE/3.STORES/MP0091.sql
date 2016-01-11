IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0091]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0091]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- IN BÁO CÁO ĐẶC THÙ CHI PHÍ NGUYÊN VẬT LIỆU TRỰC TIẾP - MF0091 - MR0001 [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 21/01/2015 by Lê Thị Hạnh 
-- <Example>
/*
 MP0091 @DivisionID = 'VG', @FromPeriod = 201407, @ToPeriod = 201410, @FromDate = '2013-01-01',
 @ToDate = '2014-10-30', @TimeMode = 1, @PeriodID = '%', @FromInventoryID = '1551S00001', @ToInventoryID = '1551S00001'
 */
 
CREATE PROCEDURE [dbo].[MP0091] 
	@DivisionID NVARCHAR(50),
	@FromPeriod INT,
	@ToPeriod INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@TimeMode TINYINT, -- 1: Theo ngày, 0: theo kỳ
	@PeriodID NVARCHAR(50), -- Đối tượng THCP
	@FromInventoryID NVARCHAR(50),
	@ToInventoryID NVARCHAR(50)
	--@Is621 TINYINT,
	--@Is622 TINYINT,
	--@Is627 TINYINT		
AS
DECLARE @sSQL1 NVARCHAR(MAX) = '',
		@sSQL2 NVARCHAR(MAX) = '',
		@sSQL3 NVARCHAR(MAX) = '',
		@sSQL4 NVARCHAR(MAX) = '',
		@sSQL5 NVARCHAR(MAX) = '',
		@sWhere NVARCHAR(MAX) = ''
IF LTRIM(STR(@TimeMode)) = 1	
SET @sSQL5 = 
     'AND CONVERT(VARCHAR(10),V00.VoucherDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
SET @sWhere = 
     'AND CONVERT(VARCHAR(10),V02.VoucherDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''''
IF LTRIM(STR(@TimeMode)) = 0	
SET @sSQL5 = 
     'AND (V00.TranYear*100 + V00.TranMonth) BETWEEN '+LTRIM(@FromPeriod)+' AND '+LTRIM(@ToPeriod)+' '
SET @sWHERE = 
     'AND (V02.TranYear*100 + V02.TranMonth) BETWEEN '+LTRIM(@FromPeriod)+' AND '+LTRIM(@ToPeriod)+' '	 
	   
------ Thông tin kết quả sản xuất thành phẩm - MT0810 + MT1001 (MP0810)
------ Thông tin xuất kho nguyên vật liệu trực tiếp - AT9000 (MP0001) - MV9000
SET @sSQL4 = '
WITH V00 AS (
SELECT V00.DivisionID,V00.PeriodID, 
       V01.ProductID, V01.UnitID, V01.ConvertedUnitID, V01.DebitAccountID, V01.CreditAccountID, 
       SUM(ISNULL(V01.Quantity,0)) AS Quantity, 
       SUM(CASE WHEN ISNULL(V01.ConvertedQuantity,0) <> 0 THEN ISNULL(V01.ConvertedQuantity,0)
                ELSE ISNULL(V01.Quantity,0) END) AS ConvertedQuantity,
       SUM(CASE WHEN ISNULL(V01.OriginalAmount,0) <> 0 THEN ISNULL(V01.OriginalAmount,0)
                ELSE ISNULL(V01.ConvertedAmount,0) END) AS OriginalAmount, 
       SUM(ISNULL(V01.ConvertedAmount,0)) AS ConvertedAmount
FROM MT0810 V00
INNER JOIN MT1001 V01 ON V01.DivisionID = V00.DivisionID AND V01.VoucherID = V00.VoucherID
WHERE V00.DivisionID = '''+@DivisionID+''' '+@sSQL5+'
GROUP BY V00.DivisionID,V00.PeriodID, 
       V01.ProductID, V01.UnitID, V01.ConvertedUnitID, V01.DebitAccountID, V01.CreditAccountID) '
SET @sSQL1 = 
'SELECT V00.DivisionID, V00.PeriodID, V00.ProductID, V00.UnitID,
       V00.ConvertedUnitID, V00.DebitAccountID, V00.CreditAccountID,
       (ISNULL(V00.Quantity,0)) AS Quantity, 
       (CASE WHEN ISNULL(V00.ConvertedQuantity,0) <> 0 THEN ISNULL(V00.ConvertedQuantity,0)
                ELSE ISNULL(V00.Quantity,0) END) AS ConvertedQuantity,
       (ISNULL(V00.OriginalAmount,0)) AS OriginalAmount, 
       (ISNULL(V00.ConvertedAmount,0)) AS ConvertedAmount,
	   V02.TransactionTypeID AS ExTransactionTypeID, 
       V02.InventoryID AS ExInventoryID,  V02.UnitID AS ExUnitID,
       V02.DebitAccountID AS ExDebitAccountID, V02.CreditAccountID AS ExCreditAccountID, 
       SUM(ISNULL(V02.Quantity,0)) AS ExQuantity, 
       SUM(CASE WHEN ISNULL(V02.ConvertedQuantity,0) <> 0 THEN ISNULL(V02.ConvertedQuantity,0)
            ELSE ISNULL(V02.Quantity,0) END) AS ExConvertedQuantity,
       --ISNULL(V02.UnitPrice,0) AS ExUnitPrice, 
	   SUM(CASE WHEN V02.D_C = ''D'' THEN ISNULL(V02.OriginalAmount,0) ELSE (-1)*ISNULL(V02.OriginalAmount,0) END) AS ExOriginalAmount,
	   SUM(CASE WHEN ISNULL(E01.AccountID,'''') = '''' THEN V02.OriginalAmount ELSE 0 END) AS ExCreditOriginalAmount,
	   SUM(CASE WHEN ISNULL(E01.AccountID,'''') = '''' THEN V02.OriginalAmount ELSE 0 END) AS ExDebitOriginalAmount,
	   SUM(CASE WHEN V02.D_C = ''D'' THEN ISNULL(V02.ConvertedAmount,0) ELSE (-1)*ISNULL(V02.ConvertedAmount,0) END) AS ExConvertedAmount,
	   SUM(CASE WHEN ISNULL(E01.AccountID,'''') = '''' THEN V02.ConvertedAmount ELSE 0 END) AS ExCreditAmount,
	   SUM(CASE WHEN ISNULL(E01.AccountID,'''') = '''' THEN V02.ConvertedAmount ELSE 0 END) AS ExDebitAmount,
	   T03.[Description] AS PeriodName, T04.InventoryName AS ProductName,
	   E00.InventoryName AS ExInventoryName, E02.UnitName AS ExUnitName,
	   V02.MaterialTypeID AS ExMaterialTypeID, ISNULL(E03.UserName,E03.SystemName) AS ExMaterialTypeName, 
	   V02.Ana01ID, A01.AnaName AS Ana01Name, V02.Ana02ID, A02.AnaName AS Ana02Name,
	   V02.Ana03ID, A03.AnaName AS Ana03Name, V02.Ana04ID, A04.AnaName AS Ana04Name,
	   V02.Ana05ID, A05.AnaName AS Ana05Name, V02.Ana06ID, A06.AnaName AS Ana06Name,
	   V02.Ana07ID, A07.AnaName AS Ana07Name, V02.Ana08ID, A08.AnaName AS Ana08Name,
	   V02.Ana09ID, A09.AnaName AS Ana09Name, V02.Ana10ID, A10.AnaName AS Ana10Name '
SET @sSQL2 = 
'FROM V00
LEFT JOIN MV9000 V02 ON V02.DivisionID = V00.DivisionID AND V02.PeriodID = V00.PeriodID AND V02.ProductID = V00.ProductID
LEFT JOIN MT1601 T03 ON T03.DivisionID = V00.DivisionID AND T03.PeriodID = V00.PeriodID
LEFT JOIN AT1302 T04 ON T04.DivisionID = V00.DivisionID AND T04.InventoryID = V00.ProductID
LEFT JOIN AT1302 E00 ON E00.DivisionID = V02.DivisionID AND E00.InventoryID = V02.InventoryID
LEFT JOIN MT0700 E01 ON E01.DivisionID = V02.DivisionID AND E01.AccountID = V02.DebitAccountID
LEFT JOIN AT1304 E02 ON E02.DivisionID = V02.DivisionID AND E02.UnitID = V02.UnitID
LEFT JOIN MT0699 E03 ON E03.DivisionID = V02.DivisionID AND E03.MaterialTypeID = V02.MaterialTypeID
LEFT JOIN AT1011 A01 ON A01.DivisionID = V02.DivisionID AND A01.AnaID = V02.Ana01ID AND A01.AnaTypeID =''A01''
LEFT JOIN AT1011 A02 ON A02.DivisionID = V02.DivisionID AND A02.AnaID = V02.Ana02ID AND A02.AnaTypeID =''A02''
LEFT JOIN AT1011 A03 ON A03.DivisionID = V02.DivisionID AND A03.AnaID = V02.Ana03ID AND A03.AnaTypeID =''A03''
LEFT JOIN AT1011 A04 ON A04.DivisionID = V02.DivisionID AND A04.AnaID = V02.Ana04ID AND A04.AnaTypeID =''A04''
LEFT JOIN AT1011 A05 ON A05.DivisionID = V02.DivisionID AND A05.AnaID = V02.Ana05ID AND A05.AnaTypeID =''A05''
LEFT JOIN AT1011 A06 ON A06.DivisionID = V02.DivisionID AND A06.AnaID = V02.Ana06ID AND A06.AnaTypeID =''A06''
LEFT JOIN AT1011 A07 ON A07.DivisionID = V02.DivisionID AND A07.AnaID = V02.Ana07ID AND A07.AnaTypeID =''A07''
LEFT JOIN AT1011 A08 ON A08.DivisionID = V02.DivisionID AND A08.AnaID = V02.Ana08ID AND A08.AnaTypeID =''A08''
LEFT JOIN AT1011 A09 ON A09.DivisionID = V02.DivisionID AND A09.AnaID = V02.Ana09ID AND A09.AnaTypeID =''A09''
LEFT JOIN AT1011 A10 ON A10.DivisionID = V02.DivisionID AND A10.AnaID = V02.Ana10ID AND A10.AnaTypeID =''A10''
WHERE V00.DivisionID = '''+@DivisionID+''' AND V00.PeriodID LIKE '''+@PeriodID+''' 
	  AND V00.ProductID BETWEEN '''+@FromInventoryID+''' AND '''+@ToInventoryID+'''
	  AND V02.ExpenseID = ''COST001''
	  '+@sWHERE+' '
SET @sSQL3 = 
'GROUP BY V02.TransactionTypeID, V02.InventoryID, V02.UnitID, V02.DebitAccountID, V02.CreditAccountID,
          V00.DivisionID, V00.PeriodID, V00.ProductID, V00.UnitID,
          V00.ConvertedUnitID, V00.DebitAccountID, V00.CreditAccountID, V00.Quantity,
          V00.ConvertedQuantity, V00.OriginalAmount, V00.ConvertedAmount,
          T03.[Description], T04.InventoryName, E00.InventoryName, E02.UnitName,
          V02.MaterialTypeID, E03.UserName,E03.SystemName, 
		  V02.Ana01ID, A01.AnaName, V02.Ana02ID, A02.AnaName,
		  V02.Ana03ID, A03.AnaName, V02.Ana04ID, A04.AnaName,
		  V02.Ana05ID, A05.AnaName, V02.Ana06ID, A06.AnaName,
		  V02.Ana07ID, A07.AnaName, V02.Ana08ID, A08.AnaName,
		  V02.Ana09ID, A09.AnaName, V02.Ana10ID, A10.AnaName
HAVING SUM(ISNULL(V02.ConvertedAmount,0)) + SUM(ISNULL(V02.Quantity,0)) <> 0 '

EXEC(@sSQL4+@sSQL1+@sSQL2+@sSQL3)
	
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON