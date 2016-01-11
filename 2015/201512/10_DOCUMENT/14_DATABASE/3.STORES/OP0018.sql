IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0018]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0018]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- In lich su bang gia
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 10/02/2012 by Le Thi Thu Hien
---- 
---- Modified on 10/02/2012 by 
-- <Example>
---- 
CREATE PROCEDURE OP0018
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),
	@ID AS NVARCHAR(50)
) 
AS 

DECLARE @InheritID AS NVARCHAR(50)

CREATE TABLE #TAM
	(
		InventoryName NVARCHAR(50),
		InventoryID NVARCHAR(50),
		ID  NVARCHAR(50),
		Description NVARCHAR(250),
		UnitPrice NVARCHAR(50),
		FromDate DATETIME,
		ToDate DATETIME,
		MinPrice DECIMAL(28,8),
		MaxPrice DECIMAL(28,8)
	)

SET @InheritID = @ID

LB_RESULT:
INSERT INTO #TAM

SELECT	AT1302.InventoryName, OT1302.InventoryID, OT1301.ID, OT1301.[Description], OT1302.UnitPrice , 
		OT1301.FromDate, OT1301.ToDate,
		OT1302.MinPrice, OT1302.MaxPrice
		
FROM	OT1301 
LEFT JOIN OT1302 ON OT1302.ID = OT1301.ID AND OT1302.DivisionID = OT1301.DivisionID
LEFT JOIN AT1302 ON AT1302.InventoryID = OT1302.InventoryID AND AT1302.DivisionID = OT1302.DivisionID

WHERE	ISNULL(OT1302.InventoryID,'') <> ''
		AND OT1301.ID = @InheritID 
		AND OT1301.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
		
ORDER BY OT1302.InventoryID,OT1301.FromDate

SET @InheritID = (SELECT TOP 1 InheritID FROM OT1301 WHERE OT1301.ID = @InheritID 
				AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
IF @InheritID <> ''
	GOTO LB_RESULT
	

SELECT * FROM #TAM
ORDER BY InventoryID, FromDate

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

