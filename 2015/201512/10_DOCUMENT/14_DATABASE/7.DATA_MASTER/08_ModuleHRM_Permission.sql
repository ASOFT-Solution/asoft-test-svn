------------------------------------------------------------------------------------------------------
-- Fix Bổ sung phân quyền màn hình -- Module HRM
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
-- HF0049 - Chấm công theo công trình
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0049'
SET @ScreenType = 3
SET @ScreenName = N'Chấm công theo công trình'
SET @ScreenNameE = N'Attendance tracking information'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Absent_Project'
------------------------------------------------------------------------------------------------------
-- HF0058 - Thông tin chung
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0058'
SET @ScreenType = 3
SET @ScreenName = N'Thông tin chung'
SET @ScreenNameE = N'Common information'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0087 - Chấm công theo sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0087'
SET @ScreenType = 3
SET @ScreenName = N'Chấm công theo sản phẩm'
SET @ScreenNameE = N'Chấm công theo sản phẩm'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Absent_Product'
------------------------------------------------------------------------------------------------------
-- HF0113 - Chấm công sản phẩm theo công đoạn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0113'
SET @ScreenType = 3
SET @ScreenName = N'Chấm công sản phẩm theo công đoạn'
SET @ScreenNameE = N'Chấm công sản phẩm theo công đoạn'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Absent_StepProduct'
------------------------------------------------------------------------------------------------------
-- HF0254 : Danh mục máy chấm công
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0254'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục máy chấm công'
SET @ScreenNameE = N'Time recorder List'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_TimeRecorder'
------------------------------------------------------------------------------------------------------
-- HF0255 : Cập nhật máy chấm công
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0255'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật máy chấm công'
SET @ScreenNameE = N'Updating Time recorder'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0256 - Hệ số theo ngày
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0256'
SET @ScreenType = 3
SET @ScreenName = N'Hệ số theo ngày'
SET @ScreenNameE = N'Day coefficient'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_DayCoefficient'
------------------------------------------------------------------------------------------------------
-- HF0257 : Lịch điều chuyển làm việc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0257'
SET @ScreenType = 2
SET @ScreenName = N'Lịch điều chuyển làm việc'
SET @ScreenNameE = N'Transfer working schedule'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_TransferWorkSchedule'
------------------------------------------------------------------------------------------------------
-- HF0258 : Cập nhật lịch điều chuyển làm việc trong ngày
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0258'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật lịch điều chuyển làm việc trong ngày'
SET @ScreenNameE = N'Update transfer working schedule'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0259 - Danh mục lỗi sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0259'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục lỗi sản phâm'
SET @ScreenNameE = N'List of defects'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_ProductError'
------------------------------------------------------------------------------------------------------
-- HF0260 - Cập nhật lỗi sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0260'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật lỗi sản phẩm'
SET @ScreenNameE = N'Update product error'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0261 - Thống kê sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0261'
SET @ScreenType = 2
SET @ScreenName = N'Thống kê sản xuất'
SET @ScreenNameE = N'Statistics production'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Manufacture'
------------------------------------------------------------------------------------------------------
-- HF0262 - Thống kê sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0262'
SET @ScreenType = 3
SET @ScreenName = N'Thống kê sản xuất'
SET @ScreenNameE = N'Statistics production'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0265 - Chấm công theo công trình
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0265'
SET @ScreenType = 3
SET @ScreenName = N'Chấm công theo công trình'
SET @ScreenNameE = N'Attendance tracking by project'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0266 - Phụ cấp theo công trình
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0266'
SET @ScreenType = 3
SET @ScreenName = N'Phụ cấp theo công trình'
SET @ScreenNameE = N'Allowance by project'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0267 - Danh mục công việc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0267'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục công việc'
SET @ScreenNameE = N'List of work'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_WorkID','19'
------------------------------------------------------------------------------------------------------
-- HF0268 - Cập nhật công việc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0268'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật công việc'
SET @ScreenNameE = N'Update work'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0269 - Phương án tính luong
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0269'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phương án tính lương'
SET @ScreenNameE = N'List Solution Count Salary'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_SolCountSalary','19'
------------------------------------------------------------------------------------------------------
-- HF0270 - Cập nhật phương án lương
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0270'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật phương án lương'
SET @ScreenNameE = N'Update Solution Salary'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0271 - Đơn giá Phương án tính luong
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0271'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục đơn giá phương án tính lương'
SET @ScreenNameE = N'List Price Solution Count Salary'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_PriceSalary','19'
------------------------------------------------------------------------------------------------------
-- HF0272 - Cập nhật đơn giá phương án tính lương
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0272'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật đơn giá phương án tính lương'
SET @ScreenNameE = N'Update Price Solution Salary'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0273 - Tổng quỹ lương toàn công ty
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0273'
SET @ScreenType = 3
SET @ScreenName = N'Tổng quỹ lương toàn công ty'
SET @ScreenNameE = N'Total company-wide salary'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_TotalAmount','19'
------------------------------------------------------------------------------------------------------
-- HF0274 - Tính lương sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0274'
SET @ScreenType = 3
SET @ScreenName = N'Tính lương sản phẩm'
SET @ScreenNameE = N'Payroll Product'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_CalculateSalaryProduct','19'
------------------------------------------------------------------------------------------------------
-- HF0275 - Cập nhật bảng phân ca
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0275'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật bảng phân ca'
SET @ScreenNameE = N'Updating shift sheet'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- HF0276 - Danh mục chế độ nghỉ hưu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0276'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục chế độ nghỉ hưu'
SET @ScreenNameE = N'List of retirement'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Retirement'
------------------------------------------------------------------------------------------------------
-- HF0277 - Thiết lập chế độ nghỉ hưu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0277'
SET @ScreenType = 3
SET @ScreenName = N'Thiết lập chế độ nghỉ hưu'
SET @ScreenNameE = N'Updating retirement'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0278 - Danh sách nhân viên nghỉ hưu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0278'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách nhân viên nghỉ hưu'
SET @ScreenNameE = N'List of retired employee'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_RetiredEmployee'
------------------------------------------------------------------------------------------------------
-- HF0279 - Trợ cấp thôi việc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0279'
SET @ScreenType = 1
SET @ScreenName = N'Trợ cấp thôi việc'
SET @ScreenNameE = N'List of severance payment'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_SeverancePayment'
------------------------------------------------------------------------------------------------------
-- HF0280 - Hệ số theo ca
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0280'
SET @ScreenType = 2
SET @ScreenName = N'Hệ số theo ca'
SET @ScreenNameE = N'List of shift coefficient'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_ShiftCoefficient'
------------------------------------------------------------------------------------------------------
-- HF0281 - Cập nhật hệ số theo ca
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0281'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật hệ số theo ca'
SET @ScreenNameE = N'Updating shift coefficient'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0282 - Chấm công nhân viên (theo ca)
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0282'
SET @ScreenType = 2
SET @ScreenName = N'Chấm công nhân viên (theo ca)'
SET @ScreenNameE = N'Chấm công nhân viên (theo ca)'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Absent_Shift'
------------------------------------------------------------------------------------------------------
-- HF0283 - Phát sinh chấm công ca
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0283'
SET @ScreenType = 3
SET @ScreenName = N'Phát sinh chấm công ca'
SET @ScreenNameE = N'Phát sinh chấm công ca'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0284 - Chấm công ca
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0284'
SET @ScreenType = 3
SET @ScreenName = N'Chấm công ca'
SET @ScreenNameE = N'Chấm công ca'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0285 - Cập nhật tạm ứng từ bảng lương thuế
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0285'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật tạm ứng từ bảng lương thuế'
SET @ScreenNameE = N'Cập nhật tạm ứng từ bảng lương thuế'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_UpdateTamUng','12'
------------------------------------------------------------------------------------------------------
-- HF0287 - Chấm công sản phẩm phương pháp chỉ định
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0287'
SET @ScreenType = 2
SET @ScreenName = N'Chấm công sản phẩm phương pháp chỉ định'
SET @ScreenNameE = N'Chấm công sản phẩm phương pháp chỉ định'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Absent_Product_Specify'
------------------------------------------------------------------------------------------------------
-- HF0288 - Cập Nhật chấm công sản phẩm phương pháp chỉ định
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0288'
SET @ScreenType = 2
SET @ScreenName = N'Cập Nhật chấm công sản phẩm phương pháp chỉ định'
SET @ScreenNameE = N'Cập Nhật chấm công sản phẩm phương pháp chỉ định'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0289 - Chấm công sản phẩm phương pháp phân bổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0289'
SET @ScreenType = 2
SET @ScreenName = N'Chấm công sản phẩm phương pháp phân bổ'
SET @ScreenNameE = N'Chấm công sản phẩm phương pháp phân bổ'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Absent_Product_Allocated'
------------------------------------------------------------------------------------------------------
-- HF0290 -Cập nhật Chấm công sản phẩm phương pháp phân bổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0290'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chấm công sản phẩm phương pháp phân bổ'
SET @ScreenNameE = N'Cập nhật chấm công sản phẩm phương pháp phân bổ'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0291 -Danh sách nhân viên
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0291'
SET @ScreenType = 3
SET @ScreenName = N'Danh sách nhân viên'
SET @ScreenNameE = N'Employee List'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0292 - Danh mục phân loại mã hợp đồng lao động
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0292'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phân loại mã hợp đồng lao động'
SET @ScreenNameE = N'Danh mục phân loại mã hợp đồng lao động'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_EmployeeRecord_ContractType'
------------------------------------------------------------------------------------------------------
-- HF0293 - Cập nhật phân loại mã hợp đồng lao động
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0293'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật phân loại mã hợp đồng lao động'
SET @ScreenNameE = N'Cập nhật phân loại mã hợp đồng lao động'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0294 - Danh mục phân loại mã quyết định thôi việc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0294'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phân loại mã quyết định thôi việc'
SET @ScreenNameE = N'Danh mục phân loại mã quyết định thôi việc'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_EmployeeRecord_DecideType'
------------------------------------------------------------------------------------------------------
-- HF0295 - Cập nhật phân loại mã quyết định thôi việc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0295'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật phân loại mã quyết định thôi việc'
SET @ScreenNameE = N'Cập nhật phân loại mã quyết định thôi việc'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0296 - Danh mục xếp loại thi đua
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0296'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục xếp loại thi đua'
SET @ScreenNameE = N'Danh mục xếp loại thi đua'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Classified_Emulation'
------------------------------------------------------------------------------------------------------
-- HF0297 - Cập nhật xếp loại thi đua
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0297'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhât xếp loại thi đua'
SET @ScreenNameE = N'Cập nhât xếp loại thi đua'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0298 - Bảng theo dõi thi đua
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0298'
SET @ScreenType = 3
SET @ScreenName = N'Bảng theo dõi thi đua'
SET @ScreenNameE = N'Bảng theo dõi thi đua'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Emulation_Monitor'
------------------------------------------------------------------------------------------------------
-- HF0299 - Báo cáo theo dõi thi đua
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0299'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo theo dõi thi đua'
SET @ScreenNameE = N'Báo cáo theo dõi thi đua'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Emulation_Monitor'
------------------------------------------------------------------------------------------------------
-- HF0300 - Đăng ký bảo hiểm tai nạn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0300'
SET @ScreenType = 3
SET @ScreenName = N'Đăng ký bảo hiểm tai nạn'
SET @ScreenNameE = N'Đăng ký bảo hiểm tai nạn'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Registration_Accident_Insurance'
------------------------------------------------------------------------------------------------------
-- HF0301 - Thiết lập chung
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0301'
SET @ScreenType = 3
SET @ScreenName = N'Thiết lập chung'
SET @ScreenNameE = N'Thiết lập chung'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSys_Setup_Public','19'
------------------------------------------------------------------------------------------------------
-- HF0302 - Danh sách đề nghị trợ cấp nghỉ DSPHSK sau điều trị thương tật
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0302'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách đề nghị trợ cấp nghỉ DSPHSK sau điều trị thương tật'
SET @ScreenNameE = N'Danh sách đề nghị trợ cấp nghỉ DSPHSK sau điều trị thương tật'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_List_Health_Of_Nursing'
------------------------------------------------------------------------------------------------------
-- HF0303 - Cập nhật danh sách đề nghị trợ cấp nghỉ DSPHSK sau điều trị thương tật
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0303'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh sách đề nghị trợ cấp nghỉ DSPHSK sau điều trị thương tật'
SET @ScreenNameE = N'Cập nhật danh sách đề nghị trợ cấp nghỉ DSPHSK sau điều trị thương tật'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- HF0305 - Cập nhật danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0303'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK'
SET @ScreenNameE = N'Cập nhật danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0310 - Danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK sau thai sản
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0310'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK sau thai sản '
SET @ScreenNameE = N'Danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK sau thai sản '
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_List_Maternity_Benefits'
------------------------------------------------------------------------------------------------------
-- HF0311 - Cập nhật danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK sau thai sản
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0311'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK'
SET @ScreenNameE = N'Cập nhật danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0312 - Danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK sau ốm đau
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0312'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK sau ốm đau'
SET @ScreenNameE = N'Danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK sau ốm đau'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_List_Health_Of_Nursing_Illness'
------------------------------------------------------------------------------------------------------
-- HF0313 - Cập nhật danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK sau ốm đau
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0313'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK sau ốm đau'
SET @ScreenNameE = N'Cập nhật danh sách đề nghị hưởng trợ cấp nghỉ DSPHSK sau ốm đau'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0314 - Cập nhật thông tin xét duyệt đề nghị hưởng trợ cấp BHXH
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0314'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật thông tin xét duyệt đề nghị hưởng trợ cấp BHXH'
SET @ScreenNameE = N'Cập nhật thông tin xét duyệt đề nghị hưởng trợ cấp BHXH'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0315 - Danh sách người lao động đề nghị hưởng chế độ thai sản
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0315'
SET @ScreenType = 3
SET @ScreenName = N'Danh sách người lao động đề nghị hưởng chế độ thai sản'
SET @ScreenNameE = N'Danh sách người lao động đề nghị hưởng chế độ thai sản'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_List_Request_Maternity'
------------------------------------------------------------------------------------------------------
-- HF0316 - Cập nhật danh sách người lao động đề nghị hưởng chế độ thai sản
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0316'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh sách người lao động đề nghị hưởng chế độ thai sản'
SET @ScreenNameE = N'Cập nhật danh sách người lao động đề nghị hưởng chế độ thai sản'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0317 - Tờ khai BHXH, BHYT
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0317'
SET @ScreenType = 2
SET @ScreenName = N'Tờ khai BHXH, BHYT'
SET @ScreenNameE = N'Tờ khai BHXH, BHYT '
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Insurance_Declaration'
------------------------------------------------------------------------------------------------------
-- HF0318 - Cập nhât tờ khai BHXH, BHYT
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0318'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhât tờ khai BHXH, BHYT'
SET @ScreenNameE = N'Cập nhât tờ khai BHXH, BHYT'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0319 - Hiểu chỉnh chấm công ca
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0319'
SET @ScreenType = 3
SET @ScreenName = N'Hiểu chỉnh chấm công ca'
SET @ScreenNameE = N'Hiểu chỉnh chấm công ca'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0305 -  Chế độ ốm đau
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0305'
SET @ScreenType = 2
SET @ScreenName = N'Chế độ ốm đau'
SET @ScreenNameE = N'Chế độ ốm đau'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Sickness'
------------------------------------------------------------------------------------------------------
-- HF0306 - Cập nhật chế độ ốm đau
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0306'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chế độ ốm đau'
SET @ScreenNameE = N'Cập nhật chế độ ốm đau'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0307 -  Cập nhật công thức
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0307'
SET @ScreenType = 4
SET @ScreenName = N'Cập nhật công thức'
SET @ScreenNameE = N'Cập nhật công thức'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0304 -  Hiệu chình chấm công sản phẩm( theo ca)
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0307'
SET @ScreenType = 4
SET @ScreenName = N'Hiệu chình chấm công sản phẩm( theo ca)'
SET @ScreenNameE = N'Hiệu chình chấm công sản phẩm( theo ca)'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0308 -  Danh sách người lao động đề nghị hưởng chế độ ốm đau
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0308'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách người lao động đề nghị hưởng chế độ ốm đau'
SET @ScreenNameE = N'Danh sách người lao động đề nghị hưởng chế độ ốm đau'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_List_Request_Of_Nursing_Illness'
------------------------------------------------------------------------------------------------------
-- HF0309 - Cập nhật danh sách người lao động đề nghị hưởng chế độ ốm đau
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0309'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh sách người lao động đề nghị hưởng chế độ ốm đau'
SET @ScreenNameE = N'Cập nhật danh sách người lao động đề nghị hưởng chế độ ốm đau'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0320 -  Danh mục tăng giảm mức đóng BHXH, BHYT
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0320'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục tăng giảm mức đóng BHXH, BHYT'
SET @ScreenNameE = N'List Increase and Decrease social insurance, health insurance'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusiness_IncreaseDecrease'
------------------------------------------------------------------------------------------------------
-- HF0321 -  Khai báo tăng giảm mức đóng BHXH, BHYT
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0321'
SET @ScreenType = 3
SET @ScreenName = N'Khai báo tăng giảm mức đóng BHXH, BHYT'
SET @ScreenNameE = N'Create Increase and Decrease social insurance, health insurance'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0322 -  Danh mục báo cáo tham gia BHXH, BHYT trong tháng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0322'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục báo cáo tham gia BHXH, BHYT trong tháng'
SET @ScreenNameE = N'Danh mục báo cáo tham gia BHXH, BHYT trong tháng'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_List_Insurance'
------------------------------------------------------------------------------------------------------
-- HF0323 - Cập nhật danh mục báo cáo tham gia BHXH, BHYT trong tháng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0323'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục báo cáo tham gia BHXH, BHYT trong tháng'
SET @ScreenNameE = N'Cập nhật danh mục báo cáo tham gia BHXH, BHYT trong tháng'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0324 - Tính lương sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0324'
SET @ScreenType = 3
SET @ScreenName = N'Tính lương sản phẩm'
SET @ScreenNameE = N'Payroll Product'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_CalculateSalaryProduct','19'
------------------------------------------------------------------------------------------------------
-- HF0325 - Nghỉ phép
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0325'
SET @ScreenType = 2
SET @ScreenName = N'Nghỉ phép'
SET @ScreenNameE = N'Vacation'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusiness_Vacation'
------------------------------------------------------------------------------------------------------
-- HF0326 - Cập nhật nghỉ phép
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0326'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật nghỉ phép'
SET @ScreenNameE = N'Update vacation'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0327 - Danh mục chế độ tăng lương
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0327'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục chế độ tăng lương'
SET @ScreenNameE = N'List mode salary increase'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_SalaryIncrease'
------------------------------------------------------------------------------------------------------
-- HF0328 - Cập nhật chế độ tăng lương
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0328'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chế độ tăng lương'
SET @ScreenNameE = N'Update mode salary increase'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0329 -  Danh sách nhân viên được tăng lương
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0329'
SET @ScreenType = 2
SET @ScreenName = N' Danh sách nhân viên được tăng lương'
SET @ScreenNameE = N'List Employee salary increase'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Salary_Increases','19'
------------------------------------------------------------------------------------------------------
-- HF0330 - Danh sách cập nhật hồ sơ nhân sự
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0330'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách cập nhật hồ sơ nhân sự'
SET @ScreenNameE = N'List personnel records'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusiness_Update_Personnel'
------------------------------------------------------------------------------------------------------
-- HF0331 - Cập nhật hồ sơ nhân sự
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0331'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật hồ sơ nhân sự'
SET @ScreenNameE = N'Update personnel records'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0332 - Danh mục nấc thang thuế TNCN
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0332'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục nấc thang thuế thu nhập cá nhân'
SET @ScreenNameE = N'List ladder of personal income tax'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_LadderTax'
------------------------------------------------------------------------------------------------------
-- HF0333 - Cập nhật nấc thang thuế TNCN
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0333'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật nấc thang thuế TNCN'
SET @ScreenNameE = N'Update ladder of personal income tax'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0334 - Danh mục khai báo người phụ thuộc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0334'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục khai báo người phụ thuộc'
SET @ScreenNameE = N'Declare the list of dependents'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_DeclareDependents'
------------------------------------------------------------------------------------------------------
-- HF0335 - Cập nhật người phụ thuộc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0335'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật người phụ thuộc'
SET @ScreenNameE = N'Update dependents'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0336 - Thiết lập phương pháp tính thuế TNCN
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0336'
SET @ScreenType = 2
SET @ScreenName = N'Thiết lập phương pháp tính thuế TNCN'
SET @ScreenNameE = N'Set Tax methods'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Set_Tax_Methods'
------------------------------------------------------------------------------------------------------
-- HF0337 - Thiết lập phương pháp tính thuế TNCN
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0337'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật thiết lập phương pháp tính thuế TNCN'
SET @ScreenNameE = N'Update set Tax methods'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0338 - Tính thuế thu nhập cá nhân
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0338'
SET @ScreenType = 2
SET @ScreenName = N'Tính thuế thu nhập cá nhân'
SET @ScreenNameE = N'Personal Income tax'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusiness_Personal_Income_Tax'
------------------------------------------------------------------------------------------------------
-- HF0339 - Lịch sử thôi việc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0339'
SET @ScreenType = 2
SET @ScreenName = N'Lịch sử thôi việc'
SET @ScreenNameE = N'History Severance'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_History_Severance'
------------------------------------------------------------------------------------------------------
-- HF0340 - Báo cáo tàu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0340'
SET @ScreenType = 4
SET @ScreenName = N'Báo cáo tàu'
SET @ScreenNameE = N'Ship Report'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuShipReportTable','19'
------------------------------------------------------------------------------------------------------
-- HF0341 - Tính thuế TNCN
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0341'
SET @ScreenType = 4
SET @ScreenName = N'Tính thuế TNCN'
SET @ScreenNameE = N'Tính thuế TNCN'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0342 - Báo cáo chi tiết ca, tàu, tổ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0342'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo chi tiết ca, tàu, tổ'
SET @ScreenNameE = N'Báo cáo chi tiết ca, tàu, tổ'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSumaryDetailTable','19'
------------------------------------------------------------------------------------------------------
-- HF0344 - Danh sách thanh toán chế độ ốm đau, thai sản, dưỡng sức PHSK
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0344'
SET @ScreenType = 4
SET @ScreenName = N'Danh sách thanh toán chế độ ốm đau, thai sản, dưỡng sức PHSK'
SET @ScreenNameE = N'List sickness maternity Insurance '
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Lists_Sickness_Maternity_Insurance'
------------------------------------------------------------------------------------------------------
-- HF0158 - Danh sách đề nghị xác nhận sổ BHXH
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0158'
SET @ScreenType = 4
SET @ScreenName = N'Danh sách đề nghị xác nhận sổ BHXH'
SET @ScreenNameE = N'List of proposed certified social insurance books'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Insurance_InsuranceNo'
------------------------------------------------------------------------------------------------------
-- HF0348 - Danh sách con nhân viên theo độ tuổi
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0348'
SET @ScreenType = 4
SET @ScreenName = N'Danh sách con nhân viên theo độ tuổi'
SET @ScreenNameE = N'List Saff child age '
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Staff_Child_Age'
------------------------------------------------------------------------------------------------------
-- HF0347 - Danh sách chấm công công trình theo ca
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0347'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách chấm công công trình theo ca'
SET @ScreenNameE = N'List of Attendance tracking by project periods'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Absent_Project_Period'
------------------------------------------------------------------------------------------------------
-- HF0350 - Cập nhật chấm công công trình theo ca
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0350'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chấm công công trình theo ca'
SET @ScreenNameE = N'Attendance tracking by project periods'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0349 - Báo cáo quá trình công tác
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0349'
SET @ScreenType = 4
SET @ScreenName = N'Báo cáo quá trình công tác'
SET @ScreenNameE = N'Report working process'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Working_Process'
------------------------------------------------------------------------------------------------------
-- HF0351 - Cập nhật chấm công công trình theo ca theo khoảng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0351'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chấm công công trình theo ca theo khoảng'
SET @ScreenNameE = N'Attendance tracking by project periods in range'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0352 - Kết chuyển công ca sang công tháng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0352'
SET @ScreenType = 4
SET @ScreenName = N'Kết chuyển công ca sang công tháng'
SET @ScreenNameE = N'The transfer of cases to the month'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0353 - Quyết toán thuế TNCN (05KK-TNCN)
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0353'
SET @ScreenType = 3
SET @ScreenName = N'Quyết toán thuế TNCN (05KK-TNCN)'
SET @ScreenNameE = N'Personal Income Tax Finalization'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0354 - Tờ khai quyết toán thuế TNCN
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0354'
SET @ScreenType = 2
SET @ScreenName = N'Tờ khai quyết toán thuế TNCN'
SET @ScreenNameE = N'Listing Personal Income Tax Finalization'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_PersonalIncomeTax_Finalization'
------------------------------------------------------------------------------------------------------
-- HF0357 - Tờ khai khấu trừ thuế TNCN (02KK-TNCN)
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0357'
SET @ScreenType = 3
SET @ScreenName = N'Tờ khai khấu trừ thuế TNCN (02KK-TNCN)'
SET @ScreenNameE = N'Personal Income Tax'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- HF0185 - Danh mục tờ khai khấu trừ thuế TNCN (02KK-TNCN)
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0185'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục tờ khai khấu trừ thuế TNCN (02KK-TNCN)'
SET @ScreenNameE = N'Listing Personal Income Tax'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_PIT_Personal'
------------------------------------------------------------------------------------------------------
-- HF0358 - Gửi phiếu lương qua email
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0358'
SET @ScreenType = 4
SET @ScreenName = N'Gửi phiếu lương qua Email'
SET @ScreenNameE = N'Gửi phiếu lương qua Email'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'',13
------------------------------------------------------------------------------------------------------
-- HF0355 - Kế thừa kết quả sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0355'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa kết quả sản xuất'
SET @ScreenNameE = N'Kế thừa kết quả sản xuất'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'',13
------------------------------------------------------------------------------------------------------
-- HF0355 - Kế thừa kết quả sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'HF0356'
SET @ScreenType = 3
SET @ScreenName = N'Duyệt đi trễ, về sớm'
SET @ScreenNameE = N'Duyệt đi trễ, về sớm'
EXEC AddScreen N'ASoftHRM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Approval',17
------------------------------------------------------------------------------------------------------
SET NOCOUNT OFF
------------------------------------------------------------------------------------------------------