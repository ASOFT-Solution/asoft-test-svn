/****** Object:  StoredProcedure [dbo].[AP0303]    Script Date: 07/28/2010 16:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----- 	Created by Nguyen Van Nhan, Date 13/11/2003
----- 	Purpose: Xoa but toan giai tru cong no phai thu.
-----	Last Updated by Nguyen Van Nhan, Date 31/07/2004
-----        Edit by: Dang Le Bao Quynh; Date 25/06/2008
-----	Purpose: Xoa but toan chenh lech No tu CreditObjectID -> ObjectID
/********************************************
'* Edited by: [GS] [Tố Oanh] [28/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP0303] @DivisionID nvarchar(50), 
				  @VoucherID nvarchar(50),
				  @BatchID as nvarchar(50),
				  @TableID as  nvarchar(50),
				  @ObjectID nvarchar(50),
				  @CurrencyID nvarchar(50),
				  @AccountID nvarchar(50),
				  @D_C as nvarchar(1)  ---- 'D' neu la o phieu PS NO
							--- 'C' neu la phat sinh co

 AS
Declare @CorVoucherID as nvarchar(50),
	@CorBatchID as nvarchar(50),
	@CorTableID as nvarchar(50),
	@OriginalAmount as decimal (28,8),
	@GivedOriginalAmount as decimal (28,8),
	@Cor_cur as cursor


IF @D_C ='D'   ---- Truong ho o ben No bo giai tru ----------------------------------------------------------------
Begin
	SET @Cor_cur = Cursor Scroll KeySet FOR 
	Select 	CreditVoucherID, CreditBatchID, CreditTableID,  Sum(OriginalAmount)
	From AT0303 Where DebitVoucherID = @VoucherID  and
				DebitBatchID = @BatchID and
				DebitTableID = @TableID and
				AccountID =@AccountID and
				ObjectID = @ObjectID and
				DivisionID =@DivisionID and
				CurrencyID =@CurrencyID

	Group by CreditVoucherID, CreditBatchID, CreditTableID

	OPEN	@Cor_cur
	FETCH NEXT FROM @Cor_cur INTO  @CorVoucherID,  @CorBatchID,  @CorTableID, @OriginalAmount
	WHILE @@Fetch_Status = 0
	Begin	
			Set @GivedOriginalAmount =0
			Set @GivedOriginalAmount  = (Select Sum(isnull(OriginalAmount,0)) 
							From  AT0303 Where 	DivisionID = @DivisionID and
										ObjectID = @ObjectID  and
										CreditVoucherID = @CorVoucherID and
										CreditBatchID = @CorBatchID and
										CreditTableID = @CorTableID and
										AccountID = @AccountID and
										CurrencyID =  @CurrencyID)			
			If @GivedOriginalAmount = @OriginalAmount	
			Update AT9000 Set Status = 0
			Where 	DivisionID = @DivisionID and
				VoucherID = @CorVoucherID and
				BatchID = @CorBatchID and
				TableID = @CorTableID and 
				(Case When TransactionTypeID ='T99' then CreditObjectID else ObjectID end) = @ObjectID and 
				CreditAccountID =@AccountID and
				CurrencyIDCN = @CurrencyID
		
			Delete AT9000 Where (VoucherID = @CorVoucherID or VoucherID = @VoucherID)  and
				(BatchID = @CorBatchID or BatchID = @BatchID) and
				(TableID = @CorTableID or TableID = @TableID) and
				TransactionTypeID = 'T10' and
				ObjectID = @ObjectID and
				DivisionID = @DivisionID and
				CurrencyID = @CurrencyID
		--Print '@CorVoucherID   '+@CorVoucherID

		FETCH NEXT FROM @Cor_cur INTO  @CorVoucherID ,  @CorBatchID ,  @CorTableID, @OriginalAmount
	End

	Close @Cor_cur



	
	Delete AT0303 Where 	DebitVoucherID = @VoucherID  and
				DebitBatchID = @BatchID and
				DebitTableID = @TableID and
				AccountID =@AccountID and
				ObjectID = @ObjectID and
				DivisionID =@DivisionID and
				CurrencyID =@CurrencyID
	--- Cap nhat trang thai
	
	Update AT9000 Set Status = 0
			Where 	DivisionID = @DivisionID and
				VoucherID =@VoucherID and
				TableID = @TableID and 
				ObjectID = @ObjectID and
				BatchID =@BatchID and
				DebitAccountID =@AccountID and
				CurrencyIDCN = @CurrencyID
	

	
	
End
IF  @D_C ='C'   ----------------------------- Truong hop o ben Co bo giai tru cong no -------------------------------------------------------------------------------------------------
Begin

SET @Cor_cur = Cursor Scroll KeySet FOR 
	Select 	DebitVoucherID, DebitBatchID, DebitTableID,  Sum(OriginalAmount)
	From AT0303 Where 	CreditVoucherID = @VoucherID  and
				CreditBatchID = @BatchID and
				CreditTableID = @TableID and
				AccountID =@AccountID and
				ObjectID = @ObjectID and
				DivisionID =@DivisionID and
				CurrencyID =@CurrencyID

	Group by DebitVoucherID, DebitBatchID, DebitTableID  

	OPEN	@Cor_cur
	FETCH NEXT FROM @Cor_cur INTO  @CorVoucherID,  @CorBatchID,  @CorTableID, @OriginalAmount
	WHILE @@Fetch_Status = 0
	Begin	
			Set @GivedOriginalAmount =0
			Set @GivedOriginalAmount  = (Select Sum(isnull(OriginalAmount,0)) 
							From  AT0303 Where 	DivisionID = @DivisionID and
										ObjectID = @ObjectID  and
										DebitVoucherID = @CorVoucherID and
										DebitBatchID = @CorBatchID and
										DebitTableID = @CorTableID and
										AccountID = @AccountID and
										CurrencyID =  @CurrencyID)			
			If @GivedOriginalAmount = @OriginalAmount	
			Update AT9000 Set Status = 0
			Where 	DivisionID = @DivisionID and
				VoucherID = @CorVoucherID and
				BatchID = @CorBatchID and
				TableID = @CorTableID and 
				ObjectID = @ObjectID and 
				DebitAccountID =@AccountID and
				CurrencyIDCN = @CurrencyID

			Delete AT9000 Where (VoucherID = @CorVoucherID or VoucherID = @VoucherID)  and
				(BatchID = @CorBatchID or BatchID = @BatchID) and
				(TableID = @CorTableID or TableID = @TableID) and
				TransactionTypeID = 'T10' and
				ObjectID = @ObjectID and
				DivisionID = @DivisionID and
				CurrencyID = @CurrencyID
		--Print '@CorVoucherID   '+@CorVoucherID

		FETCH NEXT FROM @Cor_cur INTO  @CorVoucherID ,  @CorBatchID ,  @CorTableID, @OriginalAmount
	End

	Close @Cor_cur





	Delete AT0303 Where 	CreditVoucherID = @VoucherID  and
				CreditBatchID = @BatchID and
				CreditTableID = @TableID and
				AccountID =@AccountID and
				ObjectID = @ObjectID and
				DivisionID =@DivisionID and
				CurrencyID =@CurrencyID
	--- Cap nhat trang thai
	Update AT9000 Set Status = 0
			Where 	DivisionID = @DivisionID and
				VoucherID =@VoucherID and
				BatchID =@BatchID and
				TableID = @TableID and 
				(Case When TransactionTypeID ='T99' then CreditObjectID else ObjectID end) = @ObjectID and 
				CreditAccountID =@AccountID and
				CurrencyIDCN = @CurrencyID


End