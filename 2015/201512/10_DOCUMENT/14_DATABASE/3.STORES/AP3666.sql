/****** Object:  StoredProcedure [dbo].[AP3666]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
---------------- 	Created by Nguyen Van Nhan. Date 12/05/2005
----------------	Purpose: Kiem tra hieu chinh mot phieu Hoa don ban hang
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[AP3666] @DivisionID as nvarchar(50), @TranMonth as int, @TranYear int, @VoucherID as nvarchar(50)
 AS

Declare @Status as tinyint,
	@Message as nvarchar(4000)


Set @Status = 0
Set @Message =''

----- Xa xuat kho thuc te dich danh
If Exists (Select top 1 1 From AT2007 Where VoucherID = @VoucherID and isnull(ReVoucherID,'')<>'' and DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear )
  Begin
	Set @Status = 1
  End
------ Da giai tru
If Exists (Select top 1 1 From AT9000 Where TransactionTypeID in ('T04', 'T14') and VoucherID = @VoucherID and Status <>0 and TranMonth = @TranMOnth and TranYear = @TranYear and DivisionID = @DivisionID)
 Begin
	Set  @Status = 2
 End

Select @Status  as Status
GO
