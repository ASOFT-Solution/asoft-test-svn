USE [HoangTran]
GO

/****** Object:  StoredProcedure [dbo].[CP0141]    Script Date: 13/01/2016 8:59:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- <Summary>
---- Kiểm tra ràng buộc dữ liệu cho phép Sửa/Xóa 
-- <History>
---- Create on 12/01/2016 --- Thị Phượng 
---- Modified on ... by 
-- <Example>
-- CP0141 @DivisionID = 'AS', @KeyID = 'TUYEN01', @TableID = 'CT0141', @IsEdit = 0

CREATE PROCEDURE [dbo].[CP0141] 	
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
	IF @TableID = 'CT0141' -- Danh mục địa điểm
	BEGIN

		-- Đã được sử dụng trong sơ đồ tuyến hay chưa? - CF0143
		IF EXISTS (SELECT TOP 1 1 FROM CT0144 WHERE DivisionID = @DivisionID AND StationID = @KeyID )
		BEGIN
				SET @Status = 1
				SET @Message = 'CFML000064'
				GOTO EndMess
		END 
		-- Đã sử dụng trong Thông tin giao hàng - Đối tượng hay chưa? - AT0047
		--IF EXISTS (SELECT TOP 1 1 FROM AT0047 WHERE DivisionID = @DivisionID AND StationID = @KeyID )
		--BEGIN
		--	SET @Status = 1
		--	SET @Message = 'CFML000064'
		--	GOTO EndMess
		--END 
		-- Đã sử dụng trong Đơn hàng bán hay chưa? - 
		--IF EXISTS (SELECT TOP 1 1 FROM OT2001 WHERE DivisionID = @DivisionID AND OrderType = 0 AND StationID = @KeyID )
		--BEGIN
		--	SET @Status = 1
		--	SET @Message ='CFML000064'
		--	GOTO EndMess
		--END 
		--If @IsEdit = 1
	END

	IF @TableID = 'CT0143' -- Danh mục sơ đồ tuyến
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM OT2001 WHERE DivisionID = @DivisionID AND RouteID = @KeyID )
		BEGIN
			SET @Status = 1
			SET @Message = 'CFML000064'
			GOTO EndMess
		END 
	END 
END 
--If @IsEdit = 1 
-------------------------------------------------------------------

EndMess:
	Select @Status as Status, @Message as Message


GO


