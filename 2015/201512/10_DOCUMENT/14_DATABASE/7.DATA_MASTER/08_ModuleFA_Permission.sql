------------------------------------------------------------------------------------------------------
-- Fix Bổ sung phân quyền màn hình -- Module FA
-- ScreenID: 1-Báo cáo; 2-Danh mục; 3-Nhập liệu; 4-Khác
------------------------------------------------------------------------------------------------------
-- Store Insert dữ liệu vào Table chuẩn
------------------------------------------------------------------------------------------------------
SET NOCOUNT ON


DECLARE
@ScreenID NVARCHAR(4000),
@ScreenType TINYINT,
@ScreenName NVARCHAR(4000),
@ScreenNameE NVARCHAR(4000)
------------------------------------------------------------------------------------------------------
--FF0046: Cập nhật hệ số phân bổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'FF0046'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật hệ số phân bổ'
SET @ScreenNameE = N'Edit Coefficient'
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
--FF0047: Danh mục hệ số phân bổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'FF0047'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục hệ số phân bổ'
SET @ScreenNameE = N'List of Coefficient'
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Coefficient'
------------------------------------------------------------------------------------------------------
--FF0048: Định nghĩa tham số
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'FF0048'
SET @ScreenType = 3
SET @ScreenName = N'Định nghĩa tham số'
SET @ScreenNameE = N'Defining parameters'
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Paramater'
------------------------------------------------------------------------------------------------------
--FF0049: Cập nhật giá trị tham số
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'FF0049'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật giá trị tham số'
SET @ScreenNameE = N'Update parameter values'
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
--FF0050: Theo dõi XDCB dở dang
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'FF0050'
SET @ScreenType = 1
SET @ScreenName = N'Theo dõi XDCB dở dang'
SET @ScreenNameE = N''
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Construct','50'
------------------------------------------------------------------------------------------------------
--FF0051: Theo dõi tình hình khấu hao TSCĐ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'FF0051'
SET @ScreenType = 1
SET @ScreenName = N'Theo dõi tình hình khấu hao TSCĐ'
SET @ScreenNameE = N''
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Depreciation_Assets','50'
------------------------------------------------------------------------------------------------------
SET NOCOUNT OFF
------------------------------------------------------------------------------------------------------