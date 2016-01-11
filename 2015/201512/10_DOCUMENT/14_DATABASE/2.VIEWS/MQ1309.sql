/****** Object: View [dbo].[MQ1309] Script Date: 12/14/2010 11:09:44 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

----NGUYEN THI THUY TUYEN
-----VIEW chet lay du lieu don vi tinh chuyen doi phan he ASOFT M.
------25/03/2006


ALTER VIEW [dbo].[MQ1309]
AS
SELECT 
AT1309.InventoryID, 
AT1309.DivisionID,
AT1302.UnitID, 
AT1309.UnitID AS ConvertedUnitID, 
AT1304.UnitName AS ConvertedUnitName, 
AT1309.ConversionFactor, 
AT1309.Operator, 
AT1309.FormulaID, 
AT1319.FormulaDes, 
CASE WHEN AT1309.DataType = 0 AND Operator = 0 THEN 'Multiplication'
ELSE CASE WHEN AT1309.DataType = 0 AND Operator = 1 THEN 'Division'
ELSE '' END END AS OperatorName, 	
DataType, 
CASE WHEN AT1309.DataType = 0 THEN 'Operator'
ELSE CASE WHEN AT1309.DataType = 1 THEN 'Formula'
END END AS DataTypeName
FROM AT1309 
INNER JOIN AT1304 ON AT1304.UnitID = AT1309.UnitID
LEFT JOIN AT1302 ON AT1302.InventoryID = AT1309.InventoryID
LEFT JOIN AT1319 ON AT1309.FormulaID = AT1319.FormulaID
WHERE AT1309.Disabled = 0 

UNION

SELECT 
AT1302.InventoryID, 
AT1302.DivisionID,
AT1302.UnitID, 
AT1302.UnitID AS ConvertedUnitID, 
UnitName AS ConvertedUnitName, 
1 AS ConversionFactor, 
0 AS Operator, 
NULL AS FormulaID, 
NULL AS FormulaDes, 
'Multiplication' AS OperatorName, 
NULL AS DataType, 
'Operator' AS DataTypeName
FROM AT1302 
INNER JOIN AT1304 ON AT1304.UnitID = AT1302.UnitID

GO


