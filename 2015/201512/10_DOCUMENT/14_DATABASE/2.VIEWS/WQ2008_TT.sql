IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WQ2008_TT]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[WQ2008_TT]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Đổ nguồn Khoản mục theo kho mua hàng
---- Customize cho Tân Thành, Cường Thanh
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 22/08/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 19/07/2013 by Lê Thị Thu Hiền :
-- <Example>
---- 
CREATE VIEW [dbo].[WQ2008_TT] 
AS

--------->>>>>> Cường Thanh, Tân Thành thì mở đoạn này ra
/*
SELECT A.DivisionID, WareHouseID, InventoryID, Ana02ID 
FROM 
(
SELECT T7.DivisionID, WareHouseID, InventoryID, Ana02ID, Isnull(SUM(isnull(ActualQuantity,0)),0) As EndQuantity
FROM AT2017 T7 
INNER JOIN AT2016 T6 On T7.VoucherID = T6.VoucherID AND T6.DivisionID = T7.DivisionID
GROUP BY T7.DivisionID, WareHouseID, InventoryID, Ana02ID

UNION ALL

SELECT T7.DivisionID,WareHouseID, InventoryID, Ana02ID, Isnull(SUM(isnull(ActualQuantity,0)),0) As EndQuantity
FROM AT2007 T7 
INNER JOIN AT2006 T6 On T7.VoucherID = T6.VoucherID AND T6.DivisionID = T7.DivisionID
WHERE KindVoucherID In (1,3,5,7,9,11,13,15,17,19)
GROUP BY T7.DivisionID, WareHouseID, InventoryID, Ana02ID

UNION ALL

SELECT T7.DivisionID,Case When KindVoucherID=3 Then WareHouseID2 Else WareHouseID End As WareHouseID, InventoryID, Ana02ID, -Isnull(SUM(isnull(ActualQuantity,0)),0) As EndQuantity
FROM AT2007 T7 
INNER JOIN AT2006 T6 On T7.VoucherID = T6.VoucherID AND T6.DivisionID = T7.DivisionID
WHERE KindVoucherID In (2,3,4,6,8,10,12,14,16,18,20)
GROUP BY T7.DivisionID,Case When KindVoucherID=3 Then WareHouseID2 Else WareHouseID End, InventoryID, Ana02ID
) A
GROUP BY A.DivisionID, WareHouseID, InventoryID, Ana02ID
HAVING SUM(EndQuantity)>0
*/
---------<<<<<<<< Cường Thanh, Tân Thành thì mở đoạn này ra


SELECT '' AS DivisionID, '' AS WareHouseID, '' AS InventoryID, '' AS Ana02ID 

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

