IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP05241]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP05241]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



--Created by Khanh Van
--Date 01/07/2013
--Purpose: Update phieu xuat kho thanh pham nhap nguyen lieu khi sua


CREATE PROCEDURE [dbo].[AP05241]	@DivisionID nvarchar(50), 		
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
Declare 
	@Ex_Cur as cursor,
	@Im_Cur as cursor,
	@Tmp_TransactionID as nvarchar(50),
	@New_InventoryID as nvarchar(50),
	@Tmp_UnitID as nvarchar(50),
	@Tmp_Quantity as decimal(28,8),
	@Tmp_CreditAccountID as nvarchar(50),
	@Tmp_DebitAccountID as nvarchar(50),
	@Orders as int



BEGIN
	if exists (select  top  1 1  from AT2007 where VoucherID = @NewVoucherID and DivisionID = @DivisionID)
		Begin
			set @Orders = ( select max(Orders) from AT2007  where VoucherID = @NewVoucherID) + 1
		End
		else
		Begin
			set  @Orders = 1
		end		
	
	Begin
		Set @Ex_Cur = CURSOR SCROLL KEYSET FOR
			Select InventoryID, UnitID, 1, @CreditAccountID_New
			From  AT1302
			Where  InventoryID = @InventoryID and DivisionID = @DivisionID
	end	

	OPEN @Ex_Cur
	FETCH NEXT FROM @Ex_Cur INTO @New_InventoryID, @Tmp_UnitID, @Tmp_Quantity, @Tmp_CreditAccountID

	WHILE @@FETCH_STATUS = 0
	  Begin
		EXEC AP0000 @DivisionID, @Tmp_TransactionID OUTPUT, 'AT2007', 'EX', @TranYear, '', 16, 3, 0, ''
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
		
		FETCH NEXT FROM @Ex_Cur INTO @New_InventoryID, @Tmp_UnitID, @Tmp_Quantity, @Tmp_CreditAccountID
		Set @Orders = @Orders + 1
	  End
	CLOSE @Ex_Cur
  END	
BEGIN
	if exists (select  top  1 1  from AT2007 where VoucherID = 'NNL'+@NewVoucherID and DivisionID = @DivisionID)
		Begin
			set @Orders = ( select max(Orders) from AT2007  where VoucherID = 'NNL'+@NewVoucherID) + 1
		End
		else
		Begin
			set  @Orders = 1
		end		
	
	Begin
		Set @Im_Cur = CURSOR SCROLL KEYSET FOR
			Select MaterialID, MaterialUnitID, QuantityUnit, AT1302.AccountID
			From MT1603 inner join AT1302 on AT1302.InventoryID = MT1603.MaterialID and AT1302.DivisionID = MT1603.DivisionID
			Where ExpenseID = 'COST001' and ApportionID = @ApportionID
				and ProductID = @InventoryID and MT1603.DivisionID = @DivisionID
	End	
		
	OPEN @Im_Cur
	FETCH NEXT FROM @Im_Cur INTO @New_InventoryID, @Tmp_UnitID, @Tmp_Quantity, @Tmp_DebitAccountID

	WHILE @@FETCH_STATUS = 0
	  Begin
		EXEC AP0000 @DivisionID, @Tmp_TransactionID OUTPUT, 'AT2007', 'IM', @TranYear, '', 16, 3, 0, ''
		INSERT INTO AT2007 	(Orders,TransactionID, DivisionID, VoucherID, TranYear, TranMonth, BatchID,			
					InventoryID, UnitID, ActualQuantity, DebitAccountID, CreditAccountID,    
					Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, 
					Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
					Notes, PeriodID, ProductID, OrderID, 
					ConversionFactor, OTransactionID)
			VALUES	 (@Orders,@Tmp_TransactionID, @DivisionID, 'NNL'+@NewVoucherID, @TranYear, @TranMonth, @NewVoucherID,  				
					@New_InventoryID, @Tmp_UnitID, @Tmp_Quantity*@NewQuantity, @Tmp_DebitAccountID,@DebitAccountID_New,     
					@Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID, 
					@Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID, 
					@Notes, @PeriodID, @InventoryID, @OrderID, 
					@ConversionFactor,@OTransactionID)
		
		FETCH NEXT FROM @Im_Cur INTO @New_InventoryID, @Tmp_UnitID, @Tmp_Quantity, @Tmp_DebitAccountID
		Set @Orders = @Orders + 1
	  End
	CLOSE @Im_Cur
  END
