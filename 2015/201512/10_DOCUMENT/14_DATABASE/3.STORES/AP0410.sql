IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0410]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0410]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- Tinh chenh lech ty gia doi voi cong no phai tra.
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 05/02/2004 by Nguyễn Văn Nhân
---- Modified on 04/01/2012 by Lê Thị Thu Hiền : Bổ sung format số lẻ
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh

-- <Example>
---- 


CREATE PROCEDURE [dbo].[AP0410] 	
				@DivisionID NVARCHAR(50), 
				@CurrencyID NVARCHAR(50), 
				@AccountID AS NVARCHAR(50),
				@TranMonth AS INT,
				@TranYear AS INT,
				@VoucherDate DATETIME,	
				@VoucherTypeID NVARCHAR(50),
				@VoucherNo NVARCHAR(50),
				@UnequalAccountID NVARCHAR(50),
				@DebitAccountID NVARCHAR(50),
				@CreditAccountID NVARCHAR(50),
				@IsProfitCost TINYINT, 
				@GroupID NVARCHAR(50),								
				@ExchangeRate DECIMAL(28,8),
				@VoucherID AS NVARCHAR(50),
				@UserID AS NVARCHAR(50),
				@Description AS NVARCHAR(250),
				@Operator AS TINYINT  --- Toan tu


 AS

DECLARE @OrOpenAmount AS DECIMAL(28,8),
		@CoOpenAmount AS DECIMAL(28,8),
		@OrDebitAmount AS DECIMAL(28,8),	
		@CoDebitAmount AS DECIMAL(28,8),
		@OrCreditAmount AS DECIMAL(28,8),
		@CoCreditAmount AS DECIMAL(28,8),
		@OrCloseAmount  AS DECIMAL(28,8),
		@CoCloseAmount  AS DECIMAL(28,8),
		@ObjectID	AS NVARCHAR(50),
		@Tran_cur AS CURSOR,
		@DifferentAmount AS DECIMAL(28,8),
		@TransactionID AS NVARCHAR(50)
		
-------------->> FORMAT số lẻ
DECLARE @OriginalDecimal AS INT,
        @ConvertedDecimal AS INT  
           
SELECT @OriginalDecimal = ExchangeRateDecimal FROM AT1004 WHERE CurrencyID = @CurrencyID AND DivisionID = @DivisionID	

SELECT @ConvertedDecimal = (SELECT TOP 1 ConvertedDecimals FROM AT1101 WHERE DivisionID = @DivisionID)
SET @ConvertedDecimal = ISNULL(@ConvertedDecimal,0)

-----------------<< FORMAT số lẻ	

SET @Tran_cur = CURSOR SCROLL KEYSET FOR 
SELECT	SUM(CASE WHEN TransactionTypeID ='T00'  THEN -ISNULL(OriginalAmount,0) ELSE 0 END),
		SUM(CASE WHEN TransactionTypeID ='T00' THEN -ISNULL(ConvertedAmount,0) ELSE 0 END ),
		SUM(CASE WHEN D_C = 'D' AND  TransactionTypeID <>'T00' THEN ISNULL(OriginalAmount,0) ELSE 0 END ),
		SUM(CASE WHEN D_C = 'D'  AND  TransactionTypeID <>'T00' THEN ISNULL(ConvertedAmount,0) ELSE 0 END  ),
		SUM(CASE WHEN D_C = 'C'  AND  TransactionTypeID <>'T00' THEN -ISNULL(OriginalAmount,0) ELSE 0 END ),
		SUM(CASE WHEN  D_C = 'C' AND  TransactionTypeID <>'T00' THEN -ISNULL(ConvertedAmount,0) ELSE 0 END  ),
		ObjectID
FROM	AV4202
WHERE 	CurrencyIDCN = @CurrencyID AND
		(AccountID = @AccountID) AND
		DivisionID = @DivisionID AND
		(TranMonth+TranYear*100 <= @TranMonth+@TranYear*100) 	
GROUP BY ObjectID

OPEN	@Tran_cur

FETCH NEXT FROM @Tran_cur  INTO  @OrOpenAmount,@CoOpenAmount,@OrDebitAmount,@CoDebitAmount,	@OrCreditAmount,@CoCreditAmount,@ObjectID

