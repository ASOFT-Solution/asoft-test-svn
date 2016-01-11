------------------------------------------------------------------------------------------------------
-- Fix Bổ sung phân quyền màn hình -- Module DM
-- ScreenID: 1-Báo cáo; 2-Danh mục; 3-Nhập liệu; 4-Khác
------------------------------------------------------------------------------------------------------
-- Store Insert dữ liệu vào Table chuẩn
------------------------------------------------------------------------------------------------------
SET NOCOUNT ON
GO
DECLARE
@ScreenID NVARCHAR(4000),
@ScreenType TINYINT,
@ScreenName NVARCHAR(4000),
@ScreenNameE NVARCHAR(4000)
------------------------------------------------------------------------------------------------------
-- DMF5555 - Xuất dữ liệu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'DMF5555'
SET @ScreenType = 4
SET @ScreenName = N'Xuất dữ liệu '
SET @ScreenNameE = N'Xuất dữ liệu'
EXEC AddScreen N'ASoftDM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'cmnuItemExport'
------------------------------------------------------------------------------------------------------
-- DMF6666 - Nhập dữ liệu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'DMF6666'
SET @ScreenType = 4
SET @ScreenName = N'Nhập dữ liệu '
SET @ScreenNameE = N'Nhập dữ liệu'
EXEC AddScreen N'ASoftDM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'cmnuItemImport'
------------------------------------------------------------------------------------------------------
-- DMF7776 - Cập nhập dữ liệu dữ liệu 
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'DMF7776'
SET @ScreenType = 4
SET @ScreenName = N'Cập nhập dữ liệu dữ liệu '
SET @ScreenNameE = N'Cập nhập dữ liệu dữ liệu '
EXEC AddScreen N'ASoftDM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'cmnuItemUpdateData'
------------------------------------------------------------------------------------------------------
-- DMF0009 - Backup dữ liệu 
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'DMF0009'
SET @ScreenType = 4
SET @ScreenName = N'Backup dữ liệu  '
SET @ScreenNameE = N'Backup dữ liệu '
EXEC AddScreen N'ASoftDM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'cmnuItemBackup'
------------------------------------------------------------------------------------------------------
-- DMF0002 - Chuyển dữ liệu 
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'DMF0002'
SET @ScreenType = 4
SET @ScreenName = N'Chuyển dữ liệu  '
SET @ScreenNameE = N'Chuyển dữ liệu '
EXEC AddScreen N'ASoftDM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'cmnuItemDataTransfer'
------------------------------------------------------------------------------------------------------
-- DMF7777 - Nghiệp vụ phát sinh 
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'DMF7777'
SET @ScreenType = 4
SET @ScreenName = N'Nghiệp vụ phát sinh  '
SET @ScreenNameE = N'Nghiệp vụ phát sinh '
EXEC AddScreen N'ASoftDM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- DMF7778 - Xem dữ liệu trước khi chuyển 
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'DMF7778'
SET @ScreenType = 4
SET @ScreenName = N'Xem dữ liệu trước khi chuyển '
SET @ScreenNameE = N'Xem dữ liệu trước khi chuyển '
EXEC AddScreen N'ASoftDM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- DMF0003 - Chọn chuyển dữ liệu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'DMF0003'
SET @ScreenType = 4
SET @ScreenName = N'Chọn chuyển dữ liệu '
SET @ScreenNameE = N'Chọn chuyển dữ liệu '
EXEC AddScreen N'ASoftDM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- DMF0005 - Cập nhật mã số tăng tự động
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'DMF0005'
SET @ScreenType = 4
SET @ScreenName = N'Cập nhật mã số tăng tự động '
SET @ScreenNameE = N'Cập nhật mã số tăng tự động '
EXEC AddScreen N'ASoftDM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'cmnuSetAutoId'
------------------------------------------------------------------------------------------------------
-- DMF0004 - Nhập thông tin chung
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'DMF0004'
SET @ScreenType = 4
SET @ScreenName = N'Nhập thông tin chung'
SET @ScreenNameE = N'Nhập thông tin chung'
EXEC AddScreen N'ASoftDM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'cmnuNhapKhau'
------------------------------------------------------------------------------------------------------


SET NOCOUNT OFF
------------------------------------------------------------------------------------------------------