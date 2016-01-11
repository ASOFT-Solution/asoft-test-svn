IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP01041]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP01041]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Grid Form CF0102 (Danh mục sản phẩm của đối tượng)
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
    EXEC AP0102 'SAS','','KH'
*/

CREATE PROCEDURE AP01041
( 
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@ObjectID VARCHAR(50)
)  
AS 
SELECT A02.InventoryID, A02.SalePrice, A02.BuyPrice, A02.Commission, A04.UnitName,
A302.InventoryName, A302.InventoryTypeID, A01.InventoryTypeName, A302.UnitID
FROM AT0104 A02
LEFT JOIN AT1302 A302 ON A302.DivisionID = A02.DivisionID AND A302.InventoryID = A02.InventoryID
LEFT JOIN AT1304 A04 ON A04.DivisionID = A302.DivisionID AND A04.UnitID = A302.UnitID
LEFT JOIN AT1301 A01 ON A01.DivisionID = A302.DivisionID AND A01.InventoryTypeID = A302.InventoryTypeID
WHERE A02.DivisionID = @DivisionID
AND A02.ObjectID =  @ObjectID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
