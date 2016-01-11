-- <Summary>
---- Add Report
-- <History>
---- Created by Tiểu Mai on 28/12/2015: Bổ sung mẫu report chuẩn Bộ định mức theo quy cách MR0136, MR0137
---- <Example>

DECLARE @CustomerName INT

IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#CustomerName')) 
DROP TABLE #CustomerName
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)
----Add MR0136
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'ASoftM', @ReportID = N'MR0135', 
     @ReportName = N'Bộ định mức NVL theo quy cách cho sản phẩm', @ReportNameE = N'Delivery Note', 
     @ReportTitle = N'TỔNG HỢP BỘ ĐỊNH MỨC SẢN PHẨM', @ReportTitleE = N'DELIVERY NOTE',
	 @Description = N'TỔNG HỢP BỘ ĐỊNH MỨC SẢN PHẨM', @DescriptionE = N'DELIVERY NOTE', 
	 @Type = 2, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'MT8888'

----Add MR0137
EXEC AP8888 @GroupID = N'G99', @ModuleID = 'ASoftM', @ReportID = N'MR0136', 
     @ReportName = N'Chi tiết định mức sản phẩm theo quy cách', @ReportNameE = N'Delivery Note', 
     @ReportTitle = N'CHI TIẾT ĐỊNH MỨC SẢN PHẨM THEO QUY CÁCH', @ReportTitleE = N'DELIVERY NOTE',
	 @Description = N'CHI TIẾT ĐỊNH MỨC SẢN PHẨM THEO QUY CÁCH', @DescriptionE = N'DELIVERY NOTE', 
	 @Type = 2, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'MT8888'	 

