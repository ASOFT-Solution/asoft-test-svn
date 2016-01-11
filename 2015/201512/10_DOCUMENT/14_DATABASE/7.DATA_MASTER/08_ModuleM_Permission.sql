------------------------------------------------------------------------------------------------------
-- Fix Bổ sung phân quyền màn hình -- Module M
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
-- MF0021 : Danh mục bộ định mức
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0021'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục đối tượng tập hợp chi phí'
SET @ScreenNameE = N'List of synthetic cost objects'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Period_Product'
------------------------------------------------------------------------------------------------------
-- MF0022 : Danh mục bộ định mức
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0022'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục bộ định mức'
SET @ScreenNameE = N'Norm list'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_SetOfNorm'
------------------------------------------------------------------------------------------------------
-- MF0102 : Sinh phiếu nhập xuất kho tự động
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0102'
SET @ScreenType = 3
SET @ScreenName = N'Sinh phiếu nhập xuất kho tự động'
SET @ScreenNameE = N'Auto create delivery voucher and receiving voucher'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- MF0103 - Tính phế phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0103'
SET @ScreenType = 3
SET @ScreenName = N'Tính phế phẩm'
SET @ScreenNameE = N'Calculating waste'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnu_Busssiness_Calculate_Waste'
------------------------------------------------------------------------------------------------------
-- MF0104 - Nhập kho phế phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0104'
SET @ScreenType = 3
SET @ScreenName = N'Nhập kho phế phẩm'
SET @ScreenNameE = N'Storing waste'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- Sample_005 - Cập nhật phiếu đề nghị vật tư
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_005'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật phiếu đề nghị vật tư'
SET @ScreenNameE = N'Cập nhật phiếu đề nghị vật tư'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnu_Busssiness_Sproposed_Materials','-2'
------------------------------------------------------------------------------------------------------
-- Sample_006 - Phiếu đề nghị vật tư
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_006'
SET @ScreenType = 2
SET @ScreenName = N'Phiếu đề nghị vật tư'
SET @ScreenNameE = N'Phiếu đề nghị vật tư'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Sproposed_Materials','-2'
------------------------------------------------------------------------------------------------------
-- Sample_010 - Lệnh sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_010'
SET @ScreenType = 2
SET @ScreenName = N'Lệnh sản xuất'
SET @ScreenNameE = N'Lệnh sản xuất'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Production_Order','-2'
------------------------------------------------------------------------------------------------------
-- Sample_011 - Cập nhật lệnh sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_011'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật lệnh sản xuất'
SET @ScreenNameE = N'Cập nhật lệnh sản xuất'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnu_Busssiness_Production_Order','-2'
------------------------------------------------------------------------------------------------------
-- MF0105 - Danh mục công thức pha trọn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0105'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục công thức pha trọn'
SET @ScreenNameE = N'Declaration mixing formula'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Declaration_Mixing_Formula','36'
------------------------------------------------------------------------------------------------------
-- MF0106 - Cập nhật công thức pha trọn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0106'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật công thức pha trọn'
SET @ScreenNameE = N'Update declaration mixing formula'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- MF0107 - Danh mục phiếu pha trộn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0107'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phiếu pha trộn'
SET @ScreenNameE = N'List share mixed'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Shares_Mixed','36'
------------------------------------------------------------------------------------------------------
-- MF0108 - Lập phiếu pha trộn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0108'
SET @ScreenType = 3
SET @ScreenName = N'Lập phiếu pha trộn'
SET @ScreenNameE = N'Update share mixed'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnu_Busssiness_Shares_Mixed','36'
------------------------------------------------------------------------------------------------------
-- MF0109 - Danh sách chỉ tiêu kiểm định sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0109'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách chỉ tiêu kiểm định sản phẩm'
SET @ScreenNameE = N'List Testing product target'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Testing_Product_Target','36'
------------------------------------------------------------------------------------------------------
-- MF0110 - Cập nhật chỉ tiêu kiểm định sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0110'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật chỉ tiêu kiểm định sản phẩm'
SET @ScreenNameE = N'Update testing product target'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- MF0111 - Danh mục kết quả thử nghiệm sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0111'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách chỉ tiêu kiểm định sản phẩm'
SET @ScreenNameE = N'List Result Test'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Result_Test','36'
------------------------------------------------------------------------------------------------------
-- MF0112 - Tạo phiếu kết quả thử nghiệm sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0112'
SET @ScreenType = 3
SET @ScreenName = N'Tạo phiếu kết quả thử nghiệm sản phẩm'
SET @ScreenNameE = N'Create result test'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnu_Busssiness_Create_Result_Test','36'
------------------------------------------------------------------------------------------------------
-- MF0113 - Khai báo công thức sản xuất sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0113'
SET @ScreenType = 2
SET @ScreenName = N'Khai báo công thức sản xuất sản phẩm'
SET @ScreenNameE = N'List producing formula'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Producing_Formula','36'
------------------------------------------------------------------------------------------------------
-- MF0114 - Cập nhật công thức sản xuất sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0114'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật công thức sản xuất sản phẩm'
SET @ScreenNameE = N'Create producing formula'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- MF0115 - Danh mục bảng giá vốn sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0115'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục bảng giá vốn sản phẩm'
SET @ScreenNameE = N'List price product'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_List_Price_Product','36'
------------------------------------------------------------------------------------------------------
-- MF0116 - Cập nhật bảng giá vốn sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0116'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật bảng giá vốn sản phẩm'
SET @ScreenNameE = N'Create price product'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnu_Busssiness_List_Price_Product','36'
------------------------------------------------------------------------------------------------------
-- MF0117 - Danh mục bảng giá nguyên liệu và bao bì
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0117'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục bảng giá nguyên liệu và bao bì'
SET @ScreenNameE = N'List price material and packing'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Price_Material_Packing','36'
------------------------------------------------------------------------------------------------------
-- MF0118 - Cập nhật bảng giá nguyên vật liệu và bao bì
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0118'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật bảng giá nguyên vật liệu và bao bì'
SET @ScreenNameE = N'Create price material and packing'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- MF0164 - Cập nhật vật liệu đóng gói
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0164'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật vật liệu đóng gói'
SET @ScreenNameE = N'Create material packing'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- MF0119 - Danh mục phiếu giao việc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0119'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phiếu giao việc'
SET @ScreenNameE = N'Query Task'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_PGV','43'
------------------------------------------------------------------------------------------------------
-- MF0120 - Cập nhật phiếu giao việc
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0120'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật phiếu giao việc'
SET @ScreenNameE = N'Bussiness Task'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusssiness_PGV','43'
------------------------------------------------------------------------------------------------------
-- MF0123 - Kế thừa tiến độ sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0123'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa tiến độ sản xuất'
SET @ScreenNameE = N'Inherit process producing'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- MF0124 - Kế thừa bảng giá vốn sản phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0124'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa bảng giá vốn sản phẩm'
SET @ScreenNameE = N'Inherit price list product'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- MF0125 - Kế hoạch sản xuất tổng thể
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0125'
SET @ScreenType = 3
SET @ScreenName = N'Kế hoạch sản xuất tổng thể'
SET @ScreenNameE = N'Manufacture plan'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'Busssiness_KHSX','47'
-----------------------------------------------------------------------------------------------------
-- MF0126 - Kế thừa đơn hàng sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0126'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa đơn hàng sản xuất'
SET @ScreenNameE = N'Inherit Order Product'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'','47'
------------------------------------------------------------------------------------------------------
-- MF0127 - Kế hoạch sản xuất chi tiết 
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0127'
SET @ScreenType = 3
SET @ScreenName = N'Kế hoạch sản xuất chi tiết'
SET @ScreenNameE = N'Plan detail product'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'','47'
------------------------------------------------------------------------------------------------------
-- MF0128 - Cập nhật lệnh sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0128'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật lệnh sản xuất'
SET @ScreenNameE = N'Cập nhật lệnh sản xuất'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnu_Busssiness_Production_OrderDNP','47'
------------------------------------------------------------------------------------------------------
-- MF0129 - Kế thừa kế hoạch sản xuất chi tiết
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0129'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa kế hoạch sản xuất chi tiết'
SET @ScreenNameE = N'Inherit detail product'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'','47'
------------------------------------------------------------------------------------------------------
-- MF0130 - Lệnh sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0130'
SET @ScreenType = 2
SET @ScreenName = N'Lệnh sản xuất'
SET @ScreenNameE = N'Lệnh sản xuất'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Production_OrderDNP','47'
------------------------------------------------------------------------------------------------------
-- MF0131 - Danh mục tiêu chuẩn giờ công
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0131'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục tiêu chuẩn giờ công'
SET @ScreenNameE = N'Danh mục tiêu chuẩn giờ công'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_CriteriaID','47'
------------------------------------------------------------------------------------------------------
-- MF0132 - Cập nhật tiêu chuẩn giờ công
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0132'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật tiêu chuẩn giờ công'
SET @ScreenNameE = N'Cập nhật tiêu chuẩn giờ công'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'','47'
------------------------------------------------------------------------------------------------------
-- MF0131 - Danh mục tiêu chuẩn giờ công
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0134'
SET @ScreenType = 4
SET @ScreenName = N'Định nghĩa tham số'
SET @ScreenNameE = N'Định nghĩa tham số'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_DefineParameterM','48'
------------------------------------------------------------------------------------------------------
-- MF0135 - Danh mục Định mức theo quy cách
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0135'
SET @ScreenType = 2
SET @ScreenName = N'Định mức theo quy cách'
SET @ScreenNameE = N'Định mức theo quy cách'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_SetOfNormS'
------------------------------------------------------------------------------------------------------
-- MF0136 - Cập nhật định mức theo quy cách
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0136'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật định mức theo quy cách'
SET @ScreenNameE = N'Cập nhật định mức theo quy cách'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- MF0137 - Thiết lập danh mục định mức theo quy cách
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0137'
SET @ScreenType = 3
SET @ScreenName = N'Thiết lập danh mục định mức theo quy cách'
SET @ScreenNameE = N'Thiết lập danh mục định mức theo quy cách'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- MF0137 - Thiết lập danh mục định mức theo quy cách
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'MF0138'
SET @ScreenType = 3
SET @ScreenName = N'Kế thừa bộ định mức theo quy cách'
SET @ScreenNameE = N'Kế thừa bộ định mức theo quy cách'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------

SET NOCOUNT OFF
------------------------------------------------------------------------------------------------------