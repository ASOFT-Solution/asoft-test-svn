IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3001_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP3001_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- In báo cáo Nhu cầu thành phẩm (customize cho Đại Nam Phát)
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 03/07/2015
---- Modified on 
-- <Example>
/*
	
*/
CREATE PROCEDURE OP3001_1
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@SOrderID VARCHAR(50)
)
AS

SELECT O02.SOrderID, O01.VoucherNo, O02.InventoryID, A02.InventoryName, O02.OrderQuantity, 0 OweQuantity,
	0 ProductQuantity, 0 MaterialQuantity, (O02.OrderQuantity * O02.PlanPercent / 100) ReserveQuantity,
	O01.OrderDate, DAY(O01.OrderDate) [Date], MONTH(O01.OrderDate) [Month], YEAR(o01.OrderDate) [Year],
	A12.ObjectName
	--INTO OR2002
FROM OT2002 O02
LEFT JOIN AT1302 A02 ON A02.DivisionID = O02.DivisionID AND A02.InventoryID = O02.InventoryID
LEFT JOIN OT2001 O01 ON O01.DivisionID = O02.DivisionID AND O01.SOrderID = O02.SOrderID
LEFT JOIN AT1202 A12 ON A12.DivisionID = O01.DivisionID AND A12.ObjectID = O01.ObjectID
WHERE O01.DivisionID = @DivisionID
AND O02.SOrderID = @SOrderID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
