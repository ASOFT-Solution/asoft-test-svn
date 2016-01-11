IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0121_2]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0121_2]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Truy vấn BTP/NVL cho lệnh sản xuất
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by:Thanh Sơn  on: 18/03/2015
---- Modified on 
-- <Example>
/*
	 MP0121_2 'DNP', '','37843C5A-DF43-4475-8461-51D196533E9D'
*/

 CREATE PROCEDURE MP0121_2
(
 @DivisionID VARCHAR(50),
 @UserID VARCHAR(50),
 @APK VARCHAR(50)
)
AS
DECLARE @ApportionID VARCHAR(50), @InventoryID VARCHAR(50), @PlanQuantity DECIMAL(28,8)

SET @ApportionID = (SELECT TOP 1 ApportionID FROM MT0120 WHERE APK = @APK)
SET @InventoryID = (SELECT TOP 1 InventoryID FROM MT0120 WHERE APK = @APK)
SET @PlanQuantity = ISNULL((SELECT TOP 1 PlanQuantity FROM MT0120 WHERE APK = @APK),0)

SELECT M03.MaterialID InventoryID, A02.InventoryName, M03.UnitID, A04.UnitName, NULL WareHouseID, 
	@PlanQuantity / M03.ProductQuantity * M03.MaterialQuantity Quantity, 0 IsCompare
FROM MT1603 M03
LEFT JOIN AT1304 A04 ON A04.DivisionID = M03.DivisionID AND A04.UnitID = M03.UnitID
LEFT JOIN AT1302 A02 ON A02.DivisionID = M03.DivisionID AND A02.InventoryID = M03.MaterialID
WHERE M03.DivisionID = @DivisionID
AND M03.ApportionID = @ApportionID
AND M03.ProductID = @InventoryID
AND M03.ExpenseID = 'COST001'

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
