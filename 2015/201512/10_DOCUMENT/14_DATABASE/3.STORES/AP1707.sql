
/****** Object:  StoredProcedure [dbo].[AP1707]    Script Date: 10/28/2010 13:08:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



--- Created by Thuy Tuyen and Van Nhan, Date13/12/2006
---- Purpose: Kiem tra dieu kien truoc khi phan bo.

/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

ALTER PROCEDURE [dbo].[AP1707]  @DivisionID nvarchar(50), 
				@TranMonth as int ,
				@TranYear as int, 
				@D_C as nvarchar(50),
				@gnLang as int,
				@JobID as nvarchar(50)	
 AS

Declare 	@Status as tinyint,
		@Message as  nvarchar(500)
Set nocount on
Set @Status=0
set  @Message =''

if @D_C ='D'  --- Kiem tra phan bo chi phi
If exists (Select top 1 1 From AT1704 Where  TranMonth +100*TranYear>= @TranMonth+100* @TranYear  and DivisionID =@DivisionID and D_C = @D_C And JobID Like @JobID)
  Begin
	Set	@Status = 1
	set @Message = 'AFML000265'
	Goto EndMess
  End

if @D_C ='C'  --- Kiem tra danh thu
If exists (Select top 1 1 From AT1704 Where  TranMonth +100*TranYear>= @TranMonth+100* @TranYear  and DivisionID =@DivisionID and  D_C = @D_C And JobID Like @JobID)
  Begin
	Set	@Status = 1
	set @Message = 'AFML000266'
	Goto EndMess
  End

Set nocount off
  EndMess:
Select @Status as Status, @Message as Message
