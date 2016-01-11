/****** Object: StoredProcedure [dbo].[MP0627] Script Date: 07/30/2010 10:18:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created BY Nguyen Van Nhan, Date 03/11/2003
------ Purpose Phan bo chi phi san xuat chung
/********************************************
'* Edited BY: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0627]
    @DivisionID NVARCHAR(50), 
    @PeriodID NVARCHAR(50), 
    @TranMonth AS INT, 
    @TranYear AS INT, 
    @DistributionID NVARCHAR(50)
AS

DECLARE 
    @MethodID AS NVARCHAR(50), 
    @CoefficientID AS NVARCHAR(50), 
    @ApportionID AS NVARCHAR(50), 
    @MaterialTypeID AS NVARCHAR(50), 
    @Expense_627 AS CURSOR

DELETE MT0621 WHERE DivisionID = @DivisionID AND ExpenseID = 'COST003'

SET @Expense_627 = CURSOR SCROLL KEYSET FOR 
    SELECT MethodID, CoefficientID, ApportionID, MaterialTypeID 
    FROM MT5001 WHERE DivisionID = @DivisionID AND DistributionID = @DistributionID AND ExpenseID = 'COST003' AND IsDistributed = 1 

OPEN @Expense_627
FETCH NEXT FROM @Expense_627 INTO @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
    BEGIN
        IF @MethodID = 'D01' --- Phan bo truc tiep. Da duoc lam xong ngay 06/11/2003.
        EXEC MP5701 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID

        IF @MethodID = 'D02' ---- Phan bo theo he so. Da duoc lam xong ngay 05/11/2003.
        EXEC MP5702 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID

        IF @MethodID = 'D03' ---- Phan bo theo dinh muc. Da lam xong ngay 07/11/2003
        EXEC MP5703 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID

        IF @MethodID = 'D04' ---- Phan bo theo nguyen vat lieu (NVL phai thuc hien truc)
        EXEC MP5704 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID

        IF @MethodID = 'D05' --- phan bo theo luong
        EXEC MP5705 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID

        IF @MethodID = 'D06' --- Phan bo truc tiep ket hop he so
        EXEC MP5706 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID

        IF @MethodID = 'D07' --- Phanbo truc tiep ket hop dinh muc
        EXEC MP5707 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID 

        IF @MethodID = 'D08' --- Phan bo theo NVL ket hop he so (Coding BY Van Nhan)
        EXEC MP5708 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID 

        FETCH NEXT FROM @Expense_627 INTO @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID 
    END

CLOSE @Expense_627

























