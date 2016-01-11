-- <Summary>
---- Add Report
-- <History>
---- Create on 05/07/2012 by Bảo Anh
---- Modified on 07/10/2014 by Lê Thị Hạnh
---- Modified on 22/04/2015 by Lê Thị Hạnh: Bổ sung IN PHIẾU GIAO HÀNG [LAVO] 
---- Modified on 29/07/2013 by Lê Thị Thu Hiền: Báo cáo có bổ sung thêm trường 
---- Modified on 29/07/2013 by Lê Thị Thu Hiền: Mẫu AR7602.rpt là mẫu dùng để In Thiết lập báo cáo chứ không phải dùng để In Báo cáo thiết lập. 
---- Modified on 23/04/2013 by Le Thi Thu Hien 
---- Modified on 10/10/2012 by Lê Thị Thu Hiền: Không WHERE đơn vị nữa vì In nhiều đơn vị
---- Modified on 05/11/2015 by Tiểu Mai: Bổ sung thêm mẫu report AR7010.
---- Modified on 10/11/2015 by Phương Thảo: Bổ sung thêm mẫu report AR0295 - Thuế nhà thầu.
---- Modified on 10/11/2015 by Phương Thảo: Bổ sung thêm mẫu report AR0295 - Thuế nhà thầu.
---- <Example>

DECLARE @CustomerName INT

IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#CustomerName')) 
DROP TABLE #CustomerName
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)
---- Add AR2016
EXEC AP8888 @GroupID = N'G05', @ModuleID = 'AsoftWM', @ReportID = N'AR2016', @ReportName = N'Mẫu 1',
	 @ReportNameE = N'Form 1', @ReportTitle = N'Phiếu nhập kho', @ReportTitleE = N'Receiving voucher',
	 @Description = N'NHẬP KHO', @DescriptionE = N'RECEIVING', @Type = 26, @SQLstring = N'', @Orderby = N' Order by Orders',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR6013
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'AsoftT', @ReportID = N'AR6013', @ReportName = N'Báo cáo tổng hợp theo mã phân tích',
	 @ReportNameE = N'General report by analysis code', @ReportTitle = N'BÁO CÁO TỔNG HỢP THEO MÃ PHÂN TÍCH', 
	 @ReportTitleE = N'GENERAL REPORT BY ANALYSIS CODE', @Description = N'BÁO CÁO TỔNG HỢP THEO MÃ PHÂN TÍCH', 
	 @DescriptionE = N'GENERAL REPORT BY ANALYSIS CODE', @Type = 99, @SQLstring = N'', @Orderby = N'Order by AnaID, VoucherDate, VoucherNo',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0287
EXEC AP8888 @GroupID = N'G07', @ModuleID = 'AsoftT', @ReportID = N'AR0287', @ReportName = N'Báo cáo so sánh giá các nhà cung cấp',
	 @ReportNameE = N'Price compare of suppliers', @ReportTitle = N'BÁO CÁO SO SÁNH GIÁ CÁC NHÀ CUNG CẤP', 
	 @ReportTitleE = N'PRICE COMPARE OF SUPPLIERS', @Description = N'BÁO CÁO SO SÁNH GIÁ CÁC NHÀ CUNG CẤP', 
	 @DescriptionE = N'PRICE COMPARE OF SUPPLIERS', @Type = 31, @SQLstring = N'', @Orderby = N'Order by InventoryID, ObjectID',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0288
EXEC AP8888 @GroupID = N'G07', @ModuleID = 'AsoftT', @ReportID = N'AR0288', @ReportName = N'Báo cáo so sánh giá theo hóa đơn',
	 @ReportNameE = N'Price compare of invoice', @ReportTitle = N'BÁO CÁO SO SÁNH GIÁ THEO HÓA ĐƠN', 
	 @ReportTitleE = N'PRICE COMPARE OF INVOICE', @Description = N'BÁO CÁO SO SÁNH GIÁ THEO HÓA ĐƠN', 
	 @DescriptionE = N'PRICE COMPARE OF INVOICE', @Type = 32, @SQLstring = N'', @Orderby = N'Order by InventoryID, ObjectID',
	 @TEST = 0, @TableID = N'AT8888'
---- Add WR20272
EXEC AP8888 @GroupID = N'G05', @ModuleID = 'AsoftWM', @ReportID = N'WR20272', @ReportName = N'Mẫu 4',
	 @ReportNameE = N'FORM 4', @ReportTitle = N'FORM 4', 
	 @ReportTitleE = N'FORM 4', @Description = N'XUẤT KHO', 
	 @DescriptionE = N'DELIVERING', @Type = 27, @SQLstring = N'', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'AT8888'
---- Add WR20271
EXEC AP8888 @GroupID = N'G05', @ModuleID = 'AsoftWM', @ReportID = N'WR20271', @ReportName = N'Mẫu 3',
	 @ReportNameE = N'FORM 3', @ReportTitle = N'FORM 3', 
	 @ReportTitleE = N'FORM 3', @Description = N'XUẤT KHO', 
	 @DescriptionE = N'DELIVERING', @Type = 27, @SQLstring = N'', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0310A
