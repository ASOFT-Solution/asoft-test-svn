/****** Object:  StoredProcedure [dbo].[AP3030]    Script Date: 07/29/2010 10:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--Created by: Vo Thanh Huong & Nguyen Thi Minh Thuy, date:  07/05/2005
--Edit by: Nguyen Quoc Huy 
--purpose :Kiem tra truoc khi cho phep hieu chinh man hình so du ton kho

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3030] @DivisionID as nvarchar(50), 
				@Tranmonth as int,
				@Tranyear as int,
				@VoucherID as nvarchar(50)
		
AS 
Declare @Status as int 

Select @Status=0

If exists (Select Top 1 1 	From AT2017 inner join AT1302 on AT2017.InventoryID  = AT1302.InventoryID
			inner join AT0114 on AT0114.ReVoucherID = AT2017.VoucherID and 
				AT0114.ReTransactionID = AT2017.TransactionID
 		Where AT2017.DivisionID=@DivisionID and AT2017.VoucherID= @VoucherID and
			 (  AT1302.MethodID=3 or AT1302.IsSource=1 or IsLimitDate=1) and AT2017.ActualQuantity <> AT0114.EndQuantity)

	Select @Status=1 

---- Tra ra gia tri
RETURN_VALUES:
Select @Status as Status