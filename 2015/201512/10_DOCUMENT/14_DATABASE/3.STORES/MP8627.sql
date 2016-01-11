/****** Object:  StoredProcedure [dbo].[MP8627]    Script Date: 01/07/2011 10:09:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

------ Created BY Hoang Thi Lan, Date 12/11/2003
------ Purpose tinh chi phi do dang SXC cuoi ky cho DTTHCP

ALTER PROCEDURE  [dbo].[MP8627]      @DivisionID NVARCHAR(50), 
                    @PeriodID  NVARCHAR(50), 
                    @TranMonth AS INT, 
                    @TranYear AS INT, 
                    @InprocessID AS NVARCHAR(50), 
                    @VoucherID AS NVARCHAR(50), 
                    @CMonth AS NVARCHAR(50), 
                    @CYear AS NVARCHAR(50)

AS
---
DECLARE     @EndMethodID  AS NVARCHAR(50), 
    @ApportionID      AS NVARCHAR(50), 
    @MaterialTypeID AS NVARCHAR(50), 
    @Expense_627 AS CURSOR

Delete MT1613 
WHERE ExpenseID ='COST003' AND Type = 'E' AND PeriodID= @PeriodID AND TranMonth = @TranMonth AND TranYear = @TranYear
    AND DivisionID = @DivisionID
    
SET @Expense_627 = CURSOR SCROLL KEYSET FOR 
SELECT EndMethodID, ApportionID, MaterialTypeID
FROM MT1618 
WHERE InprocessID = @InProcessID AND ExpenseID ='COST003' AND IsUsed = 1                 
    AND DivisionID = @DivisionID
OPEN    @Expense_627
FETCH NEXT FROM @Expense_627 INTO  @EndMethodID, @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
    BEGIN
    
        IF @EndMethodID ='I01'  
            EXEC MP8701 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @VoucherID, @CMonth, @CYear 
                
        IF @EndMethodID ='I02'        
            EXEC MP8702  @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID, @VoucherID, @CMonth, @CYear 
            
--      IF @EndMethodID ='I03'  (Không làm phần này trong trường hợp này)
            --print 'Lam sau'
        
        FETCH NEXT FROM @Expense_627  INTO  @EndMethodID, @ApportionID, @MaterialTypeID
    END

CLOSE @Expense_627