EXEC AP8888 @GroupID = N'G03', @ModuleID = 'ASoftT', @ReportID = N'AR0310A', @ReportName = N'Báo cáo chi tiết tình hình thanh toán',
	 @ReportNameE = N'The report details of payment situation', @ReportTitle = N'BÁO CÁO CHI TIẾT TÌNH HÌNH THANH TOÁN', 
	 @ReportTitleE = N'THE REPORT DETAILS OF PAYMENT SITUATION', @Description = N'BÁO CÁO CHI TIẾT TÌNH HÌNH THANH TOÁN', 
	 @DescriptionE = N'THE REPORT DETAILS OF PAYMENT SITUATION', @Type = 3, 
	 @SQLstring = N'Select * From AV0310  where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', 
	 @Orderby = N'Order by GroupID, VoucherDate, VoucherNo, TransactionTypeID,Orders',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR1020 (mẫu cũ)
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'ASoftT', @ReportID = N'AR1020', @ReportName = N'Thông tin hợp đồng',
	 @ReportNameE = N'Contract information', @ReportTitle = N'THÔNG TIN HỢP ĐỒNG', 
	 @ReportTitleE = N'CONTRACT INFORMATION', @Description = N'Thông tin hợp đồng', 
	 @DescriptionE = N'Contract information', @Type = 120, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR1020_A
IF @CustomerName = 20 --- Customize Sinolife
BEGIN
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'ASoftT', @ReportID = N'AR1020_A', @ReportName = N'Hợp đồng chuyển nhượng',
	 @ReportNameE = N'Transfer contract', @ReportTitle = N'HỢP ĐỒNG CHUYỂN NHƯỢNG', 
	 @ReportTitleE = N'TRANSFER CONTRACT', @Description = N'Hợp đồng chuyển nhượng', 
	 @DescriptionE = N'Transfer contract', @Type = 120, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR1020_B
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'ASoftT', @ReportID = N'AR1020_B', @ReportName = N'Bảng thanh toán hàng tháng',
	 @ReportNameE = N'Monthly payment sheet', @ReportTitle = N'MONTHLY PAYMENT SHEET', 
	 @ReportTitleE = N'MONTHLY PAYMENT SHEET', @Description = N'Monthly payment sheet', 
	 @DescriptionE = N'Monthly payment sheet', @Type = 120, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'	
END
---- Add WR20262
EXEC AP8888 @GroupID = N'G05', @ModuleID = 'AsoftWM', @ReportID = N'WR20262', @ReportName = N'Mẫu 4',
	 @ReportNameE = N'Form 4', @ReportTitle = N'Form 4', @ReportTitleE = N'Form 4', @Description = N'NHẬP KHO', 
	 @DescriptionE = N'RECEIVING', @Type = 26, @SQLstring = N'', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3032B
EXEC AP8888 @GroupID = N'G07', @ModuleID = 'ASoftT', @ReportID = N'AR3032B', @ReportName = N'Báo cáo hàng bán trả lại (nhóm theo khu vực - đối tượng)',
	 @ReportNameE = N'Return Goods Group by Area - Object', @ReportTitle = N'BÁO CÁO HÀNG BÁN TRẢ LẠI', @ReportTitleE = N'RETURN GOODS', @Description = N'Báo cáo hàng bán trả lại (nhóm theo khu vực - đối tượng)', 
	 @DescriptionE = N'Return Goods Group by Area - Object', @Type = 12, @SQLstring = N'Select * From AV3052  where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', @Orderby = N'Order by S2, ObjectID, VoucherDate, VoucherNo, InventoryID',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR7002
EXEC AP8888 @GroupID = N'G05', @ModuleID = 'AsoftWM', @ReportID = N'AR7002', @ReportName = N'Báo cáo chi tiết nhập xuất tồn theo mặt hàng',
	 @ReportNameE = N'General report of receiving - delivering - remaining', @ReportTitle = N'BÁO CÁO CHI TIẾT NHẬP XUẤT TỒN THEO MẶT HÀNG', @ReportTitleE = N'RETURN GOODS', @Description = N'REPORT OF RECEIVING - DELIVERING - REMAINING', 
	 @DescriptionE = N'REPORT OF RECEIVING - DELIVERING - REMAINING ACCORDING', @Type = 39, @SQLstring = N'Select * from AV2009 where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', @Orderby = N'Order by InventoryID',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0249
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'ASoftT', @ReportID = N'AR0249', @ReportName = N'Báo cáo theo dõi tình hình xuất hóa đơn',
	 @ReportNameE = N'Report situation invoice', @ReportTitle = N'BÁO CÁO THEO DÕI TÌNH HÌNH XUẤT HÓA ĐƠN', @ReportTitleE = N'REPORT SITUATION INVOICE',
	 @Description = N'Báo cáo theo dõi tình hình xuất hóa đơn', @DescriptionE = N'Report situation invoice', @Type = 3, 
	 @SQLstring = N'SELECT * FROM AV0249 WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', @Orderby = N'ORDER BY DivisionID, VoucherDate, VoucherNo, OrderID, InventoryID',
	 @TEST = 0, @TableID = N'AT8888'
