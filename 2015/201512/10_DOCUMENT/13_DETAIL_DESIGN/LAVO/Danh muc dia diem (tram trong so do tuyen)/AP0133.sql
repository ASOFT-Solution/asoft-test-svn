IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0133]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0133]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra ràng buộc dữ liệu cho phép Sửa/Xóa [Customize LAVO]
-- <History>
---- Create on 03/12/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
-- AP0133 @DivisionID = 'CTY', @KeyID = '03', @TableID = 'AT0133', @IsEdit = 0

CREATE PROCEDURE [dbo].[AP0133] 	
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
	IF @TableID = 'AT0133' -- Danh mục địa điểm
	BEGIN

		-- Đã được sử dụng trong sơ đồ tuyến hay chưa? - CF0135-6
		IF EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND StationID = @KeyID )
		BEGIN
				SET @Status = 1
				SET @Message = 'CFML000064'
				GOTO EndMess
		END 
		-- Đã sử dụng trong Thông tin giao hàng - Đối tượng hay chưa? - AT0047
		IF EXISTS (SELECT TOP 1 1 FROM AT0047 WHERE DivisionID = @DivisionID AND StationID = @KeyID )
		BEGIN
			SET @Status = 1
			SET @Message = 'CFML000064'
			GOTO EndMess
		END 
		-- Đã sử dụng trong Đơn hàng bán hay chưa? - 
		--IF EXISTS (SELECT TOP 1 1 FROM OT2001 WHERE DivisionID = @DivisionID AND OrderType = 0 AND StationID = @KeyID )
		--BEGIN
		--	SET @Status = 1
		--	SET @Message ='CFML000064'
		--	GOTO EndMess
		--END 
		--If @IsEdit = 1
	END

	IF @TableID = 'AT0135' -- Danh mục sơ đồ tuyến
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
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

