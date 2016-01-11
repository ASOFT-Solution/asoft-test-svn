IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP04041]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP04041]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by Khanh Van

CREATE PROCEDURE [dbo].[AP04041]	 
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
					@ConvertedAmountRemain decimal(28,8),
					@TVoucherID nvarchar(50), 
					@TBatchID nvarchar(50)

 AS			

Declare @GiveUpID nvarchar(50),	
	@VoucherDate Datetime,
	@DeTableID  as nvarchar(50),
	@TransactionTypeID as nvarchar(50),
	@Cor_cur as cursor,
	@DebitVoucherDate Datetime
	
		
Set @DeTableID =''

	Select top 1  @DebitVoucherDate = voucherdate, @DeTableID = TableID from AT9000 where VoucherID =@VoucherID and DivisionID = @DivisionID and BatchID=@BatchID
	IF ISNULL(@TVoucherID,'') <>''	and ISNULL(@TBatchID,'')<>''
	Begin
		SELECT  	@VoucherDate = VoucherDate
		FROM	AT9000	 
		Where VoucherID =@TVoucherID and DivisionID = @DivisionID 
		SET @Cor_cur = Cursor Scroll KeySet FOR 
		SELECT  top 1(select top 1 TransactionTypeID From AT9000 a where a.VoucherID=b.TVoucherID		and a.DivisionID=b.DivisionID)
		FROM AT9000 b
		Where VoucherID = @VoucherID and DivisionID = @DivisionID and BatchID=@BatchID and isnull(b.TvoucherID,'')<>''
		Group by b.TVoucherID, b.DivisionID, TransactionTypeID
		OPEN	@Cor_cur
		FETCH NEXT FROM @Cor_cur INTO   @TransactionTypeID
		WHILE @@Fetch_Status = 0
		Begin
		Exec AP0000 @DivisionID, @GiveUpID  OUTPUT, 'AT0404', 'G', @TranYear ,'',18, 3, 0, '-'
		If @TransactionTypeID in ('T02','T22')
		Begin
		Insert AT0404 	(GiveUpID,  GiveUpDate, GiveUpEmployeeID, DivisionID,
						ObjectID, AccountID, CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID,
						CreditVoucherID, CreditBatchID, CreditTableID,
						OriginalAmount ,ConvertedAmount, CreateDate, CreateUserID, 
						LastModifyDate, LastModifyUserID,DebitVoucherDate, CreditVoucherDate)

		Values ( @GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
				 @ObjectID, @AccountID, @CurrencyID, @TVoucherID, @TBatchID, @TableID,
				@VoucherID, @BatchID, @DeTableID,@OriginalAmountRemain , @ConvertedAmountRemain,
				getdate(), @UserID, getdate(), @UserID,@VoucherDate,@DebitVoucherDate) 
	
	
		Update AT9000 
		Set Status = 1 
		Where 	DivisionID = @DivisionID and VoucherID =@TVoucherID and	
				BatchID =@TBatchID and TableID = @TableID and 
				(Case when TransactionTypeID ='T99' then CreditObjectID Else ObjectID End) = @ObjectID and 
				CurrencyIDCN = @CurrencyID 
		Update AT9000 
		Set Status = 1   
		Where 	DivisionID = @DivisionID and VoucherID =@VoucherID and	
				BatchID =@BatchID and TableID = @DeTableID and 
				(Case when TransactionTypeID ='T99' then CreditObjectID Else ObjectID End)   = @ObjectID and 
							CurrencyIDCN = @CurrencyID 
		End
		Else
		Begin
		Insert AT0404 	(GiveUpID,  GiveUpDate, GiveUpEmployeeID, DivisionID,
						ObjectID, AccountID, CurrencyID, DebitVoucherID, DebitBatchID, DebitTableID,
						CreditVoucherID, CreditBatchID, CreditTableID,
						OriginalAmount ,ConvertedAmount, CreateDate, CreateUserID, 
						LastModifyDate, LastModifyUserID,DebitVoucherDate, CreditVoucherDate)

		Values ( @GiveUpID,  @GiveUpDate, @GiveUpEmployeeID, @DivisionID,
				 @ObjectID, @AccountID, @CurrencyID, @VoucherID, @BatchID, @DeTableID,
				@TVoucherID, @TBatchID, @TableID,@OriginalAmountRemain , @ConvertedAmountRemain,
				getdate(), @UserID, getdate(), @UserID,@DebitVoucherDate,@VoucherDate) 
	
	
		Update AT9000 
		Set Status = 1 
		Where 	DivisionID = @DivisionID and VoucherID =@TVoucherID and	
				BatchID =@TBatchID and TableID = @TableID and 
				ObjectID = @ObjectID and 
				CurrencyIDCN = @CurrencyID 
		Update AT9000 
		Set Status = 1   
		Where 	DivisionID = @DivisionID and VoucherID =@VoucherID and	
				BatchID =@BatchID and TableID = @DeTableID and 
				ObjectID  = @ObjectID and 
				CurrencyIDCN = @CurrencyID 

		End
				FETCH NEXT FROM @Cor_cur INTO  @TransactionTypeID
		End
	Close @Cor_cur
	End	

