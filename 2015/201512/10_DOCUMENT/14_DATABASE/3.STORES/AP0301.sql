IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0301]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0301]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



------ Created by Nguyen Van Nhan, Date 25/01/2005
------ Purpose: Giai tru ban tu dong
----- Edit by: Nguyen Quoc Huy, date 26/08/2008
---- Modified on 16/11/2011 by Le Thi Thu Hien : Sua loi tien quy doi ben no nho hon ben co

CREATE PROCEDURE [dbo].[AP0301]	
					@Ana02ID nvarchar(50), 
					@DivisionID nvarchar(50), 
					@AccountID nvarchar(50), 
					@CurrencyID nvarchar(50), 
					@ObjectID nvarchar(50), 			
					@TranYear int, 							
					@GiveupDate AS Datetime,
					@GiveupEmployeeID AS nvarchar(50),
					@UserID AS nvarchar(50),
					@VoucherID nvarchar(50), 
					@BatchID nvarchar(50), 
					@TableID nvarchar(50), 
					@OriginalAmountRemain decimal (28,8),
					@ConvertedAmountRemain decimal (28,8),
					@VoucherDate AS Datetime

 AS			
	

Declare @GiveUpID nvarchar(50),	
		@DueDate Datetime,
		@CrVoucherID AS nvarchar(50),
		@CrBatchID AS nvarchar(50),
		@CrTableID  AS nvarchar(50),
		@CrOriginalAmountRemain AS decimal (28,8),
		@CrConvertedAmountRemain AS decimal (28,8),
		@GiveOriginal AS decimal (28,8)	,
		@GiveConverted AS decimal (28,8) ,
		@DebitVoucherDate Datetime,
		@CreditVoucherDate Datetime

