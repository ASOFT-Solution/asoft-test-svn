IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0114VG]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0114VG]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- In báo cáo chi tiết nhập xuất tồn theo lô cho VIỆN GÚT
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 19/01/2015
---- Modified on 
-- <Example>
/*
	 AP0114VG 'VG', '', 8, 2014, 8, 2014, '2015-01-16 15:10:16.127', '2015-01-16 15:10:16.127', 0, '01','08', 'K01','K01', 0
*/

 CREATE PROCEDURE AP0114VG
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT,
	@FromInventoryID VARCHAR(50),
	@ToInventoryID VARCHAR(50),
	@FromWareHouseID VARCHAR(50),
	@ToWareHouseID VARCHAR(50),
	@IsInner TINYINT
)
AS
DECLARE @RemainSQL NVARCHAR(MAX) = '',
		@sSQL NVARCHAR(MAX),
		@ImKindVoucherList NVARCHAR(50),
		@ExKindVoucherList NVARCHAR(50),
		@TimesWhere NVARCHAR(1000) = ''
		
IF @IsInner = 0 
	BEGIN
		SET @ImKindVoucherList = '1,5,7,9,11,13,15,17,19'
		SET @ExKindVoucherList = '0,2,4,6,8,10,12,14,16,18,20'
	END
ELSE 
	BEGIN
		SET @ImKindVoucherList = '1,3,5,7,9,11,13,15,17,19'
		SET @ExKindVoucherList = '0,2,3,4,6,8,10,12,14,16,18,20'
	END

