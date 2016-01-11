IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP9000]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP9000]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
---- Created by: Khanh Van on 23/10/2013
---- Purpose: Kiem tra thong tin ton tai tren cac bang co lien quan truoc khi xoa

CREATE PROCEDURE 	[dbo].[HP9000]		
				@DivisionID as nvarchar(50), 
				@DataID as nvarchar(50),
				@TranMonth int,
				@TranYear int ,
				@FormID as nvarchar(50)
 AS

Declare @Status as tinyint,
	@Message  as nvarchar(250)
	Set @Status =0


	
IF @FormID ='HF0320'
Begin
If Exists (Select 1 From HT0322 inner join HT0323 
on HT0322.DivisionID = HT0323.DivisionID and HT0322.VoucherID = HT0323.VoucherID Where EmployeeID = @DataID and HT0322.DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear)
	Begin
		Set @Status =1
		Set @Message = N'HFML000481'
		goto EndMess
	End
End
IF @FormID ='HF0332'
Begin
If Exists (Select 1 From HT0322 inner join HT0323 
on HT0322.DivisionID = HT0323.DivisionID and HT0322.VoucherID = HT0323.VoucherID Where EmployeeID = @DataID and HT0322.DivisionID = @DivisionID and TranMonth = @TranMonth and TranYear = @TranYear)
	Begin
		Set @Status =1
		Set @Message = N'HFML000009'
		goto EndMess
	End
End
EndMess:

	Select @Status as Status, @Message as Message
GO


