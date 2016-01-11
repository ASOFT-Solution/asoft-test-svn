IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1400]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1400]
GO


/****** Object:  StoredProcedure [dbo].[HP1400]    Script Date: 09/20/2011 16:08:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




----- Kiem tra dieu kien khi xoa ho so nhan vien
---- Created by Nguyen Van Nhan, Date 22/04/2004
---- Edit by: Dang Le Bao Quynh; Date 14/08/2007
---- Purpose: Kiem tra thong tin ton tai tren cac bang co lien quan truoc khi xoa
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
CREATE PROCEDURE 	[dbo].[HP1400]		@DivisionID as nvarchar(50), 
				@EmployeeID as nvarchar(50) 
 AS

Declare @Status as tinyint,
	@VietMess as nvarchar(250),
	@EngMess as nvarchar(250)
	Set @Status =0
	Set @VietMess =''
	Set @EngMess =''

If Exists (Select 1 From HT2400 Where EmployeeID = @EmployeeID and DivisionID = @DivisionID
	Union Select 1 From HT2460 Where EmployeeID = @EmployeeID and DivisionID = @DivisionID)
	Begin
		Set @Status =1
		Set @VietMess = N'HFML000084'--' §· thiÕt lËp hå s¬ l­¬ng hay hå s¬ BHXH cho nh©n viªn nµy. B¹n kh«ng thÓ Xãa!'
		Set @EngMess= N'HFML000084'--'This Employee has been setup ,you can not delete!'
		goto EndMess
	End

If Exists (Select 1 From HT1331 Where EmployeeID = @EmployeeID and DivisionID = @DivisionID)
	Begin
		Set @Status =1
		Set @VietMess = N'HFML000085'--' §· thiÕt lËp khãa ®µo t¹o cho nh©n viªn nµy. B¹n kh«ng thÓ Xãa!'
		Set @EngMess= N'HFML000085'--'This Employee has been setup ,you can not delete!'
		goto EndMess
	End

If Exists (Select 1 From HT1380 Where EmployeeID = @EmployeeID and DivisionID = @DivisionID)
	Begin
		Set @Status =1
		Set @VietMess = N'HFML000086'--' §· thiÕt lËp quyÕt ®Þnh th«i viÖc  cho nh©n viªn nµy. B¹n kh«ng thÓ Xãa!'
		Set @EngMess= N'HFML000086'--'This Employee has been setup ,you can not delete!'
		goto EndMess
	End

If Exists (Select 1 From HT0305 Where EmployeeID = @EmployeeID and DivisionID = @DivisionID)
	Begin
		Set @Status =1
		Set @VietMess = N'HFML000479'
		Set @EngMess= N'HFML000479'
		goto EndMess
	End

If Exists (Select 1 From HT0321 Where EmployeeID = @EmployeeID and DivisionID = @DivisionID)
	Begin
		Set @Status =1
		Set @VietMess = N'HFML000481'
		Set @EngMess= N'HFML000481'
		goto EndMess
	End
	
EndMess:

	Select @Status as Status, @VietMess as VieMessage,@EngMess as EngMessage
GO


