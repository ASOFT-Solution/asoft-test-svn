IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0417]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0417]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




---- 	Sinh but toan CLTG thanh toan Cong no phai tra
------ Created by Nguyen Thi Ngoc Minh, Date 14/09/2004
----- Update by : Dang Le Bao Quynh; Date 19/03/2009
----- Purpose: Them dieu kien xu ly cho hoa don giai tru
---- Modified on 21/02/2012 by Lê Thị Thu Hiền : Bổ sung format số lẻ
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [28/07/2010]
				[Hoang Phuoc] [05/11/2010]
					Noi dung: AP0000  @NewVoucherID OUTPUT, 'AT9000', 'CV', @TranYear ,'',15, 3, 0, '-'
						sua thanh AP0000  @Division, @NewVoucherID OUTPUT, 'AT9000', 'CV', @TranYear ,'',15, 3, 0, '-'
'********************************************/

CREATE PROCEDURE [dbo].[AP0417] 	
				@DivisionID AS nvarchar(50), 
				@TranMonth AS int, 
				@TranYear AS int, 
				@UserID AS nvarchar(50),
				@VoucherDate AS datetime,
				@VoucherNo AS nvarchar(50),
				@VoucherTypeID AS nvarchar(50),
				@LossDiffAcc AS nvarchar(50),
				@InterestDiffAcc AS nvarchar(50),
				@Description AS nvarchar(250),
				@NewVoucherID AS nvarchar(50),
				@FromObjectID  AS nvarchar(50),
				@ToObjectID AS  nvarchar(50),
				@iAccountID AS nvarchar(50),
				@iCurrencyID AS  nvarchar(50)

 AS

------------>> Format số lẻ	
DECLARE	@OriginalDecimal AS TINYINT,
		@ConvertedDecimals AS TINYINT
SET @OriginalDecimal = ISNULL((SELECT TOP 1 OriginalDecimal FROM AV1004 WHERE CurrencyID = @iCurrencyID AND DivisionID = @DivisionID),0)
SET @ConvertedDecimals = ISNULL((SELECT TOP 1 ConvertedDecimals FROM AV1004 WHERE CurrencyID = @iCurrencyID AND DivisionID = @DivisionID),0)
------------<< Format số lẻ	

Declare 
	@AV0401_02_Cur AS cursor, 
	@AccountID AS nvarchar(50), 
	@CurrencyIDCN AS nvarchar(50),
	@ExchangeRate AS decimal(28,8),
	@ExchangeRateCN AS decimal(28,8),
	@ObjectID AS nvarchar(50),
	@VoucherID AS nvarchar(50), 
	@BatchID AS nvarchar(50), 
	@D_C AS nvarchar(20),
	@DiffConvertedAmount AS decimal(28,8),
	@TableID AS nvarchar(50),	
	@NewTransactionID nvarchar(50),
	@NewGiveUpID AS nvarchar(50),
	@TempTranMonth AS nvarchar(20)

Set @TempTranMonth =  CASE WHEN @TranMonth < 10 then '0' + ltrim(str(@TranMonth))
							else ltrim(str(@TranMonth)) end

Set @AV0401_02_Cur = Cursor Scroll KeySet FOR 
Select 'D' AS D_C, VoucherID, BatchID ,TableID, ObjectID, DebitAccountID AS AccountID,  CurrencyIDCN, ExchangeRate, ExchangeRateCN, 
		Sum(ConvertedAmount) - Sum(GivedConvertedAmount)  AS DiffConvertedAmount
From	AV0401
Where 	 
		
		DivisionID = @DivisionID and
		TranMonth + TranYear*100 <= @TranMonth + @TranYear*100 and
		CurrencyIDCN = @iCurrencyID and
		(DebitAccountID = @iAccountID)and
		ObjectID Between @FromObjectID and @ToObjectID	
Group by VoucherID, BatchID ,TableID, ObjectID, DebitAccountID,  CurrencyIDCN, ExchangeRate, ExchangeRateCN
Having Sum(GivedOriginalAmount) = Sum(OriginalAmountCN)and Sum(GivedConvertedAmount)<> Sum(ConvertedAmount) 
Union All
Select 'C' AS D_C,  VoucherID, BatchID ,TableID, ObjectID, CreditAccountID AS AccountID, CurrencyIDCN, ExchangeRate, ExchangeRateCN, 
		Sum(ConvertedAmount) - Sum(GivedConvertedAmount)   AS DiffConvertedAmount
