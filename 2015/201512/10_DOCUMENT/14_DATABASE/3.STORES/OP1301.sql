
/****** Object:  StoredProcedure [dbo].[OP1301]    Script Date: 08/03/2010 15:11:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


--Created by: Vo Thanh Huong, date: 15/08/2005
---purpose: Kiem tra truoc khi Luu BANG GIA


/********************************************
'* Edited by: [GS] [Thanh Trẫm] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP1301]  @ID nvarchar(50),
				@FromDate datetime,
				@ToDate datetime,
				@OID nvarchar(50),
				@gnLang int  --0: Ti?ng Vi?t, 1: Ti?ng Anh		
					---tr? ra các bi?n @Status,	@Message 
					---0: Cho phép Luu
					---1: Không cho phép luu và hi?n câu thông báo @Message
AS

DECLARE @Status int,
	@Message nvarchar(250)	,
	@ID0 nvarchar(50)

Select @Status = 0, 		@Message ='', @ID0 = ''

If Exists(Select Top 1 1 From OT1301 WHERE @OID<> @OID and  
		(@FromDate between FromDate and case when ToDate = '01/01/1900' then  '12/31/9999' else ToDate end  or 
		Isnull(@ToDate, '12/31/9999') between FromDate and case when ToDate = '01/01/1900' then  '12/31/9999' else ToDate end
		or (@FromDate < FromDate and  isnull(@ToDate, '12/31/9999') > FromDate)))
BEGIN
	Set @ID0 = (Select Top 1 1 From OT1301 WHERE @OID<> @OID and  
			(@FromDate between FromDate and case when ToDate = '01/01/1900' then  '12/31/9999' else ToDate end  or 
			Isnull(@ToDate, '12/31/9999') between FromDate and  case when ToDate = '01/01/1900' then  '12/31/9999' else ToDate end))
	Select @Status = 1, @Message = case when @gnLang = 0 then 'B¶ng gi¸ nµy kh«ng hîp lÖ, v× §· cã b¶ng gi¸ ' + @ID0 + '. B¹n h·y kiÓm tra l¹i'
		 else  'It is invalid, ready exists ' + @ID0 + '. Please check again' end
	GOTO 		RETURN_VALUES													
END


---- Tra ra gia tri
RETURN_VALUES:
Select @Status as Status, @Message as Message