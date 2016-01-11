IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0080]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0080]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- In báo cáo tuổi hàng tồn kho
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 01/11/2012 by Lê Thị Thu Hiền : 
---- 
---- Modified on 01/11/2012 by 
-- <Example>
---- EXEC WP0080 'AS', 'ADMIN', 0, '01/11/2012','01/11/2012','A01', 'DUA', 'X', '01/01/2012'
CREATE PROCEDURE WP0080
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@IsDate AS TINYINT,
	@FromImportDate AS DATETIME,
	@ToImportDate AS DATETIME,
	@AnaTypeID AS NVARCHAR(50),
	@FromInventoryID AS NVARCHAR(50),
	@ToInventoryID AS NVARCHAR(50),
	@PrintDate AS DATETIME
) 
AS 
DECLARE @Ssql AS NVARCHAR(4000),
		@AnaID AS NVARCHAR(4000),
		@Swhere AS NVARCHAR(4000)
		
SET @AnaID = RIGHT(@AnaTypeID,2)	
SET @Swhere = N''

IF @IsDate = 1
BEGIN
	SET @Swhere = N' AND A1.VoucherDate BETWEEN '''+CONVERT (NVARCHAR(20),@FromImportDate,101)+''' AND '''+CONVERT(NVARCHAR(20),@ToImportDate,101)+''' '
END
	
SET @Ssql =N'
SELECT	O.InventoryID, A.InventoryName, 
		O1.VoucherDate AS ImportDate, O4.ExportDate,
		O.Ana'+@AnaID+'ID AS Seri,
		O1.WareHouseID, O1.VoucherNo AS ImportVoucherNo,
		CASE WHEN DATEDIFF(day,''' + CONVERT (NVARCHAR(20),@PrintDate,101) + ''',O1.VoucherDate) >0 THEN 0 ELSE -DATEDIFF(day,''' + CONVERT (NVARCHAR(20),@PrintDate,101) + ''',O1.VoucherDate)END AS DateInWareHouse , 
		O.ActualQuantity - ISNULL(O4.ActualQuantity,0) AS EndQuantity
FROM AT2007 O
LEFT JOIN AT2006 O1 ON O1.DivisionID = O.DivisionID AND O1.VoucherID = O.VoucherID
LEFT JOIN AT1302 A ON A.DivisionID = O.DivisionID AND O.InventoryID = A.InventoryID
LEFT JOIN (	SELECT	O2.InventoryID, O2.DivisionID,O3.WareHouseID AS WareHouseID,
					MAX(O3.VoucherDate) AS ExportDate, O2.Ana'+@AnaID+'ID,
					SUM(O2.ActualQuantity) AS ActualQuantity
			FROM	AT2007 O2
			LEFT JOIN AT2006 O3 ON O3.DivisionID = O2.DivisionID AND O3.VoucherID = O2.VoucherID
            WHERE	O2.DivisionID = '''+@DivisionID+'''
					AND O3.KindVoucherID IN (2,  4, 6, 8, 10, 14, 20)
					AND DATEDIFF(DAY, ''' + CONVERT (NVARCHAR(20),@PrintDate,101) + ''', O3.VoucherDate ) <=0 
			GROUP BY O2.InventoryID, O2.DivisionID,O3.WareHouseID,
					 O2.Ana'+@AnaID+'ID	
			UNION ALL
			SELECT	O2.InventoryID, O2.DivisionID,O3.WareHouseID2 AS WareHouseID,
					MAX(O3.VoucherDate) AS ExportDate, O2.Ana'+@AnaID+'ID,
					SUM(O2.ActualQuantity) AS ActualQuantity
			FROM	AT2007 O2
			LEFT JOIN AT2006 O3 ON O3.DivisionID = O2.DivisionID AND O3.VoucherID = O2.VoucherID
            WHERE	O2.DivisionID = '''+@DivisionID+'''
					AND O3.KindVoucherID = 3
					AND DATEDIFF(DAY, ''' + CONVERT (NVARCHAR(20),@PrintDate,101) + ''', O3.VoucherDate ) <=0 
			GROUP BY O2.InventoryID, O2.DivisionID,O3.WareHouseID2,
					 O2.Ana'+@AnaID+'ID		
			)O4
	ON		O.DivisionID = O4.DivisionID 
			AND O.InventoryID = O4.InventoryID 
			AND O1.WareHouseID = O4.WareHouseID
			AND O.Ana'+@AnaID+'ID = O4.Ana'+@AnaID+'ID
WHERE O.DivisionID = '''+@DivisionID+'''
AND O1.KindVoucherID in (1,3, 5, 7, 9, 15, 17)
AND O.InventoryID BETWEEN '''+@FromInventoryID+''' AND '''+@ToInventoryID+'''
AND O.ActualQuantity - ISNULL(O4.ActualQuantity,0) >0	

UNION ALL
SELECT	A.InventoryID, A2.InventoryName, 
		A1.VoucherDate AS ImportDate, A4.ExportDate,
		A.Ana'+@AnaID+'ID AS Seri,
		A1.WareHouseID, A1.VoucherNo AS ImportVoucherNo,
		CASE WHEN DATEDIFF(day,''' + CONVERT (NVARCHAR(20),@PrintDate,101) + ''',A1.VoucherDate) >0 THEN 0 ELSE -DATEDIFF(day,''' + CONVERT (NVARCHAR(20),@PrintDate,101) + ''',A1.VoucherDate)END AS DateInWareHouse , 
		A.ActualQuantity - ISNULL(A4.ActualQuantity,0) AS EndQuantity
FROM AT2017 A
LEFT JOIN AT2016 A1 ON A1.DivisionID = A.DivisionID AND A1.VoucherID = A.VoucherID	
LEFT JOIN AT1302 A2 ON A2.DivisionID = A.DivisionID AND A2.InventoryID = A.InventoryID
LEFT JOIN (	SELECT	O2.InventoryID, O2.DivisionID,O3.WareHouseID AS WareHouseID,
					MAX(O3.VoucherDate) AS ExportDate, O2.Ana'+@AnaID+'ID,
					SUM(O2.ActualQuantity) AS ActualQuantity
			FROM	AT2007 O2
			LEFT JOIN AT2006 O3 ON O3.DivisionID = O2.DivisionID AND O3.VoucherID = O2.VoucherID
            WHERE	O2.DivisionID = '''+@DivisionID+'''
					AND O3.KindVoucherID IN (2,  4, 6, 8, 10, 14, 20)
					AND DATEDIFF(DAY, ''' + CONVERT (NVARCHAR(20),@PrintDate,101) + ''', O3.VoucherDate ) <=0 
			GROUP BY O2.InventoryID, O2.DivisionID,O3.WareHouseID,
					 O2.Ana'+@AnaID+'ID	
			UNION ALL
			SELECT	O2.InventoryID, O2.DivisionID,O3.WareHouseID2 AS WareHouseID,
					MAX(O3.VoucherDate) AS ExportDate, O2.Ana'+@AnaID+'ID,
					SUM(O2.ActualQuantity) AS ActualQuantity
			FROM	AT2007 O2
			LEFT JOIN AT2006 O3 ON O3.DivisionID = O2.DivisionID AND O3.VoucherID = O2.VoucherID
            WHERE	O2.DivisionID = '''+@DivisionID+'''
					AND O3.KindVoucherID = 3
					AND DATEDIFF(DAY, ''' + CONVERT (NVARCHAR(20),@PrintDate,101) + ''', O3.VoucherDate ) <=0 
			GROUP BY O2.InventoryID, O2.DivisionID,O3.WareHouseID2,
					 O2.Ana'+@AnaID+'ID		
			)A4
	ON		A.DivisionID = A4.DivisionID 
			AND A.InventoryID = A4.InventoryID 
			AND A1.WareHouseID = A4.WareHouseID
			AND A.Ana'+@AnaID+'ID = A4.Ana'+@AnaID+'ID
					
WHERE A.DivisionID = '''+@DivisionID+'''
AND A.InventoryID BETWEEN '''+@FromInventoryID+''' AND '''+@ToInventoryID+'''
AND A.ActualQuantity - ISNULL(A4.ActualQuantity,0) >0	
'

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'WV0080' AND SYSOBJECTS.XTYPE = 'V')
    EXEC ('CREATE VIEW WV0080 AS ' + @Ssql + @Swhere)
ELSE
    EXEC ('ALTER VIEW WV0080 AS ' + @Ssql + @Swhere)
PRINT(@Ssql)
PRINT(@Swhere)
EXEC(@Ssql + @Swhere)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

