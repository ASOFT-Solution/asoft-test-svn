/****** Object:  StoredProcedure [dbo].[MP5703]    Script Date: 08/03/2010 10:34:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----- Created BY  Hoang Thi Lan
----- Created Date 07/11/2003.
----- Purpose: Phan bo chi phi SXC theo PP dinh muc
-- Edit BY Quoc Hoai
---Edited BY: VO THANH HUONG, date: 20/05/2005
---purpose: Xu ly lam tron 

/********************************************
'* Edited BY: [GS] [Việt Khánh] [03/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP5703]     
    @DivisionID NVARCHAR(50), 
    @PeriodID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @MaterialTypeID NVARCHAR(50), 
    @ApportionID NVARCHAR(50)
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @ListMaterial_cur CURSOR, 
    @SUMConvertedAmount DECIMAL(28, 8), 
    @MaterialID NVARCHAR(50), 
    @ConvertedAmount DECIMAL(28, 8), 
    @MaterialQuantity DECIMAL(28, 8), 
    @ProductConvertedUnit DECIMAL(28, 8), 
    @MaterialQuantityUnit DECIMAL(28, 8), 
    @SUMProductQuantity DECIMAL(28, 8), 
    @SUMProductConverted DECIMAL(28, 8), 
    @MaterialConvertedUnit DECIMAL(28, 8), 
    @ListProduct_cur CURSOR, 
    @ProductID NVARCHAR(50), 
    @ProductQuantity DECIMAL(28, 8), 
    @ProductQuantityUnit DECIMAL(28, 8), 
    @UnitID NVARCHAR(50), 
    @OtherQuantityUnit DECIMAL(28, 8), 
    @OtherConvertedUnit DECIMAL(28, 8), 
    @ConvertedUnit DECIMAL(28, 8), 
    @SUMProductCovalues DECIMAL(28, 8), 
    @QuantityUnit DECIMAL(28, 8), 
    @ConvertedDecimal TINYINT  --- Bien lam tron

SET @ConvertedDecimal = (SELECT ConvertDecimal FROM MT0000 where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

--tinh tong chi phi
 SET @SUMConvertedAmount = (SELECT SUM(CASE D_C WHEN 'D' THEN ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) 
                             FROM MV9000
                             WHERE ExpenseID = 'COST003' AND PeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID
                             
                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))) 
---- Xac dinh tong he so chung
SET @SUMProductConverted = (SELECT SUM(ISNULL(ConvertedUnit, 0)*ISNULL(MT2222.ProductQuantity, 0))
                            FROM MT1603 INNER JOIN MT2222 ON MT2222.DivisionID = MT1603.DivisionID AND MT2222.ProductID = MT1603.ProductID
                            WHERE ApportionID = @ApportionID 
                            AND ExpenseID = 'COST003' 
                            AND MaterialTypeID = @MaterialTypeID
                                AND MT1603.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

SET @ListMaterial_cur = CURSOR SCROLL KEYSET FOR 
SELECT MT1603.ProductID, ConvertedUnit*MT2222.ProductQuantity, MT2222.ProductQuantity, MT2222.UnitID    
FROM MT1603 INNER JOIN MT2222 ON MT2222.DivisionID = MT1603.DivisionID AND MT2222.ProductID = MT1603.ProductID
WHERE ApportionID = @ApportionID AND ExpenseID = 'COST003' AND MaterialTypeID = @MaterialTypeID    
    AND MT1603.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
    
OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO @ProductID, @ProductConvertedUnit, @ProductQuantity, @UnitID    
    WHILE @@Fetch_Status = 0
    BEGIN                
        IF ISNULL(@SUMProductConverted, 0)<>0 
             SET @MaterialConvertedUnit = ROUND((ISNULL(@SUMConvertedAmount, 0)/@SUMProductConverted)*ISNULL(@ProductConvertedUnit, 0), @ConvertedDecimal)
        ELSE SET @MaterialConvertedUnit = 0 
        
        IF ISNULL(@ProductQuantity, 0)<>0 
             SET @ConvertedUnit = ISNULL(@MaterialConvertedUnit, 0)/@ProductQuantity
        ELSE SET @ConvertedUnit = 0

        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate)
        VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST003', NULL, NULL, @MaterialTypeID, @MaterialConvertedUnit, @ConvertedUnit, @ProductQuantity, NULL)
    
        FETCH NEXT FROM @ListMaterial_cur INTO @ProductID, @ProductConvertedUnit, @ProductQuantity, @UnitID    
    END            
CLOSE @ListMaterial_cur

---- Xu ly lam tron

DECLARE @MaxProductID AS NVARCHAR(50), 
    @Detal DECIMAL(28, 8)

SET @Detal = ROUND(ISNULL(@SUMConvertedAmount, 0), @ConvertedDecimal) - ISNULL((SELECT SUM(ConvertedAmount) FROM MT0621 
                                                                                WHERE MaterialTypeID = @MaterialtypeID AND ExpenseID = 'COST003'
                                                                                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))), 0)
IF @Detal<>0 
    BEGIN
        --- Lam tron
    SET @MaxProductID = (SELECT TOP 1 ProductID FROM MT0621 
                        WHERE ExpenseID = 'COST003' AND MaterialTypeID = @MaterialTypeID
                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                        ORDER BY ConvertedAmount Desc)

        Update MT0621 SET ConvertedAmount = ConvertedAmount + @Detal
        WHERE ProductID = @MaxProductID AND MaterialTypeID = @MaterialTypeID AND ExpenseID = 'COST003'
            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
    END