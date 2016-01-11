IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0411]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0411]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Tinh chenh lech ty gia doi voi cong no phai thu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 04/02/2004 by Nguyễn Văn Nhân
---- Modified on 04/01/2012 by Lê Thị Thu Hiền : Bổ sung format số lẻ
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh

-- <Example>
---- 


CREATE PROCEDURE [dbo].[AP0411] 	
				@DivisionID nvarchar(50), 
				@CurrencyID nvarchar(50), 
				@AccountID AS nvarchar(50),
				@TranMonth AS int,
				@TranYear AS int,
				@VoucherDate Datetime,	
				@VoucherTypeID nvarchar(50),
				@VoucherNo nvarchar(50),
				@UnequalAccountID nvarchar(50),
				@DebitAccountID nvarchar(50),
				@CreditAccountID nvarchar(50),
				@IsProfitCost tinyint, 
				@GroupID nvarchar(50),								
				@ExchangeRate decimal(28,8),
				@VoucherID AS nvarchar(50),
				@UserID AS nvarchar(50),
				@Description AS nvarchar(250),
				@Operator AS tinyint


 AS

DECLARE @OrOpenAmount AS decimal(28,8),
		@CoOpenAmount AS decimal(28,8),
		@OrDebitAmount AS decimal(28,8),	
		@CoDebitAmount AS decimal(28,8),
		@OrCreditAmount AS decimal(28,8),
		@CoCreditAmount AS decimal(28,8),
		@OrCloseAmount  AS decimal(28,8),
		@CoCloseAmount  AS decimal(28,8),
		@ObjectID	as nvarchar(50),
		@Tran_cur AS cursor,
		@DifferentAmount AS decimal(28,8),
		@TransactionID AS nvarchar(50)

-------------->> FORMAT số lẻ
DECLARE @OriginalDecimal AS int,
        @ConvertedDecimal AS int  
           
SELECT @OriginalDecimal = ExchangeRateDecimal FROM AT1004 WHERE CurrencyID = @CurrencyID AND DivisionID = @DivisionID	

SELECT @ConvertedDecimal = (SELECT TOP 1 ConvertedDecimals FROM AT1101 WHERE DivisionID = @DivisionID)
SET @ConvertedDecimal = ISNULL(@ConvertedDecimal,0)

-----------------<< FORMAT số lẻ	

SET @Tran_cur = Cursor Scroll KeySET FOR 
SELECT	sum(Case when TransactionTypeID ='T00'  then isnull(OriginalAmount,0) else 0 end),
		Sum(Case when TransactionTypeID ='T00' then isnull(ConvertedAmount,0) else 0 end ),
		sum(Case when D_C = 'D' and  TransactionTypeID <>'T00' then isnull(OriginalAmount,0) else 0 end ),
		Sum(Case when D_C = 'D'  and  TransactionTypeID <>'T00' then isnull(ConvertedAmount,0) else 0 end  ),
		Sum(Case when D_C = 'C'  and  TransactionTypeID <>'T00' then -isnull(OriginalAmount,0) else 0 end ),
		Sum(Case when  D_C = 'C' and  TransactionTypeID <>'T00' then -isnull(ConvertedAmount,0) else 0 end  ),
		ObjectID
FROM	AV4202
WHERE 	CurrencyIDCN = @CurrencyID and
		(AccountID = @AccountID)and
		DivisionID = @DivisionID and
		(TranMonth+TranYear*100 <= @TranMonth+@TranYear*100) 	
GROUP BY ObjectID

