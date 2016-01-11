IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0124]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0124]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Detail cho màn hình MF0123 - kế thừa tiến độ sản xuất [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 19/03/2015 by Lê Thị Hạnh 
---- Modified on 18/12/2015 by Tiểu Mai: Bổ sung trường hợp thiết lập quản lý mặt hàng theo quy cách 
---- Modified on ... by ...
-- <Example>
/* -- VÍ DỤ
 exec MP0124 @DivisionID=N'VG',@VoucherIDList=N'ML2014000000001'',''ML2014000000002',@SPMVoucherID=N'MP2014000000002'
  
 */
CREATE PROCEDURE [dbo].[MP0124] 	
	@DivisionID NVARCHAR(50),
	@VoucherIDList NVARCHAR(MAX),
	@SPMVoucherID NVARCHAR(50), -- VoucherID của phiếu kết quả sản xuất - Truyền vào khi Edit
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sSQL2 NVARCHAR(MAX)

SET @sSQL2 = ''		
SET @SPMVoucherID = ISNULL(@SPMVoucherID,'')
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	SET @sSQL1 = '
		SELECT CONVERT(TINYINT,1) AS [IsCheck], ''MT2004'' AS TableID, MT24.VoucherID, MT25.TransactionID, 
			   MT25.PLanID, MT25.InventoryID, AT13.InventoryName, MT25.UnitID, 
			   ISNULL(MT25.ActualQuantity,0) AS ActualQuantity, 
			   SUM(ISNULL(MT11.Quantity,0)) AS InheritQuantity,
			   (ISNULL(MT25.ActualQuantity,0) - SUM(ISNULL(MT11.Quantity,0))) + SUM(ISNULL(MT11.Quantity,0)) AS RemainQuantity,
			   MT25.[Description], MT25.DepartmentID, AT12.DepartmentName, ISNULL(MT25.Finish,0) AS Finish,
			   MT25.Notes01, MT25.Notes02, MT25.Notes03, MT25.Notes04, MT25.Notes05, MT25.Orders, 
			   MT25.Ana01ID, MT25.Ana02ID, MT25.Ana03ID, MT25.Ana04ID, MT25.Ana05ID, MT25.Ana06ID, MT25.Ana07ID, MT25.Ana08ID, MT25.Ana09ID, MT25.Ana10ID,
			   O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			   O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		FROM MT2004 MT24
		INNER JOIN MT2005 MT25 ON MT25.DivisionID = MT24.DivisionID AND MT25.VoucherID = MT24.VoucherID
		LEFT JOIN MT1001 MT11 ON MT11.DivisionID = MT25.DivisionID  AND MT11.InheritTableID = ''MT2004'' AND MT11.InheritVoucherID = MT24.VoucherID AND MT11.InheritTransactionID = MT25.TransactionID
		LEFT JOIN AT1102 AT12 ON AT12.DivisionID = MT25.DivisionID AND AT12.DepartmentID = MT25.DepartmentID
		LEFT JOIN AT1302 AT13 ON AT13.DivisionID = MT25.DivisionID AND AT13.InventoryID = MT25.InventoryID
		LEFT JOIN MT8899 O99 ON O99.DivisionID = MT25.DivisionID AND O99.VoucherID = MT25.VoucherID AND O99.TransactionID = MT25.TransactionID
		WHERE MT24.DivisionID = '''+@DivisionID+''' AND MT11.VoucherID = '''+@SPMVoucherID+'''
			  AND MT24.VoucherID IN ('''+@VoucherIDList+''')
		GROUP BY MT24.VoucherID, MT25.TransactionID, 
			   MT25.PLanID, MT25.InventoryID, AT13.InventoryName, MT25.UnitID, MT25.ActualQuantity, 
			   MT25.[Description], MT25.DepartmentID, AT12.DepartmentName, MT25.Finish,
			   MT25.Notes01, MT25.Notes02, MT25.Notes03, MT25.Notes04, MT25.Notes05, MT25.Orders, 
			   MT25.Ana01ID, MT25.Ana02ID, MT25.Ana03ID, MT25.Ana04ID, MT25.Ana05ID, MT25.Ana06ID, MT25.Ana07ID, MT25.Ana08ID, MT25.Ana09ID, MT25.Ana10ID,
			   O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			   O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		'
	SET @sSQL2 = '
		UNION 
		SELECT CONVERT(TINYINT,0) AS [IsCheck], ''MT2004'' AS TableID, MT24.VoucherID, MT25.TransactionID, 
			   MT25.PLanID, MT25.InventoryID, AT13.InventoryName, MT25.UnitID, 
			   ISNULL(MT25.ActualQuantity,0) AS ActualQuantity, 
			   SUM(ISNULL(MT11.Quantity,0)) AS InheritQuantity,
			   (ISNULL(MT25.ActualQuantity,0) - SUM(ISNULL(MT11.Quantity,0))) AS RemainQuantity,
			   MT25.[Description], MT25.DepartmentID, AT12.DepartmentName, ISNULL(MT25.Finish,0) AS Finish,
			   MT25.Notes01, MT25.Notes02, MT25.Notes03, MT25.Notes04, MT25.Notes05, MT25.Orders, 
			   MT25.Ana01ID, MT25.Ana02ID, MT25.Ana03ID, MT25.Ana04ID, MT25.Ana05ID, MT25.Ana06ID, MT25.Ana07ID, MT25.Ana08ID, MT25.Ana09ID, MT25.Ana10ID,
			   O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			   O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		FROM MT2004 MT24
		INNER JOIN MT2005 MT25 ON MT25.DivisionID = MT24.DivisionID AND MT25.VoucherID = MT24.VoucherID
		LEFT JOIN MT1001 MT11 ON MT11.DivisionID = MT25.DivisionID  AND MT11.InheritTableID = ''MT2004'' AND MT11.InheritVoucherID = MT24.VoucherID AND MT11.InheritTransactionID = MT25.TransactionID
		LEFT JOIN AT1102 AT12 ON AT12.DivisionID = MT25.DivisionID AND AT12.DepartmentID = MT25.DepartmentID
		LEFT JOIN AT1302 AT13 ON AT13.DivisionID = MT25.DivisionID AND AT13.InventoryID = MT25.InventoryID
		LEFT JOIN MT8899 O99 ON O99.DivisionID = MT25.DivisionID AND O99.VoucherID = MT25.VoucherID AND O99.TransactionID = MT25.TransactionID
		WHERE MT24.DivisionID = '''+@DivisionID+''' AND MT25.TransactionID NOT IN (
																SELECT MT11.InheritTransactionID
																FROM MT1001 MT11
																WHERE MT11.DivisionID = '''+@DivisionID+''' AND MT11.InheritTableID = ''MT2004'' AND MT11.VoucherID = '''+@SPMVoucherID+''')
			  AND MT24.VoucherID IN ('''+@VoucherIDList+''')
		GROUP BY MT24.VoucherID, MT25.TransactionID, 
			   MT25.PLanID, MT25.InventoryID,AT13.InventoryName, MT25.UnitID, MT25.ActualQuantity, 
			   MT25.[Description], MT25.DepartmentID, AT12.DepartmentName, MT25.Finish,
			   MT25.Notes01, MT25.Notes02, MT25.Notes03, MT25.Notes04, MT25.Notes05, MT25.Orders, 
			   MT25.Ana01ID, MT25.Ana02ID, MT25.Ana03ID, MT25.Ana04ID, MT25.Ana05ID, MT25.Ana06ID, MT25.Ana07ID, MT25.Ana08ID, MT25.Ana09ID, MT25.Ana10ID,
			   O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			   O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		HAVING ISNULL(MT25.ActualQuantity,0) - SUM(ISNULL(MT11.Quantity,0)) > 0
		ORDER BY MT24.VoucherID, MT25.Orders, MT25.InventoryID
			'
END
ELSE
SET @sSQL1 = '
SELECT CONVERT(TINYINT,1) AS [IsCheck], ''MT2004'' AS TableID, MT24.VoucherID, MT25.TransactionID, 
	   MT25.PLanID, MT25.InventoryID, AT13.InventoryName, MT25.UnitID, 
	   ISNULL(MT25.ActualQuantity,0) AS ActualQuantity, 
	   SUM(ISNULL(MT11.Quantity,0)) AS InheritQuantity,
	   (ISNULL(MT25.ActualQuantity,0) - SUM(ISNULL(MT11.Quantity,0))) + SUM(ISNULL(MT11.Quantity,0)) AS RemainQuantity,
       MT25.[Description], MT25.DepartmentID, AT12.DepartmentName, ISNULL(MT25.Finish,0) AS Finish,
       MT25.Notes01, MT25.Notes02, MT25.Notes03, MT25.Notes04, MT25.Notes05, MT25.Orders
FROM MT2004 MT24
INNER JOIN MT2005 MT25 ON MT25.DivisionID = MT24.DivisionID AND MT25.VoucherID = MT24.VoucherID
LEFT JOIN MT1001 MT11 ON MT11.DivisionID = MT25.DivisionID  AND MT11.InheritTableID = ''MT2004'' AND MT11.InheritVoucherID = MT24.VoucherID AND MT11.InheritTransactionID = MT25.TransactionID
LEFT JOIN AT1102 AT12 ON AT12.DivisionID = MT25.DivisionID AND AT12.DepartmentID = MT25.DepartmentID
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = MT25.DivisionID AND AT13.InventoryID = MT25.InventoryID
WHERE MT24.DivisionID = '''+@DivisionID+''' AND MT11.VoucherID = '''+@SPMVoucherID+'''
	  AND MT24.VoucherID IN ('''+@VoucherIDList+''')
GROUP BY MT24.VoucherID, MT25.TransactionID, 
	   MT25.PLanID, MT25.InventoryID, AT13.InventoryName, MT25.UnitID, MT25.ActualQuantity, 
       MT25.[Description], MT25.DepartmentID, AT12.DepartmentName, MT25.Finish,
       MT25.Notes01, MT25.Notes02, MT25.Notes03, MT25.Notes04, MT25.Notes05, MT25.Orders
UNION 
SELECT CONVERT(TINYINT,0) AS [IsCheck], ''MT2004'' AS TableID, MT24.VoucherID, MT25.TransactionID, 
	   MT25.PLanID, MT25.InventoryID, AT13.InventoryName, MT25.UnitID, 
	   ISNULL(MT25.ActualQuantity,0) AS ActualQuantity, 
	   SUM(ISNULL(MT11.Quantity,0)) AS InheritQuantity,
	   (ISNULL(MT25.ActualQuantity,0) - SUM(ISNULL(MT11.Quantity,0))) AS RemainQuantity,
       MT25.[Description], MT25.DepartmentID, AT12.DepartmentName, ISNULL(MT25.Finish,0) AS Finish,
       MT25.Notes01, MT25.Notes02, MT25.Notes03, MT25.Notes04, MT25.Notes05, MT25.Orders
FROM MT2004 MT24
INNER JOIN MT2005 MT25 ON MT25.DivisionID = MT24.DivisionID AND MT25.VoucherID = MT24.VoucherID
LEFT JOIN MT1001 MT11 ON MT11.DivisionID = MT25.DivisionID  AND MT11.InheritTableID = ''MT2004'' AND MT11.InheritVoucherID = MT24.VoucherID AND MT11.InheritTransactionID = MT25.TransactionID
LEFT JOIN AT1102 AT12 ON AT12.DivisionID = MT25.DivisionID AND AT12.DepartmentID = MT25.DepartmentID
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = MT25.DivisionID AND AT13.InventoryID = MT25.InventoryID
WHERE MT24.DivisionID = '''+@DivisionID+''' AND MT25.TransactionID NOT IN (
														SELECT MT11.InheritTransactionID
														FROM MT1001 MT11
														WHERE MT11.DivisionID = '''+@DivisionID+''' AND MT11.InheritTableID = ''MT2004'' AND MT11.VoucherID = '''+@SPMVoucherID+''')
	  AND MT24.VoucherID IN ('''+@VoucherIDList+''')
GROUP BY MT24.VoucherID, MT25.TransactionID, 
	   MT25.PLanID, MT25.InventoryID,AT13.InventoryName, MT25.UnitID, MT25.ActualQuantity, 
       MT25.[Description], MT25.DepartmentID, AT12.DepartmentName, MT25.Finish,
       MT25.Notes01, MT25.Notes02, MT25.Notes03, MT25.Notes04, MT25.Notes05, MT25.Orders
HAVING ISNULL(MT25.ActualQuantity,0) - SUM(ISNULL(MT11.Quantity,0)) > 0
ORDER BY MT24.VoucherID, MT25.Orders, MT25.InventoryID
	'
EXEC (@sSQL1 + @sSQL2)
--PRINT(@sSQL1)
--PRINT(@sSQL2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON