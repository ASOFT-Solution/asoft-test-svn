IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP2202_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP2202_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Tính dự trù nguyên vật liệu (viết lại khi một thành phẩm có nhiều công đoạn sản xuất)
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 11/02/2015
---- Modified on 
-- <Example>
/*
	 OP2202_1 'PL', 'ASOFTADMIN', 1, 'ES/01/2015/0002'
*/

 CREATE PROCEDURE OP2202_1
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50) = NULL,
	@ApportionType INT, --0 - Dinh muc nguyen vat lieu Asoft-M, 1- Dinh muc ton kho Asoft-T, 2- Khong su dung dinh muc
	@EstimateID NVARCHAR(50)

)
AS
DECLARE @Cur CURSOR, @ProductID VARCHAR(50), @ApportionID VARCHAR(50), @Quanity DECIMAL(28,8),  @Level TINYINT,
		@IsStop TINYINT, @Cur2 CURSOR, @MaterialID VARCHAR(50), @MaterialQuantity DECIMAL(28,8)
		
CREATE TABLE #Tam
(
	ProductID VARCHAR(50),
	ApportionID VARCHAR(50),
	MaterialType TINYINT,
	MaterialID VARCHAR(50),
	Quantity DECIMAL(28,8),
	UnitPrice DECIMAL(28,8),
	QuantityUnit DECIMAL(28,8),
	ConvertedUnit DECIMAL(28,8),
	PhaseID VARCHAR(50),
	[Level] TINYINT
)

SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT ProductID, ApportionID, ProductQuantity FROM OT2202 WHERE DivisionID = @DivisionID AND EstimateID = @EstimateID

OPEN @Cur
FETCH NEXT FROM @Cur INTO @ProductID, @ApportionID, @Quanity
WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM #Tam WHERE ProductID = @ProductID AND ApportionID = @ApportionID)
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM MT1603 WHERE ProductID = @ProductID AND ApportionID = @ApportionID AND ExpenseID = 'COST001')
		BEGIN
			INSERT INTO #Tam (ProductID, ApportionID, MaterialType, MaterialID, Quantity, UnitPrice, QuantityUnit, PhaseID, [Level])
			VALUES (@ProductID, @ApportionID, 1, @ProductID, @Quanity, 0,1,NULL,0)
			
			INSERT INTO #Tam (ProductID, ApportionID, MaterialType, MaterialID, Quantity, UnitPrice, QuantityUnit, ConvertedUnit, PhaseID, [Level])		
			SELECT @ProductID, @ApportionID, (SELECT TOP 1 ProductTypeID FROM AT1302 WHERE DivisionID = @DivisionID AND InventoryID = MT1603.MaterialID),
				MaterialID, MaterialQuantity * @Quanity / ISNULL(ProductQuantity,1), MaterialPrice, QuantityUnit, ConvertedUnit, PhaseID, 1
			FROM MT1603 WHERE ProductID = @ProductID AND ApportionID = @ApportionID AND ExpenseID = 'COST001'
		END		
	END
	
	SET @Level = 1
	SET @IsStop = 1
	
	ReturnCur2:
	SET @Cur2 = CURSOR SCROLL KEYSET FOR
	SELECT MaterialID, Quantity, [Level] FROM #Tam WHERE ProductID = @ProductID AND ApportionID = @ApportionID AND MaterialType = 2 AND [Level] = @Level
	
	OPEN @Cur2
	FETCH NEXT FROM @Cur2 INTO @MaterialID, @MaterialQuantity, @Level
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM MT1603 WHERE ProductID = @MaterialID AND ApportionID = @ApportionID AND ExpenseID = 'COST001')
		BEGIN			
			INSERT INTO #Tam (ProductID, ApportionID, MaterialType, MaterialID, Quantity, UnitPrice, QuantityUnit, ConvertedUnit, PhaseID, [Level])		
			SELECT @ProductID, @ApportionID, (SELECT TOP 1 ProductTypeID FROM AT1302 WHERE DivisionID = @DivisionID AND InventoryID = MT1603.MaterialID),
				MaterialID, MaterialQuantity * @MaterialQuantity / ISNULL(ProductQuantity,1), MaterialPrice, QuantityUnit, ConvertedUnit, PhaseID, @Level + 1
			FROM MT1603 WHERE ProductID = @MaterialID AND ApportionID = @ApportionID AND ExpenseID = 'COST001'			
			SET @IsStop = 0
		END		
		FETCH NEXT FROM @Cur2 INTO @MaterialID, @MaterialQuantity, @Level
	END
	CLOSE @Cur2
	IF @IsStop = 0
	BEGIN
		SET @Level = @Level + 1
		SET @IsStop = 1
		GOTO ReturnCur2
	END
	FETCH NEXT FROM @Cur INTO @ProductID, @ApportionID, @Quanity
