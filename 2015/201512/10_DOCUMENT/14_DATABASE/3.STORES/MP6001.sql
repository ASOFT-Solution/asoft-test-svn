/****** Object:  StoredProcedure [dbo].[MP6001]    Script Date: 08/03/2010 10:34:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan
--Date 6/12/2003
--Purpose:Phan bo chi phi cho  doi tuong (Theo chi phi cau thanh)
--Edit BY: Vo THanh Huong, date: 18/4/2006
--Edit BY: Dang Le Bao Quynh, Date: 29/05/2008
--Purpose: Sua lai cach thuc xu ly lam tron

/********************************************
'* Edited BY: [GS] [Việt Khánh] [03/08/2010]
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần tiền hạch toán theo thiết lập đơn vị-chi nhánh
'********************************************/

ALTER PROCEDURE [dbo].[MP6001]     
    @DivisionID NVARCHAR(50), 
    @PeriodID NVARCHAR(50), 
    @CoefficientID NVARCHAR(50), 
    @CMonth INT, 
    @CYear INT, 
    @VoucherID NVARCHAR(50), 
    @BatchID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT
AS 

DECLARE 
    @sSQL NVARCHAR(4000), 
    @SumCovalue DECIMAL(28, 8), 
    @ChildPeriodID_Cur CURSOR, 
    @ChildPeriodID NVARCHAR(50), 
    @ConvertedAmount DECIMAL(28, 8), 
    @PeriodConv DECIMAL(28, 8), 
    @ChildConv DECIMAL(28, 8), 
    @ExpenseID NVARCHAR(50), 
    @MaterialTypeID NVARCHAR(50), 
    @TransactionID NVARCHAR(50), 
    @Covalue DECIMAL(28, 8), 
    @PeriodID_Cur CURSOR, 
    @ConvertedDecimal DECIMAL(28, 8), 
    @DebitAccountID NVARCHAR(50), 
    @CreditAccountID NVARCHAR(50), 
    @Quantity DECIMAL(28, 8), 
    @ChildQConv DECIMAL(28, 8), 
    @InventoryID NVARCHAR(50), 
    @CurrencyID NVARCHAR(50), 
    @ExchangeRate DECIMAL(28, 8)

SELECT @ConvertedDecimal = ConvertDecimal FROM MT0000 WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
SET @ConvertedDecimal = ISNULL(@ConvertedDecimal, 2)

SET @CurrencyID = ISNULL((SELECT TOP 1 BaseCurrencyID FROM AT1101 WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))), 'VND')
SET @ExchangeRate = 1

--Lay tung he so
SET @SumCovalue = (SELECT SUM(Covalue) FROM MT1607 WHERE CoefficientID = @CoefficientID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

--Lay he so theo doi tuong
SET @ChildPeriodID_Cur = CURSOR SCROLL KEYSET FOR 
SELECT PeriodID, Covalue 
FROM MT1607
WHERE CoefficientID = @CoefficientID 
AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))

OPEN @ChildPeriodID_Cur
FETCH NEXT FROM @ChildPeriodID_Cur INTO @ChildPeriodID, @CoValue
            
WHILE @@Fetch_Status = 0
BEGIN
    --Lay tong tien cua doi tuong cha
    SET @PeriodID_Cur = CURSOR SCROLL KEYSET FOR 
    SELECT SUM(ConvertedAmount) AS ConvertedAmount, MaterialTypeID, DebitAccountID, CreditAccountID
    FROM MV9000
    WHERE PeriodID = @PeriodID AND ExpenseID = 'COST003' AND ISNULL(MaterialTypeID, '') <> ''
        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
    GROUP BY MaterialTypeID, DebitAccountID, CreditAccountID

    OPEN @PeriodID_Cur
    FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount, @MaterialTypeID, @DebitAccountID, @CreditAccountID
    WHILE @@Fetch_Status = 0
        BEGIN
            IF (@SumCovalue<>0)
                BEGIN
                    SET @ChildConv = (ISNULL(@ConvertedAmount, 0) * ISNULL(@Covalue, 0))/@SumCovalue
                    SET @ChildQConv = (ISNULL(@Quantity, 0) * ISNULL(@Covalue, 0))/@SumCovalue
                END
            ELSE 
                BEGIN
                    SET @ChildConv = 0 
                    SET @ChildQConv = 0 
                END

            SET @ChildConv = ROUND(@ChildConv, @ConvertedDecimal) 
            SET @ChildQConv = ROUND(@ChildQConv, @ConvertedDecimal) 

            EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT9000', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

            INSERT MT9000 (ParentPeriodID, VoucherID, BatchID, DivisionID, TransactionID, ExpenseID, MaterialTypeID, OriginalAmount, ConvertedAmount, PeriodID, Status, CreateDate, IsFromPeriodID, DebitAccountID, CreditAccountID, TransactiontypeID, TranMonth, TranYear, Quantity, InventoryID, CurrencyID, ExchangeRate)
            VALUES (@PeriodID, @VoucherID, @BatchID, @DivisionID, @TransactionID, 'COST003', @MaterialTypeID, @ChildConv, @ChildConv, @ChildPeriodID, 0, GETDATE(), 1, @DebitAccountID, @CreditAccountID, ' ', @TranMonth, @TranYear, @ChildQConv, @InventoryID, @CurrencyID, @ExchangeRate)
                
            FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount, @MaterialTypeID, @DebitAccountID, @CreditAccountID

        END
    CLOSE @PeriodID_Cur
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Phan bo chi phi nhan cong

--Lay tong tien cua doi tuong cha
    SET @PeriodID_Cur = CURSOR SCROLL KEYSET FOR 
    SELECT SUM(ConvertedAmount) AS ConvertedAmount, SUM(ISNULL(Quantity, 0)) AS Quantity, MaterialTypeID, DebitAccountID, CreditAccountID
    FROM MV9000
    WHERE PeriodID = @PeriodID AND ExpenseID = 'COST002' AND ISNULL(MaterialTypeID, '') <> ''
        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
    GROUP BY MaterialTypeID, DebitAccountID, CreditAccountID

    OPEN @PeriodID_Cur
    FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount, @Quantity, @MaterialTypeID, @DebitAccountID, @CreditAccountID
    WHILE @@Fetch_Status = 0
        BEGIN
            IF (@SumCovalue<>0)
                BEGIN
                    SET @ChildConv = (ISNULL(@ConvertedAmount, 0) * ISNULL(@Covalue, 0))/@SumCovalue
                    SET @ChildQConv = (ISNULL(@Quantity, 0) * ISNULL(@Covalue, 0))/@SumCovalue
                END
            ELSE 
                BEGIN
                    SET @ChildConv = 0 
                    SET @ChildQConv = 0 
                END

            SET @ChildConv = ROUND(@ChildConv, @ConvertedDecimal) 
            SET @ChildQConv = ROUND(@ChildQConv, @ConvertedDecimal) 

            EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT9000', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

            INSERT MT9000 (ParentPeriodID, VoucherID, BatchID, DivisionID, TransactionID, ExpenseID, MaterialTypeID, OriginalAmount, ConvertedAmount, PeriodID, Status, CreateDate, IsFromPeriodID, DebitAccountID, CreditAccountID, transactiontypeID, TranMonth, TranYear, Quantity, CurrencyID, ExchangeRate)
            VALUES (@PeriodID, @VoucherID, @BatchID, @DivisionID, @TransactionID, 'COST002', @MaterialTypeID, @ChildConv, @ChildConv, @ChildPeriodID, 0, GETDATE(), 1, @DebitAccountID, @CreditAccountID, ' ', @TranMonth, @TranYear, @ChildQConv, @CurrencyID, @ExchangeRate)
            
            FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount, @Quantity, @MaterialTypeID, @DebitAccountID, @CreditAccountID
        END
    CLOSE @PeriodID_Cur

