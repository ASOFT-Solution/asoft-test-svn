/****** Object:  StoredProcedure [dbo].[AP3013]    Script Date: 07/29/2010 09:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Van Nhan, Date 05/08/2003
---- Purpose: Kiem tra cho phep duoc Sua, Xoa phieu Mua hang hay khong

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE	 [dbo].[AP3013] 	@VoucherID nvarchar(50), 
					@BatchID nvarchar(50), 
					@DivisionID nvarchar(50), 
					@TranMonth as int, 
					@TranYear as int
As

-------- Xoa bang Detail ----------
Declare @Status as tinyint,
	@Message as nvarchar(4000)

--	Select 0 as Status, ' ' as Message
	Set @Status =0
If Exists (Select  top 1 1 From AT9000 Where 	VoucherID = @VoucherID and Status <>0 and IsCost<>0 and
						DivisionID = @DivisionID and TranMonth =@TranMonth  and
						TranYear = @TranYear)
 Begin	
	Set @Status = 1
	Set @Message =N'D÷ liÖu ®· ®­îc xö lý, b¹n kh«ng ®­îc phÐp Söa hoÆc Xo¸ '
	Goto MES
End

If Exists (Select  top 1 1 From AT2007	 Where 	ReVoucherID = @VoucherID and DivisionID = @DivisionID )
 Begin	
	Set @Status = 1
	Set @Message =N'PhiÕu mua hµng ®· ®­îc xuÊt kho theo l« nhËp nµy, b¹n kh«ng ®­îc phÐp Söa hoÆc Xo¸ '
	Goto MES
End

If Exists (Select  top 1  1 From AT0114	 Where 	ReVoucherID = @VoucherID and DivisionID = @DivisionID and isnull(DeQuantity,0)<> 0 )
 Begin	
	Set @Status = 1
	Set @Message =N' PhiÕu mua hµng ®· ®­îc xuÊt kho theo l« nhËp nµy, b¹n kh«ng ®­îc phÐp Söa hoÆc Xo¸ '
	Goto MES
End



MES:
Select @Status as Status, @Message as Message



