/****** Object:  StoredProcedure [dbo].[MP8127]    Script Date: 12/22/2010 16:01:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created BY Hoang Thi Lan, Date 13/11/2003
------ Purpose Kiem tra tinh hop le cua chi phi SXC 

/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'* Edited BY: [GS] [Cẩm Loan] [22/12/2010]        
'********************************************/

ALTER PROCEDURE  [dbo].[MP8127]      @DivisionID nvarchar(50), 
                    @PeriodID  nvarchar(50), 
                    @TranMonth AS INT, 
                    @TranYear AS INT, 
                    @InProcessID  nvarchar(50), 
                    @Status AS tinyint output, 
                    @Message AS nvarchar(250) output
AS

---
DECLARE     @EndMethodID  AS nvarchar(50), 
    @ApportionID      AS nvarchar(50), 
    @MaterialTypeID AS nvarchar(50), 
    @Expense_621 AS CURSOR

SET @Expense_621 = CURSOR SCROLL KEYSET FOR 
    SELECT   EndMethodID, ApportionID, MaterialTypeID
         FROM MT1618 WHERE     InprocessID = @InProcessID AND 
                    ExpenseID ='COST003' AND 
                    IsUsed = 1 AND DivisionID = @DivisionID


    OPEN    @Expense_621
    FETCH NEXT FROM @Expense_621  INTO  @EndMethodID, @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
    BEGIN
        IF @EndMethodID ='I02'        --TÝnh chi phÝ dë dang theo PP §Þnh møc
            BEGIN
            IF  EXISTS (SELECT ProductID FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID  AND MT0810.VoucherID = MT1001.VoucherID 
                          WHERE MT1001.DivisionID = @DivisionID AND
                          ResultTypeID = 'R03' AND
                            PeriodID = @PeriodID AND
                            ProductID NOT IN (SELECT ProductID FROM MT1603 WHERE ApportionID =@ApportionID AND DivisionID = @DivisionID))
                BEGIN

                    SET @Status = 1                    
                    --SET @Message ='Sản phẩm này chưa tồn tại định mức .Bạn không thể tính chi phí dở dang cuối kỳ được.'
                    SET @Message ='MFML000114'
                    Goto EndMess
    
                END
        END    
            
        FETCH NEXT FROM @Expense_621  INTO  @EndMethodID, @ApportionID, @MaterialTypeID
    END

CLOSE @Expense_621
EndMess:



