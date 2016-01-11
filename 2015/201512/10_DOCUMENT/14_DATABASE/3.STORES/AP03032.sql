IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP03032]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP03032]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
----- 	Created by Khanh Van, Date 20/06/2013
----- 	Purpose: Xoa but toan giai tru cong no phai thu, phai tra

CREATE PROCEDURE [dbo].[AP03032] @DivisionID nvarchar(50), 
				  @VoucherID nvarchar(50),
				  @Mode as int --0: Cong no phai thu, 1: Cong no phai tra


AS
Declare 
	@AccountID as nvarchar(50),
	@CorBatchID as nvarchar(50),
	@CorObjectID as nvarchar(50),
	@CorTableID as nvarchar(50),
	@CorCurrencyID as nvarchar(50),
	@CorAccountID as nvarchar (50),
	@TransactionTypeID as nvarchar(50),
	@Cor_cur as cursor,
	@Cor_cur1 as cursor

If @Mode = 0 -- Bo giai tru cong no phai thu
Begin
	Select @AccountID = CreditAccountID 
	From AT9000 
	Where DivisionID = @DivisionID and VoucherID = @VoucherID
	--IF @AccountID in (Select AccountID From AT1005 Where GroupID ='G03' and  IsObject =1 and DivisionID = @DivisionID)
	--SELECT @TransactionTypeID = (select top 1 TransactionTypeID From AT9000 a where a.VoucherID=b.TVoucherID and a.DivisionID=b.DivisionID)
	--	FROM AT9000 b
	--	Where VoucherID = @VoucherID and DivisionID = @DivisionID
	--If @TransactionTypeID in ('T01','T21')
	Begin	
		SET @Cor_cur = Cursor Scroll KeySet FOR 
		Select 	BatchID, ObjectID , TableID, CurrencyID, (Case When TransactionTypeID ='T99' then DebitAccountID else CreditAccountID end)
		From AT9000
		Where DivisionID = @DivisionID and VoucherID = @VoucherID
	
		OPEN	@Cor_cur
		FETCH NEXT FROM @Cor_cur INTO   @CorBatchID, @CorObjectID,  @CorTableID, @CorCurrencyID, @CorAccountID
		WHILE @@Fetch_Status = 0
		Begin
			Exec AP0303 @DivisionID, @VoucherID, @CorBatchID, @CorTableID, @CorObjectID, @CorCurrencyID, @CorAccountID,'D'
		FETCH NEXT FROM @Cor_cur INTO  @CorBatchID, @CorObjectID,  @CorTableID, @CorCurrencyID, @CorAccountID
		End
	Close @Cor_cur
	End
	--Else
		Begin	
		SET @Cor_cur1 = Cursor Scroll KeySet FOR 
		Select 	BatchID, (Case When TransactionTypeID ='T99' then CreditObjectID else ObjectID end), TableID, CurrencyID, CreditAccountID
		From AT9000
		Where DivisionID = @DivisionID and VoucherID = @VoucherID
	
		OPEN	@Cor_cur1
		FETCH NEXT FROM @Cor_cur1 INTO   @CorBatchID, @CorObjectID,  @CorTableID, @CorCurrencyID, @CorAccountID
		WHILE @@Fetch_Status = 0
		Begin
			Exec AP0303 @DivisionID, @VoucherID, @CorBatchID, @CorTableID, @CorObjectID, @CorCurrencyID, @CorAccountID,'C'
		FETCH NEXT FROM @Cor_cur1 INTO  @CorBatchID, @CorObjectID,  @CorTableID, @CorCurrencyID, @CorAccountID
		End
	Close @Cor_cur1
	End

End
Else --- Bo giai tru cong no phai tra
Begin
	Select @AccountID = DebitAccountID 
	From AT9000 
	Where DivisionID = @DivisionID and VoucherID = @VoucherID
	--IF @AccountID in (Select AccountID From AT1005 Where GroupID ='G04' and  IsObject =1 and DivisionID = @DivisionID)
	--SELECT @TransactionTypeID = (select top 1 TransactionTypeID From AT9000 a where a.VoucherID=b.TVoucherID and a.DivisionID=b.DivisionID)
	--FROM AT9000 b
	--Where VoucherID = @VoucherID and DivisionID = @DivisionID
	--If @TransactionTypeID in ('T02','T22')

	Begin	
		SET @Cor_cur = Cursor Scroll KeySet FOR 
		Select 	BatchID, (Case When TransactionTypeID ='T99' then CreditObjectID else ObjectID end) , TableID, CurrencyID, (Case When TransactionTypeID <>'T99' then DebitAccountID else CreditAccountID end)
		From AT9000
		Where DivisionID = @DivisionID and VoucherID = @VoucherID
	
		OPEN	@Cor_cur
		FETCH NEXT FROM @Cor_cur INTO   @CorBatchID, @CorObjectID,  @CorTableID, @CorCurrencyID, @CorAccountID
		WHILE @@Fetch_Status = 0
		Begin
			Exec AP0404 @DivisionID, @VoucherID, @CorBatchID, @CorTableID, @CorObjectID, @CorCurrencyID, @CorAccountID,'C'
		FETCH NEXT FROM @Cor_cur INTO  @CorBatchID, @CorObjectID,  @CorTableID, @CorCurrencyID, @CorAccountID
		End
	Close @Cor_cur
	End
	--Else
		Begin	
		SET @Cor_cur1 = Cursor Scroll KeySet FOR 
		Select 	BatchID, ObjectID, TableID, CurrencyID, DebitAccountID
		From AT9000
		Where DivisionID = @DivisionID and VoucherID = @VoucherID
	
		OPEN	@Cor_cur1
		FETCH NEXT FROM @Cor_cur1 INTO   @CorBatchID, @CorObjectID,  @CorTableID, @CorCurrencyID, @CorAccountID
		WHILE @@Fetch_Status = 0
		Begin
			Exec AP0404 @DivisionID, @VoucherID, @CorBatchID, @CorTableID, @CorObjectID, @CorCurrencyID, @CorAccountID,'D'
		FETCH NEXT FROM @Cor_cur1 INTO  @CorBatchID, @CorObjectID,  @CorTableID, @CorCurrencyID, @CorAccountID
		End
	Close @Cor_cur1
	End

End
