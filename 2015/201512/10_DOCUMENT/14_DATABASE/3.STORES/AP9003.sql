/****** Object:  StoredProcedure [dbo].[AP9003]    Script Date: 07/29/2010 13:40:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





------ 	Created by Nguyen Van Nhan, Date 05/06/2004
-----	Purpose: Phan bo chi phi
----	Edit by Nguyen Quoc Huy, Date 16/06/2004
-----	Edit by: Dang Le Bao Quynh, Date 19/11/2008
-----	Purpose: Neu tong he so = 0 thi khong phan bo
----	Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh



/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP9003]		@DivisionID NVARCHAR(50),
					@FromMonth INT,
					@FromYear INT,
					@ToMonth INT,
					@ToYear INT,
					@AccountID  NVARCHAR(50),
					@CorAccountID  NVARCHAR(50),
					@GroupID  NVARCHAR(50),
					@VoucherDate DATETIME,
					@VoucherTypeID  NVARCHAR(50),
					@VoucherNo  NVARCHAR(50),
					@EmployeeID  NVARCHAR(50),
					@Description  NVARCHAR(250),
					@CoefficientID  NVARCHAR(50),
					@UserID  NVARCHAR(50),
					@Ana02ID  AS NVARCHAR(50), 
					@Ana03ID  AS NVARCHAR(50)	
					--@VoucherID  nvarchar(20),
					--@BatchID  nvarchar(20),
					---@TransactionID  nvarchar(20)			

AS
DECLARE @TranMonth AS INT,
	@TranYear AS INT,
	@DebitAccountID  NVARCHAR(50),
	@CreditAccountID NVARCHAR(50),
	@ConvertedAmount DECIMAL(28,8),
	@CurrencyID NVARCHAR(50),
	@AT9001_cur AS CURSOR ,
	@Ana_cur AS CURSOR,
	@AnaID AS NVARCHAR(50),
	@TotalValues AS DECIMAL(28,8),
	@CoValues AS MONEY,
	@NewTransactionID AS NVARCHAR(50),
	@NewVoucherID AS NVARCHAR(50),
	@CYear NVARCHAR(20),
	@NewBatchID AS NVARCHAR(50),
	@ConvertedDecimals AS INT,
	@TotalAmount AS DECIMAL(28,8),
	@DeltaAmount AS DECIMAL(28,8),
	@TransactionID AS NVARCHAR(50)

--Neu tong he so = 0 thi thoat
IF (SELECT SUM(ISNULL(CoValues,0)) FROM AT7804 WHERE  CoefficientID =@CoefficientID AND DivisionID = @DivisionID) = 0 RETURN

	---@Ana03ID as  nvarchar(20)
SELECT @CurrencyID =  BaseCurrencyID,  @ConvertedDecimals =ConvertedDecimals  FROM AT1101 WHERE DivisionID = @DivisionID
SET @CurrencyID= ISNULL(@CurrencyID,'VND')
SET @ConvertedDecimals =ISNULL(@ConvertedDecimals,0)
	
------ Part I:  Phan bo phat sinh No
SET @AT9001_cur = CURSOR SCROLL KEYSET FOR 	
	SELECT  	TranMonth ,  TranYear,     AccountID  AS DebitAccountID,            
		CorAccountID AS CreditAccountID,         SUM(ConvertedAmount) AS ConvertedAmount
	
	FROM 	AV9001 
	WHERE 	D_C ='D'   AND --- Phat sinh No
		GroupID = @GroupID AND ISNULL(Ana02ID,'') =ISNULL(@Ana02ID,'') AND  ISNULL(Ana03ID,'') = ISNULL(@Ana03ID,'') AND 
		AccountID = @AccountID AND 
		CorAccountID = @CorAccountID AND
		DivisionID = @DivisionID AND
		TableID <>'AT9001' AND
		(TranMonth + 100*TranYear BETWEEN @FromMonth +100*@FromYear AND  @ToMonth +100*@ToYear)
	GROUP BY TranMonth ,  TranYear,    AccountID , CorAccountID 

	OPEN	@AT9001_cur
	FETCH NEXT FROM @AT9001_cur INTO  @TranMonth, @TranYear, @DebitAccountID, @CreditAccountID, @ConvertedAmount
	WHILE @@Fetch_Status = 0
		BEGIN	
			SET @CYear = LTRIM(RTRIM(STR(@TranYear)))
			EXEC AP0000 @DivisionID, @NewVoucherID  OUTPUT, 'AT9001', 'AV', @CYear ,'',15, 3, 0, '-'
			WHILE EXISTS (SELECT TOP 1 1 FROM AT9001 WHERE VoucherID = @NewVoucherID)
					BEGIN
					EXEC AP0000 @DivisionID, @NewVoucherID  OUTPUT, 'AT9001', 'AV', @CYear ,'',15, 3, 0, '-'								
					END
			SET @TotalValues =0 
			SET @TotalValues = ( SELECT SUM(CoValues) FROM AT7804 WHERE  CoefficientID =@CoefficientID)

			SET @Ana_cur = CURSOR SCROLL KEYSET FOR 
				SELECT AnaID, CoValues FROM AT7804 WHERE CoefficientID =@CoefficientID
				OPEN @Ana_cur
			 	FETCH NEXT FROM @Ana_cur INTO  @AnaID, @CoValues
				WHILE @@Fetch_Status = 0
					Begin
					If  (@CoValues*@ConvertedAmount)/@TotalValues <>0
					   Begin
						Exec AP0000 @DivisionID, @NewTransactionID  OUTPUT, 'AT9001', 'AT', @CYear ,'',15, 3, 0, '-'
						While Exists (Select top 1 1 From AT9001 Where TransactionID = @NewTransactionID)
							Begin
								Exec AP0000 @DivisionID, @NewTransactionID  OUTPUT, 'AT9001', 'AT', @CYear ,'',15, 3, 0, '-'
								
							End
						Insert AT9001 (TransactionID,  DivisionID,    TranMonth, TranYear,   VoucherID,  BatchID, 
								 VoucherTypeID,        VoucherNo,  DebitAccountID,       CreditAccountID,      CurrencyID,
							           	OriginalAmount,        ConvertedAmount ,      Description,    Ana01ID,  Ana02ID, Ana03ID,             ExchangeRate ,
							  	 VoucherDate , CoefficientID, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
						Values	(@NewTransactionID,  @DivisionID,    @TranMonth, @TranYear,   @NewVoucherID,  @NewBatchID,
								 @VoucherTypeID,        @VoucherNo,  @DebitAccountID,       @CreditAccountID,      @CurrencyID,
							           	round( (@CoValues*@ConvertedAmount)/@TotalValues ,  @ConvertedDecimals),      round( (@CoValues*@ConvertedAmount)/@TotalValues ,  @ConvertedDecimals),         @Description,    @AnaID,   
								 @Ana02ID, @Ana03ID,        1 ,
							  	@VoucherDate, @CoefficientID, @UserID, GETDATE(), @UserID, GETDATE())
					End	
					---- Xu ly lam tron
						
					
					
					FETCH NEXT FROM @Ana_cur INTO  @AnaID, @CoValues

					End
				Close @Ana_cur
			---- Xu ly lam tron ---  	
			Set 	@TotalAmount =0
			Set @TotalAmount = (Select sum(ConvertedAmount) From AT9001
								 Where 	DivisionID = @DivisionID and 
									TranMonth =@TranMonth and
									 TranYear =@TranYear and
									CoefficientID = @CoefficientID and
									DebitAccountID = @DebitAccountID and
									CreditAccountID = @CreditAccountID and
									 isnull(Ana02ID,'') =isnull(@Ana02ID,'') and  isnull(Ana03ID,'') = isnull(@Ana03ID,'')  )
						
					Set @DeltaAmount = @ConvertedAmount - @TotalAmount
					If @DeltaAmount<>0 
						Begin
							set @TransactionID =''
							set @TransactionID = (Select top 1  TransactionID From AT9001 
										 Where 	DivisionID = @DivisionID and TranMonth =@TranMonth and TranYear =@TranYear and
										CoefficientID = @CoefficientID and
										DebitAccountID = @DebitAccountID and
										CreditAccountID = @CreditAccountID
										Order by ConvertedAmount  Desc ) 
							if @TransactionID<>''
								Update AT9001 Set 	ConvertedAmount = ConvertedAmount +@DeltaAmount,
											OriginalAmount =OriginalAmount +@DeltaAmount
								Where TransactionID = @TransactionID

						End
		    FETCH NEXT FROM @AT9001_cur INTO  @TranMonth, @TranYear, @DebitAccountID, @CreditAccountID, @ConvertedAmount
		End

	
	Close @AT9001_cur
	
	
----- Part II: 	Phan bo phat sinh Co


SET @AT9001_cur = Cursor Scroll KeySet FOR 	
	Select  	TranMonth ,  TranYear,   CorAccountID as DebitAccountID,            
		  AccountID  as CreditAccountID,         
		Sum(ConvertedAmount) as ConvertedAmount
	From 	AV9001
	Where 	D_C ='C'   and --- Phat sinh No
		GroupID = @GroupID and	
		AccountID = @AccountID and 
		CorAccountID = @CorAccountID and
		DivisionID = @DivisionID and
		TableID <>'AT9001' and 
		(TranMonth + 100*TranYear Between @FromMonth +100*@FromYear and  @ToMonth +100*@ToYear)
	Group by TranMonth ,  TranYear,    AccountID , CorAccountID 

	OPEN	@AT9001_cur
	FETCH NEXT FROM @AT9001_cur INTO  @TranMonth, @TranYear, @DebitAccountID, @CreditAccountID, @ConvertedAmount

	WHILE @@Fetch_Status = 0
		Begin	
		  
			Set @CYear = ltrim(Rtrim(str(@TranYear)))
			Exec AP0000  @DivisionID, @NewVoucherID  OUTPUT, 'AT9001', 'AV', @CYear ,'',15, 3, 0, '-'
			While Exists (Select top 1 1 From AT9001 Where VoucherID = @NewVoucherID)
					Begin
					Exec AP0000 @DivisionID, @NewVoucherID  OUTPUT, 'AT9001', 'AV', @CYear ,'',15, 3, 0, '-'
							
					End
			Set @TotalValues =0 
			Set @TotalValues = ( Select Sum(CoValues) From AT7804 Where  CoefficientID =@CoefficientID)
			
			SET @Ana_cur = Cursor Scroll KeySet FOR 
				Select AnaID, CoValues From AT7804 Where CoefficientID =@CoefficientID
				OPEN @Ana_cur
			 	FETCH NEXT FROM @Ana_cur INTO  @AnaID, @CoValues
				WHILE @@Fetch_Status = 0
					Begin
					  If  (@CoValues*@ConvertedAmount)/@TotalValues <>0
				 	    Begin
						Exec AP0000 @DivisionID, @NewTransactionID  OUTPUT, 'AT9001', 'AT', @CYear ,'',15, 3, 0, '-'
						While Exists (Select top 1 1 From AT9001 Where TransactionID = @NewTransactionID)
							Begin
								Exec AP0000 @DivisionID, @NewTransactionID  OUTPUT, 'AT9001', 'AT', @CYear ,'',15, 3, 0, '-'
								
							End
						Insert AT9001 (TransactionID,  DivisionID,    TranMonth, TranYear,   VoucherID,  BatchID, 
								 VoucherTypeID,        VoucherNo,  DebitAccountID,       CreditAccountID,      CurrencyID,
							           	OriginalAmount,        ConvertedAmount ,      Description,    Ana01ID,              ExchangeRate ,
							  	 VoucherDate , CoefficientID)
						Values	(@NewTransactionID,  @DivisionID,    @TranMonth, @TranYear,   @NewVoucherID,  @NewBatchID,
								 @VoucherTypeID,        @VoucherNo,  @DebitAccountID,       @CreditAccountID,      @CurrencyID,
							           	round( (@CoValues*@ConvertedAmount)/@TotalValues ,  @ConvertedDecimals),   round( (@CoValues*@ConvertedAmount)/@TotalValues ,  @ConvertedDecimals),         @Description,    @AnaID,              1 ,
							  	@VoucherDate, @CoefficientID)
					End
		
					FETCH NEXT FROM @Ana_cur INTO  @AnaID, @CoValues
					End
				Close @Ana_cur
			---- Cap nhat trang thai phieu da duoc cap nhat
			Update AT9000 Set IsAudit = 1 
			Where TranMonth =  @TranMonth and TranYear =@TranYear and DebitAccountID =@DebitAccountID and CreditAccountID = @CreditAccountID  and  Isnull(Ana01ID,'') =''

		    FETCH NEXT FROM @AT9001_cur INTO  @TranMonth, @TranYear, @DebitAccountID, @CreditAccountID, @ConvertedAmount
		End
	
	Close @AT9001_cur