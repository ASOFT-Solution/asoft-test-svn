/****** Object:  StoredProcedure [dbo].[AP0524]    Script Date: 07/29/2010 09:04:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



--Created by Nguyen Thi Ngoc Minh
--Date 23/10/2004
--Purpose: Update phieu xuat kho khi update phieu xuat kho theo bo
--Last edit: Thuy Tuyen ,date: 08/07/2009
--Last edit: Bao Quynh ,date: 16/11/2009
--Purpose: Sua lai cau lenh Insert bi trung column Orders
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP0524]	@DivisionID nvarchar(50), 		
				@ApportionID nvarchar(50),
				@TranMonth int, 			
				@TranYear int, 
				@OldVoucherID nvarchar(50), 		
				@NewVoucherID nvarchar(50), 
				@BatchID nvarchar(50), 			
				@InventoryID nvarchar(50), 
				@UnitID nvarchar(50), 			
				@NewQuantity decimal(28,8),
				@DebitAccountID_New nvarchar(50),	
				@CreditAccountID_New nvarchar(50),
				@ConversionFactor decimal(28,8),		
				@Ana01ID nvarchar(50),
	 			@Ana02ID nvarchar(50), 			
	 			@Ana03ID nvarchar(50), 			
	 			@Ana04ID nvarchar(50),
	 			@Ana05ID nvarchar(50), 			
	 			@Ana06ID nvarchar(50), 			
	 			@Ana07ID nvarchar(50), 			
	 			@Ana08ID nvarchar(50),
	 			@Ana09ID nvarchar(50), 			
	 			@Ana10ID nvarchar(50), 			
				@Notes nvarchar(250), 			
				@PeriodID nvarchar(50), 		
				@OrderID nvarchar(50), 			
				@Table nvarchar(250),
				@OTransactionID nvarchar(50)
AS
Declare @MT1603_Cur as cursor,
	@AT1326_Cur as cursor,
	@Tmp_TransactionID as nvarchar(50),
	@New_InventoryID as nvarchar(50),
	@Tmp_UnitID as nvarchar(50),
	@Tmp_Quantity as decimal(28,8),
	@Tmp_CreditAccountID as nvarchar(50),
	@Orders as int

----- Xoa di phan tinh toan cu truoc do 
--Edit by Quoc Huy
/*
DELETE AT2007 WHERE VoucherID = @OldVoucherID and 	DivisionID = @DivisionID 
		and TranMonth = @TranMonth and TranYear = @TranYear  and ProductID = @InventoryID
*/

--print  '@OldVoucherID: ' + @OldVoucherID
--print  '@InventoryID: ' + @InventoryID
--print  '@Tmp_TransactionID: ' + ISNULL(@Tmp_TransactionID,'')

if exists (select  top  1 1  from AT2007 where VoucherID = @NewVoucherID and DivisionID = @DivisionID)
		Begin
			set @Orders = ( select max(Orders) from AT2007  where VoucherID = @NewVoucherID) + 1
		End
		else
		Begin
			set  @Orders = 1
		end		
	
If @Table like 'MT1603'
  BEGIN
		

