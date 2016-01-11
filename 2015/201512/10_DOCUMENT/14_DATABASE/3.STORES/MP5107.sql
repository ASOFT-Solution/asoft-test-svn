/****** Object:  StoredProcedure [dbo].[MP5107]    Script Date: 12/16/2010 11:31:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Created BY Hoang Thi Lan
--Date 07/11/2003
--Purpose: Phan bo chi phi nguyen vat lieu truc tiep ket hop dinh muc.
-- Edit BY Quoc Hoai
---Edited BY: Vo Thanh Huong, date: 20/05/2005, Xu ly lam tron
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP5107]  @DivisionID AS nvarchar(50), 
                 @PeriodID AS nvarchar(50), 
                 @TranMonth AS INT, 
                 @TranYear AS INT, 
                 @MaterialTypeID AS nvarchar(50), 
                 @ApportionID AS nvarchar(50)         
AS
DECLARE @sSQL AS nvarchar(4000), 
    @SUMProductCovalues AS DECIMAL(28, 8), 
    @ListProduct_cur AS Cursor, 
    @ProductID AS nvarchar(50), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @ProductCovalues AS DECIMAL(28, 8), 
    @ListMaterial_cur AS Cursor, 
    @MaterialID AS nvarchar(50), 
    @MaterialQuantity AS DECIMAL(28, 8), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @ConvertedUnit     AS DECIMAL(28, 8), 
    @UnitID AS INT, 
    @ProductConvertedUnit AS DECIMAL(28, 8), 
    @MaterialQuantityUnit AS DECIMAL(28, 8), 
    @SUMProductQuantity AS DECIMAL(28, 8), 
    @SUMProductConverted AS DECIMAL(28, 8), 
    @MaterialConvertedUnit AS DECIMAL(28, 8), 
    @ProductQuantityUnit AS DECIMAL(28, 8), 
    @ConvertedDecimal INT

SET @ConvertedDecimal = (SELECT ConvertDecimal FROM MT0000)
        
--------- Buoc 1:     Phan bo truc tiep ------------------------
SET @sSQL='
SELECT 
    DivisionID, 
    InventoryID AS MaterialID, 
    SUM( CASE D_C WHEN ''D'' then ISNULL(Quantity, 0) ELSE - ISNULL(Quantity, 0) END) AS MaterialQuantity, 
    SUM( CASE D_C WHEN ''D'' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
    ProductID
FROM MV9000  -----INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
WHERE PeriodID = N'''+@PeriodID+''' 
    AND ExpenseID =''COST001'' 
    AND ISNULL(ProductID, '''')<>''''  
    AND MaterialTypeID =N'''+@MaterialTypeID+''' 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
GROUP BY DivisionID, InventoryID, ProductID  
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV6107' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6107 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6107 AS '+@sSQL)

SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
SELECT MV6107.MaterialID, MV6107.MaterialQuantity, round(MV6107.ConvertedAmount, 0), MV6107.ProductID, MT2222.ProductQuantity, MT2222.UnitID
FROM MV6107 LEFT JOIN MT2222 ON MV6107.DivisionID = MT2222.DivisionID AND MV6107.ProductID  = MT2222.ProductID 

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
        IF ISNULL(@SUMProductCovalues, 0) <>0 
        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, 
                    ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
        VALUES (@DivisionID, @MaterialID, @ProductID, @UnitID, 'COST001', @MaterialQuantity, @QuantityUnit, @MaterialTypeID, 
                    @ConvertedAmount, @ConvertedUnit, @ProductQuantity, NULL)
        
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductQuantity, @UnitID
    END
CLOSE @ListMaterial_cur


---- Buoc 1:  lay he so quy doi cho ca nguyen vat lieu
SET @sSQl='
SELECT 
    MT1603.DivisionID, 
    MT1603.ProductID, 
    MaterialID, 
    QuantityUnit, 
    ConvertedUnit, 
    MT2222.ProductQuantity, 
    MT2222.UnitID, 
    QuantityUnit*MT2222.ProductQuantity AS ProductQuantityUnit, 
    ConvertedUnit*MT2222.ProductQuantity AS ProductConvertedUnit
FROM MT1603 INNER JOIN MT2222 ON MT2222.DivisionID = MT1603.DivisionID AND MT2222.ProductID = MT1603.ProductID
WHERE ApportionID = N'''+@ApportionID+''' 
    AND ExpenseID =''COST001'' 
    AND MT1603.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5107' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5107 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5107 AS '+@sSQL)

--print @MaterialTypeID
---- Buoc 2:  Lay tong chi phi theo tung nguyen vat lieu
SET @sSQL='
SELECT 
    DivisionID, 
    InventoryID AS MaterialID, 
    SUM( CASE D_C WHEN ''D'' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
    SUM(Quantity) AS MaterialQuantity,
    ProductID
FROM MV9000  ----INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
WHERE PeriodID = N'''+@PeriodID+''' 
    AND ExpenseID =''COST001'' 
    AND MaterialTypeID =N'''+@MaterialTypeID+'''  
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
GROUP BY DivisionID, InventoryID, ProductID
'

---Print @sSQL
IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV6107' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6107 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6107 AS '+@sSQL)


----- Buoc 3: Duyet tung nguyen vat lieu va phan bo chi phi cho chung
SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
SELECT MV5107.MaterialID, MV5107.ProductID, MV6107.ConvertedAmount, 
    MV6107.MaterialQuantity, 
    MV5107.ProductQuantity, 
    MV5107.ProductQuantityUnit, MV5107.ProductConvertedUnit, 
    SUMProductQuantity = (SELECT SUM (ProductQuantityUnit) FROM MV5107 M07
            WHERE M07.MaterialID = MV6107.MaterialID), 
    SUMProductConverted = (SELECT SUM (ProductConvertedUnit) FROM MV5107 M07
            WHERE M07.MaterialID = MV6107.MaterialID)
FROM MV5107 INNER JOIN  MV6107 ON MV5107.DivisionID = MV6107.DivisionID AND MV5107.MaterialID = MV6107.MaterialID 

OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @ProductID, @ConvertedAmount, 
            @MaterialQuantity, @ProductQuantity, @ProductQuantityUnit, @ProductConvertedUnit, @SUMProductQuantity, @SUMProductConverted

    WHILE @@Fetch_Status = 0
    Begin    
        
        SET     @MaterialQuantityUnit = (@MaterialQuantity/@SUMProductQuantity)*@ProductQuantityUnit
        SET      @MaterialConvertedUnit =(@ConvertedAmount/@SUMProductConverted)*@ProductConvertedUnit

        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, 
                        ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
            VALUES (@DivisionID, @MaterialID, @ProductID, @UnitID, 'COST001', @MaterialQuantityUnit, @MaterialQuantityUnit/@ProductQuantity, @MaterialTypeID, 
                        round(@MaterialConvertedUnit, @ConvertedDecimal), @MaterialConvertedUnit/@ProductQuantity, @ProductQuantity, NULL)

    
        FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @ProductID, @ConvertedAmount, 
            @MaterialQuantity, @ProductQuantity, @ProductQuantityUnit, @ProductConvertedUnit, @SUMProductQuantity, @SUMProductConverted

    END            
CLOSE @ListMaterial_cur


---- Xu ly lam tron
DECLARE @Detal AS DECIMAL(28, 8), 
    @ID AS DECIMAL(28, 8)

SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
SELECT ISNULL(MaterialID, ''), SUM(Quantity) AS Quantity, SUM(ConvertedAmount) AS ConvertedAmount 
FROM MT0621 WHERE MaterialTypeID = @MaterialTypeID  AND ExpenseID ='COST001'
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
GROUP BY ISNULL(MaterialID, '')
        
OPEN @ListMaterial_cur         
FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount
WHILE @@Fetch_Status = 0
    Begin
        SELECT @Detal =0, @ID = NULL, 
            @Detal = round(ISNULL( (SELECT SUM( CASE D_C WHEN 'D' then   ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) 
                FROM MV9000   --- INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
                WHERE PeriodID =@PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) AND 
                    MaterialTypeID = @MaterialTypeID AND ISNULL(InventoryID, '')  = @MaterialID), 0), @ConvertedDecimal) - @ConvertedAmount
        IF @Detal<>0
            Begin
                SET @ID = (SELECT TOP 1 ID  FROM MT0621 WHERE MaterialTypeID =@MaterialTypeID AND ExpenseID = 'COST001' AND ISNULL(MaterialID, '') = @MaterialID Order BY  ConvertedAmount Desc )
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
    WHERE     DivisionID =N'''+@DivisionID+''' AND
        PeriodID = N'''+@PeriodID+''' AND
        ExpenseID =''COST001'' AND
        ISNULL(ProductID, '''')<>''''  AND 
        MaterialTypeID =N'''+@MaterialTypeID+''' 
        GROUP BY InventoryID, ProductID  '

    IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV6107' AND Xtype ='V')
        EXEC ('CREATE VIEW MV6107 AS '+@sSQL)
    ELSE
        EXEC ('ALTER VIEW MV6107 AS '+@sSQL)

SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 
    SELECT MV6107.MaterialID, MV6107.MaterialQuantity, MV6107.ConvertedAmount, MV6107.ProductID, MT2222.ProductQiantity, MT2222.UnitID
        FROM MV6107 LEFT JOIN MT2222 ON MV5101.ProductID  = MT2222.ProductID 
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

                
                --INSERT vao bang MT0612
                IF ISNULL(@SUMProductCovalues, 0) <>0 
                Update MT0621 SET  Quantity=Quantity-@MaterialQuantity, ConvertedAmount= ConvertedAmount-@ConvertedAmount, ProductQuantity=ProductQuantity-@ProductQuantity, QuantityUnit=QuantityUnit-@QuantityUnit, ConvertedUnit=ConvertedUnit-@ConvertedUnit
                        WHERE MaterialID=@MaterialID AND ProductID=@ProductID AND  ExpenseID='COST001'  AND  MaterialTypeID=@MaterialTypeID

                FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductQuantity, @UnitID
            END
    CLOSE @ListMaterial_cur


---- Buoc 2:  Lay tong chi phi theo tung nguyen vat lieu
SET @sSQL='
SELECT InventoryID AS MaterialID, 
    SUM(ConvertedAMount) AS ConvertedAmount, 
     SUM(Quantity) AS MaterialQuantity
FROM MV9000 INNER JOIN MT0700 ON MV9000.CreditAccountID=MT0700.AccountID
WHERE     PeriodID = N'''+@PeriodID+''' AND
    DivisionID = N'''+@DivisionID+''' AND

    ExpenseID =''COST001'' AND
    MaterialTypeID =N'''+@MaterialTypeID+'''  
GROUP BY InventoryID '

---Print @sSQL
IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV6107' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6107 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6107 AS '+@sSQL)


----- Buoc 3: Duyet tung nguyen vat lieu va phan bo chi phi cho chung


    SET @ListMaterial_cur  = Cursor Scroll KeySet FOR 

    SELECT MV5107.MaterialID, MV5107.ProductID, MV6107.ConvertedAmount, 
        MV6107.MaterialQuantity, 
        MV5107.ProductQuantity, 
        MV5107.ProductQuantityUnit, MV5107.ProductConvertedUnit, 
        SUMProductQuantity = (SELECT SUM (ProductQuantityUnit) FROM MV5107 M07
                WHERE M03.MaterialID = MV6107.MaterialID), 
        SUMProductConverted = (SELECT SUM (ProductConvertedUnit) FROM MV5107 M07
                WHERE M03.MaterialID = MV6107.MaterialID)
    FROM MV5107 INNER JOIN  MV6107 ON MV5107.MaterialID = MV6107.MaterialID 
    OPEN @ListMaterial_cur 
    FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @ProductID, @ConvertedAmount, 
                @MaterialQuantity, @ProductQuantity, @ProductQuantityUnit, @ProductConvertedUnit, @SUMProductQuantity, @SUMProductConverted
    
        WHILE @@Fetch_Status = 0
        Begin    
            
            SET     @MaterialQuantityUnit = (@MaterialQuantity/@SUMProductQuantity)*@ProductQuantityUnit
            SET      @MaterialConvertedUnit =(@ConvertedAmount/@SUMProductConverted)*@ProductConvertedUnit

            ---Print' @ProductQuantity ='+str(@ProductQuantity)
            --print '@InventoryID = '+@MaterialID+'  @SUMProductConverted'+str(@SUMProductConverted)+' ProductID ='+@ProductID+' @MaterialConvertedUnit ='+str(@MaterialConvertedUnit, 20, 8)    
            --print '@SUMProductQuantity' +str(@SUMProductQuantity)
            ---Print ' @MaterialID; @ProductID ='+@MaterialID+'; '+@ProductID+' @MaterialQuantityUnit = '+str(@MaterialQuantityUnit)

            Update MT0621 SET  Quantity=Quantity-@MaterialQuantityUnit, ConvertedAmount= ConvertedAmount-@MaterialConvertedUnit, ProductQuantity=ProductQuantity-@ProductQuantity, QuantityUnit=QuantityUnit-@MaterialQuantityUnit/@ProductQuantity, ConvertedUnit=ConvertedUnit-@MaterialConvertedUnit/@ProductQuantity 
                WHERE MaterialID=@MaterialID AND ProductID=@ProductID AND  ExpenseID='COST001'  AND  MaterialTypeID=@MaterialTypeID 

        
            FETCH NEXT FROM @ListMaterial_cur INTO  @MaterialID, @ProductID, @ConvertedAmount, 
                @MaterialQuantity, @ProductQuantity, @ProductQuantityUnit, @ProductConvertedUnit, @SUMProductQuantity, @SUMProductConverted
    
        END            
CLOSE @ListMaterial_cur
*/

