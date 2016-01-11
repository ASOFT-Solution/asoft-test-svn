/****** Object: StoredProcedure [dbo].[MP4622] Script Date: 12/16/2010 11:06:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Created BY Hoàng Thị Lan
--Date 17/12/2003
--Purpose : Chiet tinh gia thanh (NC & SXC)
--Edited BY: Vo Thanh Huong, date : 25/05/2005
--Purpose: Xu ly lam tron
--- Modify on 16/12/2015 by Bảo Anh: Sửa lỗi chia cho 0 khi ProductQuantity = 0
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP4622] 
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
    @ExpenseID AS NVARCHAR(50), 
    @ConvertedAmount1 AS DECIMAL(28, 8), 
    @ConvertedAmount2 AS DECIMAL(28, 8), 
    @ProductQuantity AS DECIMAL(28, 8), 
    @ConvertedDecimal INT 

SELECT @ConvertedDecimal = ConvertDecimal FROM MT0000 where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))

IF @TranMonth >9
    SET @CMonth = LTRIM(RTRIM(STR(@TranMonth)))
ELSE
    SET @CMonth = '0'+LTRIM(RTRIM(STR(@TranMonth)))

SET @CYear =RIGHT(LTRIM(RTRIM(STR(@TranYear))), 2)

--Lay ket qua phan bo chi phi cho doi tuong (NVL)
SET @sSQL ='
SELECT 
    DivisionID, 
    ProductID, 
    MaterialTypeID, 
    ExpenseID, 
    ConvertedAmount, 
    ProductQuantity = (SELECT SUM(MT1001.Quantity) 
                       FROM MT1001 INNER JOIN MT0810 ON MT1001.DivisionID = MT0810.DivisionID AND MT1001.VoucherID = MT0810.VoucherID
                       WHERE MT0810.ResultTypeID = ''R01'' AND MT0810.PeriodID = N'''+ @PeriodID+''' AND ProductID = MT0400.ProductID
                           AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N'''+ @DivisionID+'''))
                       )
    FROM MT0400
    WHERE DivisionID = N'''+@DivisionID+''' AND PeriodID = N'''+ @PeriodID+''' AND ExpenseID IN (''COST002'', ''COST003'') AND
    ProductID IN (SELECT ProductID 
                  FROM MT1001 INNER JOIN MT0810 ON MT1001.DivisionID = MT0810.DivisionID AND MT1001.VoucherID = MT0810.VoucherID
                  WHERE MT0810.ResultTypeID = ''R01'' AND MT0810.PeriodID = N'''+ @PeriodID+''' 
                           AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N'''+ @DivisionID+'''))
                  ) 
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV4622' AND Xtype ='V')
    EXEC ('CREATE VIEW MV4622 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV4622 AS '+@sSQL)

-- Lay hieu so cua do dang dau ky va cuoi ky (NVL)
SET @sSQL ='
SELECT 
    DivisionID, 
    ProductID, 
    MaterialTypeID, 
    ExpenseID, 
    SUM(CASE WHEN Type = ''B'' THEN ProductQuantity ELSE -ProductQuantity END) AS ProductQuantity, 
    SUM(CASE WHEN Type = ''B'' THEN ConvertedAmount ELSE -ConvertedAmount END ) AS ConvertedAmount
FROM MT1613
WHERE PeriodID = N'''+ @PeriodID+''' AND ExpenseID IN (''COST002'', ''COST003'') 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(N'''+ @DivisionID+'''))
GROUP BY DivisionID, ProductID, MaterialTypeID, ExpenseID
'

IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV4722' AND Xtype ='V')
    EXEC ('CREATE VIEW MV4722 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV4722 AS '+@sSQL)

---Chiet tinh

SET @Product_cur = CURSOR SCROLL KEYSET FOR
SELECT 
    ISNULL(V1.ProductID, V2.ProductID ) AS ProductID, 
    ISNULL(V1.MaterialTypeID, V2.MaterialTypeID) AS MaterialTypeID, 
    ISNULL(V1.ExpenseID, V2.ExpenseID) AS ExpenseID, 
    V1.ConvertedAmount, 
    V2.ConvertedAmount, 
    ISNULL( V1.ProductQuantity, V2.ProductQuantity) AS ProductQuantity 
FROM MV4622 V1 Full JOIN MV4722 V2 ON V2.DivisionID = V1.DivisionID 
AND V1.ProductID = V2.ProductID 
AND V1.MaterialTypeID = V2.MaterialTypeID
where V1.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))

OPEN @Product_cur 
FETCH NEXT FROM @Product_cur INTO @ProductID, @MaterialTypeID, @ExpenseID, @ConvertedAmount1, @ConvertedAmount2, @ProductQuantity
WHILE @@Fetch_Status = 0
    BEGIN 
        IF @ProductQuantity <> 0 
            SET @ConvertedUnit = round((ISNULL(@ConvertedAmount1, 0) + ISNULL(@ConvertedAmount2, 0))/@ProductQuantity, @ConvertedDecimal) 
        ELSE
            SET @ConvertedUnit = 0 

        EXEC AP0000 @DivisionID, @DetailCostID OUTPUT, 'MT4000', 'ID', @CMonth, @CYear, 16, 3, 0, '-' 
        
        INSERT INTO MT4000(DetailCostID, PeriodID, ProductID, ExpenseID, MaterialTypeID, ConvertedUnit, VoucherID, CreateDate, DivisionID, TranMonth, TranYear )
        VALUES (@DetailCostID, @PeriodID, @ProductID, @ExpenseID, @MaterialTypeID, @ConvertedUnit, @VoucherID, GetDate(), @DivisionID, @TranMonth, @TranYear)

        FETCH NEXT FROM @Product_cur INTO @ProductID, @MaterialTypeID, @ExpenseID, @ConvertedAmount1, @ConvertedAmount2, @ProductQuantity
    END 
CLOSE @Product_cur

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Xu ly lam tron
DECLARE @Detal AS DECIMAL(28, 8), 
@ID AS NVARCHAR(50)

SET @Product_cur = CURSOR SCROLL KEYSET FOR 
SELECT 
    ExpenseID, 
    ProductID, 
    SUM(ISNULL(ConvertedUnit, 0)) AS ConvertedUnit
FROM MT4000 
WHERE ExpenseID IN ('COST002', 'COST003') AND PeriodID = @PeriodID AND TranMonth = @TranMonth AND TranYear = @TranYear
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
GROUP BY ProductID, ExpenseID

OPEN @Product_cur 
FETCH NEXT FROM @Product_cur INTO @ExpenseID, @ProductID, @ConvertedUnit
WHILE @@Fetch_Status = 0
    BEGIN
        SELECT @Detal =0, @ID = '', @ConvertedAmount1 = 0, @ProductQuantity = 0 
        
        SET @ConvertedAmount1 = (SELECT SUM(ISNULL(ConvertedAmount, 0)) 
                                 FROM (SELECT SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount 
                                       FROM MT0400
                                       WHERE PeriodID = @PeriodID AND ExpenseID= @ExpenseID AND ProductID = @ProductID 
                                           AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                       Union
                                       SELECT SUM(CASE WHEN Type = 'B' THEN ConvertedAmount ELSE (-ConvertedAmount) END ) AS ConvertedAmount
                                       FROM MT1613
                                       WHERE PeriodID = @PeriodID AND ExpenseID= @ExpenseID AND ProductID = @ProductID 
                                           AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                 ) MV)

        SET @ProductQuantity = (SELECT SUM(MT1001.Quantity) 
                                FROM MT1001 INNER JOIN MT0810 ON MT1001.DivisionID = MT0810.DivisionID AND MT1001.VoucherID = MT0810.VoucherID
                                WHERE MT0810.ResultTypeID = 'R01' AND MT0810.PeriodID = @PeriodID AND ProductID = @ProductID
                                    AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

		IF Isnull(@ProductQuantity,0) <> 0
			SET @Detal = round(@ConvertedAmount1/ @ProductQuantity, @ConvertedDecimal) - @ConvertedUnit
		ELSE
			SET @Detal = 0

        IF @Detal<>0
            BEGIN
                SET @ID = (SELECT TOP 1 DetailCostID 
                           FROM MT4000 
                           WHERE ExpenseID = @ExpenseID AND ProductID = @ProductID AND PeriodID = @PeriodID 
                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                           Order BY ConvertedUnit Desc )
                           
                IF @ID is NOT NULL
                    Update MT4000 SET ConvertedUnit = ConvertedUnit + @Detal 
                    WHERE DetailCostID =@ID
                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
            END
        FETCH NEXT FROM @Product_cur INTO @ExpenseID, @ProductID, @ConvertedUnit
    END 

SET @Product_cur = CURSOR SCROLL KEYSET FOR 
SELECT 
    ProductID, 
    SUM(ISNULL(ConvertedUnit, 0)) AS ConvertedUnit
FROM MT4000 
WHERE PeriodID = @PeriodID AND TranMonth = @TranMonth AND TranYear = @TranYear
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
GROUP BY ProductID

OPEN @Product_cur 
FETCH NEXT FROM @Product_cur INTO @ProductID, @ConvertedUnit
WHILE @@Fetch_Status = 0
    BEGIN
        SELECT @Detal =0, @ID = '', @ConvertedAmount1 = 0, @ProductQuantity = 0 
        
        SET @ConvertedAmount1 =(SELECT SUM(ISNULL(ConvertedAmount, 0)) 
                                FROM(SELECT SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount 
                                     FROM MT0400
                                     WHERE PeriodID = @PeriodID AND ProductID = @ProductID
                                           AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                     Union
                                     SELECT SUM(CASE WHEN Type = 'B' THEN ConvertedAmount ELSE (-ConvertedAmount) END ) AS ConvertedAmount
                                     FROM MT1613
                                     WHERE PeriodID = @PeriodID AND ProductID = @ProductID 
                                           AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                ) MV)

        SET @ProductQuantity = (SELECT SUM(MT1001.Quantity) 
                                FROM MT1001 INNER JOIN MT0810 ON MT1001.DivisionID = MT0810.DivisionID AND MT1001.VoucherID = MT0810.VoucherID
                                WHERE MT0810.ResultTypeID = 'R01' AND MT0810.PeriodID = @PeriodID AND ProductID = @ProductID
                                    AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                )
		IF Isnull(@ProductQuantity,0) <> 0
			SET @Detal = round(@ConvertedAmount1/ @ProductQuantity, @ConvertedDecimal) - @ConvertedUnit
		ELSE
			SET @Detal = 0
			
        IF @Detal<>0
            BEGIN
                SET @ID = (SELECT TOP 1 DetailCostID 
                           FROM MT4000 
                           WHERE ProductID = @ProductID AND PeriodID = @PeriodID 
                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                           Order BY ConvertedUnit Desc)
                IF @ID is NOT NULL
                    Update MT4000 SET ConvertedUnit = ConvertedUnit + @Detal 
                    WHERE DetailCostID =@ID
                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
            END
        FETCH NEXT FROM @Product_cur INTO @ProductID, @ConvertedUnit
    END
