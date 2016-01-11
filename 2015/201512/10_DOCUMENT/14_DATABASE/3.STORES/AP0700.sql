
/****** Object:  StoredProcedure [dbo].[AP0700]    Script Date: 07/29/2010 17:23:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Nguyen Van Nhan.
---- Date SaturDay, 31/05/2003.
---- Purpose: Kiem tra trang thai phieu co duoc phep Sua, Xoa hay khong.
---- Edit by: Dang Le Bao Quynh; Date: 16/01/2009
---- Purpose: Bo sung truong hop xuat hang mua tra lai
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/
ALTER PROCEDURE [dbo].[AP0700] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)

 AS
Declare @Status as tinyint,
	@Message as nvarchar(250)
	Set  @Status = 0



If Exists (Select top 1  1  From  AT0114 Where 	DivisionID =@DivisionID and	
					ReVoucherID =@VoucherID and
					DeQuantity<>0 )
	Begin
		Set @Status =1
		Set @Message = N' PhiÕu nhËp nµy ®· ®­îc xuÊt ®Ých danh tõ l« nhËp, b¹n kh«ng ®­îc phÐp söa hoÆc xo¸. NÕu muèn söa phiÕu nhËp nµy b¹n ph¶i xo¸ c¸c phiÕu xuÊt liªn quan.'
		Goto MESS
	End

/*
If  Exists (Select top 1  1 From AT2006 Where TableID<>N'AT2006'  and VoucherID =@VoucherID )
	Begin
		Set @Status =1
		Set @Message = N' B¹n kh«ng ®­îc phÐp Söa, Xo¸ phiÕu nµy. PhiÕu nµy ®­îc nhËp tõ ph©n hÖ kh¸c (Mua hµng, b¸n hµng,...) '
		Goto MESS
		
	End	
*/

If  Exists (Select top 1  1 From AT2006 Where KindVoucherID = 5  and VoucherID =@VoucherID and DivisionID =@DivisionID)
	Begin
		Set @Status =1
		Set @Message = N' B¹n kh«ng ®­îc phÐp Söa, Xo¸ phiÕu nµy. PhiÕu nµy ®­îc nhËp tõ ph©n hÖ kh¸c (Mua hµng). '
		Goto MESS
		
	End	

If  Exists (Select top 1  1 From AT2006 Where KindVoucherID = 4  and VoucherID =@VoucherID and DivisionID =@DivisionID)
	Begin
		Set @Status =1
		Set @Message = N' B¹n kh«ng ®­îc phÐp Söa, Xo¸ phiÕu nµy. PhiÕu nµy ®­îc nhËp tõ ph©n hÖ kh¸c (B¸n hµng). '
		Goto MESS
		
	End	

If  Exists (Select top 1  1 From AT2006 Where KindVoucherID = 7  and VoucherID =@VoucherID and DivisionID =@DivisionID)
	Begin
		Set @Status =1
		Set @Message = N' B¹n kh«ng ®­îc phÐp Söa, Xo¸ phiÕu nµy. PhiÕu nµy ®­îc nhËp tõ ph©n hÖ kh¸c (Hµng b¸n tr¶ l¹i). '
		Goto MESS
		
	End	

If  Exists (Select top 1  1 From AT2006 Where KindVoucherID = 10  and VoucherID =@VoucherID and DivisionID =@DivisionID)
	Begin
		Set @Status =1
		Set @Message = N' B¹n kh«ng ®­îc phÐp Söa, Xo¸ phiÕu nµy. PhiÕu nµy ®­îc nhËp tõ ph©n hÖ kh¸c (Hµng mua tr¶ l¹i). '
		Goto MESS
		
	End	

If Exists (Select Top 1  1  From AT9000 Where TableID=N'AT2006'  and VoucherID =@VoucherID and (Status <>0 or IsCost<>0) and DivisionID =@DivisionID)
	Begin
		Set @Status =1
		Set @Message = N'  B¹n kh«ng ®­îc phÐp Söa, Xo¸ phiÕu nµy. PhiÕu nµy ®­îc tÝnh gi¸ thµnh hoÆc gi¶i trõ c«ng nî. '
		
	End	

 MESS:
Select  @Status as Status,  @Message as Message
GO
