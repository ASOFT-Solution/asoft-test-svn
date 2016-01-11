
/****** Object:  StoredProcedure [dbo].[AP9004]    Script Date: 07/29/2010 13:56:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


------ Created by Nguyen Van Nhan
------  Created Date 29/06/2004
------ Purpose:  Xoa phieu duoc phan bo va cap nhat trang thai tuong ung
------ Edit by Nguyen Quoc Huy Date 19/07/2006



/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP9004] 	
	@DivisionID as nvarchar(50), 
	@VoucherID as nvarchar(50),
	@TransactionID as nvarchar(50), 
	@TranMonth as int, 
	@TranYear as int

AS

Declare 	@DebitAccountID as nvarchar(50),
		@CreditAccountID as nvarchar(50)


Select top 1 @DebitAccountID = DebitAccountID, @CreditAccountID = CreditAccountID 
From AT9001 Where DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear and VoucherID = @VoucherID and TransactionID = @TransactionID

--- Xoa but toan phan bo
Delete AT9001 Where DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear and VoucherID = @VoucherID and TransactionID = @TransactionID
--- Cap nhat trang thai
Update AT9000 set IsAudit =0
Where DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear and DebitAccountID =@DebitAccountID and CreditAccountID = CreditAccountID and Isnull(Ana01ID,'') =''