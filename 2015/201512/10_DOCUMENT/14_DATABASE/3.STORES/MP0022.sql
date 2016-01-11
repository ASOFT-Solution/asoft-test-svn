
/****** Object:  StoredProcedure [dbo].[MP0022]    Script Date: 07/29/2010 17:16:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


---- Chiet tinh gia thanh, chi tiet tung DTTHCP.
---- Created by Van Nhan, date 02/06/2008
---- Edit by: Dang Le Bao Quynh; Date: 19/11/2008
---- Purpose: Cai tien toc do xu ly

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0022] 	
					@DivisionID as nvarchar(50), 
					@TranMonth as int, 
					@TranYear as int, 
					@ProcedureID as nvarchar(50),		
					@FixProductID as nvarchar(250),
					@ProductQuantity as decimal(28,8)
 AS

Declare @PeriodID as nvarchar(50)

Select Top 1 @PeriodID = PeriodID From MT1631 Where  ProcedureID=@ProcedureID AND DivisionID = @DivisionID Order by StepID Desc
Exec MP0023 @DivisionID, @PeriodID, @FixProductID, 1, @FixProductID

/*
Declare 	@Cur as cursor,
		@MaterialID as nvarchar(20),
		@QuantityUnit as money,
		@ConvertedUnit as money,
		@NextPeriodID as nvarchar(20),
		@EndPeriodID as nvarchar(20),
		@PeriodID as nvarchar(20),
		@ProductID as nvarchar(20)

While  exists (Select top 1 1 From MT1634 Where FixProductID =@FixProductID)
  Begin
	Select top 1  @MaterialID =ProductID,  @QuantityUnit = QuantityUnit, @ConvertedUnit = ConvertedUnit, @EndPeriodID= PeriodID 
	From MT1634 Where FixProductID=@FixProductID

	Insert MT1633 ( PeriodID, MaterialID, ProductID, ExpenseID, MaterialTypeID, QuantityUnit, ConvertedUnit)
	Select PeriodID, null,  @FixProductID, ExpenseID, MaterialTypeID,QuantityUnit, ConvertedUnit*@QuantityUnit
	From MT4000
	Where ExpenseID in ('COST002', 'COST003')  and ProductID = @MaterialID and PeriodID =@EndPeriodID and DivisionID =@DivisionID
	Order by ProductID, ExpenseID, MaterialTypeID
	
	Insert MT1633 ( PeriodID, MaterialID, ProductID, ExpenseID,  QuantityUnit, ConvertedUnit)
	Select PeriodID, MaterialID, @FixProductID, ExpenseID,  QuantityUnit, ConvertedUnit*@QuantityUnit
	From MT4000 
	Where ExpenseID = 'COST001'   and PeriodID =@EndPeriodID and DivisionID =@DivisionID and ProductID =@MaterialID and
		MaterialID  not in (Select distinct ProductID From  MT1001 inner join MT0810 on MT1001.VoucherID = MT0810.VoucherID
								Where isnull(TransferPeriodID,'')=@EndPeriodID --and
								---PeriodID in (select PeriodID From MT1631 Where ProcedureID =@ProcedureID)
								)
	

	Insert MT1634 (FixProductID,ProductID, PeriodID, QuantityUnit, ConvertedUnit)
	Select @FixProductID, MaterialID, N.PeriodID, QuantityUnit*@QuantityUnit, ConvertedUnit
	 From MT4000   inner join (Select distinct ProductID, PeriodID From  MT1001 inner join MT0810 on MT1001.VoucherID = MT0810.VoucherID
								Where isnull(TransferPeriodID,'')=@EndPeriodID --and
								---PeriodID in (select PeriodID From MT1631 Where ProcedureID =@ProcedureID)
								) N
	on N.ProductID = MT4000.MaterialID

	where 	----MT4000.PeriodID =@EndPeriodID and 
		MT4000.ProductID = @MaterialID 
	
	Delete MT1634  Where FixProductID=@FixProductID and PeriodID =@EndPeriodID and ProductID = @MaterialID	
  End
*/