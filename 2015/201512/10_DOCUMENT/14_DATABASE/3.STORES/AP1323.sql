IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1323]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1) 
DROP PROCEDURE [DBO].[AP1323]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Gird quy cách bên màn hình cập nhật mặt hàng
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: on:
---- Modified on 
-- <Example>
/*
AP1323 'AS', '', 'BUDDY_1.20'
*/
CREATE PROCEDURE AP1323
(
@DivisionID VARCHAR(50),
@UserID VARCHAR(50),
@InventoryID VARCHAR(50)
)
AS

SELECT A28.StandardID, A28.StandardName, A28.StandardTypeID, 0 IsUsed, NULL InventoryID
FROM AT0128 A28
WHERE A28.DivisionID = @DivisionID
AND A28.[Disabled] = 0
AND A28.StandardTypeID + A28.StandardID NOT IN (SELECT StandardTypeID + StandardID FROM AT1323 WHERE DivisionID = @DivisionID AND AT1323.InventoryID = @InventoryID)

UNION ALL

SELECT A23.StandardID, A28.StandardName, A23.StandardTypeID, A23.IsUsed, A23.InventoryID
FROM AT1323 A23
LEFT JOIN AT0128 A28 ON A28.DivisionID = A23.DivisionID AND A28.StandardID = A23.StandardID AND A28.StandardTypeID = A23.StandardTypeID
WHERE A23.DivisionID = @DivisionID
AND A23.InventoryID = @InventoryID
ORDER BY StandardTypeID, StandardID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO