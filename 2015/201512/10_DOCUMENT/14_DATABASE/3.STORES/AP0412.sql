IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0412]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0412]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Tạo bút toán CLTG cuối kỳ tự động
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 31/10/2003 by Nguyễn Văn Nhân
---- Modified on 04/03/2007 by Nguyễn Văn Nhân
---- Modified on 19/09/2008 by Bảo Quỳnh
---- Modified on 02/12/2011 by Nguyễn Bình Minh: Bổ sung điều kiện trong trường hợp lấy luôn bút toán chuyển khoản
---- Modified on 06/12/2011 by Nguyễn Bình Minh: Bổ sung loại kết chuyển lãi lỗ trực tiếp không thông qua tài khoản TG 413
---- Modified on 04/01/2012 by Lê Thị Thu Hiền : Bổ sung format số lẻ
---- Modified on 31/01/2012 by Lê Thị Thu Hiền : Bo sung tieu chi tinh chenh lech ty gia, gom ca nhung but toan doi tien va chuyen khoan ngan hang
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ, tiền hạch toán theo thiết lập đơn vị-chi nhánh

-- <Example>
---- 
CREATE PROCEDURE [dbo].[AP0412]
(
	@DivisionID nvarchar(50), 
	@TranMonth int, 
	@TranYear int,
	@VoucherDate Datetime,	
	@VoucherTypeID nvarchar(50),
	@VoucherNo nvarchar(50),
	@UnequalAccountID nvarchar(50),
	@DebitAccountID nvarchar(50),
	@CreditAccountID nvarchar(50),
	@AccountID nvarchar(50), 
	@IsProfitCost tinyint,
	@GroupID nvarchar(50),				
	@CurrencyID nvarchar(50), 
	@ExchangeRate decimal(28,8),
	@VoucherID as nvarchar(50),
	@UserID as nvarchar(50),
	@BankAccountID  as nvarchar(50),
	@Description as  nvarchar(50),
	@Operator as TINYINT,   --- Toan tu cua ty gia
	@IsDirectProfitCost AS TINYINT = 0 -- Ket chuyen truc tiep
)
AS

--- Thuoc nhom von bang tien
DECLARE @OrOpenAmount     AS DECIMAL(28, 8),
        @CoOpenAmount     AS DECIMAL(28, 8),
        @OrDebitAmount    AS DECIMAL(28, 8),
        @CoDebitAmount    AS DECIMAL(28, 8),
        @OrCreditAmount   AS DECIMAL(28, 8),
        @CoCreditAmount   AS DECIMAL(28, 8),
        @OrCloseAmount    AS DECIMAL(28, 8),
        @CoCloseAmount    AS DECIMAL(28, 8),
        @DifferentAmount  AS DECIMAL(28, 8),
        @TransactionID    AS NVARCHAR(50),
        @BaseCurrencyID	  AS VARCHAR(20)

Set @BaseCurrencyID = (Select top 1 BaseCurrencyID From AT1101 WHERE DivisionID = @DivisionID)
Set @BaseCurrencyID =isnull( @BaseCurrencyID,'VND')       
-------------->> FORMAT số lẻ
DECLARE @OriginalDecimal AS int,
        @ConvertedDecimal AS int  
           
SELECT @OriginalDecimal = ExchangeRateDecimal FROM AT1004 WHERE CurrencyID = @CurrencyID AND DivisionID = @DivisionID	

SELECT @ConvertedDecimal = (SELECT TOP 1 ConvertedDecimals FROM AT1101 WHERE DivisionID = @DivisionID)
SET @ConvertedDecimal = ISNULL(@ConvertedDecimal,0)

-----------------<< FORMAT số lẻ

--------------------  Truong hop la Von bang tien 
IF @GroupID = 'G01'
BEGIN
    IF @BankAccountID = ''
        SELECT @OrOpenAmount = SUM(CASE WHEN DebitAccountID = @AccountID AND TransactionTypeID = 'T00' THEN ISNULL(OriginalAmount, 0) ELSE 0 END),
               @CoOpenAmount = SUM(CASE WHEN DebitAccountID = @AccountID AND TransactionTypeID = 'T00' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END),
               @OrDebitAmount = SUM(CASE WHEN DebitAccountID = @AccountID AND TransactionTypeID <> 'T00' THEN ISNULL(OriginalAmount, 0) ELSE 0 END),
               @CoDebitAmount = SUM(CASE WHEN DebitAccountID = @AccountID AND TransactionTypeID <> 'T00' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END),
               @OrCreditAmount = SUM(CASE WHEN CreditAccountID = @AccountID AND TransactionTypeID <> 'T00' THEN ISNULL(OriginalAmount, 0) ELSE 0 END),
               @CoCreditAmount = SUM(CASE WHEN CreditAccountID = @AccountID AND TransactionTypeID <> 'T00' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END)
        FROM   AT9000
        WHERE  (CurrencyID = @CurrencyID OR CurrencyIDCN = @CurrencyID)
               AND (DebitAccountID = @AccountID OR CreditAccountID = @AccountID)
               AND DivisionID = @DivisionID
               AND (TranMonth + TranYear * 100 <= @TranMonth + @TranYear * 100)
    ELSE
        SELECT @OrOpenAmount = SUM(CASE WHEN DebitBankAccountID = @BankAccountID AND TransactionTypeID = 'T00' THEN ISNULL(OriginalAmount, 0) ELSE 0 END),
               @CoOpenAmount = SUM(CASE WHEN DebitBankAccountID = @BankAccountID AND TransactionTypeID = 'T00' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END),
               @OrDebitAmount = SUM(CASE WHEN DebitBankAccountID = @BankAccountID AND TransactionTypeID <> 'T00' THEN
				CASE WHEN TransactionTypeID NOT IN ('T11', 'T16') THEN OriginalAmount	ELSE 
				CASE WHEN AT9000.CurrencyID =  @BaseCurrencyID THEN ConvertedAmount ELSE OriginalAmount END END
				ELSE 0 END) ,
               @CoDebitAmount = SUM(CASE WHEN DebitBankAccountID = @BankAccountID AND TransactionTypeID <> 'T00' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END),
               @OrCreditAmount = SUM(CASE WHEN CreditBankAccountID = @BankAccountID AND TransactionTypeID <> 'T00' THEN 
               	CASE WHEN TransactionTypeID IN ('T11', 'T16') THEN OriginalAmountCN 
				ELSE OriginalAmount END	ELSE 0 END),
               @CoCreditAmount = SUM(CASE WHEN CreditBankAccountID = @BankAccountID AND TransactionTypeID <> 'T00' THEN ISNULL(ConvertedAmount, 0) ELSE 0 END)
        FROM   AT9000
        WHERE  (CurrencyID = @CurrencyID OR CurrencyIDCN = @CurrencyID)
               AND (DebitBankAccountID = @BankAccountID OR CreditBankAccountID = @BankAccountID)
               AND DivisionID = @DivisionID
               AND (TranMonth + TranYear * 100 <= @TranMonth + @TranYear * 100) 	
        
    SET @OrCloseAmount = ISNULL(@OrOpenAmount, 0) + ISNULL(@OrDebitAmount, 0) - ISNULL(@OrCreditAmount, 0)
    
    SET @CoCloseAmount = ISNULL(@CoOpenAmount, 0) + ISNULL(@CoDebitAmount, 0) - ISNULL(@CoCreditAmount, 0)
    
    IF @Operator = 0
        SET @DifferentAmount = @CoCloseAmount - @OrCloseAmount * ISNULL(@ExchangeRate, 0)
    ELSE
        SET @DifferentAmount = @CoCloseAmount - @OrCloseAmount / ISNULL(@ExchangeRate, 1) 
    --       SET     @DifferentAmount=   @CoCloseAmount - @OrCloseAmount /16000
    --    pRINT @CoCloseAmount
    --   PRINT @OrCloseAmount
    
    IF @IsDirectProfitCost = 0 
    BEGIN
		IF @DifferentAmount > 0 -- dieu chinh giam
		BEGIN
			EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear, '', 15, 3, 0, '-'
	        
			INSERT AT9000 (	DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
							VoucherID, TransactionID,BatchID,
							VoucherDate, VoucherTypeID, VoucherNo,
							CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
							DebitAccountID, CreditAccountID,
							CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, CreditBankAccountID,
							VDescription, BDescription, TDescription
						 )
			VALUES		(	@DivisionID, 'AT9000', @TranMonth, @TranYear, NULL, 'T09',
							@VoucherID, @TransactionID, @VoucherID,
							@VoucherDate,@VoucherTypeID, @VoucherNo,
							@CurrencyID, @ExchangeRate, 0, ROUND(@DifferentAmount, @ConvertedDecimal),
							@UnequalAccountID, @AccountID ,
							GETDATE() , @UserID, GETDATE() , @UserID, @BankAccountID,
							@Description, @Description, @Description 
						)
						
			IF @IsProfitCost <> 0 --- Co xac dinh  --- Xac dinh lo (ghi No 811)
			BEGIN
				EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear, '', 15, 3, 0, '-'
	            
				INSERT AT9000 (	DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
								VoucherID, TransactionID,BatchID,
								VoucherDate, VoucherTypeID, VoucherNo,
								CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
								DebitAccountID, CreditAccountID,
								CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
								VDescription, BDescription, TDescription 
								)
				VALUES		(	@DivisionID, 'AT9000', @TranMonth, @TranYear, NULL, 'T09',
								@VoucherID, @TransactionID, @VoucherID,
								@VoucherDate,@VoucherTypeID, @VoucherNo,				
								@CurrencyID, @ExchangeRate, 0, ROUND(@DifferentAmount, @ConvertedDecimal),
								@DebitAccountID, @UnequalAccountID ,
								getDate() , @UserID, getDate() , @UserID,
								@Description, @Description, @Description
							)
			END
		END
		ELSE
		IF @DifferentAmount < 0
		BEGIN
			-----  Dieu chinh tang
			EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear, '', 15, 3, 0, '-'
	        
			INSERT AT9000 (	DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
							VoucherID, TransactionID,BatchID,
							VoucherDate, VoucherTypeID, VoucherNo,
							CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
							DebitAccountID, CreditAccountID,
							CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, DebitBankAccountID,
							VDescription, BDescription, TDescription 
						) 
			VALUES		(	@DivisionID, 'AT9000', @TranMonth, @TranYear, NULL, 'T09',
							@VoucherID, @TransactionID, @VoucherID,
							@VoucherDate,@VoucherTypeID, @VoucherNo,
							@CurrencyID, @ExchangeRate, 0, ROUND(abs(@DifferentAmount), @ConvertedDecimal),
							@AccountID ,@UnequalAccountID,
							getDate() , @UserID, getDate() , @UserID, @BankAccountID,
							@Description, @Description, @Description
						)
	        
			IF @IsProfitCost <> 0 ------- Ghi vao tk Doanh thu (ghi co 711)
			BEGIN
				EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear, '', 15, 3, 0, '-'
	            
				INSERT AT9000 (	DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
								VoucherID, TransactionID,BatchID,
								VoucherDate, VoucherTypeID, VoucherNo,
								CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
								DebitAccountID, CreditAccountID,
								CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
								VDescription, BDescription, TDescription
							)
				VALUES		(	@DivisionID, 'AT9000', @TranMonth, @TranYear, NULL, 'T09',
								@VoucherID, @TransactionID, @VoucherID,
								@VoucherDate,@VoucherTypeID, @VoucherNo,
								@CurrencyID, @ExchangeRate, 0, ROUND(abs(@DifferentAmount),@ConvertedDecimal),
								@UnequalAccountID, @CreditAccountID ,
								getDate() , @UserID, getDate() , @UserID,
								@Description, @Description, @Description 
							)
			END
		END
    END
    ELSE -- @IsDirectProfitCost <> 0: Điều chỉnh trực tiếp lãi lỗ
    BEGIN
    	IF @DifferentAmount > 0 -- dieu chinh giam
		BEGIN
			EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear, '', 15, 3, 0, '-'
	        
			INSERT AT9000 (	DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
							VoucherID, TransactionID,BatchID,
							VoucherDate, VoucherTypeID, VoucherNo,
							CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
							DebitAccountID, CreditAccountID,
							CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, CreditBankAccountID,
							VDescription, BDescription, TDescription
						 )
			VALUES		(	@DivisionID, 'AT9000', @TranMonth, @TranYear, NULL, 'T09',
							@VoucherID, @TransactionID, @VoucherID,
							@VoucherDate,@VoucherTypeID, @VoucherNo,
							@CurrencyID, @ExchangeRate, 0, ROUND(@DifferentAmount, @ConvertedDecimal),
							@DebitAccountID, @AccountID ,
							GETDATE() , @UserID, GETDATE() , @UserID, @BankAccountID,
							@Description, @Description, @Description 
						)
		END
		ELSE
		IF @DifferentAmount < 0
		BEGIN
			-----  Dieu chinh tang
			EXEC AP0000 @DivisionID, @TransactionID OUTPUT, 'AT9000', 'AT', @TranYear, '', 15, 3, 0, '-'
	        
			INSERT AT9000 (	DivisionID, TableID, TranMonth, TranYear, ObjectID, TransactionTypeID,
							VoucherID, TransactionID,BatchID,
							VoucherDate, VoucherTypeID, VoucherNo,
							CurrencyID, ExchangeRate, OriginalAmount, ConvertedAmount,
							DebitAccountID, CreditAccountID,
							CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, DebitBankAccountID,
							VDescription, BDescription, TDescription 
						) 
			VALUES		(	@DivisionID, 'AT9000', @TranMonth, @TranYear, NULL, 'T09',
							@VoucherID, @TransactionID, @VoucherID,
							@VoucherDate,@VoucherTypeID, @VoucherNo,
							@CurrencyID, @ExchangeRate, 0, ROUND(abs(@DifferentAmount), @ConvertedDecimal),
							@AccountID ,@CreditAccountID,
							getDate() , @UserID, getDate() , @UserID, @BankAccountID,
							@Description, @Description, @Description
						)
		END
    END
END
ELSE
IF @GroupID = 'G04'
    EXEC AP0410 @DivisionID,		@CurrencyID,
				 @AccountID,	
				 @TranMonth,		@TranYear,			@VoucherDate,	@VoucherTypeID,	@VoucherNo,
				 @UnequalAccountID,	@DebitAccountID,	@CreditAccountID,
				 @IsProfitCost,		@GroupID,
				 @ExchangeRate,
				 @VoucherID,		@UserID,			@Description,	@Operator
ELSE
IF @GroupID = 'G03'
    EXEC AP0411	@DivisionID,        @CurrencyID,
				@AccountID,
				@TranMonth,         @TranYear,			@VoucherDate,	@VoucherTypeID,	@VoucherNo,
		        @UnequalAccountID,	@DebitAccountID,	@CreditAccountID,
				@IsProfitCost,		@GroupID,
				@ExchangeRate,
				@VoucherID,			@UserID,			@Description,	@Operator

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

