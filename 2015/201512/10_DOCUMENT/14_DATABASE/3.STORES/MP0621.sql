/****** Object: StoredProcedure [dbo].[MP0621] Script Date: 07/30/2010 10:13:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created BY Nguyen Van Nhan, Date 03/11/2003
------ Purpose Phan bo NVL truc tiep
/********************************************
'* Edited BY: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0621] 
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
    @Expense_621 AS CURSOR

DELETE MT0621 WHERE DivisionID = @DivisionID AND ExpenseID = 'COST001'

SET @Expense_621 = CURSOR SCROLL KEYSET FOR 
    SELECT MethodID, CoefficientID, ApportionID, MaterialTypeID
    FROM MT5001 
    WHERE DivisionID = @DivisionID AND DistributionID = @DistributionID AND ExpenseID = 'COST001' AND IsDistributed = 1 
--print @DistributionID;
OPEN @Expense_621
FETCH NEXT FROM @Expense_621 INTO @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
    BEGIN
		IF @MethodID = 'D01' --- Phan bo truc tiep. Da lam xong ngay 06/11/2003
        EXEC MP5101 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID

        IF @MethodID = 'D02' ---- Phan bo theo he so. Da lam xong Ngay 05/11/2003
        EXEC MP5102 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID

        IF @MethodID = 'D03' ---- Phan bo theo dinh muc. Da lam xong ngay 07/11/2003
        EXEC MP5103 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID

        -- IF @MethodID = 'D04' 
        ---- Phan bo theo nguyen vat lieu (khong su dung cho loai chi phi nay) 

        -- IF @MethodID = 'D05'
        --- Phan bo theo luong (luong phai tinh truoc) --duoc tinh sau khi phan bo tinh luong

        IF @MethodID = 'D06' --- Phan bo truc tiep ket hop he so. Da lam xong ngay 06/11/2003
        EXEC MP5106 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID

        IF @MethodID = 'D07' --- Phan bo truc tiep ket hop dinh muc. Da lam xong ngay 07/11/2003
        EXEC MP5107 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID 

        FETCH NEXT FROM @Expense_621 INTO @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID 
    END

CLOSE @Expense_621