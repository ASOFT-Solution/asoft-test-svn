IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0106]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP0106]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Detail cho màn hình MF0104 - kế thừa lệnh sản xuất [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 23/09/2014 by Lê Thị Hạnh 
---- Modify on 03/10/2014 by Lê Thị Hạnh: Bổ sung VoucherID của phiếu xuất kho , trường hợp Edit
---- Modified on 07/11/2014 by Lê Thị Hạnh: Bổ sung ProductID, ProductName - yêu cầu 4/11/2014
---- Modified on ... by 
-- <Example>
/* -- VÍ DỤ
 exec WP0106 @DivisionID=N'VG',@VoucherIDList=N'KH/01/15/001',@EOVoucherID=N'AD20150000000004'
 */
CREATE PROCEDURE [dbo].[WP0106] 	
	@DivisionID NVARCHAR(50),
	@VoucherIDList NVARCHAR(MAX),
	@EOVoucherID NVARCHAR(50) -- VoucherID của phiếu xuất kho - Truyền vào khi Edit
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sSQL2 NVARCHAR(MAX)
		
SET @EOVoucherID = ISNULL(@EOVoucherID,'')
-- Load dữ liệu cho GridMaterial - Nguyên vật liệu
/*
SELECT CASE WHEN MT21.TransactionID IN(
		    SELECT AT27.InheritTransactionID
			FROM AT2007 AT27
			WHERE MT21.DivisionID = '''+@DivisionID+''' AND AT27.InheritTableID = ''MT2001'' AND AT27.VoucherID = '''+@EOVoucherID+'''
	        ) THEN CONVERT(TINYINT,1) 
	        ELSE CONVERT(TINYINT,0) END AS [IsCheck],
	   ''MT2001'' AS TableID, MT21.PlanID, MT21.ProductID, AT02.InventoryName AS ProductName, 
	   MT21.TransactionID, MT21.TypeID, MT21.MaterialID,
	   AT12.InventoryName AS MaterialName, MT21.Notes01, AT12.UnitID, AT12.AccountID, 
	   AT12.IsSource, AT12.IsLimitDate, AT12.IsLocation, AT12.MethodID, 
       MT21.VolumeTotal, MT21.WeightTotal, MT21.InheritQuantity, MT21.RemainQuantity
FROM (
SELECT MT21.DivisionID, MT21.PlanID, MT21.ProductID, MT08.TransactionID, MT08.TypeID, MT08.MaterialID, MT08.Notes01, 
	   ISNULL(MT08.VolumeTotal,0) AS VolumeTotal, ISNULL(MT08.WeightTotal,0) AS WeightTotal, 
	   SUM(ISNULL(AT27.ActualQuantity,0)) AS InheritQuantity, 
	   ISNULL(MT08.WeightTotal,0) - SUM(ISNULL(AT27.ActualQuantity,0)) AS RemainQuantity	      
FROM MT2001 MT21
INNER JOIN MT0108 MT08 ON MT08.DivisionID = MT21.DivisionID AND MT08.VoucherID = MT21.MixVoucherID
LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT21.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID AND AT27.InheritTransactionID = MT08.TransactionID
WHERE MT21.DivisionID = '''+@DivisionID+''' AND MT21.PlanID IN ('''+@VoucherIDList+''')
GROUP BY MT21.DivisionID, MT21.PlanID, MT21.ProductID, MT08.TransactionID, MT08.TypeID, MT08.MaterialID, 
         MT08.Notes01, MT08.WeightTotal,MT08.VolumeTotal
HAVING ISNULL(MT08.WeightTotal,0) - SUM(ISNULL(AT27.ActualQuantity,0)) > 0) AS MT21
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT21.DivisionID AND AT12.InventoryID = MT21.MaterialID
LEFT JOIN AT1302 AT02 ON AT02.DivisionID = MT21.DivisionID AND AT02.InventoryID = MT21.ProductID
ORDER BY MT21.PlanID, [IsCheck] DESC, MT21.TypeID, MT21.MaterialID
*/
SET @sSQL1 = '
SELECT CONVERT(TINYINT,1) AS [IsCheck],
       ''MT2001'' AS TableID, MT21.PlanID, MT21.ProductID, AT02.InventoryName AS ProductName,
       MT08.TransactionID, MT08.TypeID, MT08.MaterialID, AT12.InventoryName AS MaterialName,
       MT08.Notes01, AT12.UnitID, AT12.AccountID, 
       AT12.IsSource, AT12.IsLimitDate, AT12.IsLocation, AT12.MethodID,
       ISNULL(MT08.VolumeTotal,0) AS VolumeTotal,
       ISNULL(MT08.WeightTotal,0) AS WeightTotal, 
       ISNULL(AT27.ActualQuantity,0) AS InheritQuantity,
       ISNULL(MT08.WeightTotal,0) - SUM(ISNULL(AT27.ActualQuantity,0)) + ISNULL(AT27.ActualQuantity,0) AS RemainQuantity
FROM MT2001 MT21
INNER JOIN MT0108 MT08 ON MT08.DivisionID = MT21.DivisionID AND MT08.VoucherID = MT21.MixVoucherID
INNER JOIN AT2007 AT27 ON AT27.DivisionID = MT21.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID AND AT27.InheritTransactionID = MT08.TransactionID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT21.DivisionID AND AT12.InventoryID = MT08.MaterialID
LEFT JOIN AT1302 AT02 ON AT02.DivisionID = MT21.DivisionID AND AT02.InventoryID = MT21.ProductID
WHERE MT21.DivisionID = '''+@DivisionID+''' AND AT27.VoucherID = '''+@EOVoucherID+'''
      AND MT21.PlanID IN ('''+@VoucherIDList+''')
GROUP BY MT21.PlanID, MT21.ProductID, AT02.InventoryName,
         MT08.TransactionID, MT08.TypeID, MT08.MaterialID, AT12.InventoryName,
         MT08.Notes01, AT12.UnitID, AT12.AccountID, 
         AT12.IsSource, AT12.IsLimitDate, AT12.IsLocation, AT12.MethodID,
         MT08.VolumeTotal, MT08.WeightTotal, AT27.ActualQuantity
UNION ALL
SELECT CONVERT(TINYINT,0) AS [IsCheck],
       ''MT2001'' AS TableID, MT21.PlanID, MT21.ProductID, AT02.InventoryName AS ProductName,
       MT08.TransactionID, MT08.TypeID, MT08.MaterialID, AT12.InventoryName AS MaterialName,
       MT08.Notes01, AT12.UnitID, AT12.AccountID, 
       AT12.IsSource, AT12.IsLimitDate, AT12.IsLocation, AT12.MethodID, 
       ISNULL(MT08.VolumeTotal,0) AS VolumeTotal,
       ISNULL(MT08.WeightTotal,0) AS WeightTotal, 
       SUM(ISNULL(AT27.ActualQuantity,0)) AS InheritQuantity,
       (ISNULL(MT08.WeightTotal,0) - SUM(ISNULL(AT27.ActualQuantity,0))) AS RemainQuantity
FROM MT2001 MT21
INNER JOIN MT0108 MT08 ON MT08.DivisionID = MT21.DivisionID AND MT08.VoucherID = MT21.MixVoucherID
LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT21.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID AND AT27.InheritTransactionID = MT08.TransactionID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT21.DivisionID AND AT12.InventoryID = MT08.MaterialID
LEFT JOIN AT1302 AT02 ON AT02.DivisionID = MT21.DivisionID AND AT02.InventoryID = MT21.ProductID
WHERE MT21.DivisionID = '''+@DivisionID+''' AND MT21.PlanID IN ('''+@VoucherIDList+''')
      AND MT08.TransactionID NOT IN (SELECT AT27.InheritTransactionID
						             FROM AT2007 AT27
						             WHERE AT27.DivisionID = '''+@DivisionID+''' AND AT27.InheritTableID = ''MT2001'' AND AT27.VoucherID = '''+@EOVoucherID+''')
GROUP BY MT21.PlanID, MT21.ProductID, AT02.InventoryName,
         MT08.TransactionID, MT08.TypeID, MT08.MaterialID, AT12.InventoryName,
         MT08.Notes01, AT12.UnitID, AT12.AccountID, 
         AT12.IsSource, AT12.IsLimitDate, AT12.IsLocation, AT12.MethodID,
         MT08.VolumeTotal, MT08.WeightTotal
HAVING (ISNULL(MT08.WeightTotal,0) - SUM(ISNULL(AT27.ActualQuantity,0))) > 0
ORDER BY PlanID, [IsCheck] DESC, TypeID, MaterialID
	'
EXEC (@sSQL1)
--PRINT(@sSQL1)
-- Load dữ liệu cho GridPacking - Vật liệu đóng gói
/*
SELECT CASE WHEN MT21.TransactionID IN(
		    SELECT AT27.InheritTransactionID
			FROM AT2007 AT27
			WHERE MT21.DivisionID = '''+@DivisionID+''' AND AT27.InheritTableID = ''MT2001'' AND AT27.VoucherID = '''+@EOVoucherID+'''
	        ) THEN CONVERT(TINYINT,1) 
	        ELSE CONVERT(TINYINT,0) END AS [IsCheck],
	   ''MT2001'' AS TableID, MT21.PlanID, MT21.ProductID, AT02.InventoryName AS ProductName, 
	   MT21.TransactionID, MT21.InventoryID,
	   AT12.InventoryName, AT12.Notes01, AT12.UnitID, AT12.AccountID, 
	   AT12.IsSource, AT12.IsLimitDate, AT12.IsLocation, AT12.MethodID, 
       MT21.InheritQuantity, MT21.RemainQuantity
FROM (
	SELECT MT64.DivisionID, MT64.PlanID, MT21.ProductID, MT64.APK AS TransactionID, MT64.InventoryID,
		   ISNULL(MT64.Quantity,0) AS Quantity, SUM(ISNULL(AT27.ActualQuantity,0)) AS InheritQuantity,
		   ISNULL(MT64.Quantity,0) - SUM(ISNULL(AT27.ActualQuantity,0)) AS RemainQuantity  
	FROM MT0164 MT64
	INNER JOIN MT2001 MT21 ON MT21.DivisionID = MT64.DivisionID AND MT21.PlanID = MT64.PlanID	
	LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT64.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT64.PlanID AND AT27.InheritTransactionID = MT64.APK
	WHERE MT64.DivisionID = '''+@DivisionID+''' AND MT64.PlanID IN ('''+@VoucherIDList+''')
	GROUP BY MT64.DivisionID, MT64.PlanID, MT21.ProductID, MT64.APK, MT64.InventoryID, MT64.Quantity 
HAVING ISNULL(MT64.Quantity,0) - SUM(ISNULL(AT27.ActualQuantity,0)) > 0) AS MT21
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT21.DivisionID AND AT12.InventoryID = MT21.InventoryID
LEFT JOIN AT1302 AT02 ON AT02.DivisionID = MT21.DivisionID AND AT02.InventoryID = MT21.ProductID
ORDER BY MT21.PlanID, [IsCheck] DESC, MT21.InventoryID
*/
SET @sSQL2 = '
SELECT CONVERT(TINYINT,1) AS [IsCheck],
       ''MT2001'' AS TableID, MT21.PlanID, MT21.ProductID, AT02.InventoryName AS ProductName, 
       MT64.APK AS TransactionID, MT64.InventoryID, AT12.InventoryName, 
       AT12.Notes01, AT12.UnitID, AT12.AccountID, 
	   AT12.IsSource, AT12.IsLimitDate, AT12.IsLocation, AT12.MethodID,
       ISNULL(AT27.ActualQuantity,0) AS InheritQuantity,
       (ISNULL(MT64.Quantity,0) - SUM(ISNULL(AT27.ActualQuantity,0)) + ISNULL(AT27.ActualQuantity,0)) AS RemainQuantity 
FROM MT2001 MT21
INNER JOIN MT0164 MT64 ON MT64.DivisionID = MT21.DivisionID AND MT64.PlanID = MT21.PlanID
INNER JOIN AT2007 AT27 ON AT27.DivisionID = MT21.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID AND AT27.InheritTransactionID = MT64.APK
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT21.DivisionID AND AT12.InventoryID = MT64.InventoryID
LEFT JOIN AT1302 AT02 ON AT02.DivisionID = MT21.DivisionID AND AT02.InventoryID = MT21.ProductID
WHERE MT21.DivisionID = '''+@DivisionID+''' AND AT27.VoucherID = '''+@EOVoucherID+'''
      AND MT21.PlanID IN ('''+@VoucherIDList+''')
GROUP BY MT21.PlanID, MT21.ProductID, AT02.InventoryName,
	     MT64.APK, MT64.InventoryID, AT12.InventoryName, 
         AT12.Notes01, AT12.UnitID, AT12.AccountID, 
	     AT12.IsSource, AT12.IsLimitDate, AT12.IsLocation, AT12.MethodID,
	     AT27.ActualQuantity, MT64.Quantity
UNION ALL
SELECT CONVERT(TINYINT,0) AS [IsCheck],
       ''MT2001'' AS TableID, MT21.PlanID, MT21.ProductID, AT02.InventoryName AS ProductName, 
       MT64.APK AS TransactionID, MT64.InventoryID, AT12.InventoryName, 
       AT12.Notes01, AT12.UnitID, AT12.AccountID, 
	   AT12.IsSource, AT12.IsLimitDate, AT12.IsLocation, AT12.MethodID,
       SUM(ISNULL(AT27.ActualQuantity,0)) AS InheritQuantity,
       (ISNULL(MT64.Quantity,0) - SUM(ISNULL(AT27.ActualQuantity,0))) AS RemainQuantity
FROM MT2001 MT21
INNER JOIN MT0164 MT64 ON MT64.DivisionID = MT21.DivisionID AND MT64.PlanID = MT21.PlanID
LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT21.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID AND AT27.InheritTransactionID = MT64.APK
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT21.DivisionID AND AT12.InventoryID = MT64.InventoryID
LEFT JOIN AT1302 AT02 ON AT02.DivisionID = MT21.DivisionID AND AT02.InventoryID = MT21.ProductID
WHERE MT21.DivisionID = '''+@DivisionID+''' AND MT21.PlanID IN ('''+@VoucherIDList+''')
      AND MT64.APK NOT IN (SELECT AT27.InheritTransactionID
						   FROM AT2007 AT27
						   WHERE AT27.DivisionID = '''+@DivisionID+''' AND AT27.InheritTableID = ''MT2001'' AND AT27.VoucherID = '''+@EOVoucherID+''')
GROUP BY MT21.PlanID, MT21.ProductID, AT02.InventoryName,
         MT64.APK, MT64.InventoryID, AT12.InventoryName, 
         AT12.Notes01, AT12.UnitID, AT12.AccountID, 
	     AT12.IsSource, AT12.IsLimitDate, AT12.IsLocation, AT12.MethodID,
	     MT64.Quantity
HAVING ISNULL(MT64.Quantity,0) - SUM(ISNULL(AT27.ActualQuantity,0)) > 0
ORDER BY PlanID, [IsCheck] DESC, MT64.InventoryID
	'
EXEC (@sSQL2)
--PRINT(@sSQL2)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
