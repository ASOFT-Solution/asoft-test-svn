/****** Object:  StoredProcedure [dbo].[AP4017]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
---- Created by Nguyen Van Nhan, Date 06/08/2003
---- Purpose: Xoa phieu xuat kho tu ban hang.
---- Edited by Bao Anh	Date: 30/10/2012
---- Purpose: Bo sung cap nhat so du theo sl mark cho AT0114 (2T)
---- Modified on 24/06/2014 by Lê Thi Thu Hien : Bổ sung AT2007 vào ReVoucherID
---- Modified by Tiểu Mai on 08/01/2016: Bổ sung xóa thông tin quy cách hàng hóa.
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/

ALTER PROCEDURE	 [dbo].[AP4017] 	@VoucherID nvarchar(50), 
					@BatchID nvarchar(50), 
					@DivisionID nvarchar(50), 
					@TranMonth as int, 
					@TranYear as int
As

-------- Xoa bang Detail ----------

Declare @Inventory_cur as cursor,
	@WareHouseID as nvarchar(50),
	@InventoryID as nvarchar(50),
	@ActualQuantity decimal(28,8),
	@TransactionID as nvarchar(50),
	@CreditAccountID as nvarchar(50),
	@ReVoucherID as nvarchar(50),
	@ReTransactionID as nvarchar(50),
	@MarkQuantity as decimal(28,8)


SET @Inventory_cur = Cursor Scroll KeySet FOR 
Select 	TransactionID, AT2006.WareHouseID, AT2007.InventoryID, ActualQuantity, CreditAccountID, 
		AT2007.ReVoucherID, ReTransactionID, MarkQuantity
From AT2007  	
inner join AT2006  on AT2007.VoucherID = AT2006.VoucherID AND AT2007.DivisionID = AT2006.DivisionID
inner join AT1302 on AT1302.InventoryID  = AT2007.InventoryID AND AT1302.DivisionID  = AT2007.DivisionID 
Where AT2007.DivisionID = @DivisionID and
	AT2007.TranMonth = @TranMOnth and
	AT2007.TranYear = @TranYear and
	AT2007.VoucherID =@VoucherID and
	AT2006.TableID = 'AT2006' and
	(MethodID = 3 or IsSource =1 or IsLimitDate = 1)

OPEN	@Inventory_cur
FETCH NEXT FROM @Inventory_cur  INTO  @TransactionID, @WareHouseID, @InventoryID, @ActualQuantity,@CreditAccountID, @ReVoucherID, @ReTransactionID, @MarkQuantity
WHILE @@Fetch_Status =0 
	Begin
		--pRINT @ActualQuantity
		
		Exec  AP7773 		@DivisionID, @TranMonth, @TranYear,
					@WareHouseID,@InventoryID,
					1,				
					@CreditAccountID,
					@ReVoucherID, @ReTransactionID,
					'',
					'',
					@ActualQuantity , 0, @MarkQuantity, 0
		
		FETCH NEXT FROM @Inventory_cur  INTO  @TransactionID, @WareHouseID, @InventoryID, @ActualQuantity,@CreditAccountID, @ReVoucherID, @ReTransactionID, @MarkQuantity
	End
Close @Inventory_cur
	
	
DELETE WT8899 
FROM WT8899 
LEFT JOIN AT2007 ON AT2007.DivisionID = WT8899.DivisionID AND AT2007.TransactionID = WT8899.TransactionID AND AT2007.VoucherID = WT8899.VoucherID AND WT8899.TableID = 'AT2007'
WHERE WT8899.DivisionID = @DivisionID AND AT2007.VoucherID = @VoucherID


Delete	 AT2007 
From 	AT2007 inner join AT2006 on AT2007.VoucherID = AT2006.VoucherID AND AT2007.DivisionID = AT2006.DivisionID
Where 	AT2007.VoucherID = @VoucherID AND AT2007.DivisionID = @DivisionID
	--and
	--AT2006.TableID ='AT2006' ---and
	---AT2006.BatchID = @BatchID

-------- Xoa bang Master  ----------
Delete AT2006 
Where 	AT2006.VoucherID =@VoucherID AND DivisionID = @DivisionID
	--and
	--AT2006.TableID ='AT2006' ---and
	--AT2006.BatchID = @BatchID

Update AT9000 set IsStock =0
	Where 	VoucherID =@VoucherID and
		TableID ='AT9000' and
		BatchID = @BatchID AND DivisionID = @DivisionID
GO
