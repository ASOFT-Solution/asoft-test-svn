------------------------------------------------------------------------------------------------------
-- Fix Bổ sung phân quyền màn hình -- Module OP
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
-- OF0006 - Định nghĩa tham số
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0006'
SET @ScreenType = 4
SET @ScreenName = N'Định nghĩa tham số'
SET @ScreenNameE = N'Define parameter'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_DefineParameterPO'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_DefineParameterM'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_DefineParameterQ'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_DTCPSXE'
------------------------------------------------------------------------------------------------------
-- OF0034 - Duyệt đơn hàng (Đơn hàng bán)
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0034'
SET @ScreenType = 3
SET @ScreenName = N'Duyệt đơn hàng (Đơn hàng bán)'
SET @ScreenNameE = N'Accept order (sale order)'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusssiness_ExamineSaleOrder'
------------------------------------------------------------------------------------------------------
-- OF0059 - Duyệt đơn hàng (đơn hàng mua)
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0059'
SET @ScreenType = 3
SET @ScreenName = N'Duyệt đơn hàng (đơn hàng mua)'
SET @ScreenNameE = N'Accept order (purchase order)'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusssiness_ExaminePurchaseOrder'
------------------------------------------------------------------------------------------------------
-- OF0114 - Định nghĩa tham số đơn hàng bán tổng hợp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0114'
SET @ScreenType = 3
SET @ScreenName = N'Định nghĩa tham số đơn hàng bán tổng hợp'
SET @ScreenNameE = N'Define parameter Sale Order Master'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_DefineParameterSOTH'
------------------------------------------------------------------------------------------------------
-- OF0120 - Dinh nghia tham so
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0120'
SET @ScreenType = 3
SET @ScreenName = N'Định nghĩa tham số đơn hàng bán tổng hợp'
SET @ScreenNameE = N'Define parameter Sale Order Master'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_DefineVourcherDetail'
------------------------------------------------------------------------------------------------------
-- OF0123 - Tính hoa hồng đa cấp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0123'
SET @ScreenType = 4
SET @ScreenName = N'Tính hoa hồng đa cấp'
SET @ScreenNameE = N'Tính hoa hồng đa cấp'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Muti_Commission','20'
------------------------------------------------------------------------------------------------------
-- OF0124 - Danh sách hoa hồng theo đơn hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0124'
SET @ScreenType = 2
SET @ScreenName = N'Danh sách hoa hồng theo đơn hàng'
SET @ScreenNameE = N'Danh sách hoa hồng theo đơn hàng'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Bonus_Commissions','20'
------------------------------------------------------------------------------------------------------
-- OF0125 - Điều chỉnh giáng cấp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0125'
SET @ScreenType = 4
SET @ScreenName = N'Điều chỉnh giáng cấp'
SET @ScreenNameE = N'Adjust Downgrade'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Adjust_Downgrade','20'
------------------------------------------------------------------------------------------------------
-- OF0126 - Lập phiếu lệnh điều động
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0126'
SET @ScreenType = 3
SET @ScreenName = N'Lập phiếu lệnh điều động'
SET @ScreenNameE = N'Order Action'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Order_Action','38'
------------------------------------------------------------------------------------------------------
-- OF0127 - Danh mục phiếu lệnh điều động
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0127'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phiếu lệnh điều động'
SET @ScreenNameE = N'Order Action'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Order_Action','38'
------------------------------------------------------------------------------------------------------
-- OF0128 - Lập phiếu xác nhận hoàn thành
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0128'
SET @ScreenType = 3
SET @ScreenName = N'Lập phiếu xác nhận hoàn thành'
SET @ScreenNameE = N'Order Completed'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Order_Completed','38'
------------------------------------------------------------------------------------------------------
-- OF0129 - Danh mục phiếu xác nhận hoàn thành
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0129'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phiếu xác nhận hoàn thành'
SET @ScreenNameE = N'Order Completed'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Order_Completed','38'
------------------------------------------------------------------------------------------------------
-- OF0130 - Danh mục cam kết chiết khấu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0130'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục cam kết chiết khấu'
SET @ScreenNameE = N'List Commit Discount'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Commit_Discount','36'
------------------------------------------------------------------------------------------------------
-- OF0131 - Danh mục cam kết chiết khấu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0131'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật cam kết chiết khấu'
SET @ScreenNameE = N'Update Commit Discount'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0132 - Kế thừa YCDV Tổng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0132'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa YCDV Tổng'
SET @ScreenNameE = N'Inherit Master Request'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0133 - Quyết toán khách hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0133'
SET @ScreenType = 3
SET @ScreenName = N'Quyết toán khách hàng'
SET @ScreenNameE = N'Bussiness Object Commited'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Object_Commited','38'
------------------------------------------------------------------------------------------------------
-- OF0134 - Kế thừa dữ liệu từ YCDV và Lệnh điều động
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0134'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa dữ liệu từ YCDV và Lệnh điều động'
SET @ScreenNameE = N'Inherit Master Request'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0135 - Quyết toán tàu - sà lan
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0135'
SET @ScreenType = 2
SET @ScreenName = N'Quyết toán tàu - sà lan'
SET @ScreenNameE = N'Finalization Barge Ship'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Finalization_Barge_Ship','38'
------------------------------------------------------------------------------------------------------
-- OF0136 - Quyết toán tàu - sà lan
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0136'
SET @ScreenType = 3
SET @ScreenName = N'Quyết toán tàu - sà lan'
SET @ScreenNameE = N'Finalization Barge Ship'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Finalization_Barge_Ship','38'
------------------------------------------------------------------------------------------------------
-- OF0137 - Danh sách gửi email
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0137'
SET @ScreenType = 4
SET @ScreenName = N'Danh sách người nhận Email'
SET @ScreenNameE = N'Listing Email'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0138 - Kế thừa đơn hàng bán
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0138'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa đơn hàng bán'
SET @ScreenNameE = N'Inherit Sale'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0139 - Danh mục quyết toán đơn hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0139'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục quyết toán đơn hàng'
SET @ScreenNameE = N'List settle order'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Settle_Order','45'
------------------------------------------------------------------------------------------------------
-- OF0140 - Quyết toán đơn hàng bán
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0140'
SET @ScreenType = 3
SET @ScreenName = N'Quyết toán đơn hàng bán'
SET @ScreenNameE = N'Settle sale order'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Settle_Sale_Order','45'
------------------------------------------------------------------------------------------------------
-- OF0141 - Quyết toán đơn hàng mua
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0141'
SET @ScreenType = 3
SET @ScreenName = N'Quyết toán đơn hàng mua'
SET @ScreenNameE = N'Settle purchase order'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Settle_Purchase_Order','45'
------------------------------------------------------------------------------------------------------
-- OF0142 - Chọn quyết toán đơn hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0142'
SET @ScreenType = 4
SET @ScreenName = N'Chọn quyết toán đơn hàng'
SET @ScreenNameE = N'Inherit settle order'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OF0143 - Kế thừa đơn hàng bán
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0143'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa đơn hàng bán'
SET @ScreenNameE = N'Inherit Sale Order'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- OFSSSS - Cập nhật tình trạng đơn hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OFSSSS'
SET @ScreenType = 4
SET @ScreenName = N'Cập nhật tình trạng đơn hàng'
SET @ScreenNameE = N'Update status sale order'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusssiness_UpdateStatus'
------------------------------------------------------------------------------------------------------
-- OF0144 - Duyệt đơn hàng cấp 1
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0144'
SET @ScreenType = 3
SET @ScreenName = N'Duyệt đơn hàng cấp 1'
SET @ScreenNameE = N'Browser sale Order level 1'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusssiness_ExamineSaleOrderlevel1'
------------------------------------------------------------------------------------------------------
-- OF0145 - Duyệt đơn hàng cấp 2
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0145'
SET @ScreenType = 3
SET @ScreenName = N'Duyệt đơn hàng cấp 2'
SET @ScreenNameE = N'Browser sale Order level 2'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusssiness_ExamineSaleOrderlevel2'
------------------------------------------------------------------------------------------------------
-- OF0146 - Kết quả dự trù chi phí sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0146'
SET @ScreenType = 3
SET @ScreenName = N'Kết quả dự trù chi phí sản xuất'
SET @ScreenNameE = N'Result of  production cost estimate'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'','47'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'','47'
------------------------------------------------------------------------------------------------------
-- OF0147 - Cập nhật đối chiếu kho gợi ý mua nguyên vật liệu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0147'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật đối chiếu kho gợi ý mua nguyên vật liệu'
SET @ScreenNameE = N'Update collate warehouse suggest buying materials'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Suggest_buying_material','47'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Suggest_buying_material','47'
------------------------------------------------------------------------------------------------------
-- OF0148 - Đối chiếu kho gợi ý mua nguyên vật liệu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0148'
SET @ScreenType = 2
SET @ScreenName = N'Đối chiếu kho gợi ý mua nguyên vật liệu'
SET @ScreenNameE = N'Collate warehouse suggest buying materials'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Suggest_buying_material','47'
------------------------------------------------------------------------------------------------------
-- OF0045 - Dự trù kết quả sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0045'
SET @ScreenType = 3
SET @ScreenName = N'Dự trù chi phí sản xuất'
SET @ScreenNameE = N'Dự trù chi phí sản xuất'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusssiness_DTCPSX'
------------------------------------------------------------------------------------------------------
-- OF0045 - Danh mục Dự trù kết quả sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0042'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục Dự trù chi phí sản xuất'
SET @ScreenNameE = N'Danh mục Dự trù chi phí sản xuất'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_DTCPSX'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_DTCPSX'
------------------------------------------------------------------------------------------------------
-- OF0028 - Danh mục đơn hàng sản xuất
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0028' 
SET @ScreenType = 2
SET @ScreenName = N'Danh mục đơn hàng sản xuất'
SET @ScreenNameE = N'Danh mục đơn hàng sản xuất'
EXEC AddScreen N'ASoftM', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_MOrder'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_MOrder'
------------------------------------------------------------------------------------------------------
-- OF0154 - Tình hình thực hiện đơn hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'OF0154' 
SET @ScreenType = 1
SET @ScreenName = N'Tình hình thực hiện đơn hàng'
SET @ScreenNameE = N'Tình hình thực hiện đơn hàng'
EXEC AddScreen N'ASoftOP', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_TNDH', 54
------------------------------------------------------------------------------------------------------
SET NOCOUNT OFF
------------------------------------------------------------------------------------------------------