IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP01031]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP01031]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Grid Form CF0103 (Thêm sản phẩm cho đối tượng)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Nguyễn Thanh Sơn, Date: 23/12/2013
-- <Example>
---- 
/*
    EXEC AP01031 'SAS','','KH'
*/

CREATE PROCEDURE AP01031
( 
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@ObjectID VARCHAR(50)
) 

AS 

SELECT A02.InventoryID, A02.InventoryName, A02.InventoryTypeID, A02.UnitID, A04.UnitName
FROM AT1302 A02
LEFT JOIN AT1304 A04 ON A04.DivisionID = A02.DivisionID AND A04.UnitID = A02.UnitID
WHERE A02.DivisionID = @DivisionID
AND A02.InventoryID NOT IN 
(SELECT InventoryID FROM AT0104 
 WHERE A02.DivisionID = @DivisionID 
 AND ObjectID = @ObjectID)
ORDER BY A02.InventoryID 


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
