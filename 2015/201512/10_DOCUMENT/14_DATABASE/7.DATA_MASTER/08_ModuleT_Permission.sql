------------------------------------------------------------------------------------------------------
-- Fix Bổ sung phân quyền màn hình -- Module T
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
-- AF0261: Danh mục bút toán kết chuyển lương
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0261'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục bút toán kết chuyển lương'
SET @ScreenNameE = N'List of convert salary entries'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_ListConvertSalary'
------------------------------------------------------------------------------------------------------
-- AF0262: Kết chuyển bút toán lương tự động
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0262'
SET @ScreenType = 4
SET @ScreenName = N'Kết chuyển bút toán lương tự động'
SET @ScreenNameE = N'Transfer automatic entry wage'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0263: Kế thừa phiếu nhập kho
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0263'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa phiếu nhập kho'
SET @ScreenNameE = N'Inheriting warehousing note'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0257: Danh mục phiếu tạm thu chi qua ngân hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0257'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phiếu tạm thu chi qua ngân hàng'
SET @ScreenNameE = N'Temporary bank revenues and expenditures'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQueryTempByBank'
------------------------------------------------------------------------------------------------------
-- AF0258: Phiếu tạm thu qua ngân hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0258'
SET @ScreenType = 3
SET @ScreenName = N'Phiếu tạm thu qua ngân hàng'
SET @ScreenNameE = N'Making temporary revenue bonds through the bank'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussinessTempByBank_Received'
------------------------------------------------------------------------------------------------------
-- AF0259: Phiếu tạm chi qua ngân hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0259'
SET @ScreenType = 3
SET @ScreenName = N'Phiếu tạm chi qua ngân hàng'
SET @ScreenNameE = N'Temporary spending bill through bank'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussinessTempByBank_Payabled'
------------------------------------------------------------------------------------------------------
-- AF0260: Duyệt phiếu tạm thu chi qua ngân hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0260'
SET @ScreenType = 2
SET @ScreenName = N'Duyệt phiếu tạm thu chi qua ngân hàng'
SET @ScreenNameE = N'TBrowse through the bank revenue and expenditure'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussinessTempByBank_Examine'
------------------------------------------------------------------------------------------------------
-- AF0249: Tình hình xuất hóa đơn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0249'
SET @ScreenType = 1
SET @ScreenName = N'Tình hình xuất hóa đơn'
SET @ScreenNameE = N'Situation invoice'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportSituationInvoice','1,24'
------------------------------------------------------------------------------------------------------
-- AF0247: Cập nhật giá trị tham số
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0247'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật giá trị tham số'
SET @ScreenNameE = N'Update Parameter'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0265: Kế thừa phiếu xuất kho
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0265'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa phiếu xuất kho'
SET @ScreenNameE = N'Inheriting warehousing note'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
-----------------------------------------------------------------------------------------------------
-- AF0266: Kế thừa phiếu tạm thu / tạm chi qua ngân hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0266'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa phiếu tạm thu / tạm chi qua ngân hàng'
SET @ScreenNameE = N'Inherit temp paying voucher'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0273: Chuyển tạm ứng qua Nhân sự tiền lương
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0273'
SET @ScreenType = 4
SET @ScreenName = N'Chuyển tạm ứng qua Nhân sự tiền lương'
SET @ScreenNameE = N'Advanced Transfer to HRM'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_AdvancedTransferToHRM'
------------------------------------------------------------------------------------------------------
-- AF0274: Kế thừa phiếu bán hàng/mua hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0274'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa phiếu bán hàng/mua hàng'
SET @ScreenNameE = N'Inheriting Bill of sales/purchase'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0275: Kế thừa công nợ đầu kỳ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0275'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa công nợ đầu kỳ'
SET @ScreenNameE = N'Inheriting begin debt'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0276: Bỏ giải trừ công nợ phải thu, phải trả
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0276'
SET @ScreenType = 4
SET @ScreenName = N'Bỏ giải trừ công nợ phải thu, phải trả'
SET @ScreenNameE = N'Delete the eliminate debt of accounts receivable and payable'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0009: Giải trừ công nợ phải thu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0009'
SET @ScreenType = 4
SET @ScreenName = N'Giải trừ công nợ phải thu'
SET @ScreenNameE = N'Subtract receivable debt'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBusinessDebtReceiveDebt'
------------------------------------------------------------------------------------------------------
-- AF0277: Kế thừa hợp đồng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0277'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa hợp đồng'
SET @ScreenNameE = N'Inherit Contract'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0278:Báo cáo doanh số bán hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0278'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo doanh số bán hàng'
SET @ScreenNameE = N'Report Sale Revenue'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Sales_Revenue','16'
------------------------------------------------------------------------------------------------------
-- AF0280: Danh mục kết chuyển phiếu bán hàng từ POS
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0280'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục phiếu bán hàng từ POS'
SET @ScreenNameE = N'List of Voucher From POS'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_POSVoucherTransfer'
------------------------------------------------------------------------------------------------------
-- AF0281: Kết chuyển phiếu bán hàng từ POS
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0281'
SET @ScreenType = 3
SET @ScreenName = N'Phiếu kết chuyển bán hàng từ POS'
SET @ScreenNameE = N'Transfer Voucher From POS'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0282: Chọn phiếu bán hàng từ POS
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0281'
SET @ScreenType = 4
SET @ScreenName = N'Chọn phiếu bán hàng từ POS'
SET @ScreenNameE = N'Choose Voucher from POS'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0283: Báo cáo công nợ phải thu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0283'
SET @ScreenType = 4
SET @ScreenName = N'Báo cáo công nợ phải thu'
SET @ScreenNameE = N'Report Credit '
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0287: Báo cáo giá mua thực tế theo nhà cung cấp
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF028701'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo giá mua thực tế theo nhà cung cấp'
SET @ScreenNameE = N'Report Purchase analysis provided '
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Purchase_Analysis_Provided'
------------------------------------------------------------------------------------------------------
-- AF0287: Báo cáo giá mua thực tế theo hóa đơn
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF028702'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo giá mua thực tế theo hóa đơn'
SET @ScreenNameE = N'Report Purchase analysis invoice '
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Purchase_Analysis_Invoice'
------------------------------------------------------------------------------------------------------
-- AF0287: Báo cáo giá mua thực tế theo kỳ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0287'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo giá mua thực tế theo kỳ'
SET @ScreenNameE = N'Report Purchase analysis Period'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Purchase_Anlysis_Period'
------------------------------------------------------------------------------------------------------
-- AF0288: Phân tích doanh thu theo thời gian
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0288'
SET @ScreenType = 1
SET @ScreenName = N'Phân tích doanh thu theo thời gian'
SET @ScreenNameE = N'Report Purchase analysis Period'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_SalesSturnoverTime'
------------------------------------------------------------------------------------------------------
-- AF0289: Danh mục mức thuế bảo vệ môi trường
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0289'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục mức thuế bảo vệ môi trường'
SET @ScreenNameE = N'List taxes enviromental'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Taxes_Enviromental'
------------------------------------------------------------------------------------------------------
-- AF0290: Khai báo mức thuế bảo vệ môi trường
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0290'
SET @ScreenType = 3
SET @ScreenName = N'Khai báo mức thuế bảo vệ môi trường'
SET @ScreenNameE = N'Create taxes enviromental'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0291: Tờ khai thuế bảo vệ môi trường
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0291'
SET @ScreenType = 3
SET @ScreenName = N'Tờ khai thuế bảo vệ môi trường'
SET @ScreenNameE = N'Taxes enviromental'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Taxes_Environmental'
------------------------------------------------------------------------------------------------------
-- AF0292: Kế thừa quyết toán khách hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0292'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa quyết toán khách hàng'
SET @ScreenNameE = N'Inherit finalization customer'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0293: Chi tiết Nợ phải thu 2
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0293'
SET @ScreenType = 1
SET @ScreenName = N'Chi tiết Nợ phải thu 2'
SET @ScreenNameE = N'Detail received amount'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportDebitDetailReceived2','16'
------------------------------------------------------------------------------------------------------
-- AF0294: Chi tiết nợ phải trả 2
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0294'
SET @ScreenType = 1
SET @ScreenName = N'Chi tiết nợ phải trả 2'
SET @ScreenNameE = N'Details Liabilities'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportDebitDetailPayable2','16'
------------------------------------------------------------------------------------------------------
-- AF0295: Báo cáo tổng hợp Nợ phải thu 2
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0295'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo tổng hợp Nợ phải thu 2'
SET @ScreenNameE = N'Report synthetic debts 2'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportDebitGroupReceived2','16'
------------------------------------------------------------------------------------------------------
-- AF0296: Báo cáo tổng hợp Nợ phải trả 2
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0296'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo tổng hợp Nợ phải trả 2'
SET @ScreenNameE = N'General payable to customer report 2'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportDebitGroupPayable2','16'
------------------------------------------------------------------------------------------------------
-- AF0297: Chi tiết tình hình thanh toán Công Nợ phải thu 2
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0297'
SET @ScreenType = 1
SET @ScreenName = N'Chi tiết tình hình thanh toán Công Nợ phải thu 2'
SET @ScreenNameE = N'Details solution of payable debt 2'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportDebitReceiableStatus2','16'
------------------------------------------------------------------------------------------------------
-- AF0298: Chi tiết tình hình thanh toán Nợ phải trả 2
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0298'
SET @ScreenType = 1
SET @ScreenName = N'Chi tiết tình hình thanh toán Nợ phải trả 2'
SET @ScreenNameE = N'Details of payable debt 2'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportDebitPayableStatus2','16'
------------------------------------------------------------------------------------------------------
-- AF0299: Kế thừa quyết toán tàu - sà lan
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0299'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa quyết toán tàu - sà lan'
SET @ScreenNameE = N'Inherit finalization ship'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0300: Truy vấn tài khoản
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0300'
SET @ScreenType = 4
SET @ScreenName = N'Truy vấn tài khoản'
SET @ScreenNameE = N'Query account'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_AccountID','40'
------------------------------------------------------------------------------------------------------
-- AF0301: Quản lý lịch sử mặt hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0301'
SET @ScreenType = 4
SET @ScreenName = N'Quản lý lịch sử mặt hàng'
SET @ScreenNameE = N'Query inventory history manage'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_HistoryInventory','36'
------------------------------------------------------------------------------------------------------
-- AF0302: Báo cáo tài chính (QĐ 15/2006/QĐ-BTC)
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0302'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo tài chính (QĐ 15/2006/QĐ-BTC)'
SET @ScreenNameE = N'Report Balance Account'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Finance_152006BTC'
------------------------------------------------------------------------------------------------------
-- AF0303: Danh mục thiết lập tờ khai thuế bảo vệ môi trường
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0303'
SET @ScreenType = 2
SET @ScreenName = N'Danh mục thiết lập tờ khai thuế bảo vệ môi trường'
SET @ScreenNameE = N'List setting protect tax enviroment'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_Tax_Protect_Environment'
------------------------------------------------------------------------------------------------------
-- AF0304: Thiết lập tờ khai thuế bảo vệ môi trường
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0304'
SET @ScreenType = 3
SET @ScreenName = N'Thiết lập tờ khai thuế bảo vệ môi trường'
SET @ScreenNameE = N'Setting protect tax enviroment'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0305: Tờ khai thuế bảo vệ môi trường
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0305'
SET @ScreenType = 2
SET @ScreenName = N'Tờ khai thuế bảo vệ môi trường'
SET @ScreenNameE = N'Listing of Enviroment taxes'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0306: Kế thừa quyết toán đơn hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0306'
SET @ScreenType = 4
SET @ScreenName = N'Kế thừa quyết toán đơn hàng'
SET @ScreenNameE = N'Inherit settle order'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0185: Tờ khai thuế GTGT (01/GTGT)
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0185'
SET @ScreenType = 2
SET @ScreenName = N'Tờ khai thuế GTGT (01/GTGT)'
SET @ScreenNameE = N'VAT'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportTaxVATDeclare'
------------------------------------------------------------------------------------------------------
-- AF0307: Cập nhật tờ khai thuế GTGT (01/GTGT)
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0307'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật tờ khai thuế GTGT (01/GTGT)'
SET @ScreenNameE = N'Update VAT'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0308: Báo cáo kết quả sản xuất kinh doanh nhiều kỳ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0308'
SET @ScreenType = 1
SET @ScreenName = N'Báo cáo kết quả sản xuất kinh doanh nhiều kỳ'
SET @ScreenNameE = N'Báo cáo kết quả sản xuất kinh doanh nhiều kỳ'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReportFinanceReportIncomeStatementPeriods'
------------------------------------------------------------------------------------------------------
-- AF0309: Danh mục tờ khai thuế TTĐB
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0309'
SET @ScreenType = 2
SET @ScreenName = N'DANH MỤC KHAI THUẾ TIÊU THỤ ĐẶC BIỆT'
SET @ScreenNameE = N'DANH MỤC KHAI THUẾ TIÊU THỤ ĐẶC BIỆT'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Taxes_SET'
------------------------------------------------------------------------------------------------------
-- AF0310: Cập nhật tờ khai thuế TTĐB
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0310'
SET @ScreenType = 3
SET @ScreenName = N'CẬP NHẬT TỜ KHAI THUẾ TIÊU THỤ ĐẶC BIỆT'
SET @ScreenNameE = N'CẬP NHẬT KHAI THUẾ TIÊU THỤ ĐẶC BIỆT'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Taxes_SET'
------------------------------------------------------------------------------------------------------
-- AF0311: Danh mục tờ khai thuế Tài nguyên
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0311'
SET @ScreenType = 2
SET @ScreenName =  N'DANH MỤC KHAI THUẾ TÀI NGUYÊN'
SET @ScreenNameE = N'DANH MỤC KHAI THUẾ TÀI NGUYÊN'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Taxes_NRT'
------------------------------------------------------------------------------------------------------
-- AF0312: Tờ khai thuế tài nguyên
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0312'
SET @ScreenType = 3
SET @ScreenName = N'CẬP NHẬT TỜ KHAI THUẾ TÀI NGUYÊN'
SET @ScreenNameE = N'CẬP NHẬT TỜ KHAI THUẾ TÀI NGUYÊN'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0313: Tờ khai quyết toán thuế tài nguyên
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0313'
SET @ScreenType = 3
SET @ScreenName = N'CẬP NHẬT TỜ KHAI QUYẾT TOÁN THUẾ TÀI NGUYÊN'
SET @ScreenNameE = N'CẬP NHẬT TỜ KHAI QUYẾT TOÁN THUẾ TÀI NGUYÊN'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0246: Định nghĩa tham số
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0246'
SET @ScreenType = 2
SET @ScreenName = N'Định nghĩa tham số'
SET @ScreenNameE = N'Định nghĩa tham số'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_PrintedInvoice'
------------------------------------------------------------------------------------------------------

