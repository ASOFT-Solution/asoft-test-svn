IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0416]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0416]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




---- 	Sinh but toan CLTG thanh toan Cong no phai thu
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

CREATE PROCEDURE [dbo].[AP0416] 	
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



Declare 
	@AV0301_02_Cur AS cursor, 
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
	
------------>> Format số lẻ	
DECLARE	@OriginalDecimal AS TINYINT,
		@ConvertedDecimals AS TINYINT
SET @OriginalDecimal = ISNULL((SELECT TOP 1 OriginalDecimal FROM AV1004 WHERE CurrencyID = @iCurrencyID AND DivisionID = @DivisionID),0)
SET @ConvertedDecimals = ISNULL((SELECT TOP 1 ConvertedDecimals FROM AV1004 WHERE CurrencyID = @iCurrencyID AND DivisionID = @DivisionID),0)
------------<< Format số lẻ	

Set @TempTranMonth =  Case when @TranMonth < 10 then '0' + ltrim(str(@TranMonth))
							else ltrim(str(@TranMonth)) end

Set @AV0301_02_Cur = Cursor Scroll KeySet FOR 
SELECT	'D' AS D_C, VoucherID, BatchID ,TableID, ObjectID, 
		DebitAccountID AS AccountID,  CurrencyIDCN, ExchangeRate, ExchangeRateCN,
		ConvertedAmount - GivedConvertedAmount  AS DiffConvertedAmount
FROM	AV0301
WHERE 	GivedOriginalAmount = OriginalAmountCN AND
		GivedConvertedAmount<> ConvertedAmount AND
		DivisionID = @DivisionID AND
		TranMonth + TranYear*100 <= @TranMonth + @TranYear*100 AND
		CurrencyIDCN = @iCurrencyID AND
		(DebitAccountID = @iAccountID)and
		ObjectID Between @FromObjectID AND @ToObjectID	
UNION ALL
SELECT 'C' AS D_C,  VoucherID, BatchID ,TableID, ObjectID, CreditAccountID AS AccountID, CurrencyIDCN, ExchangeRate, ExchangeRateCN, 
		ConvertedAmount - GivedConvertedAmount  AS DiffConvertedAmount
FROM	AV0302
WHERE 	GivedOriginalAmount = OriginalAmountCN AND
		GivedConvertedAmount<> ConvertedAmount AND
		DivisionID = @DivisionID AND
		TranMonth + TranYear*100 <= @TranMonth + @TranYear*100 AND 
		CurrencyIDCN = @iCurrencyID AND
		(CreditAccountID = @iAccountID)and
		ObjectID Between @FromObjectID AND @ToObjectID	

OPEN	@AV0301_02_Cur
FETCH NEXT FROM @AV0301_02_Cur  INTO 	@D_C, @VoucherID, @BatchID, @TableID,  @ObjectID, @AccountID, @CurrencyIDCN, 
						@ExchangeRate, @ExchangeRateCN, @DiffConvertedAmount

