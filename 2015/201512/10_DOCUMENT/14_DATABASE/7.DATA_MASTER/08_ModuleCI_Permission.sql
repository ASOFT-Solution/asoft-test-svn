------------------------------------------------------------------------------------------------------
-- Fix Bổ sung phân quyền màn hình -- Module CI
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
-- CF0048 : Hiệu chỉnh danh mục đối tượng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0097'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật thông tin hợp đồng'
SET @ScreenNameE = N'Update contract infomation'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- CF0069 : Khai báo thông số
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0069'
SET @ScreenType = 2
SET @ScreenName = N'Khai báo thông số'
SET @ScreenNameE = N'Khai báo thông số'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_ConvertUnit_Formula'
------------------------------------------------------------------------------------------------------
-- CF0098 : Cập nhật tình trạng hợp đồng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0098'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật tình trạng hợp đồng'
SET @ScreenNameE = N'Update contract status'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- CF0100 - Cấp nhân viên
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0100'
SET @ScreenType = 2
SET @ScreenName = N'Cấp nhân viên'
SET @ScreenNameE = N'Level Employee'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Other_EmployeeID_LevelNo','0020'
------------------------------------------------------------------------------------------------------
-- CF0101 - Cập nhật cấp nhân viên
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0101'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật cấp nhân viên'
SET @ScreenNameE = N'Update Level Employee'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0102 - Tra cứu sơ đồ quân hệ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0102'
SET @ScreenType = 2
SET @ScreenName = N'Tra cứu sơ đồ quân hệ'
SET @ScreenNameE = N'Lookup Diagram'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_ObjectInfor_Lookup_Diagram','0020'
-----------------------------------------------------------------------------------------------------
-- CF0105 - Thiết lập chi tiết phương thức thanh toán
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0105'
SET @ScreenType = 3
SET @ScreenName = N'Thiết lập chi tiết phương thức thanh toán'
SET @ScreenNameE = N'Thiết lập chi tiết phương thức thanh toán'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0106 - Chọn đơn hàng bán
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0106'
SET @ScreenType = 4
SET @ScreenName = N'Chọn đơn hàng bán'
SET @ScreenNameE = N'Choose Contract Sales'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0112 - Danh mục dân tộc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0112'
SET @ScreenType = 2
SET @ScreenName = N'Dân tộc'
SET @ScreenNameE = N'Ethnicity'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- Sample_001 - Danh mục các chỉ tiêu kiểm định
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_001'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục các chỉ tiêu kiểm định'
SET @ScreenNameE = N'Danh mục các chỉ tiêu kiểm định'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Criteria_Testing','-2'
-----------------------------------------------------------------------------------------------------
-- Sample_002 - Cập nhật các chỉ tiêu kiểm định
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_002'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật các chỉ tiêu kiểm định'
SET @ScreenNameE = N'Cập nhật các chỉ tiêu kiểm định'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- Sample_003 - Chỉ tiêu kiểm định theo mặt hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_003'
SET @ScreenType = 2
SET @ScreenName = N'Chỉ tiêu kiểm định theo mặt hàng'
SET @ScreenNameE = N'Chỉ tiêu kiểm định theo mặt hàng'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Products_Targets_Tested','-2'
-----------------------------------------------------------------------------------------------------
-- Sample_004 - Chỉ tiêu kiểm định theo mặt hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_004'
SET @ScreenType = 3
SET @ScreenName = N'Chỉ tiêu kiểm định theo mặt hàng'
SET @ScreenNameE = N'Chỉ tiêu kiểm định theo mặt hàng'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0112 - Danh mục dân tộc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0112'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục dân tộc'
SET @ScreenNameE = N'List Ethnic'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Society_Ethnic_CI'
-----------------------------------------------------------------------------------------------------
-- CF0113 - cập nhật dân tộc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0113'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật dân tộc'
SET @ScreenNameE = N'Update Ethnic'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0114 - Danh mục tôn giáo
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0114'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục tôn giáo'
SET @ScreenNameE = N'List Religion'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Society_Religion'
-----------------------------------------------------------------------------------------------------
-- CF0115 - cập nhật tôn giáo
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0115'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật tôn giáo'
SET @ScreenNameE = N'Update Religion'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0116 - Danh mục Đoàn thể - Hiệp hội
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0116'
SET @ScreenType = 2
SET @ScreenName = N'Đoàn thể - Hiệp hội'
SET @ScreenNameE = N'List Religion'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Society_Association'
-----------------------------------------------------------------------------------------------------
-- CF0117 - cập nhật Đoàn thể - Hiệp hội
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0117'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật tôn giáo'
SET @ScreenNameE = N'Update Religion'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0118 - Danh mục Tổ nhóm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0118'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục Tổ nhóm'
SET @ScreenNameE = N'List Team'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Organization_Team'
-----------------------------------------------------------------------------------------------------
-- CF0119 - cập nhật Tổ nhóm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0119'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật Tổ nhóm'
SET @ScreenNameE = N'Update Team'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0120 - Danh mục chức vụ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0120'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục chức vụ'
SET @ScreenNameE = N'List Duty'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Organization_Duty'
-----------------------------------------------------------------------------------------------------
-- CF0121 - Cập nhật chức vụ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0121'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chức vụ'
SET @ScreenNameE = N'Update Duty'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0111 - Thiết lập
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0111'
SET @ScreenType = 3
SET @ScreenName = N'Thiết lập'
SET @ScreenNameE = N'Config'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_AnaID'
-----------------------------------------------------------------------------------------------------
-- CF0109 - Danh mục mã phân tích đơn hàng mua
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0109'
SET @ScreenType = 2
SET @ScreenName = N'Mã phân tích đơn hàng mua'
SET @ScreenNameE = N'Ana Order Purchase '
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_AnaOrderPO'
-----------------------------------------------------------------------------------------------------
-- CF0110 - Cập nhật mã phân tích đơn hàng mua
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0110'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật mã phân tích đơn hàng mua'
SET @ScreenNameE = N'Update Ana Order Purchase '
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0107 - Danh mục mã phân tích đơn hàng bán
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0107'
SET @ScreenType = 3
SET @ScreenName = N'Mã phân tích đơn hàng bán'
SET @ScreenNameE = N'Ana Order Sale'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_AnaOrderSO'
-----------------------------------------------------------------------------------------------------
-- CF0108 -  Cập nhật mã phân tích đơn hàng bán
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0108'
SET @ScreenType = 3
SET @ScreenName = N'Mã phân tích đơn hàng bán'
SET @ScreenNameE = N'Ana Order Sale'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0122 -  Mã tự động đối tượng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0122'
SET @ScreenType = 4
SET @ScreenName = N'Mã tự động đối tượng'
SET @ScreenNameE = N'Auto Object'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSys_Auto_Object'
-----------------------------------------------------------------------------------------------------
-- CF0123 -  Mã tự động mặt hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0123'
SET @ScreenType = 4
SET @ScreenName = N'Mã tự động mặt hàng'
SET @ScreenNameE = N'Auto Inventory'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSys_Auto_Inventory'
-----------------------------------------------------------------------------------------------------
-- CF0124 -  Mã tự động mặt hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0124'
SET @ScreenType = 2
SET @ScreenName = N'Khuyến mãi theo hóa đơn'
SET @ScreenNameE = N'Promoted by Invoice'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Promotion'
-----------------------------------------------------------------------------------------------------
-- CF0125 -  Cập nhật khuyễn mãi theo hóa đơn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0125'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật khuyễn mãi theo hóa đơn'
SET @ScreenNameE = N'Update promotion by invoice'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Promotion'
-----------------------------------------------------------------------------------------------------
-- CF0126 -  Danh mục công đoạn sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0126'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục công đoạn sản xuất'
SET @ScreenNameE = N'List phase producing'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Phase_Producing','47'
-----------------------------------------------------------------------------------------------------
-- CF0127 -  Cập nhật công đoạn sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0127'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật công đoạn sản xuất'
SET @ScreenNameE = N'Update phase producing'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'','47'
-----------------------------------------------------------------------------------------------------
-- CF0129 -  Thuế bảo vệ môi trường
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0129'
SET @ScreenType = 2
SET @ScreenName = N'Thuế bảo vệ môi trường'
SET @ScreenNameE = N'Tax environment'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Tax_Environment'
-----------------------------------------------------------------------------------------------------
-- CF0130 -  Cập nhật văn bản về thuế bảo vệ môi trường
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0130'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật văn bản về thuế bảo vệ môi trường'
SET @ScreenNameE = N'Update tax environment'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0131 -  Danh mục quy cách hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0131'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục quy cách hàng'
SET @ScreenNameE = N'List Standard inventory'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Standard_Invetory'
-----------------------------------------------------------------------------------------------------
-- CF0134 -  Danh mục bieu thue tai nguyen
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0134'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục biểu thuế tài nguyên'
SET @ScreenNameE = N'Danh mục biểu thuế tài nguyên'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Tax_NRT'
-----------------------------------------------------------------------------------------------------
-- CF0135 -  Cập nhật bieu thue tai nguyen
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0135'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật biểu thuế tài nguyên'
SET @ScreenNameE = N'Cập nhật biểu thuế tài nguyên'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0136 - Danh mục bieu thue tai nguyen
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0136'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục biểu thuế tiêu thụ đặc biệt'
SET @ScreenNameE = N'Danh mục biểu thuế tiêu thụ đặc biệt'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Tax_SET'
-----------------------------------------------------------------------------------------------------
-- CF0137 -  Cập nhật bieu thue tiêu thụ đặc biệt
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0137'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật biểu thuế tiêu thụ đặc biệt'
SET @ScreenNameE = N'Cập nhật biểu thuế tiêu thụ đặc biệt'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0138 -  Danh mục quy cách
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0138'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục quy cách'
SET @ScreenNameE = N'List extraID'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_ExtraID','43'
-----------------------------------------------------------------------------------------------------
-- CF0139 -  Cập nhật quy cách
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0139'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật quy cách'
SET @ScreenNameE = N'Update extraID'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- CF0140 -  Thiết lập quy cách hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0140'
SET @ScreenType = 4
SET @ScreenName = N'Thiết lập quy cách hàng'
SET @ScreenNameE = N'Thiết lập quy cách hàng'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Standard_Config'
-----------------------------------------------------------------------------------------------------
-- CF0145 -  Danh mục lỗi máy
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0145'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục lỗi máy'
SET @ScreenNameE = N'Danh mục lỗi máy'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_MacError', 57
-----------------------------------------------------------------------------------------------------
-- CF0146 -  Cập nhật lỗi máy
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0146'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật lỗi máy'
SET @ScreenNameE = N'Cập nhật lỗi máy'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'', 57
-----------------------------------------------------------------------------------------------------
-- CF0147 -  Danh mục lỗi sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0147'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục lỗi sản phẩm'
SET @ScreenNameE = N'Danh mục lỗi sản phẩm'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_ProError', 57
-----------------------------------------------------------------------------------------------------
-- CF0148 -  Cập nhật lỗi sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0148'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật lỗi sản phẩm'
SET @ScreenNameE = N'Cập nhật lỗi sản phẩm'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'', 57
-----------------------------------------------------------------------------------------------------
-- CF0149 -  Danh mục thông số máy
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0149'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục thông số máy'
SET @ScreenNameE = N'Danh mục thông số máy'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_MachineID', 57
-----------------------------------------------------------------------------------------------------
-- CF0150 -  Cập nhật thông số máy
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0150'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật thông số máy'
SET @ScreenNameE = N'Cập nhật thông số máy'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'', 57
-----------------------------------------------------------------------------------------------------
-- CF0151 -  Danh mục khuôn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0151'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục khuôn'
SET @ScreenNameE = N'Danh mục khuôn'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_BlockID', 57
-----------------------------------------------------------------------------------------------------
-- CF0152 -  Cập nhật khuôn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0152'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật khuôn'
SET @ScreenNameE = N'Cập nhật khuôn'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'', 57
-----------------------------------------------------------------------------------------------------
SET NOCOUNT OFF
------------------------------------------------------------------------------------------------------