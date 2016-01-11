IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0105]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0105]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiểm tra ràng buộc dữ liệu cho phép Sửa/Xóa [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 12/09/2014 by Lê Thị Hạnh 
---- Modified on 12/01/2015 by Lê Thị Hạnh: Bổ sung kiểm tra MF0117 và sửa điều kiện MF0113
---- Modified on ... by 
-- <Example>
-- MP0105 @DivisionID = 'VG', @KeyID = 'SPP20150112', @TableID = 'MT0117', @IsEdit = 1

CREATE PROCEDURE [dbo].[MP0105] 	
	@DivisionID NVARCHAR(50),
	@KeyID NVARCHAR(50),
	@TableID NVARCHAR(50),
	@IsEdit TINYINT  ----  =0  la Xoa,  = 1 la Sua

AS

DECLARE @Status TINYINT,
		@Message NVARCHAR(250),
		@ScreenID NVARCHAR(50),
		@VoucherNo NVARCHAR(1000)
--@Status = 1: Khong cho xoa, sua
--@Status = 2: co canh bao nhung  cho xoa cho sua
--@Status = 3: Cho sua mot phan thoi
Select @Status =0, 	@Message ='', @ScreenID = '', @VoucherNo = ''
----------- Kiểm tra xóa/ sửa phiếu pha trộn
--If @IsEdit = 0
IF @TableID = 'MT0105' -- công thức pha trộn: kiểm tra sửa và xoá
BEGIN
	--- Đã được sử dụng trong phiếu pha trộn hay chưa? - MT0109
	IF EXISTS (SELECT TOP 1 1 FROM MT0107 WHERE DivisionID = @DivisionID AND FormulaID = @KeyID )
	BEGIN
			SET @Status = 1
			SET @Message ='MFML000271'
			SET @ScreenID = N'MF0107'
			SET @VoucherNo = 
				(SELECT STUFF((SELECT N', ' + VoucherNo
								FROM MT0107 
								WHERE DivisionID = @DivisionID AND FormulaID = @KeyID
								FOR XML PATH('')),1,2,N''))
			GOTO EndMess
	END 	
END
--If @IsEdit = 1
IF @TableID = 'MT0107' -- phiếu pha trộn: kiểm tra sửa và xoá
BEGIN
	---- Kiểm tra phiếu pha trộn đã được sử dụng trong phiếu kiểm định sản phẩm - MT0111-12
	IF EXISTS (SELECT TOP 1 1 FROM MT0111 WHERE DivisionID = @DivisionID AND MixVoucherID = @KeyID)
	BEGIN
			SET @Status = 1
			SET @Message = 'MFML000271'
			SET @ScreenID = N'MF0111'
			SET @VoucherNo = 
				(SELECT STUFF((SELECT N', ' + VoucherNo
								FROM MT0111 
								WHERE DivisionID = @DivisionID AND MixVoucherID = @KeyID
								FOR XML PATH('')),1,2,N''))
			GOTO EndMess
	END 
	--- Kiểm tra đã sử dụng trong lệnh sản xuất hay chưa? - MT2001
	IF EXISTS (SELECT TOP 1 1 FROM MT2001 WHERE DivisionID = @DivisionID AND MixVoucherID = @KeyID )
	BEGIN
			SET @Status = 1
			SET @Message = 'MFML000271'
			SET @ScreenID = N'MF0062'
			SET @VoucherNo = 
				(SELECT STUFF((SELECT N', ' + VoucherNo
								FROM MT2001 
								WHERE DivisionID = @DivisionID AND MixVoucherID = @KeyID
								FOR XML PATH('')),1,2,N''))
			GOTO EndMess
	END 
	-- Đã sử dụng trong bảng giá hay chưa? - MT0113-14
	IF EXISTS (SELECT TOP 1 1 FROM MT0113 WHERE DivisionID = @DivisionID AND MixVoucherID = @KeyID )
	BEGIN
			SET @Status = 1
			SET @Message ='MFML000271'
			SET @ScreenID = N'MF0113'
			SET @VoucherNo = 
				(SELECT STUFF((SELECT N', ' + ID
								FROM MT0113
								WHERE DivisionID = @DivisionID AND MixVoucherID = @KeyID
								FOR XML PATH('')),1,2,N''))
			GOTO EndMess
	END 
END
IF @TableID = 'MT0109' -- Chỉ tiêu kiểm định: kiểm tra sửa
BEGIN
	---- Kiểm tra chỉ tiêu kiểm định đã được sử dụng trong phiếu kiểm định sản phẩm - MT0112
	If @IsEdit = 0
	BEGIN
		IF EXISTS (SELECT TOP 1 1 FROM MT0112 WHERE DivisionID = @DivisionID AND TestID = @KeyID )
		BEGIN
				SET @Status = 1
				SET @Message ='MFML000271'
				SET @ScreenID = N'MF0111'
				SET @VoucherNo = 
					(SELECT STUFF((SELECT N', ' + MT12.VoucherNo
								   FROM 
								   (SELECT DISTINCT MT11.VoucherNo 
								    FROM MT0112 MT12
								    INNER JOIN MT0111 MT11 ON MT11.DivisionID = MT12.DivisionID AND MT11.VoucherID = MT12.VoucherID 
								    WHERE MT12.DivisionID = @DivisionID AND MT12.TestID = @KeyID) MT12
								   FOR XML PATH('')),1,2,N''))
				GOTO EndMess
		END
	END	 
	--If @IsEdit = 1
END
IF @TableID = 'MT0113' -- Khai báo công thức sản xuất sản phẩm: kiểm tra sửa và xoá
BEGIN
	---- Kiểm tra Khai báo công thức đã được sử dụng trong bảng giá vốn sản phẩm - MT0115-16
	IF EXISTS (SELECT TOP 1 1 FROM MT0115 WHERE DivisionID = @DivisionID AND PMID = @KeyID )
	BEGIN
			SET @Status = 1
			SET @Message ='MFML000271'
			SET @ScreenID = N'MF0115'
			SET @VoucherNo = 
				(SELECT STUFF((SELECT N', ' + VoucherNo
								FROM MT0115
								WHERE DivisionID = @DivisionID AND PMID = @KeyID
								FOR XML PATH('')),1,2,N''))
			GOTO EndMess
	END 
END

IF @TableID = 'MT0117' -- Bảng giá Nguyên vật liệu và bao bì: kiểm tra sửa và xoá
BEGIN
	---- Kiểm tra bảng giá đã được sử dụng trong bảng giá vốn sản phẩm - MT0115-16
	IF EXISTS (SELECT TOP 1 1 FROM MT0115 WHERE DivisionID = @DivisionID AND PriceListID = @KeyID )
	BEGIN
			SET @Status = 1
			SET @Message ='MFML000276'
			SET @ScreenID = N'MF0115'
			SET @VoucherNo = 
				(SELECT STUFF((SELECT N', ' + VoucherNo
								FROM MT0115
								WHERE DivisionID = @DivisionID AND PriceListID = @KeyID
								FOR XML PATH('')),1,2,N''))
			GOTO EndMess
	END 	
END
-------------------------------------------------------------------

EndMess:
	Select @Status as Status, @Message as MESSAGE, @ScreenID AS ScreenID, @VoucherNo AS VoucherNo

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

