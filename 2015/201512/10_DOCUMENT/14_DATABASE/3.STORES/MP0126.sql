IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0126]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0126]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Dự trù thời gian sản xuất cho đơn hàng bán
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 16/07/2015
---- Modified on 07/09/2015 by Bảo Anh: Lấy ProductName, bổ sung convert khi so sánh ngày đơn hàng và ngày hiệu lực của tiêu chuẩn giờ công
-- <Example>
/*
	MP0126 'DNP', '','EO/05/2015/0001', 'DM1'
*/
CREATE PROCEDURE MP0126
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@SOrderID VARCHAR(50),
	@ApportionID VARCHAR(50)
)
AS
DECLARE @Cur CURSOR, @ProductID VARCHAR(50), @Quanity DECIMAL(28,8),  @Level TINYINT,
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
	[Level] INT
)

SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT InventoryID, OrderQuantity FROM OT2002 WHERE DivisionID = @DivisionID AND SOrderID = @SOrderID

OPEN @Cur
FETCH NEXT FROM @Cur INTO @ProductID, @Quanity
WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM #Tam WHERE ProductID = @ProductID AND ApportionID = @ApportionID)
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM MT1603 WHERE ProductID = @ProductID AND ApportionID = @ApportionID AND ExpenseID = 'COST001')
		BEGIN
			INSERT INTO #Tam (ProductID, ApportionID, MaterialType, MaterialID, Quantity, UnitPrice, QuantityUnit, PhaseID, [Level])
			VALUES (@ProductID, @ApportionID, 1, @ProductID, @Quanity, 0, 1, NULL, 0)
			
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

	IF @IsStop = 0 --AND @Level < 4
	BEGIN
		SET @Level = @Level + 1
		SET @IsStop = 1
		GOTO ReturnCur2
	END

	FETCH NEXT FROM @Cur INTO @ProductID, @Quanity
END
CLOSE @Cur

SELECT TAM.ProductID, A03.InventoryName as ProductName, TAM.MaterialID InventoryID, A02.InventoryName, TAM.Quantity, M63.PhaseID, A26.PhaseName,
	CASE WHEN ISNULL(M25.QtyCriteria1h, 0) = 0 THEN 0 ELSE TAM.Quantity/ISNULL(M25.QtyCriteria1h, 0) END QtyCriteria1h,
	CASE WHEN ISNULL(M25.QtyCriteria8h, 0) = 0 THEN 0 ELSE TAM.Quantity/ISNULL(M25.QtyCriteria8h, 0) * 8 END QtyCriteria8h,
	CASE WHEN ISNULL(M25.QtyCriteria12h, 0) = 0 THEN 0 ELSE TAM.Quantity/ISNULL(M25.QtyCriteria12h, 0) * 12 END QtyCriteria12h
FROM #Tam TAM
LEFT JOIN MT1603 M63 ON M63.ApportionID = TAM.ApportionID AND M63.ProductID = TAM.MaterialID
LEFT JOIN MT0125 M25 ON M25.DivisionID = M63.DivisionID AND M25.PhaseID = M63.PhaseID
LEFT JOIN AT0126 A26 ON A26.DivisionID = M25.DivisionID AND A26.PhaseID = M25.PhaseID
LEFT JOIN AT1302 A02 ON A02.InventoryID = TAM.MaterialID
LEFT JOIN AT1302 A03 ON A03.InventoryID = TAM.ProductID
WHERE A02.DivisionID = @DivisionID
AND A02.ProductTypeID IN (1,2)
AND M25.CriteriaID =
(	
	SELECT TOP 1 CriteriaID
    FROM MT0124 
	WHERE (SELECT convert(nvarchar(20),OrderDate,112) FROM OT2001 WHERE DivisionID = @DivisionID AND SOrderID = @SOrderID)
			BETWEEN convert(nvarchar(20),BeginDate,112) AND convert(nvarchar(20),EndDate,112)
)
ORDER BY TAM.ProductID, TAM.MaterialID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON