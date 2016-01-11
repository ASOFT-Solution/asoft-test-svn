
/****** Object:  StoredProcedure [dbo].[MP5106]    Script Date: 12/16/2010 11:29:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----     Created BY Nguyen Van Nhan; Date: 06/11/2003
----     Purpose: Phan bo chi phi nguyen vat lieu truc tiep ket hop he so.
-- Edit BY Quoc Hoai
---edited BY: Vo Thanh Huong, date: 20/05/2005, Xu ly lam tron
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER Procedure [dbo].[MP5106] @DivisionID AS nvarchar(50), @PeriodID AS nvarchar(50), 
                @TranMonth AS INT, @TranYear AS INT, 
                @MaterialTypeID AS nvarchar(50), 
                @CoefficientID AS nvarchar(50) 

AS 
DECLARE @sSQL AS nvarchar(4000), 
    @SumProductCovalues AS DECIMAL(28, 8), 
    @ListProduct_cur AS Cursor, 
    @ProductID AS nvarchar(50), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @ProductCovalues AS DECIMAL(28, 8), 
    @ListMaterial_cur AS Cursor, 
    @MaterialID AS nvarchar(50), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @ConvertedUnit AS DECIMAL(28, 8), 
    @UnitID AS INT, 
    @ConvertedDecimal INT

SET @ConvertedDecimal = (Select ConvertDecimal FROM MT0000)

--------- Buoc 1:     Phan bo truc tiep ------------------------
SET @sSQL='

    SELECT DivisionID, InventoryID AS MaterialID, SUM( Case D_C  when  ''D'' then ISNULL(Quantity, 0) ELSE - ISNULL(Quantity, 0) END) AS MaterialQuantity, 
        SUM( Case D_C when  ''D'' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
        ProductID 

    FROM MV9000  ---INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
    WHERE PeriodID = N'''+@PeriodID+''' 
        AND ExpenseID =''COST001'' 
        AND ISNULL(ProductID, '''')<>''''  
        AND MaterialTypeID =N'''+@MaterialTypeID+''' 
        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
        GROUP BY DivisionID, InventoryID, ProductID  '

    IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV5101' AND Xtype ='V')
        EXEC ('CREATE VIEW MV5101 AS '+@sSQL)
    ELSE
        EXEC ('ALTER VIEW MV5101 AS '+@sSQL)

SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
Select MV5101.MaterialID, MV5101.MaterialQuantity, round(MV5101.ConvertedAmount, @ConvertedAmount), MV5101.ProductID, MT2222.ProductQuantity, MT2222.UnitID
FROM MV5101 LEFT JOIN MT2222 ON MV5101.DivisionID  = MT2222.DivisionID AND MV5101.ProductID  = MT2222.ProductID 
        
OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
WHILE @@Fetch_Status = 0
    Begin    
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
        VALUES (@DivisionID, @MaterialID, @ProductID, @UnitID, 'COST001', @MaterialQuantity, @QuantityUnit, @MaterialTypeID, 
                    @ConvertedAmount, @ConvertedUnit, @ProductQuantity, NULL)
        
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductQuantity, @UnitID
    END
CLOSE @ListMaterial_cur


---Print ' Van Nhan '
SET @sSQL='
SELECT MT1605.DivisionID, (CASE when MT1605.InventoryID is NULL then MT2222.ProductID ELSE MT1605.InventoryID END) AS ProductID, 
    MT2222.UnitID, 
    ISNULL(CoValue, 0) AS  CoValue, 
    ISNULL(ProductQuantity, 0) AS ProductQuantity, 
    CoValue * ProductQuantity AS ProductCoValues 
FROM MT1605 Full JOIN MT2222 ON MT2222.DivisionID = MT1605.DivisionID AND MT2222.ProductID = MT1605.InventoryID
WHERE CoefficientID =N'''+@CoefficientID+''' 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
'

IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV5106' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5106 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5106 AS '+@sSQL)


---- tao ra VIEW So 1
SET @sSQL='

Select DivisionID, InventoryID AS MaterialID, SUM( Case D_C  when  ''D'' then ISNULL(Quantity, 0) ELSE - ISNULL(Quantity, 0) END) AS MaterialQuantity, 
     SUM( Case when D_C =''D'' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0)  END) AS ConvertedAmount 

FROM MV9000 ----INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
WHERE PeriodID = N'''+@PeriodID+''' 
    AND ExpenseID =''COST001'' 
    AND ISNULL(ProductID, '''') ='''' 
    AND MaterialTypeID =N'''+@MaterialTypeID+''' 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
GROUP BY DivisionID, InventoryID 
'

IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV6106' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6106 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6106 AS '+@sSQL)


------ Buoc 3  --- Xac dinh tong he so chung

SET @SumProductCovalues = (Select SUM(ISNULL(ProductCovalues, 0)) FROM MV5106)

SET @ListProduct_cur = Cursor Scroll KeySet FOR 
    SELECT ProductID, ProductQuantity, ProductCoValues, UnitID
    FROM MV5106       
     
OPEN    @ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @UnitID            
WHILE @@Fetch_Status = 0
    Begin    
        SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
        Select MaterialID, MaterialQuantity, ConvertedAmount FROM MV6106
        OPEN @ListMaterial_cur 
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount
        WHILE @@Fetch_Status = 0
            Begin    
                ---- Phan bo so luong NVL cho mot san pham
                 IF ISNULL(@SumProductCovalues, 0) <> 0 AND  ISNULL(@ProductQuantity, 0)<>0        
                SET @QuantityUnit=(ISNULL(@MaterialQuantity, 0)/@SumProductCovalues)*ISNULL(@ProductCoValues, 0)/ @ProductQuantity 
                ELSE SET @QuantityUnit=0                
                
                ---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
                IF ISNULL(@SumProductCovalues, 0) <> 0 AND  ISNULL(@ProductQuantity, 0)<> 0                    
                   SET @ConvertedUnit = (@ConvertedAmount/@SumProductCovalues)*@ProductCoValues/@ProductQuantity                    
                ELSE SET @ConvertedUnit = 0
                --INSERT vao bang MT0612
                IF ISNULL(@SumProductCovalues, 0) <>0 
                INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, 
                            ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
                VALUES (@DivisionID, @MaterialID, @ProductID, @UnitID, 'COST001', (ISNULL(@MaterialQuantity, 0)/@SumProductCovalues)* ISNULL(@ProductCoValues, 0), @QuantityUnit, @MaterialTypeID, 
                            round((ISNULL(@ConvertedAmount, 0)/@SumProductCovalues)*ISNULL(@ProductCoValues, 0), @ConvertedDecimal), @ConvertedUnit, @ProductQuantity, NULL)
                
                FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount
            END
        CLOSE @ListMaterial_cur
     FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @UnitID
    END
CLOSE @ListProduct_cur


---- Xu ly lam tron
DECLARE @Detal AS DECIMAL(28, 8), 
    @ID AS DECIMAL(28, 8)

SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
Select ISNULL(MaterialID, ''), SUM(Quantity) AS Quantity, SUM(ConvertedAmount) AS ConvertedAmount 
FROM MT0621 WHERE MaterialTypeID =@MaterialTypeID  AND ExpenseID ='COST001'
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
GROUP BY ISNULL(MaterialID, '')

OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount
WHILE @@Fetch_Status = 0
    Begin
        SELECT @Detal =0, @ID = NULL, 
            @Detal = round( ISNULL( (Select SUM( Case D_C  when  'D' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) 
                FROM MV9000   --- INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
                WHERE PeriodID =@PeriodID 
                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                    AND MaterialTypeID = @MaterialTypeID 
                    AND ISNULL(InventoryID, '')  = @MaterialID), 0), @ConvertedDecimal) - @ConvertedAmount
        IF @Detal<>0
            Begin
                SET @ID = (Select TOP 1 ID  FROM MT0621 
                            WHERE MaterialTypeID =@MaterialTypeID AND ExpenseID = 'COST001' AND ISNULL(MaterialID, '') = @MaterialID 
                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                            Order BY  ConvertedAmount Desc )
                IF @ID is NOT NULL
                    Update MT0621 SET ConvertedAmount = ConvertedAmount + @Detal     
                    WHERE ID =@ID
                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
            END
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount
    END    
/*
---- Phan giam chi phi gia thanh

--------- Buoc 1:     Phan bo truc tiep ------------------------
SET @sSQL='

    SELECT InventoryID AS MaterialID, SUM(Quantity) AS MaterialQuantity, 
        SUM(convertedAmount) AS ConvertedAmount, 
        ProductID

     FROM MV9000 INNER JOIN MT0700 ON MV9000.CreditAccountID=MT0700.AccountID
    WHERE DivisionID =N'''+@DivisionID+''' AND
        PeriodID = N'''+@PeriodID+''' AND
        ExpenseID =''COST001'' AND
        ISNULL(ProductID, '''')<>''''  AND 
        MaterialTypeID =N'''+@MaterialTypeID+''' 
        GROUP BY InventoryID, ProductID  '

    IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV5101' AND Xtype ='V')
        EXEC ('CREATE VIEW MV5101 AS '+@sSQL)
    ELSE
        EXEC ('ALTER VIEW MV5101 AS '+@sSQL)

SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
    Select MV5101.MaterialID, MV5101.MaterialQuantity, MV5101.ConvertedAmount, MV5101.ProductID, MT2222.ProductQuantity, MT2222.UnitID
        FROM MV5101 LEFT JOIN MT2222 ON MV5101.ProductID  = MT2222.ProductID 
        OPEN @ListMaterial_cur 
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductQuantity, @UnitID
        WHILE @@Fetch_Status = 0
            Begin    
                IF ISNULL(@ProductQuantity, 0)<>0  
                     SET @QuantityUnit = ISNULL(@MaterialQuantity, 0)/@ProductQuantity 
                ELSE  SET @QuantityUnit =0
                ---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
                IF ISNULL(@ProductQuantity, 0)<>0 
                      SET @ConvertedUnit =ISNULL(@ConvertedAmount, 0)
                ELSE SET @ConvertedUnit = 0
                
                Update MT0621 SET  Quantity=Quantity-@MaterialQuantity, ConvertedAmount= ConvertedAmount-@ConvertedAmount, ProductQuantity=ProductQuantity-@ProductQuantity, QuantityUnit=QuantityUnit-@QuantityUnit, ConvertedUnit=ConvertedUnit-@ConvertedUnit
                        WHERE MaterialID=@MaterialID AND ProductID=@ProductID AND  ExpenseID='COST001'  AND  MaterialTypeID=@MaterialTypeID

                
                FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductQuantity, @UnitID
            END
    CLOSE @ListMaterial_cur


---- tao ra VIEW So 1
SET @sSQL='

Select InventoryID AS MaterialID, SUM(Quantity) AS MaterialQuantity, 
     SUM(convertedAMount) AS ConvertedAmount

 FROM MV9000 INNER JOIN MT0700 ON MV9000.CreditAccountID=MT0700.AccountID
WHERE DivisionID =N'''+@DivisionID+''' AND
    PeriodID = N'''+@PeriodID+''' AND
    ExpenseID =''COST001'' AND 
    ISNULL(ProductID, '''') ='''' AND 
    MaterialTypeID =N'''+@MaterialTypeID+''' 
GROUP BY InventoryID '

IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV6106' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6106 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6106 AS '+@sSQL)


------ Buoc 3  --- Xac dinh tong he so chung

SET @SumProductCovalues = (Select SUM(ISNULL(ProductCovalues, 0)) FROM MV5106)

SET @ListProduct_cur = Cursor Scroll KeySet FOR 
    SELECT ProductID, ProductQuantity, ProductCoValues, UnitID
    FROM MV5106        
OPEN    @ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @UnitID
            
WHILE @@Fetch_Status = 0
    Begin    
        SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
        Select MaterialID, MaterialQuantity, ConvertedAmount FROM MV6106
        OPEN @ListMaterial_cur 
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount
        WHILE @@Fetch_Status = 0
            Begin    
                ---- Phan bo so luong NVL cho mot san pham
                 IF ISNULL(@SumProductCovalues, 0) <> 0 AND  ISNULL(@ProductQuantity, 0)<>0        
                SET @QuantityUnit=(ISNULL(@MaterialQuantity, 0)/@SumProductCovalues)*ISNULL(@ProductCoValues, 0)/ @ProductQuantity 
                ELSE SET @QuantityUnit=0                
                
                ---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
                IF ISNULL(@SumProductCovalues, 0) <> 0 AND  ISNULL(@ProductQuantity, 0)<> 0                    
                   SET @ConvertedUnit = (@ConvertedAmount/@SumProductCovalues)*@ProductCoValues/@ProductQuantity                    
                ELSE SET @ConvertedUnit = 0
                --INSERT vao bang MT0612
                IF ISNULL(@SumProductCovalues, 0) <>0 
                Update MT0621 SET  Quantity=Quantity-(ISNULL(@MaterialQuantity, 0)/@SumProductCovalues)* ISNULL(@ProductCoValues, 0), ConvertedAmount= ConvertedAmount-(ISNULL(@ConvertedAmount, 0)/@SumProductCovalues)*ISNULL(@ProductCoValues, 0), ProductQuantity=ProductQuantity-@ProductQuantity, QuantityUnit=QuantityUnit-@QuantityUnit, ConvertedUnit=ConvertedUnit-@ConvertedUnit
                    WHERE MaterialID=@MaterialID AND ProductID=@ProductID AND  ExpenseID='COST001'  AND  MaterialTypeID=@MaterialTypeID 

                
                FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount
            END
        CLOSE @ListMaterial_cur
     FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @UnitID
    END

CLOSE @ListProduct_cur
*/
