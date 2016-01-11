------------------------------------------------------------------------------------------------------
-- Fix Bổ sung phân quyền màn hình -- Module WM
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
-- WF0072 : Hàng bán trả lại nhập kho
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0072'
SET @ScreenType = 3
SET @ScreenName = N'Hàng bán trả lại nhập kho'
SET @ScreenNameE = N'Receiving sales return'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0073 : Hàng mua trả lại xuất kho
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0073'
SET @ScreenType = 3
SET @ScreenName = N'Hàng mua trả lại xuất kho'
SET @ScreenNameE = N'Return sales delivery'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AS0051 : Cập nhật đối tượng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0073'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật đối tượng'
SET @ScreenNameE = N'Update object'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
--WF0076: Theo dõi đặt hàng - sản xuất - nhập kho - giao hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0076'
SET @ScreenType = 1
SET @ScreenName = N'Theo dõi đặt hàng - sản xuất - nhập kho - giao hàng'
SET @ScreenNameE = N'Order Tracking - manufacturing - warehousing - Delivery'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Theodoidathang_SX_NK_GH','1'
------------------------------------------------------------------------------------------------------
--WF0077: Thông tin tồn kho theo mã vạch
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0077'
SET @ScreenType = 2
SET @ScreenName = N'Thông tin tồn kho theo mã vạch'
SET @ScreenNameE = N'List of Inventory by Barcode'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_InventoryByBarcode'
------------------------------------------------------------------------------------------------------
--WF0078: Nhập kho thành phẩm
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0078'
SET @ScreenType = 3
SET @ScreenName = N'Nhập kho thành phẩm'
SET @ScreenNameE = N'Warehousing of finished products'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Stock_Product','15'
------------------------------------------------------------------------------------------------------
--WF0079: Chi phí khác
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0079'
SET @ScreenType = 3
SET @ScreenName = N'Chi phí khác'
SET @ScreenNameE = N'Other costs'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0080 - Báo cáo tuổi hàng tồn kho
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0080' 
SET @ScreenType = 1 
SET @ScreenName = N'Báo cáo tuổi hàng tồn kho' 
SET @ScreenNameE = N'Report inventory age'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_InventoryAge'
------------------------------------------------------------------------------------------------------
-- WF0082 - Báo cáo hàng tồn kho
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0082' 
SET @ScreenType = 1 
SET @ScreenName = N'Báo cáo hàng tồn kho' 
SET @ScreenNameE = N'Report inventory'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Stock_InventoryAge2'
------------------------------------------------------------------------------------------------------
-- WF0083 - Định nghĩa tham số
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0083' 
SET @ScreenType = 4 
SET @ScreenName = N'Định nghĩa tham số' 
SET @ScreenNameE = N'Define parameter'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuSys_DefineParameter'
------------------------------------------------------------------------------------------------------
-- WF0084 - Mua hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0084' 
SET @ScreenType = 3 
SET @ScreenName = N'Mua hàng' 
SET @ScreenNameE = N'Purchase'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0085 - Chi phí Mua hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0085' 
SET @ScreenType = 3 
SET @ScreenName = N'Chi phí Mua hàng' 
SET @ScreenNameE = N'Purchase costs'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0086 - Thuế nhập khẩu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0086' 
SET @ScreenType = 3 
SET @ScreenName = N'Thuế nhập khẩu' 
SET @ScreenNameE = N'Import tax'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0087 - Bán hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0087' 
SET @ScreenType = 3 
SET @ScreenName = N'Thuế nhập khẩu' 
SET @ScreenNameE = N'Sales'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0088 - Hoa hồng bán hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0088' 
SET @ScreenType = 3 
SET @ScreenName = N'Hoa hồng bán hàng' 
SET @ScreenNameE = N'Sales commission'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0089 - Truy vấn xuất kho thành phẩm nhập nguyên liệu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0089' 
SET @ScreenType = 2 
SET @ScreenName = N'Truy vấn xuất kho thành phẩm, nhập nguyên liệu' 
SET @ScreenNameE = N'Query warehousing finished products, raw materials imported'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_ExportImport'
------------------------------------------------------------------------------------------------------
-- WF0090 - Cập nhật xuất kho thành phẩm nhập nguyên liệu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0090' 
SET @ScreenType = 3 
SET @ScreenName = N'Cập nhật xuất kho thành phẩm, nhập nguyên liệu' 
SET @ScreenNameE = N'Update warehousing finished products, raw materials imported'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0093 - Nhật ký nhập xuất hàng và VCNB
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0093' 
SET @ScreenType = 1 
SET @ScreenName = N'Nhật ký nhập xuất hàng và VCNB' 
SET @ScreenNameE = N'Log Inventory Import Export and Transport'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Invertory_Export'
------------------------------------------------------------------------------------------------------
-- WF0094 - Chuyển phiếu xuất kho
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0094' 
SET @ScreenType = 2
SET @ScreenName = N'Chuyển phiếu xuất kho' 
SET @ScreenNameE = N'Tranfer WareHouse'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_TranferWareHouse','23'
------------------------------------------------------------------------------------------------------
-- Sample_007 - Cập nhật phiếu kiểm định vật tư
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_007' 
SET @ScreenType = 2
SET @ScreenName = N'Cập nhật phiếu kiểm định vật tư' 
SET @ScreenNameE = N'Cập nhật phiếu kiểm định vật tư'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Inspection_Of_Materials_Purchased','-2'
------------------------------------------------------------------------------------------------------
-- Sample_008 - Phiếu kiểm định vật tư
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_008' 
SET @ScreenType = 3
SET @ScreenName = N'Phiếu kiểm định vật tư' 
SET @ScreenNameE = N'Phiếu kiểm định vật tư'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Inspection_Of_Materials_Purchased','-2'
------------------------------------------------------------------------------------------------------
-- Sample_009 - Chi tiết phiếu kiểm định vật tư
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'Sample_009' 
SET @ScreenType = 3
SET @ScreenName = N'Chi tiết phiếu kiểm định vật tư' 
SET @ScreenNameE = N'Chi tiết phiếu kiểm định vật tư'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0095 Phiếu yêu cầu nhập kho
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0095' 
SET @ScreenType = 3
SET @ScreenName = N'Phiếu yêu cầu nhập kho' 
SET @ScreenNameE = N'Repuest import warehouse'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_RequestImportWarehouse'
------------------------------------------------------------------------------------------------------
-- WF0096 Phiếu yêu cầu xuất kho
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0096' 
SET @ScreenType = 3
SET @ScreenName = N'Phiếu yêu cầu xuất kho' 
SET @ScreenNameE = N'Repuest export warehouse'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Request_Stock_Delivery'
------------------------------------------------------------------------------------------------------
-- WF0097 Phiếu yêu cầu vận chuyển nội bộ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0097' 
SET @ScreenType = 3
SET @ScreenName = N'Phiếu yêu cầu vận chuyển nội bộ' 
SET @ScreenNameE = N'Repuest stock internal tranfer'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Request_Stock_InternalTranfer'
------------------------------------------------------------------------------------------------------
-- WF0098 Phiếu yêu cầu nhập - xuất - VCNB
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0098' 
SET @ScreenType = 2
SET @ScreenName = N'Phiếu yêu cầu nhập - xuất - VCNB' 
SET @ScreenNameE = N'Request received delivery tranfer'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Request_ReceivedDeliveryTranfer'
------------------------------------------------------------------------------------------------------
-- WF0099 Duyệt phiếu yêu cầu nhập - xuất - VCNB
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0099' 
SET @ScreenType = 2
SET @ScreenName = N'Duyệt phiếu yêu cầu nhập - xuất - VCNB' 
SET @ScreenNameE = N'Browse Request received delivery tranfer'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Browse_Request_Stock_InternalTranfer'
------------------------------------------------------------------------------------------------------
-- WF0100 
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0100' 
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa phiếu yêu cầu nhập - xuất - VCNB' 
SET @ScreenNameE = N'Browse Request received delivery tranfer'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0101 
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0101' 
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phiếu chênh lệch' 
SET @ScreenNameE = N'List Voucher disparity'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Balance_Disparity'
------------------------------------------------------------------------------------------------------
-- WF0102 
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0102' 
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật phiếu chênh lệch' 
SET @ScreenNameE = N'Update Voucher disparity'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0103 Cảnh Báo Tồn Kho 
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0103' 
SET @ScreenType = 4
SET @ScreenName = N'Cảnh Báo Tồn Kho' 
SET @ScreenNameE = N'Waring WareHouse'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0104 Kế thừa lệnh sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0104' 
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa lệnh sản xuất' 
SET @ScreenNameE = N'Inherited Product order'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- WF0105 Kế thừa lệnh sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0105' 
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa lệnh sản xuất' 
SET @ScreenNameE = N'Inherited Product order'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'','47'
------------------------------------------------------------------------------------------------------

-- WF0106 Nhập thông tin thuế GTGT
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'WF0106' 
SET @ScreenType = 3
SET @ScreenName = N'Thông tin thuế GTGT' 
SET @ScreenNameE = N'Thông tin thuế GTGT'
EXEC AddScreen N'ASoftWM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------

SET NOCOUNT OFF
------------------------------------------------------------------------------------------------------