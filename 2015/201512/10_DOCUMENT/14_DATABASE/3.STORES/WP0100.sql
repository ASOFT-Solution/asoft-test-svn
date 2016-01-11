IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0100]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0100]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Load danh sách các phiếu yêu cầu lên màn hình kế thừa
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Thanh Sơn on 29/05/2014
---- 
---- Modified on 01/07/2014 by Le Thi Thu Hien : Sửa lại A04.WareHouseID = W95.WareHouseID2
---- Modified by Tieu Mai on 29/12/2015: Load phieu yeu cau chua xuat/nhap het so luong yeu cau
-- <Example>
/*
    EXEC WP0100 'EIS','',1,2014,5,2014, '2014-05-29 11:32:10.833', '2014-05-29 11:32:10.833','%',0, 1
*/

 CREATE PROCEDURE WP0100
(
     @DivisionID VARCHAR(50),
     @UserID VARCHAR(50),
     @FromMonth INT,
     @FromYear INT,
     @ToMonth INT,
     @ToYear INT,
     @FromDate DATETIME,
     @ToDate DATETIME,
     @ObjectID VARCHAR(50),
     @IsDate TINYINT,
     @Mode TINYINT --1: Phiếu yêu cầu nhập, 2: Xuất, 3: VCNB
)
AS
DECLARE @sSQL NVARCHAR(MAX), 
			@sWhere NVARCHAR(2000)
			
SET @sWhere = ''
IF @IsDate = 0 SET @sWhere = 'AND W95.TranMonth + W95.TranYear * 100 BETWEEN '+STR(@FromMonth + @FromYear * 100)+' AND '+STR(@ToMonth + @ToYear * 100)+' '
IF @IsDate = 1 SET @sWhere = 'AND CONVERT(VARCHAR, W95.VoucherDate,112) BETWEEN '+CONVERT(VARCHAR,@FromDate,112)+' AND '+CONVERT(VARCHAR,@ToDate,112)+' '
IF @Mode = 1 SET @sWhere = @sWhere + '
AND W95.KindVoucherID IN (1,3,5,7,9) AND W95.WareHouseID2 IS NULL'
IF @Mode = 2 SET @sWhere = @sWhere + '
AND W95.KindVoucherID IN (2,4,6,8,10)'
IF @Mode = 3 SET @sWhere = @sWhere + '
AND W95.KindVoucherID = 3 AND W95.WareHouseID2 IS NOT NULL'

IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	SET @sSQL = '
	SELECT DISTINCT CONVERT(TINYINT,0) Choose, W95.VoucherID, W95.VoucherNo, W95.VoucherTypeID, W95.VoucherDate, A02.ObjectName, W95.[Description],
	CASE WHEN W95.KindVoucherID IN (1,3,5,7,9) THEN A03.WareHouseName ELSE '''' END ImWareHouseName,
	CASE WHEN W95.KindVoucherID IN (2,4,6,8,10) THEN A03.WareHouseName ELSE  
		CASE WHEN W95.KindVoucherID = 3 AND W95.WareHouseID2 IS NOT NULL THEN A04.WareHouseName ELSE '''' END END ExWareHouseName
	FROM WT0095 W95
	LEFT JOIN AT1303 A04 ON A04.DivisionID = W95.DivisionID AND A04.WareHouseID = W95.WareHouseID2
	LEFT JOIN AT1303 A03 ON A03.DivisionID = W95.DivisionID AND A03.WareHouseID = W95.WareHouseID
	LEFT JOIN AT1202 A02 ON A02.DivisionID = W95.DivisionID AND A02.ObjectID = W95.ObjectID
	LEFT JOIN WT0096 W96 ON W96.DivisionID = W95.DivisionID AND W96.VoucherID = W95.VoucherID
	LEFT JOIN WT8899 O99 ON O99.DivisionID = W96.DivisionID AND O99.VoucherID = W96.VoucherID AND O99.TransactionID = W96.TransactionID AND O99.TableID = ''WT0096''
	LEFT JOIN (SELECT 
		AT2007.DivisionID, 
		AT2007.OrderID,
		AT2007.InheritVoucherID,
		AT2007.InheritTransactionID, 
		AT2007.OTransactionID,
		AT2007.InventoryID, 
		SUM(ISNULL(AT2007.ConvertedQuantity, 0)) AS ActualConvertedQuantity, 
		SUM(ISNULL(AT2007.ActualQuantity, 0)) AS ActualQuantity, 
		SUM(ISNULL(AT2007.OriginalAmount, 0)) AS ActualOriginalAmount, 
		SUM(ISNULL(AT2007.ConvertedAmount, 0)) AS ActualConvertedAmount,
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		FROM AT2007 
		INNER JOIN AT2006 ON AT2007.VoucherID = AT2006.VoucherID AND AT2007.DivisionID = AT2006.DivisionID
		LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID AND O99.TableID = ''AT2007''
		WHERE AT2007.InheritTableID = ''WT0095''
		GROUP BY AT2007.DivisionID, AT2007.OrderID, InventoryID, OTransactionID, AT2007.InheritVoucherID, AT2007.InheritTransactionID, 
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID) AS G 
												ON G.InheritVoucherID = W96.VoucherID AND G.InventoryID = W96.InventoryID AND 
												G.InheritTransactionID = W96.TransactionID AND
												Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND 
												Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND 
												Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND 
												Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND 
												Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND 
												Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND 
												Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND 
												Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND
												Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND 
												Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''') AND	Isnull(G.S01ID,'''') = Isnull(O99.S01ID,'''')
	WHERE W95.DivisionID = '''+@DivisionID+'''
	AND W95.IsCheck = 1
	AND Isnull(W96.ActualQuantity, 0) - isnull(G.ActualQuantity,0) > 0
	--AND W95.VoucherID NOT IN (SELECT ISNULL(InheritVoucherID,'''') FROM AT2007 WHERE InheritTableID = ''WT0095'')
	AND ISNULL(W95.ObjectID,'''') LIKE '''+@ObjectID+'''
	'+@sWhere+'
	'
ELSE
	SET @sSQL = '
	SELECT CONVERT(TINYINT,0) Choose, W95.VoucherID, W95.VoucherNo, W95.VoucherTypeID, W95.VoucherDate, A02.ObjectName, W95.[Description],
	CASE WHEN W95.KindVoucherID IN (1,3,5,7,9) THEN A03.WareHouseName ELSE '''' END ImWareHouseName,
	CASE WHEN W95.KindVoucherID IN (2,4,6,8,10) THEN A03.WareHouseName ELSE  
	CASE WHEN W95.KindVoucherID = 3 AND W95.WareHouseID2 IS NOT NULL THEN A04.WareHouseName ELSE '''' END END ExWareHouseName
	FROM WT0095 W95
	LEFT JOIN AT1303 A04 ON A04.DivisionID = W95.DivisionID AND A04.WareHouseID = W95.WareHouseID2
	LEFT JOIN AT1303 A03 ON A03.DivisionID = W95.DivisionID AND A03.WareHouseID = W95.WareHouseID
	LEFT JOIN AT1202 A02 ON A02.DivisionID = W95.DivisionID AND A02.ObjectID = W95.ObjectID
	LEFT JOIN WT0096 W96 ON W96.DivisionID = W95.DivisionID AND W96.VoucherID = W95.VoucherID
	LEFT JOIN (SELECT 
		AT2007.DivisionID, 
		AT2007.OrderID,
		AT2007.InheritVoucherID, 
		AT2007.OTransactionID,
		AT2007.InventoryID, 
		SUM(ISNULL(AT2007.ConvertedQuantity, 0)) AS ActualConvertedQuantity, 
		SUM(ISNULL(AT2007.ActualQuantity, 0)) AS ActualQuantity, 
		SUM(ISNULL(AT2007.OriginalAmount, 0)) AS ActualOriginalAmount, 
		SUM(ISNULL(AT2007.ConvertedAmount, 0)) AS ActualConvertedAmount
		FROM AT2007 
		INNER JOIN AT2006 ON AT2007.VoucherID = AT2006.VoucherID AND AT2007.DivisionID = AT2006.DivisionID
		WHERE AT2007.InheritTableID = ''WT0095''
		GROUP BY AT2007.DivisionID, AT2007.OrderID, InventoryID, OTransactionID, AT2007.InheritVoucherID) AS G 
												ON G.InheritVoucherID = W96.VoucherID AND G.InventoryID = W96.InventoryID
	WHERE W95.DivisionID = '''+@DivisionID+'''
	AND W95.IsCheck = 1
	AND Isnull(W96.ActualQuantity, 0) - isnull(G.ActualQuantity,0) > 0
	--AND W95.VoucherID NOT IN (SELECT ISNULL(InheritVoucherID,'''') FROM AT2007 WHERE InheritTableID = ''WT0095'')
	AND ISNULL(W95.ObjectID,'''') LIKE '''+@ObjectID+'''
	'+@sWhere+'
	'		
EXEC(@sSQL)
--PRINT(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