IF @IsDate = 0 SET @TimesWhere = 'AND A07.TranMonth + A07.TranYear * 100 BETWEEN '+STR(@FromMonth + @FromYear * 100)+' AND '+STR(@ToMonth + @ToYear * 100)+''
ELSE SET @TimesWhere = 'AND CONVERT(VARCHAR, A06.VoucherDate, 112) BETWEEN '''+CONVERT(VARCHAR, @FromDate, 112)+''' AND '''+CONVERT(VARCHAR, @ToDate, 112)+''' '


IF (@FromMonth + @FromYear * 100 = (SELECT BeginMonth + BeginYear * 100 FROM AT1101 WHERE DivisionID = @DivisionID) AND @IsDate = 0)
SET @RemainSQL = '
BEGIN
WITH Temp AS
(
	SELECT A17.DivisionID, A17.VoucherID, A17.TransactionID ReTransactionID, A16.WareHouseID, A16.VoucherNo, A17.InventoryID,
		A17.SourceNo, A17.LimitDate, A17.UnitID, A17.UnitPrice, A17.ActualQuantity, A17.ConvertedQuantity, A17.OriginalAmount,
		A17.ConvertedAmount, A16.VoucherDate
	FROM AT2017 A17
		LEFT JOIN AT1302 A02 ON A02.DivisionID = A17.DivisionID AND A02.InventoryID = A17.InventoryID		
		INNER JOIN AT2016 A16 ON A16.VoucherID = A17.VoucherID AND A16.DivisionID = A17.DivisionID  
	WHERE A16.DivisionID = ''' + @DivisionID + '''
		AND (A17.InventoryID LIKE '''+@FromInventoryID+''' OR A17.InventoryID BETWEEN '''+@FromInventoryID+''' AND '''+@ToInventoryID+''')
		AND (A16.WareHouseID LIKE '''+@FromWareHouseID+''' OR A16.WareHouseID BETWEEN '''+@FromWareHouseID+''' AND '''+@ToWareHouseID+''')
		AND A02.IsSource = 1
)'
ELSE SET @RemainSQL = '
BEGIN
WITH Temp AS
(
	SELECT * FROM
	( 
		SELECT A14.DivisionID, A14.ReVoucherID VoucherID, A14.InventoryID, A14.ReVoucherDate VoucherDate, A14.ReVoucherNo VoucherNo,
		   A14.WareHouseID, A14.ReTransactionID, A14.ReVoucherNo, A14.ReVoucherDate, A14.ReTranMonth,
		   A14.ReTranYear, A14.ReSourceNo SourceNo, A14.LimitDate, A14.ReQuantity,
		   A14.ReQuantity - SUM(ISNULL(A07.ActualQuantity, 0)) ActualQuantity,
		   V77.ConvertedAmount - SUM(ISNULL(A07.ConvertedAmount, 0)) ConvertedAmount, A14.UnitPrice
		FROM AT0114 A14
		INNER JOIN AV2777 V77 ON V77.TransactionID = A14.ReTransactionID AND V77.DivisionID = A14.DivisionID
		LEFT JOIN 
		(
			SELECT A06.KindVoucherID, A06.DivisionID, A07.ReTransactionID, ISNULL(A07.ActualQuantity, 0) ActualQuantity,
				ISNULL(A07.ConvertedAmount, 0) ConvertedAmount
			FROM AT2006 A06 
				LEFT JOIN AT2007 A07 ON A07.DivisionID = A06.DivisionID AND A07.VoucherID = A06.VoucherID
			WHERE A07.TranMonth + A07.TranYear * 100 < '+STR(@FromMonth + @FromYear * 100)+'
			AND A06.KindVoucherID IN (0,2,3,4,6,8,10,12,14,16,8,20)	
		) A07 ON A07.DivisionID = A14.DivisionID AND A07.ReTransactionID = A14.ReTransactionID
		WHERE A14.DivisionID = '''+@DivisionID+'''
		AND ((A14.ReTranMonth + A14.ReTranYear * 100 < '+STR(@FromMonth + @FromYear * 100)+' AND '+STR(@IsDate)+' = 0) 
			OR (CONVERT(VARCHAR, A14.ReVoucherDate, 112) < '''+CONVERT(VARCHAR, @FromDate, 112)+''' AND '+STR(@IsDate)+' = 1))
		AND (A14.InventoryID LIKE '''+@FromInventoryID+''' OR A14.InventoryID BETWEEN '''+@FromInventoryID+''' AND '''+@ToInventoryID+''')
		AND (A14.WareHouseID LIKE '''+@FromWareHouseID+''' OR A14.WareHouseID BETWEEN '''+@FromWareHouseID+''' AND '''+@ToWareHouseID+''')
		GROUP BY A14.DivisionID, A14.InventoryID, A14.WareHouseID, A14.ReVoucherID,
			   A14.ReTransactionID, A14.ReVoucherNo, A14.ReVoucherDate, A14.ReTranMonth,
			   A14.ReTranYear, A14.ReSourceNo, A14.LimitDate, A14.ReQuantity, A07.ReTransactionID, A14.UnitPrice,
			   V77.ActualQuantity, V77.ConvertedAmount
	)B		
)'

PRINT (@RemainSQL)
SET @sSQL = '
SELECT A.*, A02.InventoryName, A02.I01ID, A05.AnaName I01Name
FROM
(
	SELECT DivisionID, VoucherID, VoucherNo, InventoryID, NULL KindVoucherID, VoucherDate, SourceNo,
		NULL ImQuantity, NULL ExQuantity, UnitPrice, LimitDate,
		NULL ImConvertedAmount, NULL ExConvertedAmount, ActualQuantity BeginQuantity, ConvertedAmount BeginConvertedAmount,
		WareHouseID
	FROM Temp
	
	UNION ALL -- phiếu nhập phát sinh
	SELECT A06.DivisionID, A06.VoucherID, A06.VoucherNo, A07.InventoryID, A06.KindVoucherID, A06.VoucherDate, A07.SourceNo,
		CASE WHEN A06.KindVoucherID IN (1,3,5,7,9,11,13,15,17,19) THEN A07.ActualQuantity ELSE NULL END ImQuantity,
		NULL ExQuantity, A07.UnitPrice, A07.LimitDate,
		CASE WHEN A06.KindVoucherID IN (1,3,5,7,9,11,13,15,17,19) THEN A07.ConvertedAmount ELSE NULL END ImConvertedAmount,
		NULL ExConvertedAmount, NULL BeginQuantity, NULL BeginConvertedAmount, A06.WareHouseID
	FROM AT2007 A07		
		LEFT JOIN AT1302 A02 ON A02.DivisionID = A07.DivisionID AND A02.InventoryID = A07.InventoryID
		LEFT JOIN AT2006 A06 ON A06.DivisionID = A07.DivisionID AND A06.VoucherID = A07.VoucherID
	WHERE A06.DivisionID = '''+@DivisionID+'''
		'+@TimesWhere+'
		AND A02.IsSource = 1
		AND (A07.InventoryID LIKE '''+@FromInventoryID+''' OR A07.InventoryID BETWEEN '''+@FromInventoryID+''' AND '''+@ToInventoryID+''')
		AND (A06.WareHouseID LIKE '''+@FromWareHouseID+''' OR A06.WareHouseID BETWEEN '''+@FromWareHouseID+''' AND '''+@ToWareHouseID+''')
		AND A06.KindVoucherID IN ('+@ImKindVoucherList+')
		
	UNION ALL -- phiếu xuất phát sinh	
	SELECT A06.DivisionID, A06.VoucherID, A06.VoucherNo, A07.InventoryID, A06.KindVoucherID, A06.VoucherDate, A07.SourceNo,
		NULL ImQuantity, 
		CASE WHEN A06.KindVoucherID IN (0,2,3,4,6,8,10,12,14,16,18,20) THEN A07.ActualQuantity ELSE NULL END ExQuantity,		
		A07.UnitPrice, A07.LimitDate, NULL ImConvertedAmount,
		CASE WHEN A06.KindVoucherID IN (0,2,3,4,6,8,10,12,14,16,18,20) THEN A07.ConvertedAmount ELSE NULL END ExConvertedAmount,
		NULL BeginQuantity, NULL BeginConvertedAmount, 
		CASE WHEN A06.KindVoucherID = 3 THEN A06.WareHouseID2 ELSE A06.WareHouseID END WareHouseID 
	FROM AT2007 A07		
		LEFT JOIN AT1302 A02 ON A02.DivisionID = A07.DivisionID AND A02.InventoryID = A07.InventoryID
		LEFT JOIN AT2006 A06 ON A06.DivisionID = A07.DivisionID AND A06.VoucherID = A07.VoucherID
	WHERE A06.DivisionID = '''+@DivisionID+'''
		'+@TimesWhere+'
		AND A02.IsSource = 1
		AND (A07.InventoryID LIKE '''+@FromInventoryID+''' OR A07.InventoryID BETWEEN '''+@FromInventoryID+''' AND '''+@ToInventoryID+''')
		AND (CASE WHEN A06.KindVoucherID = 3 THEN A06.WareHouseID2 ELSE A06.WareHouseID END LIKE '''+@FromWareHouseID+''' 
			OR CASE WHEN A06.KindVoucherID = 3 THEN A06.WareHouseID2 ELSE A06.WareHouseID END BETWEEN '''+@FromWareHouseID+''' AND '''+@ToWareHouseID+''')
		AND A06.KindVoucherID IN ('+@ExKindVoucherList+')
)A
	LEFT JOIN AT1302 A02 ON A02.DivisionID = A.DivisionID AND A02.InventoryID = A.InventoryID
	LEFT JOIN AT1015 A05 ON A05.DivisionID = A02.DivisionID AND A05.AnaID = A02.I01ID
ORDER BY VoucherDate
END'

EXEC (@RemainSQL + @sSQL)
--PRINT (@RemainSQL + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
