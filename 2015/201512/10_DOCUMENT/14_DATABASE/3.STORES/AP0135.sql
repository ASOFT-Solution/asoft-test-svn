IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0135]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0135]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load chi tiết đơn giá quy cách theo từng mặt hàng trường hợp new/edit/view
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 27/04/2015
---- Modified on 26/10/2015 by Tiểu Mai: bổ sung ràng buộc UnitID
-- <Example>
/*
	AP0135 @DivisionID='HD',@UserID='ASOFTADMIN',@PriceID='COE003_0001',@InventoryID='BUDDY_1.40'
*/
CREATE PROCEDURE AP0135
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@PriceID VARCHAR(50),
	@InventoryID VARCHAR(50),
	@UnitID VARCHAR(50)
)
AS


CREATE TABLE #Tam (StandardTypeID VARCHAR(50), StandardID VARCHAR(50), StandardName NVARCHAR(50))
INSERT INTO #Tam
SELECT A28.StandardTypeID, A.StandardID, A28.StandardName
FROM
(
	SELECT DISTINCT StandardID
	FROM AT0128
	WHERE DivisionID = @DivisionID
	AND [Disabled] = 0
)A
LEFT JOIN AT0128 A28 ON A28.APK = (SELECT TOP 1 APK FROM AT0128 WHERE DivisionID = @DivisionID AND StandardID = A.StandardID)
WHERE A28.StandardTypeID LIKE 'S%'

SELECT B.StandardID, B.StandardName, B.StandardTypeID, A05.UserName StandardTypeName, UnitPrice
FROM
( 
	SELECT O00.StandardID, Tam.StandardName, Tam.StandardTypeID, O00.UnitPrice
	FROM AT0135 O00
	LEFT JOIN #Tam Tam ON Tam.StandardID = O00.StandardID
	LEFT JOIN AT1323 A23 ON A23.StandardTypeID = Tam.StandardTypeID AND A23.StandardID = Tam.StandardID AND A23.InventoryID = @InventoryID 
	WHERE O00.DivisionID = @DivisionID AND O00.PriceID = @PriceID AND O00.InventoryID = @InventoryID AND ISNULL(A23.IsUsed, 0) = 1 AND O00.UnitID = @UnitID
	
	UNION ALL

	SELECT Tam.StandardID, Tam.StandardName, Tam.StandardTypeID, 0.00 UnitPrice
	FROM #Tam Tam
	LEFT JOIN AT1323 A23 ON A23.StandardTypeID = Tam.StandardTypeID AND A23.StandardID = Tam.StandardID AND A23.InventoryID = @InventoryID 
	WHERE Tam.StandardID NOT IN
	(
		SELECT O00.StandardID
		FROM AT0135 O00
		
		LEFT JOIN #Tam Tam ON Tam.StandardID = O00.StandardID
		LEFT JOIN AT1323 A23 ON A23.StandardTypeID = Tam.StandardTypeID AND A23.StandardID = Tam.StandardID AND A23.InventoryID = @InventoryID 
		WHERE O00.DivisionID = @DivisionID AND O00.PriceID = @PriceID AND O00.InventoryID = @InventoryID AND ISNULL(A23.IsUsed, 0) = 1 AND O00.UnitID = @UnitID
	)
	AND ISNULL(A23.IsUsed, 0) = 1
)B
LEFT JOIN AT0005 A05 ON A05.TypeID = B.StandardTypeID
WHERE A05.DivisionID = @DivisionID
AND ISNULL(A05.IsExtraFee, 0) = 0
AND A05.IsUsed = 1
ORDER BY A05.TypeID, B.StandardID																					

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