---- Add WR20261
EXEC AP8888 @GroupID = N'G05', @ModuleID = 'AsoftWM', @ReportID = N'WR20261', @ReportName = N'Mẫu 3',
	 @ReportNameE = N'FORM 3', @ReportTitle = N'FORM 3', @ReportTitleE = N'FORM 3',
	 @Description = N'NHẬP KHO', @DescriptionE = N'RECEIVING', @Type = 26, @SQLstring = N'', @Orderby = N' Order by Orders',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0310B
EXEC AP8888 @GroupID = N'G03', @ModuleID = 'AsoftT', @ReportID = N'AR0310B', @ReportName = N'Bảng kê đối chiếu công nợ theo tuổi nợ',
	 @ReportNameE = N'List of compare debt by age', @ReportTitle = N'BẢNG KÊ ĐỐI CHIẾU CÔNG NỢ THEO TUỔI NỢ', @ReportTitleE = N'LIST OF COMPARE DEBT BY AGE',
	 @Description = N'BẢNG KÊ ĐỐI CHIẾU CÔNG NỢ THEO TUỔI NỢ', @DescriptionE = N'LIST OF COMPARE DEBT BY AGE', @Type = 15, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0290
EXEC AP8888 @GroupID = N'G07', @ModuleID = 'AsoftT', @ReportID = N'AR0290', @ReportName = N'Doanh thu theo thời gian (so sánh kỳ này - kỳ trước)',
	 @ReportNameE = N'Sales in times (compare this period with last period)', @ReportTitle = N'BÁO CÁO DOANH THU THEO THỜI GIAN', @ReportTitleE = N'SALES IN TIMES',
	 @Description = N'DOANH THU THEO THỜI GIAN (SO SÁNH KỲ NÀY - KỲ TRƯỚC)', @DescriptionE = N'SALES IN TIMES (COMPARE THIS PERIOD - LAST PERIOD)', @Type = 34, @SQLstring = N'', @Orderby = N'Order by InventoryID',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0291
EXEC AP8888 @GroupID = N'G07', @ModuleID = 'AsoftT', @ReportID = N'AR0291', @ReportName = N'Doanh thu theo thời gian (so sánh nhiều kỳ)',
	 @ReportNameE = N'Sales in times (compare many periods)', @ReportTitle = N'BÁO CÁO DOANH THU THEO THỜI GIAN', @ReportTitleE = N'SALES IN TIMES',
	 @Description = N'DOANH THU THEO THỜI GIAN (SO SÁNH NHIỀU KỲ)', @DescriptionE = N'SALES IN TIMES (COMPARE MANY PERIODS)', @Type = 35, @SQLstring = N'', @Orderby = N'Order by InventoryID,MonthYear',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0292
EXEC AP8888 @GroupID = N'G07', @ModuleID = 'AsoftT', @ReportID = N'AR0292', @ReportName = N'Doanh thu theo thời gian (so sánh nhiều kỳ, nhóm theo loại hàng)',
	 @ReportNameE = N'Sales in times (compare many periods, group by inventory type)', @ReportTitle = N'BÁO CÁO DOANH THU THEO THỜI GIAN', @ReportTitleE = N'SALES IN TIMES',
	 @Description = N'DOANH THU THEO THỜI GIAN (SO SÁNH NHIỀU KỲ, NHÓM THEO LOẠI HÀNG)', @DescriptionE = N'SALES IN TIMES (COMPARE MANY PERIODS, GROUP BY INVENTORY TYPE)', @Type = 35, @SQLstring = N'', @Orderby = N'Order by InventoryTypeID,InventoryID,MonthYear',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0293
EXEC AP8888 @GroupID = N'G07', @ModuleID = 'AsoftT', @ReportID = N'AR0293', @ReportName = N'Doanh thu theo thời gian (phân tích theo mặt hàng)',
	 @ReportNameE = N'Sales in times (lost & profit by inventory)', @ReportTitle = N'PHÂN TÍCH DOANH THU THEO MẶT HÀNG', @ReportTitleE = N'LOST & PROFIT BY INVENTORY',
	 @Description = N'DOANH THU THEO THỜI GIAN (PHÂN TÍCH THEO MẶT HÀNG)', @DescriptionE = N'SALES IN TIMES (LOST & PROFIT BY INVENTORY)', 
	 @Type = 36, @SQLstring = N'', @Orderby = N'Order by InventoryID',
	 @TEST = 0, @TableID = N'AT8888'
