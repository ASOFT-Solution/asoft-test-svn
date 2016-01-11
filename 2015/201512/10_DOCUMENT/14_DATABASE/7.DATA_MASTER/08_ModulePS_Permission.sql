------------------------------------------------------------------------------------------------------
-- Fix Bổ sung phân quyền màn hình -- Module PS
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
-- 1 - Báo cáo
------------------------------------------------------------------------------------------------------
-- PSF3000 - Báo cáo sản lượng và doanh thu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF3000'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo sản lượng và doanh thu'
SET @ScreenNameE = N'Revenue and output report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF3000'
------------------------------------------------------------------------------------------------------
-- PSF3010 - Kế hoạch xếp dỡ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF3010'
SET @ScreenType = 1
SET @ScreenName = N'Kế hoạch xếp dỡ'
SET @ScreenNameE = N'Plan report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF3010'
------------------------------------------------------------------------------------------------------
-- PSF3011 - Tình hình xếp dỡ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF3011'
SET @ScreenType = 1
SET @ScreenName = N'Tình hình xếp dỡ'
SET @ScreenNameE = N'Plan mornitoring report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF3011'
------------------------------------------------------------------------------------------------------
-- PSF3013 - Báo cáo sản lượng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF3013'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo sản lượng'
SET @ScreenNameE = N'Output report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF3011'
------------------------------------------------------------------------------------------------------
-- PSF3020 - Báo cáo nhập xuất tồn theo loại hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF3020'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo nhập xuất tồn theo loại hàng'
SET @ScreenNameE = N'Warehouse mornitoring report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF3020'
------------------------------------------------------------------------------------------------------
-- PSF3030 - Báo cáo sản lượng hàng hóa hàng ngày
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF3030'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo sản lượng hàng hóa hàng ngày'
SET @ScreenNameE = N'Ouput daily mornitoring report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF3030'
------------------------------------------------------------------------------------------------------
-- PSF3040 - Báo cáo sản lượng giao nhận công ty
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF3040'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo sản lượng giao nhận công ty'
SET @ScreenNameE = N'Company output report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF3040'
------------------------------------------------------------------------------------------------------
-- PSF3070 - Báo cáo danh sách tàu kiểm đếm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF3070'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo danh sách tàu kiểm đếm'
SET @ScreenNameE = N'Ship comming report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF3070'
------------------------------------------------------------------------------------------------------
-- PSF3080 - Báo cáo sản lượng giao nhận
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF3080'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo sản lượng giao nhận'
SET @ScreenNameE = N'Delivery output report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF3080'
------------------------------------------------------------------------------------------------------
-- PSF3080 - Báo cáo sản lượng giao nhận
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF3080'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo sản lượng giao nhận'
SET @ScreenNameE = N'Delivery output report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF3080'
------------------------------------------------------------------------------------------------------
-- PSF3060 - Bảng kê sản lượng bốc xếp theo tàu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF3060'
SET @ScreenType = 1
SET @ScreenName = N'Bảng kê sản lượng bốc xếp theo tàu'
SET @ScreenNameE = N'Delivery output report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF3060'






