/****** Object:  StoredProcedure [dbo].[MP2621]    Script Date: 08/02/2010 10:17:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by: Vo Thanh Huong, Date 12/4/2006
------ Purpose: Phan bo NVL truc tiep, truong hop DDCK nhap bang tay
 
 /********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP2621] 	@DivisionID nvarchar(50), 
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
		 @Expense_621 as cursor

Delete MT0444 Where ExpenseID  = 'COST001' 

SET @Expense_621 = Cursor Scroll KeySet FOR 
	Select   MethodID,  CoefficientID,  ApportionID  , MaterialTypeID
		 From MT5001 Where 	DistributionID = @DistributionID and 
					ExpenseID ='COST001' and 
					IsDistributed = 1 				

OPEN	@Expense_621
FETCH NEXT FROM @Expense_621  INTO  @MethodID ,  @CoefficientID ,  @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
Begin

If @MethodID ='D01' --- Phan bo truc tiep. 		
	Exec MP5101 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @BeginMethodID, @FromPeriodID

If @MethodID ='D02' ---- Phan bo theo he so. 						
	Exec MP5102 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID,  @BeginMethodID, @FromPeriodID	
		
If @MethodID ='D03'  ---- Phan bo theo dinh muc.
	Exec MP5103 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID,@BeginMethodID, @FromPeriodID

FETCH NEXT FROM @Expense_621  INTO  @MethodID,  @CoefficientID,  @ApportionID, @MaterialTypeID  
End

CLOSE @Expense_621