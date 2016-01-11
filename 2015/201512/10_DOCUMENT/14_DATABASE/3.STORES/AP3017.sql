/****** Object:  StoredProcedure [dbo].[AP3017]    Script Date: 07/29/2010 09:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---- Created by Nguyen Van Nhan, Date 21/08/2003
---- Purpose: Kiem tra cho phep duoc Sua, Xoa phieu but toan tong hop


/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE	 [dbo].[AP3017]  	@DivisionID nvarchar(50), 
						@TranMonth as int, 
						@TranYear as int,
						@VoucherID nvarchar(50)
As
-------- Xoa bang Detail ----------
Declare 	@Status  as tinyint,
		@Message as nvarchar(250)

Set @Status  = 0
Set @Message = ''



If exists (Select top 1 1 From AT9000 Where VoucherID =@VoucherID and DivisionID =@DivisionID and Status <> 0 )
	Begin
		Set @Status = 1
		Set @Message = N'D÷ liÖu ®· ®uîc gi¶i trõ c«ng nî, b¹n kh«ng thÓ Söa hoÆc Xo¸'
		GOTO ENDMESS
	End
If exists (Select top 1 1 From AT9000 Where VoucherID =@VoucherID and DivisionID =@DivisionID and IsCost<>0 )
	Begin
		Set @Status = 1
		Set @Message = N'D÷ liÖu ®· ®uîc ph©n bæ vµ tÝnh gi¸ thµnh, b¹n kh«ng thÓ Söa hoÆc Xo¸'
		GOTO ENDMESS
	End

ENDMESS:
Select @Status as Status, @Message as Message


