/****** Object:  StoredProcedure [dbo].[MP5706]    Script Date: 12/16/2010 13:20:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----- Created BY  Hoang Thi Lan     Date: 010/12/2003 
---- Purpose: Phan bo chi phi SXC theo PP truc tiep ket hop he so
-- Edit BY Quoc Hoai
--- Modify on 30/12/2013 by Bảo Anh: Sửa kiểu dữ liệu các biến truyền vào store từ nvarchar(20) thành nvarchar(50)

ALTER PROCEDURE [dbo].[MP5706] 
                 @DivisionID AS VARCHAR(50), @PeriodID AS VARCHAR(50), 
                @TranMonth AS INT, @TranYear AS INT, 
                @MaterialTypeID AS VARCHAR(50), 
                @CoefficientID AS VARCHAR(50) 
AS 

DECLARE @sSQL AS VARCHAR(8000), 
    @SumProductCovalues AS DECIMAL(28, 8), 
    @ListProduct_cur AS CURSOR, 
    @ListMaterial_cur AS CURSOR, 
    @ProductID AS VARCHAR(50), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @ProductCovalues AS DECIMAL(28, 8), 
    @ProductHumanRes AS DECIMAL(28, 8), 
    @MaterialID AS VARCHAR(50), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @ConvertedUnit     AS DECIMAL(28, 8), 
    @UnitID AS VARCHAR(50), 
    @ConvertedDecimal AS DECIMAL(28, 8), 
    @ConvertedAmount1 AS DECIMAL(28, 8), 
    @Detal AS DECIMAL(28, 8), 
    @ProductOthers AS DECIMAL(28, 8)


SET @ConvertedDecimal = (SELECT ConvertDecimal FROM MT0000)

---Trùc tiÕp---
SET NOCOUNT ON
SET @sSQL='
SELECT DivisionID, 
    SUM( Case D_C  when  ''D'' then ISNULL(Quantity, 0) ELSE - ISNULL(Quantity, 0) END) AS MaterialQuantity, 
    SUM(Case D_C when ''D'' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
    ProductID
FROM MV9000 
WHERE DivisionID ='''+@DivisionID+''' AND
    PeriodID = '''+@PeriodID+''' AND
    ExpenseID =''COST003'' AND
    ISNULL(ProductID, '''')<>''''  AND 
    MaterialTypeID ='''+@MaterialTypeID+''' 
GROUP BY  DivisionID, ProductID  '

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5701' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5701 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5701 AS '+@sSQL)

SET @ListMaterial_cur  = CURSOR SCROLL KEYSET FOR 
SELECT   round(MV5701.ConvertedAmount, @ConvertedDecimal), MV5701.ProductID, MT2222.ProductQuantity, MT2222.UnitID
FROM MV5701 LEFT JOIN MT2222 ON MV5701.DivisionID = MT2222.DivisionID AND MV5701.ProductID  = MT2222.ProductID 

OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO    @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
WHILE @@Fetch_Status = 0
    BEGIN    
        ---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
        IF ISNULL(@ProductQuantity, 0)<>0 
              SET @ConvertedUnit =ISNULL(@ConvertedAmount, 0)/@ProductQuantity
        ELSE SET @ConvertedUnit = 0
        
        --INSERT vao bang MT0621
        --IF ISNULL(@SumProductCovalues, 0) <>0             
        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, 
                    ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
        VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST003', 0, 0, @MaterialTypeID, 
                    @ConvertedAmount, @ConvertedUnit, @ProductQuantity, NULL)
        
        FETCH NEXT FROM @ListMaterial_cur INTO   @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
    END
CLOSE @ListMaterial_cur

--HÖ sè--


SET @sSQL='
SELECT MT1605.DivisionID, 
    (Case  when MT1605.InventoryID is NULL then MT2222.ProductID ELSE MT1605.InventoryID END) AS ProductID, 
    ISNULL(CoValue, 0) AS  CoValue, 
    ISNULL(ProductQuantity, 0) AS ProductQuantity, 
     CoValue*ProductQuantity AS ProductCoValues 
FROM MT1605  Full JOIN MT2222 ON MT2222.DivisionID = MT1605.DivisionID AND MT2222.ProductID = MT1605.InventoryID
WHERE CoefficientID ='''+@CoefficientID+''' AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5702' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5702 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5702 AS '+@sSQL)

--Duyet  tung mat hang
SET @ConvertedAmount=(SELECT SUM(Case D_C when 'D' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END)  FROM MV9000 WHERE      DivisionID =@DivisionID AND PeriodID = @PeriodID AND
                                        ExpenseID ='COST003' AND    MaterialTypeID =@MaterialTypeID )

--print @ConvertedAmount
SET @SumProductCovalues = (SELECT SUM(ISNULL(ProductCovalues, 0)) FROM MV5702)
        --Print str(@SumProductCoValues)
SET @ListProduct_cur = CURSOR SCROLL KEYSET FOR 
    SELECT     ProductID, ProductQuantity, ProductCoValues
    FROM MV5702        
OPEN    @ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues
            
WHILE @@Fetch_Status = 0
    BEGIN
        
        IF ISNULL(@SumProductCoValues, 0) <> 0 AND ISNULL(@ProductQuantity, 0) <> 0
            
            SET  @ProductOthers = ((ISNULL(@ConvertedAmount, 0)/@SumProductCovalues)*ISNULL(@ProductCoValues, 0))/@ProductQuantity        
        ELSE
            SET @ProductOthers= 0 
    
        SET @ProductOthers = Round(@ProductOthers, @ConvertedDecimal)

        IF ISNULL(@SumProductCovalues, 0) <>0 
            SET @ConvertedAmount1 = (round((ISNULL(@ConvertedAmount, 0)*ISNULL(@ProductCoValues, 0)/@SumProductCovalues), @ConvertedDecimal) )
        ELSE 
            SET @ConvertedAmount1 = 0 

                INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, 
                            ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
                VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST003', NULL, NULL, @MaterialTypeID, @ConvertedAmount1, 
                            @ProductOthers, @ProductQuantity, NULL)
                
        FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues
    END

CLOSE @ListProduct_cur