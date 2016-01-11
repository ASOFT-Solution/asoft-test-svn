/****** Object:  StoredProcedure [dbo].[AP3033]    Script Date: 07/29/2010 10:11:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Van Nhan, Date 07/06/2004
---- Purpose: Kiem tra cho phep duoc Sua, Xoa phieu Mua hang hay khong

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [29/07/2010]
'********************************************/

ALTER PROCEDURE	 [dbo].[AP3033] 	@VoucherID nvarchar(50), 
					@BatchID nvarchar(50), 
					@DivisionID nvarchar(50), 
					@TranMonth as int, 
					@TranYear as int,
					@Status as tinyint output,
					@VieMessage as nvarchar(250) output,
					@EngMessage as nvarchar(250) output
As

-------- Xoa bang Detail ----------
Declare @Message as nvarchar(4000)

--Add by Dang Le Bao Quynh; Date 02/05/2013
--Purpose: Kiem tra customize cho Sieu Thanh

Declare @AP4444 Table(CustomerName Int, Export Int)
Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')

--	Select 0 as Status, ' ' as Message
	Set @Status =0
/*	
If (Select CustomerName From @AP4444)=16
	Begin
		If Exists (Select  top 1 1 From AT9000 Where VoucherID = @VoucherID and IsCost<>0 and
								DivisionID = @DivisionID and TranMonth =@TranMonth  and
								TranYear = @TranYear)
		Begin	
			Set @Status = 1
			Set @Message = 'AFML000088'
			Goto MES
		End
	End
Else
*/
	Begin
		If Exists (Select  top 1 1 From AT9000 Where 	VoucherID = @VoucherID and (Status <>0 or IsCost<>0) and
								DivisionID = @DivisionID and TranMonth =@TranMonth  and
								TranYear = @TranYear)
		Begin	
			Set @Status = 1
			Set @Message = 'AFML000088'
			Goto MES
		End
	End
If Exists (Select  top 1 1 From AT2007	 Where 	ReVoucherID = @VoucherID and DivisionID = @DivisionID )
 Begin	
	Set @Status = 1
	Set @Message = 'AFML000089'
	Goto MES
End

If Exists (Select  top 1  1 From AT0114 Inner Join AT1302 On AT1302.InventoryID = AT0114.InventoryID and AT1302.DivisionID = AT0114.DivisionID	 
		Where 	ReVoucherID = @VoucherID and AT0114.DivisionID = @DivisionID and isnull(DeQuantity,0)<> 0  and (MethodID =3 Or IsSource=1 or IsLimitDate =1) )
 Begin	
	Set @Status = 1
	Set @Message = 'AFML000089'
	Goto MES
End



MES:
Set @VieMessage = @Message
Set @EngMessage=@Message