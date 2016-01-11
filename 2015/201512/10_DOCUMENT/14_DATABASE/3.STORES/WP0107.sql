IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0107]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP0107]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Master cho màn hình MF0104 - kế thừa lệnh sản xuất [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 06/10/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/* -- VÍ DỤ
 WP0107 @DivisionID = 'AP', @FromMonth = 8, @FromYear = 2014, @ToMonth = 9, @ToYear = 2014, @EOVoucherID = 'AD20140000000001'
  WP0107 @DivisionID = 'AP',@FromMonth = 9, @FromYear = 2014, @ToMonth = 9, @ToYear = 2014, @EOVoucherID = NULL
 */
 
CREATE PROCEDURE [dbo].[WP0107] 	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@EOVoucherID NVARCHAR(50) -- VoucherID của phiếu xuất kho - Truyền vào khi Edit
AS
DECLARE @sSQL1 NVARCHAR(MAX)
		
SET @EOVoucherID = ISNULL(@EOVoucherID,'')
/*
WITH MT21 (DivisionID, PlanID, VoucherTypeID, VoucherNo, VoucherDate, MOVoucherNo, ProductID, [Description])
AS 
   (SELECT MT21.DivisionID, 
		   MT21.PlanID, MT21.VoucherTypeID, MT21.VoucherNo, MT21.VoucherDate, OT21.VoucherNo, 
		  MT21.ProductID, MT21.[Description]     
	FROM MT2001 MT21
	INNER JOIN OT2001 OT21 ON OT21.DivisionID = MT21.DivisionID AND OT21.SOrderID = MT21.SOderID
	LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT21.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID
	WHERE MT21.DivisionID = '''+@DivisionID+''' AND AT27.VoucherID = '''+@EOVoucherID+'''
	GROUP BY MT21.PlanID, MT21.VoucherTypeID, MT21.VoucherNo, MT21.VoucherDate, OT21.VoucherNo, MT21.ProductID,
			  MT21.DivisionID, MT21.[Description]
	UNION 
	SELECT MT21.DivisionID,
		   MT21.PlanID, MT21.VoucherTypeID, MT21.VoucherNo, MT21.VoucherDate, OT21.VoucherNo, 
		   MT21.ProductID, MT21.[Description]  
	FROM MT2001 MT21
	INNER JOIN MT0164 MT64 ON MT64.DivisionID = MT21.DivisionID AND MT64.PlanID = MT21.PlanID
	INNER JOIN OT2001 OT21 ON OT21.DivisionID = MT21.DivisionID AND OT21.SOrderID = MT21.SOderID
	LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT64.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT64.PlanID AND AT27.InheritTransactionID = MT64.APK
	WHERE MT21.DivisionID = '''+@DivisionID+''' AND
	MT21.TranYear*12 + MT21.TranMonth BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+'
	GROUP BY MT21.PlanID, MT21.VoucherTypeID, MT21.VoucherNo, MT21.VoucherDate, OT21.VoucherNo, 
			  MT21.DivisionID, MT21.ProductID, MT21.[Description], MT64.InventoryID, MT64.Quantity
	HAVING ISNULL(MT64.Quantity,0) - SUM(ISNULL(AT27.ActualQuantity,0)) > 0)
SELECT CASE WHEN MT21.PlanID IN(
		    SELECT AT27.InheritVoucherID
			FROM AT2007 AT27
			WHERE MT21.DivisionID = '''+@DivisionID+''' AND AT27.InheritTableID = ''MT2001'' AND AT27.VoucherID = '''+@EOVoucherID+'''
	        ) THEN CONVERT(BIT,1) 
	        ELSE CONVERT(BIT,0) END AS [Choose],
       MT21.PlanID AS VoucherID, MT21.VoucherTypeID, MT21.VoucherNo, MT21.VoucherDate, MT21.MOVoucherNo, 
       MT21.ProductID, AT12.InventoryName AS ProductName, MT21.[Description]
FROM MT21
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT21.DivisionID AND AT12.InventoryID = MT21.ProductID
ORDER BY [Choose] DESC, MT21.VoucherDate, MT21.VoucherNo
*/
SET @sSQL1 = '
SELECT CONVERT(BIT,1) AS [Choose],
	   MT21.PlanID AS VoucherID, MT21.VoucherTypeID, MT21.VoucherNo, MT21.VoucherDate, OT21.VoucherNo AS MOVoucherNo, 
	   MT21.ProductID, AT12.InventoryName AS ProductName, MT21.[Description]
FROM MT2001 MT21
INNER JOIN OT2001 OT21 ON OT21.DivisionID = MT21.DivisionID AND OT21.SOrderID = MT21.SOderID
LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT21.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT21.DivisionID AND AT12.InventoryID = MT21.ProductID
WHERE MT21.DivisionID = '''+@DivisionID+''' AND AT27.VoucherID = '''+@EOVoucherID+'''
GROUP BY MT21.PlanID, MT21.VoucherTypeID, MT21.VoucherNo, MT21.VoucherDate, OT21.VoucherNo, MT21.ProductID,
		 AT12.InventoryName, MT21.[Description]
UNION 
SELECT CONVERT(BIT,0) AS [Choose],
	   MT21.PlanID AS VoucherID, MT21.VoucherTypeID, MT21.VoucherNo, MT21.VoucherDate, OT21.VoucherNo AS MOVoucherNo, 
	   MT21.ProductID, AT12.InventoryName AS ProductName, MT21.[Description]
FROM MT2001 MT21
INNER JOIN MT0164 MT64 ON MT64.DivisionID = MT21.DivisionID AND MT64.PlanID = MT21.PlanID
INNER JOIN OT2001 OT21 ON OT21.DivisionID = MT21.DivisionID AND OT21.SOrderID = MT21.SOderID
LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT64.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT64.PlanID AND AT27.InheritTransactionID = MT64.APK
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT21.DivisionID AND AT12.InventoryID = MT21.ProductID
WHERE MT21.DivisionID = '''+@DivisionID+''' AND
MT21.TranYear*12 + MT21.TranMonth BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+'
      AND MT21.PlanID NOT IN(
						 SELECT AT27.InheritVoucherID
						 FROM AT2007 AT27
						 WHERE MT21.DivisionID = '''+@DivisionID+''' AND AT27.InheritTableID = ''MT2001'' AND AT27.VoucherID = '''+@EOVoucherID+''')
GROUP BY MT21.PlanID, MT21.VoucherTypeID, MT21.VoucherNo, MT21.VoucherDate, OT21.VoucherNo, MT21.ProductID,
		 AT12.InventoryName, MT21.[Description], MT64.InventoryID, MT64.Quantity
HAVING ISNULL(MT64.Quantity,0) - SUM(ISNULL(AT27.ActualQuantity,0)) > 0
UNION 
SELECT CONVERT(BIT,0) AS [Choose],
	   MT21.PlanID AS VoucherID, MT21.VoucherTypeID, MT21.VoucherNo, MT21.VoucherDate, OT21.VoucherNo AS MOVoucherNo, 
	   MT21.ProductID, AT12.InventoryName AS ProductName, MT21.[Description]
FROM MT2001 MT21
INNER JOIN MT0108 MT08 ON MT08.DivisionID = MT21.DivisionID AND MT08.VoucherID = MT21.MixVoucherID
INNER JOIN OT2001 OT21 ON OT21.DivisionID = MT21.DivisionID AND OT21.SOrderID = MT21.SOderID
LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT21.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID AND AT27.InheritTransactionID = MT08.TransactionID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT21.DivisionID AND AT12.InventoryID = MT21.ProductID
WHERE MT21.DivisionID = '''+@DivisionID+''' AND
MT21.TranYear*12 + MT21.TranMonth BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+'
      AND MT21.PlanID NOT IN(
						 SELECT AT27.InheritVoucherID
						 FROM AT2007 AT27
						 WHERE MT21.DivisionID = '''+@DivisionID+''' AND AT27.InheritTableID = ''MT2001'' AND AT27.VoucherID = '''+@EOVoucherID+''')
GROUP BY MT21.PlanID, MT21.VoucherTypeID, MT21.VoucherNo, MT21.VoucherDate, OT21.VoucherNo, MT21.ProductID,
		 AT12.InventoryName, MT21.[Description], MT08.MaterialID, MT08.WeightTotal
HAVING ISNULL(MT08.WeightTotal,0) - SUM(ISNULL(AT27.ActualQuantity,0)) > 0
ORDER BY [Choose] DESC, VoucherDate, VoucherNo
'
EXEC (@sSQL1)
--PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
