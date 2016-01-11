/****** Object:  StoredProcedure [dbo].[MP5708]    Script Date: 12/16/2010 13:23:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----- Created BY Nguyen Van Nhan     Date: 26/12/2003 
---- Purpose: Phan bo chi phi sxc theo dinh muc ket h¬p v¬i he so
-- Edit BY Quoc Hoai
--- Modify on 30/12/2013 by Bảo Anh: Sửa kiểu dữ liệu các biến truyền vào store từ nvarchar(20) thành nvarchar(50)
/********************************************
'* Edited BY: [GS] [Viet Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP5708]
    @DivisionID AS NVARCHAR(50), 
    @PeriodID AS NVARCHAR(50), 
    @TranMonth AS INT, 
    @TranYear AS INT, 
    @MaterialTypeID AS NVARCHAR(50), 
    @CoefficientID AS NVARCHAR(50) 
AS 

DECLARE 
    @sSQL AS NVARCHAR(4000), 
    @SumProductCovalues AS DECIMAL(28, 8), 
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
    @UnitID AS NVARCHAR(50), 
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
FROM MT0621 FULL JOIN MT2222 ON MT0621.ProductID = MT2222.ProductID AND MT0621.DivisionID = MT2222.DivisionID
WHERE ExpenseID = ''COST001'' AND MT0621.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
GROUP BY  MT0621.DivisionID, MT0621.ProductID, MT2222.UnitID, MT2222.ProductQuantity, MT0621.DivisionID '

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5718' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5718 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5718 AS '+@sSQL)

SET @sSQL='
SELECT MV5718.DivisionID, 
    MV5718.ProductID, 
    MV5718.ProductQuantity, 
    MV5718.ProductCoValues*ISNULL(MT1605.CoValue, 1) AS ProductCoValues, --- He so phan bo
    MV5718.UnitID
FROM MV5718 LEFT JOIN MT1605 ON MT1605.DivisionID = MV5718.DivisionID 
    AND MT1605.InventoryID = MV5718.ProductID 
    AND MT1605.CoefficientID ='''+@CoefficientID+''' '
IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5708' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5708 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5708 AS '+@sSQL)


--Duyet  tung mat hang
SET @ConvertedAmount =(SELECT SUM(CASE D_C WHEN 'D' THEN ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) FROM MV9000 WHERE DivisionID =@DivisionID AND PeriodID = @PeriodID AND
                                        ExpenseID ='COST003' AND MaterialTypeID =@MaterialTypeID)

SET @SumProductCovalues = (SELECT SUM(ISNULL(ProductCovalues, 0)) FROM MV5708)

SET @ListProduct_cur = CURSOR SCROLL KEYSET FOR 
    SELECT ProductID, ProductQuantity, ProductCoValues
    FROM MV5708        
OPEN @ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO @ProductID, @ProductQuantity, @ProductCoValues
            
WHILE @@Fetch_Status = 0
    BEGIN
        
        IF ISNULL(@SumProductCoValues, 0) <> 0 AND ISNULL(@ProductQuantity, 0) <> 0
            SET @ProductHumanRes = ((ISNULL(@ConvertedAmount, 0)/@SumProductCovalues)*ISNULL(@ProductCoValues, 0))/@ProductQuantity        
        ELSE
            SET @ProductHumanRes = 0 
        SET @ProductHumanRes = ROUND(@ProductHumanRes, @ConvertedDecimal)
    

        IF ISNULL(@SumProductCovalues, 0) <>0 

            SET @ConvertedAmount1 = ROUND((ISNULL(@ConvertedAmount, 0)*ISNULL(@ProductCoValues, 0)/@SumProductCovalues), @ConvertedDecimal)
        ELSE 
            SET @ConvertedAmount1 = 0 

        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, 
                    ConvertedAmount, ConvertedUnit, ProductQuantity, Rate)
        VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST003', NULL, NULL, @MaterialTypeID, @ConvertedAmount1, 
                        @ProductHumanRes, @ProductQuantity, NULL)
    
        FETCH NEXT FROM @ListProduct_cur INTO @ProductID, @ProductQuantity, @ProductCoValues
    END

CLOSE @ListProduct_cur
