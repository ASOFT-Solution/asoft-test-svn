IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0070]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV0070]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- <Summary>
---- Đổ dữ liệu nguồn cho màn hình thiết lập Customize Report
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 22/11/2011 by Nguyễn Bình Minh
---- Modify by Lê Thị Hạnh on 02/10/2014: Bổ sung OID, IID - Báo cáo theo dõi chiết kháu cho Sài Gòn Petro - CUstomoze Index: 36
---- 
---- Modified on 03/07/2013 by Lê Thị Thu Hiền : Bổ sung thêm ICode
---- Modified on 02/10/2014 by Lê Thị Thu Hiền : Bổ sung thêm Trạng thái quyết toán (BOURBON)
-- <Example>
---- 
CREATE VIEW [DBO].[AV0070]
AS 
SELECT 'TextBox' AS Code, 'TextBox' AS Name, 'TextBox' AS NameE, 'ControlType' AS DataType, '0,1' AS Filter, NULL AS DivisionID
UNION
SELECT 'DateTimePicker' AS Code, 'DateTimePicker' AS Name, 'DateTimePicker' AS NameE, 'ControlType' AS DataType, '2' AS Filter, NULL AS DivisionID
UNION
SELECT 'Label' AS Code, 'Label' AS Name, 'Label' AS NameE, 'ControlType' AS DataType, '0' AS Filter, NULL AS DivisionID
UNION
SELECT 'ComboBox' AS Code, 'ComboBox' AS Name, 'ComboBox' AS NameE, 'ControlType' AS DataType, '0,1' AS Filter, NULL AS DivisionID
UNION
SELECT 'CheckBox' AS Code, 'CheckBox' AS Name, 'CheckBox' AS NameE, 'ControlType' AS DataType, '1' AS Filter, NULL AS DivisionID
UNION
SELECT 'RadioButton' AS Code, 'RadioButton' AS Name, 'RadioButton' AS NameE, 'ControlType' AS DataType, '1' AS Filter, NULL AS DivisionID

UNION
SELECT '0' AS Code, N'Chuỗi' AS Name, 'String' AS NameE, 'DataType' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT '1' AS Code, N'Số' AS Name, 'Number' AS NameE, 'DataType' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT '2' AS Code, N'Ngày tháng' AS Name, 'Date' AS NameE, 'DataType' AS DataType, '' AS Filter, NULL AS DivisionID

UNION
SELECT 'ACC' AS Code, N'Tài khoản' AS Name, N'Account' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'OBJ' AS Code, N'Đối tượng' AS Name, N'Object' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'CUR' AS Code, N'Loại tiền' AS Name, N'Currency' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'WH' AS Code, N'Kho' AS Name, N'WareHouse' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'VT' AS Code, N'Loại chứng từ' AS Name, N'Voucher Type' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'INV' AS Code, N'Mặt hàng' AS Name, N'Inventory' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'EMP' AS Code, N'Nhân viên' AS Name, N'Employee' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'EMPHV1400' AS Code, N'Hồ sơ lương' AS Name, N'Profile' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'DEV' AS Code, N'Phòng ban' AS Name, N'Department' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'YEAR' AS Code, N'Năm' AS Name, N'Year' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'DEVICEGROUP' AS Code, N'Nhóm phương tiện' AS Name, N'Device group' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'DEVICE' AS Code, N'Phương tiện' AS Name, N'Device' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT DISTINCT TypeID AS Code, UserName AS Name, UserNameE AS NameE, 'DataSource' AS DataType, '' AS Filter, DivisionID AS DivisionID
FROM AT0005 WHERE IsUsed = 1 
UNION
SELECT 'TYPE' AS Code, N'Phân loại' AS Name, N'TypeID' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'DEVICETYPE' AS Code, N'Loại phương tiện' AS Name, N'DeviceType' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION 
SELECT 'IID' AS Code, N'Nhóm hàng' AS NAME, N'GroupInventory' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION 
SELECT 'OID' AS Code, N'Khu vực' AS NAME, N'Area' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'SEST' AS Code, N'Trạng thái quyết toán' AS Name, N'Settlement Status' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'SOrderID' AS Code, N'Yêu cầu dịch vụ tổng' AS Name, N'Yêu cầu dịch vụ tổng' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'PERIODID' AS Code, N'Kỳ lương' AS Name, N'Kỳ lương' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'PROJECTID' AS Code, N'Công trình' AS Name, N'Công trình' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'SHIFTCODE' AS Code, N'Ca làm việc' AS Name, N'Ca làm việc' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'PERIODHRM' AS Code, N'Kỳ kế toán HRM' AS Name, N'Kỳ kế toán HRM' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'I01ID-SECOIN' AS Code, N'Phân loại gạch' AS Name, N'Phân loại gạch' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID
UNION
SELECT 'TEAM' AS Code, N'Tổ nhóm' AS Name, N'Team' AS NameE, 'DataSource' AS DataType, '' AS Filter, NULL AS DivisionID



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
