-- <Summary>
---- 
-- <History>
---- Create on 24/04/2014 by Bảo Anh
---- Modified on ... by ...
---- <Example>
---- Add CMR0019: Báo cáo thanh toán hoa hồng
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftCM', @ReportID = N'CMR0019', 
	 @ReportName = N'Báo cáo thanh toán hoa hồng khách hàng qua ngân hàng', @ReportNameE = N'Payment by bank report', 
	 @ReportTitle = N'BÁO CÁO THANH TOÁN HOA HỒNG KHÁCH HÀNG QUA NGÂN HÀNG', @ReportTitleE = N'PAYMENT BY BANK REPORT',
	 @Description = N'BÁO CÁO THANH TOÁN HOA HỒNG KHÁCH HÀNG QUA NGÂN HÀNG', @DescriptionE = N'PAYMENT BY BANK REPORT', 
	 @Type = 0, @SQLstring = N'', @Orderby = N'Order by VoucherDate, VoucherNo',
	 @TEST = 0, @TableID = N'CMT8888'
---- Add CMR0020
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftCM', @ReportID = N'CMR0020', 
	 @ReportName = N'Báo cáo thanh toán hoa hồng khách hàng bằng tiền mặt', @ReportNameE = N'Payment by cash report', 
	 @ReportTitle = N'BÁO CÁO THANH TOÁN HOA HỒNG KHÁCH HÀNG BẰNG TIỀN MẶT', @ReportTitleE = N'PAYMENT BY CASH REPORT',
	 @Description = N'BÁO CÁO THANH TOÁN HOA HỒNG KHÁCH HÀNG BẰNG TIỀN MẶT', @DescriptionE = N'PAYMENT BY CASH REPORT', 
	 @Type = 1, @SQLstring = N'', @Orderby = N'Order by VoucherDate, VoucherNo',
	 @TEST = 0, @TableID = N'CMT8888'
---- Add CMR00131: Báo cáo thống kê hoa hồng
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftCM', @ReportID = N'CMR00131', 
	 @ReportName = N'Báo cáo thống kê hoa hồng theo hóa đơn', @ReportNameE = N'Bonus list by invoice', 
	 @ReportTitle = N'BÁO CÁO THỐNG KÊ HOA HỒNG THEO HÓA ĐƠN', @ReportTitleE = N'BONUS LIST BY INVOICE',
	 @Description = N'BÁO CÁO THỐNG KÊ HOA HỒNG THEO HÓA ĐƠN', @DescriptionE = N'BONUS LIST BY INVOICE', 
	 @Type = 0, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'CMT8888'
---- Add CMR00132
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftCM', @ReportID = N'CMR00132', 
	 @ReportName = N'Báo cáo thống kê hoa hồng theo mặt hàng', @ReportNameE = N'Bonus list by inventory', 
	 @ReportTitle = N'BÁO CÁO THỐNG KÊ HOA HỒNG THEO MẶT HÀNG', @ReportTitleE = N'BONUS LIST BY INVENTORY',
	 @Description = N'BÁO CÁO THỐNG KÊ HOA HỒNG THEO MẶT HÀNG', @DescriptionE = N'BONUS LIST BY INVENTORY', 
	 @Type = 1, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'CMT8888'
---- Add CMR00133
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftCM', @ReportID = N'CMR00133', 
	 @ReportName = N'Báo cáo thống kê hoa hồng theo đối tượng', @ReportNameE = N'Bonus list by object', 
	 @ReportTitle = N'BÁO CÁO THỐNG KÊ HOA HỒNG THEO ĐỐI TƯỢNG', @ReportTitleE = N'BONUS LIST BY OBJECT',
	 @Description = N'BÁO CÁO THỐNG KÊ HOA HỒNG THEO ĐỐI TƯỢNG', @DescriptionE = N'BONUS LIST BY OBJECT', 
	 @Type = 2, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'CMT8888' 
---- Add CMR00134
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'AsoftCM', @ReportID = N'CMR00134', 
	 @ReportName = N'Báo cáo thống kê hoa hồng theo bộ phận hỗ trợ', @ReportNameE = N'Bonus list by supportman', 
	 @ReportTitle = N'BÁO CÁO THỐNG KÊ HOA HỒNG THEO BỘ PHẬN HỖ TRỢ', @ReportTitleE = N'BONUS LIST BY SUPPORTMAN',
	 @Description = N'BÁO CÁO THỐNG KÊ HOA HỒNG THEO BỘ PHẬN HỖ TRỢ', @DescriptionE = N'BONUS LIST BY SUPPORTMAN', 
	 @Type = 3, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'CMT8888' 