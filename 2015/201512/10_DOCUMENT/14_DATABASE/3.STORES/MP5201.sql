IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP5201]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP5201]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created BY Nguyen Van Nhan  Date: 06/11/2003
---- Purpose: Phan bo nhan cong theo PP  truc tiep
-- Edit BY Quoc Hoai
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

CREATE Procedure [dbo].[MP5201]     
                @DivisionID AS NVARCHAR(50), @PeriodID AS NVARCHAR(50), 
                @TranMonth AS INT, @TranYear AS INT, 
                @MaterialTypeID AS NVARCHAR(50) 
                
AS 
DECLARE @sSQL AS NVARCHAR(4000), 
        @SUMProductCovalues AS DECIMAL(28, 8),     
        @ProductID AS NVARCHAR(50), 
        @ProductQuantity AS DECIMAL(28, 8), 
        @ProductCovalues AS DECIMAL(28, 8), 
        @ListMaterial_cur AS CURSOR, 
        @MaterialID AS NVARCHAR(50), 
        @MaterialQuantity AS DECIMAL(28, 8), 
        @ConvertedAmount AS DECIMAL(28, 8), 
        @QuantityUnit AS DECIMAL(28, 8), 
        @ConvertedUnit AS DECIMAL(28, 8), 
        @UnitID AS NVARCHAR(50), 
        @ConvertedDecimal INT

SET @ConvertedDecimal = (SELECT ConvertDecimal FROM MT0000 WHERE DivisionID=@DivisionID)


SET @sSQL='
SELECT DivisionID, 
    SUM( CASE D_C WHEN ''D'' then ISNULL(Quantity, 0) ELSE - ISNULL(Quantity, 0) END) AS MaterialQuantity, 
    SUM( CASE D_C WHEN ''D'' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
    ProductID
FROM MV9000       ---INNER JOIN MT0700 ON MV9000.DebitAccountID = MT0700.AccountID
WHERE PeriodID = N'''+@PeriodID+''' AND ExpenseID =''COST002'' AND ISNULL(ProductID, '''')<>'''' AND MaterialTypeID =N'''+@MaterialTypeID+''' 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
GROUP BY  DivisionID, ProductID'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5201' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5201 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5201 AS '+@sSQL)

SET @ListMaterial_cur  = CURSOR SCROLL KEYSET FOR 
SELECT round(MV5201.ConvertedAmount, @ConvertedDecimal), MV5201.ProductID, MT2222.ProductQuantity, MT2222.UnitID
FROM MV5201 LEFT JOIN MT2222 ON MV5201.DivisionID  = MT2222.DivisionID AND MV5201.ProductID  = MT2222.ProductID 

OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
WHILE @@Fetch_Status = 0
    BEGIN    
        ---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
        IF ISNULL(@ProductQuantity, 0)<>0 
              SET @ConvertedUnit =ISNULL(@ConvertedAmount, 0)/@ProductQuantity
        ELSE SET @ConvertedUnit = 0
        
        --INSERT vao bang MT0612
        --IF ISNULL(@SUMProductCovalues, 0) <>0 
        INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
        VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST002', 0, 0, @MaterialTypeID, @ConvertedAmount, @ConvertedUnit, @ProductQuantity, NULL)
        
        FETCH NEXT FROM @ListMaterial_cur INTO @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
    END
CLOSE @ListMaterial_cur


---- Xu ly lam tron

DECLARE @MaxProductID AS NVARCHAR(50), 
    @Detal DECIMAL(28, 8)
SET @ConvertedAmount = (SELECT SUM( CASE D_C WHEN 'D' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount
                        FROM MV9000       ---INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
                        WHERE PeriodID = @PeriodID AND ExpenseID = 'COST002' AND ISNULL(ProductID, '') <> '' AND MaterialTypeID = @MaterialTypeID
                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

SET @Detal = round(ISNULL(@ConvertedAmount, 0), 0) - ISNULL((SELECT SUM(ConvertedAmount) FROM MT0621 
                                                             WHERE MaterialTypeID = @MaterialtypeID AND ExpenseID = 'COST002'
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
---- Phan giam chi phi gia thanh
SET @sSQL='

SELECT    SUM(ISNULL(Quantity, 0)) AS MaterialQuantity, 
    SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount, 
    ProductID

 FROM MV9000 INNER JOIN MT0700 ON MV9000.CreditAccountID=MT0700.AccountID
WHERE DivisionID =N'''+@DivisionID+''' AND
    PeriodID = N'''+@PeriodID+''' AND
    ExpenseID =''COST002'' AND
    ISNULL(ProductID, '''')<>'''' AND 
    MaterialTypeID =N'''+@MaterialTypeID+''' 
GROUP BY  ProductID  '

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5201' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5201 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5201 AS '+@sSQL)

SET @ListMaterial_cur  = CURSOR SCROLL KEYSET FOR 
    SELECT MV5201.ConvertedAmount, MV5201.ProductID, MT2222.ProductQuantity, MT2222.UnitID
        FROM MV5201 LEFT JOIN MT2222 ON MV5201.ProductID  = MT2222.ProductID 
        OPEN @ListMaterial_cur 
        FETCH NEXT FROM @ListMaterial_cur INTO @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
        WHILE @@Fetch_Status = 0
            BEGIN    
                ---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
                IF ISNULL(@ProductQuantity, 0)<>0 
                      SET @ConvertedUnit =ISNULL(@ConvertedAmount, 0)/@ProductQuantity
                ELSE SET @ConvertedUnit = 0
                
                --INSERT vao bang MT0612
                --IF ISNULL(@SUMProductCovalues, 0) <>0 

                Update MT0621 SET  ConvertedAmount= ConvertedAmount-@ConvertedAmount, ProductQuantity=ProductQuantity-@ProductQuantity, ConvertedUnit=ConvertedUnit-@ConvertedUnit
                        WHERE MaterialID=@MaterialID AND ProductID=@ProductID AND  ExpenseID='COST002' AND  MaterialTypeID=@MaterialTypeID

                
                FETCH NEXT FROM @ListMaterial_cur INTO @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
            END
        CLOSE @ListMaterial_cur

*/

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
