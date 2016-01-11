
/****** Object:  StoredProcedure [dbo].[AP0427]    Script Date: 07/28/2010 16:31:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- 	Sinh but toan CLTG thanh toan Cong no phai tra. Truong hop khong giai tru cong no
------ Created by Nguyen Van Nhan, Date 28/12/2007
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [28/07/2010]
					[Hoang Phuoc] [05/11/2010]
				Noi dung: AP0000  @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear ,'',15, 3, 0, '-'
						sua thanh AP0000  @Division, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear ,'',15, 3, 0, '-'
'********************************************/

ALTER PROCEDURE [dbo].[AP0427] 	@DivisionID nvarchar(50), 
				@TranMonth as int, 
				@TranYear as int, 
				@UserID as nvarchar(50),
				@VoucherDate as datetime,
				@VoucherNo as nvarchar(50),
				@VoucherTypeID as nvarchar(50),
				@LossDiffAcc as nvarchar(50),
				@InterestDiffAcc as nvarchar(50),
				@Description as nvarchar(250),
				@NewVoucherID as nvarchar(50),
				@FromObjectID  as nvarchar(50),
				@ToObjectID as  nvarchar(50),
				@AccountID as nvarchar(50),
				@CurrencyID as  nvarchar(50)

 AS



Declare @OrOpenAmount as decimal(28,8),
	@CoOpenAmount as decimal(28,8),
	@OrDebitAmount as decimal(28,8),	
	@CoDebitAmount as decimal(28,8),
	@OrCreditAmount as decimal(28,8),
	@CoCreditAmount as decimal(28,8),
	@OrCloseAmount  as decimal(28,8),
	@CoCloseAmount  as decimal(28,8),
	@ObjectID	as nvarchar(50),
	@Tran_cur as cursor,
	@DifferentAmount as decimal(28,8),
	@TransactionID as nvarchar(50),
	@VoucherID  nvarchar(50)


SET @Tran_cur = Cursor Scroll KeySet FOR 
Select		sum( Case when TransactionTypeID ='T00'  then -isnull(OriginalAmount,0) else 0 end),
		Sum(Case when TransactionTypeID ='T00' then -isnull(ConvertedAmount,0) else 0 end ),
		sum(Case when D_C = 'D' and  TransactionTypeID <>'T00' then isnull(OriginalAmount,0) else 0 end ),
		Sum(Case when D_C = 'D'  and  TransactionTypeID <>'T00' then isnull(ConvertedAmount,0) else 0 end  ),
		Sum(Case when D_C = 'C'  and  TransactionTypeID <>'T00' then -isnull(OriginalAmount,0) else 0 end ),
		Sum(Case when  D_C = 'C' and  TransactionTypeID <>'T00' then -isnull(ConvertedAmount,0) else 0 end  ),
		ObjectID
	From AV4202
	Where 	CurrencyIDCN = @CurrencyID and
		(AccountID = @AccountID)and
		DivisionID = @DivisionID and
		(TranMonth+TranYear*100 <= @TranMonth+@TranYear*100)  and
		ObjectID Between @FromObjectID and @ToObjectID	
	Group by ObjectID

OPEN	@Tran_cur

FETCH NEXT FROM @Tran_cur  INTO  @OrOpenAmount,@CoOpenAmount,@OrDebitAmount,@CoDebitAmount,	@OrCreditAmount,@CoCreditAmount,@ObjectID

WHILE @@Fetch_Status = 0
	Begin
	Set @OrCloseAmount =0 
	Set @CoCloseAmount =0 
	Set @DifferentAmount =0
	Set @OrCloseAmount  = isnull(@OrOpenAmount,0) - isnull(@OrDebitAmount,0) + isnull(@OrCreditAmount,0)
	Set @CoCloseAmount =  isnull(@CoOpenAmount,0) - isnull(@CoDebitAmount,0) + isnull(@CoCreditAmount,0)
	
	If @OrCloseAmount=0 and @CoCloseAmount<>0 
	 Begin 
		Set @DifferentAmount = @CoCloseAmount
		If @DifferentAmount>0  -- Truong hop du co,  Vi vay phai ghi No 33X va ghi co 515, doanh thu
		Begin
			Exec AP0000  @DivisionID,@TransactionID OUTPUT, 'AT9000', 'AT', @TranYear ,'',15, 3, 0, '-'
				
			Insert AT9000 (DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
					VoucherID, TransactionID,BatchID, VoucherDate, VoucherTypeID, VoucherNo,
					CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
					CurrencyIDCN, ExchangeRateCN, OriginalAmountCN,
					DebitAccountID, CreditAccountID,
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
					VDescription, BDescription, TDescription)
			Values (@DivisionID, 'AT9000', @TranMonth, @TranYear, @ObjectID, 'T10',
					@NewVoucherID, @TransactionID, @NewVoucherID, @VoucherDate, @VoucherTypeID,@VoucherNo,
					@CurrencyID, 1, 0, @DifferentAmount,
					@CurrencyID, 1, 0,
					@AccountID, @InterestDiffAcc,  
					getDate() , @UserID, getDate() , @UserID,
					@Description, @Description,@Description)
		End
		Else
		If @DifferentAmount<0
		Begin
			Exec AP0000  @DivisionID, @TransactionID OUTPUT ,  'AT9000',  'AT',  @TranYear ,'',15, 3, 0, '-'
					
			Insert AT9000 (DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
					VoucherID, TransactionID,BatchID, VoucherDate, VoucherTypeID, VoucherNo,
					CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
					CurrencyIDCN, ExchangeRateCN, OriginalAmountCN,
					DebitAccountID, CreditAccountID,
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
					VDescription, BDescription, TDescription)
			Values (@DivisionID, 'AT9000', @TranMonth, @TranYear, @ObjectID, 'T10',
					@NewVoucherID, @TransactionID, @NewVoucherID, @VoucherDate, @VoucherTypeID,@VoucherNo,
					@CurrencyID, 1, 0, abs(@DifferentAmount),
					@CurrencyID, 1, 0,
					@LossDiffAcc, @AccountID, 
					getDate() , @UserID, getDate() , @UserID,
					@Description, @Description,@Description)
			

			
		End
		End
		
		FETCH NEXT FROM @Tran_cur  INTO  @OrOpenAmount,@CoOpenAmount,@OrDebitAmount,@CoDebitAmount,	@OrCreditAmount,@CoCreditAmount,@ObjectID
	End



Close @Tran_cur