
/****** Object: View [dbo].[OV3011] Script Date: 12/16/2010 15:15:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----NGUYEN THI THUY TUYEN
-----VIEW chet lay du lieu don vi tinh chuyen doi cho don hang mua.
------17/11/2006
-- Last edit : Thuy Tuyen , dat 19/03/2009 sua cach lay OperatorName
--- Edited by Bao Anh	Date: 31/07/2012
--- Purpose: Lay them truong FormulaID, FormulaDes, DataType, DataTypeName

ALTER VIEW [dbo].[OV3011]
AS 
SELECT 
AT1309.DivisionID,
AT1309.InventoryID,
AT1309.UnitID,
AT1304.UnitName,
AT1309.ConversionFactor,
AT1309.Operator,
CASE WHEN AT1309.DataType = 0 AND AT1309.Operator = 0 THEN N'WQ1309.MultiplyStr' 
     WHEN AT1309.DataType = 0 AND AT1309.Operator = 1 THEN N'WQ1309.Divide' 
     ELSE '' END AS OperatorName,
AT1309.FormulaID, AT1319.FormulaDes, AT1309.DataType,
CASE WHEN AT1309.DataType = 0 THEN 'WQ1309.Operators' 
     WHEN AT1309.DataType = 1 THEN 'WQ1309.Formula'
     ELSE '' END AS DataTypeName

FROM AT1309 
INNER JOIN AT1304 on AT1304.UnitID = AT1309.UnitID AND AT1304.DivisionID = AT1309.DivisionID
LEFT JOIN AT1319 on AT1309.FormulaID = AT1319.FormulaID AND AT1319.DivisionID = AT1309.DivisionID

WHERE AT1309.Disabled = 0 

UNION ALL

SELECT 
AT1302.DivisionID,
AT1302.InventoryID,
AT1302.UnitID,
AT1304.UnitName,
CAST(1 AS DECIMAL(28, 8)) AS ConversionFactor,
CAST(0 AS TINYINT) AS Operator, 
N'WQ1309.MultiplyStr' AS OperatorName,
CAST(null AS NVARCHAR(250)) AS FormulaID, 
CAST(null AS NVARCHAR(250)) AS FormulaDes, 
CAST(0 AS TINYINT) AS DataType, 
'WQ1309.Operators' AS DataTypeName
FROM AT1302 
INNER JOIN AT1304 on AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT1302.DivisionID

GO


