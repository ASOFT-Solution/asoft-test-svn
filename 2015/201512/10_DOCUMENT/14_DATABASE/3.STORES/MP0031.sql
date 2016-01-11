
/****** Object:  StoredProcedure [dbo].[MP0031]    Script Date: 08/02/2010 14:08:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



---- Created by Van Nhan, Date 07/05/2009.
---- Purporse: Luu gia tri phan bo tu bang tam MT0621 qua bang MT0400
---- Edit by: Dang Le Bao Quynh; Date 03/09/2009
---- Purpose: Sua lai cach sinh IGE

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [02/08/2010]
'********************************************/

ALTER PROCEDURE	[dbo].[MP0031] 	@DivisionID as nvarchar(50),
						@PeriodID as nvarchar(50),
						@TranMonth int,
						@TranYear int
 AS

Declare 	@VoucherID as nvarchar(50),
		@VoucherTypeID as nvarchar(50),
		@EmployeeID  as nvarchar(50),
		@Description  as nvarchar(250),
		@TransactionID as   nvarchar(50),
		@MaterialID  as   nvarchar(50),
		@ProductID as    nvarchar(50),
		@UnitID as nvarchar(50),
		@Quantity as decimal(28,8),
		@QuantityUnit  as decimal(28,8),
		@MaterialTypeID as nvarchar(50),
		@ConvertedAmount as money,
		@ConvertedUnit as money,	
		@ProductQuantity  as decimal(28,8),
		@ExpenseID as nvarchar(50),
		@ApportionCostID as nvarchar(50),	 		
		@MaterialQuantity   as decimal(28,8),
		@voucherNo     as nvarchar(50),
		@Voucherdate Datetime, 
		@Cursor as cursor,
		@charMonth as nvarchar(50),
		@charYear as nvarchar(50),
		@CharDate as nvarchar(50)

Set @CharDate =(Case when @TranMonth in (1,3,5,7,8,10,12) then '31'
			else Case when @TranMonth in (4,6,9,11) then '30' else '28' end end)


Set @charYear = ltrim(rtrim(str(@TranYear)))
if @TranMonth <10 
	Set @charMonth='0'+ltrim(rtrim(str(@TranMonth)))
Else
	Set @charMonth=ltrim(rtrim(str(@TranMonth)))

Set @VoucherDate =@charMonth+'/'+@CharDate+'/'+@charYear
Select @VoucherTypeID= VoucherTypeID, @EmployeeID=EmployeeID, @Description=Description From MT0001 Where TableID='MT0400'
--Print @VoucherTypeID+' '+@EmployeeID+' '+@Description

Exec AP0000  @DivisionID, @VoucherNo  OUTPUT, 'AT9000', @VoucherTypeID, @CharMonth, @CharYear, 15, 3, 1, '-'
--Print @CharMonth
--Print @CharYear
--Print @VoucherDate
--Print @VoucherNo

	SET @Cursor = Cursor Scroll KeySet FOR 	
		Select MaterialID, ProductID, UnitID, ExpenseID, Quantity, QuantityUnit, MaterialTypeID, ConvertedAmount, ConvertedUnit ,ProductQuantity
		From MT0621 WHERE DivisionID = @DivisionID
		Open @Cursor
		FETCH NEXT FROM @Cursor INTO  @MaterialID, @ProductID, @UnitID, @ExpenseID, @Quantity, @QuantityUnit, @MaterialTypeID, @ConvertedAmount, @ConvertedUnit ,@ProductQuantity			
		WHILE @@Fetch_Status = 0 
		Begin
			
			Set @ApportionCostID=null
			Exec AP0000  @DivisionID, @ApportionCostID  OUTPUT, 'MT0400', 'MA', @TranYear ,'',16, 3, 0, '-'
			---Print ' Ma so:+'+@ApportionCostID+' sp: ' +@ProductID+' ch iphi +'+str(@ConvertedAmount)
			while   exists (Select top 1 1 From MT0400 Where ApportionCostID=@ApportionCostID)
				Begin
					Set @ApportionCostID=null
					Exec AP0000  @DivisionID,@ApportionCostID  OUTPUT, 'MT0400', 'MA', @TranYear ,'',16, 3, 0, '-'
				End 
			Insert MT0400 (ApportionCostID, PeriodID, MaterialQuantity, ProductQuantity, ConvertedAmount, ConvertedUnit, QuantityUnit,
					 ProductID, MaterialID, ExpenseID,TranMonth, TranYear, DivisionID, Description,
					  VoucherNo, VoucherDate, EmployeeID, Automatic, MaterialTypeID, VoucherTypeID,     UnitID)
			Values (@ApportionCostID, @PeriodID, @MaterialQuantity, @ProductQuantity, @ConvertedAmount, @ConvertedUnit, @QuantityUnit,
					 @ProductID, @MaterialID, @ExpenseID,@TranMonth, @TranYear, @DivisionID, @Description,
					  @VoucherNo, @VoucherDate, @EmployeeID, 0, @MaterialTypeID, @VoucherTypeID,     @UnitID)
				
			FETCH NEXT FROM @Cursor INTO  @MaterialID, @ProductID, @UnitID, @ExpenseID, @Quantity, @QuantityUnit, @MaterialTypeID, @ConvertedAmount, @ConvertedUnit ,@ProductQuantity
		End
		Close @Cursor		
---Print 'Update MT1601 Set IsDistribute =1 Where PeriodID =@PeriodID'		
Update MT1601 Set IsDistribute =1 Where PeriodID =@PeriodID AND DivisionID = @DivisionID
---ID  Rate 
--- 400
--