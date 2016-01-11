IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0295]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0295]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- LOAD DANH MỤC TỜ KHAI THUẾ BẢO VỆ MÔI TRƯỜNG -- Kiểm tra trước khi xoá
-- <History>
---- Create on 03/04/2015 by Lê Thị Hạnh 
-- <Example>
/*
AP0295 @DivisionID = 'AG', @KeyID = '', @TableID = 'AT0296', @IsEdit = 1,@UserID = ''
*/

CREATE PROCEDURE [dbo].[AP0295] 	
	@DivisionID NVARCHAR(50),
	@KeyID NVARCHAR(50),
	@TableID NVARCHAR(50),
	@IsEdit TINYINT,  ----  =0  la Xoa,  = 1 la Sua
	@UserID NVARCHAR(50)
AS
Declare @Status as tinyint,
	    @Message as nvarchar(250)
--@Status = 1: Khong cho xoa, sua
--@Status = 2: co canh bao nhung  cho xoa cho sua
--@Status = 3: Cho sua mot phan thoi
Select @Status =0, 	@Message =''
----------- Kiểm tra xóa/ sửa Tờ khai thuế bảo vệ môi trường	    
--If @IsEdit = 0
--IF @TableID = 'AT0296' -- công thức pha trộn: kiểm tra sửa và xoá
--BEGIN
--	IF EXISTS (SELECT TOP 1 1 FROM AT0296 WHERE DivisionID = @DivisionID AND VoucherID = @KeyID )
--	BEGIN
--			SET @Status = 1
--			SET @Message ='MFML000271'
--			GOTO EndMess
--	END 	
--END
-------------------------------------------------------------------

EndMess:
	Select @Status as Status, @Message as Message
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
