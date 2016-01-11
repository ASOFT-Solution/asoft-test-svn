/****** Object:  StoredProcedure [dbo].[AP0452]    Script Date: 07/28/2010 17:56:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Van Nhan, Date 26/09/2008
------ Purpose: Giai tru ban tu dong
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [28/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP0452]		@Ana01ID nvarchar(50), 
					@DivisionID nvarchar(50), 
					@AccountID nvarchar(50), 
					@CurrencyID nvarchar(50), 
					@ObjectID nvarchar(50), 			
					@TranYear int, 							
					@GiveupDate as Datetime,
					@GiveupEmployeeID as nvarchar(50),
					@UserID as nvarchar(50),
					@VoucherID nvarchar(50), 
					@BatchID nvarchar(50), 
					@TableID nvarchar(50), 
					@OriginalAmountRemain decimal(28,8),
					@ConvertedAmountRemain decimal(28,8)

 AS			
	

Declare @GiveUpID nvarchar(50),	
	@VoucherDate Datetime,
	@DueDate Datetime,
	@DeVoucherID as nvarchar(50),
	@DeBatchID as nvarchar(50),
	@DeTableID  as nvarchar(50),
	@DeOriginalAmountRemain as decimal(28,8),
	@DeConvertedAmountRemain as decimal(28,8),
	@GiveOriginal as decimal(28,8)	,
	@GiveConverted as decimal(28,8)

While @OriginalAmountRemain >0 or @ConvertedAmountRemain >0		
	Begin
			
				Set @DeVoucherID =''
				Set  @DeBatchID = ''
				Set @DeTableID =''
				Set @GiveOriginal =0
				Set @GiveConverted =0
		
				Select 		top 1 @DeVoucherID = VoucherID, @DeBatchID = BatchID, @DeTableID = TableID, 
						@DeOriginalAmountRemain = RemainOriginal,
						@DeConvertedAmountRemain = RemainConverted
				From AT0333	 Where D_C='D'  and ObjectID =@ObjectID and DivisionID =@DivisionID 
				Order by VoucherDate
								
				If isnull(@DeVoucherID,'') <>''
				  Begin
					---Print 'OK'
					If @DeOriginalAmountRemain<= @OriginalAmountRemain  ----- Ben Co nho hon ben No
					   Begin						
						Set	@GiveOriginal = 	 @DeOriginalAmountRemain
						Set 	@GiveConverted =	 @DeConvertedAmountRemain						
						Exec AP0000 @DivisionID, @GiveUpID  OUTPUT, 'AT0404', 'G', @TranYear ,'',18, 3, 0, '-'
						Insert AT0404 	(GiveUpID,  GiveUpDate, GiveUpEmployeeID, DivisionID,
								 ObjectID, AccountID, CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID,
								CreditVoucherID, CreditBatchID, CreditTableID,
								OriginalAmount ,ConvertedAmount, 
								CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)

						Values ( @GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
								 @ObjectID, @AccountID, @CurrencyID, 
								@DeVoucherID, @DeBatchID, @DeTableID,
								@VoucherID, @BatchID, @TableID,								
								@GiveOriginal , @GiveConverted,
							getdate(), @UserID, getdate(), @UserID) 
	
						Delete AT0333 Where DivisionID = @DivisionID and VoucherID = @DeVoucherID and BatchID =@DeBatchID and ObjectID = @ObjectID and TableID =@DeTableID and D_C ='D' 
			
						Update AT9000 Set Status = 1  --- Cap nhat da giai tru PSNO -- thu tien
						Where 	DivisionID = @DivisionID and VoucherID =@DeVoucherID and	
							BatchID =@DeBatchID and TableID = @DeTableID and 
							ObjectID   = @ObjectID and 
							DebitAccountID =@AccountID and
							CurrencyIDCN = @CurrencyID and Status = 0
						Update AT9000 Set Status = 1   ---- Cap nhat da giai tru PSCo --- Mua hang
						Where 	DivisionID = @DivisionID and VoucherID =@VoucherID and	
							BatchID =@BatchID and TableID = @TableID and 
							(Case when TransactionTypeID ='T99' then CreditObjectID Else ObjectID End)   = @ObjectID and 
							CreditAccountID =@AccountID and
							CurrencyIDCN = @CurrencyID and Status = 0

				 	  End	
					  Else -------------------------- Ben No nho hon ben No
					   Begin
						Set	@GiveOriginal = 	 @OriginalAmountRemain
						Set 	@GiveConverted =	 @ConvertedAmountRemain						
						Exec AP0000 @DivisionID, @GiveUpID  OUTPUT, 'AT0404', 'G', @TranYear ,'',18, 3, 0, '-'
						Insert AT0404 	(GiveUpID,  GiveUpDate, GiveUpEmployeeID, DivisionID,
								 ObjectID, AccountID, CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID,
								CreditVoucherID, CreditBatchID, CreditTableID,
								OriginalAmount ,ConvertedAmount, 
								CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)

						Values ( @GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
								 @ObjectID, @AccountID, @CurrencyID,
								@DeVoucherID, @DeBatchID, @DeTableID,
								 @VoucherID, @BatchID, @TableID,
								@GiveOriginal , @GiveConverted,
								getdate(), @UserID, getdate(), @UserID)

						Update  AT0333 Set	 RemainOriginal = RemainOriginal - @GiveOriginal,
									 RemainConverted = RemainConverted - @GiveConverted
						Where DivisionID = @DivisionID and VoucherID = @DeVoucherID and BatchID =@DeBatchID and ObjectID = @ObjectID and TableID =@DeTableID and D_C ='D' 

						Update AT9000 Set Status = 1
						Where 	DivisionID = @DivisionID and VoucherID =@DeVoucherID and	
							BatchID =@DeBatchID and TableID = @DeTableID and 
							ObjectID  = @ObjectID and 
							DebitAccountID =@AccountID and
							CurrencyIDCN = @CurrencyID and Status = 0
						Update AT9000 Set Status = 1
						Where 	DivisionID = @DivisionID and VoucherID =@VoucherID and	
							BatchID =@BatchID and TableID = @TableID and 
							(Case When TransactionTypeID='T99' then CreditObjectID else  ObjectID End)   = @ObjectID and 
							CreditAccountID =@AccountID and
							CurrencyIDCN = @CurrencyID and Status = 0



					   End		

					---print ' Con lai: '+str(@OriginalAmountRemain)+ '  Giai tru: '+str(@GiveOriginal)

					Set @OriginalAmountRemain	 = @OriginalAmountRemain - 	@GiveOriginal
					set @ConvertedAmountRemain = @ConvertedAmountRemain - @GiveConverted
				

				End 
				Else
				Begin
					
					Set @OriginalAmountRemain =0
					Set @ConvertedAmountRemain =0
				End
				
			End