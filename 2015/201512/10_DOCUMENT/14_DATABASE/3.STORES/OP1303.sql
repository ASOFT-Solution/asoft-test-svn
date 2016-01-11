
/****** Object:  StoredProcedure [dbo].[OP1303]    Script Date: 08/03/2010 15:15:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


--Created by: Vo Thanh Huong, date: 15/08/2005
---purpose: Kiem tra truoc khi Luu QUAN LY SO LUONG

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP1303]  @ID nvarchar(50),
				@FromDate datetime,
				@ToDate datetime,
				@gnLang int  --0: Tieng Viut, 1: Tieng Anh		
					---tra ra cac bien @Status,	@Message 
					---0: Cho phep Luu
					---1: Khong cho phep luu và hien cau thong bao @Message
AS

DECLARE @Status int,
	@Message nvarchar(250)	


Select @Status = 0, 		@Message =''

If Exists(Select Top 1 1 From OT1303 WHERE ID<> @ID and  
		(@FromDate between FromDate and case when ToDate = '01/01/1900' then  '12/31/9999' else ToDate end  or 
		Isnull(@ToDate, '12/31/9999') between FromDate and case when ToDate = '01/01/1900' then  '12/31/9999' else ToDate end
		or (@FromDate < FromDate and isnull(@ToDate, '12/31/9999') > FromDate)))
BEGIN
	Select @Status = 1, @Message = case when @gnLang = 0 then 'OFML000137'
		 else  'OFML000137' end

	GOTO 		RETURN_VALUES													
END

---- Tra ra gia tri
RETURN_VALUES:
Select @Status as Status, @Message as Message