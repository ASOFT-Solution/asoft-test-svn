/****** Object:  StoredProcedure [dbo].[MP2622]    Script Date: 08/02/2010 10:23:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
------ Created by: Vo Thanh Huong, date: 12/4/2006
------ Purpose :  Phan bo nhan cong truc tiep & DDCK cap nhat bang tay

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP2622] 	 @DivisionID nvarchar(50), 
					@PeriodID  nvarchar(50), 
					@TranMonth as int, 
					@TranYear as int, 
					@DistributionID  nvarchar(50),
					@BeginMethodID int,
					@FromPeriodID	nvarchar(50)
AS
Declare	 @MethodID  as nvarchar(50),
		 @CoefficientID 	as nvarchar(50),
		 @ApportionID  	as nvarchar(50),
		 @MaterialTypeID as nvarchar(50),
		 @Expense_622 as cursor,
		 @Expense_621 as cursor

Delete MT0444  Where ExpenseID ='COST002'

SET @Expense_622 = Cursor Scroll KeySet FOR 
	Select   MethodID,  CoefficientID,  ApportionID , MaterialTypeID 
		 From MT5001 Where 	DistributionID = @DistributionID and 
					ExpenseID ='COST002' and 
					IsDistributed = 1 				


OPEN	@Expense_622
FETCH NEXT FROM @Expense_622  INTO  @MethodID ,  @CoefficientID ,  @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
Begin
If @MethodID ='D01'    --- Phan bo truc tiep. 
	Exec MP5201 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID,  @BeginMethodID, @FromPeriodID

If @MethodID ='D02'   ---- Phan bo theo he so. 
	Exec MP5202 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID, @BeginMethodID, @FromPeriodID

If @MethodID ='D03'  ---- Phan bo theo dinh muc
	Exec MP5203 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID, @BeginMethodID, @FromPeriodID
	
If @MethodID ='D04'   ---- Phan bo theo nguyen vat lieu (NVL phai thuc hien truoc)
	Exec MP5204 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @BeginMethodID, @FromPeriodID

FETCH NEXT FROM @Expense_622  INTO  @MethodID,  @CoefficientID,  @ApportionID, @MaterialTypeID  
END

CLOSE @Expense_622


-----------------------------------------------------------------------------------------------------------------
----Phan bo NVL theo luong
SET @Expense_621 = Cursor Scroll KeySet FOR 
	Select    MaterialTypeID
		 From MT5001 Where 	DistributionID = @DistributionID and 
					ExpenseID ='COST001' and 
					IsDistributed = 1  and
					MethodID ='D05' 	

	OPEN	@Expense_621
	FETCH NEXT FROM @Expense_621  INTO @MaterialTypeID
WHILE @@Fetch_Status = 0
BEGIN
	Delete MT0444 Where ExpenseID ='COST001' and MaterialTypeID  =  @MaterialTypeID		
	Exec MP5105 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @BeginMethodID, @FromPeriodID

	FETCH NEXT FROM @Expense_621  INTO @MaterialTypeID
END
CLOSE @Expense_621