
/****** Object:  StoredProcedure [dbo].[TP9999]    Script Date: 08/04/2010 13:41:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Nguyen Quoc Huy
---- Date 18/10/2005.
---- Purpose: Kiem tra xem co cho phep xoa du lieu.
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[TP9999] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int

 AS
Declare @Status as int, 
@Message as nvarchar(250)

	Set @Status =0
	Set @Message =''

Set nocount on

Exec  AP7301 @DivisionID,@TranMonth,@TranYear,@TranMonth,@TranYear, 0, 0

If Exists ( SELECT  top 1 1 FROM AV7302 Where (AccountGroup1ID = 'G07' and (DebitClosing  <> 0 or CreditClosing <> 0 ))
				or (AccountGroup1ID = 'G06' and (DebitClosing  <> 0 or CreditClosing <> 0 ) ) )
	Begin	
		Set @Message =N'B¹n kh«ng thÓ bá kú kÕ to¸n nµy, v× doanh thu vµ chi phÝ b¹n ch­a kÕt chuyÓn.'
		set @Status = 1
		Goto EndMes
	End
Else
	Begin
		Delete AT9999 Where DivisionID =  @DivisionID  and TranMonth =  @TranMonth  and TranYear =  @TranYear 
		Set @Message =N'....'
		Set @Status = 0
		Goto EndMes
	End
Set nocount off
EndMes:
Select @Status as Status, @Message as Message
GO
