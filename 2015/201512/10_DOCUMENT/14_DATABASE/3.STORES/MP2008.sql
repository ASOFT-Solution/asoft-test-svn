IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP2008]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP2008]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Hoàng Vũ	Date: 12/02/2015
--- Purpose: Load detail Phiếu giao việc
--- EXEC MP2008 'AS','5c6516f1-07d2-4d4b-99c7-a1b606a648ac'

CREATE PROCEDURE [dbo].[MP2008] 
(
	@DivisionID nvarchar(50),
	@VoucherID nvarchar(50)
)
AS
		
IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#TAM')) 
	DROP TABLE #TAM
	
SELECT	AT1309.DivisionID,
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
INTO #TAM
FROM AT1309 
			INNER JOIN AT1304 on AT1304.UnitID = AT1309.UnitID AND AT1304.DivisionID = AT1309.DivisionID
			LEFT JOIN AT1319 on AT1309.FormulaID = AT1319.FormulaID AND AT1319.DivisionID = AT1309.DivisionID
WHERE AT1309.DivisionID = @DivisionID And AT1309.Disabled = 0 

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
WHERE AT1302.DivisionID = @DivisionID
		
--- Trả ra dữ liệu
SELECT * FROM (
SELECT	distinct
		MT2008.APK,
		MT2008.DivisionID,
		MT2008.TransactionID,
		MT2008.VoucherID,
		MT2008.IsPicking, 
		MT2008.WareHouseID, 
		AT1303.WareHouseName,  
		AT1302.IsStocked,
		MT2008.RInventoryTypeID, 
		MT2008.RInventoryID, 
		MT2008.InventoryID, 
		case when ISNULL(MT2008.InventoryCommonName, '') = '' then AT1302.InventoryName else MT2008.InventoryCommonName end AS InventoryName, 	
		ISNULL(MT2008.UnitID,AT1302.UnitID) AS  UnitID,
		ISNULL(T04.UnitName,AT1304.UnitName) AS  UnitName,
		MT2008.ExtraID, --Ma phu
		AT1311.ExtraName, --Ten ma phu
		MT2008.Quantity, 
		MT2008.ConvertedQuantity, 
		(SELECT Quantity FROM MT2008 T02 Where T02.TransactionID = MT2008.TransactionID AND T02.DivisionID=MT2008.DivisionID)
		- (ISNULL((SELECT Sum(Quantity) FROM MT2008 T02 Where T02.InheritTransactionID = MT2008.TransactionID AND T02.DivisionID=MT2008.DivisionID),0))
		AS RemainQuantity,
		MT2008.Orders, 
		P.VoucherNo as ReVoucherNo,
		MT2008.Description, 
		MT2008.Ana01ID, MT2008.Ana02ID, MT2008.Ana03ID, MT2008.Ana04ID, MT2008.Ana05ID, MT2008.Ana06ID, 
		MT2008.Ana07ID, MT2008.Ana08ID, MT2008.Ana09ID, MT2008.Ana10ID,
		MT2008.Notes01,MT2008.Notes02,MT2008.Notes03,
		MT2008.nvarchar01, MT2008.nvarchar02, MT2008.nvarchar03, MT2008.nvarchar04, MT2008.nvarchar05,
		MT2008.nvarchar06, MT2008.nvarchar07, MT2008.nvarchar08, MT2008.nvarchar09, MT2008.nvarchar10,
		TAM.ConversionFactor, TAM.Operator, TAM.OperatorName, TAM.FormulaID, TAM.FormulaDes,
		TAM.DataType, TAM.DataTypeName,
		MT2008.InheritTableID,
		MT2008.InheritVoucherID, MT2008.InheritTransactionID, MT2008.Parameter01, MT2008.Parameter02, 
		MT2008.Parameter03, MT2008.Parameter04, MT2008.Parameter05
FROM MT2008 
--LEFT JOIN AT1011 ON AT1011.DivisionID = MT2008.DivisionID and AT1011.InventoryID = MT2008.InventoryID and AT1011.AnaID = MT2008.ExtraID
LEFT JOIN AT1311 ON AT1311.DivisionID = MT2008.DivisionID and AT1311.ExtraID = MT2008.ExtraID
LEFT JOIN AT1302 ON MT2008.DivisionID = AT1302.DivisionID AND AT1302.InventoryID= MT2008.InventoryID 	
LEFT JOIN AT1303 ON AT1303.DivisionID = MT2008.DivisionID AND AT1303.WareHouseID = MT2008.WareHouseID
LEFT JOIN AT1304 ON MT2008.DivisionID = AT1302.DivisionID AND AT1304.UnitID = AT1302.UnitID
LEFT JOIN AT1304  T04 ON MT2008.DivisionID = T04.DivisionID	AND T04.UnitID = MT2008.UnitID
LEFT JOIN #TAM TAM ON TAM.DivisionID = MT2008.DivisionID AND TAM.InventoryID = MT2008.InventoryID AND TAM.UnitID = MT2008.UnitID
LEFT JOIN 
		(Select MT.DivisionID, MT.SOrderID, MT.VoucherNo, DT.TransactionID
		 From OT2001 MT inner join OT2002 DT on MT.DivisionID = DT.DivisionID and MT.SOrderID = DT.SOrderID
		 Where OrderType = 1
		) P on P.DivisionID = MT2008.DivisionID and P.SOrderID = MT2008.InheritVoucherID and P.TransactionID = MT2008.InheritTransactionID

WHERE	MT2008.DivisionID = @DivisionID And MT2008.VoucherID = @VoucherID) A ORDER BY Orders	

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON