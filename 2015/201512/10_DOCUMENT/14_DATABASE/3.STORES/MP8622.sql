/****** Object:  StoredProcedure [dbo].[MP8622]    Script Date: 01/07/2011 10:08:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

------ Created BY Hoang Thi Lan, Date 12/11/2003
------ Purpose tinh chi phi do dang NC cuoi ky cho DTTHCP

ALTER PROCEDURE  [dbo].[MP8622]      @DivisionID NVARCHAR(50), 
                    @PeriodID  NVARCHAR(50), 
                    @TranMonth AS INT, 
                    @TranYear AS INT, 
                    @InProcessID  NVARCHAR(50), 
                    @VoucherID AS NVARCHAR(50), 
                    @CMonth AS NVARCHAR(50), 
                    @CYear AS NVARCHAR(50)
AS

---
DECLARE     @EndMethodID  AS NVARCHAR(50), 
    @ApportionID      AS NVARCHAR(50), 
    @MaterialTypeID AS NVARCHAR(50), 
    @Expense_622 AS CURSOR


DELETE MT1613 
WHERE ExpenseID ='COST002'  AND Type='E' AND PeriodID= @PeriodID AND TranMonth = @TranMonth AND TranYear = @TranYear
    AND DivisionID = @DivisionID
    
SET @Expense_622 = CURSOR SCROLL KEYSET FOR 
SELECT EndMethodID, ApportionID, MaterialTypeID
FROM MT1618 
WHERE InprocessID = @InProcessID AND ExpenseID ='COST002' AND IsUsed = 1                 
    AND DivisionID = @DivisionID
    
OPEN @Expense_622
FETCH NEXT FROM @Expense_622  INTO  @EndMethodID, @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
    BEGIN        
        IF @EndMethodID ='I01'  -- Uoc luong tuong duong
            EXEC MP8201 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @VoucherID, @CMonth, @CYear
            
        IF @EndMethodID = 'I02'  -- Dinh muc        
            EXEC MP8202  @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID, @VoucherID, @CMonth, @CYear
            
        --IF @EndMethodID ='I03'    (Không làm phần này trong trường hợp này)            
            --print 'lam sau'

        FETCH NEXT FROM @Expense_622  INTO  @EndMethodID, @ApportionID, @MaterialTypeID
    END

CLOSE @Expense_622