While @OriginalAmountRemain >0 or @ConvertedAmountRemain >0		
BEGIN	
	SET @CrVoucherID =''
	SET @CrBatchID = ''
	SET @CrTableID =''
	SET @GiveOriginal =0
	SET @GiveConverted =0

	SELECT 	top 1 @CrVoucherID = VoucherID, @CrBatchID = BatchID, @CrTableID = TableID, 
			@DebitVoucherDate = @VoucherDate, @CreditVoucherDate = VoucherDate,
			@CrOriginalAmountRemain = RemainOriginal,
			@CrConvertedAmountRemain = RemainConverted
	FROM	AT0333	 
	WHERE	D_C='C' 
			AND ObjectID = @ObjectID 
			---and Ana02ID = @Ana02ID
	ORDER BY VoucherDate
						
	IF ISNULL(@CrVoucherID,'') <>''
	BEGIN 
		IF @CrOriginalAmountRemain<= @OriginalAmountRemain  ----- Tien nguyen te Ben Co nho hon ben No
			BEGIN
		   		IF @CrConvertedAmountRemain <= @ConvertedAmountRemain ----Tien quy doi cua ben Co <= Ben No
		   		BEGIN
		   			SET	@GiveOriginal = 	 @CrOriginalAmountRemain
					SET @GiveConverted =	 @CrConvertedAmountRemain						
					Exec AP0000  @DivisionID, @GiveUpID  OUTPUT, 'AT0303', 'G', @TranYear ,'',18, 3, 0, '-'
					----INSERT vao bang gia tru
					INSERT AT0303 	(GiveUpID,  GiveUpDate, GiveUpEmployeeID, DivisionID,
							 ObjectID, AccountID, CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID,
							CreditVoucherID, CreditBatchID, CreditTableID,
							OriginalAmount ,ConvertedAmount, DebitVoucherDate,CreditVoucherDate,
							CreateDate, CreateUseID, LastModifyDate, LastModifyUserID)

					VALUES (@GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
							@ObjectID, @AccountID, @CurrencyID, @VoucherID, @BatchID, @TableID,
							@CrVoucherID, @CrBatchID, @CrTableID,
							@GiveOriginal , @GiveConverted, @DebitVoucherDate, @CreditVoucherDate,
							getdate(), @UserID, getdate(), @UserID) 					
					----- Xoa but toan ben co trong bang tam
					DELETE AT0333 WHERE VoucherID = @CrVoucherID AND BatchID = @CrBatchID AND ObjectID = @ObjectID AND TableID =@CrTableID AND D_C ='C' ----and Ana02ID =@Ana02ID
		
					UPDATE AT9000 
					SET Status = 1
					WHERE 	DivisionID = @DivisionID AND VoucherID = @CrVoucherID AND	
							BatchID =@CrBatchID AND TableID = @CrTableID AND 
							(Case when TransactionTypeID <>'T99' then ObjectID Else CreditObjectID End)  = @ObjectID AND 
							CreditAccountID =@AccountID AND
							CurrencyIDCN = @CurrencyID AND Status = 0
							
					UPDATE AT9000 
					SET Status = 1
					WHERE 	DivisionID = @DivisionID AND VoucherID =@VoucherID AND	
							BatchID =@BatchID AND TableID = @TableID AND 
							ObjectID   = @ObjectID AND 
							DebitAccountID =@AccountID AND
							CurrencyIDCN = @CurrencyID AND Status = 0
		   		END	
		   		ELSE ---Tien quy doi Ben Co > Ben no
		   			BEGIN
		   				Set	@GiveOriginal = 	 @OriginalAmountRemain
						SET @GiveConverted =	 @ConvertedAmountRemain						
						Exec AP0000  @DivisionID, @GiveUpID  OUTPUT, 'AT0303', 'G', @TranYear ,'',18, 3, 0, '-'
						
						INSERT AT0303 	(GiveUpID,  GiveUpDate, GiveUpEmployeeID, DivisionID,
										ObjectID, AccountID, CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID,
										CreditVoucherID, CreditBatchID, CreditTableID,
										OriginalAmount ,ConvertedAmount, DebitVoucherDate, CreditVoucherDate,
										CreateDate, CreateUseID, LastModifyDate, LastModifyUserID)

						VALUES (	@GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
									@ObjectID, @AccountID, @CurrencyID, @VoucherID, @BatchID, @TableID,
									@CrVoucherID, @CrBatchID, @CrTableID,
									@GiveOriginal , @GiveConverted, @DebitVoucherDate, @CreditVoucherDate,
									getdate(), @UserID, getdate(), @UserID)

						UPDATE  AT0333 
						SET		RemainOriginal = RemainOriginal - @GiveOriginal,
								RemainConverted = RemainConverted - @GiveConverted
						WHERE	VoucherID = @CrVoucherID AND BatchID = @CrBatchID AND ObjectID = @ObjectID AND TableID =@CrTableID AND D_C ='C' ---and Ana02ID = @Ana02ID

						UPDATE	AT9000 
						SET		Status = 1
						Where 	DivisionID = @DivisionID AND VoucherID =@CrVoucherID AND	
								BatchID =@CrBatchID AND TableID = @CrTableID AND 
								(Case when TransactionTypeID <>'T99' then ObjectID Else CreditObjectID End)  = @ObjectID AND 
								CreditAccountID =@AccountID AND
								CurrencyIDCN = @CurrencyID AND Status = 0
							
						UPDATE	AT9000 
						SET		Status = 1
						WHERE 	DivisionID = @DivisionID AND VoucherID =@VoucherID AND	
								BatchID =@BatchID AND TableID = @TableID AND 
								ObjectID   = @ObjectID AND 
								DebitAccountID =@AccountID AND
								CurrencyIDCN = @CurrencyID AND Status = 0
		   			END					

	 		END	-----<<<< Tien nguyen te Ben Co nho hon ben No
			ELSE -------------------------- Tien nguyen te Ben No nho hon ben Co
			BEGIN
				Set	@GiveOriginal = 	 @OriginalAmountRemain
				SET @GiveConverted =	 @ConvertedAmountRemain						
				Exec AP0000  @DivisionID, @GiveUpID  OUTPUT, 'AT0303', 'G', @TranYear ,'',18, 3, 0, '-'
				Insert AT0303 	(GiveUpID,  GiveUpDate, GiveUpEmployeeID, DivisionID,
								ObjectID, AccountID, CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID,
								CreditVoucherID, CreditBatchID, CreditTableID,
								OriginalAmount ,ConvertedAmount, DebitVoucherDate, CreditVoucherDate,
								CreateDate, CreateUseID, LastModifyDate, LastModifyUserID)

				Values (	@GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
							@ObjectID, @AccountID, @CurrencyID, @VoucherID, @BatchID, @TableID,
							@CrVoucherID, @CrBatchID, @CrTableID,
							@GiveOriginal , @GiveConverted, @DebitVoucherDate, @CreditVoucherDate,
							getdate(), @UserID, getdate(), @UserID)

				UPDATE  AT0333 
				SET		RemainOriginal = RemainOriginal - @GiveOriginal,
						RemainConverted = RemainConverted - @GiveConverted
				WHERE	VoucherID = @CrVoucherID AND BatchID =@CrBatchID AND ObjectID = @ObjectID AND TableID =@CrTableID AND D_C ='C' ---and Ana02ID = @Ana02ID

				UPDATE	AT9000 
				SET		Status = 1
				WHERE 	DivisionID = @DivisionID AND VoucherID =@CrVoucherID AND	
						BatchID =@CrBatchID AND TableID = @CrTableID AND 
						(Case when TransactionTypeID <>'T99' then ObjectID Else CreditObjectID End)  = @ObjectID AND 
						CreditAccountID =@AccountID AND
						CurrencyIDCN = @CurrencyID AND Status = 0
						
				UPDATE	AT9000 
				SET		Status = 1
				WHERE 	DivisionID = @DivisionID AND VoucherID = @VoucherID AND	
						BatchID =@BatchID AND TableID = @TableID AND 
						ObjectID   = @ObjectID AND 
						DebitAccountID =@AccountID AND
						CurrencyIDCN = @CurrencyID AND Status = 0
			   END	--------------------------<<< Tien nguyen te Ben No nho hon ben Co	

			---print ' Con lai: '+str(@OriginalAmountRemain)+ '  Giai tru: '+str(@GiveOriginal)

				SET @OriginalAmountRemain = @OriginalAmountRemain - @GiveOriginal
				SET @ConvertedAmountRemain = @ConvertedAmountRemain - @GiveConverted				
		

		END 
		Else
		BEGIN
			
			SET @OriginalAmountRemain = 0
			SET @ConvertedAmountRemain = 0
		END
				
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

