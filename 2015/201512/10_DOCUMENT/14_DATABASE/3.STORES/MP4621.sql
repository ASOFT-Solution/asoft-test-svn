/****** Object: StoredProcedure [dbo].[MP4621] Script Date: 12/16/2010 11:04:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Created BY: Hoang Thi Lan
--Date 17/12/2003
--Purpose : Chiet tinh gia thanh (NVL)
--Edit BY: Vo Thanh Huong, date: 25/05/2005, xu ly lam tron 
--- Modify on 16/12/2015 by Bảo Anh: Sửa lỗi chia cho 0 khi ProductQuantity = 0
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP4621] 
    @DivisionID AS NVARCHAR(50), 
    @PeriodID AS NVARCHAR(50), 
    @VoucherID AS NVARCHAR(50), 
    @TranMonth AS INT, 
    @TranYear AS INT
AS

DECLARE 
    @sSQL AS NVARCHAR(4000), 
    @DetailCostID AS NVARCHAR(50), 
    @Product_cur AS CURSOR, 
    @ProductID AS NVARCHAR(50), 
    @MaterialTypeID AS NVARCHAR(50), 
    @MaterialID AS NVARCHAR(50), 
    @QuantityUnit AS DECIMAL(28, 8), 
    @ConvertedUnit AS DECIMAL (28, 8), 
    @CMonth AS NVARCHAR(50), 
    @CYear AS NVARCHAR(50), 
    @ProductQuantity1 AS DECIMAL(28, 8), 
    @ProductQuantity2 AS DECIMAL(28, 8), 
    @ConvertedAmount1 AS DECIMAL(28, 8), 
    @ConvertedAmount2 AS DECIMAL(28, 8), 
    @MaterialQuantity1 AS DECIMAL(28, 8), 
    @MaterialQuantity2 AS DECIMAL(28, 8), 
    @ConvertedDecimal INT

SELECT @ConvertedDecimal = ConvertDecimal FROM MT0000 where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))

IF @TranMonth >9
    SET @CMonth = LTRIM(RTRIM(STR(@TranMonth)))
ELSE
    SET @CMonth = '0'+LTRIM(RTRIM(STR(@TranMonth)))

SET @CYear =RIGHT(LTRIM(RTRIM(STR(@TranYear))), 2)

----Lay ket qua chi phi phan bo chi phi cho doi tuong NVL
SET @sSQL ='
SELECT 
    DivisionID, 
    ProductID, 
    MaterialTypeID, 
    MaterialID, 
    ISNULL(ConvertedAmount, 0) AS ConvertedAmount, 
    ISNULL(MaterialQuantity, 0) AS MaterialQuantity, 
    ProductQuantity = ISNULL((SELECT SUM(MT1001.Quantity) 
                              FROM MT1001 INNER JOIN MT0810 ON MT1001.DivisionID = MT0810.DivisionID AND MT1001.VoucherID = MT0810.VoucherID
                              WHERE MT0810.ResultTypeID = ''R01'' 
                                    AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N''' + @DivisionID + '''))
                                    AND MT0810.PeriodID = N'''+ @PeriodID+''' 
                                    AND MT1001.ProductID = MT0400.ProductID), 0)
FROM MT0400
WHERE PeriodID = N'''+@PeriodID+''' 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N''' + @DivisionID + '''))
    AND ExpenseID = ''COST001'' 
    AND ProductID IN (SELECT ProductID 
                      FROM MT1001 INNER JOIN MT0810 ON MT1001.VoucherID = MT0810.VoucherID
                      WHERE MT0810.ResultTypeID = ''R01'' 
                            AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N''' + @DivisionID + '''))
                            AND MT0810.PeriodID = N''' + @PeriodID + ''')
'

IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV4621' AND Xtype ='V')
    DROP VIEW MV4621
EXEC ('CREATE VIEW MV4621 AS '+@sSQL)

--Lay hieu so cua do dang dau ky va cuoi ky NVL
/*
SET @sSQL ='
SELECT ProductID, MaterialTypeID, MaterialID, 
SUM(CASE WHEN Type = ''B'' THEN ProductQuantity ELSE (-ProductQuantity) END) AS ProductQuantity, 
SUM (CASE WHEN Type=''B'' THEN MaterialQuantity ELSE (-MaterialQuantity) END) AS MaterialQuantity, 
SUM(CASE WHEN Type = ''B'' THEN ConvertedAmount ELSE (-ConvertedAmount) END ) AS ConvertedAmount
FROM MT1613
WHERE DivisionID = '''+@DivisionID+''' AND PeriodID = '''+@PeriodID+''' AND ExpenseID = ''COST001'' 
GROUP BY ProductID, MaterialTypeID, MaterialID'
*/

