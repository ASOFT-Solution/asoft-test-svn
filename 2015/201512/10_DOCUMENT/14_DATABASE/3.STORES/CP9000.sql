/****** Object:  StoredProcedure [dbo].[CP9000]    Script Date: 07/29/2010 15:17:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



----- Created by: Nguyen Thi Thuy Tuyen, date: 11/01/2006
---- Purpose: Kiem tra rang buoc du lieu cho phep Sua, Xoa
---Last Edt  Thuy Tuyen  10/06/2007
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[CP9000]  @DivisionID nvarchar(50),
				 @TranMonth int,
				@TranYear int,
				@WMFileID nvarchar(50),
				@TableName  nvarchar(250),
				@IsEdit tinyint   ----  =0  la Xoa,  = 1 la Sua

AS

Declare @Status as tinyint,
	@EngMessage as nvarchar(250),
	@VieMessage as nvarchar(250)

Select @Status =0, 	@EngMessage ='',	 @VieMessage=''

If @TableName =  'CT4000'  and @IsEdit = 0
BEGIN
	If exists (Select top 1 1 From CT4002 Where WMFileID = @WMFileID AND DivisionID = @DivisionID)
	Begin
			Set @Status =1
			Set @VieMessage = 'Hå s¬ nµy ®· ®­îc lËp nhËt ký . B¹n kh«ng thÓ xãa. Vui lßng kiÓm tra l¹i !'
			Set @EngMessage ='This File  is used. You can not delete one. You must check!'
			Goto EndMess
	End 	

	/*If exists (Select 1 From CT5000  Where WMFileID = @WMFileID AND DivisionID = @DivisionID)
	Begin
			Set @Status = 2 
			Set @VieMessage ='Hå s¬ nµy ®­îc khai b¸o danh môc thiÕt bÞ. Vui lßng kiÓm tra l¹i!' 
			Set @EngMessage ='This File  is used. You can not delete one. You must check!'
			Goto EndMess
	End */
	
	If exists (Select 1 From CT5003  Where WMFileID = @WMFileID AND DivisionID = @DivisionID)
	Begin
			Set @Status = 3 
			Set @VieMessage ='Hå s¬ nµy ®· ®­îc lËp yªu cÇu dÞch vô. B¹n kh«ng thÓ xãa. Vui lßng kiÓm tra l¹i !' 
			Set @EngMessage ='This File  is used. You can not delete one. You must check!'
			Goto EndMess
	End
END


If @TableName =  'CT4000'  and @IsEdit = 1
BEGIN
	If exists (Select top 1 1 From CT4002 Where WMFileID = @WMFileID AND DivisionID = @DivisionID)
	Begin
			Set @Status =4
			Set @VieMessage = 'Hå s¬ nµy ®· lËp nhËt ký dÞch vô. B¹n cã muèn söa kh«ng?'
			Set @EngMessage ='This File  is used . You want to edit !'
			Goto EndMess
	End 	

	/*If exists (Select 1 From CT5000  Where WMFileID = @WMFileID AND DivisionID = @DivisionID)
	Begin
			Set @Status =5 
			Set @VieMessage ='Hå s¬ nµy ®· ®­îc sö dông, kh«ng thÓ söa. B¹n cã muèn xem kh«ng?'
			Set @EngMessage ='This File  is used. You can not  edit  one. You want to see !'
			Goto EndMess
	End  */
	
	If exists (Select 1 From CT5003  Where WMFileID = @WMFileID AND DivisionID = @DivisionID)
	Begin
			Set @Status = 6
			Set @VieMessage ='Hå s¬ nµy ®·®· lËp yªu cÇu dÞch vô. B¹n cã muèn söa kh«ng?'
			Set @EngMessage ='This File  is used. You want to edit !'
			Goto EndMess
	End
END
------ Kiem tra  yeu cau dich vu------
If @TableName =  'CT5003'  and @IsEdit = 0
BEGIN
	If exists (Select top 1 1 From CT4002 Where  ReVoucherID = @WMFileID AND DivisionID = @DivisionID)
	Begin
			Set @Status =1
			Set @VieMessage = 'Hå s¬ nµy ®· ®­îc lËp nhËt ký. B¹n kh«ng thÓ xãa. Vui lßng kiÓm tra l¹i !'
			Set @EngMessage ='This File  is used. You can not delete one. You must check!'
			Goto EndMess
	End 	

	
END
If @TableName =  'CT5003'  and @IsEdit = 1
BEGIN
	If exists (Select top 1 1 From CT4002 Where  ReVoucherID = @WMFileID AND DivisionID = @DivisionID)
	Begin
			Set @Status =2
			Set @VieMessage ='Hå s¬ nµy ®· ®­îc sö dông, kh«ng thÓ söa. B¹n cã muèn xem kh«ng?'
			Set @EngMessage ='This File  is used. You can not  edit  one. You want to see !'
			Goto EndMess
	End 	

	
END

-----Kiem tra xoa Nhat ky dich vu
If @TableName =  'CT4002'  and @IsEdit = 0
BEGIN
	If exists (Select top 1 1 From CT5002  Where  VoucherNo = @WMFileID AND DivisionID = @DivisionID)
	Begin
			Set @Status =1
			Set @VieMessage = 'NhËt ký ®· nµy cã thay thÕ thiÕt bÞ. B¹n kh«ng thÓ xãa. Vui lßng kiÓm tra l¹i!'
			Set @EngMessage ='This File  is used. You can not delete one. You must check!'
			Goto EndMess
	End 	

	
END


	



EndMess:
	Select @Status as Status, @EngMessage as EngMessage, @VieMessage as VieMessage