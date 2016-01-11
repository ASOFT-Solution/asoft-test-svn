/****** Object:  StoredProcedure [dbo].[AP3016]    Script Date: 07/29/2010 09:54:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Van Nhan, Date 05/08/2003
---- Purpose: Kiem tra cho phep duoc Sua, Xoa phieu Ban hang khong

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE	 [dbo].[AP3016] 	@VoucherID nvarchar(50), 
					@BatchID nvarchar(50), 
					@DivisionID nvarchar(50), 
					@TranMonth as int, 
					@TranYear as int
As

-------- Xoa bang Detail ----------

Declare @Status as tinyint,
	@Message as nvarchar(500)

Set @Status =0 
Set @Message =''

If Exists (Select top 1 1 From AT9000 Where VoucherID =@VoucherID and DivisionID =@DivisionID and ( Status <>0 or IsCost<>0))
	Begin
		Set @Status = 1
		Set @Message =N'Chøng tõ nµy ®· ®­îc xö lý (gi¶i trõ c«ng nî hoÆc tÝng gi¸ thµnh). B¹n kh«ng ®­îc phÐp Söa hoÆc Xo¸.'
		Goto MESS
	End
MESS:
Select 0 as Status, ' ' as Message

