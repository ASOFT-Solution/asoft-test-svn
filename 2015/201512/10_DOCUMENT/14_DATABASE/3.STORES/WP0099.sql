IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0099]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0099]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load danh sách phiếu yêu cầu nhập - xuất - VCNB lên màn hình Duyệt
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
    EXEC WP0099 'EIS','',5,2014
*/

 CREATE PROCEDURE WP0099
(
     @DivisionID VARCHAR(50),
     @UserID VARCHAR(50),
     @TranMonth INT,
     @TranYear INT     
)
AS

SELECT CASE WHEN W95.KindVoucherID IN (1,3,5,7,9) AND W95.WareHouseID2 IS NULL THEN 1 
WHEN W95.KindVoucherID  = 3 AND W95.WareHouseID2 IS NOT NULL THEN 3 ELSE 2 END KindVoucherID, ISNULL(W95.IsCheck,0) IsCheck,
 W95.VoucherTypeID, W95.VoucherID, W95.VoucherNo, W95.VoucherDate, W95.ObjectID, A02.ObjectName, W95.WareHouseID, 
CASE WHEN W95.KindVoucherID IN (1,3,5,7,9) THEN A03.WareHouseName ELSE '' END ImWareHouseName,
CASE WHEN W95.KindVoucherID IN (2,4,6,8,10) THEN A03.WareHouseName ELSE 
	CASE WHEN W95.KindVoucherID = 3 THEN A04.WareHouseName ELSE '' END END ExWareHouseName,
SUM (W96.ConvertedAmount) ConvertedAmount, W95.RefNo01, W95.RefNo02, W95.[Description]
FROM WT0095 W95
LEFT JOIN WT0096 W96 ON W96.DivisionID = W95.DivisionID AND W96.VoucherID = W95.VoucherID
LEFT JOIN AT1303 A03 ON A03.DivisionID = W95.DivisionID AND A03.WareHouseID = W95.WareHouseID
LEFT JOIN AT1303 A04 ON A04.DivisionID = W95.DivisionID AND A04.WareHouseID = W95.WareHouseID2
LEFT JOIN AT1202 A02 ON A02.DivisionID = W95.DivisionID AND A02.ObjectID = W95.ObjectID
WHERE W95.DivisionID = @DivisionID
AND W95.TranMonth = @TranMonth
AND W95.TranYear = @TranYear
GROUP BY W95.VoucherID, W95.VoucherTypeID, W95.VoucherNo, W95.VoucherDate, W95.ObjectID, A02.ObjectName, W95.WareHouseID,
KindVoucherID, A03.WareHouseName, A04.WareHouseName, W95.RefNo01, W95.RefNo02, W95.[Description],W95.WareHouseID2, IsCheck		


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
