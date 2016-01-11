/****** Object:  StoredProcedure [dbo].[MP5206]    Script Date: 12/16/2010 11:38:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----- Created BY Nguyen Van Nhan AND Hoang Thi Lan     Date: 06/11/2003 
---- Purpose: Phan bo chi phi Nhan cong theo PP truc tiep ket hop he so
-- Edit BY Quoc Hoai
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/    
    
ALTER PROCEDURE [dbo].[MP5206] 
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
    
--Trùc tiep
    
SET @sSQL='
SELECT DivisionID, 
    SUM(ISNULL(Quantity, 0)) AS MaterialQuantity, 
    SUM(CASE D_C WHEN ''D'' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
    ProductID
FROM MV9000  ----INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID 
WHERE PeriodID = N'''+@PeriodID+''' AND ExpenseID =''COST002'' AND ISNULL(ProductID, '''')<>'''' AND  MaterialTypeID =N'''+@MaterialTypeID+''' 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
GROUP BY DivisionID, ProductID  '
    
IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5201' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5201 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5201 AS '+@sSQL)
    
SET @ListMaterial_cur  = CURSOR SCROLL KEYSET FOR 
SELECT round(MV5201.ConvertedAmount, @ConvertedDecimal), MV5201.ProductID, MT2222.ProductQuantity, MT2222.UnitID
FROM MV5201 LEFT JOIN MT2222 ON MV5201.DivisionID = MT2222.DivisionID AND MV5201.ProductID  = MT2222.ProductID
 
OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
WHILE @@Fetch_Status = 0
    BEGIN    
        ---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
        IF ISNULL(@ProductQuantity, 0)<>0 
              SET @ConvertedUnit =ISNULL(@ConvertedAmount, 0)/@ProductQuantity
        ELSE SET @ConvertedUnit = 0
                                
        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
        VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST002', 0, 0, @MaterialTypeID, @ConvertedAmount, @ConvertedUnit, @ProductQuantity, NULL)
            
        FETCH NEXT FROM @ListMaterial_cur INTO @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
    END
CLOSE @ListMaterial_cur    
    
--He so
    
--Tao  ra VIEW so 1
    
SET @sSQL='
SELECT MT1605.DivisionID, 
    (CASE WHEN MT1605.InventoryID is NULL then MT2222.ProductID ELSE MT1605.InventoryID END) AS ProductID, 
    ISNULL(CoValue, 0) AS  CoValue, 
    ISNULL(ProductQuantity, 0) AS ProductQuantity, 
    CoValue*ProductQuantity AS ProductCoValues 
FROM MT1605 FULL JOIN MT2222 ON MT2222.DivisionID = MT1605.DivisionID AND MT2222.ProductID = MT1605.InventoryID
WHERE CoefficientID = N'''+@CoefficientID+''' AND MT1605.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))'
    
IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5202' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5202 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5202 AS '+@sSQL)
    
    
--Duyet  tung mat hang
SET @ConvertedAmount =( SELECT SUM(CASE D_C WHEN 'D' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END)  
                        FROM MV9000 
                        WHERE PeriodID = @PeriodID AND ExpenseID ='COST002' AND MaterialTypeID = @MaterialTypeID
                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
    
SET @SUMProductCovalues = (SELECT SUM(ISNULL(ProductCovalues, 0)) FROM MV5202)
    
SET @ListProduct_cur = CURSOR SCROLL KEYSET FOR 
SELECT ProductID, ProductQuantity, ProductCoValues FROM MV5202        

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