----AR0258A: Mẫu 1 - PHIẾU THU QUA NGÂN HÀNG
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR0258A', @ReportName = N'Phiếu thu qua ngân hàng (Mẫu 1)',
	 @ReportNameE = N'Receipts through banks (From 1)', @ReportTitle = N'PHIẾU THU QUA NGÂN HÀNG', @ReportTitleE = N'RECEIPTS THROUGH BANKS',
	 @Description = N'Phiếu thu qua ngân hàng (Mẫu 1)', @DescriptionE = N'Receipts through banks (From 1)', 
	 @Type = 4, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0258C: Mẫu 3 - PHIẾU KẾ TOÁN
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR0258C', @ReportName = N'Phiếu kế toán',
	 @ReportNameE = N'Voucher Accounting', 
	 @ReportTitle = N'PHIẾU KẾ TOÁN', @ReportTitleE = N'Voucher Accounting',
	 @Description = N'Phiếu kế toán', @DescriptionE = N'Voucher Accounting', 
	 @Type = 4, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3501: Mẫu 1 - ỦY NHIỆM CHI
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3501', 
	 @ReportName = N'Ủy nhiệm chi', @ReportNameE = N'Authoridez Payment', 
	 @ReportTitle = N'ỦY NHIỆM CHI', @ReportTitleE = N'AUTHORIZED PAYMENT',
	 @Description = N'Ủy nhiệm chi', @DescriptionE = N'Authoridez Payment', 
	 @Type = 5, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3502: Mẫu 2 - PHIẾU CHI QUA NGÂN HÀNG
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3502', 
	 @ReportName = N'Phiếu chi qua ngân hàng', @ReportNameE = N'Payment through banks', 
	 @ReportTitle = N'PHIẾU CHI QUA NGÂN HÀNG', @ReportTitleE = N'PAYMENT THROUGH BANKS',
	 @Description = N'Phiếu chi qua ngân hàng', @DescriptionE = N'Payment through banks', 
	 @Type = 5, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3503: Mẫu 3 - PHIẾU KẾ TOÁN
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3503', 
	 @ReportName = N'Phiếu kế toán', @ReportNameE = N'Voucher Accounting', 
	 @ReportTitle = N'PHIẾU KẾ TOÁN', @ReportTitleE = N'VOUCHER ACCOUNTING',
	 @Description = N'Phiếu kế toán', @DescriptionE = N'Voucher Accounting', 
	 @Type = 5, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR8001: DANH SÁCH PHIẾU THU QUA NGÂN HÀNG
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR8001', 
	 @ReportName = N'Danh sách phiếu thu', @ReportNameE = N'Receipts list', 
	 @ReportTitle = N'PHIẾU THU QUA NGÂN HÀNG', @ReportTitleE = N'RECEIPTS THROUGH BANKS',
	 @Description = N'Danh sách phiếu thu', @DescriptionE = N'Receipts list', 
	 @Type = 9, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR8002: DANH SÁCH PHIẾU CHI QUA NGÂN HÀNG
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR8002', 
	 @ReportName = N'Danh sách phiếu chi', @ReportNameE = N'Payment list', 
	 @ReportTitle = N'PHIẾU CHI QUA NGÂN HÀNG', @ReportTitleE = N'PAYMENT THROUGH BANKS',
	 @Description = N'Danh sách phiếu chi', @DescriptionE = N'Payment list', 
	 @Type = 9, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888' 
---- Add AR3043: Mẫu 1 - PHIẾU THU QUA NGÂN HÀNG
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3043', 
	 @ReportName = N'Phiếu thu qua ngân hàng (Mẫu 1)', @ReportNameE = N'Receipts through banks (From 1)', 
	 @ReportTitle = N'PHIẾU THU QUA NGÂN HÀNG', @ReportTitleE = N'RECEIPTS THROUGH BANKS',
	 @Description = N'Phiếu thu qua ngân hàng (Mẫu 1)', @DescriptionE = N'Receipts through banks (From 1)', 
	 @Type = 6, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888' 