-- AF0314: Phân bổ chi phí mua hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0314'
SET @ScreenType = 4
SET @ScreenName = N'Phân bổ chi phí mua hàng'
SET @ScreenNameE = N'Phân bổ chi phí mua hàng'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuBussiness_Allocation_purchase_cost'
------------------------------------------------------------------------------------------------------
-- AF0315: Cập nhật phân bổ chi phí mua hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0315'
SET @ScreenType = 3
SET @ScreenName = N'Cập nhật phân bổ chi phí mua hàng'
SET @ScreenNameE = N'Cập nhật phân bổ chi phí mua hàng'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0316: danh mục phân bổ chi phí mua hàng
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0316'
SET @ScreenType = 4
SET @ScreenName = N'Danh mục phân bổ chi phí mua hàng'
SET @ScreenNameE = N'Danh mục phân bổ chi phí mua hàng'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuQuery_Result_allocation_Purchase_Cost'
------------------------------------------------------------------------------------------------------
-- AF0317: Danh mục tờ khai thuế nhà thầu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0317'
SET @ScreenType = 2
SET @ScreenName =  N'DANH MỤC TỜ KHAI THUẾ TÀI NGUYÊN'
SET @ScreenNameE = N'DANH MỤC TỜ KHAI THUẾ TÀI NGUYÊN'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuReport_Taxes_WT'
------------------------------------------------------------------------------------------------------
-- AF0318: Tờ khai thuế nhà thầu
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0318'
SET @ScreenType = 3
SET @ScreenName = N'CẬP NHẬT TỜ KHAI THUẾ NHÀ THẦU'
SET @ScreenNameE = N'CẬP NHẬT TỜ KHAI THUẾ NHÀ THẦU'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N''
------------------------------------------------------------------------------------------------------
-- AF0319: Tập hợp bút toán hình thành TSCĐ
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0319'
SET @ScreenType = 4
SET @ScreenName = N'Tập hợp bút toán hình thành TSCĐ'
SET @ScreenNameE = N'Tập hợp bút toán hình thành TSCĐ'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'',50
------------------------------------------------------------------------------------------------------
-- AF0320: Danh mục tỷ lệ phân bổ đơn vị ngành
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0320'
SET @ScreenType = 2 
SET @ScreenName = N'Danh mục tỷ lệ phân bổ đơn vị ngành'
SET @ScreenNameE = N'Danh mục tỷ lệ phân bổ đơn vị ngành'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'mnuList_PercantageSectorUnits',52
------------------------------------------------------------------------------------------------------

-- AF0320: Danh mục tỷ lệ phân bổ đơn vị ngành
------------------------------------------------------------------------------------------------------
SET @ScreenID = N'AF0321'
SET @ScreenType = 3 
SET @ScreenName = N'Cập nhật tỷ lệ phân bổ đơn vị ngành'
SET @ScreenNameE = N'Cập nhật tỷ lệ phân bổ đơn vị ngành'
EXEC AddScreen N'ASoftT', @ScreenID, @ScreenType, @ScreenName, @ScreenNameE, N'',52
------------------------------------------------------------------------------------------------------
--Xóa những dòng lỗi ngôn ngữ
delete FROM AT1404 WHERE ScreenName LIKE '%?%'

SET NOCOUNT OFF
------------------------------------------------------------------------------------------------------