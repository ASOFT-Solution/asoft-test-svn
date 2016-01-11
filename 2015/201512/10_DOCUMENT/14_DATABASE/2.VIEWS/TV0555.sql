IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[TV0555]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[TV0555]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
-- Created by Quoc Hoai, Date 06/04/2004 
-- VIEW chet - chua ten cac table danh muc 
--- Modify on 15/08/2013 by Bao Anh: Bo sung cac table thong tin nhan vien va to nhom
--- Modify on 15/08/2013 by Thanh Sơn: Bổ sung 2 bảng Danh mục hợp đồng và chi tiết hợp đồng
--- Modified by Tiểu Mai on 11/01/2016: Bổ sung 3 bảng Danh mục bộ định mức theo quy cách.

CREATE VIEW TV0555 AS 

----------------------------------------------------------------------------------------------
-- Tiếng Việt
--SELECT 'AT1001' AS TABLENAME, N'Quốc gia' AS NOTE, 'CountryID' AS IDTable 
--UNION SELECT 'AT1101', N'Đơn vị', 'DivisionID' 
--UNION SELECT 'AT1002', N'Tỉnh - Thành phố',        'CityID' 
--UNION SELECT 'AT1003', N'Vùng - Khu vực', 'AreaID' 
--UNION SELECT 'AT1004', N'Loại tiền', 'CurrencyID' 
--UNION SELECT 'AT1005', N'DM Tài khoản', 'AccountID' 
--UNION SELECT 'AT1006', N'DM Nhóm tài khoản', 'GroupID' 
--UNION SELECT 'AT1007', N'DM Loại chứng từ', 'VoucherTypeID' 
--UNION SELECT 'AT1008', N'DM Loại bút toán', 'TransactionTypeID' 
--UNION SELECT 'AT1009', N'DM Loại hóa đơn', 'VATTypeID' 
--UNION SELECT 'AT1010', N'DM Nhóm thuế', 'VATGroupID' 
--UNION SELECT 'AT1011', N'DM Khoản mục', 'AnaID' 
--UNION SELECT 'AT1102', N'Phòng ban', 'DepartmentID' 
--UNION SELECT 'AT1103', N'Nhân viên', 'EmployeeID' 
--UNION SELECT 'AT1104', N'Loại nhân viên', 'EmployeeTypeID' 
--UNION SELECT 'AT1201', N'Loại đối tượng', 'ObjectTypeID' 
--UNION SELECT 'AT1202', N'Đối tượng (nhà cung cấp, khách hàng)', 'ObjectID' 
--UNION SELECT 'AT1203', N'Tình trạng tài chính', 'FinanceStatusID' 
--UNION SELECT 'AT1204', N'Lĩnh vực hoạt động', 'FieldID' 
--UNION SELECT 'AT1205', N'Phương thức thanh toán', 'PaymentID' 
--UNION SELECT 'AT1207', N'Phân loại mã đối tượng', 'StypeID' 
--UNION SELECT 'AT1301', N'Loại hàng tồn kho', 'InventoryTypeID' 
--UNION SELECT 'AT1302', N'DM Hàng tồn kho', 'InventoryID' 
--UNION SELECT 'AT1303', N'DM Kho hàng', 'WareHouseID' 
--UNION SELECT 'AT1304', N'DM Đơn vị tính', 'UnitID' 
--UNION SELECT 'AT1307', N'Phân loại mã hàng tồn kho', 'ClassifyID' 
--UNION SELECT 'AT1310', N'Phân loại mã hàng', 'STypeID' 
--UNION SELECT 'AT1502', N'Danh sách nguồn vốn hình thành', 'SourceID' 
--UNION SELECT 'AT1503', N'Danh sách tài sản cố định', 'AssetID' 

----------------------------------------------------------------------------------------------
-- Tiếng Anh
SELECT 'AT1001' AS TABLENAME, N'Country' AS NOTE, 'CountryID' AS IDTable 
UNION SELECT 'AT1101', N'Division', 'DivisionID' 
UNION SELECT 'AT1002', N'Province - City',        'CityID' 
UNION SELECT 'AT1003', N'Area', 'AreaID' 
UNION SELECT 'AT1004', N'Currency', 'CurrencyID' 
UNION SELECT 'AT1005', N'Account', 'AccountID' 
UNION SELECT 'AT1006', N'Group account', 'GroupID' 
UNION SELECT 'AT1007', N'Voucher type', 'VoucherTypeID' 
UNION SELECT 'AT1008', N'Transaction type', 'TransactionTypeID' 
UNION SELECT 'AT1009', N'VAT type', 'VATTypeID' 
UNION SELECT 'AT1010', N'VAT group', 'VATGroupID' 
UNION SELECT 'AT1011', N'Analysis', 'AnaID' 
UNION SELECT 'AT1016', N'Bank AccountID', 'BankAccountID' 
UNION SELECT 'AT1102', N'Department', 'DepartmentID' 
UNION SELECT 'AT1103', N'Employee', 'EmployeeID' 
UNION SELECT 'AT1104', N'Employee type', 'EmployeeTypeID' 
UNION SELECT 'AT1201', N'Object type', 'ObjectTypeID' 
UNION SELECT 'AT1202', N'Object (supplier, customer)', 'ObjectID' 
UNION SELECT 'AT1203', N'Finance status', 'FinanceStatusID' 
UNION SELECT 'AT1204', N'Scope of business', 'FieldID' 
UNION SELECT 'AT1205', N'Payment', 'PaymentID' 
UNION SELECT 'AT1207', N'Object code classification', 'StypeID' 
UNION SELECT 'AT1301', N'Inventory type', 'InventoryTypeID' 
UNION SELECT 'AT1302', N'Inventory', 'InventoryID' 
UNION SELECT 'AT1303', N'Warehouse', 'WareHouseID' 
UNION SELECT 'AT1304', N'Unit', 'UnitID' 
UNION SELECT 'AT1307', N'Classification', 'ClassifyID' 
UNION SELECT 'AT1310', N'Inventory classification', 'STypeID' 
UNION SELECT 'AT1502', N'Capital formation', 'SourceID' 
UNION SELECT 'AT1503', N'Fixed assets', 'AssetID' 

UNION SELECT 'MT0006', N'Nhóm nguyên vật liệu thay thế', 'MaterialGroupID' 
UNION SELECT 'MT0007', N'Chi tiết Nhóm nguyên vật liệu thay thế', 'MaterialGroupID, MaterialID' 
UNION SELECT 'MT0699', N'Thiết lập phân loại chi phí theo tài khoản', 'MaterialTypeID, ExpenseID'
UNION SELECT 'MT0700', N'Thiết lập phân loại chi phí theo tài khoản', 'AccountID'
UNION SELECT 'MT1601', N'Đối tượng tập hợp chi phí', 'PeriodID'
UNION SELECT 'MT1602', N'Bộ định mức', 'ApportionID'
UNION SELECT 'MT1603', N'Định mức cho sản phẩm', 'ApportionProductID'
UNION SELECT 'MT1604', N'Bộ hệ số theo sản phẩm', 'CoefficientID'
UNION SELECT 'MT1605', N'Chi tiết Bộ hệ số theo sản phẩm', 'DeCoefficientID, CoefficientID'
UNION SELECT 'MT1606', N'Bộ hệ số theo đối tượng', 'CoefficientID'
UNION SELECT 'MT1607', N'Chi tiết Bộ hệ số theo đối tượng', 'DeCoefficientID'
UNION SELECT 'MT1608', N'Phương pháp xác đinh chi phí dỡ dang', 'InprocessID'
UNION SELECT 'MT1609', N'Đối tượng tập hợp chi phí', 'ChildPeriodID, PeriodID'
UNION SELECT 'MT1610', N'Đối tượng tập hợp chi phí', 'ExpenseID, MaterialTypeID, PeriodID'
UNION SELECT 'MT1618', N'Phương pháp xác đinh chi phí dỡ dang', 'InProcessDetailID, InprocessID'
UNION SELECT 'MT1619', N'Thiết lập Phương pháp xác định chi phí dỡ dang', 'EndMethodID'
UNION SELECT 'MT1620', N'Nhóm chi phí', 'ExpenseID'
UNION SELECT 'MT1630', N'Quy trình sản xuất', 'ProcedureID'
UNION SELECT 'MT1631', N'Chi tiết Quy trình sản xuất', 'ProcedureID, StepID, PeriodID'
UNION SELECT 'MT1701', N'Quy trình, công đoạn', 'WorkID'
UNION SELECT 'MT1702', N'Quy trình, công đoạn', 'LevelID, WorkID'
UNION SELECT 'MT2003', N'Kế hoạch sản xuất', 'PlanID'
UNION SELECT 'MT5000', N'Phương pháp phân bổ', 'DistributionID'
UNION SELECT 'MT5001', N'Thiết lập phương pháp phân bổ', 'DeDistributionID'
UNION SELECT 'MT5002', N'Mã phân bổ', 'DistributedMethod'

UNION SELECT 'HT1400', N'Hồ sơ nhân viên', 'EmployeeID'
UNION SELECT 'HT1401', N'Hồ sơ nhân viên', 'EmployeeID'
UNION SELECT 'HT1402', N'Hồ sơ nhân viên', 'EmployeeID'
UNION SELECT 'HT1403', N'Hồ sơ nhân viên', 'EmployeeID'
UNION SELECT 'HT1404', N'Hồ sơ nhân viên', 'RelationID'
UNION SELECT 'HT1405', N'Hồ sơ nhân viên', 'AssEmID'
UNION SELECT 'HT1301', N'Hồ sơ nhân viên', 'HistoryID'
UNION SELECT 'HT1412', N'Hồ sơ nhân viên', 'ResidentID'

UNION SELECT 'AT1020', N'Mã số hợp đồng', 'ContractID'
UNION SELECT 'AT1021', N'Chi tiết hợp đồng', 'ContractID'
UNION SELECT 'HT1101', N'Tổ nhóm', 'DepartmentID, TeamID'


UNION SELECT 'MT0135', N'Bộ định mức theo quy cách', 'ApportionID'
UNION SELECT 'MT0136', N'Thiết lập bộ định mức sản phẩm theo quy cách', 'ApportionID, ProductID'
UNION SELECT 'MT0137', N'Định mức NVL chi tiết cho sản phẩm', 'ApportionID, ProductID, MaterialID'
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