------------------------------------------------------------------------------------------------------
-- 2 - Danh mục
------------------------------------------------------------------------------------------------------
-- PSF1050 - Danh mục nhóm hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1050'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục nhóm hàng'
SET @ScreenNameE = N'Inventory type category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF1050'
------------------------------------------------------------------------------------------------------
-- PSF1060 - Danh mục loại hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1060'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục loại hàng'
SET @ScreenNameE = N'Inventory category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF1060'
------------------------------------------------------------------------------------------------------
-- PSF1010 - Danh mục cảng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1010'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục cảng'
SET @ScreenNameE = N'Port category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF1010'
------------------------------------------------------------------------------------------------------
-- PSF1030 - Danh mục tàu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1030'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục tàu'
SET @ScreenNameE = N'Ship category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF1030'
------------------------------------------------------------------------------------------------------
-- PSF1000 - Danh mục nhóm phương án
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1000'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục nhóm phương án'
SET @ScreenNameE = N'Plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF1000'
------------------------------------------------------------------------------------------------------
-- PSF2080 - Danh mục phương án xếp dở
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2080'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phương án xếp dở'
SET @ScreenNameE = N'SubPlan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2080'
------------------------------------------------------------------------------------------------------
-- PSF1040 - Danh mục phương án kết toán tàu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1040'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phương án kết toán tàu'
SET @ScreenNameE = N'Account plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF1040'
------------------------------------------------------------------------------------------------------
-- PSF1070 - Danh mục phương án cơ giới
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1070'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phương án cơ giới'
SET @ScreenNameE = N'Engine plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF1070'
------------------------------------------------------------------------------------------------------
-- PSF1080 - Danh mục phương án bốc xếp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1080'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phương án bốc xếp'
SET @ScreenNameE = N'Turn round plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF1080'
------------------------------------------------------------------------------------------------------
-- PSF1090 - Danh mục phương án giao nhận
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1090'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phương án giao nhận'
SET @ScreenNameE = N'Delivery plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF1090'
------------------------------------------------------------------------------------------------------
-- PSF2090 - Danh mục dịch vụ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2090'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục dịch vụ'
SET @ScreenNameE = N'Work category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2090'
------------------------------------------------------------------------------------------------------
-- PSF1100 - Danh mục khách hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1100'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục khách hàng'
SET @ScreenNameE = N'Object category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF1100'
------------------------------------------------------------------------------------------------------
-- PSF1020 - Đơn giá phương án
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1020'
SET @ScreenType = 2
SET @ScreenName = N'Đơn giá phương án'
SET @ScreenNameE = N'Price category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF1020'
------------------------------------------------------------------------------------------------------
-- PSF2010 -Danh sách báo giá dịch vụ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2010'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách báo giá dịch vụ'
SET @ScreenNameE = N'Work price category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2010'
------------------------------------------------------------------------------------------------------
-- PSF2020 -Danh sách hợp đồng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2020'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách hợp đồng'
SET @ScreenNameE = N'Contract category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2020'
------------------------------------------------------------------------------------------------------
-- PSF2190 -Danh sách hóa đơn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2190'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách hóa đơn'
SET @ScreenNameE = N'Invoice category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2190'
------------------------------------------------------------------------------------------------------
-- PSF2030 - Kế hoạch sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2030'
SET @ScreenType = 2
SET @ScreenName = N'Kế hoạch sản xuất'
SET @ScreenNameE = N'Voucher plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2030'
------------------------------------------------------------------------------------------------------
-- PSF2040 - Lệnh sản xuất bốc xếp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2040'
SET @ScreenType = 2
SET @ScreenName = N'Lệnh sản xuất bốc xếp'
SET @ScreenNameE = N'Command voucher category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2040'
------------------------------------------------------------------------------------------------------
-- PSF2050 - Kết quả sản xuất bốc xếp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2050'
SET @ScreenType = 2
SET @ScreenName = N'Kết quả sản xuất bốc xếp'
SET @ScreenNameE = N'Command voucher result category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2050'
------------------------------------------------------------------------------------------------------
-- PSF2200 - Danh sách kết quả sản xuất bốc xếp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2200'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách kết quả sản xuất'
SET @ScreenNameE = N'Production result category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2200'
------------------------------------------------------------------------------------------------------
-- PSF2100 - Lệnh sản xuất cơ giới
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2100'
SET @ScreenType = 2
SET @ScreenName = N'Lệnh sản xuất cơ giới'
SET @ScreenNameE = N'Transport command voucher'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2100'
------------------------------------------------------------------------------------------------------
-- PSF2110 - Kết quả sản xuất cơ giới
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2110'
SET @ScreenType = 2
SET @ScreenName = N'Kết quả sản xuất cơ giới'
SET @ScreenNameE = N'Transport command voucher result'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2110'
------------------------------------------------------------------------------------------------------
-- PSF2060 - Lệnh sản xuất giao nhận
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2060'
SET @ScreenType = 2
SET @ScreenName = N'Lệnh sản xuất giao nhận'
SET @ScreenNameE = N'Delivery command voucher'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2060'
------------------------------------------------------------------------------------------------------
-- PSF2070 - Kết quả sản xuất giao nhận
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2070'
SET @ScreenType = 2
SET @ScreenName = N'Kết quả sản xuất giao nhận'
SET @ScreenNameE = N'Delivery command voucher result'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2070'
------------------------------------------------------------------------------------------------------
-- PSF2140 - Thống kê kết toán tàu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2140'
SET @ScreenType = 2
SET @ScreenName = N'Thống kê kết toán tàu'
SET @ScreenNameE = N'Ship statistic'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2140'
------------------------------------------------------------------------------------------------------
-- PSF2150 - Bảng kê sản lượng rút cont hàng xá đóng bao
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2150'
SET @ScreenType = 2
SET @ScreenName = N'Bảng kê sản lượng rút cont hàng xá đóng bao'
SET @ScreenNameE = N'Cont delivery output report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2150'
------------------------------------------------------------------------------------------------------
-- PSF2160 - Bảng tổng hợp sản lượng nhập xuất cont tàu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2160'
SET @ScreenType = 2
SET @ScreenName = N'Bảng tổng hợp sản lượng nhập xuất cont tàu'
SET @ScreenNameE = N'Cont delivery output sumary report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2160'
------------------------------------------------------------------------------------------------------
-- PSF2170 - Bảng tổng hợp sản lượng đóng & rút container
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2170'
SET @ScreenType = 2
SET @ScreenName = N'Bảng tổng hợp sản lượng đóng & rút container'
SET @ScreenNameE = N'Cont delivery output sumary report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2170'
------------------------------------------------------------------------------------------------------
-- PSF2180 - Bảng tổng hợp sản lượng nhập - xuất kho bãi
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2180'
SET @ScreenType = 2
SET @ScreenName = N'Bảng tổng hợp sản lượng nhập - xuất kho bãi'
SET @ScreenNameE = N'Output sumary report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2180'