---- Phan bo chi phi NVL
---- Lay tong tien cua doi tuong cha
    SET @PeriodID_Cur = CURSOR SCROLL KEYSET FOR 
    SELECT SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount, SUM(ISNULL(Quantity, 0)) AS Quantity, MaterialTypeID, InventoryID, DebitAccountID, CreditAccountID
    FROM MV9000
    WHERE PeriodID = @PeriodID AND ExpenseID = 'COST001' AND ISNULL(MaterialTypeID, '')<>''
        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
    GROUP BY MaterialTypeID, InventoryID, DebitAccountID, CreditAccountID

    OPEN @PeriodID_Cur
    FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount, @Quantity, @MaterialTypeID, @InventoryID, @DebitAccountID, @CreditAccountID

    WHILE @@Fetch_Status = 0
    BEGIN
        SET @TranMonth = (SELECT distinct TranMonth FROM MV9000 WHERE PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) AND ExpenseID = 'COST001')
        SET @TranYear = (SELECT distinct TranYear FROM MV9000 WHERE PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) AND ExpenseID = 'COST001')

        IF (@SumCovalue<>0)
            BEGIN
                SET @ChildConv = (ISNULL(@ConvertedAmount, 0) * ISNULL(@Covalue, 0))/@SumCovalue
                SET @ChildQConv = (ISNULL(@Quantity, 0) * ISNULL(@Covalue, 0))/@SumCovalue
            END
        ELSE 
            BEGIN
                SET @ChildConv = 0 
                SET @ChildQConv = 0 
            END

        SET @ChildConv = ROUND(@ChildConv, @ConvertedDecimal) 
        SET @ChildQConv = ROUND(@ChildQConv, @ConvertedDecimal) 

        EXEC AP0000 @DivisionID, @TransactionID  OUTPUT, 'MT9000', 'IT', @CMonth, @CYear, 18, 3, 0, '-'

        INSERT MT9000 (ParentPeriodID, VoucherID, BatchID, DivisionID, TransactionID, ExpenseID, MaterialTypeID, OriginalAmount, ConvertedAmount, PeriodID, Status, CreateDate, IsFromPeriodID, DebitAccountID, CreditAccountID, TransactiontypeID, TranMonth, TranYear, Quantity, InventoryID, CurrencyID, ExchangeRate)
        VALUES (@PeriodID, @VoucherID, @BatchID, @DivisionID, @TransactionID, 'COST001', @MaterialTypeID, @ChildConv, @ChildConv, @ChildPeriodID, 0, GETDATE(), 1, @DebitAccountID, @CreditAccountID, ' ', @TranMonth, @TranYear, @ChildQConv, @InventoryID, @CurrencyID, @ExchangeRate)

        FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount, @Quantity, @MaterialTypeID, @InventoryID, @DebitAccountID, @CreditAccountID
    END
    CLOSE @PeriodID_Cur

    FETCH NEXT FROM @ChildPeriodID_Cur INTO @ChildPeriodID, @Covalue
END
CLOSE @ChildPeriodID_Cur

------------------------------------------------------------------------------------------------------------------
--- Add BY: Vo Thanh Huong
--- Xu ly chenh lech 
--- Edit BY: Dang Le Bao Quynh; Date 03/08/2007
--- Không c?n ph?i x? lý -ConvertedAmount khi but toan phat sinh Co TK chi phi
DECLARE 
    @Delta_Converted DECIMAL(28, 8), 
    @Delta_Quantity DECIMAL(28, 8), 
    @ID NVARCHAR(50), 
    @MaterialID NVARCHAR(50)
