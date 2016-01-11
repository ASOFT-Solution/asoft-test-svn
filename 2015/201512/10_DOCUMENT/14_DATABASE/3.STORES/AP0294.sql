IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0294]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0294]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra ràng buộc dữ liệu cho phép Sửa/Xóa - Thuế bảo vệ môi trường
-- <History>
---- Create on 20/03/2015 by Lê Thị Hạnh
---- Modified on ... by 
-- <Example>
-- AP0294 @DivisionID = 'VG', @KeyID = '', @TableID = 'AT0294', @IsEdit = 0

CREATE PROCEDURE [dbo].[AP0294] 	
	@DivisionID NVARCHAR(50),
	@KeyID NVARCHAR(50),
	@TableID NVARCHAR(50),
	@IsEdit TINYINT  ----  =0  la Xoa,  = 1 la Sua

AS
Declare @Status as tinyint,
	@Message as nvarchar(250)
--@Status = 1: Khong cho xoa, sua
--@Status = 2: co canh bao nhung  cho xoa cho sua
--@Status = 3: Cho sua mot phan thoi
Select @Status =0, 	@Message =''

If @IsEdit = 0 -- Xoá
BEGIN
	IF @TableID = 'AT0294' 
	BEGIN
		--- Đã được sử dụng trong HOÁ ĐƠN BÁN HÀNG HAY CHƯA - AT9000 - T04
		--IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE DivisionID = @DivisionID AND ETaxVoucherID = @KeyID )
		--BEGIN
		--		SET @Status = 1
		--		SET @Message ='CFML000064'
		--		GOTO EndMess
		--END 
		-- Dữ liệu mặc định từ CT
			IF EXISTS (SELECT TOP 1 1 FROM AT0294 WHERE VoucherID = @KeyID AND IsDefault = 1 )
			BEGIN
					SET @Status = 1
					SET @Message ='CFML000182'
					GOTO EndMess
			END	
			-- Thiết lập tờ khai thuế BVMT
			IF EXISTS (SELECT TOP 1 1 FROM AT0304 WHERE ETaxVoucherID = @KeyID )
			BEGIN
					SET @Status = 1
					SET @Message ='CFML000183'
					GOTO EndMess
			END	
	END
	IF @TableID = N'AT0304'
	BEGIN
		-- Dữ liệu mặc định từ CT
		IF EXISTS (SELECT TOP 1 1 FROM AT0304 WHERE VoucherID = @KeyID AND IsDefault = 1 )
		BEGIN
				SET @Status = 1
				SET @Message ='AFML000388'
				GOTO EndMess
		END
	END
END
/*
If @IsEdit = 1
BEGIN
	
	IF @TableID = 'AT0294' 
	BEGIN
		--- Đã được sử dụng trong HOÁ ĐƠN BÁN HÀNG HAY CHƯA - AT9000 - T04
		IF EXISTS (SELECT TOP 1 1 FROM AT0294 WHERE VoucherID = @KeyID AND IsDefault = 1 )
		BEGIN
				SET @Status = 1
				SET @Message ='CFML000182'
				GOTO EndMess
		END	
	END
	
	IF @TableID = N'AT0304'
	BEGIN
		-- Dữ liệu mặc định từ CT
		IF EXISTS (SELECT TOP 1 1 FROM AT0304 WHERE VoucherID = @KeyID AND IsDefault = 1 )
		BEGIN
				SET @Status = 1
				SET @Message ='AFML000388'
				GOTO EndMess
		END
	END
END
*/
-------------------------------------------------------------------

EndMess:
	Select @Status as Status, @Message as Message

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
