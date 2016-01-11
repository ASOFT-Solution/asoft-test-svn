
/****** Object:  StoredProcedure [dbo].[AP1111]    Script Date: 07/29/2010 17:23:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Le Quoc Hoai and Nguyen Van Nhan.
----- Created Date 07/05/04
---- Purpose: Kiem tra cho phep Xoa mot phieu thu - chi - doi tien hay hay khong.
---- Edit by: Nguyen Quoc Huy, Date 11/01/2007
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần tiền hạch toán theo thiết lập đơn vị-chi nhánh


ALTER PROCEDURE [dbo].[AP1111] @DivisionID nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@AccountID as nvarchar(50),
				@CurrencyID as nvarchar(50),
				@OldCreditOriginalAmount as decimal(28, 8),
				@CreditOriginalAmount as decimal(28, 8)
AS

Declare @Status as tinyint,
	@SumDebitOriginalAmount as decimal(28, 8),
	@SumCreditOriginalAmount as decimal(28, 8),
	@StartOriginalAmount as decimal(28, 8),
	@StartConvertedAmount as decimal(28, 8),
	@BegOriginalAmount as decimal(28, 8),
	@BegConvertedAmount as decimal(28, 8),
	@DetalOriginalAmount as decimal(28, 8),
	@DetalConvertedAmount as decimal(28, 8),
	@EndOrginalAmount as decimal(28, 8),
	@EndConvertedAmount as decimal(28, 8),
	@StartMonth as int,
	@StartYear as int,
	@BaseCurrencyID as nvarchar(50)

Set Nocount on 
Set @Status =0 

Set @BaseCurrencyID = (Select top 1 BaseCurrencyID From AT1101 WHERE DivisionID = @DivisionID)
Set @BaseCurrencyID =isnull( @BaseCurrencyID,'VND')

--print '@BaseCurrencyID :'  + @BaseCurrencyID 
----- Buoc 1, So du dau ky------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Set  	@StartMonth = (Select top 1 TranMonth From AT9999 Where DivisionID =@DivisionID Order by (TranMonth+TranYear*100))
Set  	@StartYear = (Select top 1 TranYear From AT9999 Where DivisionID =@DivisionID Order by (TranMonth+TranYear*100))

	Select  	@StartOriginalAmount = Sum( Case when DebitAccountID = @AccountID then  OriginalAmount else - OriginalAmount End ),
		@StartConvertedAmount = Sum(Case when   DebitAccountID = @AccountID  then ConvertedAmount else - ConvertedAmount End)
	From AT9000 
	Where 	TranMonth = @StartMonth and
		TranYear = @StartYear and
		DivisionID = @DivisionID and
		( DebitAccountID = @AccountID Or CreditAccountID = @AccountID ) and
		CurrencyID =@CurrencyID and
		TransactionTypeID ='T00' --- So du dau 

If @TranMonth+ @TranYear*100 = @StartMonth + @StartYear*100
	Begin
		Set @BegOriginalAmount = isnull(@StartOriginalAmount,0)
		Set @BegConvertedAmount = isnull(@StartConvertedAmount,0)
	End
Else
	Begin
		--- Xac dinh so phat sinh truoc giai doan (FromMonth , FromYear)
		Set  @DetalOriginalAmount = 	isnull((Select Sum(Case when  TransactionTypeID ='T11' and CurrencyID =@BaseCurrencyID then  ConvertedAmount
							Else  OriginalAmount End )  From AT9000 Where 	DivisionID =@DivisionID and
												DebitAccountID =@AccountID and
												CurrencyID = @CurrencyID and
												TransactionTypeID <>'T00' and
												TranMonth + TranYear*100< (@TranMonth+ @TranYear*100)),0)					
						- isnull((Select Sum(Case when  TransactionTypeID ='T11' and CurrencyIDCN =@BaseCurrencyID then  ConvertedAmount
							Else  OriginalAmount End)  From AT9000 Where 	DivisionID =@DivisionID and
													CreditAccountID =@AccountID and
													(Case When TransactionTypeID ='T11' then CurrencyIDCN Else CurrencyID End) = @CurrencyID and
													TransactionTypeID <>'T00' and
													TranMonth + TranYear*100< @TranMonth+ @TranYear*100),0)
		Set  @DetalConvertedAmount = 	isnull((Select Sum(ConvertedAmount)  From AT9000 Where 	DivisionID =@DivisionID and
												DebitAccountID =@AccountID and
												CurrencyID = @CurrencyID and
												TransactionTypeID <>'T00' and
												TranMonth + TranYear*100< (@TranMonth+ @TranYear*100)),0)					
						- isnull(( Select Sum(ConvertedAmount)  From AT9000 Where 	DivisionID =@DivisionID and
													CreditAccountID =@AccountID and
													(Case When TransactionTypeID ='T11' then CurrencyIDCN Else CurrencyID End) = @CurrencyID and
													TransactionTypeID <>'T00' and
													TranMonth + TranYear*100< @TranMonth+ @TranYear*100),0)
		Set @BegOriginalAmount = isnull(@StartOriginalAmount,0) + isnull(@DetalOriginalAmount,0)
		Set @BegConvertedAmount = isnull(@StartConvertedAmount,0) + isnull(@DetalConvertedAmount,0)		
	End
----------------------------------------------------------------------------

Set @SumDebitOriginalAmount = @BegOriginalAmount + 
		--isnull((Select sum(OriginalAmount) From AT9000 	Where DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear and DebitAccountID = @AccountID) ,0)

		isnull((Select Sum(Case when  TransactionTypeID ='T11' and CurrencyID =@BaseCurrencyID then  ConvertedAmount
							Else  OriginalAmount End )  From AT9000 Where 	DivisionID =@DivisionID and
												DebitAccountID =@AccountID and
												CurrencyID = @CurrencyID and
												TransactionTypeID <>'T00' and
												TranMonth = @TranMonth and
												TranYear    = @TranYear),0)					


--Set @SumCreditOriginalAmount = isnull((Select sum(OriginalAmount) From AT9000 	Where DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear and CreditAccountID = @AccountID) ,0)

Set @SumCreditOriginalAmount = isnull((Select Sum(Case when  TransactionTypeID ='T11' and CurrencyID =@BaseCurrencyID then  ConvertedAmount
							Else  OriginalAmount End )  From AT9000 Where 	DivisionID =@DivisionID and
												CreditAccountID =@AccountID and
												CurrencyID = @CurrencyID and
												TransactionTypeID <>'T00' and
												TranMonth = @TranMonth and
												TranYear    = @TranYear),0)					

	if isnull(@SumDebitOriginalAmount,0) + isnull(@OldCreditOriginalAmount,0) - isnull(@SumCreditOriginalAmount,0) - isnull(@CreditOriginalAmount,0) < 0  
		Begin
			Set @Status =1
			GOTO ENDMESS
		End
	
ENDMESS:

Select @Status as Status
Set Nocount Off
GO
