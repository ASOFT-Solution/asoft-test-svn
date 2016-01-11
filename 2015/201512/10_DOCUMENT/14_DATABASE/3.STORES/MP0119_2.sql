IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0119_2]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0119_2]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Chi tiết Grid đơn hàng sản xuất MF0119
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 06/03/2015 
---- Modified on 
-- <Example>
/*
	 MP0119_2 'PL','ASOFTADMIN', 'IO/01/2015/0001'
*/

 CREATE PROCEDURE MP0119_2
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@SOrderID VARCHAR(50)
)
AS
DECLARE @sSQL NVARCHAR(MAX)

SET @sSQL = '
SELECT CONVERT(TINYINT, 0) IsChoose, O02.SOrderID, O02.TransactionID, O02.InventoryID, A02.InventoryName, O02.UnitID, A04.UnitName,
	O02.OrderQuantity Quantity, O02.EndDate
FROM OT2002 O02
LEFT JOIN AT1304 A04 ON A04.DivisionID = O02.DivisionID AND A04.UnitID = O02.UnitID
LEFT JOIN AT1302 A02 ON A02.DivisionID = O02.DivisionID AND A02.InventoryID = O02.InventoryID
WHERE O02.DivisionID = '''+@DivisionID+'''
AND O02.SOrderID = '''+@SOrderID+''' '

EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
