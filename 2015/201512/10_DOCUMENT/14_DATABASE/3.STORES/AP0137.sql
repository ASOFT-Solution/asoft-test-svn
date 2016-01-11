IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0137]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0137]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra ràng buộc dữ liệu cho phép Sửa/Xóa - ASOFT-CI
-- <History>
---- Create on 25/05/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
-- AP0137 @DivisionID = 'VG', @KeyID = '101', @TableID = 'AT0134', @IsEdit = 0

CREATE PROCEDURE [dbo].[AP0137] 	
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
----------- Kiểm tra xóa/ sửa phiếu pha trộn
If @IsEdit = 0
BEGIN
IF @TableID = 'AT0134' -- Danh mục biểu thuế tài nguyên
BEGIN
	--- Đã được sử dụng trong danh mục mặt hàng hay chưa? - AT1302
	IF EXISTS (SELECT TOP 1 1 FROM AT1302 WHERE DivisionID = @DivisionID AND NRTClassifyID = @KeyID )
	BEGIN
			SET @Status = 1
			SET @Message ='CFML000064'
			GOTO EndMess
	END 	
	--- Đã được sử dụng trong AT9000 hay chưa?
	IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE DivisionID = @DivisionID AND NRTClassifyID = @KeyID )
	BEGIN
			SET @Status = 1
			SET @Message ='CFML000064'
			GOTO EndMess
	END 
END
IF @TableID = 'AT0136' -- Danh mục biểu thuế tiêu thụ đặc biệt
BEGIN
	--- Đã được sử dụng trong danh mục mặt hàng hay chưa? - AT1302
	IF EXISTS (SELECT TOP 1 1 FROM AT1302 WHERE DivisionID = @DivisionID AND SETID = @KeyID )
	BEGIN
			SET @Status = 1
			SET @Message ='CFML000064'
			GOTO EndMess
	END 	
	--- Đã được sử dụng trong AT9000 hay chưa?
	IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE DivisionID = @DivisionID AND SETID = @KeyID )
	BEGIN
			SET @Status = 1
			SET @Message ='CFML000064'
			GOTO EndMess
	END 
END
END
-------------------------------------------------------------------

EndMess:
	Select @Status as Status, @Message as Message

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

