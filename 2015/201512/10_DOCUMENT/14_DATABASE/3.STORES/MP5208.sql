/****** Object:  StoredProcedure [dbo].[MP5208]    Script Date: 12/16/2010 11:40:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----- Created BY Nguyen Van Nhan     Date: 26/12/2003 
---- Purpose: Phan bo chi phi Nhan cong theo dinh muc ket h¬p v¬i he so
-- Edit BY Quoc Hoai
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/    


ALTER PROCEDURE [dbo].[MP5208]
                 @DivisionID AS NVARCHAR(50), @PeriodID AS NVARCHAR(50), 
                @TranMonth AS INT, @TranYear AS INT, 
                @MaterialTypeID AS NVARCHAR(50), 
                @CoefficientID AS NVARCHAR(50) 
AS 

DECLARE @sSQL AS NVARCHAR(4000), 
    @SUMProductCovalues AS DECIMAL(28, 8), 
    @ListProduct_cur AS CURSOR, 
    @ListMaterial_cur AS CURSOR, 
    @ProductID AS NVARCHAR(50), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @ProductCovalues AS DECIMAL(28, 8), 
    @ProductHumanRes AS DECIMAL(28, 8), 
    @MaterialID AS NVARCHAR(50), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @ConvertedUnit AS DECIMAL(28, 8), 
    @UnitID AS INT, 
    @ConvertedDecimal AS DECIMAL(28, 8), 
    @ConvertedAmount1 AS DECIMAL(28, 8), 
    @Detal AS DECIMAL(28, 8)

SET @ConvertedDecimal = (SELECT ConvertDecimal FROM MT0000)

--- Buoc 1. Xac dinh he so phan bo dua vao NVL da phan bo
SET @sSQL ='    
SELECT MT0621.DivisionID, 
    MT0621.ProductID, 
    SUM(ConvertedUnit) AS ConvertedUnit, 
    MT2222.ProductQuantity, 
    MT2222.UnitID, 
    SUM(ConvertedUnit)*MT2222.ProductQuantity AS ProductCoValues
FROM MT0621 FULL JOIN MT2222 ON MT0621.DivisionID = MT2222.DivisionID AND MT0621.ProductID = MT2222.ProductID
WHERE ExpenseID = ''COST001''
    AND MT0621.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
GROUP BY MT0621.DivisionID, MT0621.ProductID, MT2222.UnitID, MT2222.ProductQuantity 
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5218' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5218 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5218 AS '+@sSQL)

SET @sSQL='
SELECT MV5218.DivisionID, 
    MV5218.ProductID, 
    MV5218.ProductQuantity, 
    MV5218.ProductCoValues * ISNULL(MT1605.CoValue, 1) AS ProductCoValues, --- He so phan bo
    MV5218.UnitID
FROM MV5218 LEFT JOIN MT1605 ON MT1605.DivisionID = MV5218.DivisionID 
    AND MT1605.InventoryID = MV5218.ProductID AND MT1605.CoefficientID =N'''+@CoefficientID+''' '

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5208' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5208 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5208 AS '+@sSQL)

--Duyet  tung mat hang
SET @ConvertedAmount =( SELECT SUM(CASE D_C WHEN 'D' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END)  
                        FROM MV9000 
                        WHERE PeriodID = @PeriodID AND ExpenseID = 'COST002' AND MaterialTypeID = @MaterialTypeID
                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

SET @SUMProductCovalues = (SELECT SUM(ISNULL(ProductCovalues, 0)) FROM MV5208)

SET @ListProduct_cur = CURSOR SCROLL KEYSET FOR 
SELECT ProductID, ProductQuantity, ProductCoValues
FROM MV5208        

OPEN @ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO @ProductID, @ProductQuantity, @ProductCoValues            
WHILE @@Fetch_Status = 0
BEGIN    
    IF ISNULL(@SUMProductCoValues, 0) <> 0 AND ISNULL(@ProductQuantity, 0) <> 0
        SET  @ProductHumanRes = ((ISNULL(@ConvertedAmount, 0)/@SUMProductCovalues)*ISNULL(@ProductCoValues, 0))/@ProductQuantity        
    ELSE SET @ProductHumanRes = 0 
    
    SET @ProductHumanRes = round(@ProductHumanRes, @ConvertedDecimal)
    
    IF ISNULL(@SUMProductCovalues, 0) <>0 
        SET @ConvertedAmount1 = round((ISNULL(@ConvertedAmount, 0)*ISNULL(@ProductCoValues, 0)/@SUMProductCovalues), @ConvertedDecimal)
    ELSE SET @ConvertedAmount1 = 0 

    INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
    VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST002', NULL, NULL, @MaterialTypeID, @ConvertedAmount1, @ProductHumanRes, @ProductQuantity, NULL)
    
    FETCH NEXT FROM @ListProduct_cur INTO @ProductID, @ProductQuantity, @ProductCoValues
END

CLOSE @ListProduct_cur
