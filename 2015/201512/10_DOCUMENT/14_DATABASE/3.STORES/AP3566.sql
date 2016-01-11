/****** Object:  StoredProcedure [dbo].[AP3566]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
---- 	Created by Nguyen Van Nhan, date 12/05/2005
--- 	Purpose: Kiem tra man hinh hieu chinh Ban hang truoc khi luu
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[AP3566] @DivisionID as nvarchar(50),  @VoucherID as nvarchar(50), @TranMonth as int, @TranYear as int, @TransactionID as nvarchar(50), @WareHouseID as nvarchar(50),
				@IsNegativeStock as tinyint, @InventoryID as nvarchar(50), @AccountID as nvarchar(50), @MethodID as tinyint, @IsSource as tinyint, 
				@IsLimitDate as tinyint, @OldQuantity as decimal(28,8), @NewQuantity as decimal(28,8),
				@Language as tinyint

 AS

Declare 
	@Message as nvarchar(500),
	@ReTransactionID as nvarchar(50),
	@ReVoucherID as  nvarchar(50),
	@CreditAccountID  as  nvarchar(50)
Set @Message =''

If Exists (Select top 1 1 From AT2007 Where VoucherID =@VoucherID and TranMonth = @TranMonth and TranYear = @TranYear AND DivisionID = @DivisionID)
Begin
	Set @ReTransactionID =''
	Set @ReVoucherID =''
	Select  @CreditAccountID = CreditAccountID, @ReTransactionID = ReTransactionID, @ReVoucherID = ReVoucherID From AT2007 Where TransactionID = @TransactionID and VoucherID =@VoucherID and TranMonth = @TranMonth and TranYear = @TranYear AND DivisionID = @DivisionID

If @MethodID = 3 or @IsSource=1 Or @IsLimitDate = 1  --- Quan ly dich danh
  Begin
	

	If exists 	(Select top 1  1  From AT0114 Where DivisionID = @DivisionID and   DeQuantity + @NewQuantity - @OldQuantity > ReQuantity  and ReTransactionID = @ReTransactionID and InventoryID = @InventoryID and ReVoucherID = @ReVoucherID)
	   Begin
		Set @Message ='AFML000186'		
	   End	

  End	
Else
 Begin

	If @IsNegativeStock=0
	  If Exists (Select top 1 1  From AT2008 Where TranMonth = @TranMonth and TranYear = @TranYear and DivisionID = @DivisionID and WareHouseID = @WareHouseID and InventoryID = @InventoryID and InventoryAccountID = @CreditAccountID  and
		EndQuantity - @NewQuantity + @OldQuantity <0)
	   Begin
		Set @Message ='AFML000187'
		GOTO ENDMESS
	   End	

							 
 End
End
ENDMESS:
Select @Message as Message
GO
