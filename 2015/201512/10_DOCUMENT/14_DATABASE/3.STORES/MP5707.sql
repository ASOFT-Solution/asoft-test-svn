/****** Object:  StoredProcedure [dbo].[MP5707]    Script Date: 12/16/2010 13:23:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang thi Lan
--Date 07/11/2003
--Purpose : Phan bo chi phi SXC truc tiep ket hop  dinh muc
-- Edit BY Quoc Hoai
--- Modify on 30/12/2013 by Bảo Anh: Sửa kiểu dữ liệu các biến truyền vào store từ nvarchar(20) thành nvarchar(50)

ALTER PROCEDURE [dbo].[MP5707]  @DivisionID AS VARCHAR(50), 
                 @PeriodID AS VARCHAR(50), 
                 @TranMonth AS INT, 
                 @TranYear AS INT, 
                 @MaterialTypeID AS VARCHAR(50), 
                 @ApportionID AS VARCHAR(50)
AS 
DECLARE @sSQL AS VARCHAR(8000), 
        @SumProductCovalues AS DECIMAL(28, 8), 
        @ListProduct_cur AS CURSOR, 
        @ProductID AS VARCHAR(50), 
        @ProductQuantity AS DECIMAL(28, 8), 
        @ProductCovalues AS DECIMAL(28, 8), 
        @ListMaterial_cur AS CURSOR, 
        @MaterialID AS VARCHAR(50), 
        @MaterialQuantity AS DECIMAL(28, 8), 
        @ConvertedAmount AS DECIMAL(28, 8), 
        @QuantityUnit AS DECIMAL(28, 8), 
        @UnitID AS VARCHAR(50), 
        @ProductConvertedUnit AS DECIMAL(28, 8), 
        @MaterialQuantityUnit AS DECIMAL(28, 8), 
        @SumProductQuantity AS DECIMAL(28, 8), 
        @SumProductConverted AS DECIMAL(28, 8), 
        @MaterialConvertedUnit AS DECIMAL(28, 8), 
        @ProductQuantityUnit AS DECIMAL(28, 8), 
        @SumConvertedAmount AS DECIMAL(28, 8), 
        @ConvertedUnit AS DECIMAL(28, 8), 
        @ConvertedDecimal AS tinyint  --- Bien lam tron

SET @ConvertedDecimal = (SELECT ConvertDecimal FROM MT0000)

--------- Buoc 1:     Phan bo truc tiep ------------------------
SET @sSQL='
SELECT DivisionID, 
    InventoryID AS MaterialID, 
    SUM( Case D_C  when  ''D'' then ISNULL(Quantity, 0) ELSE - ISNULL(Quantity, 0) END) AS MaterialQuantity, 
    SUM(Case D_C when ''D'' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
    ProductID
FROM MV9000 
WHERE DivisionID ='''+@DivisionID+''' AND
    PeriodID = '''+@PeriodID+''' AND
    ExpenseID =''COST002'' AND
    ISNULL(ProductID, '''')<>''''  AND 
    MaterialTypeID ='''+@MaterialTypeID+''' 
    GROUP BY DivisionID, InventoryID, ProductID  '

    IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV6707' AND Xtype ='V')
        EXEC ('CREATE VIEW MV6707 AS '+@sSQL)
    ELSE
        EXEC ('ALTER VIEW MV6707 AS '+@sSQL)

SET @ListMaterial_cur  = CURSOR SCROLL KEYSET FOR 
SELECT MV6707.MaterialID, MV6707.MaterialQuantity, round(MV6707.ConvertedAmount, @ConvertedDecimal), MV6707.ProductID, MT2222.ProductQuantity, MT2222.UnitID
FROM MV6707 LEFT JOIN MT2222 ON MV6707.DivisionID  = MT2222.DivisionID AND MV6707.ProductID  = MT2222.ProductID 

OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
WHILE @@Fetch_Status = 0
    BEGIN
        IF ISNULL(@ProductQuantity, 0)<>0  
             SET @QuantityUnit = ISNULL(@MaterialQuantity, 0)/@ProductQuantity 
        ELSE  SET @QuantityUnit =0
        ---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
        IF ISNULL(@ProductQuantity, 0)<>0 
              SET @ConvertedUnit =ISNULL(@ConvertedAmount, 0)
        ELSE SET @ConvertedUnit = 0
        
        --INSERT vao bang MT0612
        IF ISNULL(@SumProductCovalues, 0) <>0 
                         
        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, 
                    ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
        VALUES (@DivisionID, @MaterialID, @ProductID, @UnitID, 'COST002', @MaterialQuantity, @QuantityUnit, @MaterialTypeID, 
                    @ConvertedAmount, @ConvertedUnit, @ProductQuantity, NULL)
        
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
    END
CLOSE @ListMaterial_cur

--tinh tong chi phi
 SET @SumConvertedAmount = (SELECT SUM(Case D_C when 'D' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) 
                 FROM MV9000
                 WHERE     DivisionID =@DivisionID AND 
                    ExpenseID ='COST003' AND
                     PeriodID= @PeriodID AND MaterialTypeID = @MaterialTypeID  )        


---- Xac dinh tong he so chung

SET @SumProductConverted = (SELECT   SUM(ISNULL(ConvertedUnit, 0)*ISNULL(MT2222.ProductQuantity, 0))
                FROM MT1603 INNER JOIN MT2222 ON MT2222.DivisionID = MT1603.DivisionID AND MT2222.ProductID = MT1603.ProductID
                WHERE     ApportionID = @ApportionID AND 
                    ExpenseID = 'COST003' AND 
                    MaterialTypeID = @MaterialTypeID AND MT1603.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

SET @ListMaterial_cur  = CURSOR SCROLL KEYSET FOR 
SELECT MT1603.ProductID, ConvertedUnit*MT2222.ProductQuantity, MT2222.ProductQuantity, MT2222.UnitID    
FROM MT1603 INNER JOIN MT2222 ON MT2222.DivisionID = MT1603.DivisionID AND MT2222.ProductID = MT1603.ProductID
WHERE     ApportionID = @ApportionID AND 
ExpenseID = 'COST003' AND 
MaterialTypeID = @MaterialTypeID AND MT1603.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))

OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO  @ProductID, @ProductConvertedUnit, @ProductQuantity, @UnitID    
WHILE @@Fetch_Status = 0
BEGIN    
    
    IF ISNULL(@SumProductConverted, 0)<>0 
    SET      @MaterialConvertedUnit = round((ISNULL(@SumConvertedAmount, 0)/@SumProductConverted)*ISNULL(@ProductConvertedUnit, 0), @ConvertedDecimal)
    ELSE SET @MaterialConvertedUnit =0 
    IF ISNULL(@ProductQuantity, 0)<>0 
    INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, 
                    ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
    VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST003', NULL, NULL, @MaterialTypeID, 
                    @MaterialConvertedUnit, ISNULL(@MaterialConvertedUnit, 0)/@ProductQuantity, @ProductQuantity, NULL)

        FETCH NEXT FROM @ListMaterial_cur INTO  @ProductID, @ProductConvertedUnit, @ProductQuantity, @UnitID    
END            
CLOSE @ListMaterial_cur
