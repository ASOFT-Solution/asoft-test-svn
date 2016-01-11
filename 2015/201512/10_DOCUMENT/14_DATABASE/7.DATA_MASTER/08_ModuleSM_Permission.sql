------------------------------------------------------------------------------------------------------
-- Fix Bổ sung phân quyền màn hình -- Module SM
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
-- AS0056 - Đặt lại chỉ số tăng tự động
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AS0056'
SET @ScreenType = 3
SET @ScreenName = N'Đặt lại chỉ số tăng tự động'
SET @ScreenNameE = N'Re-setup automatically increasing coefficient'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftCS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- SF3000 - Báo cáo tổng hợp Nợ phải thu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'SF3000'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo tổng hợp Nợ phải thu'
SET @ScreenNameE = N'Report synthetic debts'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportDebitGroupReceived'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Customer_DebitGroupReceived'
------------------------------------------------------------------------------------------------------
-- SF3001 - Báo cáo bán hàng trả lại
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'SF3001'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo bán hàng trả lại'
SET @ScreenNameE = N'Inventory return report'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Sales_ReturnSale'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Customer_ReturnSale'
------------------------------------------------------------------------------------------------------
-- SF3002 - Báo cáo chi tiết công nợ phải thu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'SF3002'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo chi tiết công nợ phải thu'
SET @ScreenNameE = N'Report Detail Debit'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Customer_DetailByOrder'
------------------------------------------------------------------------------------------------------
-- SF3010 - Báo cáo toa hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'SF3010'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo toa hàng'
SET @ScreenNameE = N'Report wagons'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Customer_SaleOrder'
------------------------------------------------------------------------------------------------------
-- SF3016 - Thiết lập báo cáo đặc thù
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'SF3016'
SET @ScreenType = 3
SET @ScreenName = N'Thiết lập báo cáo đặc thù'
SET @ScreenNameE = N'Customize Report'
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportSetupCustomize'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportSetupCustomize'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportSetupCustomize'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportSetupCustomize'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportSetupCustomize'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportSetupCustomize'
------------------------------------------------------------------------------------------------------
-- OF0018 - Danh mục bảng giá bán
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0018'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục bảng giá bán'
SET @ScreenNameE = N'Price List'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_PriceControl'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_PriceControl'
------------------------------------------------------------------------------------------------------
-- OF0019 - Quản lý số lượng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0019'
SET @ScreenType = 2
SET @ScreenName = N'Quản lý số lượng'
SET @ScreenNameE = N'Manage quantity'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_QuantityControl'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_QuantityControl'
------------------------------------------------------------------------------------------------------
-- OF0020 - Cập nhật bảng giá bán
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0020'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật bảng giá bán'
SET @ScreenNameE = N'Update quotation'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0021 - Thiết lập bảng giá
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0021'
SET @ScreenType = 3
SET @ScreenName = N'Thiết lập bảng giá'
SET @ScreenNameE = N'Setup quotation'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0022 - Cập nhật định mức số lượng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0022'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật định mức số lượng'
SET @ScreenNameE = N'Update quantity rate'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0023 - Thiết lập số lượng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0023'
SET @ScreenType = 3
SET @ScreenName = N'Thiết lập số lượng'
SET @ScreenNameE = N'Setup quantity'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0116 - Bảng giá bậc thang
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0116'
SET @ScreenType = 3
SET @ScreenName = N'Bảng giá bậc thang'
SET @ScreenNameE = N'Price ladder'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0117 - Bảng giá theo cấp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0117'
SET @ScreenType = 3
SET @ScreenName = N'Bảng giá theo cấp'
SET @ScreenNameE = N'Price ledder'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0118 - Danh mục bảng giá mua
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0118'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục bảng giá mua'
SET @ScreenNameE = N'Price List'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_PurchasePriceControl'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_PurchasePriceControl'
------------------------------------------------------------------------------------------------------
-- OF0119 - Cập nhật bảng giá mua
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0119'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật bảng giá mua'
SET @ScreenNameE = N'Update quotation'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- SF2001 - Danh sách đề xuất sửa, xóa phiếu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'SF2001'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách đề xuất sửa, xóa phiếu'
SET @ScreenNameE = N'List of Reuquest to Edit/Delete voucher'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuInquiry_RequestVoucher'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuInquiry_RequestVoucher'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuInquiry_RequestVoucher'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuInquiry_RequestVoucher'
------------------------------------------------------------------------------------------------------
-- SF2002 - Đề xuất sửa / xóa phiếu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'SF2002'
SET @ScreenType = 3
SET @ScreenName = N'Đề xuất sửa / xóa phiếu'
SET @ScreenNameE = N'Suggest edit / delete voucher'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- SF2003 - Chọn đơn vị
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'SF2003'
SET @ScreenType = 4
SET @ScreenName = N'Chọn đơn vị'
SET @ScreenNameE = N'Choose division'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AS0025 - Cập nhật bảng giá
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AS0025'
SET @ScreenType = 3
SET @ScreenName = N'Phân quyền đơn vị'
SET @ScreenNameE = N'Permission Division'
EXEC AddScreen N'ASoftS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- CF0084 - Cập nhật mã phân tích
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0084'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật mã phân tích'
SET @ScreenNameE = N'Update analysis code'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AS0070 - Thiết lập phân quyền dữ liệu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AS0070'
SET @ScreenType = 4
SET @ScreenName = N'Thiết lập phân quyền dữ liệu'
SET @ScreenNameE = N'Data permission Setting'
EXEC AddScreen N'ASoftS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuPermission_DataPermissionSetting'
------------------------------------------------------------------------------------------------------
-- CF0058 - Cập nhật mặt hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0058'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật mặt hàng'
SET @ScreenNameE = N'Update inventory'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftCS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AS0051 - Cập nhật đối tượng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AS0051'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật đối tượng'
SET @ScreenNameE = N'Update object'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftCM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AFXXXX - Mở sổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AFXXXX'
SET @ScreenType = 4
SET @ScreenName = N'Mở sổ'
SET @ScreenNameE = N'Open book'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSys_OpenBook'
------------------------------------------------------------------------------------------------------
-- FFXXXX - Mở sổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'FFXXXX'
SET @ScreenType = 4
SET @ScreenName = N'Mở sổ'
SET @ScreenNameE = N'Open book'
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSys_OpenBook'
------------------------------------------------------------------------------------------------------
-- WFXXXX - Mở sổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WFXXXX'
SET @ScreenType = 4
SET @ScreenName = N'Mở sổ'
SET @ScreenNameE = N'Open book'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSys_OpenBook'
------------------------------------------------------------------------------------------------------
-- MFXXXX - Mở sổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MFXXXX'
SET @ScreenType = 4
SET @ScreenName = N'Mở sổ'
SET @ScreenNameE = N'Open book'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSys_OpenBook'
------------------------------------------------------------------------------------------------------
-- HFXXXX - Mở sổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HFXXXX'
SET @ScreenType = 4
SET @ScreenName = N'Mở sổ'
SET @ScreenNameE = N'Open book'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSys_OpenBook'
------------------------------------------------------------------------------------------------------
-- OFXXXX - Mở sổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OFXXXX'
SET @ScreenType = 4
SET @ScreenName = N'Mở sổ'
SET @ScreenNameE = N'Open book'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSys_OpenBook'
------------------------------------------------------------------------------------------------------
-- CSFXXXX - Mở sổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CSFXXXX'
SET @ScreenType = 4
SET @ScreenName = N'Mở sổ'
SET @ScreenNameE = N'Open book'
EXEC AddScreen N'ASoftCS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSys_OpenBook'
------------------------------------------------------------------------------------------------------
-- AS0072 - Phân quyền xem dữ liệu của người  khác
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AS0072'
SET @ScreenType = 2
SET @ScreenName = N'Phân quyền xem dữ liệu của người  khác'
SET @ScreenNameE = N'Data permission user other view '
EXEC AddScreen N'ASoftS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuPermission_DataPermissionUserOrherView'
------------------------------------------------------------------------------------------------------
-- AS0073 - Cập nhật phân quyền xem dữ liệu của người  khác
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AS0073'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật phân quyền xem dữ liệu của người  khác'
SET @ScreenNameE = N'Update data permission user other view '
EXEC AddScreen N'ASoftS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- CF0025 - Phân loại nhân viên
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0025'
SET @ScreenType = 2
SET @ScreenName = N'Phân loại nhân viên'
SET @ScreenNameE = N'Employee type'
EXEC AddScreen N'ASoftS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuPermission_EmployeeType'
------------------------------------------------------------------------------------------------------
-- CF0024 - Nhân viên
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0024'
SET @ScreenType = 2
SET @ScreenName = N'Nhân viên'
SET @ScreenNameE = N'Employee'
EXEC AddScreen N'ASoftS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuPermission_Employee'
------------------------------------------------------------------------------------------------------
-- CF0030 - Cập nhật loại nhân viên
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0030'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật loại nhân viên'
SET @ScreenNameE = N'Update Employee'
EXEC AddScreen N'ASoftS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AS0053 - Cập nhật nhân viên
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AS0053'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật nhân viên'
SET @ScreenNameE = N'Update Employee'
EXEC AddScreen N'ASoftS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- Sample_007 - Cập nhật kiểm định nhập thành phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_007'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật kiểm định nhập thành phẩm'
SET @ScreenNameE = N'Cập nhật kiểm định nhập thành phẩm'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnu_Busssiness_Imported_Finished_Products','-2'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Inspection_Of_Materials_Purchased','-2'
------------------------------------------------------------------------------------------------------
-- Sample_008 - Kiểm định nhập thành phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_008'
SET @ScreenType = 2
SET @ScreenName = N'Kiểm định nhập thành phẩm'
SET @ScreenNameE = N'Kiểm định nhập thành phẩm'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Inspection_Of_Imported_Finished_Products','-2'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Inspection_Of_Materials_Purchased','-2'
------------------------------------------------------------------------------------------------------
-- Sample_009 - Chi tiết kiểm định thành phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_009'
SET @ScreenType = 3
SET @ScreenName = N'Chi tiết kiểm định thành phẩm'
SET @ScreenNameE = N'Chi tiết kiểm định thành phẩm'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- SF3017 - Quản lý báo cáo
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'SF3017'
SET @ScreenType = 2
SET @ScreenName = N'Quản lý báo cáo'
SET @ScreenNameE = N'Report management'
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuOptionReportManager'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuTool_ReportManagement'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuOption_ReportManager'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuOption_Report'
EXEC AddScreen N'ASoftCM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuOption_ReportManager'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuOptionReportManager'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuOption_ReportManager'
------------------------------------------------------------------------------------------------------
-- SF3018 - Cập nhật quản lý báo cáo
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'SF3018'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật quản lý báo cáo'
SET @ScreenNameE = N'Update report'
EXEC AddScreen N'ASoftFA', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftCM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0008 - Chọn bút toán mẫu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0008'
SET @ScreenType = 4
SET @ScreenName = N'Chọn bút toán mẫu'
SET @ScreenNameE = N'Select template voucher'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0028 - Truy vấn đơn hàng sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0028'
SET @ScreenType = 2
SET @ScreenName = N'Truy vấn đơn hàng sản xuất'
SET @ScreenNameE = N'Query manufacture order'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_MOrder'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_MOrder'
------------------------------------------------------------------------------------------------------
-- OF0032 - Lập đơn hàng sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0032'
SET @ScreenType = 3
SET @ScreenName = N'Lập đơn hàng sản xuất'
SET @ScreenNameE = N'Create manufacture order'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusssiness_CreateMO'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusssiness_CreateMO'
------------------------------------------------------------------------------------------------------
-- OF0033 - Kế thừa đơn hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0033'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa đơn hàng'
SET @ScreenNameE = N'Inherit Order'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0035 - Duyệt đơn hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0035'
SET @ScreenType = 3
SET @ScreenName = N'Duyệt đơn hàng'
SET @ScreenNameE = N'Accept order'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0092 - Chi tiết đơn hàng sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0092'
SET @ScreenType = 1
SET @ScreenName = N'Chi tiết đơn hàng sản xuất'
SET @ScreenNameE = N'Detail of manufacture Order'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_MODetail'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_MODetail','36'
------------------------------------------------------------------------------------------------------
-- OF0113 - Cập nhật giá trị tham số
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0113'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật giá trị tham số'
SET @ScreenNameE = N'Adjust parameter value'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- CF0132 - Cập nhật quy cách hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0132'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật quy cách hàng'
SET @ScreenNameE = N'Update standard inventory'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- CF0133 - Thiết lập bảng giá theo quy cách
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0133'
SET @ScreenType = 4
SET @ScreenName = N'Thiết lập bảng giá theo quy cách'
SET @ScreenNameE = N'Setting price for standard'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- CF0140 - Kế thừa mã phụ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'CF0140'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa mã phụ'
SET @ScreenNameE = N'Inherit extraID'
EXEC AddScreen N'ASoftCI', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- MF0133 - Dự trù thời gian sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0133'
SET @ScreenType = 4
SET @ScreenName = N'Dự trù thời gian sản xuất'
SET @ScreenNameE = N'Dự trù thời gian sản xuất'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0044 - Kế thừa chào giá
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0044'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa chào giá'
SET @ScreenNameE = N'Kế thừa chào giá'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AS0075 - Thiết lập phân quyền chức năng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AS0075'
SET @ScreenType = 4
SET @ScreenName = N'Thiết lập phân quyền chức năng'
SET @ScreenNameE = N'Thiết lập phân quyền chức năng'
EXEC AddScreen N'ASoftS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuPermission_Functions'
------------------------------------------------------------------------------------------------------
-- MF0139 - Kế thừa bộ định mức theo quy cách
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0139'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa bộ định mức theo quy cách'
SET @ScreenNameE = N'Kế thừa bộ định mức theo quy cách'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'',54
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'',54
------------------------------------------------------------------------------------------------------
-- OF0048 - Kế thừa đơn hàng sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0048'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa đơn hàng sản xuất'
SET @ScreenNameE = N'Kế thừa đơn hàng sản xuất'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'',54
------------------------------------------------------------------------------------------------------
-- OF0046 - Kết quả dự trù chi phí sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0046'
SET @ScreenType = 3
SET @ScreenName = N'Kết quả dự trù chi phí sản xuất'
SET @ScreenNameE = N'Kết quả dự trù chi phí sản xuất'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0047 - Duyệt dự trù chi phí sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0047'
SET @ScreenType = 3
SET @ScreenName = N'Duyệt dự trù chi phí sản xuất'
SET @ScreenNameE = N'Duyệt dự trù chi phí sản xuất'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0115 - Chi tiết nguyên vật liệu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0115'
SET @ScreenType = 2
SET @ScreenName = N'Chi tiết nguyên vật liệu'
SET @ScreenNameE = N'Chi tiết nguyên vật liệu'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-------------------------------------------------------------------------------------------------------
SET NOCOUNT OFF
------------------------------------------------------------------------------------------------------