/****** Object:  StoredProcedure [dbo].[AP3724]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
---- Created by Nguyen Quoc Huy, Date: 12/09/2007
---- Purpose: Cap nhat gia nhap kho cho phieu nhap kho mua hang.

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh



ALTER PROCEDURE [dbo].[AP3724] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50) 

 AS
Declare 	@Cur_AT2007 as cursor,
		@BatchID as nvarchar(50),	
		@TransactionID as nvarchar(50),	
		@ReVoucherID as nvarchar(50),	
		@ReBatchID as nvarchar(50),	
		@ReTransactionID as nvarchar(50),	
		@InventoryID as nvarchar(50),	
		@DebitAccountID as nvarchar(50),
		@CreditAccountID as nvarchar(50),
		@ConvertedAmount as decimal(28,8),
		@ImTaxConvertedAmount as decimal(28,8),
		@ExpenseConvertedAmount as decimal(28,8),
		@Quantity as decimal(28,8),
		@UnitID as nvarchar(50),
		@OriginalQuantity as decimal(28,8),
		@OriginalUnitID as nvarchar(50),
		@UnitCostDecimals  as tinyint, 
		@ConvertedDecimals as tinyint

Select @UnitCostDecimals = UnitCostDecimals, @ConvertedDecimals = ConvertedDecimals
FROM AT1101
WHERE DivisionID = @DivisionID

Set @UnitCostDecimals = isnull( @UnitCostDecimals,2)
Set @ConvertedDecimals = isnull( @ConvertedDecimals,2)



SET @Cur_AT2007  = Cursor Scroll KeySet FOR 	
Select 		BatchID,TransactionID, ReVoucherID, ReTransactionID, InventoryID,
		DebitAccountID,CreditAccountID,
		ConvertedAmount,ImTaxConvertedAmount,ExpenseConvertedAmount
		

From AT9000 Where DivisionID = @DivisionID and
			TranMonth = @TranMonth  and
			TranYear = @TranYear  and
			VoucherID = @VoucherID  and
			TransactionTypeID <> 'T23'
			---Loai ra nhung phieu mua hang dich vu
			and isnull(OrderID,'') not like 'POS%'
			and isnull(ReVoucherID,'') not like 'POS%'

OPEN	@Cur_AT2007
FETCH NEXT FROM @Cur_AT2007 INTO  @BatchID, @TransactionID,  @ReVoucherID, @ReTransactionID, @InventoryID, @DebitAccountID, @CreditAccountID,  @ConvertedAmount, @ImTaxConvertedAmount, @ExpenseConvertedAmount 
WHILE @@Fetch_Status = 0
Begin

	Update AT2007 Set 	DebitAccountID = @DebitAccountID,
				CreditAccountID = @CreditAccountID,
				OriginalAmount = Round (isnull(@ConvertedAmount,0) + isnull(@ImTaxConvertedAmount,0) + isnull(@ExpenseConvertedAmount,0), @ConvertedDecimals),
				ConvertedAmount = Round (isnull(@ConvertedAmount,0) + isnull(@ImTaxConvertedAmount,0) + isnull(@ExpenseConvertedAmount,0), @ConvertedDecimals),
				UnitPrice = Round( (isnull(@ConvertedAmount,0) + isnull(@ImTaxConvertedAmount,0) + isnull(@ExpenseConvertedAmount,0))/isnull(ActualQuantity,1), @UnitCostDecimals)
	Where 		VoucherID = @ReVoucherID and
			TransactionID = @ReTransactionID and 
			InventoryID = @InventoryID

							
FETCH NEXT FROM @Cur_AT2007 INTO  @BatchID, @TransactionID, @ReVoucherID, @ReTransactionID, @InventoryID, @DebitAccountID, @CreditAccountID, @ConvertedAmount, @ImTaxConvertedAmount, @ExpenseConvertedAmount 
End

Close @Cur_AT2007

Update AT9000 Set IsStock = 1
Where DivisionID = @DivisionID and
			TranMonth = @TranMonth  and
			TranYear = @TranYear  and
			VoucherID = @VoucherID
			---Loai ra nhung phieu mua hang dich vu
			and isnull(OrderID,'') not like 'POS%'
			and isnull(ReVoucherID,'') not like 'POS%'
GO
