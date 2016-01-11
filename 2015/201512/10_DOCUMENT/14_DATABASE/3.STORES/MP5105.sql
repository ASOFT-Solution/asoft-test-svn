
/****** Object:  StoredProcedure [dbo].[MP5105]    Script Date: 12/16/2010 11:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Created BY Nguyen Van Nhan
--Date 08/11/2003
--Purpose :phan bo chi phi NVL theo luong
--Edit BY Quoc Hoai
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP5105]     @DivisionID AS nvarchar(50), 
                     @PeriodID AS nvarchar(50), 
                     @TranMonth AS INT, 
                     @TranYear AS INT, 
                     @MaterialTypeID AS nvarchar(50)
AS
DECLARE @sSQL AS nvarchar(4000), 
    @SumProductCovalues AS DECIMAL(28, 8), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @ProductCoValues AS DECIMAL(28, 8), 
    @ConvertedUnit AS DECIMAL(28, 8), 
    @ListMaterial_cur AS cursor, 
    @SumConvertedAmount AS DECIMAL(28, 8), 
    @MaterialID AS nvarchar(50), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ProductConvertedUnit AS DECIMAL(28, 8), 
    @MaterialQuantityUnit AS DECIMAL(28, 8), 
    @SumProductQuantity AS DECIMAL(28, 8), 
    @SumProductConverted AS DECIMAL(28, 8), 
      @MaterialConvertedUnit AS DECIMAL(28, 8), 
    @ListProduct_cur AS cursor, 
    @ProductID AS nvarchar(50), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @ProductQuantityUnit AS DECIMAL(28, 8), 
    @UnitID AS nvarchar(50), @ApportionID AS nvarchar(50), 
    @SumConvertedAmountH AS DECIMAL(28, 8), 
    @ConvertedDecimal INT

SET @ConvertedDecimal = (Select ConvertDecimal FROM MT0000 WHERE DivisionID =@DivisionID)
---- Tong chi phi

---- Buoc 1. Xac dinh he so phan bo dua vao luong da phan bo
SET @sSQL ='
Select  MT0621.DivisionID, MT0621.ProductID, SUM(ConvertedUnit) AS ConvertedUnit, 
    MT2222.ProductQuantity, 
    MT2222.UnitID, 
    SUM(ConvertedUnit)*MT2222.ProductQuantity AS ProductCoValues
FROM MT0621 Full JOIN MT2222 ON MT0621.DivisionID = MT2222.DivisionID AND MT0621.ProductID = MT2222.ProductID
WHERE ExpenseID = ''COST002''
    AND MT0621.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
GROUP BY MT0621.DivisionID, MT0621.ProductID, MT2222.UnitID, MT2222.ProductQuantity '

---- Tao vie he so chung can phan bo cho san pham
IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV5105' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5105 AS '+@sSQL)--Create by MP5105
ELSE
    EXEC ('ALTER VIEW MV5105 AS '+@sSQL)--Create by MP5105

---- tao ra VIEW So 1
SET @sSQL='

Select MV9000.DivisionID, InventoryID AS MaterialID, SUM( Case D_C  when  ''D'' then ISNULL(Quantity, 0) ELSE - ISNULL(Quantity, 0) END) AS MaterialQuantity, 
     SUM( Case D_C when  ''D'' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount
 FROM MV9000  ---INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
WHERE PeriodID = N'''+@PeriodID+''' 
    AND ExpenseID =''COST001'' 
    AND MaterialTypeID =N'''+@MaterialTypeID+''' 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
GROUP BY MV9000.DivisionID, InventoryID '

IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV6105' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6105 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6105 AS '+@sSQL)


SET @SumProductCovalues = (Select SUM(ISNULL(ProductCovalues, 0)) FROM MV5105)

SET @ListProduct_cur = Cursor Scroll KeySet FOR 
    Select     ProductID, ProductQuantity, ProductCoValues, UnitID
    FROM MV5105        
OPEN    @ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @UnitID
            
WHILE @@Fetch_Status = 0
    Begin    
        SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
        Select MaterialID, MaterialQuantity, ConvertedAmount FROM MV6105
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
        Select  @Detal =0, @ID = NULL, 
            @Detal = round(ISNULL( (Select SUM( Case D_C  when  'D' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) 
                FROM MV9000   --- INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
                WHERE PeriodID =@PeriodID AND MaterialTypeID = @MaterialTypeID AND ISNULL(InventoryID, '')  = @MaterialID
                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))), 0), @ConvertedDecimal) - @ConvertedAmount
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

SET @sSQL='

Select InventoryID AS MaterialID, SUM(Quantity) AS MaterialQuantity, 
     SUM( Case when D_C =''D'' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) ) AS ConvertedAmount

 FROM MV9000  ---INNER JOIN MT0700 ON MV9000.CreditAccountID=MT0700.AccountID
WHERE     DivisionID =N'''+@DivisionID+''' AND
    PeriodID = N'''+@PeriodID+''' AND
    ExpenseID =''COST001'' AND
    MaterialTypeID =N'''+@MaterialTypeID+''' 
GROUP BY InventoryID '

IF NOT EXISTS (Select TOP 1 1 FROM SysObjects WHERE name = 'MV6105' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6105 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6105 AS '+@sSQL)


SET @SumProductCovalues = (Select SUM(ISNULL(ProductCovalues, 0)) FROM MV5105)

SET @ListProduct_cur = Cursor Scroll KeySet FOR 
    Select     ProductID, ProductQuantity, ProductCoValues, UnitID
    FROM MV5105        
OPEN    @ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO  @ProductID, @ProductQuantity, @ProductCoValues, @UnitID
            
WHILE @@Fetch_Status = 0
    Begin    
        SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
        Select MaterialID, MaterialQuantity, ConvertedAmount FROM MV6105
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
