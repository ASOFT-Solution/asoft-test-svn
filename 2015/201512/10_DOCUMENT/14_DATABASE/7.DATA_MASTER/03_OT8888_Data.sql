-- <Summary>
---- 
-- <History>
---- Create on 10/07/2012 by Bảo Anh
---- Modified on 25/11/2014 by Mai Trí Thiện
---- <Example>

---- Add OR0124
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'AsoftOP', @ReportID = N'OR0124', 
	 @ReportName = N'Báo cáo tổng chi hoa hồng', @ReportNameE = N'Payment total report', 
	 @ReportTitle = N'BÁO CÁO TỔNG CHI HOA HỒNG', @ReportTitleE = N'PAYMENT TOTAL REPORT',
	 @Description = N'TỔNG CHI HOA HỒNG', @DescriptionE = N'PAYMENT TOTAL', 
	 @Type = 1, @SQLstring = N'', @Orderby = N'Order by SalesmanID',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR21022
EXEC AP8888 @GroupID = N'G06', @ModuleID = 'AsoftOP', @ReportID = N'OR21022', 
	 @ReportName = N'Mẫu 4', @ReportNameE = N'Form 4', 
	 @ReportTitle = N'MẪU 4', @ReportTitleE = N'FORM 4',
	 @Description = N'CHÀO GIÁ', @DescriptionE = N'QUOTATION', 
	 @Type = 9, @SQLstring = N'', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR21021
EXEC AP8888 @GroupID = N'G06', @ModuleID = 'AsoftOP', @ReportID = N'OR21021', 
	 @ReportName = N'Mẫu 3', @ReportNameE = N'Form 3', 
	 @ReportTitle = N'MẪU 3', @ReportTitleE = N'FORM 3',
	 @Description = N'CHÀO GIÁ', @DescriptionE = N'QUOTATION', 
	 @Type = 9, @SQLstring = N'Select * From OV2101', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR0128
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftOP', @ReportID = N'OR0128', 
	 @ReportName = N'Xác nhận hoàn thành', @ReportNameE = N'Confirm completion', 
	 @ReportTitle = N'Xác nhận hoàn thành', @ReportTitleE = N'Confirm completion',
	 @Description = N'Xác nhận hoàn thành', @DescriptionE = N'Confirm completion', 
	 @Type = 12, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR2102
EXEC AP8888 @GroupID = N'G06', @ModuleID = 'AsoftOP', @ReportID = N'OR2102', 
	 @ReportName = N'Mẫu 2', @ReportNameE = N'Form 2', 
	 @ReportTitle = N'PHỤ LỤC', @ReportTitleE = N'APPENDIX',
	 @Description = N'CHÀO GIÁ', @DescriptionE = N'QUOTATION', 
	 @Type = 9, @SQLstring = N'Select * From OV2101', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR2101
EXEC AP8888 @GroupID = N'G06', @ModuleID = 'AsoftOP', @ReportID = N'OR2101', 
	 @ReportName = N'Mẫu 1', @ReportNameE = N'Form 1', 
	 @ReportTitle = N'PHIẾU CHÀO GIÁ', @ReportTitleE = N'QUOTATION VOUCHER',
	 @Description = N'CHÀO GIÁ', @DescriptionE = N'QUOTATION', 
	 @Type = 9, @SQLstring = N'Select * From OV2101', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR0123
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'AsoftOP', @ReportID = N'OR0123', 
	 @ReportName = N'Báo cáo tiền thưởng hoa hồng', @ReportNameE = N'Bonus report', 
	 @ReportTitle = N'BÁO CÁO TIỀN THƯỞNG HOA HỒNG', @ReportTitleE = N'PAYMENT TOTAL REPORT',
	 @Description = N'TIỀN THƯỞNG HOA HỒNG', @DescriptionE = N'BONUS REPORT', 
	 @Type = 1, @SQLstring = N'', @Orderby = N'Order by SalesmanID, ContractNo',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR0126
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftOP', @ReportID = N'OR0126', 
	 @ReportName = N'Lệnh điều động - Mẫu A', @ReportNameE = N'Mobilization orders - A', 
	 @ReportTitle = N'Lệnh điều động', @ReportTitleE = N'Mobilization orders',
	 @Description = N'Lệnh điều động', @DescriptionE = N'Mobilization orders', 
	 @Type = 11, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR0126A
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftOP', @ReportID = N'OR0126A', 
	 @ReportName = N'Lệnh điều động', @ReportNameE = N'Mobilization orders', 
	 @ReportTitle = N'Lệnh điều động', @ReportTitleE = N'Mobilization orders',
	 @Description = N'Lệnh điều động', @DescriptionE = N'Mobilization orders', 
	 @Type = 11, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'OT8888'	 
