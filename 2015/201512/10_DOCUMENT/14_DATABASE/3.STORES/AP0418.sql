/****** Object:  StoredProcedure [dbo].[AP0418]    Script Date: 07/28/2010 16:10:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----- 	Created by Nguyen Thi Ngoc Minh, Date 14/09/2004
----- 	Purpose: Xoa but toan chenh lech ty gia
------	Edit by: Nguyen Quoc Huy, Date: 06/07/2007
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [28/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP0418] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@ListTransactionID as nvarchar(4000)


 AS
Declare @sSQL as nvarchar(4000),
	 @sSQL1  as nvarchar(4000),
	@VoucherID as nvarchar(50),
	@BatchID as nvarchar(50),
	@TableID as nvarchar(50),
	@ObjectID as nvarchar(50),
	@CurrencyID as nvarchar(50),
	@DebitAccountID as nvarchar(50),
	@CreditAccountID as nvarchar(50),
	@TransactionID as nvarchar(50),
	@AV0418_Cursor as cursor

Set @sSQL = 'Select VoucherID, BatchID, TableID, ObjectID, DebitAccountID, CreditAccountID, TransactionID, CurrencyID, DivisionID
	From AT9000 
	Where 
		 DivisionID = ''' + @DivisionID + '''
		and TranMonth = ' + ltrim(str(@TranMonth)) + '
		and TranYear = ' + ltrim(str(@TranYear))

set @sSQL1 = ' and  TransactionID in (''' + @ListTransactionID +''')'
If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV0418]') and OBJECTPROPERTY(id, N'IsView') = 1)
     		Exec ('  Create View AV0418 	---created by AP0418
				as ' + @sSQL + @sSQL1)
	Else
		Exec ('  Alter View AV0418   	---created by AP0418
				as ' + @sSQL + @sSQL1)
print @sSQL + @sSQL1		

SET @AV0418_Cursor = CURSOR SCROLL KEYSET FOR
	Select VoucherID, BatchID, TableID, ObjectID, CurrencyID, DebitAccountID, CreditAccountID, TransactionID
	From AV0418

OPEN @AV0418_Cursor
FETCH NEXT FROM @AV0418_Cursor INTO 	@VoucherID, @BatchID, @TableID, @ObjectID, @CurrencyID,
						@DebitAccountID, @CreditAccountID, @TransactionID

WHILE @@Fetch_Status = 0
  BEGIN
/*
print 'V: ' + @VoucherID + '	B: ' + @BatchID + ' 	Ta: ' + @TableID
print 'O: ' + @ObjectID + '	C: ' + @CurrencyID + '	De: ' + @DebitAccountID
print 'Cr: ' + @CreditAccountID + '		Tr: ' + @TransactionID
*/
	Delete AT0303 Where 	(DebitVoucherID = @VoucherID or CreditVoucherID = @VoucherID) 
				and (DebitBatchID = @BatchID or CreditBatchID = @BatchID)
				and (AccountID = @DebitAccountID or AccountID = @CreditAccountID)
				and ObjectID = @ObjectID and CurrencyID = @CurrencyID
				and IsExrateDiff = 1 and DivisionID = @DivisionID

	Delete AT0404 Where 	(DebitVoucherID = @VoucherID or CreditVoucherID = @VoucherID) 
				and (DebitBatchID = @BatchID or CreditBatchID = @BatchID)
				and (AccountID = @DebitAccountID or AccountID = @CreditAccountID)
				and ObjectID = @ObjectID and CurrencyID = @CurrencyID 
				and IsExrateDiff = 1 and DivisionID = @DivisionID

	Delete AT9000 Where	VoucherID = @VoucherID and BatchID = @BatchID and TransactionID = @TransactionID
				and TableID = @TableID and isnull(ObjectID,'') = isnull(@ObjectID,'') and isnull(CurrencyID,'') = isnull(@CurrencyID,'')
				and DebitAccountID = @DebitAccountID and CreditAccountID = @CreditAccountID
				and DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear


	FETCH NEXT FROM @AV0418_Cursor INTO 	@VoucherID, @BatchID, @TableID, @ObjectID, @CurrencyID,
							@DebitAccountID, @CreditAccountID, @TransactionID
  END