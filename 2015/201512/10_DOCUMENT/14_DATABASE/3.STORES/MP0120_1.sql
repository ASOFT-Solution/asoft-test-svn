IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0120_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0120_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Grid kế hoạch chi tiết MF0120
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by:  on: 
---- Modified on 
-- <Example>
/*
	 MP0120_1 'PL', '', 'bee7f739-7a7f-4bb1-b2d4-a13c3e7f6d7b', 'IO/05/2015/0001', 1
*/

 CREATE PROCEDURE MP0120_1
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@PlanID VARCHAR(50),
	@IOrderID VARCHAR(50),
	@InherritType TINYINT
)
AS

IF EXISTS (SELECT TOP 1 1 FROM MT0120 WHERE DivisionID = @DivisionID AND PlanID = @PlanID)
BEGIN
	SELECT M20_1.*, A02.InventoryName, A04.UnitName,
	(CASE WHEN EXISTS (SELECT TOP 1 1 FROM MT0121 WHERE PlanDetailID = M20_1.PlanDetailID) THEN 1 ELSE 0 END) IsCommand
	FROM MT0120 M20_1
	LEFT JOIN AT1302 A02 ON A02.DivisionID = M20_1.DivisionID AND A02.InventoryID = M20_1.InventoryID
	LEFT JOIN AT1304 A04 ON A04.DivisionID = A02.DivisionID AND A04.UnitID = A02.UnitID
	WHERE M20_1.DivisionID = @DivisionID AND M20_1.PlanID = @PlanID
END
ELSE
BEGIN
IF @InherritType = 3 -- Kế thừa từ phiếu đối chiếu
BEGIN
	SELECT O38.APK, NEWID() PlanDetailID, O38.MaterialID InventoryID, A02.InventoryName, O38.MaterialQuantity PlanQuantity, A02.UnitID, A04.UnitName,
	(SELECT TOP 1 MOrderID FROM OT2202 WHERE DivisionID = @DivisionID AND EstimateID = O37.EstimateID) MOrderID, O38.[Level],
	 A02.ProductTypeID, 0 IsCommand, O38.ApportionID,
	 NULL Quantity01, NULL Quantity02, NULL Quantity03, NULL Quantity04, NULL Quantity05, NULL Quantity06, NULL Quantity07, NULL Quantity08, NULL Quantity09, NULL Quantity10,
	 NULL Quantity11, NULL Quantity12, NULL Quantity13, NULL Quantity14, NULL Quantity15, NULL Quantity16, NULL Quantity17, NULL Quantity18, NULL Quantity19, NULL Quantity20,
	 NULL Quantity21, NULL Quantity22, NULL Quantity23, NULL Quantity24, NULL Quantity25, NULL Quantity26, NULL Quantity27, NULL Quantity28, NULL Quantity29, NULL Quantity30,
	 NULL Quantity31, NULL Quantity32, NULL Quantity33, NULL Quantity34, NULL Quantity35, NULL Quantity36, NULL Quantity37, NULL Quantity38, NULL Quantity39, NULL Quantity40
	FROM OT0138 O38
	LEFT JOIN AT1302 A02 ON A02.DivisionID = O38.DivisionID AND A02.InventoryID = O38.MaterialID
	LEFT JOIN AT1304 A04 ON A04.DivisionID = A02.DivisionID AND A04.UnitID = A02.UnitID
	LEFT JOIN OT0137 O37 ON O37.DivisionID = O38.DivisionID AND O37.CompareID = O38.CompareID
	WHERE O37.DivisionID = @DivisionID
	AND (SELECT TOP 1 MOrderID FROM OT2202 WHERE DivisionID = @DivisionID AND EstimateID = O37.EstimateID) = @IOrderID
	ORDER BY O38.[Level] DESC
END