WHILE @@Fetch_Status = 0
   Begin
	if @D_C = 'D' --- Ghi lo
		Begin
			Exec AP0000  @DivisionID, @NewTransactionID OUTPUT, 'AT9000', 'CR',  @TranYear ,'',15, 3, 0, '-'						---1 Insert vao AT9000 mot dong but toan CLTG thanh toan lo: No @LossDiffAcc; Co @AccountID
			Insert AT9000( 	DivisionID, TranMonth, TranYear, EmployeeID,
					TransactionID, VoucherID, BatchID, TableID, ObjectID, DebitAccountID, CreditAccountID, 	
					VoucherDate, VoucherNo, VoucherTypeID, OriginalAmount , ConvertedAmount, 
					CurrencyID, CurrencyIDCN, ExchangeRate, ExchangeRateCN, TransactionTypeID,
					VDescription, BDescription, TDescription, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID) 		
			Values 	(@DivisionID, @TranMonth, @TranYear, @UserID,
					@NewTransactionID , @NewVoucherID , @NewVoucherID , 'AT9000', @ObjectID,  @LossDiffAcc, @AccountID,
					@VoucherDate, @VoucherNo, @VoucherTypeID, 0, ROUND(@DiffConvertedAmount,@ConvertedDecimals), 
					@CurrencyIDCN,@CurrencyIDCN, @ExchangeRate, @ExchangeRateCN, 'T10' ,
					@Description, @Description,  N'Lỗ chênh lệch tỷ giá', getdate(), @UserID,  getdate(), @UserID)

			Exec AP0000  @DivisionID, @NewGiveUpID OUTPUT, 'AT0303', 'G', @TempTranMonth , @TranYear ,18, 3, 0, '-'

			--- 2 Insert vao AT0303 mot dong but toan Giai tru CLTY voi Phieu thu do
			Insert AT0303 (GiveUpID, DivisionID,ObjectID, AccountID,CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID, 
					CreditVoucherID, CreditBatchID, CreditTableID, OriginalAmount, ConvertedAmount, IsExrateDiff,
					CreateDate,CreateUseID, LastModifyDate, LastModifyUserID) 	
			Values (@NewGiveUpID, @DivisionID, @ObjectID, @AccountID, @CurrencyIDCN, @VoucherID, @BatchID, @TableID,
					@NewVoucherID, @NewVoucherID, 'AT9000' , 0, ROUND(@DiffConvertedAmount, @ConvertedDecimals), 1,
					getdate(), @UserID,  getdate(), @UserID)
			

		End
	Else  -- Ghi Lai
		Begin
			Exec AP0000  @DivisionID, @NewTransactionID OUTPUT, 'AT9000', 'CR', @TranYear ,'',15, 3, 0, '-'
			---1 Insert vao AT9000 mot dong but toan CLTG thanh toan lai: No @AccountID; Co @InterestDiffAcc
			Insert AT9000( DivisionID, TranMonth, TranYear, EmployeeID,
					TransactionID, VoucherID, BatchID, TableID, ObjectID, DebitAccountID, CreditAccountID, 	
					VoucherDate, VoucherNo, VoucherTypeID, OriginalAmount, ConvertedAmount, 
					CurrencyID, CurrencyIDCN, ExchangeRate, ExchangeRateCN, TransactionTypeID,
					VDescription, BDescription, TDescription, CreateDate,CreateUserID, LastModifyDate, LastModifyUserID) 	
			Values (@DivisionID, @TranMonth, @TranYear, @UserID,
					@NewTransactionID , @NewVoucherID , @NewVoucherID , 'AT9000', @ObjectID, @AccountID, @InterestDiffAcc,
					@VoucherDate, @VoucherNo, @VoucherTypeID, 0, ROUND(@DiffConvertedAmount,@ConvertedDecimals), 
					@CurrencyIDCN,@CurrencyIDCN, @ExchangeRateCN, @ExchangeRateCN, 'T10' ,
					@Description, @Description, N'Lãi chênh lệch tỷ giá', getdate(), @UserID,  getdate(), @UserID)
					
			Exec AP0000  @DivisionID, @NewGiveUpID OUTPUT, 'AT0303', 'G', @TempTranMonth , @TranYear ,18, 3, 0, '-'

			--- 2 Insert vao AT0303 mot dong but toan Giai tru CLTY voi Hoa don do
			Insert AT0303 (GiveUpID, DivisionID,ObjectID, AccountID,CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID, 
					CreditVoucherID, CreditBatchID, CreditTableID, OriginalAmount, ConvertedAmount, IsExrateDiff,
					CreateDate,CreateUseID, LastModifyDate, LastModifyUserID) 	
			Values (@NewGiveUpID, @DivisionID, @ObjectID, @AccountID, @CurrencyIDCN, @NewVoucherID, @NewVoucherID, 'AT9000' ,
					@VoucherID, @BatchID, @TableID, 0, ROUND(@DiffConvertedAmount,@ConvertedDecimals), 1,
					getdate(), @UserID,  getdate(), @UserID)
			
		End

	
	FETCH NEXT FROM @AV0301_02_Cur  INTO 	@D_C, @VoucherID, @BatchID, @TableID,  @ObjectID, @AccountID, @CurrencyIDCN, 
						@ExchangeRate, @ExchangeRateCN, @DiffConvertedAmount
   End

Close @AV0301_02_Cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

