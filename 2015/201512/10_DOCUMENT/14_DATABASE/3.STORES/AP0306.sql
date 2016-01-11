/****** Object:  StoredProcedure [dbo].[AP0306]    Script Date: 12/14/2010 15:26:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



------ Created by Dang Le Bao Quynh, Date 24/06/2008
-----  Purpose: Tu dong giai tru but toan chenh lech ty gia thanh toan
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP0306] 	@DivisionID nvarchar(50),
					@TranMonth as int,
					@TranYear as int,		
					@GiveVoucherID nvarchar(50),		
					@GiveBatchID 	 nvarchar(50),		
					@GiveTableID 	 nvarchar(50),		
					@VoucherID as nvarchar(50),
					@BacthID as nvarchar(50),
					@AccountID as nvarchar(50),
					@ObjectID as nvarchar(50),
					@CurrencyID as nvarchar(50),
					@DebitAccountID as nvarchar(50),
					@CreditAccountID  as nvarchar(50),
					@ConvertedAmount as decimal (28,8),
					@UserID as nvarchar(50)
					

 AS
Declare @GiveUpID as nvarchar(50)

Exec AP0000 @DivisionID, @GiveUpID  OUTPUT, 'AT0303', 'G', @TranYear ,'',18, 3, 0, '-'

If  	@CreditAccountID = @AccountID
	Insert AT0303 (GiveUpID, GiveUpDate, GiveUpEmployeeID, DivisionID, ObjectID, AccountID, CurrencyID, 
		DebitVoucherID, DebitBatchID, DebitTableID, CreditVoucherID, CreditBatchID, CreditTableID, 
		OriginalAmount, ConvertedAmount, IsExrateDiff, CreateDate, CreateUseID, LastModifyUserID, LastModifyDate)
	Values  (@GiveUpID, getdate(), null, @DivisionID, @ObjectID, @AccountID, @CurrencyID,
		@GiveVoucherID, @GiveBatchID, @GiveTableID, @VoucherID, @BacthID, 'AT9000',
		0, @ConvertedAmount, 0, getdate(), @UserID, @UserID, getDate())
Else
	Insert AT0303 (GiveUpID, GiveUpDate, GiveUpEmployeeID, DivisionID, ObjectID, AccountID, CurrencyID, 
		DebitVoucherID, DebitBatchID, DebitTableID, CreditVoucherID, CreditBatchID, CreditTableID, 
		OriginalAmount, ConvertedAmount, IsExrateDiff, CreateDate, CreateUseID, LastModifyUserID, LastModifyDate)
	Values  (@GiveUpID, getdate(), null, @DivisionID, @ObjectID, @AccountID, @CurrencyID,
		 @VoucherID, @BacthID, 'AT9000',@GiveVoucherID, @GiveBatchID, @GiveTableID,
		0, @ConvertedAmount, 0, getdate(), @UserID, @UserID, getDate())


UPdate AT9000 set Status =1
Where VoucherID =@VoucherID and TransactionTypeID='T10' and DivisionID =@DivisionID