From AV0402
Where 	DivisionID = @DivisionID and
		TranMonth + TranYear*100 <= @TranMonth + @TranYear*100 and
		CurrencyIDCN = @iCurrencyID and
		(CreditAccountID = @iAccountID)and
		ObjectID Between @FromObjectID and @ToObjectID	
Group by VoucherID, BatchID ,TableID, ObjectID, CreditAccountID,  CurrencyIDCN, ExchangeRate, ExchangeRateCN
Having Sum(GivedOriginalAmount) = Sum(OriginalAmountCN)and Sum(GivedConvertedAmount)<> Sum(ConvertedAmount) 

OPEN	@AV0401_02_Cur
FETCH NEXT FROM @AV0401_02_Cur  INTO 	@D_C, @VoucherID, @BatchID, @TableID,  @ObjectID, @AccountID, @CurrencyIDCN, 
						@ExchangeRate, @ExchangeRateCN, @DiffConvertedAmount

WHILE @@Fetch_Status = 0
   Begin
	---- Print ' CL ='+@AccountID+' '+@ObjectID+'  '+@D_C+'  '+str(@DiffConvertedAmount)
	if @D_C ='C' --- Ghi lo: Xu ly phat sinh Co
		Begin
			
			Exec AP0000  @DivisionID, @NewTransactionID OUTPUT, 'AT9000', 'CR',  @TranYear ,'',15, 3, 0, '-'						---1 INSERT vao AT9000 mot dong but toan CLTG thanh toan lo: No @LossDiffAcc; Co @AccountID
			INSERT AT9000( 	DivisionID, TranMonth, TranYear, EmployeeID,
					TransactionID, VoucherID, BatchID, TableID, ObjectID, DebitAccountID, CreditAccountID, 	
					VoucherDate, VoucherNo, VoucherTypeID, OriginalAmount, ConvertedAmount, 
					CurrencyID, CurrencyIDCN, ExchangeRate, ExchangeRateCN, TransactionTypeID,
					VDescription, BDescription, TDescription, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, status) 	
	
			Values 	(@DivisionID, @TranMonth, @TranYear, @UserID,
					@NewTransactionID , @NewVoucherID , @NewTransactionID , 'AT9000', @ObjectID, 
					CASE WHEN @DiffConvertedAmount<0 then @LossDiffAcc  else @AccountID End , 
					CASE WHEN @DiffConvertedAmount<0 then @AccountID else @InterestDiffAcc End, 
					@VoucherDate, @VoucherNo, @VoucherTypeID, 0, ROUND(abs(@DiffConvertedAmount), @ConvertedDecimals), 
					@CurrencyIDCN,@CurrencyIDCN, @ExchangeRate, @ExchangeRateCN, 'T10' ,
					@Description, @Description, 
					CASE WHEN @DiffConvertedAmount>0 then N'Lãi chênh lệch tỷ giá' else N'Lỗ chênh lệch tỷ giá ' End, 
					getdate(), @UserID,  getdate(), @UserID, 1)

			Exec AP0000  @DivisionID, @NewGiveUpID OUTPUT, 'AT0404', 'G', @TempTranMonth , @TranYear ,18, 3, 0, '-'

			--- 2 INSERT vao AT0404 mot dong but toan Giai tru CLTG voi Hoa don do
			INSERT AT0404 (GiveUpID, DivisionID,ObjectID, AccountID,CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID, 
					CreditVoucherID, CreditBatchID, CreditTableID, OriginalAmount, ConvertedAmount, IsExrateDiff,
					CreateDate,CreateUserID, LastModifyDate, LastModifyUserID) 	

			Values (@NewGiveUpID, @DivisionID, @ObjectID, @AccountID, @CurrencyIDCN, 
				CASE WHEN @DiffConvertedAmount>0  then @NewVoucherID else @VoucherID End , 
				CASE WHEN @DiffConvertedAmount>0  then @NewTransactionID else @BatchID End , 
				CASE WHEN @DiffConvertedAmount>0  then 'AT9000'  else @TableID end,
				CASE WHEN @DiffConvertedAmount<0  then @NewVoucherID else @VoucherID End , 
				CASE WHEN @DiffConvertedAmount<0  then @NewTransactionID else @BatchID End , 
				CASE WHEN @DiffConvertedAmount<0  then 'AT9000'  else @TableID end,
				0, ROUND(abs(@DiffConvertedAmount), @ConvertedDecimals), 1, 
				getdate(), @UserID,  getdate(), @UserID)
			
			
		End

	Else  -- Ghi Lai: Xu ly phat sinh No
		Begin

			Exec AP0000  @DivisionID, @NewTransactionID OUTPUT, 'AT9000', 'CR', @TranYear ,'',15, 3, 0, '-'
			---1 INSERT vao AT9000 mot dong but toan CLTG thanh toan lai: No @AccountID; Co @InterestDiffAcc

			
			INSERT AT9000( DivisionID, TranMonth, TranYear, EmployeeID,
					TransactionID, VoucherID, BatchID, TableID, ObjectID, DebitAccountID, CreditAccountID, 	
					VoucherDate, VoucherNo, VoucherTypeID, OriginalAmount, ConvertedAmount, 
					CurrencyID, CurrencyIDCN, ExchangeRate, ExchangeRateCN, TransactionTypeID,
					VDescription, BDescription, TDescription, CreateDate,CreateUserID, LastModifyDate, LastModifyUserID,status) 	
			Values (@DivisionID, @TranMonth, @TranYear, @UserID,
					@NewTransactionID , @NewVoucherID , @NewTransactionID , 'AT9000', @ObjectID, 
					CASE WHEN @DiffConvertedAmount>0 then  @LossDiffAcc else  @AccountID end,
					CASE WHEN @DiffConvertedAmount<0 then  @InterestDiffAcc else  @AccountID end,
					@VoucherDate, @VoucherNo, @VoucherTypeID, 0, ROUND(abs(@DiffConvertedAmount), @ConvertedDecimals), 
					@CurrencyIDCN,@CurrencyIDCN, @ExchangeRateCN, @ExchangeRateCN, 'T10' ,
					@Description, @Description, 
					CASE WHEN @DiffConvertedAmount<0  then N'Lãi chênh lệch tỷ giá' else N' Lỗ chênh lệch tỷ giá ' End
					, getdate(), @UserID,  getdate(), @UserID,1)
					
			Exec AP0000  @DivisionID, @NewGiveUpID OUTPUT, 'AT0404', 'G', @TempTranMonth , @TranYear ,18, 3, 0, '-'

			--- 2 INSERT vao AT0404 mot dong but toan Giai tru CLTG voi Phieu chi do
			INSERT AT0404 (GiveUpID, DivisionID,ObjectID, AccountID,CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID, 
					CreditVoucherID, CreditBatchID, CreditTableID, OriginalAmount, ConvertedAmount, IsExrateDiff,
					CreateDate,CreateUserID, LastModifyDate, LastModifyUserID) 	
			Values (@NewGiveUpID, @DivisionID, @ObjectID, @AccountID, @CurrencyIDCN, 
				CASE WHEN @DiffConvertedAmount>0 then @VoucherID else @NewVoucherID End, 
				CASE WHEN @DiffConvertedAmount>0 then @BatchID else @NewTransactionID End, 
				CASE WHEN @DiffConvertedAmount>0 then @TableID else 'AT9000' End ,
	
				CASE WHEN @DiffConvertedAmount<0 then @VoucherID else @NewVoucherID End, 
				CASE WHEN @DiffConvertedAmount<0 then @BatchID else @NewTransactionID End, 
				CASE WHEN @DiffConvertedAmount<0 then @TableID else 'AT9000' End ,

				0, ROUND(abs(@DiffConvertedAmount), @ConvertedDecimals), 1,
				getdate(), @UserID,  getdate(), @UserID)
			
			
		End

	FETCH NEXT FROM @AV0401_02_Cur  INTO 	@D_C, @VoucherID, @BatchID, @TableID,  @ObjectID, @AccountID, @CurrencyIDCN, 
							@ExchangeRate, @ExchangeRateCN, @DiffConvertedAmount
   End

Close @AV0401_02_Cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

