/****** Object:  StoredProcedure [dbo].[MP5204]    Script Date: 12/16/2010 11:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Created BY Hoang Thi Lan
--Date :10/11/2003
--Purpose:Phan bo chi phi Nhan cong theo NVL
-- Edit BY Quoc Hoai

--Edited BY: Vo Thanh Huong, date: 20/05/2005, Xu ly lam tron
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP5204] @DivisionID AS NVARCHAR(50), 
                 @PeriodID AS NVARCHAR(50), 
                 @TranMonth AS INT, 
                 @TranYear AS INT, 
                 @MaterialTypeID AS NVARCHAR(50)
AS 
DECLARE @sSQL AS NVARCHAR(4000), 
        @SUMProductCovalues AS DECIMAL(28, 8), 
        @QuantityUnit AS DECIMAL(28, 8), 
        @ProductCoValues AS DECIMAL(28, 8), 
        @ConvertedUnit AS DECIMAL(28, 8), 
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
        @UnitID AS NVARCHAR(50), @ApportionID AS NVARCHAR(50), 
        @SUMConvertedAmountH AS DECIMAL(28, 8), 
        @ProductHumanRes AS DECIMAL(28, 8), 
        @CoefficientID AS NVARCHAR(50), 
        @ConvertedDecimal INT

SET @ConvertedDecimal = (Select ConvertDecimal FROM MT0000 where DivisionID = @DivisionID)
---- Tong chi phi

---- Buoc 1. Xac dinh he so phan bo dua vao NVL da phan bo
SET @sSQL ='
SELECT MT0621.DivisionID, 
    MT0621.ProductID, 
    SUM(ConvertedUnit) AS ConvertedUnit, 
    MT2222.ProductQuantity, 
    MT2222.UnitID, 
    SUM(ConvertedUnit)*MT2222.ProductQuantity AS ProductCoValues
FROM MT0621 FULL JOIN MT2222 ON MT0621.DivisionID = MT2222.DivisionID AND MT0621.ProductID = MT2222.ProductID
WHERE ExpenseID = ''COST001'' AND MT0621.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
GROUP BY MT0621.DivisionID, MT0621.ProductID, MT2222.UnitID, MT2222.ProductQuantity '

---- Tao VIEW he so chung can phan bo cho san pham
IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV5204' AND Xtype ='V')
    EXEC ('CREATE VIEW MV5204 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV5204 AS '+@sSQL)
/*
--Tao  ra VIEW so 1

SET @sSQL='
SELECT     (CASE WHEN MT1605.InventoryID is NULL then MT2222.ProductID 
        ELSE MT1605.InventoryID END) AS ProductID, 
    ISNULL(CoValue, 0) AS  CoValue, 
    ISNULL(ProductQuantity, 0) AS ProductQuantity, 
     CoValue*ProductQuantity AS ProductCoValues 
FROM MT1605  FULL JOIN MT2222 ON MT2222.ProductID = MT1605.InventoryID
WHERE CoefficientID =N'''+@CoefficientID+''' '

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV6204' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6204 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6204 AS '+@sSQL)


--Duyet  tung mat hang
*/
SET @ConvertedAmount = (SELECT SUM(CASE D_C WHEN 'D' then ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END)
                        FROM MV9000 
                        WHERE PeriodID = @PeriodID AND ExpenseID ='COST002' AND MaterialTypeID =@MaterialTypeID
                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

SET @SUMProductCovalues = (SELECT SUM(ISNULL(ProductCovalues, 0)) FROM MV5204)

SET @ListProduct_cur = CURSOR SCROLL KEYSET FOR 
    SELECT ProductID, ProductQuantity, ProductCoValues
    FROM MV5204        
OPEN @ListProduct_cur
FETCH NEXT FROM @ListProduct_cur INTO @ProductID, @ProductQuantity, @ProductCoValues
            
WHILE @@Fetch_Status = 0
    BEGIN
        IF ISNULL(@SUMProductCoValues, 0) <> 0 AND ISNULL(@ProductQuantity, 0) <> 0
             SET  @ProductHumanRes = ((ISNULL(@ConvertedAmount, 0)/@SUMProductCovalues)*ISNULL(@ProductCoValues, 0))/@ProductQuantity        
        ELSE SET @ProductHumanRes = 0 

        IF @ProductHumanRes <> 0 AND ISNULL(@SUMProductCovalues, 0) <>0 
            INSERT MT0621 (DivisionID, MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit, ProductQuantity, Rate  )
            VALUES (@DivisionID, NULL, @ProductID, @UnitID, 'COST002', NULL, NULL, @MaterialTypeID, Round(((ISNULL(@ConvertedAmount, 0)/@SUMProductCovalues)*ISNULL(@ProductCoValues, 0)), @ConvertedDecimal), @ProductHumanRes, @ProductQuantity, NULL)
                
        FETCH NEXT FROM @ListProduct_cur INTO @ProductID, @ProductQuantity, @ProductCoValues
    END
CLOSE @ListProduct_cur


---- Xu ly lam tron

DECLARE @MaxProductID AS NVARCHAR(50), 
    @Detal DECIMAL(28, 8)

SET @Detal = round(ISNULL(@ConvertedAmount, 0), @ConvertedDecimal) - ISNULL((SELECT SUM(ConvertedAmount) FROM MT0621 
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