OPEN	@Tran_cur
FETCH NEXT FROM @Tran_cur  INTO  @OrOpenAmount,@CoOpenAmount,@OrDebitAmount,@CoDebitAmount,	@OrCreditAmount,@CoCreditAmount,@ObjectID
WHILE @@Fetch_Status = 0
	Begin
	SET @OrCloseAmount =0 
	SET @CoCloseAmount =0 
	SET @DifferentAmount =0
	SET @OrCloseAmount  = isnull(@OrOpenAmount,0) + isnull(@OrDebitAmount,0) - isnull(@OrCreditAmount,0)
	SET @CoCloseAmount =  isnull(@CoOpenAmount,0) + isnull(@CoDebitAmount,0) - isnull(@CoCreditAmount,0)

	IF @Operator =0 
		SET @DifferentAmount = @CoCloseAmount- @OrCloseAmount*ISNULL(@ExchangeRate,0)   
    ELSE 
		SET @DifferentAmount = @CoCloseAmount- @OrCloseAmount/ISNULL(@ExchangeRate,1)   

	If @DifferentAmount >0 -- dieu chinh giam
		BEGIN
			Exec AP0000  @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear ,'',15, 3, 0, '-'
					
			INSERT AT9000 (DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
					VoucherID, TransactionID,BatchID, 
					VoucherDate, VoucherTypeID, VoucherNo,
					CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
					CurrencyIDCN, ExchangeRateCN, OriginalAmountCN,
					DebitAccountID, CreditAccountID,
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
					VDescription, BDescription, TDescription )
			VALUES (@DivisionID, 'AT9000', @TranMonth, @TranYear, @ObjectID, 'T09',
					@VoucherID, @TransactionID, @VoucherID, 
					@VoucherDate,@VoucherTypeID, @VoucherNo,
					@CurrencyID, @ExchangeRate, 0, ROUND (@DifferentAmount, @ConvertedDecimal),
					@CurrencyID, @ExchangeRate, 0,
					@UnequalAccountID, @AccountID ,
					getDate() , @UserID, getDate() , @UserID,
					@Description, @Description,@Description)
			If @IsProfitCost <>0 --- Co xac dinh  --- Xac dinh lo (ghi No 811)
				Begin
					Exec AP0000  @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear ,'',15, 3, 0, '-'
					
					INSERT AT9000 (DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
							VoucherID, TransactionID,BatchID,  
							VoucherDate, VoucherTypeID, VoucherNo,
							CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
							DebitAccountID, CreditAccountID,
							CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
							VDescription, BDescription, TDescription )
					VALUES (@DivisionID, 'AT9000', @TranMonth, @TranYear, @ObjectID, 'T09',
							@VoucherID, @TransactionID, @VoucherID,  
							@VoucherDate,@VoucherTypeID, @VoucherNo,				
							@CurrencyID, @ExchangeRate, 0, ROUND (@DifferentAmount, @ConvertedDecimal),
							@DebitAccountID, @UnequalAccountID ,
							getDate() , @UserID, getDate() , @UserID,
							@Description, @Description,@Description)	
			End
			
		End
		Else
		If @DifferentAmount<0
		Begin   -----  Dieu chinh tang
			Exec AP0000  @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear ,'',15, 3, 0, '-'
					
			Insert AT9000 (DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
					VoucherID, TransactionID,BatchID,
					VoucherDate, VoucherTypeID, VoucherNo,
					CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
					CurrencyIDCN, ExchangeRateCN, OriginalAmountCN,
					DebitAccountID, CreditAccountID,
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
					VDescription, BDescription, TDescription )
			Values (@DivisionID, 'AT9000', @TranMonth, @TranYear, @ObjectID, 'T09',
					@VoucherID, @TransactionID, @VoucherID,
					@VoucherDate,@VoucherTypeID, @VoucherNo,
					@CurrencyID, @ExchangeRate, 0, ROUND (abs(@DifferentAmount), @ConvertedDecimal),
					@CurrencyID, @ExchangeRate, 0,
					 @AccountID ,@UnequalAccountID,
					getDate() , @UserID, getDate() , @UserID,
					@Description, @Description,@Description)
			If @IsProfitCost <>0   ------- Ghi vao tk Doanh thu (ghi co 711)
			 Begin
				Exec AP0000  @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear ,'',15, 3, 0, '-'
					
				Insert AT9000 (DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
					VoucherID, TransactionID,BatchID,
					VoucherDate, VoucherTypeID, VoucherNo,
					CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
					CurrencyIDCN, ExchangeRateCN, OriginalAmountCN,
					DebitAccountID, CreditAccountID,
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
					VDescription, BDescription, TDescription )
				Values (@DivisionID, 'AT9000', @TranMonth, @TranYear, @ObjectID, 'T09',
					@VoucherID, @TransactionID, @VoucherID,
					@VoucherDate,@VoucherTypeID, @VoucherNo,
					@CurrencyID, @ExchangeRate, 0, ROUND (abs(@DifferentAmount), @ConvertedDecimal),
					@CurrencyID, @ExchangeRate, 0,
					@UnequalAccountID, @CreditAccountID ,
					getDate() , @UserID, getDate() , @UserID,
					@Description, @Description,@Description)
			 End
			
		End

		FETCH NEXT FROM @Tran_cur  INTO  @OrOpenAmount,@CoOpenAmount,@OrDebitAmount,@CoDebitAmount,	@OrCreditAmount,@CoCreditAmount,@ObjectID
	End



Close @Tran_cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