SET @sSQL ='
SELECT 
    MT1613.DivisionID, 
    MT1613.ProductID, 
    MaterialTypeID, 
    MaterialID, 
    avg(MT0810.ProductQuantity) AS ProductQuantity, 
    SUM (CASE WHEN Type=''B'' THEN MaterialQuantity ELSE (-MaterialQuantity) END) AS MaterialQuantity, 
    SUM(CASE WHEN Type = ''B'' THEN ConvertedAmount ELSE (-ConvertedAmount) END ) AS ConvertedAmount
FROM MT1613 LEFT JOIN (SELECT SUM (MT1001.Quantity) AS ProductQuantity, ProductID
                       FROM MT1001 INNER JOIN MT0810 ON Mt1001.VoucherID = MT0810.VoucherID
                       WHERE MT0810.ResultTypeID = ''R01'' 
                            AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N''' + @DivisionID + '''))
                            AND MT0810.PeriodID = N''' + @PeriodID + ''' 
                       GROUP BY ProductID) MT0810 ON MT0810.ProductID = MT1613.ProductID 

WHERE PeriodID = N'''+@PeriodID+''' 
    AND MT1613.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N''' + @DivisionID + '''))
    AND ExpenseID = ''COST001'' 
GROUP BY MT1613.DivisionID, MT1613.ProductID, MaterialTypeID, MaterialID'

IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV4721' AND Xtype ='V')
    DROP VIEW MV4721
EXEC ('CREATE VIEW MV4721 AS '+@sSQL)

---Chiet tinh
SET @Product_cur = CURSOR SCROLL KEYSET FOR
SELECT 
    ISNULL(V1.ProductID, V2.ProductID ) AS ProductID, 
    ISNULL(V1.MaterialTypeID, V2.MaterialTypeID) AS MaterialTypeID, 
    ISNULL(V1.MaterialID, V2.MaterialID) AS MaterialID, 
    ISNULL(V1.ProductQuantity, V2.ProductQuantity) AS ProductQuantity1, --V1.ProductQuantity AS ProductQuantity1, 
    V2.ProductQuantity AS ProductQuantity2, 
    V1.ConvertedAmount AS ConvertedAmount1, 
    V2.ConvertedAmount AS ConvertedAmount2, 
    V1.MaterialQuantity AS MaterialQuantity1, 
    V2.MaterialQuantity AS MaterialQuantity2
FROM MV4621 V1 Full JOIN MV4721 V2 ON V1.DivisionID = V2.DivisionID AND V1.ProductID = V2.ProductID 
    AND V1.MaterialTypeID = V2.MaterialTypeID
    AND V1.MaterialID = V2.MaterialID
	where V1.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))

OPEN @Product_cur 
FETCH NEXT FROM @Product_cur INTO @ProductID, @MaterialTypeID, @MaterialID, @ProductQuantity1, @ProductQuantity2, @ConvertedAmount1, @ConvertedAmount2, @MaterialQuantity1, @MaterialQuantity2
WHILE @@Fetch_Status = 0
    BEGIN 
        IF Isnull(@ProductQuantity1,0) <> 0
            BEGIN
                SET @QuantityUnit = (ISNULL(@MaterialQuantity1, 0) +ISNULL(@MaterialQuantity2, 0))/@ProductQuantity1
                SET @ConvertedUnit = round((ISNULL(@ConvertedAmount1, 0) +ISNULL(@ConvertedAmount2, 0))/@ProductQuantity1, @ConvertedDecimal)
            END
        ELSE 
            BEGIN
                SET @QuantityUnit = 0
                SET @ConvertedUnit = 0
            END
            
        EXEC AP0000 @DivisionID, @DetailCostID OUTPUT, 'MT4000', 'ID', @CMonth, @CYear, 16, 3, 0, '-' 
        
        INSERT INTO MT4000 (DetailCostID, PeriodID, ProductID, ExpenseID, MaterialTypeID, MaterialID, ProductUnitID, MaterialUnitID, ConvertedUnit, QuantityUnit, VoucherID, CreateDate, DivisionID, TranMonth, TranYear)
        VALUES (@DetailCostID, @PeriodID, @ProductID, 'COST001', @MaterialTypeID, @MaterialID, NULL, NULL, @ConvertedUnit, @QuantityUnit, @VoucherID, GetDate(), @DivisionID, @TranMonth, @TranYear)

        FETCH NEXT FROM @Product_cur INTO @ProductID, @MaterialTypeID, @MaterialID, @ProductQuantity1, @ProductQuantity2, @ConvertedAmount1, @ConvertedAmount2, @MaterialQuantity1, @MaterialQuantity2
    END 