---- Add OR0133
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftOP', @ReportID = N'OR0133', 
	 @ReportName = N'Quyết toán khách hàng', @ReportNameE = N'Commited Object', 
	 @ReportTitle = N'QUYẾT TOÁN KHÁCH HÀNG', @ReportTitleE = N'COMMITED OBJECT',
	 @Description = N'QUYẾT TOÁN KHÁCH HÀNG', @DescriptionE = N'COMMITED OBJECT', 
	 @Type = 13, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR0134
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftOP', @ReportID = N'OR0134', 
	 @ReportName = N'Quyết toán khách hàng - Tất cả', @ReportNameE = N'Commited Object - All', 
	 @ReportTitle = N'QUYẾT TOÁN KHÁCH HÀNG', @ReportTitleE = N'COMMITED OBJECT',
	 @Description = N'QUYẾT TOÁN KHÁCH HÀNG', @DescriptionE = N'COMMITED OBJECT', 
	 @Type = 13, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR0135
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftOP', @ReportID = N'OR0135', 
	 @ReportName = N'Quyết toán khách hàng tổng hợp', @ReportNameE = N'General Commited Object', 
	 @ReportTitle = N'QUYẾT TOÁN KHÁCH HÀNG TỔNG HỢP', @ReportTitleE = N'GENERAL COMMITED OBJECT',
	 @Description = N'QUYẾT TOÁN KHÁCH HÀNG TỔNG HỢP', @DescriptionE = N'General Commited Object', 
	 @Type = 13, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR0140
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftOP', @ReportID = N'OR0140', 
	 @ReportName = N'Quyết toán Tàu-Sà lan (Sà Lan)', @ReportNameE = N'Commited Ship', 
	 @ReportTitle = N'QUYẾT TOÁN TÀU - SÀ LAN', @ReportTitleE = N'COMMITED SHIP',
	 @Description = N'QUYẾT TOÁN TÀU - SÀ LAN', @DescriptionE = N'COMMITED SHIP', 
	 @Type = 14, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR0141
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftOP', @ReportID = N'OR0141', 
	 @ReportName = N'Quyết toán Tàu - Sà lan (Nội địa)', @ReportNameE = N'Commited Ship', 
	 @ReportTitle = N'QUYẾT TOÁN TÀU - SÀ LAN', @ReportTitleE = N'COMMITED SHIP',
	 @Description = N'QUYẾT TOÁN TÀU - SÀ LAN', @DescriptionE = N'COMMITED SHIP', 
	 @Type = 14, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR0142
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftOP', @ReportID = N'OR0142', 
	 @ReportName = N'Quyết toán Tàu - Sà lan (Nước ngoài)', @ReportNameE = N'Commited Ship', 
	 @ReportTitle = N'QUYẾT TOÁN TÀU - SÀ LAN', @ReportTitleE = N'COMMITED SHIP',
	 @Description = N'QUYẾT TOÁN TÀU - SÀ LAN', @DescriptionE = N'COMMITED SHIP', 
	 @Type = 14, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR0136
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftOP', @ReportID = N'OR0136', 
	 @ReportName = N'Quyết toán khách hàng tổng hợp - mẫu 2', @ReportNameE = N'General Commited Object', 
	 @ReportTitle = N'QUYẾT TOÁN KHÁCH HÀNG TỔNG HỢP', @ReportTitleE = N'GENERAL COMMITED OBJECT',
	 @Description = N'QUYẾT TOÁN KHÁCH HÀNG TỔNG HỢP', @DescriptionE = N'GENERAL COMMITED OBJECT', 
	 @Type = 13, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'OT8888'
