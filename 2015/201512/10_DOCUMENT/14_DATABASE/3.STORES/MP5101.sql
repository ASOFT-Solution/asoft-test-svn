
/****** Object:  StoredProcedure [dbo].[MP5101]    Script Date: 12/16/2010 11:17:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----- Created BY Nguyen Van Nhan  Date: 06/11/2003
---- Purpose: Phan bo chi phi NVL the PP truc tiep
-- Edit BY : Vo Thanh Huong, date : 06/05/2005
---purpose: lam tron, phan giam so luong d/v ps giam 
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER Procedure [dbo].[MP5101]     @DivisionID AS nvarchar(50), 
                @PeriodID AS nvarchar(50), 
                @TranMonth AS INT, 
                @TranYear AS INT, 
                @MaterialTypeID AS nvarchar(50)                 
AS 
DECLARE @sSQL AS nvarchar(4000), 
    @SumProductCovalues AS DECIMAL(28, 8), 
    @ProductID AS nvarchar(50), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @ProductCovalues AS DECIMAL(28, 8), 
    @ListMaterial_cur AS Cursor, 
    @MaterialID AS nvarchar(50), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @ConvertedUnit AS DECIMAL(28, 8), 
    @UnitID AS nvarchar(50), 
    @ConvertDecimal INT
    
SET @ConvertDecimal = (Select ConvertDecimal FROM MT0000 where DivisionID = @DivisionID)
--- Phan bo chi phi 
SET @sSQL='
Select     
    DivisionID, 
    InventoryID AS MaterialID, 
    SUM( Case D_C when ''D'' then ISNULL(Quantity, 0) ELSE - ISNULL(Quantity, 0) END ) AS MaterialQuantity, 
    SUM( Case D_C when ''D'' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
    ProductID
FROM MV9000
WHERE PeriodID = N'''+@PeriodID+''' 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N''' + @DivisionID + '''))
    AND ExpenseID = ''COST001'' 
    AND ISNULL(ProductID, '''') <> ''''  
    AND MaterialTypeID = N''' + @MaterialTypeID + ''' 
GROUP BY DivisionID, InventoryID, ProductID  
'
IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV5101' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5101 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5101 AS '+@sSQL)

SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
Select 
    MV5101.MaterialID, 
    MV5101.MaterialQuantity, 
    round(MV5101.ConvertedAmount, @ConvertDecimal), 
    MV5101.ProductID, 
    MT2222.ProductQuantity, 
    MT2222.UnitID
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
              SET @ConvertedUnit =ISNULL(@ConvertedAmount, 0)/@ProductQuantity
        ELSE SET @ConvertedUnit = 0
        
        --INSERT vao bang MT0612
        --IF ISNULL(@SumProductCovalues, 0) <>0 
        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
        VALUES (@DivisionID, @MaterialID, @ProductID, @UnitID, 'COST001', @MaterialQuantity, @QuantityUnit, @MaterialTypeID, @ConvertedAmount, @ConvertedUnit, @ProductQuantity, NULL)
        
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
    END
CLOSE @ListMaterial_cur

---- Xu ly lam tron
DECLARE @Detal_ConvertedAmount AS DECIMAL(28, 8), 
    @ID AS DECIMAL(28, 0)

SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
Select ISNULL(MaterialID, ''), SUM(Quantity) AS Quantity, SUM(ConvertedAmount) AS ConvertedAmount 
FROM MT0621 
WHERE MaterialTypeID =@MaterialTypeID AND ExpenseID ='COST001'
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
GROUP BY ISNULL(MaterialID, '')
        
OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount

WHILE @@Fetch_Status = 0        
    Begin    
        Select @Detal_ConvertedAmount =0
        Select @Detal_ConvertedAmount = round(ISNULL((Select  SUM( Case D_C  when  'D' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) 
                                                      FROM MV9000 
                                                      WHERE PeriodID =@PeriodID AND MaterialTypeID =@MaterialTypeID 
                                                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                                        AND ISNULL(ProductID, '')<>'' AND ISNULL(InventoryID, '')  = @MaterialID ), 0), @ConvertDecimal) - @ConvertedAmount
            
        IF @Detal_ConvertedAmount <>0
            Begin
                SET @ID = NULL
                SET @ID =(Select TOP 1 ID  FROM MT0621 
                          WHERE MaterialTypeID =@MaterialTypeID AND ExpenseID = 'COST001' AND ISNULL(MaterialID, '') = @MaterialID 
                              AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                          Order BY  ConvertedAmount Desc )
                IF @ID is NOT NULL
                    Update MT0621  SET ConvertedAmount = ConvertedAmount + @Detal_ConvertedAmount     
                    WHERE ID =@ID
                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
            END
    
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount
    END    

/*
--- Phan bo giam chi phi 
SET @sSQL='

Select     InventoryID AS MaterialID, SUM(ISNULL(Quantity, 0)) AS MaterialQuantity, 
    SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount, 
    ProductID

 FROM MV9000 INNER JOIN MT0700 ON MV9000.CreditAccountID=MT0700.AccountID   
WHERE     DivisionID ='''+@DivisionID+''' AND
    PeriodID = '''+@PeriodID+''' AND
    ExpenseID =''COST001'' AND
    ISNULL(ProductID, '''')<>''''  AND 
    MaterialTypeID ='''+@MaterialTypeID+''' 
GROUP BY InventoryID, ProductID  '

IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV5101' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5101 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5101 AS '+@sSQL)

SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
    Select MV5101.MaterialID, MV5101.MaterialQuantity, MV5101.ConvertedAmount, MV5101.ProductID, MT2222.ProductQuantity, MT2222.UnitID
        FROM MV5101 LEFT JOIN MT2222 ON MV5101.ProductID  = MT2222.ProductID 
        OPEN @ListMaterial_cur 
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
        WHILE @@Fetch_Status = 0
            Begin    
                                
                --Print '@MaterialID'+@MaterialID
            ---    print '@MaterialQuantity'+str(@MaterialQuantity)
                
                IF ISNULL(@ProductQuantity, 0)<>0  
                     SET @QuantityUnit = ISNULL(@MaterialQuantity, 0)/@ProductQuantity 
                ELSE  SET @QuantityUnit =0
                ---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
                IF ISNULL(@ProductQuantity, 0)<>0 
                      SET @ConvertedUnit =ISNULL(@ConvertedAmount, 0)/@ProductQuantity
                ELSE SET @ConvertedUnit = 0
                
                --INSERT vao bang MT0612
                --IF ISNULL(@SumProductCovalues, 0) <>0 

                Update MT0621 SET  Quantity=Quantity-@MaterialQuantity, ConvertedAmount= ConvertedAmount-@ConvertedAmount, ProductQuantity=ProductQuantity-@ProductQuantity, QuantityUnit=QuantityUnit-@QuantityUnit, ConvertedUnit=ConvertedUnit-@ConvertedUnit
                        WHERE MaterialID=@MaterialID AND ProductID=@ProductID AND  ExpenseID='COST001'  AND  MaterialTypeID=@MaterialTypeID
                
                FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
            END
        CLOSE @ListMaterial_cur






*/
