------------------------------------------------------------------------------------------------------
-- Fix Bổ sung phân quyền màn hình -- Module POS
-- ScreenID: 1-Báo cáo; 2-Danh mục; 3-Nhập liệu; 4-Khác
------------------------------------------------------------------------------------------------------
-- Store Insert dữ liệu vào Table chuẩn
------------------------------------------------------------------------------------------------------
-- create by Thị Phượng  Date 09/08/2016
-- Thêm dữ liệu vào bảng Master

DECLARE @ModuleID AS NVARCHAR(50) = 'AsoftOO'


DECLARE
	@ScreenID VARCHAR(50),
	@ScreenName NVARCHAR(MAX),
	@ScreenNameE NVARCHAR(MAX),
	@ScreenType TINYINT

------------------------------------------------------------------------------------------------------
------------------------------------------------ Báo cáo ---------------------------------------------
------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
--- Danh mục
------------------------------------------------------------------------------------------------------
SET @ScreenType =2

SET @ScreenID = N'OOF1050'
SET @ScreenName = N'Danh mục thông báo'
SET @ScreenNameE = N''
EXEC AddScreenERP9 @ModuleID, @ScreenID,@ScreenType,@ScreenName,@ScreenNameE
----Danh mục quy trình
SET @ScreenID = N'OOF1020'
SET @ScreenName = N'Danh mục quy trình'
SET @ScreenNameE = N''
EXEC AddScreenERP9 @ModuleID, @ScreenID,@ScreenType,@ScreenName,@ScreenNameE
---- Danh mục bước
SET @ScreenID = N'OOF1030'
SET @ScreenName = N'Danh mục bước'
SET @ScreenNameE = N''
EXEC AddScreenERP9 @ModuleID, @ScreenID,@ScreenType,@ScreenName,@ScreenNameE
---- Danh mục trạng thái
SET @ScreenID = N'OOF1040'
SET @ScreenName = N'Danh mục trạng thái'
SET @ScreenNameE = N''
EXEC AddScreenERP9 @ModuleID, @ScreenID,@ScreenType,@ScreenName,@ScreenNameE


------------------------------------------------------------------------------------------------------
------------------------------------------------ Cập nhật --------------------------------------------
------------------------------------------------------------------------------------------------------
SET @ScreenType =3
SET @ScreenID = N'OOF1021'
SET @ScreenName = N'Cập nhật quy trình'
SET @ScreenNameE = N''
EXEC AddScreenERP9 @ModuleID, @ScreenID,@ScreenType,@ScreenName,@ScreenNameE
--- Cập nhật bước
SET @ScreenType =3
SET @ScreenID = N'OOF1031'
SET @ScreenName = N'Cập nhật bước'
SET @ScreenNameE = N''
EXEC AddScreenERP9 @ModuleID, @ScreenID,@ScreenType,@ScreenName,@ScreenNameE
--- Cập nhật trạng thái
SET @ScreenType =3
SET @ScreenID = N'OOF1041'
SET @ScreenName = N'Cập nhật trạng thái'
SET @ScreenNameE = N''
EXEC AddScreenERP9 @ModuleID, @ScreenID,@ScreenType,@ScreenName,@ScreenNameE


--------------- Xem chi tiết --------------------------

SET @ScreenType = 5


SET @ScreenID = N'OOF1052'
SET @ScreenName = N'Xem chi tiết thông báo'
SET @ScreenNameE = N''
EXEC AddScreenERP9 @ModuleID, @ScreenID,@ScreenType,@ScreenName,@ScreenNameE
--- Xem chi tiết quy trinh
SET @ScreenID = N'OOF1022'
SET @ScreenName = N'Xem chi tiết quy trình'
SET @ScreenNameE = N''
EXEC AddScreenERP9 @ModuleID, @ScreenID,@ScreenType,@ScreenName,@ScreenNameE
--- Xem chi tiết bước

SET @ScreenID = N'OOF1032'
SET @ScreenName = N'Xem chi tiết bước'
SET @ScreenNameE = N''
EXEC AddScreenERP9 @ModuleID, @ScreenID,@ScreenType,@ScreenName,@ScreenNameE
--- Xem chi tiết trạng thái

SET @ScreenID = N'OOF1042'
SET @ScreenName = N'Xem chi tiết trạng thái'
SET @ScreenNameE = N''
EXEC AddScreenERP9 @ModuleID, @ScreenID,@ScreenType,@ScreenName,@ScreenNameE
