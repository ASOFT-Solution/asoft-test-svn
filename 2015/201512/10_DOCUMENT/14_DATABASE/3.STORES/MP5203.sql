
/****** Object:  StoredProcedure [dbo].[MP5203]    Script Date: 08/03/2010 16:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----- Created BY  Nguyen Van Nhan
----- Created Date 07/11/2003.
----- Purpose: Phan bo chi phi nhan cong theo PP dinh muc
-- Edit BY Quoc Hoai

--edited BY: Vo Thanh Huong, date: 20/05/2005, Xu ly lam tron
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP5203]     @DivisionID AS NVARCHAR(50), 
                     @PeriodID AS NVARCHAR(50), 
                    @TranMonth AS INT, 
                    @TranYear AS INT, 
                    @MaterialTypeID AS NVARCHAR(50), 
                    @ApportionID AS NVARCHAR(50)

AS

DECLARE @sSQL AS NVARCHAR(4000), 
        @ListMaterial_cur AS CURSOR, 
        @SUMConvertedAmount AS DECIMAL(28, 8), 
        @MaterialID AS NVARCHAR(50), 
        @ConvertedAmount AS DECIMAL(28, 8), 
        @MaterialQuantity AS DECIMAL(28, 8), 
        @ProductConvertedUnit AS DECIMAL(28, 8), 
        @MaterialQuantityUnit AS DECIMAL(28, 8), 
        @SUMProductQuantity AS DECIMAL(28, 8), 
        @SUMProductConverted AS DECIMAL(28, 8), 
          @MaterialConvertedUnit AS DECIMAL(28, 8), 
        @ListProduct_cur AS CURSOR, 
        @ProductID AS NVARCHAR(50), 
        @ProductQuantity AS DECIMAL(28, 8), 
        @ProductQuantityUnit AS DECIMAL(28, 8), 
        @UnitID AS NVARCHAR(50), 
        @ConvertedUnit AS DECIMAL(28, 8), 
        @ConvertedDecimal INT

SET @ConvertedDecimal = (SELECT ConvertDecimal FROM MT0000 WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
---- Tong chi phi
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
             SET @ConvertedUnit = ISNULL(@MaterialConvertedUnit, 0)/@ProductQuantity
        ELSE SET @ConvertedUnit = 0
        
        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
        VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST002', NULL, NULL, @MaterialTypeID, @MaterialConvertedUnit, @ConvertedUnit, @ProductQuantity, NULL)
    
        FETCH NEXT FROM @ListMaterial_cur INTO @ProductID, @ProductConvertedUnit, @ProductQuantity, @UnitID    
    END            
CLOSE @ListMaterial_cur

---- Xu ly lam tron

DECLARE @MaxProductID AS NVARCHAR(50), 
    @Detal DECIMAL(28, 8)

SET @Detal = round(ISNULL(@SUMConvertedAmount, 0), @ConvertedDecimal) - ISNULL((SELECT SUM(ConvertedAmount) FROM MT0621 
                                                                                WHERE MaterialTypeID = @MaterialtypeID 
                                                                                    AND ExpenseID = 'COST002'
                                                                                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))), 0)
IF @Detal<>0 
    BEGIN
        --- Lam tron
    SET @MaxProductID = (SELECT TOP 1 ProductID FROM MT0621 
                        WHERE ExpenseID ='COST002' AND MaterialTypeID = @MaterialTypeID
                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                        Order BY ConvertedAmount Desc)

        Update MT0621 SET ConvertedAmount = ConvertedAmount + @Detal
        WHERE ProductID = @MaxProductID AND MaterialTypeID = @MaterialTypeID AND ExpenseID = 'COST002'                
            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
    END

/*
---- Phan giam chi gia thanh

---- Tong chi phi
 SET @SUMConvertedAmount = (SELECT SUM(ConvertedAmount) FROM MV9000  WHERE DivisionID =@DivisionID 
                         AND  ExpenseID ='COST002' 
                         AND    PeriodID =@PeriodID 
                         AND MaterialTypeID = @MaterialTypeID AND MV9000.CreditAccountID IN (SELECT AccountID FROM MT0700))        

---- Xac dinh tong he so chung
SET @SUMProductConverted = (SELECT SUM(ISNULL(ConvertedUnit, 0)*ISNULL(MT2222.ProductQuantity, 0))
                FROM MT1603 INNER JOIN MT2222 ON MT2222.ProductID = MT1603.ProductID
                WHERE ApportionID = @ApportionID AND 
                    ExpenseID = 'COST002' AND 
                    MaterialTypeID = @MaterialTypeID)

    SET @ListMaterial_cur  = CURSOR SCROLL KEYSET FOR 
    SELECT MT1603.ProductID, ISNULL(ConvertedUnit, 0)*ISNULL(MT2222.ProductQuantity, 0), MT2222.ProductQuantity, MT2222.UnitID    
    FROM MT1603 INNER JOIN MT2222 ON MT2222.ProductID = MT1603.ProductID
    WHERE ApportionID = @ApportionID AND 
        ExpenseID = 'COST002' AND 
        MaterialTypeID = @MaterialTypeID    
    OPEN @ListMaterial_cur 
    FETCH NEXT FROM @ListMaterial_cur INTO @ProductID, @ProductConvertedUnit, @ProductQuantity, @UnitID    
        WHILE @@Fetch_Status = 0
        BEGIN    
            IF ISNULL(@SUMProductConverted, 0)<>0
            SET      @MaterialConvertedUnit =(ISNULL(@SUMConvertedAmount, 0)/@SUMProductConverted)*ISNULL(@ProductConvertedUnit, 0)
            ELSE     SET      @MaterialConvertedUnit = 0
            IF ISNULL(@ProductQuantity, 0)<>0 
                SET @ConvertedUnit = ISNULL(@MaterialConvertedUnit, 0)/@ProductQuantity
            ELSE 
                SET @ConvertedUnit = 0
        
            update MT0621 SET ConvertedAmount=ConvertedAmount-@MaterialConvertedUnit, ConvertedUnit=ConvertedUnit-@ConvertedUnit, ProductQuantity=ProductQuantity-@ProductQuantity 
             WHERE MaterialID=@MaterialID AND ProductID=@ProductID AND  ExpenseID='COST002' AND  MaterialTypeID=@MaterialTypeID

                FETCH NEXT FROM @ListMaterial_cur INTO @ProductID, @ProductConvertedUnit, @ProductQuantity, @UnitID    
        END            
CLOSE @ListMaterial_cur

*/
GO