-----------Nhan cong & SXC
SET @PeriodID_Cur = CURSOR SCROLL KEYSET FOR
SELECT 
    MaterialTypeID, 
    SUM(CASE WHEN D_C = 'D' THEN ISNULL(ConvertedAmount, 0) ELSE ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
    SUM(CASE WHEN D_C = 'D' THEN ISNULL(Quantity, 0) ELSE ISNULL(Quantity, 0) END) AS Quantity, 
    DebitAccountID, 
    CreditAccountID
FROM MV9000
WHERE PeriodID = @PeriodID AND ExpenseID <> 'COST001' AND ISNULL(MaterialTypeID, '') <> ''
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
GROUP BY MaterialTypeID, DebitAccountID, CreditAccountID

OPEN @PeriodID_Cur
FETCH NEXT FROM @PeriodID_Cur INTO @MaterialTypeID, @ConvertedAmount, @Quantity, @DebitAccountID, @CreditAccountID
WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Delta_Converted = @ConvertedAmount - (SELECT SUM(ISNULL(ConvertedAmount, 0)) 
                                                    FROM MT9000
                                                    WHERE ParentPeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID 
                                                        AND DebitAccountID = @DebitAccountID AND CreditAccountID = @CreditAccountID
                                                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))) 

        SET @Delta_Quantity = @Quantity - (SELECT SUM(ISNULL(Quantity, 0)) 
                                            FROM MT9000
                                            WHERE ParentPeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID 
                                                AND DebitAccountID = @DebitAccountID AND CreditAccountID = @CreditAccountID
                                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
        IF @Delta_Converted <> 0
            BEGIN
                SET @ID = NULL
                SELECT @ID = TransactionID FROM MT9000
                WHERE ParentPeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID 
                    AND DebitAccountID = @DebitAccountID AND CreditAccountID = @CreditAccountID
                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                ORDER BY ConvertedAmount DESC

                IF @ID IS NOT NULL 
                    UPDATE MT9000 SET OriginalAmount = OriginalAmount + @Delta_Converted, ConvertedAmount = ConvertedAmount + @Delta_Converted
                    WHERE TransactionID = @ID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
            END    
        

        IF @Delta_Quantity <> 0
            BEGIN
                SET @ID = NULL
                SELECT @ID = TransactionID FROM MT9000
                WHERE ParentPeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID 
                    AND DebitAccountID = @DebitAccountID AND CreditAccountID = @CreditAccountID
                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                ORDER BY Quantity DESC

                IF @ID IS NOT NULL 
                    UPDATE MT9000 SET Quantity = Quantity + @Delta_Quantity
                    WHERE TransactionID = @ID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
            END    

        FETCH NEXT FROM @PeriodID_Cur INTO @MaterialTypeID, @ConvertedAmount, @Quantity, @DebitAccountID, @CreditAccountID
    END
CLOSE @PeriodID_Cur


------Nhan cong truc tiep
SET @PeriodID_Cur = CURSOR SCROLL KEYSET FOR
SELECT 
    MaterialTypeID, 
    InventoryID, 
    SUM(CASE WHEN D_C = 'D' THEN ISNULL(ConvertedAmount, 0) ELSE ISNULL(ConvertedAmount, 0) END) AS ConvertedAmount, 
    SUM(CASE WHEN D_C = 'D' THEN ISNULL(Quantity, 0) ELSE ISNULL(Quantity, 0) END) AS Quantity, 
    DebitAccountID, 
    CreditAccountID 
FROM MV9000
WHERE PeriodID = @PeriodID AND ExpenseID = 'COST001' AND ISNULL(MaterialTypeID, '') <> ''
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
GROUP BY MaterialTypeID, InventoryID, DebitAccountID, CreditAccountID 

OPEN @PeriodID_Cur
FETCH NEXT FROM @PeriodID_Cur INTO @MaterialTypeID, @MaterialID, @ConvertedAmount, @Quantity, @DebitAccountID, @CreditAccountID
WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Delta_Converted = @ConvertedAmount - (SELECT SUM(ISNULL(ConvertedAmount, 0)) FROM MT9000
                                                    WHERE ParentPeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID 
                                                        AND InventoryID = @MaterialID AND DebitAccountID = @DebitAccountID 
                                                        AND CreditAccountID = @CreditAccountID
                                                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))


        SET @Delta_Quantity = @Quantity - (SELECT SUM(ISNULL(Quantity, 0)) FROM MT9000
                                            WHERE ParentPeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID 
                                                AND InventoryID = @MaterialID AND DebitAccountID = @DebitAccountID 
                                                AND CreditAccountID = @CreditAccountID
                                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
        IF @Delta_Converted <> 0
            BEGIN
                SET @ID = NULL
                SELECT @ID = TransactionID FROM MT9000
                    WHERE ParentPeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID AND InventoryID = @MaterialID 
                        AND DebitAccountID = @DebitAccountID AND CreditAccountID = @CreditAccountID
                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                    ORDER BY ConvertedAmount DESC

                IF @ID IS NOT NULL  
                    UPDATE MT9000 SET OriginalAmount = OriginalAmount + @Delta_Converted, ConvertedAmount = ConvertedAmount + @Delta_Converted 
                    WHERE TransactionID = @ID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
            END    
        ---
        IF @Delta_Quantity <> 0
            BEGIN
                SET @ID = NULL
                SELECT @ID = TransactionID FROM MT9000
                    WHERE ParentPeriodID = @PeriodID AND MaterialTypeID = @MaterialTypeID AND InventoryID = @MaterialID 
                        AND DebitAccountID = @DebitAccountID AND CreditAccountID = @CreditAccountID
                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                    ORDER BY Quantity DESC

                IF @ID IS NOT NULL 
                    UPDATE MT9000 SET Quantity = Quantity + @Delta_Quantity
                    WHERE TransactionID = @ID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
            END    

        FETCH NEXT FROM @PeriodID_Cur INTO @MaterialTypeID, @MaterialID, @ConvertedAmount, @Quantity, @DebitAccountID, @CreditAccountID 
    END
CLOSE @PeriodID_Cur