if  isnull(@ApportionID,'')  <>  '' 
	Begin
		Set @MT1603_Cur = CURSOR SCROLL KEYSET FOR
			Select MaterialID, MaterialUnitID, QuantityUnit, AT1302.AccountID
			From MT1603 inner join AT1302 on AT1302.InventoryID = MT1603.MaterialID and AT1302.DivisionID = MT1603.DivisionID
			Where ExpenseID = 'COST001' and ApportionID = @ApportionID
				and ProductID = @InventoryID and MT1603.DivisionID = @DivisionID
	End	
	else
	Begin
		Set @MT1603_Cur = CURSOR SCROLL KEYSET FOR
			Select InventoryID, UnitID, 1, @CreditAccountID_New
			From  AT1302
			Where  InventoryID = @InventoryID and DivisionID = @DivisionID
	end	

		
	OPEN @MT1603_Cur
	FETCH NEXT FROM @MT1603_Cur INTO @New_InventoryID, @Tmp_UnitID, @Tmp_Quantity, @Tmp_CreditAccountID

	WHILE @@FETCH_STATUS = 0
	  Begin
		EXEC AP0000 @DivisionID, @Tmp_TransactionID OUTPUT, 'AT2007', 'BD', @TranYear, '', 16, 3, 0, ''
		INSERT INTO AT2007 	(Orders,TransactionID, DivisionID, VoucherID, TranYear, TranMonth, BatchID,			
					InventoryID, UnitID, ActualQuantity, DebitAccountID, CreditAccountID,    
					Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, 
					Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
					Notes, PeriodID, ProductID, OrderID, 
					ConversionFactor, OTransactionID)
			VALUES	 (@Orders,@Tmp_TransactionID, @DivisionID, @NewVoucherID, @TranYear, @TranMonth, @NewVoucherID,  				
					@New_InventoryID, @Tmp_UnitID, @Tmp_Quantity*@NewQuantity, @DebitAccountID_New, @Tmp_CreditAccountID,    
					@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, 
					@Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID, 
					@Notes, @PeriodID, @InventoryID, @OrderID, 
					@ConversionFactor,@OTransactionID)
		
		FETCH NEXT FROM @MT1603_Cur INTO @New_InventoryID, @Tmp_UnitID, @Tmp_Quantity, @Tmp_CreditAccountID
		Set @Orders = @Orders + 1
	  End
	CLOSE @MT1603_Cur
  END
Else 
BEGIN
	if  isnull(@ApportionID,'')  <>  '' 
	begin
		Set @AT1326_Cur = CURSOR SCROLL KEYSET FOR
			Select ItemID, ItemUnitID, ItemQuantity/InventoryQuantity, AT1302.AccountID
			From AT1326 inner join AT1302 on AT1302.InventoryID = AT1326.ItemID and AT1302.DivisionID = AT1326.DivisionID
			Where AT1326.KITID = @ApportionID
			and AT1326.InventoryID = @InventoryID and AT1326.DivisionID = @DivisionID
	end
	else 
	begin
		Set @AT1326_Cur = CURSOR SCROLL KEYSET FOR
			Select InventoryID, UnitID, 1, @CreditAccountID_New
			From  AT1302
			Where  InventoryID = @InventoryID and DivisionID = @DivisionID
	end

		
	OPEN @AT1326_Cur
	FETCH NEXT FROM @AT1326_Cur INTO @New_InventoryID, @Tmp_UnitID, @Tmp_Quantity, @Tmp_CreditAccountID

	WHILE @@FETCH_STATUS = 0
	  Begin
		EXEC AP0000 @DivisionID, @Tmp_TransactionID OUTPUT, 'AT2007', 'BD', @TranYear, '', 16, 3, 0, ''
		/*
		if @New_InventoryID = 'VLNU0006'
		begin	
			print '@New_InventoryID: ' + @New_InventoryID
			print '@ApportionID: ' + @ApportionID
			print '@Tmp_Quantity: ' + str(@Tmp_Quantity)
			print '@NewQuantity: ' + str(@NewQuantity)	
			set @Notes = 'huy'
		end
		*/

		INSERT INTO AT2007 	(Orders,TransactionID, DivisionID, VoucherID, TranYear, TranMonth, BatchID,			
					InventoryID, UnitID, ActualQuantity, DebitAccountID, CreditAccountID,    
					Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, 
					Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
					Notes, PeriodID, ProductID, OrderID, 
					ConversionFactor,OTransactionID)
			VALUES	 (@Orders,@Tmp_TransactionID, @DivisionID, @NewVoucherID, @TranYear, @TranMonth, @NewVoucherID,  				
					@New_InventoryID, @Tmp_UnitID, @Tmp_Quantity*@NewQuantity, @DebitAccountID_New, @Tmp_CreditAccountID,    
					@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, 
					@Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID, 
					@Notes, @PeriodID, @InventoryID, @OrderID, 
					@ConversionFactor,@OTransactionID)
		
		FETCH NEXT FROM @AT1326_Cur INTO @New_InventoryID, @Tmp_UnitID, @Tmp_Quantity, @Tmp_CreditAccountID
		Set @Orders = @Orders + 1
	  End
	CLOSE @AT1326_Cur
  END