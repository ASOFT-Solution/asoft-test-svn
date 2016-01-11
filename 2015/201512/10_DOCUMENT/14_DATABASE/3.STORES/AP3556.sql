/****** Object:  StoredProcedure [dbo].[AP3556]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
----- 	Created by Nguyen Van Nhan
-----	Created Date 12/05/2005
----	Purpose: Cap nhat lai so luong , don gia nhap kho khi hieu chinh man hinh ban hang
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[AP3556] @DivisionID as nvarchar(50),  @TranMonth int, @TranYear as int, @VoucherID nvarchar(50)

AS


Declare 	@AT9000_cur as cursor,
		@TransactionID as nvarchar(50),
		@InventoryID  as nvarchar(50),
		@NewQuantity as decimal(28,8),
		@UnitPrice as decimal(28,8), ---- Gia nhap kho
		@Ana01ID as nvarchar(50),
		@Ana02ID as nvarchar(50),
		@Ana03ID as nvarchar(50),
		@ObjectID as nvarchar(50),	
		@LastModifyUserID as nvarchar(50)
		

If Exists (Select Top 1 1 From AT2006 Where VoucherID =@VoucherID and TableID = 'AT2006' AND DivisionID = @DivisionID)
Begin

---- B1 Lay cac gia moi duoc hieu chinh o man hinh ban  hang
SET @AT9000_cur = Cursor Scroll KeySet FOR 
Select  TransactionID, InventoryID, Quantity,  Ana01ID, Ana02ID, Ana03ID,		
	ObjectID,  LastModifyUserID 
From AT9000 Where VoucherID = @VoucherID and TransactionTypeID ='T04' AND DivisionID = @DivisionID
OPEN	@AT9000_cur
FETCH NEXT FROM @AT9000_cur INTO  @TransactionID, @InventoryID, @NewQuantity,  @Ana01ID, @Ana02ID, @Ana03ID,
	  	 @ObjectID,  @LastModifyUserID



/*
Update AT2006 set ObjectID = @ObjectID 
Where 	VoucherID =@VoucherID and
	TableID = 'AT9000'
*/

WHILE @@Fetch_Status = 0
	Begin	--- Cap nhat gia xuat kho thuong
		
		
		Update AT2007		 set 	ActualQuantity = @NewQuantity,
						ConvertedAmount = UnitPrice*@NewQuantity,
						OriginalAmount = UnitPrice*@NewQuantity,
						UnitPrice = UnitPrice

		From AT2007 inner join AT2006 on AT2007.VoucherID = AT2006.VoucherID AND AT2007.DivisionID = AT2006.DivisionID 
		
		Where 	AT2007.DivisionID = @DivisionID and
			AT2007.VoucherID = @VoucherID and
			AT2007.TransactionID = @TransactionID and
			AT2007.InventoryID = @InventoryID and
			AT2006.TableID = 'AT2006'

		FETCH NEXT FROM @AT9000_cur INTO  @TransactionID, @InventoryID, @NewQuantity,  @Ana01ID, @Ana02ID, @Ana03ID,
		  	  @ObjectID,  @LastModifyUserID

	End

Update AT2006 set ObjectID = @ObjectID 
Where 	VoucherID =@VoucherID and
	TableID = 'AT2006' AND DivisionID = @DivisionID

Close @AT9000_cur

End
GO
