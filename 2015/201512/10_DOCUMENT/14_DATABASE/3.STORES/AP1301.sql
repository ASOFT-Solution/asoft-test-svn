
/****** Object:  StoredProcedure [dbo].[AP1301]    Script Date: 07/29/2010 17:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Minh Thuy and Van Nhan.
---- Created Date 26/06/2006
--- Purpose: Lam tron phan tinhgia xuat kho FIFO
---- Edit by Nguyen Quoc Huy, Date 30/10/2006
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1301] @DivisionID as nvarchar(50), @TranMonth as int , @TranYear int
 AS

Declare @DeltaAmount as decimal(28,8),
	 @ReTransactionID as nvarchar(50),
	@InventoryID as  nvarchar(50),
	@TransactionID nvarchar(50),
	@Delta_cur as cursor



SET @Delta_cur = Cursor Scroll KeySet FOR 
	
Select 	AT0114.ReTransactionID, AT0114.InventoryID, AT2007.ConvertedAmount- sum(AT0115.convertedAmount) as DeltaAmount 

From AT0114 	inner join AT1302 on AT1302.InventoryID = AT0114.InventoryID and AT1302.DivisionID = AT0114.DivisionID
		inner join (Select TransactionID, ConvertedAmount, DivisionID From AT2007
				Union All
				Select TransactionID, ConvertedAmount, DivisionID From AT2017
			) AT2007 on AT2007.TransactionID =AT0114.reTransactionID and AT2007.DivisionID =AT0114.DivisionID
		right join AT0115 on AT0115.reTransactionID = AT0114.reTransactionID and AT0115.DivisionID = AT0114.DivisionID
Where MethodID =1 and EndQuantity =0 and AT0114.DivisionID = @DivisionID
group by AT0114.ReTransactionID, AT0114.InventoryID, AT0114.ReVoucherNo,ReQuantity, AT0114.UnitPrice,
	AT2007.ConvertedAmount
having AT2007.ConvertedAmount- sum(AT0115.convertedAmount)<>0

OPEN	@Delta_cur
FETCH NEXT FROM @Delta_cur INTO  @ReTransactionID, @InventoryID, @DeltaAmount
WHILE @@Fetch_Status = 0
Begin
----Print ' INV: '+@InventoryID+' can lam tron: '+str(@DeltaAmount,20,4)
/*
	If  @InventoryID = 'VLNU0006'
	Begin
	print '@ReTransactionID' + @ReTransactionID
	print '@DeltaAmount' + str(@DeltaAmount)
	End
*/
	Set @TransactionID = null
	Set @TransactionID = (Select top 1 TransactionID From AT0115
							Where ReTransactionID = @ReTransactionID and InventoryID =@InventoryID and
								TranMonth + 100*TranYear >= @TranMonth +100*@TranYear and DivisionID = @DivisionID
				Order by TranYear*100+ TranMonth DESC,  VoucherDate Desc , TransactionID  Desc)

	If @TransactionID is not null
		Begin
			--- Update AT2007.
				update AT2007 set 	ConvertedAmount = ConvertedAmount +isnull(@DeltaAmount,0),
							OriginalAmount =ConvertedAmount+isnull(@DeltaAmount,0),
							UnitPrice = (Case when ActualQuantity <>0 then (ConvertedAmount+isnull(@DeltaAmount,0))/ActualQuantity else UnitPrice End)
				Where InventoryID =@InventoryID and 
					TransactionID = @TransactionID and 
					DivisionID = @DivisionID
			--- Update At0115
				update AT0115 	set  	ConvertedAmount = ConvertedAmount +isnull(@DeltaAmount,0)							
				Where InventoryID =@InventoryID and 
					TransactionID = @TransactionID and 
					ReTransactionID = @ReTransactionID and 
					DivisionID = @DivisionID	
		End
							
FETCH NEXT FROM @Delta_cur INTO  @ReTransactionID, @InventoryID, @DeltaAmount
End

Close @Delta_cur