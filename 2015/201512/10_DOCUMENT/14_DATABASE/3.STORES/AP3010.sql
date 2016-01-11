/****** Object:  StoredProcedure [dbo].[AP3010]    Script Date: 07/29/2010 09:21:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
----- 	Created by Nguyen Quoc Huy.
-----	Created Date 07/05/2005.
-----	Purpose: Kiem tra Trang thai phieu co duoc hieu chinh hay khong

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3010] 
	@DivisionID as nvarchar(50), 
	@TranMonth int, @TranYear as int, 
	@VoucherID as nvarchar(50)
 AS

Declare @Status as tinyint

Set nocount on
 
Set @Status =0

 If Exists (Select top 1  1  From AT0114 Where ReVoucherID = @VoucherID and  DivisionID = @DivisionID and DeQuantity <>0 )
	 Set @Status =1

If  Exists (Select top 1  1 From AT9000  Where VoucherID = @VoucherID and  DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear  and Status <>0 )
	 Set @Status =2

Set nocount off

Select @Status as Status