---- Add AR3053: Mẫu 2 - PHIẾU THU QUA NGÂN HÀNG
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3053', 
	 @ReportName = N'Phiếu thu qua ngân hàng (Mẫu 2)', @ReportNameE = N'Receipts through banks (From 2)', 
	 @ReportTitle = N'PHIẾU THU QUA NGÂN HÀNG', @ReportTitleE = N'RECEIPTS THROUGH BANKS',
	 @Description = N'Phiếu thu qua ngân hàng (Mẫu 2)', @DescriptionE = N'Receipts through banks (From 2)', 
	 @Type = 6, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3073: Mẫu 3 - PHIẾU KẾ TOÁN
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3073', 
	 @ReportName = N'Phiếu kế toán', @ReportNameE = N'Voucher Accounting', 
	 @ReportTitle = N'PHIẾU KẾ TOÁN', @ReportTitleE = N'VOUCHER ACCOUNTING',
	 @Description = N'Phiếu kế toán', @DescriptionE = N'Voucher Accounting', 
	 @Type = 6, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3046: Mẫu 1 - ỦY NHIỆM CHI
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3046', 
	 @ReportName = N'Ủy nhiệm chi', @ReportNameE = N'Authoridez Payment', 
	 @ReportTitle = N'ỦY NHIỆM CHI', @ReportTitleE = N'AUTHORIZED PAYMENT',
	 @Description = N'Ủy nhiệm chi', @DescriptionE = N'Authoridez Payment', 
	 @Type = 7, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3047: Mẫu 2 - PHIẾU CHI QUA NGÂN HÀNG
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3047', 
	 @ReportName = N'Phiếu chi qua ngân hàng (Mẫu 2)', @ReportNameE = N'Payment through banks (Form 2)', 
	 @ReportTitle = N'PHIẾU CHI QUA NGÂN HÀNG', @ReportTitleE = N'PAYMENT THROUGH BANKS',
	 @Description = N'Phiếu chi qua ngân hàng (Mẫu 2)', @DescriptionE = N'Payment through banks (Form 2)', 
	 @Type = 7, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3048: Mẫu 3 - PHIẾU CHI QUA NGÂN HÀNG
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3048', 
	 @ReportName = N'Phiếu chi qua ngân hàng (Mẫu 3)', @ReportNameE = N'Payment through banks (Form 3)', 
	 @ReportTitle = N'PHIẾU CHI QUA NGÂN HÀNG', @ReportTitleE = N'PAYMENT THROUGH BANKS',
	 @Description = N'Phiếu chi qua ngân hàng (Mẫu 3)', @DescriptionE = N'Payment through banks (Form 3)', 
	 @Type = 7, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3049: Mẫu 4 - PHIẾU CHI QUA NGÂN HÀNG
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3049', 
	 @ReportName = N'Phiếu chi qua ngân hàng (Mẫu 4)', @ReportNameE = N'Payment through banks (Form 4)', 
	 @ReportTitle = N'PHIẾU CHI QUA NGÂN HÀNG', @ReportTitleE = N'PAYMENT THROUGH BANKS',
	 @Description = N'Phiếu chi qua ngân hàng (Mẫu 4)', @DescriptionE = N'Payment through banks (Form 4)', 
	 @Type = 7, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3050: Mẫu 5 - PHIẾU CHI QUA NGÂN HÀNG
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3050', 
	 @ReportName = N'Phiếu chi qua ngân hàng (Mẫu 5)', @ReportNameE = N'Payment through banks (Form 5)', 
	 @ReportTitle = N'PHIẾU CHI QUA NGÂN HÀNG', @ReportTitleE = N'PAYMENT THROUGH BANKS',
	 @Description = N'Phiếu chi qua ngân hàng (Mẫu 5)', @DescriptionE = N'Payment through banks (Form 5)', 
	 @Type = 7, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3075: Mẫu 6 - PHIẾU KẾ TOÁN
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3075', 
	 @ReportName = N'Phiếu kế toán', @ReportNameE = N'Voucher Accounting', 
	 @ReportTitle = N'PHIẾU KẾ TOÁN', @ReportTitleE = N'PAYMENT THROUGH BANKS',
	 @Description = N'Phiếu kế toán', @DescriptionE = N'Voucher Accounting', 
	 @Type = 7, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'	
---- Add AR3113: Mẫu 1 - PHIẾU CHUYỂN KHOẢN
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3113', 
	 @ReportName = N'Phiếu chuyển khoản', @ReportNameE = N'Slip transfer', 
	 @ReportTitle = N'PHIẾU CHUYỂN KHOẢN', @ReportTitleE = N'SLIP TRANSFER',
	 @Description = N'Phiếu chuyển khoản', @DescriptionE = N'Slip transfer', 
	 @Type = 8, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3113: AR3115: Mẫu 2 - PHIẾU KẾ TOÁN
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR3115', 
	 @ReportName = N'Phiếu kế toán', @ReportNameE = N'Voucher Accounting', 
	 @ReportTitle = N'PHIẾU KẾ TOÁN', @ReportTitleE = N'VOUCHER ACCOUNTING',
	 @Description = N'Phiếu kế toán', @DescriptionE = N'Voucher Accounting', 
	 @Type = 8, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add WR2027
EXEC AP8888 @GroupID = N'G05', @ModuleID = 'AsoftWM', @ReportID = N'WR2027', 
	 @ReportName = N'Mẫu 2', @ReportNameE = N'Form 2', 
	 @ReportTitle = N'PHIẾU KẾ TOÁN', @ReportTitleE = N'ACCOUNTING VOUCHER',
	 @Description = N'XUẤT KHO', @DescriptionE = N'DELIVERING', 
	 @Type = 27, @SQLstring = N'', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR7624
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'AsoftWM', @ReportID = N'AR7624', 
	 @ReportName = N'Báo cáo kết quả kinh doanh theo ngân sách', @ReportNameE = N'Business result according to budget', 
	 @ReportTitle = N'KẾT QUẢ KINH DOANH THEO NGÂN SÁCH', @ReportTitleE = N'BUSINESS RESULT ACCORDING TO BUDGET',
	 @Description = N'KẾT QUẢ KINH DOANH THEO NGÂN SÁCH', @DescriptionE = N'BUSINESS RESULT ACCORDING TO BUDGET', 
	 @Type = 54, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add WR2026