---- Add OR0308
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftOP', @ReportID = N'OR0308', 
	 @ReportName = N'Báo cáo theo dõi tình trạng đơn đặt hàng', @ReportNameE = N'Order status', 
	 @ReportTitle = N'BÁO CÁO THEO DÕI TÌNH TRẠNG ĐƠN ĐẶT HÀNG', @ReportTitleE = N'ORDER STATUS',
	 @Description = N'BÁO CÁO THEO DÕI TÌNH TRẠNG ĐƠN ĐẶT HÀNG', @DescriptionE = N'ORDER STATUS', 
	 @Type = 2, @SQLstring = N'Select * From OV0301 where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', @Orderby = N'Order by GroupID, OrderDate, VoucherNo, InventoryID',
	 @TEST = 0, @TableID = N'OT8888'
---- Update Report
Update OT8888 Set DescriptionE = N'Purchase Request' , TitleE = N'PURCHASE REQUEST', ReportNameE = N'Purchase Request' where ReportID = 'OR3101'
Update OT8888 Set DescriptionE = N'Purchase Request' , TitleE = N'PURCHASE REQUEST', ReportNameE = N'Purchase Request' where ReportID = 'OR3102'
Update OT8888 Set DescriptionE = N'The exports and supplies' , TitleE = N'STATUS OF MATERIALS', ReportNameE = N'The exports and supplies' where ReportID = 'OR3227'
Update OT8888 Set DescriptionE = N'Code analysis' , TitleE = N'REPORTS REQUESTED BY PURCHASING CODE ANALYSIS', ReportNameE = N'Report purchase requirements under the code analysis' where ReportID = 'OR3046'
Update OT8888 Set DescriptionE = N'Review the situation to order' , TitleE = N'GENERAL ORDER STATUS', ReportNameE = N'Review the situation to order' where ReportID = 'OR6012'
Update OT8888 Set DescriptionE = N'Review the situation of order (specified by PO)' , TitleE = N'ORDER STATUS SUMMARY (DETAIL BY PO)', ReportNameE = N'Review the situation of order (specified by PO)' where ReportID = 'OR6014'
Update OT8888 Set DescriptionE = N'Review the situation to order - delivery' , TitleE = N'GENERAL ORDER STATUS - Cargoes', ReportNameE = N'Review the situation to order - delivery' where ReportID = 'OR6015'
Update OT8888 Set DescriptionE = N'Price analysis' , TitleE = N'ANALYSIS OF PURCHASE PRICE', ReportNameE = N'Price analysis' where ReportID = 'OR6016'
Update OT8888 Set DescriptionE = N'Purchase orders' , TitleE = N'PURCHASE ORDER', ReportNameE = N'Purchase orders' where ReportID = 'OR3002'
Update OT8888 Set DescriptionE = N'Purchase orders' , TitleE = N'PURCHASE ORDER', ReportNameE = N'Purchase orders' where ReportID = 'OR3001'
Update OT8888 Set DescriptionE = N'Purchase orders' , TitleE = N'PURCHASE ORDER', ReportNameE = N'Purchase orders' where ReportID = 'OR3011'
Update OT8888 Set DescriptionE = N'Sell ​​orders' , TitleE = N'SALES ORDER', ReportNameE = N'Sell ​​orders' where ReportID = 'OR2001'
Update OT8888 Set DescriptionE = N'Sell ​​orders' , TitleE = N'SALES ORDER', ReportNameE = N'Sell ​​orders' where ReportID = 'OR2011'
Update OT8888 Set DescriptionE = N'Code analysis' , TitleE = N'REPORTS REQUESTED BY PURCHASING CODE ANALYSIS', ReportNameE = N'Report purchase requirements under the code analysis' where ReportID = 'OR3047'
Update OT8888 Set DescriptionE = N'Code analysis' , TitleE = N'REPORTS REQUESTED BY PURCHASING CODE ANALYSIS', ReportNameE = N'Report purchase requirements under the code analysis' where ReportID = 'OR3048'
Update OT8888 Set DescriptionE = N'Code analysis' , TitleE = N'REPORTS REQUESTED BY PURCHASING CODE ANALYSIS', ReportNameE = N'Report purchase requirements under the code analysis' where ReportID = 'OR3049'
Update OT8888STD Set DescriptionE = N'Purchase Request' , TitleE = N'PURCHASE REQUEST', ReportNameE = N'Purchase Request' where ReportID = 'OR3101'
Update OT8888STD Set DescriptionE = N'Purchase Request' , TitleE = N'PURCHASE REQUEST', ReportNameE = N'Purchase Request' where ReportID = 'OR3102'
Update OT8888STD Set DescriptionE = N'The exports and supplies' , TitleE = N'STATUS OF MATERIALS', ReportNameE = N'The exports and supplies' where ReportID = 'OR3227'
Update OT8888STD Set DescriptionE = N'Code analysis' , TitleE = N'REPORTS REQUESTED BY PURCHASING CODE ANALYSIS', ReportNameE = N'Report purchase requirements under the code analysis' where ReportID = 'OR3046'
Update OT8888STD Set DescriptionE = N'Review the situation to order' , TitleE = N'GENERAL ORDER STATUS', ReportNameE = N'Review the situation to order' where ReportID = 'OR6012'
Update OT8888STD Set DescriptionE = N'Review the situation of order (specified by PO)' , TitleE = N'ORDER STATUS SUMMARY (DETAIL BY PO)', ReportNameE = N'Review the situation of order (specified by PO)' where ReportID = 'OR6014'
Update OT8888STD Set DescriptionE = N'Review the situation to order - delivery' , TitleE = N'GENERAL ORDER STATUS - Cargoes', ReportNameE = N'Review the situation to order - delivery' where ReportID = 'OR6015'
Update OT8888STD Set DescriptionE = N'Price analysis' , TitleE = N'ANALYSIS OF PURCHASE PRICE', ReportNameE = N'Price analysis' where ReportID = 'OR6016'
Update OT8888STD Set DescriptionE = N'Purchase orders' , TitleE = N'PURCHASE ORDER', ReportNameE = N'Purchase orders' where ReportID = 'OR3002'
Update OT8888STD Set DescriptionE = N'Purchase orders' , TitleE = N'PURCHASE ORDER', ReportNameE = N'Purchase orders' where ReportID = 'OR3001'
Update OT8888STD Set DescriptionE = N'Purchase orders' , TitleE = N'PURCHASE ORDER', ReportNameE = N'Purchase orders' where ReportID = 'OR3011'
Update OT8888STD Set DescriptionE = N'Sell ​​orders' , TitleE = N'SALES ORDER', ReportNameE = N'Sell ​​orders' where ReportID = 'OR2001'
Update OT8888STD Set DescriptionE = N'Sell ​​orders' , TitleE = N'SALES ORDER', ReportNameE = N'Sell ​​orders' where ReportID = 'OR2011'
Update OT8888STD Set DescriptionE = N'Code analysis' , TitleE = N'REPORTS REQUESTED BY PURCHASING CODE ANALYSIS', ReportNameE = N'Report purchase requirements under the code analysis' where ReportID = 'OR3047'
Update OT8888STD Set DescriptionE = N'Code analysis' , TitleE = N'REPORTS REQUESTED BY PURCHASING CODE ANALYSIS', ReportNameE = N'Report purchase requirements under the code analysis' where ReportID = 'OR3048'
Update OT8888STD Set DescriptionE = N'Code analysis' , TitleE = N'REPORTS REQUESTED BY PURCHASING CODE ANALYSIS', ReportNameE = N'Report purchase requirements under the code analysis' where ReportID = 'OR3049'

--- Modified by Tiểu Mai on 06/01/2016: Add OR0084 cho An Phat
EXEC AP8888 @GroupID = N'G03', @ModuleID = 'AsoftOP', @ReportID = N'OR0084', 
	 @ReportName = N'Báo cáo theo dõi tình hình đơn hàng sản xuất', @ReportNameE = N'Order status', 
	 @ReportTitle = N'PHIẾU KIỂM KÊ', @ReportTitleE = N'ORDER STATUS',
	 @Description = N'BÁO CÁO THEO DÕI TÌNH HÌNH ĐƠN HÀNG SX (PHIẾU KIỂM KÊ)', @DescriptionE = N'ORDER STATUS', 
	 @Type = 11, @SQLstring = N'Select * From OV0084 where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', @Orderby = N'Order by SOrderID',
	 @TEST = 0, @TableID = N'OT8888'