CLOSE @Product_cur
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Xu ly lam tron
DECLARE @Detal AS DECIMAL(28, 8), 
@ID AS NVARCHAR(50)

SET @Product_cur = CURSOR SCROLL KEYSET FOR 
SELECT 
    ProductID, 
    MaterialTypeID, 
    SUM(ISNULL(ConvertedUnit, 0)) AS ConvertedUnit
FROM MT4000 
WHERE ExpenseID ='COST001' 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
    AND PeriodID = @PeriodID 
    AND TranMonth = @TranMonth 
    AND TranYear = @TranYear
GROUP BY ProductID, MaterialTypeID


OPEN @Product_cur 
FETCH NEXT FROM @Product_cur INTO @ProductID, @MaterialTypeID, @ConvertedUnit
WHILE @@Fetch_Status = 0
    BEGIN
        SELECT @Detal =0, @ID = '', @ConvertedAmount1 = 0, @ProductQuantity1 = 0 
        
        SET @ConvertedAmount1 = (SELECT SUM(ISNULL(ConvertedAmount, 0)) 
                                 FROM(SELECT SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount 
                                      FROM MT0400
                                      WHERE PeriodID = @PeriodID AND ExpenseID = 'COST001' AND ProductID = @ProductID AND MaterialTypeID = @MaterialTypeID
                                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                      Union
                                      SELECT SUM(CASE WHEN Type = 'B' THEN ConvertedAmount ELSE (-ConvertedAmount) END ) AS ConvertedAmount
                                      FROM MT1613
                                      WHERE PeriodID = @PeriodID AND ExpenseID = 'COST001' AND ProductID = @ProductID AND MaterialTypeID = @MaterialTypeID
                                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                      ) MV)

        SET @ProductQuantity1 = (SELECT SUM(MT1001.Quantity) 
                                 FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT1001.VoucherID = MT0810.VoucherID
                                 WHERE MT0810.ResultTypeID = 'R01' AND MT0810.PeriodID = @PeriodID AND ProductID = @ProductID
                                        AND MT0810.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
		IF Isnull(@ProductQuantity1,0) <> 0
			SET @Detal = round(@ConvertedAmount1/ @ProductQuantity1, @ConvertedDecimal) - @ConvertedUnit
		ELSE
			SET @Detal = 0

        IF @Detal<>0
            BEGIN
                SET @ID = (SELECT TOP 1 DetailCostID 
                           FROM MT4000 
                           WHERE MaterialTypeID = @MaterialTypeID AND ExpenseID = 'COST001' AND ProductID = @ProductID AND PeriodID = @PeriodID 
                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                           Order BY ConvertedUnit Desc )

                IF @ID is NOT NULL
                    Update MT4000 
                    SET ConvertedUnit = ConvertedUnit + @Detal 
                    WHERE DetailCostID =@ID
                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
            END
        FETCH NEXT FROM @Product_cur INTO @ProductID, @MaterialTypeID, @ConvertedUnit
    END 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET @Product_cur = CURSOR SCROLL KEYSET FOR 
SELECT ProductID, SUM(ISNULL(ConvertedUnit, 0)) AS ConvertedUnit
FROM MT4000 
WHERE ExpenseID = 'COST001' AND PeriodID = @PeriodID AND TranMonth = @TranMonth AND TranYear = @TranYear
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
GROUP BY ProductID

OPEN @Product_cur 
FETCH NEXT FROM @Product_cur INTO @ProductID, @ConvertedUnit
WHILE @@Fetch_Status = 0
    BEGIN
        SELECT @Detal =0, @ID = '', @ConvertedAmount1 = 0, @ProductQuantity1 = 0 
        
        SET @ConvertedAmount1 = (SELECT SUM(ISNULL(ConvertedAmount, 0)) 
                                 FROM(SELECT SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount 
                                      FROM MT0400
                                      WHERE PeriodID = @PeriodID AND ExpenseID = 'COST001' AND ProductID = @ProductID 
                                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                      Union
                                      SELECT SUM(CASE WHEN Type = 'B' THEN ConvertedAmount ELSE (-ConvertedAmount) END ) AS ConvertedAmount
                                      FROM MT1613
                                      WHERE PeriodID = @PeriodID AND ExpenseID = 'COST001' AND ProductID = @ProductID 
                                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                      ) MV)

        SET @ProductQuantity1 = (SELECT SUM(MT1001.Quantity) 
                                 FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT1001.VoucherID = MT0810.VoucherID
                                 WHERE MT0810.ResultTypeID = 'R01' AND MT0810.PeriodID = @PeriodID AND ProductID = @ProductID 
                                            AND MT0810.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
		IF Isnull(@ProductQuantity1,0) <> 0
			SET @Detal = round(@ConvertedAmount1/ @ProductQuantity1 - @ConvertedUnit, @ConvertedDecimal)
		ELSE
			SET @Detal = 0

        IF @Detal<>0
            BEGIN
                SET @ID = (SELECT TOP 1 DetailCostID 
                           FROM MT4000 
                           WHERE ExpenseID = 'COST001' AND ProductID = @ProductID AND PeriodID = @PeriodID 
                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                           Order BY ConvertedUnit Desc )

                IF @ID is NOT NULL
                    Update MT4000 SET ConvertedUnit = ConvertedUnit + @Detal 
                    WHERE DetailCostID =@ID
                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
            END
        FETCH NEXT FROM @Product_cur INTO @ProductID, @ConvertedUnit
    END 

/*
SET @ListMaterial_cur = CURSOR SCROLL KEYSET FOR 
SELECT MV5101.MaterialID, MV5101.MaterialQuantity, round(MV5101.ConvertedAmount, @ConvertedDecimal), MV5101.ProductID, MT2222.ProductQuantity, MT2222.UnitID
FROM MV5101 LEFT JOIN MT2222 ON MV5101.ProductID = MT2222.ProductID 
OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
WHILE @@Fetch_Status = 0
BEGIN 

IF ISNULL(@ProductQuantity, 0)<>0 
SET @QuantityUnit = ISNULL(@MaterialQuantity, 0)/@ProductQuantity 
ELSE SET @QuantityUnit =0
---- Phan bo thanh tien chi phi mot nguyen vat lieu cho mot san pham
IF ISNULL(@ProductQuantity, 0)<>0 
SET @ConvertedUnit =ISNULL(@ConvertedAmount, 0)/@ProductQuantity
ELSE SET @ConvertedUnit = 0

--INSERT vao bang MT0612
--IF ISNULL(@SumProductCovalues, 0) <>0 

INSERT MT0621 (MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, 
ConvertedAmount, ConvertedUnit, ProductQuantity, Rate )
VALUES (@MaterialID, @ProductID, @UnitID, 'COST001', @MaterialQuantity, @QuantityUnit, @MaterialTypeID, 
@ConvertedAmount, @ConvertedUnit, @ProductQuantity, NULL)

FETCH NEXT FROM @ListMaterial_cur INTO @MaterialID, @MaterialQuantity, @ConvertedAmount, @ProductID, @ProductQuantity, @UnitID
END
CLOSE @ListMaterial_cur
CLOSE @ListMaterial_cur
---- Xu ly lam tron
DECLARE @Detal AS DECIMAL(28, 8), 
@ID AS DECIMAL(28, 8)

SET @ListMaterial_cur = CURSOR SCROLL KEYSET FOR 
SELECT ISNULL(MaterialID, ''), SUM(Quantity) AS Quantity, SUM(ConvertedAmount) AS ConvertedAmount 
FROM MT0621 WHERE MaterialTypeID =@MaterialTypeID AND ExpenseID ='COST001'
GROUP BY ISNULL(MaterialID, '')
OPEN @ListMaterial_cur 
FETCH NEXT FROM @ListMaterial_cur INTO @MaterialID, @MaterialQuantity, @ConvertedAmount
WHILE @@Fetch_Status = 0
BEGIN
SELECT @Detal =0, @ID = NULL, 
@Detal = round(ISNULL( (SELECT SUM( CASE D_C WHEN 'D' THEN ISNULL(ConvertedAmount, 0) ELSE - ISNULL(ConvertedAmount, 0) END) 
FROM MV9000 --- INNER JOIN MT0700 ON MV9000.DebitAccountID=MT0700.AccountID
WHERE PeriodID =@PeriodID AND DivisionID =@DivisionID AND ExpenseID ='COST001' AND
ISNULL(ProductID, '')<>'' AND 
MaterialTypeID = @MaterialTypeID AND ISNULL(InventoryID, '') = @MaterialID), 0), @ConvertedDecimal) - @ConvertedAmount
IF @Detal<>0
BEGIN
SET @ID = (SELECT TOP 1 ID FROM MT0621 WHERE MaterialTypeID =@MaterialTypeID AND ExpenseID = 'COST001' AND ISNULL(MaterialID, '') = @MaterialID Order BY ConvertedAmount Desc )
IF @ID is NOT NULL
Update MT0621 SET ConvertedAmount = ConvertedAmount + @Detal 
WHERE ID =@ID
END
FETCH NEXT FROM @ListMaterial_cur INTO @MaterialID, @MaterialQuantity, @ConvertedAmount
END 
*/