EXEC AP8888 @GroupID = N'G05', @ModuleID = 'AsoftWM', @ReportID = N'WR2026', 
	 @ReportName = N'Mẫu 2', @ReportNameE = N'Form 2', 
	 @ReportTitle = N'Phiếu kế toán', @ReportTitleE = N'Accounting voucher',
	 @Description = N'NHẬP KHO', @DescriptionE = N'RECEIVING', 
	 @Type = 26, @SQLstring = N'', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0294
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'ASoftT', @ReportID = N'AR0294', 
	 @ReportName = N'TỜ KHAI THUẾ BẢO VỆ MÔI TRƯỜNG', @ReportNameE = N'Environment Protection Commitment', 
	 @ReportTitle = N'TỜ KHAI THUẾ BẢO VỆ MÔI TRƯỜNG', @ReportTitleE = N'ENVIRONMENT PROTECTION COMMITMENT',
	 @Description = N'TỜ KHAI THUẾ BẢO VỆ MÔI TRƯỜNG', @DescriptionE = N'ENVIRONMENT PROTECTION COMMITMENT', 
	 @Type = 12, @SQLstring = N'', @Orderby = N'ORDER BY IID, UnitID',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR7614
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'ASoftT', @ReportID = N'AR7614', 
	 @ReportName = N'Báo cáo kết quả kinh doanh nhiều kỳ', @ReportNameE = N'PROFIT & LOSS BY PERIODS', 
	 @ReportTitle = N'BÁO CÁO KẾT QUẢ KINH DOANH NHIỀU KỲ', @ReportTitleE = N'PROFIT & LOSS BY PERIODS',
	 @Description = N'BÁO CÁO KẾT QUẢ KINH DOANH NHIỀU KỲ', @DescriptionE = N'PROFIT & LOSS BY PERIODS', 
	 @Type = 7, @SQLstring = N'', @Orderby = N'ORDER BY PrintCode, MonthYear',
	 @TEST = 0, @TableID = N'AT8888'	
---- Add AR7617
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'ASoftT', @ReportID = N'AR7617', 
	 @ReportName = N'BÁO CÁO KẾT QUẢ KINH DOANH NHIỀU KỲ (CÓ BIỂU ĐỒ)', @ReportNameE = N'PROFIT & LOSS BY PERIODS (WITH CHARTS)', 
	 @ReportTitle = N'BÁO CÁO KẾT QUẢ KINH DOANH NHIỀU KỲ (CÓ BIỂU ĐỒ)', @ReportTitleE = N'PROFIT & LOSS BY PERIODS (WITH CHARTS)',
	 @Description = N'BÁO CÁO KẾT QUẢ KINH DOANH NHIỀU KỲ (CÓ BIỂU ĐỒ)', @DescriptionE = N'PROFIT & LOSS BY PERIODS (WITH CHARTS)', 
	 @Type = 7, @SQLstring = N'', @Orderby = N'ORDER BY TypeID, PrintCode, MonthYear',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0601A
EXEC AP8888 @GroupID = N'G07', @ModuleID = 'ASoftT', @ReportID = N'AR0601A', 
	 @ReportName = N'Báo cáo chi tiết mua hàng', @ReportNameE = N'The report details purchase', 
	 @ReportTitle = N'BÁO CÁO CHI TIẾT MUA HÀNG', @ReportTitleE = N'THE REPORT DETAILS PURCHASE',
	 @Description = N'BÁO CÁO CHI TIẾT MUA HÀNG', @DescriptionE = N'THE REPORT DETAILS PURCHASE', 
	 @Type = 4, @SQLstring = N'Select * From AV0601  where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', @Orderby = N'Order by Group1ID,VoucherNo',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0255
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'ASoftT', @ReportID = N'AR0255', 
	 @ReportName = N'Báo cáo theo dõi chi tiết đơn hàng', @ReportNameE = N'Orders Status Report', 
	 @ReportTitle = N'BÁO CÁO THEO DÕI CHI TIẾT ĐƠN HÀNG', @ReportTitleE = N'ORDERS STATUS REPORT',
	 @Description = N'BÁO CÁO THEO DÕI CHI TIẾT ĐƠN HÀNG', @DescriptionE = N'ORDERS STATUS REPORT', 
	 @Type = 113, @SQLstring = N'SELECT * FROM AV0255', @Orderby = N'ORDER BY DivisionID, OrderDate, SOrderID, GroupID',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR2017
EXEC AP8888 @GroupID = N'G05', @ModuleID = 'ASoftT', @ReportID = N'AR2017', 
	 @ReportName = N'Mẫu 1', @ReportNameE = N'Form 1', 
	 @ReportTitle = N'PHIẾU XUẤT KHO', @ReportTitleE = N'DELIVERING VOUCHER',
	 @Description = N'XUẤT KHO', @DescriptionE = N'DELIVERING', 
	 @Type = 27, @SQLstring = N'', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR3022A
