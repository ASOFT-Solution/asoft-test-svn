IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1104]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1104]
GO
----- Created by Nguyen Van Nhan.
----- Created Date 17/05/2003
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
CREATE PROCEDURE [dbo].[HP1104] 	@DivisionID nvarchar(50),	@STypeID nvarchar(50) ,
					@S as nvarchar(50)

 AS
	Declare @Status as tinyint,
		@EMess as nvarchar(500),
		@VMess as nvarchar(500)

Set 		@Status=0
Set		@EMess=''
Set		@VMess=''


If Exists (Select top 1 1 From  HT1400 Where S1 = @S and @STypeID ='E01' and DivisionID = @DivisionID)
	Begin
		Set 		@Status=1
		Set		@EMess= N'HFML000383'--'You can not delete data,because it in use!'
		Set		@VMess= N'HFML000383'--'B¹n kh«ng thÓ d÷ liÖu,d÷ liÖu ®ang ®­îc sö dông!'
	End

Else
If Exists (Select top 1 1 From  HT1400 Where S2 = @S and @STypeID ='E02' and DivisionID = @DivisionID)
	Begin
		Set 		@Status=1
		Set		@EMess= N'HFML000383'--'You can not delete data,because it in use!'
		Set		@VMess= N'HFML000383'--'B¹n kh«ng thÓ d÷ liÖu,d÷ liÖu ®ang ®­îc sö dông!'
	End
Else
If Exists (Select top 1 1 From  HT1400 Where S3 = @S and @STypeID ='E03' and DivisionID = @DivisionID)
	Begin
		Set 		@Status=1
		Set		@EMess= N'HFML000383'--'You can not delete data,because it in use'
		Set		@VMess= N'HFML000383'--'B¹n kh«ng thÓ d÷ liÖu,d÷ liÖu ®ang ®­îc sö dông!'
	End
	

Select @Status as Status , @EMess as  EMess, @VMess as VMess