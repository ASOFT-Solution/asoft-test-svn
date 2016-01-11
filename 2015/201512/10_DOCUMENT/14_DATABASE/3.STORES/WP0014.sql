IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0104]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0104]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- In báo cáo Phiếu yêu cầu nhập, xuất, vận chuyển nội bộ
-- <Param>
---- 
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by:
-- <Example>
/*
    EXEC WP0104 'KC','','79ebd83b-e203-4183-a633-84a9c6135c94', 2
*/

 CREATE PROCEDURE WP0104
(
     @DivisionID NVARCHAR(2000),
     @UserID VARCHAR(50),
     @VoucherID VARCHAR(50),
     @Mode TINYINT  --: 0: Phiếu yêu cầu nhập, 1: Phiếu yêu cầu xuất, 2: Phiếu yêu cầu VCNB

)
AS
DECLARE @sSQL NVARCHAR(MAX),
		@sWhere NVARCHAR(2000)
		
SET @sWhere = ''		
IF @Mode = 2
SET @sWhere = 'W95.WareHouseID2 ExVoucherID, A03.WareHouseName ExVoucherName, W95.WareHouseID ImWareHouseID, A01.WareHouseName ImVoucherName,'

IF @Mode = 0 
SET @sWhere = ' W95.WareHouseID ImWareHouseID, A01.WareHouseName ImVoucherName,'

IF @Mode = 1
SET @sWhere = ' W95.WareHouseID ExVoucherID, A01.WareHouseName ExVoucherName,'

SET @sSQL = '
	SELECT W95.VoucherNo, W95.VoucherDate, '+@sWhere+' W95.[Description],
	W96.InventoryID, A02.InventoryName, W96.UnitID, SUM(W96.ConvertedQuantity) ConvertedQuantity,
	W96.UnitPrice, SUM(W96.ConvertedAmount) ConvertedAmount
	FROM WT0095 W95
	LEFT JOIN WT0096 W96 ON W96.DivisionID = W95.DivisionID AND W96.VoucherID = W95.VoucherID
	LEFT JOIN AT1302 A02 ON A02.DivisionID = W96.DivisionID AND A02.InventoryID = W96.InventoryID
	LEFT JOIN AT1303 A01 ON A01.DivisionID = W95.DivisionID AND A01.WareHouseID = W95.WareHouseID
	LEFT JOIN AT1303 A03 ON A03.DivisionID = W95.DivisionID AND A03.WareHouseID = W95.WareHouseID2
	WHERE W95.DivisionID = '''+@DivisionID+'''
	AND W95.VoucherID = '''+@VoucherID+'''
	GROUP BY W95.VoucherNo, W95.VoucherDate, W95.WareHouseID2, A03.WareHouseName, W95.WareHouseID,
	A01.WareHouseName, W95.[Description], W96.InventoryID, A02.InventoryName, W96.UnitID,
	W96.UnitPrice'

EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
