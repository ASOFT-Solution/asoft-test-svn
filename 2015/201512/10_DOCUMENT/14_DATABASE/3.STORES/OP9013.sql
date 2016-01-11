IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP9013]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP9013]
GO
/****** Object:  StoredProcedure [dbo].[OP9013]    Script Date: 08/04/2010 13:41:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----- Created by:Nguyen Thuy Tuyen , date:23/04/2009
---- Purpose: Kiem tra rang buoc du lieu cho phep  Xoa
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[OP9013] @DivisionID nvarchar(50),
				@TemplateVoucherID nvarchar(50)
				
AS

Declare @Status as tinyint, --- 1: Khong cho xoa, sua:    2--- co canh bao nhung  cho xoa cho sua; --3: Cho sua mot phan thoi
	@EngMessage as nvarchar(250),
	@VieMessage as nvarchar(250)

Select @Status =0, 	@EngMessage ='',	 @VieMessage=''


	If exists (select top 1 1 from ET2002 Inner join OT2002 on ET2002.TemplateTransactionID = OT2002.QuotationID Where TemplateVoucherID  = @TemplateVoucherID )
	Begin
			Set @Status =1
			Set @VieMessage =N' PhiÕu mÉu nµy ®· ®­îc t¹o Debit. B¹n kh«ng ®­îc phÐp xo¸. '
			Set @EngMessage =N'This template is used. You can not delete one. You must check!'
			Goto EndMess
	End 	

	





EndMess:
	Select @Status as Status, @EngMessage as EngMessage, @VieMessage as VieMessage
GO
