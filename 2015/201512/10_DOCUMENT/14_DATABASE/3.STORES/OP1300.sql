IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP1300]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP1300]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Bảng giá phụ phí cho trường hợp new hoặc edit/view
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by:Thanh Sơn on: 27/04/2015
---- Modified on 
-- <Example>
/*
	OP1300 'HD', '', 'NBNoDiscount'
*/
CREATE PROCEDURE OP1300
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@PriceID VARCHAR(50)
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

SELECT B.StandardID, B.StandardName, B.StandardTypeID, A05.UserName StandardTypeName, UnitPrice FROM
( 
	SELECT O00.StandardID, Tam.StandardName, Tam.StandardTypeID, O00.UnitPrice
	FROM OT1300 O00
	LEFT JOIN #Tam Tam ON Tam.StandardID = O00.StandardID
	WHERE DivisionID = @DivisionID AND PriceID = @PriceID

	UNION ALL

	SELECT StandardID, StandardName, StandardTypeID, 0.00 UnitPrice
	FROM #Tam
	WHERE StandardID NOT IN
	(
		SELECT StandardID
		FROM OT1300
		WHERE DivisionID = @DivisionID AND PriceID = @PriceID
	)
)B
LEFT JOIN AT0005 A05 ON A05.TypeID = B.StandardTypeID
WHERE A05.DivisionID = @DivisionID
AND ISNULL(A05.IsExtraFee, 0) = 1
AND A05.IsUsed = 1
ORDER BY A05.TypeID, B.StandardID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
