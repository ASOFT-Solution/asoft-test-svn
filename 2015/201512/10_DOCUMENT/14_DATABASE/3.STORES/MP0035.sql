
/****** Object:  StoredProcedure [dbo].[MP0035]    Script Date: 08/02/2010 14:15:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



--- Created by Dang Le Bao Quynh, Date 04/09/2009.
--- purpose: Tu dong insert but toan chiet tinh gia thanh theo quy trinh


/********************************************
'* Edited by: [GS] [Thanh Trẫm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0035] 	@DivisionID  nvarchar(50),
					@TranMonth  int,
					@TranYear int,
					@ProcedureID nvarchar(50),
					@UserID nvarchar(50)
AS
Declare 	@DetailCostID as nvarchar(50),
		@VoucherID as nvarchar(50),
		@VoucherTypeID as nvarchar(50),
		@EmployeeID  as nvarchar(50),
		@Description  as nvarchar(250),		
		@VoucherNo     as nvarchar(50),
		@Voucherdate Datetime, 
		@Cursor as cursor,
		@CharMonth as nvarchar(50),
		@CharYear as nvarchar(50),
		@CharDate as nvarchar(50),

		@ProductID as nvarchar(50), 
		@MaterialID as nvarchar(50), 
		@ExpenseID as nvarchar(50), 
		@MaterialTypeID as nvarchar(50), 
		@QuantityUnit as money, 
		@ConvertedUnit as money

Set @CharDate =(Case when @TranMonth in (1,3,5,7,8,10,12) then '31'
			else Case when @TranMonth in (4,6,9,11) then '30' else '28' end end)


Set @CharYear = ltrim(@TranYear)
if @TranMonth <10 
	Set @CharMonth='0'+ltrim(@TranMonth)
Else
	Set @CharMonth=ltrim(@TranMonth)

Set @VoucherDate =@CharMonth+'/'+@CharDate+'/'+@CharYear

Select @VoucherTypeID= VoucherTypeID, @EmployeeID=EmployeeID, @Description=Description From MT0001 Where TableID='MT4000' AND DivisionID = @DivisionID  --- Du lieu chiet tinh gia thanh
Exec AP0000  @DivisionID, @VoucherNo  OUTPUT, 'AT9000', @VoucherTypeID, @CharMonth, @CharYear, 15, 3, 1, '-'

Set @VoucherID=null
Exec AP0000  @DivisionID, @VoucherID  OUTPUT, 'MT1632', 'DP', @charYear ,@charMonth,16, 3, 0, '-'

While   exists (Select top 1 1 From MT1632 Where VoucherID=@VoucherID AND DivisionID = @DivisionID)
	Begin
		Set @VoucherID=null
		Exec AP0000  @DivisionID, @VoucherID  OUTPUT, 'MT1632', 'DP', @charYear ,@charMonth,16, 3, 0, '-'
	End

Set @Cursor = cursor static for 
Select 	ProductID, MaterialID, ExpenseID, MaterialTypeID, QuantityUnit, ConvertedUnit
From MV1633
Order by ProductID, ExpenseID, MaterialTypeID, MaterialID

Open @Cursor

Fetch Next From @Cursor Into  @ProductID, @MaterialID, @ExpenseID, @MaterialTypeID, @QuantityUnit, @ConvertedUnit
While @@Fetch_Status = 0
Begin
	Set @DetailCostID=null
	Exec AP0000  @DivisionID, @DetailCostID  OUTPUT, 'MT1632', 'DC', @CharYear ,@CharMonth,16, 3, 0, '-'

	While   exists (Select top 1 1 From MT1632 Where DetailCostID=@DetailCostID AND DivisionID = @DivisionID)
	Begin
		Set @DetailCostID=null
		Exec AP0000  @DivisionID, @DetailCostID  OUTPUT, 'MT1632', 'CP', @CharYear ,@CharMonth,16, 3, 0, '-'
	End
	
	Insert Into MT1632 
			(	
				DetailCostID, ProcedureID, ProductID, ExpenseID, MaterialID, ConvertedUnit, QuantityUnit, MaterialTypeID,
				VoucherID,TranMonth,TranYear,DivisionID, 
				VoucherTypeID, VoucherNo, VoucherDate, EmployeeID, Description, 
				CreateDate,CreateUserID,LastModifyUserID,LastModifyDate
			) 
	Values		
			(	
				@DetailCostID, @ProcedureID, @ProductID, @ExpenseID, @MaterialID, @ConvertedUnit, @QuantityUnit, @MaterialTypeID,
				@VoucherID, @TranMonth, @TranYear, @DivisionID, 
				@VoucherTypeID, @VoucherNo, @VoucherDate, @EmployeeID, @Description, 
				getDate(), @UserID, @UserID, getDate()
			)
	Fetch Next From @Cursor Into  @ProductID, @MaterialID, @ExpenseID, @MaterialTypeID, @QuantityUnit, @ConvertedUnit
End

Update MT1630 Set IsDetailCost=1 Where ProcedureID=@ProcedureID