

/****** Object:  View [dbo].[AV1399]    Script Date: 12/16/2010 14:37:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Van Nhan. Date 04/10/2005
---- Purpose: Chi tiet danh muc don vi tinh chuyen doi. View Chet
-- Edit Thuy Tuyen, them thong tin DataType, Formular , date: 17/03/2009

-- Created by Nguyen Van Nhan. Date 04/10/2005
-- Purpose: Chi tiet danh muc don vi tinh chuyen doi. View Chet
-- Edit Thuy Tuyen, them thong tin DataType, Formular , date: 17/03/2009*/
ALTER VIEW [dbo].[AV1399]
AS
SELECT     dbo.AT1309.DivisionID, dbo.AT1309.InventoryID, dbo.AT1302.InventoryName, dbo.AT1302.UnitID, C.UnitName, dbo.AT1309.UnitID AS ConvertUnitID, 
                      C.UnitName AS ConvertUnitName, dbo.AT1309.Orders, 
                      CASE WHEN AT1309.Operator = 0 THEN ' 01 ' + C.UnitName + ' = ' + ltrim(rtrim(str(ConversionFactor))) 
                      + ' ' + B.UnitName ELSE '01 ' + B.UnitName + ' = ' + ltrim(rtrim(str(ConversionFactor))) + ' ' + C.UnitName END AS Example, dbo.AT1309.Disabled, 
                      dbo.AT1309.ConversionFactor, dbo.AT1309.Operator, CASE WHEN AT1309.DataType = 0 AND 
                      Operator = 0 THEN '0' ELSE CASE WHEN AT1309.DataType = 0 AND Operator = 1 THEN '1' ELSE '' END END AS OperatorName, 0 AS locked, 
                      CASE WHEN DataType = 0 THEN '0' ELSE '1' END AS DataType, dbo.AT1309.FormulaID, dbo.AT1319.FormulaName, dbo.AT1319.FormulaDes
                      ,AT1309.IsCommon
FROM         dbo.AT1309 INNER JOIN
                      dbo.AT1302 ON dbo.AT1302.InventoryID = dbo.AT1309.InventoryID and AT1309.DivisionID = AT1302.DivisionID
                      INNER JOIN dbo.AT1304 AS B ON B.UnitID = dbo.AT1302.UnitID  and AT1302.DivisionID = B.DivisionID
                      INNER JOIN dbo.AT1304 AS C ON C.UnitID = dbo.AT1309.UnitID  and AT1309.DivisionID = C.DivisionID
                      LEFT OUTER JOIN dbo.AT1319 ON dbo.AT1319.FormulaID = dbo.AT1309.FormulaID and AT1309.DivisionID = AT1319.DivisionID

GO