END
CLOSE @Cur

-- Dataset cho lưới BTP/NVL trực tiếp
SELECT A.*, A26.PhaseName FROM 
(
	SELECT O02.DivisionID, O02.EstimateID, O02.EDetailID, O01.TranMonth, O01.TranYear, O01.ObjectID, A202.ObjectName, O01.PeriodID, TAM.MaterialID,
		A01.InventoryName MaterialName, A01.UnitID, '' MDescripton, TAM.ProductID,
		(SELECT TOP 1 Quantity FROM #Tam WHERE ProductID = TAM.ProductID AND ApportionID = TAM.ApportionID) ProductQuantity,
		TAM.Quantity MaterialQuantity, TAM.UnitPrice * TAM.Quantity ConvertedAmount, TAM.ConvertedUnit, TAM.QuantityUnit, TAM.UnitPrice MaterialPrice,	
		'COST001' ExpenseID, TAM.MaterialType MaterialTypeID, NULL MaterialTypeName, O01.WareHouseID, 0 IsPicking, O02.Orders POrders, O01.OrderStatus, TAM.[Level], TAM.ApportionID,
		(SELECT TOP 1 PhaseID FROM MT1603 WHERE DivisionID = @DivisionID AND ProductID = TAM.MaterialID) PhaseID, A02.InventoryName ProductName
	FROM #Tam TAM
	LEFT JOIN OT2202 O02 ON O02.DivisionID = @DivisionID AND O02.EstimateID = @EstimateID AND O02.ApportionID = TAM.ApportionID AND O02.ProductID = TAM.ProductID
	LEFT JOIN OT2201 O01 ON O01.DivisionID = O02.DivisionID AND O01.EstimateID = O02.EstimateID
	LEFT JOIN AT1202 A202 ON A202.DivisionID = O01.DivisionID  AND A202.ObjectID = O01.ObjectID
	LEFT JOIN AT0126 A26 ON A26.DivisionID = @DivisionID AND A26.PhaseID = TAM.PhaseID
	LEFT JOIN AT1302 A02 ON A02.DivisionID = @DivisionID AND A02.InventoryID = TAM.ProductID
	LEFT JOIN AT1302 A01 ON A02.DivisionID = @DivisionID AND A01.InventoryID = TAM.MaterialID
	LEFT JOIN AT1304 A04 ON A04.DivisionID = A01.DivisionID AND A04.UnitID = A01.UnitID
	WHERE TAM.MaterialType IN (2,3)
)A
LEFT JOIN AT0126 A26 ON A26.DivisionID = A.DivisionID AND A26.PhaseID = A.PhaseID
ORDER BY ProductID, [Level]

-- Dataset cho lưới chi phí nhân công trực tiếp
SELECT O02.DivisionID, O02.EstimateID, O02.EDetailID, O01.TranMonth, O01.TranYear, O01.ObjectID, A202.ObjectName, O01.PeriodID,
	NULL MaterialName, NULL UnitID, '' MDescripton, TAM.ProductID,
	(SELECT TOP 1 Quantity FROM #Tam WHERE ProductID = TAM.ProductID AND ApportionID = TAM.ApportionID) ProductQuantity,
	TAM.Quantity MaterialQuantity, M63.ConvertedUnit * TAM.Quantity ConvertedAmount, M63.ConvertedUnit, TAM.QuantityUnit, 0 MaterialPrice,	
	'COST002' ExpenseID, M63.MaterialTypeID, M99.UserName MaterialTypeName, O01.WareHouseID, 0 IsPicking, O02.Orders POrders, O01.OrderStatus,
	A02.InventoryName ProductName
FROM #Tam TAM

LEFT JOIN 
(
	SELECT DivisionID, ApportionID, ProductID, PhaseID, ISNULL(MT1603.MaterialAmount, 0) MaterialAmount, ConvertedUnit, [Description], MaterialTypeID
	FROM MT1603 WHERE DivisionID = @DivisionID AND ExpenseID = 'COST002'
)  M63 ON M63.DivisionID = @DivisionID AND M63.ApportionID = TAM.ApportionID AND M63.ProductID = TAM.MaterialID
LEFT JOIN MT0699 M99 ON M99.MaterialTypeID = M63.MaterialTypeID AND M99.DivisionID = M63.DivisionID
LEFT JOIN OT2202 O02 ON O02.DivisionID = @DivisionID AND O02.EstimateID = @EstimateID AND O02.ApportionID = TAM.ApportionID AND O02.ProductID = TAM.ProductID
LEFT JOIN OT2201 O01 ON O01.DivisionID = O02.DivisionID AND O01.EstimateID = O02.EstimateID
LEFT JOIN AT1202 A202 ON A202.DivisionID = O01.DivisionID  AND A202.ObjectID = O01.ObjectID
LEFT JOIN AT1302 A02 ON A02.DivisionID = @DivisionID AND A02.InventoryID = TAM.ProductID
LEFT JOIN AT0126 A26 ON A26.DivisionID = @DivisionID AND A26.PhaseID = M63.PhaseID
WHERE TAM.MaterialType IN (1,2)
ORDER BY ProductID, [Level]

-- OP2202_1 'PL', 'ASOFTADMIN', 1, 'DC/01/2015/0002'

-- Dataset cho lưới chi phí sản xuất chung
SELECT O02.DivisionID, O02.EstimateID, O02.EDetailID, O01.TranMonth, O01.TranYear, O01.ObjectID, A202.ObjectName, O01.PeriodID,
	NULL MaterialName, NULL UnitID, '' MDescripton, TAM.ProductID,
	(SELECT TOP 1 Quantity FROM #Tam WHERE ProductID = TAM.ProductID AND ApportionID = TAM.ApportionID) ProductQuantity,
	TAM.Quantity MaterialQuantity, M63.ConvertedUnit * TAM.Quantity ConvertedAmount, M63.ConvertedUnit, TAM.QuantityUnit, 0 MaterialPrice,	
	'COST003' ExpenseID, M63.MaterialTypeID, M99.UserName MaterialTypeName, O01.WareHouseID, 0 IsPicking, O02.Orders POrders, O01.OrderStatus,
	A02.InventoryName ProductName
FROM #Tam TAM
LEFT JOIN 
(
	SELECT DivisionID, ApportionID, ProductID, PhaseID, ISNULL(MT1603.MaterialAmount, 0) MaterialAmount, ConvertedUnit, [Description], MaterialTypeID
	FROM MT1603 WHERE DivisionID = @DivisionID AND ExpenseID = 'COST003'
)  M63 ON M63.DivisionID = @DivisionID AND M63.ApportionID = TAM.ApportionID AND M63.ProductID = TAM.MaterialID
LEFT JOIN MT0699 M99 ON M99.MaterialTypeID = M63.MaterialTypeID AND M99.DivisionID = M63.DivisionID
LEFT JOIN OT2202 O02 ON O02.DivisionID = @DivisionID AND O02.EstimateID = @EstimateID AND O02.ApportionID = TAM.ApportionID AND O02.ProductID = TAM.ProductID
LEFT JOIN OT2201 O01 ON O01.DivisionID = O02.DivisionID AND O01.EstimateID = O02.EstimateID
LEFT JOIN AT1202 A202 ON A202.DivisionID = O01.DivisionID  AND A202.ObjectID = O01.ObjectID
LEFT JOIN AT1302 A02 ON A02.DivisionID = @DivisionID AND A02.InventoryID = TAM.ProductID
LEFT JOIN AT0126 A26 ON A26.DivisionID = @DivisionID AND A26.PhaseID = M63.PhaseID
WHERE TAM.MaterialType IN (1,2)
ORDER BY ProductID, [Level]

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
