/****** Object: StoredProcedure [dbo].[MP0622] Script Date: 07/30/2010 10:15:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created BY Nguyen Van Nhan, Date 03/11/2003
------ Purpose Phan bo nhan cong truc tiep
/********************************************
'* Edited BY: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0622] 
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
    @Expense_622 AS CURSOR, 
    @Expense_621 AS CURSOR
 
DELETE MT0621 WHERE DivisionID = @DivisionID AND ExpenseID = 'COST002'

SET @Expense_622 = CURSOR SCROLL KEYSET FOR 
    SELECT MethodID, CoefficientID, ApportionID, MaterialTypeID 
    FROM MT5001 
    WHERE DivisionID = @DivisionID AND DistributionID = @DistributionID AND ExpenseID = 'COST002' AND IsDistributed = 1 

OPEN @Expense_622
FETCH NEXT FROM @Expense_622 INTO @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
    BEGIN
        IF @MethodID = 'D01' --- Phan bo truc tiep. Da duoc lam xong ngay 06/11/2003.
        EXEC MP5201 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID

        IF @MethodID = 'D02' ---- Phan bo theo he so. Da duoc lam xong ngay 05/11/2003.
        EXEC MP5202 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID

        IF @MethodID = 'D03' ---- Phan bo theo dinh muc
        EXEC MP5203 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID

        IF @MethodID = 'D04' ---- Phan bo theo nguyen vat lieu (NVL phai thuc hien truoc)
        EXEC MP5204 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID

        --IF @MethodID = 'D05' 
        ---khong su dung 

        IF @MethodID = 'D06' --- Phan bo truc tiep ket hop he so
        EXEC MP5206 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID

        IF @MethodID = 'D07' --- Phanbo truc tiep ket hop dinh muc
        EXEC MP5207 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID 

        IF @MethodID = 'D08' --- Phan bo theo NVL ket hop he so. Coding BY Van Nhan (dap ung yeu cua cua Chau Electronics)
        EXEC MP5208 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID

        FETCH NEXT FROM @Expense_622 INTO @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID 
    END

CLOSE @Expense_622


----- Nhung cai duoc phan bo theo luong

-----1. NVL Phan bo theo luong
SET @Expense_621 = CURSOR SCROLL KEYSET FOR 
SELECT MethodID, CoefficientID, ApportionID, MaterialTypeID
FROM MT5001 WHERE DivisionID = @DivisionID AND DistributionID = @DistributionID AND ExpenseID = 'COST001' AND IsDistributed = 1 AND MethodID = 'D05' 

OPEN @Expense_621
FETCH NEXT FROM @Expense_621 INTO @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
    BEGIN
        DELETE MT0621 WHERE DivisionID = @DivisionID AND ExpenseID = 'COST001' AND MaterialTypeID = @MaterialTypeID

        EXEC MP5105 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID

        FETCH NEXT FROM @Expense_621 INTO @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID 
    END

CLOSE @Expense_621































