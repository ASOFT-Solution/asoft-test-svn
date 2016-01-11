
/****** Object:  StoredProcedure [dbo].[MP2627]    Script Date: 08/02/2010 10:29:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by: Vo Thanh Huong, Date 12/4/2006
------ Purpose   Phan bo chi phi san xuat chung - truong hop CPDDCK nhap bang tay

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP2627] 	 @DivisionID nvarchar(50), 
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
		 @Expense_627 as cursor

Delete MT0444  Where ExpenseID ='COST003'
SET @Expense_627 = Cursor Scroll KeySet FOR 
	Select   MethodID,  CoefficientID,  ApportionID , MaterialTypeID 
		 From MT5001 Where 	DistributionID = @DistributionID and 
					ExpenseID ='COST003' and 
					IsDistributed = 1 				


OPEN	@Expense_627
FETCH NEXT FROM @Expense_627 INTO  @MethodID ,  @CoefficientID ,  @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
	Begin			
		If @MethodID ='D01'    --- Phan bo truc tiep.
			Exec MP5701 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @BeginMethodID, @FromPeriodID

		If @MethodID ='D02' ---- Phan bo theo he so. 
			Exec MP5702 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @CoefficientID, @BeginMethodID, @FromPeriodID

		If @MethodID ='D03' ---- Phan bo theo dinh muc.
			Exec MP5703 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @ApportionID, @BeginMethodID, @FromPeriodID

		If @MethodID ='D04' ---- Phan bo theo nguyen vat lieu (NVL phai thuc hien truoc)
			Exec MP5704 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @BeginMethodID, @FromPeriodID
		
		If @MethodID ='D05' --- phan bo theo luong	
			Exec MP5705 @DivisionID, @PeriodID, @TranMonth, @TranYear, @MaterialTypeID, @BeginMethodID, @FromPeriodID
		
		FETCH NEXT FROM @Expense_627  INTO  @MethodID,  @CoefficientID,  @ApportionID, @MaterialTypeID  
	End
CLOSE @Expense_627



