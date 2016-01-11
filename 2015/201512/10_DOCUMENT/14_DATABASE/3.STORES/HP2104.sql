IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2104]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2104]
GO
----- Created by Bảo Anh	Date: 27/08/2013
----- Purpose: Kiểm tra trước khi xóa mã phân loại hợp đồng lao động

CREATE PROCEDURE [dbo].[HP2104] 	@DivisionID nvarchar(50),
									@STypeID nvarchar(50),
									@S as nvarchar(50)

 AS
	Declare @Status as tinyint,
		@EMess as nvarchar(500),
		@VMess as nvarchar(500)

Set 	@Status=0
Set		@EMess=''
Set		@VMess=''


If Exists (Select top 1 1 From  HT1360 Where DivisionID = @DivisionID and @STypeID ='C01' And S1 = @S)
	Begin
		Set 		@Status=1
		Set		@EMess= N'HFML000383'--'You can not delete data,because it in use!'
		Set		@VMess= N'HFML000383'--'B¹n kh«ng thÓ d÷ liÖu,d÷ liÖu ®ang ®­îc sö dông!'
	End

Else
If Exists (Select top 1 1 From  HT1360 Where DivisionID = @DivisionID and @STypeID ='C02' And S2 = @S)
	Begin
		Set 		@Status=1
		Set		@EMess= N'HFML000383'--'You can not delete data,because it in use!'
		Set		@VMess= N'HFML000383'--'B¹n kh«ng thÓ d÷ liÖu,d÷ liÖu ®ang ®­îc sö dông!'
	End
Else
If Exists (Select top 1 1 From  HT1360 Where DivisionID = @DivisionID and @STypeID ='C03' And S3 = @S)
	Begin
		Set 		@Status=1
		Set		@EMess= N'HFML000383'--'You can not delete data,because it in use'
		Set		@VMess= N'HFML000383'--'B¹n kh«ng thÓ d÷ liÖu,d÷ liÖu ®ang ®­îc sö dông!'
	End	

Select @Status as Status , @EMess as  EMess, @VMess as VMess