IF @InherritType = 2 -- Kế thừa từ phiếu dự trù
BEGIN
	SELECT O03.APK, NEWID() PlanDetailID, O03.MaterialID InventoryID, A02.InventoryName, O03.MaterialQuantity PlanQuantity, A02.UnitID, A04.UnitName,
	    (SELECT TOP 1 MOrderID FROM OT2202 WHERE DivisionID = @DivisionID AND EstimateID = O03.EstimateID) MOrderID, O03.[Level],
	    A02.ProductTypeID, 0 IsCommand, O03.ApportionID,
	    NULL Quantity01, NULL Quantity02, NULL Quantity03, NULL Quantity04, NULL Quantity05, NULL Quantity06, NULL Quantity07, NULL Quantity08, NULL Quantity09, NULL Quantity10,
		NULL Quantity11, NULL Quantity12, NULL Quantity13, NULL Quantity14, NULL Quantity15, NULL Quantity16, NULL Quantity17, NULL Quantity18, NULL Quantity19, NULL Quantity20,
		NULL Quantity21, NULL Quantity22, NULL Quantity23, NULL Quantity24, NULL Quantity25, NULL Quantity26, NULL Quantity27, NULL Quantity28, NULL Quantity29, NULL Quantity30,
		NULL Quantity31, NULL Quantity32, NULL Quantity33, NULL Quantity34, NULL Quantity35, NULL Quantity36, NULL Quantity37, NULL Quantity38, NULL Quantity39, NULL Quantity40
	FROM OT2203 O03
	LEFT JOIN AT1302 A02 ON A02.DivisionID = O03.DivisionID AND A02.InventoryID = O03.MaterialID
	LEFT JOIN AT1304 A04 ON A04.DivisionID = A02.DivisionID AND A04.UnitID = A02.UnitID
	WHERE O03.DivisionID = @DivisionID
	AND (SELECT TOP 1 MOrderID FROM OT2202 WHERE DivisionID = @DivisionID AND EstimateID = O03.EstimateID) = @IOrderID
	AND O03.ExpenseID = 'COST001'
	ORDER BY O03.[Level] DESC
END

	IF @InherritType = 1 -- Tính mới (không kế thừa từ nguồn nào hết)
	BEGIN
		DECLARE @Cur CURSOR, @ProductID VARCHAR(50), @ApportionID VARCHAR(50), @Quanity DECIMAL(28,8), @Level TINYINT,
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
		SELECT InventoryID, ApportionID, PlanQuantity FROM MT2002 WHERE DivisionID = @DivisionID AND PlanID = @PlanID
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
	
	---		 MP0120_1 'PL', '', 'GT/01/2015/001', 'IO/01/2015/0001',1
	
		SELECT NEWID() APK, NEWID() PlanDetailID, TAM.MaterialID InventoryID, A02.InventoryName, TAM.Quantity PlanQuantity, A02.UnitID, A04.UnitName, @IOrderID MOrderID, 
		TAM.[Level], TAM.ApportionID, 0 IsCommand,		
		NULL Quantity01, NULL Quantity02, NULL Quantity03, NULL Quantity04, NULL Quantity05, NULL Quantity06, NULL Quantity07, NULL Quantity08, NULL Quantity09, NULL Quantity10,
		NULL Quantity11, NULL Quantity12, NULL Quantity13, NULL Quantity14, NULL Quantity15, NULL Quantity16, NULL Quantity17, NULL Quantity18, NULL Quantity19, NULL Quantity20,
		NULL Quantity21, NULL Quantity22, NULL Quantity23, NULL Quantity24, NULL Quantity25, NULL Quantity26, NULL Quantity27, NULL Quantity28, NULL Quantity29, NULL Quantity30,
		NULL Quantity31, NULL Quantity32, NULL Quantity33, NULL Quantity34, NULL Quantity35, NULL Quantity36, NULL Quantity37, NULL Quantity38, NULL Quantity39, NULL Quantity40
		FROM #Tam TAM
			LEFT JOIN AT1302 A02 ON A02.DivisionID = @DivisionID AND A02.InventoryID = TAM.MaterialID
			LEFT JOIN AT1304 A04 ON A04.DivisionID = A02.DivisionID AND A04.UnitID = A02.UnitID
		WHERE TAM.MaterialType IN (2,3)
		ORDER BY TAM.[Level] DESC
	END 
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