EXEC AP8888 @GroupID = N'G07', @ModuleID = 'ASoftT', @ReportID = N'AR3022A', 
	 @ReportName = N'Báo cáo chi tiết bán hàng', @ReportNameE = N'The report detail sales', 
	 @ReportTitle = N'BÁO CÁO CHI TIẾT BÁN HÀNG', @ReportTitleE = N'THE REPORT DETAIL SALES',
	 @Description = N'BÁO CÁO CHI TIẾT BÁN HÀNG', @DescriptionE = N'THE REPORT DETAIL SALES', 
	 @Type = 1, @SQLstring = N'Select * From AV3025  where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', @Orderby = N'Order by ObjectID,InventoryID',
	 @TEST = 0, @TableID = N'AT8888'	 
----Add AR0258B: Mẫu 2 - PHIẾU THU QUA NGÂN HÀNG
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftT', @ReportID = N'AR0258B', 
     @ReportName = N'Phiếu thu qua ngân hàng (Mẫu 2)', @ReportNameE = N'Receipts through banks (From 2)', 
     @ReportTitle = N'PHIẾU THU QUA NGÂN HÀNG', @ReportTitleE = N'RECEIPTS THROUGH BANKS',
	 @Description = N'Phiếu thu qua ngân hàng (Mẫu 2)', @DescriptionE = N'Receipts through banks (From 2)', 
	 @Type = 4, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'	 
----Add AR3032A
EXEC AP8888 @GroupID = N'G07', @ModuleID = 'AsoftT', @ReportID = N'AR3032A', 
     @ReportName = N'Báo cáo hàng bán trả lại (nhóm theo đối tượng)', @ReportNameE = N'Return Goods Group by Object', 
     @ReportTitle = N'BÁO CÁO HÀNG BÁN TRẢ LẠI', @ReportTitleE = N'RETURN GOODS',
	 @Description = N'Báo cáo hàng bán trả lại (nhóm theo đối tượng)', @DescriptionE = N'Return Goods Group by Object', 
	 @Type = 12, @SQLstring = N'Select * From AV3052  where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', @Orderby = N'Order by ObjectID, VoucherDate, VoucherNo, InventoryID',
	 @TEST = 0, @TableID = N'AT8888'	
----Add WR0012
EXEC AP8888 @GroupID = N'G05', @ModuleID = 'ASoftWM', @ReportID = N'WR0012', 
     @ReportName = N'Phiếu giao hàng', @ReportNameE = N'Delivery Note', 
     @ReportTitle = N'PHIẾU GIAO HÀNG', @ReportTitleE = N'DELIVERY NOTE',
	 @Description = N'PHIẾU GIAO HÀNG', @DescriptionE = N'DELIVERY NOTE', 
	 @Type = 27, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'
---- Add AR0289
EXEC AP8888 @GroupID = N'G07', @ModuleID = 'AsoftT', @ReportID = N'AR0289', 
	 @ReportName = N'Báo cáo so sánh giá mua nhiều kỳ', @ReportNameE = N'Price compare of periods', 
	 @ReportTitle = N'BÁO CÁO SO SÁNH GIÁ NHIỀU KỲ', @ReportTitleE = N'PRICE COMPARE OF PERIODS', 
	 @Description = N'BÁO CÁO SO SÁNH GIÁ NHIỀU KỲ', @DescriptionE = N'PRICE COMPARE OF PERIODS', 
	 @Type = 33, @SQLstring = N'', @Orderby = N'Order by InventoryID, ObjectID',
	 @TEST = 0, @TableID = N'AT8888'
	 
---- Add AR7010
EXEC AP8888 @GroupID = N'G05', @ModuleID = 'AsoftWM', @ReportID = N'AR7010', @ReportName = N'Báo cáo nhập xuất tồn theo quy cách hàng hóa',
	 @ReportNameE = N'General report of receiving - delivering - remaining', @ReportTitle = N'BÁO CÁO CHI TIẾT NHẬP XUẤT TỒN THEO QUY CÁCH HÀNG HÓA', @ReportTitleE = N'RETURN GOODS', @Description = N'REPORT OF RECEIVING - DELIVERING - REMAINING', 
	 @DescriptionE = N'REPORT OF RECEIVING - DELIVERING - REMAINING ACCORDING', @Type = 97, @SQLstring = N'Select * from AV2009 where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', @Orderby = N'Order by InventoryID',
	 @TEST = 0, @TableID = N'AT8888'

---- Add AR0295: Thuế nhà thầu
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'AsoftT', @ReportID = N'AR0295', @ReportName = N'Tờ khai nộp Thuế nhà thầu',
	 @ReportNameE = N'Withhoding Tax Commitment', @ReportTitle = N'TỜ KHAI NỘP THUẾ NHÀ THẦU', @ReportTitleE = N'WITHHOLDING TAX COMMITMENT', @Description = N'WITHHOLDING TAX COMMITMENT', 
	 @DescriptionE = N'WITHHOLDING TAX COMMITMENT', @Type = 34, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'

