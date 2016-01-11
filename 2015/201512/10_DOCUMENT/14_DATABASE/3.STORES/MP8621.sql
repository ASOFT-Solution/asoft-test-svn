/****** Object:  StoredProcedure [dbo].[MP8621]    Script Date: 01/07/2011 10:08:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

------ Created BY Nguyen Van Nhan, Date 12/11/2003
------ Purpose tinh chi phi do dang NVL cuoi ky cho DTTHCP

ALTER PROCEDURE  [dbo].[MP8621]     @DivisionID NVARCHAR(50), 
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
     @Expense_621 AS CURSOR

DELETE MT1613 
WHERE ExpenseID ='COST001'  AND Type='E'  AND PeriodID= @PeriodID AND TranMonth = @TranMonth AND TranYear = @TranYear
    AND DivisionID = @DivisionID

SET @Expense_621 = CURSOR SCROLL KEYSET FOR 
SELECT   EndMethodID, ApportionID, MaterialTypeID
FROM MT1618 
WHERE     InprocessID = @InProcessID AND ExpenseID ='COST001' AND IsUsed = 1                 
    AND DivisionID = @DivisionID

OPEN @Expense_621
FETCH NEXT FROM @Expense_621  INTO  @EndMethodID, @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
    BEGIN
        --print '@EndMethodID' + @EndMethodID
        IF @EndMethodID ='I01'  --Theo pp ước lượng tương đương
            EXEC MP8101 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @VoucherID, @CMonth, @CYear
            
        IF @EndMethodID ='I02'    --Theo PP  định mức
            EXEC MP8102 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID, @VoucherID, @CMonth, @CYear
        
        IF @EndMethodID ='I03'    --NVL trực tiếp      
            EXEC MP8103 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @VoucherID, @CMonth, @CYear
    
        FETCH NEXT FROM @Expense_621  INTO  @EndMethodID, @ApportionID, @MaterialTypeID
    END

CLOSE @Expense_621
GO


