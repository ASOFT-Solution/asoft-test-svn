IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[DP0114]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[DP0114]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---- Created by Nguyen Quoc Huy.
---- Created Date 09/05/2007
---- Purpose: Xy ly lai thuc te dich danh sau khi chuyen so lieu qua.
---- Modified on 24/06/2014 by Lê Thi Thu Hien : Bổ sung AT2007 vào ReVoucherID
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[DP0114] 
AS
	

Declare @Cur as cursor,
	@WareHouseID	 as nvarchar(50),	
	@InventoryID as nvarchar(50),
	@Quantity as decimal(28,8),
	@DivisionID as nvarchar(50),
	@ReTransactionID nvarchar(50),
	@ReVoucherID as nvarchar(50),
	@VOUCHERID as nvarchar(50),
	@TransactionID nvarchar(50),
	@count as int,
	@ReVoucherID1 as nvarchar(50),
	@TransactionID1 nvarchar(50)


Alter Table AT2007  DISABLE TRIGGER All

Set @Cur = Cursor Scroll KeySet For



SELECT AT2007.VOUCHERID,AT2007.TransactionID,AT2007.ReVoucherID,ReTransactionID,InventoryID 
FROM AT2007 INNER JOIN AT2006 ON AT2006.VOUCHERID = AT2007.VOUCHERID and AT2006.DivisionId = AT2007.DivisionId
WHERE KINDVOUCHERID IN (3,2,4,6,8,10) --AND AT2007.VOUCHERID = 'CNAI20070000000076'
AND AT2007.DivisionID = @DivisionID
	
set @count =0
Open @Cur
Fetch Next From @Cur Into @VOUCHERID,@TransactionID, @ReVoucherID,@ReTransactionID,@InventoryID

While @@FETCH_STATUS = 0
Begin	
	--PRINT @ReVoucherID
	/*
	If (not exists (Select 1 From AT0114 	Where 	ReVoucherID =@ReVoucherID and ReTransactionID = @ReTransactionID)) and len(@ReVoucherID)>16
	BEGIN
		
		Update AT2007 Set ReVoucherID = Right(@ReVoucherID,Len(@ReVoucherID)-2),
					ReTransactionID = Right(@ReTransactionID,Len(@ReTransactionID)-2)
		Where VOUCHERID = @VOUCHERID and InventoryID = @InventoryID and ReTransactionID = @ReTransactionID
		
	END
	*/
	--Set @ReVoucherID1 = @ReVoucherID
	--Set @TransactionID1 = @TransactionID
	While (not exists (Select 1 From AT0114 	Where 	AT0114.ReVoucherID =@ReVoucherID and ReTransactionID = @ReTransactionID AND DivisionID = @DivisionID)) and len(@ReVoucherID)>16
	BEGIN
		
		Update AT2007 Set ReVoucherID = Right(@ReVoucherID,Len(@ReVoucherID)-2),
					ReTransactionID = Right(@ReTransactionID,Len(@ReTransactionID)-2)
		Where VOUCHERID = @VOUCHERID and InventoryID = @InventoryID and TransactionID = @TransactionID AND DivisionID = @DivisionID
		Set @ReVoucherID = Right(@ReVoucherID,Len(@ReVoucherID)-2)
		if len(@ReTransactionID)>16 Set @ReTransactionID = Right(@ReTransactionID,Len(@ReTransactionID)-2)

	END
	Fetch Next From @Cur Into  @VOUCHERID, @TransactionID, @ReVoucherID,@ReTransactionID,@InventoryID
End
Close @Cur
Alter Table AT2007 ENABLE  Trigger All
--print @count
					
---- Xu ly lai thuc te dich danh

Update  AT0114 set  	EndQuantity =ReQuantity,
			DeQuantity =0


Set @Cur = Cursor Scroll KeySet For

Select WareHouseID,  InventoryID, AT2007.ReVoucherID, ReTransactionID,sum(isnull(ActualQuantity,0)) as ActualQuantity
From AT2007 inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID and AT2006.DivisionID = AT2007.DivisionID
Where KindVoucherID in (2,4,6,8) AND AT2007.DivisionID = @DivisionID

Group by WareHouseID,  InventoryID, AT2007.ReVoucherID, ReTransactionID
Union All
Select WareHouseID2,  InventoryID, AT2007.ReVoucherID, ReTransactionID, sum(isnull(ActualQuantity,0)) as ActualQuantity
From AT2007 inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID and AT2006.DivisionID = AT2007.DivisionID
Where KindVoucherID =3 AND AT2007.DivisionID = @DivisionID

Group by WareHouseID2,  InventoryID, AT2007.ReVoucherID, ReTransactionID 

Open @Cur
Fetch Next From @Cur Into  @WareHouseID,  @InventoryID, @ReVoucherID, @ReTransactionID, @Quantity
While @@FETCH_STATUS = 0
Begin	

  Update AT0114 set 	--DeQuantity = @Quantity,
			--EndQuantity = ReQuantity - @Quantity
			DeQuantity = DeQuantity + @Quantity,
			EndQuantity = ReQuantity - (DeQuantity +  @Quantity)
  Where ReVoucherID = @ReVoucherID and 
	ReTransactionID = @ReTransactionID and
	InventoryID = @InventoryID and
	WareHouseID = @WareHouseID AND DivisionID = @DivisionID	
Fetch Next From @Cur Into  @WareHouseID,  @InventoryID, @ReVoucherID, @ReTransactionID, @Quantity	
End
Close @Cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