IF @CustomerName = 50 --- Customize Meiko
BEGIN
	EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftFA', @ReportID = N'FR1540', @ReportName = N'Báo cáo theo dõi XDCB dở dang',
	 @ReportNameE = N'CIP report', @ReportTitle = N'BÁO CÁO THEO DÕI XDCB DỞ DANG', @ReportTitleE = N'CONTRUCTION IN PROGRESS REPORT', @Description = N'CONTRUCTION IN PROGRESS', 
	 @DescriptionE = N'CONTRUCTION IN PROGRESSG', @Type = 3, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'

	EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftFA', @ReportID = N'FR1511', @ReportName = N'Báo cáo theo dõi khấu hao TSCĐ',
	 @ReportNameE = N'Fixed Asset depreciation', @ReportTitle = N'BÁO CÁO THEO DÕI KHẤU HAO TSCĐ', @ReportTitleE = N'FIXED ASSET DEPRECIATION', @Description = N'FIXED ASSET DEPRECIATION', 
	 @DescriptionE = N'FIXED ASSET DEPRECIATION', @Type = 4, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'AT8888'	 	 
END

---- Update Report
UPDATE AT8888STD SET Orderby = ' ORDER BY ObjectID, InventoryID, VoucherDate ' WHERE ReportID = 'AR0720'
UPDATE AT8888STD SET Orderby = ' ORDER BY InventoryID, VoucherDate ' WHERE ReportID = 'AR0721'
UPDATE AT8888STD SET Orderby = ' ORDER BY ObjectID, InventoryID, VoucherDate ' WHERE ReportID = 'AR0722'
UPDATE AT8888STD SET Orderby = ' ORDER BY ObjectID, InventoryID, VoucherDate ' WHERE ReportID = 'AR0723'
UPDATE AT8888STD SET Orderby = ' ORDER BY ObjectID, InventoryID, VoucherDate ' WHERE ReportID = 'AR0724'
UPDATE AT8888    SET Orderby = ' ORDER BY ObjectID, InventoryID, VoucherDate ' WHERE ReportID = 'AR0720'
UPDATE AT8888    SET Orderby = ' ORDER BY InventoryID, VoucherDate ' WHERE ReportID = 'AR0721'
UPDATE AT8888    SET Orderby = ' ORDER BY ObjectID, InventoryID, VoucherDate ' WHERE ReportID = 'AR0722'
UPDATE AT8888    SET Orderby = ' ORDER BY ObjectID, InventoryID, VoucherDate ' WHERE ReportID = 'AR0723'
UPDATE AT8888    SET Orderby = ' ORDER BY ObjectID, InventoryID, VoucherDate ' WHERE ReportID = 'AR0724'
UPDATE AT8888
SET SQLstring = 'SELECT * FROM AV7211  WHERE UserID = @UserID'
WHERE GroupID = 'G99' AND Type IN( 1) AND ReportID = 'AR7201'
UPDATE AT8888STD
SET SQLstring = 'SELECT * FROM AV7211  WHERE UserID = @UserID'
WHERE GroupID = 'G99' AND Type IN(1) AND ReportID = 'AR7201'
UPDATE AT8888
SET SQLstring = 'SELECT * FROM AV7201 WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))'
WHERE GroupID = 'G99' AND Type IN( 1) AND ReportID = 'AR7202'
UPDATE AT8888STD
SET SQLstring = 'SELECT * FROM AV7201 WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))'
WHERE GroupID = 'G99' AND Type IN( 1) AND ReportID = 'AR7202'
UPDATE AT8888
SET SQLstring = ''
WHERE GroupID = 'G99' AND Type IN( 0)
UPDATE AT8888STD
SET SQLstring = ''
WHERE GroupID = 'G99' AND Type IN(0)
UPDATE	AT8888
SET    	SQLstring = 'SELECT * FROM AV1313 WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))'
WHERE	GroupID ='G05' 
		AND Type IN (9,10)
UPDATE AT8888STD
SET SQLString = N'SELECT DISTINCT * FROM AT2018 where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))'
WHERE ReportID = 'AR7006'
UPDATE AT8888STD
SET SQLstring = N'SELECT * FROM AV4706 WHERE (1=1)'
WHERE ReportID IN ('AR4000', 'AR4001', 'AR4002', 'AR4010', 'AR4011', 'AR4014', 'AR4015', 'AR4016', 'AR4017')
UPDATE AT8888STD
SET SQLstring = N'SELECT * FROM AV6003 WHERE (1=1)'
WHERE ReportID IN ('AR6003','AR6004')

UPDATE AT8888STD
SET SQLstring = N'SELECT * FROM AV6600 WHERE (1=1)'
WHERE ReportID IN ('AR6600')
UPDATE	AT8888STD
SET    	SQLstring = 'SELECT * FROM AV1313 WHERE DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))'
WHERE	GroupID ='G05' 
		AND Type IN (9,10)


---- Delete Report
Delete AT8888 Where GroupID = 'G99' AND Type = 7 And ReportID = 'AR7602'