------------------------------------------------------------------------------------------------------
-- 3 - Nhập liệu
------------------------------------------------------------------------------------------------------
-- PSF1051 - Cập nhật danh mục nhóm hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1051'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục nhóm hàng'
SET @ScreenNameE = N' Update inventory type category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF1061 - Cập nhật danh mục loại hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1061'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục loại hàng'
SET @ScreenNameE = N'Update inventory category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF1011 - Cập nhật danh mục cảng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1011'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục cảng'
SET @ScreenNameE = N'Update port category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF1031 - Cập nhật danh mục tàu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1031'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục tàu'
SET @ScreenNameE = N'Update ship category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF1001 - Danh mục nhóm phương án
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1001'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục nhóm phương án'
SET @ScreenNameE = N'Update plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2081 - Cập nhật danh mục phương án xếp dở
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2081'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục phương án xếp dở'
SET @ScreenNameE = N'Update subplan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF1041 - Cập nhật danh mục phương án kết toán tàu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1041'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục phương án kết toán tàu'
SET @ScreenNameE = N'Update account plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF1071 - Cập nhật danh mục phương án cơ giới
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1071'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục phương án cơ giới'
SET @ScreenNameE = N'Update engine plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF1081 - Cập nhật danh mục phương án bốc xếp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1081'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục phương án bốc xếp'
SET @ScreenNameE = N'Update turn round plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF1091 - Cập nhật danh mục phương án giao nhận
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1091'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục phương án giao nhận'
SET @ScreenNameE = N'Update delivery plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2091 - Cập nhật danh mục dịch vụ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2091'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục dịch vụ'
SET @ScreenNameE = N'Update work category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF1101 - Cập nhật danh mục khách hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1101'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh mục khách hàng'
SET @ScreenNameE = N'Update object category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF1021 - Cập nhật đơn giá phương án
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF1021'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật đơn giá phương án'
SET @ScreenNameE = N'Update price category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2011 - Cập nhật danh sách báo giá dịch vụ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2011'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh sách báo giá dịch vụ'
SET @ScreenNameE = N'Update work price category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2021 - Cập nhật danh sách hợp đồng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2021'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh sách hợp đồng'
SET @ScreenNameE = N'Update contract category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2191 - Cập nhật hóa đơn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2191'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật hóa đơn'
SET @ScreenNameE = N'Update invoice category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2192 - Cập nhật chi tiết hóa đơn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2192'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chi tiết hóa đơn'
SET @ScreenNameE = N'Update invoice category details'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2031 - Cập nhật kế hoạch sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2031'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật kế hoạch sản xuất'
SET @ScreenNameE = N'Update voucher plan category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2041 - Cập nhật lệnh sản xuất bốc xếp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2041'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật lệnh sản xuất bốc xếp'
SET @ScreenNameE = N'Update command voucher category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2051 - Cập nhật kết quả sản xuất bốc xếp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2051'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật kết quả sản xuất bốc xếp'
SET @ScreenNameE = N'Update command voucher result category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2052 - Cập nhật chi tiết kết quả sản xuất bốc xếp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2052'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chi tiết kết quả sản xuất bốc xếp'
SET @ScreenNameE = N'Update command voucher result category details'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2201 - Cập nhật danh sách kết quả sản xuất bốc xếp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2201'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật danh sách kết quả sản xuất'
SET @ScreenNameE = N'Update production result category'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2101 - Cập nhật lệnh sản xuất cơ giới
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2101'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật lệnh sản xuất cơ giới'
SET @ScreenNameE = N'Update transport command voucher'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2111 - Cập nhật kết quả sản xuất cơ giới
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2111'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật kết quả sản xuất bốc xếp'
SET @ScreenNameE = N'Update transport command voucher result'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2112 - Cập nhật chi tiết kết quả sản xuất cơ giới
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2112'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chi tiết kết quả sản xuất bốc xếp'
SET @ScreenNameE = N'Update transport command voucher result details'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2061 - Cập nhật lệnh sản xuất giao nhận
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2061'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật lệnh sản xuất giao nhận'
SET @ScreenNameE = N'Update delivery command voucher'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2071 - Cập nhật kết quả sản xuất giao nhận
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2071'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật kết quả sản xuất giao nhận'
SET @ScreenNameE = N'Update delivery command voucher result'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2072 - Cập nhật chi tiết kết quả sản xuất giao nhận
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2072'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chi tiết kết quả sản xuất giao nhận'
SET @ScreenNameE = N'Update delivery command voucher result details'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2141 - Cập nhật thống kê kết toán tàu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2141'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật thống kê kết toán tàu'
SET @ScreenNameE = N'Update ship statistic'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2151 - Cập nhật bảng kê sản lượng rút cont hàng xá đóng bao
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2151'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật bảng kê sản lượng rút cont hàng xá đóng bao'
SET @ScreenNameE = N'Update cont delivery output report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2152 - Cập nhật chi tiết bảng kê sản lượng rút cont hàng xá đóng bao
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2152'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chi tiết bảng kê sản lượng rút cont hàng xá đóng bao'
SET @ScreenNameE = N'Update cont delivery output report details'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2161 - Cập nhật bảng tổng hợp sản lượng nhập xuất cont tàu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2161'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật bảng tổng hợp sản lượng nhập xuất cont tàu'
SET @ScreenNameE = N'Update cont delivery output sumary report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2162 - Cập nhật chi tiết bảng tổng hợp sản lượng nhập xuất cont tàu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2162'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chi tiết bảng tổng hợp sản lượng nhập xuất cont tàu'
SET @ScreenNameE = N'Update cont delivery output sumary report details'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2171 - Cập nhật bảng tổng hợp sản lượng đóng & rút container
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2171'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật bảng tổng hợp sản lượng đóng & rút container'
SET @ScreenNameE = N'Update cont delivery output sumary report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2172 - Cập nhật chi tiết bảng tổng hợp sản lượng đóng & rút container
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2172'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chi tiết bảng tổng hợp sản lượng đóng & rút container'
SET @ScreenNameE = N'Update cont delivery output sumary report details'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2181 - Cập nhật bảng tổng hợp sản lượng nhập - xuất kho bãi
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2181'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật bảng tổng hợp sản lượng nhập - xuất kho bãi'
SET @ScreenNameE = N'Update output sumary report'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- PSF2182 - Cập nhật chi tiết bảng tổng hợp sản lượng nhập - xuất kho bãi
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2182'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chi tiết bảng tổng hợp sản lượng nhập - xuất kho bãi'
SET @ScreenNameE = N'Update output sumary report details'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''






