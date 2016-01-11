/****** Object:  StoredProcedure [dbo].[MP5207]    Script Date: 12/16/2010 11:40:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Created BY Hoang Thi Lan
--Date 07/11/2003
--Purpose : Phan bo chi phi nhan cong ket hop dinh muc.
-- Edit BY Quoc Hoai
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/    

ALTER PROCEDURE [dbo].[MP5207]  @DivisionID AS NVARCHAR(50), 
                 @PeriodID AS NVARCHAR(50), 
                 @TranMonth AS INT, 
                 @TranYear AS INT, 
                 @MaterialTypeID AS NVARCHAR(50), 
                 @ApportionID AS NVARCHAR(50)        
AS
DECLARE @sSQL AS NVARCHAR(4000), 
    @SUMProductCovalues AS DECIMAL(28, 8), 
    @ListProduct_cur AS CURSOR, 
    @ProductID AS NVARCHAR(50), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @ProductCovalues AS DECIMAL(28, 8), 
    @ListMaterial_cur AS CURSOR, 
    @MaterialID AS NVARCHAR(50), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @UnitID AS INT, 
    @ProductConvertedUnit AS DECIMAL(28, 8), 
    @MaterialQuantityUnit AS DECIMAL(28, 8), 
    @SUMProductQuantity AS DECIMAL(28, 8), 
    @SUMProductConverted AS DECIMAL(28, 8), 
    @MaterialConvertedUnit AS DECIMAL(28, 8), 
    @ProductQuantityUnit AS DECIMAL(28, 8), 
    @SUMConvertedAmount AS DECIMAL(28, 8), 
    @ConvertedUnit AS DECIMAL(28, 8), 
    @ConvertedDecimal INT

SET @ConvertedDecimal = (SELECT ConvertDecimal FROM MT0000 WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
        
--------- Buoc 1:     Phan bo truc tiep ------------------------
SET @sSQL='
SELECT DivisionID, 
    InventoryID AS MaterialID, SUM( CASE D_C WHEN ''D'' then ISNULL(Quantity, 0) ELSE - ISNULL(Quantity, 0) END) AS MaterialQuantity, 
    SUM(CASE D_C WHEN ''D'' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
    ProductID
FROM MV9000 --- INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID 
WHERE PeriodID = N'''+@PeriodID+''' AND ExpenseID =''COST002'' AND ISNULL(ProductID, '''')<>'''' AND MaterialTypeID =N'''+@MaterialTypeID+''' 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
GROUP BY DivisionID, InventoryID, ProductID  
'
IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV6207' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6207 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6207 AS '+@sSQL)

SET @ListMaterial_cur = CURSOR SCROLL KEYSET FOR 
SELECT MV6207.MaterialID, MV6207.MaterialQuantity, round(MV6207.ConvertedAmount, 0), MV6207.ProductID, MT2222.ProductQuantity, MT2222.UnitID
FROM MV6207 LEFT JOIN MT2222 ON MV6207.DivisionID = MT2222.DivisionID AND MV6207.ProductID  = MT2222.ProductID 

OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
WHILE @@Fetch_Status = 0
    BEGIN    
        IF ISNULL(@ProductQuantity, 0)<>0  
             SET @QuantityUnit = ISNULL(@MaterialQuantity, 0)/@ProductQuantity 
        ELSE SET @QuantityUnit =0
        ---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
        IF ISNULL(@ProductQuantity, 0)<>0 
             SET @ConvertedUnit = ISNULL(@ConvertedAmount, 0)
        ELSE SET @ConvertedUnit = 0
        
        --INSERT vao bang MT0612
        IF ISNULL(@SUMProductCovalues, 0) <> 0 
        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
        VALUES (@DivisionID, @MaterialID, @ProductID, @UnitID, 'COST002', @MaterialQuantity, @QuantityUnit, @MaterialTypeID, @ConvertedAmount, @ConvertedUnit, @ProductQuantity, NULL)
        
        FETCH NEXT FROM @ListMaterial_cur INTO @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductQuantity, @UnitID
    END
CLOSE @ListMaterial_cur


 SET @SUMConvertedAmount = (SELECT SUM(CASE D_C WHEN 'D' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) 
                            FROM MV9000 
                            WHERE ExpenseID ='COST002' AND PeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID
                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))        

---- Xac dinh tong he so chung
SET @SUMProductConverted = (SELECT SUM(ISNULL(ConvertedUnit, 0)*ISNULL(MT2222.ProductQuantity, 0))
                            FROM MT1603 INNER JOIN MT2222 ON MT2222.DivisionID = MT1603.DivisionID AND MT2222.ProductID = MT1603.ProductID
                            WHERE ApportionID = @ApportionID AND ExpenseID = 'COST002' AND MaterialTypeID = @MaterialTypeID
                                AND MT1603.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

SET @ListMaterial_cur  = CURSOR SCROLL KEYSET FOR 
SELECT MT1603.ProductID, ISNULL(ConvertedUnit, 0)*ISNULL(MT2222.ProductQuantity, 0), MT2222.ProductQuantity, MT2222.UnitID    
FROM MT1603 INNER JOIN MT2222 ON MT2222.DivisionID = MT1603.DivisionID AND MT2222.ProductID = MT1603.ProductID
WHERE ApportionID = @ApportionID AND ExpenseID = 'COST002' AND MaterialTypeID = @MaterialTypeID    
    AND MT1603.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
    
OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO @ProductID, @ProductConvertedUnit, @ProductQuantity, @UnitID    
WHILE @@Fetch_Status = 0
    BEGIN    
        IF ISNULL(@SUMProductConverted, 0)<>0
             SET @MaterialConvertedUnit = round((ISNULL(@SUMConvertedAmount, 0)/@SUMProductConverted)*ISNULL(@ProductConvertedUnit, 0), @ConvertedDecimal)
        ELSE SET @MaterialConvertedUnit = 0
        
        IF ISNULL(@ProductQuantity, 0)<>0 
        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
        VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST002', NULL, NULL, @MaterialTypeID, @MaterialConvertedUnit, ISNULL(@MaterialConvertedUnit, 0)/@ProductQuantity, @ProductQuantity, NULL)
    
        FETCH NEXT FROM @ListMaterial_cur INTO @ProductID, @ProductConvertedUnit, @ProductQuantity, @UnitID    
    END            
CLOSE @ListMaterial_cur
