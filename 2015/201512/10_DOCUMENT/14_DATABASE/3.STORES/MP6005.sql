if exists (select * from dbo.sysobjects where id = object_id(N'MP6005') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [MP6005]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

--Create by: Dang Le Bao Quynh, Date: 17/06/2011
--Purpose: Xu ly phan bo doi tuong theo he so lay tu gia tri don hang san xuat
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần tiền hạch toán theo thiết lập đơn vị-chi nhánh

CREATE PROCEDURE MP6005 	@DivisionID as nvarchar(50),
					@PeriodID as nvarchar(50),
					@CMonth as int ,  
					@CYear as int,
					@VoucherID as nvarchar(50),
					@BatchID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int
As 
Declare @sSQL as nvarchar(4000),
	@SumCovalue as Decimal(28,8),
	@ChildPeriodID_Cur as cursor,
	@ChildPeriodID as nvarchar(50),
	@ConvertedAmount as Decimal(28,8),
	@PeriodConv as Decimal(28,8),
	@ChildConv as Decimal(28,8),
	@ExpenseID as nvarchar(50),
	@MaterialTypeID as nvarchar(50),
	@TransactionID as nvarchar(50),
	@Covalue as Decimal(28,8),
	@PeriodID_Cur as cursor,
	@ConvertedDecimal as Decimal(28,8),
	@DebitAccountID as nvarchar(50),	
	@CreditAccountID as nvarchar(50),
	@Quantity as Decimal(28,8),
	@ChildQConv as Decimal(28,8),
	@InventoryID as nvarchar(50),
	@CurrencyID as nvarchar(50),
	@ExchangeRate  as Decimal(28,8)

SET @ConvertedDecimal = (Select ConvertDecimal FROM MT0000 where DivisionID = @DivisionID)
Set @ConvertedDecimal = isnull(@ConvertedDecimal,2)

Set @CurrencyID = isnull ((Select  top 1 BaseCurrencyID From AT1101  where DivisionID = @DivisionID ),'VND')
Set @ExchangeRate = 1

--Lay he so tong
Set @SumCovalue = 
(Select Sum(OT2002.OrderQuantity*Isnull((Case When Isnull(OT02.OrderQuantity,0) = 0 Then 0 Else Round(OT02.ConvertedAmount/OT02.OrderQuantity,0) End),0))
From OT2001 Inner Join OT2002 On OT2001.SOrderID = OT2002.SOrderID and OT2001.DivisionID = OT2002.DivisionID
Inner Join OT2002 OT02 On OT2001.InheritSOrderID = OT02.SOrderID and OT2001.DivisionID = OT02.DivisionID
and OT2002.InventoryID = OT02.InventoryID
Where 	OT2001.OrderType=1 And 
	OT2001.OrderStatus=1 And 
	OT2001.PeriodID In (Select ChildPeriodID From MT1609 Where PeriodID = @PeriodID and DivisionID =  @DivisionID)
	and OT2001.DivisionID =  @DivisionID
)


--Lay he so theo doi tuong
Set @ChildPeriodID_Cur = CURSOR SCROLL KEYSET FOR 
	Select OT2001.PeriodID, Sum(OT2002.OrderQuantity*Isnull((Case When Isnull(OT02.OrderQuantity,0) = 0 Then 0 Else Round(OT02.ConvertedAmount/OT02.OrderQuantity,0) End),0))
	From OT2001 Inner Join OT2002 On OT2001.SOrderID = OT2002.SOrderID and OT2001.DivisionID = OT2002.DivisionID
	Inner Join OT2002 OT02 On OT2001.InheritSOrderID = OT02.SOrderID and OT2001.DivisionID = OT02.DivisionID
	and OT2002.InventoryID = OT02.InventoryID
	Where 	OT2001.OrderType=1 And 
		OT2001.OrderStatus=1 And 
		OT2001.PeriodID In (Select ChildPeriodID From MT1609 Where PeriodID = @PeriodID and DivisionID =  @DivisionID)
		and OT2001.DivisionID =  @DivisionID
	Group By OT2001.PeriodID

OPEN	@ChildPeriodID_Cur
FETCH NEXT FROM @ChildPeriodID_Cur INTO @ChildPeriodID, @CoValue
			
WHILE @@Fetch_Status = 0
Begin
---- Phan bo chi phi SXC
	--Lay tong tien cua doi tuong cha
	Set @PeriodID_Cur = Cursor Scroll KeySet FOR 
		 Select Sum(ConvertedAmount) as ConvertedAmount , MaterialTypeID, DebitAccountID, CreditAccountID
		 From MV9000
		 Where PeriodID = @PeriodID and DivisionID = @DivisionID and ExpenseID = 'COST003'  and isnull(MaterialTypeID,'')<>''
		 Group by MaterialTypeID, DebitAccountID, CreditAccountID
	
	OPEN	@PeriodID_Cur
	FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount , @MaterialTypeID, @DebitAccountID, @CreditAccountID
	WHILE @@Fetch_Status = 0
	Begin
		If (@SumCovalue<>0)
		Begin
			Set @ChildConv = (Isnull(@ConvertedAmount,0) * Isnull(@Covalue,0))/@SumCovalue
			Set @ChildQConv = (Isnull(@Quantity,0) * Isnull(@Covalue,0))/@SumCovalue
		End
		Else 
		Begin
			Set @ChildConv = 0 
			Set @ChildQConv = 0 
		End
	
		Set @ChildConv = round(@ChildConv, @ConvertedDecimal)	
		Set @ChildQConv = round(@ChildQConv, @ConvertedDecimal)	
	
		Exec AP0000  @DivisionID, @TransactionID  OUTPUT, 'MT9000', 'IT', @CMonth, @CYear ,18, 3, 0, '-'
	
		Insert MT9000 (ParentPeriodID, VoucherID, BatchID, DivisionID, TransactionID , ExpenseID,  MaterialTypeID, 
				OriginalAmount, ConvertedAmount ,PeriodID,  Status, CreateDate,IsFromPeriodID,
			DebitAccountID,CreditAccountID,TransactiontypeID,TranMonth,TranYear,Quantity,InventoryID,CurrencyID, ExchangeRate)
	             Values (@PeriodID, @VoucherID,@BatchID,@DivisionID,@TransactionID,'COST003',@MaterialTypeID,
			@ChildConv, @ChildConv,@ChildPeriodID,0,GetDate() , 1,
			 @DebitAccountID, @CreditAccountID,' ',@TranMonth,@TranYear,@ChildQConv,@InventoryID, @CurrencyID, @ExchangeRate)
			
		FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount , @MaterialTypeID, @DebitAccountID, @CreditAccountID
	
	End
	Close @PeriodID_Cur
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Phan bo chi phi nhan cong

	--Lay tong tien cua doi tuong cha
	Set @PeriodID_Cur = Cursor Scroll KeySet FOR 
		 Select Sum(ConvertedAmount) as ConvertedAmount ,Sum(Isnull(Quantity,0)) As Quantity, MaterialTypeID,
			 DebitAccountID, CreditAccountID
		 From MV9000
		 Where PeriodID = @PeriodID and DivisionID = @DivisionID and ExpenseID = 'COST002'  and isnull(MaterialTypeID,'')<>''
		Group by MaterialTypeID, DebitAccountID, CreditAccountID
	
	OPEN	@PeriodID_Cur
	FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount , @Quantity, @MaterialTypeID, @DebitAccountID, @CreditAccountID
	WHILE @@Fetch_Status = 0
	Begin
		If (@SumCovalue<>0)
		Begin
			Set @ChildConv = (Isnull(@ConvertedAmount,0) * Isnull(@Covalue,0))/@SumCovalue
			Set @ChildQConv = (Isnull(@Quantity,0) * Isnull(@Covalue,0))/@SumCovalue
		End
		Else 
		Begin
			Set @ChildConv = 0 
			Set @ChildQConv = 0 
		End
	
		Set @ChildConv = round(@ChildConv, @ConvertedDecimal)	
		Set @ChildQConv = round(@ChildQConv, @ConvertedDecimal)	
	
		Exec AP0000  @DivisionID, @TransactionID  OUTPUT, 'MT9000', 'IT', @CMonth, @CYear ,18, 3, 0, '-'
	
		Insert MT9000 (ParentPeriodID, VoucherID, BatchID, DivisionID, TransactionID , ExpenseID,  MaterialTypeID, 
			OriginalAmount, ConvertedAmount ,PeriodID,  Status, CreateDate,IsFromPeriodID,
			DebitAccountID,CreditAccountID,transactiontypeID,TranMonth,TranYear,Quantity, CurrencyID, ExchangeRate)
	             Values (@PeriodID, @VoucherID,@BatchID,@DivisionID,@TransactionID,'COST002',@MaterialTypeID,
			@ChildConv, @ChildConv,@ChildPeriodID,0,GetDate() , 1,
			 @DebitAccountID, @CreditAccountID,' ',@TranMonth,@TranYear,@ChildQConv,@CurrencyID, @ExchangeRate)
		
		FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount , @Quantity, @MaterialTypeID, @DebitAccountID, @CreditAccountID
	End
	Close @PeriodID_Cur

---- Phan bo chi phi NVL
	---- Lay tong tien cua doi tuong cha
	Set @PeriodID_Cur = Cursor Scroll KeySet FOR 
		 Select Sum(isnull(ConvertedAmount,0)) as ConvertedAmount ,Sum(Isnull(Quantity,0)) As Quantity,MaterialTypeID, InventoryID,
			DebitAccountID, CreditAccountID
		 From MV9000
		 Where PeriodID = @PeriodID and DivisionID = @DivisionID and ExpenseID = 'COST001'  and isnull(MaterialTypeID,'')<>''
		Group by MaterialTypeID, InventoryID,  DebitAccountID, CreditAccountID
	
	OPEN	@PeriodID_Cur
	FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount , @Quantity, @MaterialTypeID, @InventoryID,  @DebitAccountID, @CreditAccountID
	
	WHILE @@Fetch_Status = 0
	BEGIN
		Set @TranMonth=(Select distinct TranMonth from MV9000 Where PeriodID = @PeriodID and DivisionID = @DivisionID and ExpenseID = 'COST001' )
		Set @TranYear=(Select distinct TranYear from MV9000 Where PeriodID = @PeriodID and DivisionID = @DivisionID and ExpenseID = 'COST001' )
	
		If (@SumCovalue<>0)
		Begin
			Set @ChildConv = (Isnull(@ConvertedAmount,0) * Isnull(@Covalue,0))/@SumCovalue
			Set @ChildQConv = (Isnull(@Quantity,0) * Isnull(@Covalue,0))/@SumCovalue
		End
		Else 
		Begin
			Set @ChildConv = 0 
			Set @ChildQConv = 0 
		End
	
		Set @ChildConv = round(@ChildConv, @ConvertedDecimal)	
		Set @ChildQConv = round(@ChildQConv, @ConvertedDecimal)	
	
		Exec AP0000  @DivisionID, @TransactionID  OUTPUT, 'MT9000', 'IT', @CMonth, @CYear ,18, 3, 0, '-'
	
		Insert MT9000 (ParentPeriodID, VoucherID, BatchID, DivisionID, TransactionID , ExpenseID,  MaterialTypeID, 
			OriginalAmount, ConvertedAmount , PeriodID,  Status, CreateDate, IsFromPeriodID, DebitAccountID, 
			CreditAccountID, TransactiontypeID, TranMonth,TranYear,Quantity,InventoryID, CurrencyID, ExchangeRate)
	             Values (@PeriodID, @VoucherID,@BatchID,@DivisionID,@TransactionID,'COST001',@MaterialTypeID,
			@ChildConv, @ChildConv, @ChildPeriodID,0,GetDate() , 1,  @DebitAccountID, @CreditAccountID,' ', 
			@TranMonth, @TranYear, @ChildQConv,@InventoryID,@CurrencyID, @ExchangeRate )
	
	
	
		FETCH NEXT FROM @PeriodID_Cur INTO @ConvertedAmount , @Quantity,@MaterialTypeID,@InventoryID,
					 @DebitAccountID, @CreditAccountID
	End
	Close @PeriodID_Cur
	
	FETCH NEXT FROM @ChildPeriodID_Cur INTO @ChildPeriodID,@Covalue
End
Close @ChildPeriodID_Cur

------------------------------------------------------------------------------------------------------------------
--- Xu ly chenh lech 

DECLARE @Delta_Converted decimal(28,8),
	@Delta_Quantity decimal(28,8),
	@ID nvarchar(50),
	@MaterialID nvarchar(50)

-----------Nhan cong & SXC
Set @PeriodID_Cur = CURSOR SCROLL KEYSET FOR
		Select MaterialTypeID, 	
			Sum(case when D_C = 'D' then isnull(ConvertedAmount,0) else isnull(ConvertedAmount,0) end) as ConvertedAmount ,
			Sum(case when D_C = 'D' then Isnull(Quantity,0) else isnull(Quantity,0) end) as Quantity,
			 DebitAccountID, CreditAccountID
		From MV9000
		Where PeriodID = @PeriodID and DivisionID = @DivisionID and 
			ExpenseID <> 'COST001'  and isnull(MaterialTypeID,'')<>''
		Group by MaterialTypeID, DebitAccountID, CreditAccountID

OPEN @PeriodID_Cur
FETCH NEXT FROM @PeriodID_Cur INTO @MaterialTypeID, @ConvertedAmount , @Quantity,  @DebitAccountID, @CreditAccountID

WHILE @@FETCH_STATUS = 0
BEGIN
	Set @Delta_Converted = @ConvertedAmount - (Select Sum(isnull(ConvertedAmount,0))  From MT9000
						Where  ParentPeriodID = @PeriodID and MaterialTypeID = @MaterialTypeID and 
							DebitAccountID = @DebitAccountID and CreditAccountID = @CreditAccountID) 

	Set @Delta_Quantity= @Quantity - (Select Sum(isnull(Quantity,0))  From MT9000
						Where  ParentPeriodID = @PeriodID and MaterialTypeID = @MaterialTypeID and
							DebitAccountID = @DebitAccountID and CreditAccountID = @CreditAccountID)
	IF 	@Delta_Converted <> 0
	BEGIN
		Set @ID = null
		Select  @ID =  TransactionID From MT9000
					Where  ParentPeriodID = @PeriodID and MaterialTypeID = @MaterialTypeID and
						DebitAccountID = @DebitAccountID and CreditAccountID = @CreditAccountID
					Order by ConvertedAmount desc

	IF 	 @ID  is not null 
			Update MT9000 Set OriginalAmount = OriginalAmount  + @Delta_Converted, ConvertedAmount = ConvertedAmount  + @Delta_Converted
				Where TransactionID = @ID
	END	
	

	IF 	@Delta_Quantity <> 0
	BEGIN
		Set @ID = null
		Select  @ID =  TransactionID From MT9000
					Where  ParentPeriodID = @PeriodID and MaterialTypeID = @MaterialTypeID and
						DebitAccountID = @DebitAccountID and CreditAccountID = @CreditAccountID
					Order by Quantity desc

	IF 	 @ID  is not null 
			Update MT9000 Set Quantity = Quantity + @Delta_Quantity
				Where TransactionID = @ID
	END	

	FETCH NEXT FROM @PeriodID_Cur INTO @MaterialTypeID, @ConvertedAmount , @Quantity, @DebitAccountID, @CreditAccountID
END
CLOSE @PeriodID_Cur


------NVL
Set @PeriodID_Cur = CURSOR SCROLL KEYSET FOR
		Select MaterialTypeID, 	InventoryID,
			Sum(case when D_C = 'D' then isnull(ConvertedAmount,0) else isnull(ConvertedAmount,0) end) as ConvertedAmount ,
			Sum(case when D_C = 'D' then Isnull(Quantity,0) else isnull(Quantity,0) end) as Quantity,
			DebitAccountID, CreditAccountID 
		From MV9000
		Where PeriodID = @PeriodID and DivisionID = @DivisionID and 
			ExpenseID = 'COST001'  and isnull(MaterialTypeID,'')<>''
		Group by MaterialTypeID, InventoryID, DebitAccountID, CreditAccountID 

OPEN @PeriodID_Cur
FETCH NEXT FROM @PeriodID_Cur INTO @MaterialTypeID, @MaterialID, @ConvertedAmount , @Quantity, @DebitAccountID, @CreditAccountID

WHILE @@FETCH_STATUS = 0
BEGIN
	Set @Delta_Converted = @ConvertedAmount - (Select Sum(isnull(ConvertedAmount,0))  From MT9000
						Where  ParentPeriodID = @PeriodID and 
							MaterialTypeID = @MaterialTypeID and InventoryID = @MaterialID and  
							DebitAccountID = @DebitAccountID and CreditAccountID = @CreditAccountID)


	Set @Delta_Quantity= @Quantity - (Select Sum(isnull(Quantity,0))  From MT9000
					Where  ParentPeriodID = @PeriodID and 
						MaterialTypeID = @MaterialTypeID and  InventoryID = @MaterialID and  
						DebitAccountID = @DebitAccountID and CreditAccountID = @CreditAccountID)
	IF 	@Delta_Converted <> 0
	BEGIN
		Set @ID = null
		Select  @ID =  TransactionID From MT9000
			Where  ParentPeriodID = @PeriodID and MaterialTypeID = @MaterialTypeID and	InventoryID = @MaterialID and 
					DebitAccountID = @DebitAccountID and CreditAccountID = @CreditAccountID
			Order by ConvertedAmount desc

	IF 	 @ID  is not null  
			Update MT9000 Set OriginalAmount = OriginalAmount  + @Delta_Converted, ConvertedAmount = ConvertedAmount  + @Delta_Converted 
				Where TransactionID = @ID
	END	
	---
	IF 	@Delta_Quantity <> 0
	BEGIN
		Set @ID = null
		Select  @ID =  TransactionID From MT9000
			Where  ParentPeriodID = @PeriodID and MaterialTypeID = @MaterialTypeID and  InventoryID = @MaterialID and 
				DebitAccountID = @DebitAccountID and CreditAccountID = @CreditAccountID
			Order by Quantity desc

	IF 	 @ID  is not null 
			Update MT9000 Set Quantity = Quantity + @Delta_Quantity
				Where TransactionID = @ID
	END	

	FETCH NEXT FROM @PeriodID_Cur INTO @MaterialTypeID, @MaterialID, @ConvertedAmount , @Quantity,
					@DebitAccountID, @CreditAccountID 
END
CLOSE @PeriodID_Cur
GO

SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