------------------------------------------------------------------------------------------------------
-- 4 - Khác
------------------------------------------------------------------------------------------------------
-- PSF0002 - Thiết lập hệ thống
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF0002'
SET @ScreenType = 4
SET @ScreenName = N'Thiết lập hệ thống'
SET @ScreenNameE = N'System configuration'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF0002'
------------------------------------------------------------------------------------------------------
-- PSF0004 - Thiết lập thông tin dùng chung
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF0004'
SET @ScreenType = 4
SET @ScreenName = N'Thông tin chung'
SET @ScreenNameE = N'Common information configuration'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF0004'
------------------------------------------------------------------------------------------------------
-- PSF0003 - Tạo kỳ kế toán
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF0003'
SET @ScreenType = 4
SET @ScreenName = N'Tạo kỳ kế toán'
SET @ScreenNameE = N'Period creation'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF0003'
------------------------------------------------------------------------------------------------------
-- PSF0001 - Kỳ kế toán
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF0001'
SET @ScreenType = 4
SET @ScreenName = N'Kỳ kế toán'
SET @ScreenNameE = N'Period Setting'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF0001'
------------------------------------------------------------------------------------------------------
-- PSF2130 - Cập nhật trạng thái lệnh sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2130'
SET @ScreenType = 4
SET @ScreenName = N'Cập nhật trạng thái lệnh sản xuất'
SET @ScreenNameE = N'Update command voucher status statistic'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'PSF2130'
------------------------------------------------------------------------------------------------------
-- PSF2444 - Chọn nhân viên tổ nhóm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'PSF2444'
SET @ScreenType = 4
SET @ScreenName = N'Chọn nhân viên tổ nhóm'
SET @ScreenNameE = N'Employee list'
EXEC AddScreen N'ASoftPS', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''

SET NOCOUNT OFF
------------------------------------------------------------------------------------------------------