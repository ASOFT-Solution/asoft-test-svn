IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP5702]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP5702]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



----- Created BY Nguyen Van Nhan AND Hoang Thi Lan     Date:5/11/2003 
---- Purpose: Phan bo chi phi SXC theo PP he so
-- Edit BY Quoc Hoai
---Created BY : VO THANH HUONG, date: 20/05/2005, Xu ly lam tron
--- Modify on 30/12/2013 by Bảo Anh: Sửa kiểu dữ liệu các biến truyền vào store từ nvarchar(20) thành nvarchar(50)
/********************************************
'* Edited BY: [GS] [Việt Khánh] [29/07/2010]
'********************************************/
----- Modify on 02/12/2015 by Phương Thảo: Customize KH Meiko - Phan bo tren tat ca cac mat hang chu ko di theo Doi tuong tap hop


CREATE PROCEDURE [dbo].[MP5702] 
    @DivisionID AS NVARCHAR(50), 
    @PeriodID AS NVARCHAR(50), 
    @TranMonth AS INT, @TranYear AS INT, 
    @MaterialTypeID AS NVARCHAR(50), 
    @CoefficientID AS NVARCHAR(50) 
AS 
DECLARE 
    @sSQL AS NVARCHAR(4000), 
    @SUMProductCovalues AS DECIMAL(28, 8), 
    @ListProduct_cur AS CURSOR, 
    @ProductID AS NVARCHAR(50), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @ProductCovalues AS DECIMAL(28, 8), 
    @ProductOthers AS DECIMAL(28, 8), 
    @MaterialID AS NVARCHAR(50), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @ConvertedUnit AS DECIMAL(28, 8), 
    @UnitID AS NVARCHAR(50), 
    @Detal AS DECIMAL(28, 8), 
    @ConvertedAmount1 AS DECIMAL(28, 8), 
    @ConvertedDecimal AS TINYINT,  --- Bien lam tron
	@CustomerName INT

CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)


--Tao  ra VIEW so 1

SET @ConvertedDecimal = (Select ConvertDecimal FROM MT0000 where DivisionID = @DivisionID)


SELECT 
    MT1605.DivisionID, 
    (CASE WHEN MT1605.InventoryID IS NULL THEN MT2222.ProductID ELSE MT1605.InventoryID END) AS ProductID, 
    ISNULL(CoValue, 0) AS CoValue, 
    ISNULL(ProductQuantity, 0) AS ProductQuantity, 
     CoValue*ProductQuantity AS ProductCoValues ,
	CoefficientID
INTO #MP5702
FROM MT1605 FULL JOIN MT2222 ON MT2222.DivisionID = MT1605.DivisionID AND MT2222.ProductID = MT1605.InventoryID
WHERE CoefficientID LIKE CASE WHEN @CustomerName = 50 THEN '%' ELSE Isnull(@CoefficientID,'') END AND
    MT1605.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))

	
--Duyet  tung mat hang
IF(@CustomerName = 50)
BEGIN
	SET @ConvertedAmount=(	SELECT SUM(CASE D_C WHEN 'D' THEN ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) 
							FROM MV9000 
							WHERE TranMonth = @TranMonth AND TranYear = @TranYear AND ExpenseID ='COST003' AND MaterialTypeID =@MaterialTypeID
								AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
END
ELSE
BEGIN
	SET @ConvertedAmount=(	SELECT SUM(CASE D_C WHEN 'D' THEN ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) 
							FROM MV9000 
							WHERE PeriodID = @PeriodID AND ExpenseID ='COST003' AND MaterialTypeID =@MaterialTypeID
								AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
END




SET @SUMProductCovalues = (SELECT SUM(ISNULL(ProductCovalues, 0)) FROM #MP5702)

SET @ListProduct_cur = CURSOR SCROLL KEYSET FOR 
    SELECT ProductID, ProductQuantity, ProductCoValues
    FROM #MP5702    
	WHERE CoefficientID = @CoefficientID     
OPEN @ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO @ProductID, @ProductQuantity, @ProductCoValues
            
WHILE @@Fetch_Status = 0
    BEGIN
        
        IF ISNULL(@SUMProductCoValues, 0) <> 0 AND ISNULL(@ProductQuantity, 0) <> 0            
            SET  @ProductOthers = ((ISNULL(@ConvertedAmount, 0)/@SUMProductCovalues)*ISNULL(@ProductCoValues, 0))/@ProductQuantity        
        ELSE
            SET @ProductOthers= 0 
    
        SET @ProductOthers = ROUND(@ProductOthers, @ConvertedDecimal)

        IF ISNULL(@SUMProductCovalues, 0) <>0 
            SET @ConvertedAmount1 = (ROUND((ISNULL(@ConvertedAmount, 0)*ISNULL(@ProductCoValues, 0)/@SUMProductCovalues), @ConvertedDecimal))
        ELSE 
            SET @ConvertedAmount1 = 0 
            
        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate)
        VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST003', NULL, NULL, @MaterialTypeID, @ConvertedAmount1, @ProductOthers, @ProductQuantity, NULL)
                
        FETCH NEXT FROM @ListProduct_cur INTO @ProductID, @ProductQuantity, @ProductCoValues
    END

CLOSE @ListProduct_cur

---- Xu ly lam tron

DECLARE @MaxProductID AS NVARCHAR(20)

SET @Detal = ROUND(ISNULL(@ConvertedAmount, 0), @ConvertedDecimal) - ISNULL((SELECT SUM(ConvertedAmount) 
                                                                            FROM MT0621 
                                                                            WHERE MaterialTypeID = @MaterialtypeID 
                                                                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                                                                AND ExpenseID = 'COST003'), 0)
IF @Detal <> 0 
    BEGIN
            --- Lam tron
        SET @MaxProductID = (SELECT TOP 1 ProductID
                                FROM MT0621 
                                WHERE ExpenseID ='COST003' AND MaterialTypeID = @MaterialTypeID
                                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                ORDER BY ConvertedAmount Desc)

        Update MT0621 SET ConvertedAmount = ConvertedAmount + @Detal
        WHERE ProductID = @MaxProductID 
            AND MaterialTypeID = @MaterialTypeID 
            AND ExpenseID = 'COST003'               
            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))    
    END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

