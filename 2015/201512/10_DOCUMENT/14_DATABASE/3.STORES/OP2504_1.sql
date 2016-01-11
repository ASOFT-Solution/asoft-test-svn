IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP2504_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP2504_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Truy vấn nguyên vật liệu và bán thành phẩm tồn kho
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 26/02/2015
---- Modified on 
-- <Example>
/*
	 OP2504_1 'DNP', '', 'ES/01/2015/0002'
*/

CREATE PROCEDURE OP2504_1
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@EstimateID VARCHAR(50)
)				
AS
DECLARE @sSQL NVARCHAR(MAX),
		@sWhere NVARCHAR(1000) = ''
		
IF @EstimateID IS NOT NULL SET @sWhere = '
AND InventoryID IN (SELECT MaterialID FROM OT2203 WHERE EstimateID = '''+@EstimateID+''' AND ExpenseID = ''COST001'')'

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'OV2504_2' AND xtype = 'U')  DROP TABLE OV2504_2

SET @sSQL = '
SELECT  NEWID() APK, *, (SELECT TOP 1 ProductTypeID FROM AT1302 WHERE DivisionID = A.DivisionID AND InventoryID = A.InventoryID) ProductTypeID
	INTO OV2504_2
FROM
(
	SELECT ISNULL(V00.DivisionID, V01.DivisionID) DivisionID, ISNULL(V00.WareHouseID, V01.WareHouseID) WareHouseID,
		ISNULL(V01.InventoryID, V00.InventoryID) InventoryID,
		CASE WHEN ENDQuantity = 0 THEN NULL ELSE ENDQuantity END ENDQuantity,
		CASE WHEN SQuantity = 0 THEN NULL ELSE SQuantity END SQuantity,
		CASE WHEN PQuantity = 0 THEN NULL ELSE PQuantity END PQuantity,
		ISNULL(ENDQuantity, 0) - ISNULL(SQuantity, 0) + ISNULL(PQuantity, 0) ReadyQuantity,
		NULL MaxQuantity, NULL MinQuantity
	FROM
		(
			SELECT DivisionID, InventoryID, WareHouseID,
				SUM(CASE WHEN TypeID IN (''SO'',''ES'') AND Finish <> 1 THEN OrderQuantity - ActualQuantity ELSE 0 END) SQuantity,
				SUM(CASE WHEN TypeID = ''PO'' AND Finish <> 1 THEN OrderQuantity - ActualQuantity ELSE 0 END) PQuantity
			FROM OV2800
			WHERE DivisionID = '''+@DivisionID+'''
			GROUP BY DivisionID, InventoryID, WareHouseID
		) V00
		FULL JOIN  
		(
			SELECT TOP 100 PERCENT DivisionID, InventoryID, WareHouseID, SUM(ISNULL(DebitQuantity,0)) - SUM(ISNULL(CreditQuantity,0)) ENDQuantity
			FROM OV2401 
			WHERE DivisionID = '''+@DivisionID+''' 
			GROUP BY DivisionID, WareHouseID, InventoryID
			HAVING SUM(ISNULL(DebitQuantity,0)) - SUM(ISNULL(CreditQuantity, 0)) <> 0
			ORDER BY DivisionID, WareHouseID, InventoryID 
		) V01 ON V00.WareHouseID = V01.WareHouseID AND V00.InventoryID = V01.InventoryID AND V00.DivisionID = V01.DivisionID
	WHERE (ISNULL(ENDQuantity, 0) <> 0 OR ISNULL(SQuantity,0) <> 0 OR PQuantity <> 0)
		AND ISNULL(V00.DivisionID, V01.DivisionID) = '''+@DivisionID+'''
) A
WHERE 1 = 1 '+@sWhere+'
AND ISNULL((SELECT TOP 1 ProductTypeID FROM AT1302 WHERE DivisionID = A.DivisionID AND InventoryID = A.InventoryID), 1) IN (2,3)'

EXEC (@sSQL)
--PRINT (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
