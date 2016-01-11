-- <Summary>
---- 
-- <History>
---- Create on 01/01/2014 by Thanh Sown
---- Modified on ... by ...
---- Add WR0097: báo cáo yêu cầu vận chuyển nội bộ
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftWM', @ReportID = N'WR0097', 
	 @ReportName = N'Phiếu yêu cầu VCNB', @ReportNameE = N'Internal Transfer WardHouse Requirement', 
	 @ReportTitle = N'PHIẾU YÊU CẦU XUẤT KIÊM VẬN CHUYỂN NỘI BỘ', @ReportTitleE = N'Internal Transfer WardHouse Requirement',
	 @Description = N'PHIẾU YÊU CẦU XUẤT KIÊM VẬN CHUYỂN NỘI BỘ', @DescriptionE = N'Internal Transfer WardHouse Requirement', 
	 @Type = 3, @SQLstring = N'', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'WT8888'
---- Add WR0096: báo cáo yêu cầu nhập kho
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftWM', @ReportID = N'WR0096', 
	 @ReportName = N'Phiếu yêu cầu xuất kho', @ReportNameE = N'Export WareHouse Requirement', 
	 @ReportTitle = N'PHIẾU YÊU CẦU XUẤT KHO', @ReportTitleE = N'Export WareHouse Requirement',
	 @Description = N'PHIẾU YÊU CẦU XUẤT KHO', @DescriptionE = N'Export WareHouse Requirement', 
	 @Type = 2, @SQLstring = N'', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'WT8888'
---- Add WR0095: báo cáo yêu cầu nhập kho
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'AsoftWM', @ReportID = N'WR0095', 
	 @ReportName = N'Phiếu yêu cầu nhập kho', @ReportNameE = N'Import WareHouse Requirement', 
	 @ReportTitle = N'PHIẾU YÊU CẦU NHẬP KHO', @ReportTitleE = N'Import WareHouse Requirement',
	 @Description = N'PHIẾU YÊU CẦU NHẬP KHO', @DescriptionE = N'Import WareHouse Requirement', 
	 @Type = 1, @SQLstring = N'', @Orderby = N'Order by Orders',
	 @TEST = 0, @TableID = N'WT8888'
	