WHILE @@Fetch_Status = 0
	Begin
	SET @OrCloseAmount =0 
	SET @CoCloseAmount =0 
	SET @DifferentAmount =0
	SET @OrCloseAmount  = isnull(@OrOpenAmount,0) - isnull(@OrDebitAmount,0) + isnull(@OrCreditAmount,0)
	SET @CoCloseAmount =  isnull(@CoOpenAmount,0) - isnull(@CoDebitAmount,0) + isnull(@CoCreditAmount,0)
	
	--SET @DifferentAmount = @CoCloseAmount- @OrCloseAmount*(CASE WHEN @Operator =0 then isnull(@ExchangeRate,0) else 1/isnull(@ExchangeRate,0) End)   

	IF @Operator =0 
		SET @DifferentAmount = @CoCloseAmount- @OrCloseAmount*ISNULL(@ExchangeRate,0)   
           	ELSE 
		SET @DifferentAmount = @CoCloseAmount- @OrCloseAmount/ISNULL(@ExchangeRate,1)   



	If @DifferentAmount>0 	-- dieu chinh giam cong no phat tra ghi No 331, Co 413
		Begin
			Exec AP0000  @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear ,'',15, 3, 0, '-'
				
			INSERT INTO AT9000 (DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
					VoucherID, TransactionID,BatchID, VoucherDate, VoucherTypeID, VoucherNo,
					CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
					CurrencyIDCN, ExchangeRateCN, OriginalAmountCN,
					DebitAccountID, CreditAccountID,
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
					VDescription, BDescription, TDescription)
			VALUES (@DivisionID, 'AT9000', @TranMonth, @TranYear, @ObjectID, 'T09',
					@VoucherID, @TransactionID, @VoucherID, @VoucherDate, @VoucherTypeID,@VoucherNo,
					@CurrencyID, @ExchangeRate, 0, ROUND(@DifferentAmount, @ConvertedDecimal),
					@CurrencyID, @ExchangeRate, 0,
					@AccountID, @UnequalAccountID,  
					getDate() , @UserID, getDate() , @UserID,
					@Description, @Description,@Description)
		If @IsProfitCost <>0   ------- Ghi vao tk Doanh thu (ghi co 711)
			 Begin

				Exec AP0000  @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear ,'',15, 3, 0, '-'
					
				INSERT AT9000 (DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
						VoucherID, TransactionID,BatchID, VoucherDate,  VoucherTypeID, VoucherNo,
						CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
						CurrencyIDCN, ExchangeRateCN, OriginalAmountCN,
						DebitAccountID, CreditAccountID,
						CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
						VDescription, BDescription, TDescription)
				VALUES (@DivisionID, 'AT9000', @TranMonth, @TranYear, @ObjectID, 'T09',
						@VoucherID, @TransactionID, @VoucherID, @VoucherDate, @VoucherTypeID,@VoucherNo,
						@CurrencyID, @ExchangeRate, 0, ROUND(abs(@DifferentAmount), @ConvertedDecimal),
						@CurrencyID, @ExchangeRate, 0,
						@UnequalAccountID, @CreditAccountID ,
						getDate() , @UserID, getDate() , @UserID,
						@Description, @Description,@Description)
			 End
		End
		Else
		If @DifferentAmount<0
		Begin
			Exec AP0000  @DivisionID, @TransactionID OUTPUT ,  'AT9000',  'AT',  @TranYear ,'',15, 3, 0, '-'
					
			INSERT AT9000 (DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
					VoucherID, TransactionID,BatchID, VoucherDate, VoucherTypeID, VoucherNo,
					CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
					CurrencyIDCN, ExchangeRateCN, OriginalAmountCN,
					DebitAccountID, CreditAccountID,
					CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
					VDescription, BDescription, TDescription)
			VALUES (@DivisionID, 'AT9000', @TranMonth, @TranYear, @ObjectID, 'T09',
					@VoucherID, @TransactionID, @VoucherID, @VoucherDate, @VoucherTypeID,@VoucherNo,
					@CurrencyID, @ExchangeRate, 0, ROUND(abs(@DifferentAmount), @ConvertedDecimal),
					@CurrencyID, @ExchangeRate, 0,
					@UnequalAccountID, @AccountID, 
					getDate() , @UserID, getDate() , @UserID,
					@Description, @Description,@Description)
			If @IsProfitCost <>0   ------- Ghi vao tk chi phi  thu (ghi No 811 )
			 Begin
				Exec AP0000  @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear ,'',15, 3, 0, '-'
					
				INSERT AT9000 (DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
						VoucherID, TransactionID,BatchID, VoucherDate, VoucherTypeID, VoucherNo,
						CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
						CurrencyIDCN, ExchangeRateCN, OriginalAmountCN,
						DebitAccountID, CreditAccountID,
						CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
						VDescription, BDescription, TDescription)
				VALUES (@DivisionID, 'AT9000', @TranMonth, @TranYear, @ObjectID, 'T09',
						@VoucherID, @TransactionID, @VoucherID, @VoucherDate, @VoucherTypeID,@VoucherNo,
						@CurrencyID, @ExchangeRate, 0, ROUND(abs(@DifferentAmount), @ConvertedDecimal),
						@CurrencyID, @ExchangeRate, 0,
						@DebitAccountID, @UnequalAccountID, 
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

