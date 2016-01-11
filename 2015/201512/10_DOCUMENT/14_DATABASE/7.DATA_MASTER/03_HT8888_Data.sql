-- <Summary>
---- Bổ sung Danh sách con nhân viên theo độ tuổi [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 07/10/2014 by Bảo Anh
---- Modified on 02/10/2014 by Lê Thị Hạnh
---- Modified on 30/06/2015 by Bảo Anh: Bỏ mẫu HR0318 vì mẫu này in ở MH nghiệp vụ
---- Modified on 03/11/2015 by Kim Vũ: Bổ sung Type = 80 trong G03 báo cáo đề nghị điều chỉnh hồ sơ BHXH - BHYT

---- Add HR0348
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'ASoftHR', @ReportID = N'HR0348', 
	 @ReportName = N'Danh sách con nhân viên theo độ tuổi', @ReportNameE = N'Age Of Employee Children List', 
	 @ReportTitle = N'DANH SÁCH CON NHÂN VIÊN THEO ĐỘ TUỔI', @ReportTitleE = N'AGE OF EMPLOYEE CHILDREN LIST',
	 @Description = N'DANH SÁCH CON NHÂN VIÊN THEO ĐỘ TUỔI', @DescriptionE = N'AGE OF EMPLOYEE CHILDREN LIST', 
	 @Type = 2, @SQLstring = N'', @Orderby = N'ORDER BY EmployeeID, RelationDate, RelationID',
	 @TEST = 0, @TableID = N'HT8888'
---- Add HR1412
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'ASoftHR', @ReportID = N'HR1412', 
	 @ReportName = N'Danh sách nhân viên nghỉ việc', @ReportNameE = N'Resignation list', 
	 @ReportTitle = N'DANH SÁCH NHÂN VIÊN NGHỈ VIỆC', @ReportTitleE = N'RESIGNATION LIST',
	 @Description = N'DANH SÁCH NHÂN VIÊN NGHỈ VIỆC', @DescriptionE = N'RESIGNATION LIST', 
	 @Type = 9, @SQLstring = N'', @Orderby = N'Order by DepartmentID, Isnull(TeamID,''''), EmployeeID',
	 @TEST = 0, @TableID = N'HT8888'
---- Add HR1413
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'ASoftHR', @ReportID = N'HR1413', 
	 @ReportName = N'Danh sách nhân viên tạm nghỉ', @ReportNameE = N'Breaking list', 
	 @ReportTitle = N'DANH SÁCH NHÂN VIÊN TẠM NGHỈ', @ReportTitleE = N'BREAKING LIST',
	 @Description = N'DANH SÁCH NHÂN VIÊN TẠM NGHỈ', @DescriptionE = N'BREAKING LIST', 
	 @Type = 3, @SQLstring = N'', @Orderby = N'Order by DepartmentID, Isnull(TeamID,''''), EmployeeID',
	 @TEST = 0, @TableID = N'HT8888'
---- Add HR2504
EXEC AP8888 @GroupID = N'G03', @ModuleID = 'ASoftHR', @ReportID = N'HR2504', 
	 @ReportName = N'Danh sách thanh toán chế độ ốm đau, thai sản, dưỡng sức PHSK', @ReportNameE = N'Payment insurance regime report', 
	 @ReportTitle = N'DANH SÁCH THANH TOÁN CHẾ ĐỘ ỐM ĐAU, THAI SẢN, DƯỠNG SỨC PHSK', @ReportTitleE = N'PAYMENT INSURANCE REGIME REPORT',
	 @Description = N'DANH SÁCH THANH TOÁN CHẾ ĐỘ ỐM ĐAU, THAI SẢN, DƯỠNG SỨC PHSK', @DescriptionE = N'PAYMENT INSURANCE REGIME REPORT', 
	 @Type = 9, @SQLstring = N'', @Orderby = N'Order by Group01ID, ConditionTypeID',
	 @TEST = 0, @TableID = N'HT8888'	
---- Add HR0324
EXEC AP8888 @GroupID = N'G03', @ModuleID = 'ASoftHR', @ReportID = N'HR0324', 
	 @ReportName = N'Danh sách trả thẻ BHYT', @ReportNameE = N'Return health insurance list', 
	 @ReportTitle = N'DANH SÁCH TRẢ THẺ BHYT', @ReportTitleE = N'RETURN HEALTH INSURANCE LIST',
	 @Description = N'DANH SÁCH TRẢ THẺ BHYT', @DescriptionE = N'RETURN HEALTH INSURANCE LIST', 
	 @Type = 10, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'
---- Add HR0323
EXEC AP8888 @GroupID = N'G03', @ModuleID = 'ASoftHR', @ReportID = N'HR0323', 
	 @ReportName = N'Danh sách lao động tham gia BHXH, BHYT', @ReportNameE = N'Labor list join in social insurance, health insurance', 
	 @ReportTitle = N'DANH SÁCH LAO ĐỘNG THAM GIA BHXH, BHYT', @ReportTitleE = N'LABOR LIST JOIN IN SOCIAL INSURANCE, HEALTH INSURANCE',
	 @Description = N'DANH SÁCH LAO ĐỘNG THAM GIA BHXH, BHYT', @DescriptionE = N'LABOR LIST JOIN IN SOCIAL INSURANCE, HEALTH INSURANCE', 
	 @Type = 10, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'
---- Add HR0340: BẢNG THANH TOÁN TÀU
EXEC AP8888 @GroupID = N'G11', @ModuleID = 'ASoftHR', @ReportID = N'HR0340', 
	 @ReportName = N'Bảng thanh toán tàu tổng hợp', @ReportNameE = N'Ship general payment report', 
	 @ReportTitle = N'BẢNG THANH TOÁN TÀU', @ReportTitleE = N'SHIP PAYMENT REPORT',
	 @Description = N'Bảng thanh toán tàu tổng hợp', @DescriptionE = N'Ship general paymenr Report', 
	 @Type = 1, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'
---- Add HR0341: Chi tiết ca-tàu-tổ
EXEC AP8888 @GroupID = N'G11', @ModuleID = 'ASoftHR', @ReportID = N'HR0341', 
	 @ReportName = N'Bảng thanh toán tàu chi tiết', @ReportNameE = N'Ship detail payment report', 
	 @ReportTitle = N'BẢNG THANH TOÁN TÀU', @ReportTitleE = N'SHIP PAYMENT REPORT',
	 @Description = N'Bảng thanh toán tàu chi tiết', @DescriptionE = N'Ship detail paymenr Report', 
	 @Type = 2, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'
---- Add HR0342: Chi tiết ca-tàu-tổ
EXEC AP8888 @GroupID = N'G12', @ModuleID = 'ASoftHR', @ReportID = N'HR0342', 
	 @ReportName = N'Bảng in chi tiết từng ca-tàu-tổ', @ReportNameE = N'Detail of shift-ship-team report', 
	 @ReportTitle = N'BẢNG IN CGI TIẾT TỪNG CA TÀU TỔ', @ReportTitleE = N'DETAIL OF SHIFT-SHIP-TEAM REPORT',
	 @Description = N'Bảng in chi tiết từng ca-tàu-tổ', @DescriptionE = N'Detail of shift-ship-team report', 
	 @Type = 1, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'	
---- Add HR2406
EXEC AP8888 @GroupID = N'G06', @ModuleID = 'ASoftHR', @ReportID = N'HR2406', 
	 @ReportName = N'Báo cáo chấm công ngày', @ReportNameE = N'Time-keeping report', 
	 @ReportTitle = N'BÁO CÁO CHẤM CÔNG NGÀY', @ReportTitleE = N'TIME-KEEPING REPORT',
	 @Description = N'BÁO CÁO CHẤM CÔNG NGÀY', @DescriptionE = N'TIME-KEEPING REPORT', 
	 @Type = 2, @SQLstring = N'Select * from HV2403', @Orderby = N'Order by DepartmentID, TeamID, EmployeeID, AbsentDate, OrdersAbsentType',
	 @TEST = 0, @TableID = N'HT8888'
---- Add HR2706
EXEC AP8888 @GroupID = N'G08', @ModuleID = 'ASoftHR', @ReportID = N'HR2706', 
	 @ReportName = N'Chứng từ Khấu trừ thuế TNCN', @ReportNameE = N'Certificate of Personal Income Tax Withholding', 
	 @ReportTitle = N'CHỨNG TỪ KHẤU TRỪ THUẾ THU NHẬP CÁ NHÂN', @ReportTitleE = N'CERTIFICATE OF PERSONAL INCOME TAX WITHHOLDING',
	 @Description = N'CHỨNG TỪ KHẤU TRỪ THUẾ THU NHẬP CÁ NHÂN', @DescriptionE = N'CERTIFICATE OF PERSONAL INCOME TAX WITHHOLDING', 
	 @Type = 2, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'	
---- Add HR2411
EXEC AP8888 @GroupID = N'G02', @ModuleID = 'ASoftHR', @ReportID = N'HR2411', 
	 @ReportName = N'Báo cáo theo dõi thi đua', @ReportNameE = N'Emulation report', 
	 @ReportTitle = N'BÁO CÁO THEO DÕI THI ĐUA', @ReportTitleE = N'EMULATION REPORT',
	 @Description = N'BÁO CÁO THEO DÕI THI ĐUA', @DescriptionE = N'EMULATION REPORT', 
	 @Type = 0, @SQLstring = N'', @Orderby = N'Order by DepartmentID, EmployeeID',
	 @TEST = 0, @TableID = N'HT8888'	 
---- Add HR2705
EXEC AP8888 @GroupID = N'G08', @ModuleID = 'ASoftHR', @ReportID = N'HR2705', 
	 @ReportName = N'Bảng kê thuế TNCN (mẫu 05A/BK-TNCN)', @ReportNameE = N'Personal tax list', 
	 @ReportTitle = N'BẢNG KÊ THUẾ TNCN (MẪU 05A/BK-TNCN)', @ReportTitleE = N'PERSONAL TAX LIST',
	 @Description = N'BẢNG KÊ THUẾ TNCN (MẪU 05A/BK-TNCN)', @DescriptionE = N'PERSONAL TAX LIST', 
	 @Type = 2, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'	
---- Add HR0349
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'ASoftHR', @ReportID = N'HR0349', 
	 @ReportName = N'Báo cáo quá trình công tác', @ReportNameE = N'Employee History Report', 
	 @ReportTitle = N'BÁO CÁO QUÁ TRÌNH CÔNG TÁC', @ReportTitleE = N'EMPLOYEE HISTORY REPORT',
	 @Description = N'BÁO CÁO QUÁ TRÌNH CÔNG TÁC', @DescriptionE = N'EMPLOYEE HISTORY REPORT', 
	 @Type = 4, @SQLstring = N'', @Orderby = N'ORDER BY EmployeeID, FromDate, ToDate',
	 @TEST = 0, @TableID = N'HT8888'	
---- Add HR2816
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'ASoftHR', @ReportID = N'HR2816', 
	 @ReportName = N'Chi tiết nhân viên', @ReportNameE = N'PERSONAL DETAIL', 
	 @ReportTitle = N'Chi tiết nhân viên', @ReportTitleE = N'PERSONAL DETAIL',
	 @Description = N'Chi tiết nhân viên', @DescriptionE = N'PERSONAL DETAIL', 
	 @Type = 10, @SQLstring = N'SELECT HV2815.*, HV2820.*  From HV2815 HV2815, HV2820 HV2820  Where  HV2815.EmployeeID = HV2820.EmployeeID  and HV2815.DivisionID = HV2820.DivisionID   AND  HV2815.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', @Orderby = N'Order By HV2820.Suppress Asc,HV2815.EmployeeID ASC',
	 @TEST = 0, @TableID = N'HT8888'
---- Add HR1400
EXEC AP8888 @GroupID = N'G01', @ModuleID = 'ASoftHR', @ReportID = N'HR1400', 
	 @ReportName = N'Danh sách nhân viên', @ReportNameE = N'LABOUR LIST', 
	 @ReportTitle = N'Danh sách nhân viên', @ReportTitleE = N'LABOUR LIST',
	 @Description = N'Danh sách nhân viên', @DescriptionE = N'LABOUR LIST', 
	 @Type = 10, @SQLstring = N'SELECT * FROM HV1400 WHERE DivisionID = @DivisionID', @Orderby = N'ORDER BY EmployeeID ASC',
	 @TEST = 0, @TableID = N'HT8888'	
---- Add HR0318
--EXEC AP8888 @GroupID = N'G03', @ModuleID = 'ASoftHR', @ReportID = N'HR0318', 
--	 @ReportName = N'Tờ khai tham gia bảo hiểm xã hội, bảo hiểm y tế', @ReportNameE = N'Labor list join in social insurance, health insurance', 
--	 @ReportTitle = N'TỜ KHAI THAM GIA BHXH, BHYT', @ReportTitleE = N'LABOR LIST JOIN IN SOCIAL INSURANCE, HEALTH INSURANCE',
--	 @Description = N'TỜ KHAI THAM GIA BHXH, BHYT', @DescriptionE = N'LABOR LIST JOIN IN SOCIAL INSURANCE, HEALTH INSURANCE', 
--	 @Type = 1, @SQLstring = N'', @Orderby = N'',
--	 @TEST = 0, @TableID = N'HT8888'	 
---- Add HR0345: Danh sách tạm hoãn hợp đồng
EXEC AP8888 @GroupID = N'G21', @ModuleID = 'ASoftHR', @ReportID = N'HR0345', 
	 @ReportName = N'Danh sách tạm hoãn công ty', @ReportNameE = N'Danh sách tạm hoãn công ty', 
	 @ReportTitle = N'DANH SÁCH TẠM HOÃN CÔNG TY', @ReportTitleE = N'DANH SÁCH TẠM HOÃN CÔNG TY',
	 @Description = N'DANH SÁCH TẠM HOÃN CÔNG TY', @DescriptionE = N'DANH SÁCH TẠM HOÃN CÔNG TY', 
	 @Type = 1, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'	 
---- Add HR1380: Quyết định thôi việc
EXEC AP8888 @GroupID = N'G20', @ModuleID = 'ASoftHR', @ReportID = N'HR0345', 
	 @ReportName = N'Quyết định thôi việc', @ReportNameE = N'Deciding severance report', 
	 @ReportTitle = N'QUYẾT ĐỊNH THÔI VIỆC', @ReportTitleE = N'DECIDING SEVERANCE REPORT',
	 @Description = N'QUYẾT ĐỊNH THÔI VIỆC', @DescriptionE = N'DECIDING SEVERANCE REPORT', 
	 @Type = 1, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'

---- Update Report
update HT8888 Set GroupID = 'G01', Type = 1 WHere ReportID in ('HR1407','HR1408','HR1410')

---- Delete Report
Delete HT8888STD Where ReportID = 'HR0318'
Delete HT8888 Where ReportID = 'HR0318'

---- Add HR2488: DANH SÁCH ĐỀ NGHỊ ĐIỀU CHỈNH HỒ SƠ CẤP SỔ BHXH, THẺ BHYT
EXEC AP8888 @GroupID = N'G03', @ModuleID = 'ASoftHR', @ReportID = N'HR2488', 
	 @ReportName = N'D07-TS', @ReportNameE = N'D07-TS', 
	 @ReportTitle = N'DANH SÁCH ĐỀ NGHỊ ĐIỀU CHỈNH HỒ SƠ CẤP SỔ BHXH, THẺ BHYT', @ReportTitleE = N'DANH SÁCH ĐỀ NGHỊ ĐIỀU CHỈNH HỒ SƠ CẤP SỔ BHXH, THẺ BHYT',
	 @Description = N'DANH SÁCH ĐỀ NGHỊ BHXH, BHYT', @DescriptionE = N'DANH SÁCH ĐỀ NGHỊ BHXH, BHYT', 
	 @Type = 80, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'
EXEC AP8888 @GroupID = N'G03', @ModuleID = 'ASoftHR', @ReportID = N'HR2488A', 
	 @ReportName = N'03a-DS/CLS', @ReportNameE = N'03a-DS/CLS', 
	 @ReportTitle = N'DANH SÁCH ĐỀ NGHỊ CẤP LẠI SỔ BHXH', @ReportTitleE = N'DANH SÁCH ĐỀ NGHỊ CẤP LẠI SỔ BHXH',
	 @Description = N'DANH SÁCH ĐỀ NGHỊ BHXH, BHYT', @DescriptionE = N'DANH SÁCH ĐỀ NGHỊ BHXH, BHYT', 
	 @Type = 80, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'
EXEC AP8888 @GroupID = N'G03', @ModuleID = 'ASoftHR', @ReportID = N'HR2488B', 
	 @ReportName = N'03b-DS/CLTH', @ReportNameE = N'03b-DS/CLTH', 
	 @ReportTitle = N'DANH SÁCH ĐỀ NGHỊ CẤP LẠI THẺ BHYT', @ReportTitleE = N'DANH SÁCH ĐỀ NGHỊ CẤP LẠI THẺ BHYT',
	 @Description = N'DANH SÁCH ĐỀ NGHỊ BHXH, BHYT', @DescriptionE = N'DANH SÁCH ĐỀ NGHỊ BHXH, BHYT', 
	 @Type = 80, @SQLstring = N'', @Orderby = N'',
	 @TEST = 0, @TableID = N'HT8888'
-- Update SQLString HR2488
	Update HT8888 set SQLString =N'Select *
      From HQ2488
      Where VoucherID = ''@VoucherID''
      and DivisionID = @DivisionID' where ReportID ='HR2488' and Type = 80 and GroupID ='G03'
	Update HT8888 set SQLString =N'Select *
      From HQ2488
      Where VoucherID = ''@VoucherID''
      and DivisionID = @DivisionID' where ReportID ='HR2488A' and Type = 80 and GroupID ='G03'
	Update HT8888 set SQLString =N'Select *
      From HQ2488
      Where VoucherID = ''@VoucherID''
      and DivisionID = @DivisionID' where ReportID ='HR2488B' and Type = 80 and GroupID ='G03'