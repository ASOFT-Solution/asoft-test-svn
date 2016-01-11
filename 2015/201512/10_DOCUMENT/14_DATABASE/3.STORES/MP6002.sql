/****** Object: StoredProcedure [dbo].[MP6002] Script Date: 12/16/2010 13:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan
--Date 6/12/2003
--Purpose:Ph©n bæ chi phÝ cho ®èi t­îng (Theo chi phÝ cÊu thµnh)
--Edit BY Quoc Hoai, Quoc Huy.
--Last Edit BY Nguyen Van Nhan, Date 23/09/2004
--Edit BY: Dang Le Bao Quynh; Date 06/08/2008
--Purpose: Loai tru cac but toan da duoc phan bo ra khoi bo du lieu lam ty trong

ALTER PROCEDURE [dbo].[MP6002] 
    @DivisionID AS NVARCHAR(50), 
    @PeriodID AS NVARCHAR(50), 
    @CMonth AS INT, 
    @CYear AS INT, 
    @VoucherID AS NVARCHAR(50), 
    @BatchID AS NVARCHAR(50), 
    @TranMonth AS INT, 
    @TranYear AS INT
AS 

DECLARE 
    @sSQL AS NVARCHAR(4000), 
    @SumTotal AS DECIMAL(28, 8), 
    @ChildPeriodID_Cur AS CURSOR, 
    @ChildPeriodID AS NVARCHAR(50), 
    @ConvertedAmount AS DECIMAL(28, 8), 
    @PeriodConv AS DECIMAL(28, 8), 
    @ChildConv AS DECIMAL(28, 8), 
    @ExpenseID AS NVARCHAR(50), 
    @MaterialTypeID AS NVARCHAR(50), 
    @TransactionID AS NVARCHAR(50), 
    @PeriodID_Cur AS CURSOR, 
    @ConvertedDecimal AS DECIMAL(28, 8), 
    @DebitAccountID AS NVARCHAR(50), 
    @CreditAccountID AS NVARCHAR(50), 
    @Quantity AS DECIMAL(28, 8), 
    @QuantityConv AS DECIMAL(28, 8), 
    @SumQuantity AS DECIMAL(28, 8), 
    @ChildQConv AS DECIMAL(28, 8), 
    @InventoryID AS NVARCHAR(50), 
    @CurrencyID AS NVARCHAR(50), 
    @ExchangeRate AS MONEY

SELECT @ConvertedDecimal = ConvertDecimal FROM MT0000 WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
SET @ConvertedDecimal = ISNULL(@ConvertedDecimal, 2)

--Lay ra he so chi phi 
SET @sSQL = '
SELECT 
    MT1610.DivisionID, 
    MT1609.PeriodID, 
    MT1609.ChildPeriodID, 
    SUM(ConvertedAmount) AS ConvertedAmount, 
    SUM(Quantity) AS Quantity 
FROM MT1610 
    INNER JOIN MT1609 ON MT1609.DivisionID = MT1610.DivisionID AND MT1610.PeriodID = MT1609.PeriodID
    INNER JOIN MV9000 ON MV9000.DivisionID = MT1610.DivisionID AND MV9000.MaterialTypeID = MT1610.MaterialTypeID AND MV9000.PeriodID = MT1609.ChildPeriodID 
WHERE ISNULL(MV9000.VoucherNo, '''') <> '''' 
    AND MT1610.IsUse = 1 
    AND MT1610.PeriodID = N''' + @PeriodID + ''' 
    AND MV9000.TranMonth = ' + str(@TranMonth) + ' 
    AND MV9000.TranYear = ' + str(@TranYear) + ' 
    AND MV9000.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID + '''))
GROUP BY MT1610.DivisionID, MT1609.PeriodID, MT1609.ChildPeriodID
'
IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV6002' AND Xtype = 'V')
    EXEC ('CREATE VIEW MV6002 AS ' + @sSQL)
ELSE
    EXEC ('ALTER VIEW MV6002 AS ' + @sSQL)

SET @SumQuantity = (SELECT SUM(ISNULL(MV9000.Quantity, 0)) 
FROM MV9000 
WHERE PeriodID = @PeriodID 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))) 

SET @ChildPeriodID_Cur = CURSOR SCROLL KEYSET FOR 
SELECT ChildPeriodID, SUM(ConvertedAmount) AS ConvertedAmount, SUM(ISNULL(Quantity, 0)) AS Quantity 
FROM MV6002
GROUP BY ChildPeriodID

OPEN @ChildPeriodID_Cur
FETCH NEXT FROM @ChildPeriodID_Cur INTO @ChildPeriodID, @ConvertedAmount, @Quantity
WHILE @@Fetch_Status = 0
BEGIN
    --Phan bo chi ohi SXC
    --Lấy tổng tiền của đối tượng cha
    SET @PeriodID_Cur = CURSOR SCROLL KEYSET FOR
    SELECT SUM(ISNULL(ConvertedAmount, 0)), SUM(ISNULL(Quantity, 0)), MaterialTypeID, DebitAccountID, CreditAccountID, CurrencyID, ExchangeRate
    FROM MV9000
    WHERE PeriodID = @PeriodID AND ExpenseID = 'COST003' AND ISNULL(MaterialTypeID, '') <> ''
        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
    GROUP BY MaterialTypeID, DebitAccountID, CreditAccountID, CurrencyID, ExchangeRate 
    
    OPEN @PeriodID_Cur
    FETCH NEXT FROM @PeriodID_Cur INTO @PeriodConv, @QuantityConv, @MaterialTypeID, @DebitAccountID, @CreditAccountID, @CurrencyID, @ExchangeRate
    WHILE @@Fetch_Status = 0
    BEGIN
        --Lấy tổng tiền của các đối tượng con
        SET @SumTotal = (SELECT SUM(MV6002.ConvertedAmount) FROM MV6002 WHERE PeriodID = @PeriodID)

        IF (@SumTotal<>0)
            BEGIN
                SET @ChildConv = (ISNULL(@PeriodConv, 0) * ISNULL(@ConvertedAmount, 0))/@SumTotal
                SET @ChildQConv = (ISNULL(@PeriodConv, 0) * ISNULL(@SumQuantity, 0))/@SumTotal
            END
        ELSE 
            BEGIN
                SET @ChildConv = 0 
                SET @ChildQConv = 0 
            END

        SET @ChildConv = round(@ChildConv, @ConvertedDecimal) 

        EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'MT9000', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

        INSERT MT9000 (ParentPeriodID, VoucherID, BatchID, DivisionID, TransactionID, ExpenseID, MaterialTypeID, OriginalAmount, ConvertedAmount, PeriodID, Status, CreateDate, IsFromPeriodID, DebitAccountID, CreditAccountID, transactiontypeID, TranMonth, TranYear, Quantity, CurrencyID, ExchangeRate )
        VALUES (@PeriodID, @VoucherID, @BatchID, @DivisionID, @TransactionID, 'COST003', @MaterialTypeID, @ChildConv, @ChildConv, @ChildPeriodID, 0, GETDATE(), 1, @DebitAccountID, @CreditAccountID, ' ', @TranMonth, @TranYear, @ChildQConv, @CurrencyID, @ExchangeRate)

        FETCH NEXT FROM @PeriodID_Cur INTO @PeriodConv, @QuantityConv, @MaterialTypeID, @DebitAccountID, @CreditAccountID, @CurrencyID, @ExchangeRate
    END 
    CLOSE @PeriodID_Cur

    --------------------------------------------------------------------------------------------------------------------------------
    ---- Phan bo chi phi nhan cong 
    --Lấy tổng tiền của đối tượng cha
    --Lấy ra hệ số chi phí 

    SET @PeriodID_Cur = CURSOR SCROLL KEYSET FOR
    SELECT SUM(ConvertedAmount), SUM(ISNULL(Quantity, 0)), MaterialTypeID, DebitAccountID, CreditAccountID, CurrencyID, ExchangeRate 
    FROM MV9000
    WHERE PeriodID = @PeriodID AND ExpenseID = 'COST002' AND ISNULL(MaterialTypeID, '') <> ''
        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
    GROUP BY MaterialTypeID, DebitAccountID, CreditAccountID, CurrencyID, ExchangeRate 
    
    OPEN @PeriodID_Cur
    FETCH NEXT FROM @PeriodID_Cur INTO @PeriodConv, @QuantityConv, @MaterialTypeID, @DebitAccountID, @CreditAccountID, @CurrencyID, @ExchangeRate
    WHILE @@Fetch_Status = 0
    BEGIN
        --LÊy tæng tiÒn cña c¸c ®èi t­îng con
        SET @SumTotal = (SELECT SUM(MV6002.ConvertedAmount) FROM MV6002 WHERE PeriodID = @PeriodID)

        IF (@SumTotal<>0)
            BEGIN
                SET @ChildConv = (ISNULL(@PeriodConv, 0) * ISNULL(@ConvertedAmount, 0))/@SumTotal
                SET @ChildQConv = (ISNULL(@PeriodConv, 0) * ISNULL(@SumQuantity, 0))/@SumTotal
            END
        ELSE 
            BEGIN
                SET @ChildConv = 0 
                SET @ChildQConv = 0 
            END

        SET @ChildConv = round(@ChildConv, @ConvertedDecimal) 
        SET @ChildQConv = round(@ChildQConv, @ConvertedDecimal)
        EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'MT9000', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

        INSERT MT9000 (ParentPeriodID, VoucherID, BatchID, DivisionID, TransactionID, ExpenseID, MaterialTypeID, ConvertedAmount, PeriodID, Status, CreateDate, IsFromPeriodID, DebitAccountID, CreditAccountID, transactiontypeID, TranMonth, TranYear, Quantity, CurrencyID, ExchangeRate )
        VALUES (@PeriodID, @VoucherID, @BatchID, @DivisionID, @TransactionID, 'COST002', @MaterialTypeID, @ChildConv, @ChildPeriodID, 0, GETDATE(), 1, @DebitAccountID, @CreditAccountID, ' ', @TranMonth, @TranYear, @ChildQConv, @CurrencyID, @ExchangeRate)

        FETCH NEXT FROM @PeriodID_Cur INTO @PeriodConv, @QuantityConv, @MaterialTypeID, @DebitAccountID, @CreditAccountID, @CurrencyID, @ExchangeRate 
    END 
    CLOSE @PeriodID_Cur

----------------------------- =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  =  = ----------------------
----- Phan bo chi phi NVL
--Lấy tổng tiền của đối tượng cha
--Lấy ra hệ số chi phí 
    SET @PeriodID_Cur = CURSOR SCROLL KEYSET FOR
    SELECT SUM(ConvertedAmount), SUM(ISNULL(Quantity, 0)), MaterialTypeID, DebitAccountID, CreditAccountID, InventoryID, CurrencyID, ExchangeRate 
    FROM MV9000
    WHERE PeriodID = @PeriodID AND ExpenseID = 'COST001' AND ISNULL(MaterialTypeID, '') <> ''
        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
    GROUP BY MaterialTypeID, DebitAccountID, CreditAccountID, InventoryID, CurrencyID, ExchangeRate
    
    OPEN @PeriodID_Cur
    FETCH NEXT FROM @PeriodID_Cur INTO @PeriodConv, @QuantityConv, @MaterialTypeID, @DebitAccountID, @CreditAccountID, @InventoryID, @CurrencyID, @ExchangeRate 
    WHILE @@Fetch_Status = 0
    BEGIN
        --LÊy tæng tiÒn cña c¸c ®èi t­îng con
        SET @SumTotal = (SELECT SUM(MV6002.ConvertedAmount) FROM MV6002 WHERE PeriodID = @PeriodID)

        IF (@SumTotal<>0)
            BEGIN
                SET @ChildConv = (ISNULL(@PeriodConv, 0) * ISNULL(@ConvertedAmount, 0))/@SumTotal
                SET @ChildQConv = (ISNULL(@PeriodConv, 0) * ISNULL(@SumQuantity, 0))/@SumTotal
            END
        ELSE 
            BEGIN
                SET @ChildConv = 0 
                SET @ChildQConv = 0 
            END
            
        SET @ChildConv = round(@ChildConv, @ConvertedDecimal) 
        SET @ChildQConv = round(@ChildQConv, @ConvertedDecimal)

        EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'MT9000', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

        INSERT MT9000 (ParentPeriodID, VoucherID, BatchID, DivisionID, TransactionID, ExpenseID, MaterialTypeID, ConvertedAmount, PeriodID, Status, CreateDate, IsFromPeriodID, DebitAccountID, CreditAccountID, transactiontypeID, TranMonth, TranYear, Quantity, InventoryID, CurrencyID, ExchangeRate )
        VALUES (@PeriodID, @VoucherID, @BatchID, @DivisionID, @TransactionID, 'COST001', @MaterialTypeID, @ChildConv, @ChildPeriodID, 0, GETDATE(), 1, @DebitAccountID, @CreditAccountID, ' ', @TranMonth, @TranYear, @ChildQConv, @InventoryID, @CurrencyID, @ExchangeRate)

        FETCH NEXT FROM @PeriodID_Cur INTO @PeriodConv, @QuantityConv, @MaterialTypeID, @DebitAccountID, @CreditAccountID, @InventoryID, @CurrencyID, @ExchangeRate
    END 
    CLOSE @PeriodID_Cur

    FETCH NEXT FROM @ChildPeriodID_Cur INTO @ChildPeriodID, @ConvertedAmount, @Quantity
END
CLOSE @ChildPeriodID_Cur

--- Xu ly chenh lech 
--- Add BY: Dang Le Bao Quynh; Date 01/10/2008

DECLARE 
    @Delta_Converted DECIMAL(28, 8), 
    @ID NVARCHAR(50), 
    @MaterialID NVARCHAR(50)

SET @PeriodID_Cur = CURSOR SCROLL KEYSET FOR
SELECT 
    MaterialTypeID, 
    SUM(CASE WHEN D_C = 'D' THEN ISNULL(ConvertedAmount, 0) ELSE ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
    DebitAccountID, 
    CreditAccountID
FROM MV9000
WHERE PeriodID = @PeriodID AND ExpenseID <> 'COST001' AND ISNULL(MaterialTypeID, '')<>''
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
GROUP BY MaterialTypeID, DebitAccountID, CreditAccountID

OPEN @PeriodID_Cur
FETCH NEXT FROM @PeriodID_Cur INTO @MaterialTypeID, @ConvertedAmount, @DebitAccountID, @CreditAccountID
WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Delta_Converted = @ConvertedAmount - (SELECT SUM(ISNULL(ConvertedAmount, 0)) 
        FROM MT9000
        WHERE ParentPeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID AND DebitAccountID = @DebitAccountID 
            AND CreditAccountID = @CreditAccountID) 

        IF @Delta_Converted <> 0
        BEGIN
            SET @ID = NULL
            SELECT @ID = TransactionID FROM MT9000
            WHERE ParentPeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID AND DebitAccountID = @DebitAccountID 
                AND CreditAccountID = @CreditAccountID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
            ORDER BY ConvertedAmount DESC

            IF @ID is NOT NULL 
            UPDATE MT9000 SET OriginalAmount = OriginalAmount + @Delta_Converted, ConvertedAmount = ConvertedAmount + @Delta_Converted
            WHERE TransactionID = @ID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
        END 
    FETCH NEXT FROM @PeriodID_Cur INTO @MaterialTypeID, @ConvertedAmount, @DebitAccountID, @CreditAccountID
END
CLOSE @PeriodID_Cur