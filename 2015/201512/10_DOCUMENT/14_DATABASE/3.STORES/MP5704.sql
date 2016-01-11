/****** Object:  StoredProcedure [dbo].[MP5704]    Script Date: 12/16/2010 13:18:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan
--Date 10/11/2003
--Purpose: Phan bo chi phi SXC theo NVL 
-- Edit BY Quoc Hoai
---Edited BY: Vo Thanh Huong, date: 20/05/2005, Xu ly lam tron
--- Modify on 30/12/2013 by Bảo Anh: Sửa kiểu dữ liệu các biến truyền vào store từ nvarchar(20) thành nvarchar(50)

ALTER PROCEDURE [dbo].[MP5704]  @DivisionID AS VARCHAR(50), 
                 @PeriodID AS VARCHAR(50), 
                 @TranMonth AS INT, 
                 @TranYear AS INT, 
                 @MaterialTypeID AS VARCHAR(50)
AS 
DECLARE        @sSQL AS VARCHAR(8000), 
        @SumProductCovalues AS DECIMAL(28, 8), 
        @QuantityUnit AS DECIMAL(28, 8), 
        @ProductCoValues AS DECIMAL(28, 8), 
        @ConvertedUnit AS DECIMAL(28, 8), 
        @ListMaterial_cur AS CURSOR, 
        @SumConvertedAmount AS DECIMAL(28, 8), 
        @MaterialID AS VARCHAR(50), 
        @ConvertedAmount AS DECIMAL(28, 8), 
        @MaterialQuantity AS DECIMAL(28, 8), 
        @ProductConvertedUnit AS DECIMAL(28, 8), 
        @MaterialQuantityUnit AS DECIMAL(28, 8), 
        @SumProductQuantity AS DECIMAL(28, 8), 
        @SumProductConverted AS DECIMAL(28, 8), 
        @MaterialConvertedUnit AS DECIMAL(28, 8), 
        @ListProduct_cur AS CURSOR, 
        @ProductID AS VARCHAR(50), 
        @ProductQuantity AS DECIMAL(28, 8), 
        @ProductQuantityUnit AS DECIMAL(28, 8), 
        @UnitID AS VARCHAR(50), @ApportionID AS VARCHAR(50), 
        @SumConvertedAmountH AS DECIMAL(28, 8), 
        @CoefficientID AS VARCHAR(50), 
        @ProductOthers AS DECIMAL(28, 8), 
        @ConvertedDecimal AS tinyint  --- Bien lam tron
--Tao  ra VIEW so 1

SET @ConvertedDecimal = (Select ConvertDecimal FROM MT0000 where DivisionID = @DivisionID)
---- Tong chi phi

---- Buoc 1. Xac dinh he so phan bo dua vao NVL da phan bo
SET @sSQL ='
SELECT  MT0621.DivisionID, MT0621.ProductID, SUM(ConvertedUnit) AS ConvertedUnit, 
    MT2222.ProductQuantity, 
    MT2222.UnitID, 
    SUM(ConvertedUnit)*MT2222.ProductQuantity AS ProductCoValues
FROM MT0621 Full JOIN MT2222 ON MT0621.ProductID = MT2222.ProductID AND MT0621.DivisionID = MT2222.DivisionID
WHERE ExpenseID = ''COST001'' AND MT0621.DivisionID = ''' + @DivisionID + '''
GROUP BY MT0621.DivisionID, MT0621.ProductID, MT2222.UnitID, MT2222.ProductQuantity '

---- Tao VIEW he so chung can phan bo cho san pham
IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5704' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5704 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5704 AS '+@sSQL)

/*
--Tao  ra VIEW so 1

SET @sSQL='
SELECT     (Case  when MT1605.InventoryID is NULL then MT2222.ProductID 
        ELSE MT1605.InventoryID END) AS ProductID, 
    ISNULL(CoValue, 0) AS  CoValue, 
    ISNULL(ProductQuantity, 0) AS ProductQuantity, 
     CoValue*ProductQuantity AS ProductCoValues 
FROM MT1605  Full JOIN MT2222 ON MT2222.ProductID = MT1605.InventoryID
WHERE CoefficientID ='''+@CoefficientID+''' '

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV6704' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6704 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6704 AS '+@sSQL)

--Duyet  tung mat hang
*/

SET @ConvertedAmount=(SELECT SUM(Case D_C when 'D' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END)
						FROM MV9000 WHERE      DivisionID =@DivisionID AND PeriodID = @PeriodID AND
                                        ExpenseID ='COST003' AND    MaterialTypeID =@MaterialTypeID )


SET @SumProductCovalues = (SELECT SUM(ISNULL(ProductCovalues, 0)) FROM MV5704)

SET @ListProduct_cur = CURSOR SCROLL KEYSET FOR 
    SELECT     ProductID, ProductQuantity, ProductCoValues
    FROM MV5704        
OPEN    @ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues
            
WHILE @@Fetch_Status = 0
    BEGIN
        
        IF ISNULL(@SumProductCoValues, 0) <> 0 AND ISNULL(@ProductQuantity, 0) <> 0
            SET  @ProductOthers = ((ISNULL(@ConvertedAmount, 0)/@SumProductCovalues)*ISNULL(@ProductCoValues, 0))/@ProductQuantity        
        ELSE
            SET @ProductOthers= 0 
        IF @ProductOthers<>0
        IF ISNULL(@SumProductCovalues, 0) <>0 
                INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, 
                            ConvertedAmount, 
                         ConvertedUnit, 
                      ProductQuantity, Rate  )
                VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST003', NULL, NULL, @MaterialTypeID, 
                        round(((ISNULL(@ConvertedAmount, 0)/@SumProductCovalues)*ISNULL(@ProductCoValues, 0)), @ConvertedDecimal), 
                            @ProductOthers, 
                         @ProductQuantity, NULL)
                
        FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues
    END

CLOSE @ListProduct_cur

---- Xu ly lam tron

DECLARE @MaxProductID AS VARCHAR(20), 
    @Detal DECIMAL(28, 8)

SET @Detal = round(ISNULL(@ConvertedAmount, 0), @ConvertedDecimal) - ISNULL((SELECT SUM(ConvertedAmount) FROM MT0621 
                    WHERE  MaterialTypeID = @MaterialtypeID AND ExpenseID =  'COST003' ), 0)
IF @Detal<>0 
    BEGIN
        --- Lam tron
    SET @MaxProductID = (SELECT TOP 1 ProductID
        FROM MT0621 WHERE ExpenseID ='COST003' AND MaterialTypeID = @MaterialTypeID
        Order BY ConvertedAmount Desc)

        Update MT0621 SET ConvertedAmount = ConvertedAmount + @Detal
        WHERE     ProductID = @MaxProductID AND
            MaterialTypeID = @MaterialTypeID AND
            ExpenseID = 'COST003'
            
    
    END