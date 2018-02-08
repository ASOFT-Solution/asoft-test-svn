USE [ASOFT8.3.7]
GO
/****** Object:  StoredProcedure [dbo].[AP1323]    Script Date: 08/02/2018 8:20:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
---- Modified by Bảo Thy on 22/05/2017: Sửa danh mục dùng chung
---- Modified by Bảo Thy on 29/05/2017: Bổ sung DivisionID, IsCommon để lấy giá trị theo check Dùng Chung trên màn hình
---- Modified on 
-- <Example>
/*
AP1323 'HT', '', 'BUDDY_1.20'
*/
ALTER PROCEDURE [dbo].[AP1323]
(
@DivisionID VARCHAR(50),
@UserID VARCHAR(50),
@InventoryID VARCHAR(50)
)
AS

SELECT A28.DivisionID, A28.IsCommon, A28.StandardID, A28.StandardName, A28.StandardTypeID, 0 IsUsed, NULL InventoryID
FROM AT0128 A28
WHERE A28.DivisionID IN (@DivisionID, '@@@')
AND A28.[Disabled] = 0
AND A28.StandardTypeID + A28.StandardID NOT IN (SELECT StandardTypeID + StandardID FROM AT1323 WHERE DivisionID IN (@DivisionID,'@@@') AND AT1323.InventoryID = @InventoryID)

UNION ALL

SELECT A23.DivisionID, A28.IsCommon, A23.StandardID, A28.StandardName, A23.StandardTypeID, A23.IsUsed, A23.InventoryID
FROM AT1323 A23
LEFT JOIN AT0128 A28 ON A28.StandardID = A23.StandardID AND A28.StandardTypeID = A23.StandardTypeID
WHERE A23.DivisionID IN (@DivisionID,'@@@')
AND A23.InventoryID = @InventoryID
ORDER BY StandardTypeID, StandardID

