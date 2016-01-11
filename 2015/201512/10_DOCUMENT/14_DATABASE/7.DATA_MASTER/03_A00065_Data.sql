-- <Summary>
---- Template import data theo template chuẩn
-- <History>
---- Create on 19/12/2011 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>

DELETE FROM A00065

INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-T''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''V.VoucherGroupID IN (''''11'''',''''99'''')''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'VoucherNo', N'Số chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'VoucherDate', N'Ngày hạch toán', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'{CheckValidVoucherDate}', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'CurrencyID', N'Loại tiền', N'Currency', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidCurrency} @ObligeCheck = 1', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'ExchangeRate', N'Tỷ giá', N'Exchange Rate', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'EmployeeID', N'Người lập phiếu', N'Employee', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidEmployee}', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'RefNo01', N'Mã tham chiếu 1 ', N'RefNo01', 
	N'', 110, 100, 0, N'NVARCHAR(250)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'SenderReceiver', N'Người nộp', N'Sender', 
	N'', 50, 250, 0, N'NVARCHAR(250)', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'SRDivisionName', N'Tên đơn vị', N'Division pay', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'SRAddress', N'Địa chỉ', N'Address', 
	N'', 110, 250, 0, N'NVARCHAR(50)', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'DebitAccountID', N'TK Nợ', N'Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID = ''''G01''''''', 1, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'VDescription', N'Diễn giải chứng từ', N'Voucher Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'Serial', N'Số serial', N'Serial', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'InvoiceNo', N'Số hoá đơn', N'Invoice No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'InvoiceDate', N'Ngày hoá đơn', N'Invoice Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'BDescription', N'Diễn giải hóa đơn', N'Invoice Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'CreditAccountID', N'TK Có', N'Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'OriginalAmount', N'Số tiền nguyên tệ', N'Original Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'ConvertedAmount', N'Số tiền quy đổi', N'Converted Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'ObjectID', N'Mã đối tượng', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidObject}', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'VATTypeID', N'Loại HĐ', N'VAT Type', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATType}', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'VATGroupID', N'Nhóm thuế', N'VAT Group', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATGroup}', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'TDescription', N'Diễn giải bút toán', N'Transaction Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'Ana01ID', N'Mã phân tích 01', N'Analysist 01', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'Ana02ID', N'Mã phân tích 02', N'Analysist 02', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'Ana03ID', N'Mã phân tích 03', N'Analysist 03', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'Ana04ID', N'Mã phân tích 04', N'Analysist 04', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'Ana05ID', N'Mã phân tích 05', N'Analysist 05', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'Ana06ID', N'Mã phân tích 06', N'Analysist 06', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna06}', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableReceiptVoucher', N'Phiếu thu', N'Receivable Receipt Voucher', N'AF0061', N'Import_Excel_PhieuThu.xls', N'EXEC AP8110 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'Ana07ID', N'Mã phân tích 07', N'Analysist 07', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna07}', 0, N'AC')
	
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-T''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''V.VoucherGroupID IN (''''12'''',''''99'''')''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'VoucherNo', N'Số chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'VoucherDate', N'Ngày hạch toán', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'{CheckValidVoucherDate}', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'CurrencyID', N'Loại tiền', N'Currency', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidCurrency} @ObligeCheck = 1', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'ExchangeRate', N'Tỷ giá', N'Exchange Rate', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'EmployeeID', N'Người lập phiếu', N'Employee', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidEmployee}', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'RefNo01', N'Mã tham chiếu 1 ', N'RefNo01', 
	N'', 110, 100, 0, N'NVARCHAR(250)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'SenderReceiver', N'Người nhận', N'Sender', 
	N'', 50, 250, 0, N'NVARCHAR(250)', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'SRDivisionName', N'Tên đơn vị', N'Division pay', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'SRAddress', N'Địa chỉ', N'Address', 
	N'', 110, 250, 0, N'NVARCHAR(50)', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'CreditAccountID', N'TK Có', N'Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID = ''''G01''''''', 1, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'VDescription', N'Diễn giải chứng từ', N'Voucher Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'Serial', N'Số serial', N'Serial', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'InvoiceNo', N'Số hoá đơn', N'Invoice No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'InvoiceDate', N'Ngày hoá đơn', N'Invoice Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'BDescription', N'Diễn giải hóa đơn', N'Invoice Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 1, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'DebitAccountID', N'TK Nợ', N'Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'OriginalAmount', N'Số tiền nguyên tệ', N'Original Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'ConvertedAmount', N'Số tiền quy đổi', N'Converted Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'ObjectID', N'Mã đối tượng', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidObject}', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'VATTypeID', N'Loại HĐ', N'VAT Type', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATType}', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'VATGroupID', N'Nhóm thuế', N'VAT Group', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATGroup}', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'TDescription', N'Diễn giải bút toán', N'Transaction Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'Ana01ID', N'Mã phân tích 01', N'Analysist 01', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'Ana02ID', N'Mã phân tích 02', N'Analysist 02', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'Ana03ID', N'Mã phân tích 03', N'Analysist 03', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'Ana04ID', N'Mã phân tích 04', N'Analysist 04', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'Ana05ID', N'Mã phân tích 05', N'Analysist 05', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'Ana06ID', N'Mã phân tích 06', N'Analysist 06', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna06}', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableReceiptVoucher', N'Phiếu chi', N'Payable Receipt Voucher', N'AF0062', N'Import_Excel_PhieuChi.xls', N'EXEC AP8111 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'Ana07ID', N'Mã phân tích 07', N'Analysist 07', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna07}', 0, N'AC')
	
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-T''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''V.VoucherGroupID IN (''''14'''',''''99'''')''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'VoucherNo', N'Số chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'VoucherDate', N'Ngày hạch toán', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'{CheckValidVoucherDate}', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'EmployeeID', N'Người lập phiếu', N'Employee', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidEmployee}', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'RefNo01', N'Mã tham chiếu 1 ', N'RefNo01', 
	N'', 110, 100, 0, N'NVARCHAR(250)', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'SenderReceiver', N'Người nộp', N'Sender', 
	N'', 50, 250, 0, N'NVARCHAR(250)', N'', 0, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'SRDivisionName', N'Tên đơn vị', N'Division pay', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'SRAddress', N'Địa chỉ', N'Address', 
	N'', 110, 250, 0, N'NVARCHAR(50)', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'DebitBankAccountID', N'Số TK ngân hàng', N'Debit Bank Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidBankAccount} @ObligeCheck = 1', 1, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'ExchangeRate', N'Tỷ giá', N'Exchange Rate', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'VDescription', N'Diễn giải chứng từ', N'Voucher Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'Serial', N'Số serial', N'Serial', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'InvoiceNo', N'Số hoá đơn', N'Invoice No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'InvoiceDate', N'Ngày hoá đơn', N'Invoice Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'BDescription', N'Diễn giải hóa đơn', N'Invoice Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'CreditAccountID', N'TK Có', N'Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'OriginalAmount', N'Số tiền nguyên tệ', N'Original Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'ConvertedAmount', N'Số tiền quy đổi', N'Converted Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'ObjectID', N'Mã đối tượng', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidObject}', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'VATTypeID', N'Loại HĐ', N'VAT Type', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATType}', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'VATGroupID', N'Nhóm thuế', N'VAT Group', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATGroup}', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'TDescription', N'Diễn giải bút toán', N'Transaction Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'Ana01ID', N'Mã phân tích 01', N'Analysist 01', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'Ana02ID', N'Mã phân tích 02', N'Analysist 02', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'Ana03ID', N'Mã phân tích 03', N'Analysist 03', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'Ana04ID', N'Mã phân tích 04', N'Analysist 04', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'Ana05ID', N'Mã phân tích 05', N'Analysist 05', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'Ana06ID', N'Mã phân tích 06', N'Analysist 06', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna06}', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceivableInBankVoucher', N'Phiếu thu qua ngân hàng', N'Receivable In Bank Voucher', N'AF0102', N'Import_Excel_PhieuThuNH.xls', N'EXEC AP8112 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'Ana07ID', N'Mã phân tích 07', N'Analysist 07', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna07}', 0, N'AB')

INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-T''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''V.VoucherGroupID IN (''''15'''',''''99'''')''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'VoucherNo', N'Số chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'VoucherDate', N'Ngày hạch toán', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'{CheckValidVoucherDate}', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'EmployeeID', N'Người lập phiếu', N'Employee', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidEmployee}', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'SenderReceiver', N'Người nộp', N'Sender', 
	N'', 50, 250, 0, N'NVARCHAR(250)', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'SRDivisionName', N'Tên đơn vị', N'Division pay', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'SRAddress', N'Địa chỉ', N'Address', 
	N'', 110, 250, 0, N'NVARCHAR(50)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'CreditBankAccountID', N'Số TK ngân hàng', N'Credit Bank Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidBankAccount} @ObligeCheck = 1', 1, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'ExchangeRate', N'Tỷ giá', N'Exchange Rate', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'VDescription', N'Diễn giải chứng từ', N'Voucher Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'Serial', N'Số serial', N'Serial', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'InvoiceNo', N'Số hoá đơn', N'Invoice No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'InvoiceDate', N'Ngày hoá đơn', N'Invoice Date', 
	N'', 80, 10, 2, N'DATETIME', N'', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'BDescription', N'Diễn giải hóa đơn', N'Invoice Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'DebitAccountID', N'TK Nợ', N'Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'OriginalAmount', N'Số tiền nguyên tệ', N'Original Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'ConvertedAmount', N'Số tiền quy đổi', N'Converted Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'ObjectID', N'Mã đối tượng', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidObject}', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'VATTypeID', N'Loại HĐ', N'VAT Type', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATType}', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'VATGroupID', N'Nhóm thuế', N'VAT Group', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATGroup}', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'TDescription', N'Diễn giải bút toán', N'Transaction Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'Ana01ID', N'Mã phân tích 01', N'Analysist 01', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'Ana02ID', N'Mã phân tích 02', N'Analysist 02', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'Ana03ID', N'Mã phân tích 03', N'Analysist 03', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'Ana04ID', N'Mã phân tích 04', N'Analysist 04', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PayableInBankVoucher', N'Phiếu chi qua ngân hàng', N'Payable In Bank Voucher', N'AF0103', N'Import_Excel_PhieuChiNH.xls', N'EXEC AP8113 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'Ana05ID', N'Mã phân tích 05', N'Analysist 05', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'Y')


INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-T''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''V.VoucherGroupID = ''''99'''' ''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'VoucherNo', N'Số chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'VoucherDate', N'Ngày hạch toán', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'{CheckValidVoucherDate}', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'EmployeeID', N'Người lập phiếu', N'Employee', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidEmployee}', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'VDescription', N'Diễn giải chứng từ', N'Voucher Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'Serial', N'Số serial', N'Serial', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'InvoiceNo', N'Số hoá đơn', N'Invoice No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'InvoiceDate', N'Ngày hoá đơn', N'Invoice Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'DueDate', N'Ngày đáo hạn', N'Due Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'BDescription', N'Diễn giải hóa đơn', N'Invoice Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'CurrencyID', N'Loại tiền', N'Currency', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidCurrency} @ObligeCheck = 1', 1, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'ExchangeRate', N'Tỷ giá', N'Exchange Rate', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'DebitAccountID', N'TK Nợ', N'Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'CreditAccountID', N'TK Có', N'Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'OriginalAmount', N'Số tiền nguyên tệ', N'Original Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'ConvertedAmount', N'Số tiền quy đổi', N'Converted Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'ObjectID', N'Đối tượng Nợ', N'Debit Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidObject}', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'CreditObjectID', N'Đối tượng Có', N'Credit Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidObject}', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'VATTypeID', N'Loại HĐ', N'VAT Type', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATType}', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'VATGroupID', N'Nhóm thuế', N'VAT Group', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATGroup}', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'TDescription', N'Diễn giải bút toán', N'Transaction Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'Ana01ID', N'Mã phân tích 01', N'Analysist 01', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'Ana02ID', N'Mã phân tích 02', N'Analysist 02', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'Ana03ID', N'Mã phân tích 03', N'Analysist 03', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'Ana04ID', N'Mã phân tích 04', N'Analysist 04', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'GeneralEntry', N'Bút toán tổng hợp', N'General Entry', N'AF0067', N'Import_Excel_PhieuTH.xls', N'EXEC AP8114 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'Ana05ID', N'Mã phân tích 05', N'Analysist 05', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'Y')



INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-T''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'JobID', N'Mã số', N'Code', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'JobName', N'Tên gọi', N'Name', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'VoucherNo', N'Chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'ObjectID', N'Đối tượng', N'Object', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidObject} @SQLFilter = ''O.ObjectID IN (SELECT AV.ObjectID FROM AV1701 AV WHERE AV.VoucherID = DT.VoucherID)''', 1, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'DebitAccountID', N'TK PB chi phí', N'Cost Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID = ''''G06''''''', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'DepValue', N'Đã phân bổ', N'Depricated Value', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'Periods', N'Số kỳ phân bổ', N'Apportion Periods', 
	N'', 50, 4, 1, N'INT', N'', 1, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'DepMonths', N'Số kỳ đã phân bổ', N'Apportioned Periods', 
	N'', 80, 4, 1, N'INT', N'', 1, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'BeginPeriod', N'Kỳ bắt đầu phân bổ', N'Begin Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidMonthYear}', 1, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'ApportionAmount', N'Mức phân bổ', N'Apportion Level', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'Description', N'Diễn giải', N'Description', 
	N'', 50, 250, 0, N'NVARCHAR(250)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'Ana01ID', N'MPT 01', N'Analysist 01', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'Ana02ID', N'MPT 02', N'Analysist 02', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'Ana03ID', N'MPT 03', N'Analysist 03', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'Ana04ID', N'MPT 04', N'Analysist 04', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeclareApportion', N'Danh sách chi phí phân bổ', N'Declare Apportion', N'AF0052', N'Import_Excel_PhieuPBCPTT.xls', N'EXEC AP8119 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'Ana05ID', N'MPT 05', N'Analysist 05', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'P')



INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-FA''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'AssetID', N'Mã tài sản', N'Asset ID', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'AssetName', N'Tên tài sản', N'Asset Name', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'AssetStatus', N'Tình trạng', N'Status', 
	N'', 50, 1, 1, N'TINYINT', N'{CheckValueInList} @Param1 = ''0,1,2,3,4,9''', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'MethodID', N'Phương pháp khấu hao', N'Dep Method', 
	N'', 50, 50, 1, N'TINYINT', N'{CheckValueInList} @Param1 = ''0,1,2''', 1, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'IsTangible', N'Tài sản hữu hình', N'Tangible Asset', 
	N'', 50, 1, 1, N'TINYINT', N'{CheckValueInList} @Param1 = ''0,1''', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'ConvertedAmount', N'Nguyên giá', N'Original Value', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'Years', N'Số năm sử dụng', N'Years', 
	N'', 50, 4, 1, N'INT', N'', 1, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'DepPeriods', N'Số kỳ khấu hao', N'Deprication Periods', 
	N'', 50, 4, 1, N'INT', N'', 1, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'DepMonths', N'Số kỳ đã khấu hao', N'Depreciated Periods', 
	N'', 50, 4, 1, N'INT', N'', 1, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'StartDate', N'Ngày bắt đầu', N'Due Date', 
	N'', 80, 10, 2, N'DATETIME', N'', 0, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'EndDate', N'Ngày kết thúc', N'Invoice Description', 
	N'', 80, 10, 2, N'DATETIME', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'ResidualValue', N'Giá trị còn lại ban đầu', N'Residual Value', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'BeginPeriod', N'Kỳ bắt đầu khấu hao', N'Dep Start Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidMonthYear}', 1, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'DepPercent', N'Tỷ lệ khấu hao', N'Dep Percent', 
	N'', 50, 2, 1, N'DECIMAL(28,8)', N'', 1, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'DepAmount', N'Mức khấu hao', N'Depricated Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'EstablishDate', N'Ngày hình thành', N'Setting Date', 
	N'', 80, 10, 2, N'DATETIME', N'', 1, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'CauseID', N'Lý do hình thành', N'Setting Reason', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT6000'', @Param2 = ''Code'', @SQLFilter = ''isASOFTFA =  1''', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'MadeYear', N'Năm sản xuất', N'Made Year', 
	N'', 50, 4, 1, N'INT', N'', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'CountryID', N'Nước sản xuất', N'Made Country', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1001'', @Param2 = ''CountryID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'Serial', N'Số hiệu', N'Serial', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'AssetGroupID', N'Nhóm tài sản', N'Asset Group', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1501'', @Param2 = ''AssetGroupID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'DepartmentID', N'Phòng ban sử dụng', N'Departments that use', 
	N'', 50, 250, 0, N'NVARCHAR(50)', N'{CheckValidDepartment}', 1, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'EmployeeID', N'Người quản lý', N'Manager', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidEmployee}', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'Notes', N'Ghi chú', N'Notes', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'AssetAccountID', N'TK tài sản', N'Asset Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID = ''''G02''''''', 1, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'DepAccountID', N'TK khấu hao', N'Deprication Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID = ''''G02''''''', 1, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'SourceID1', N'Nguồn hình thành', N'Source', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1502'', @Param2 = ''SourceID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'DebitDepAccountID1', N'Tài khoản phân bổ', N'Allocation Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID = ''''G06''''''', 1, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'Ana01ID', N'MPT 01', N'Analysist 01', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'Ana02ID', N'MPT 02', N'Analysist 02', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'Ana03ID', N'MPT 03', N'Analysist 03', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'Ana04ID', N'MPT 04', N'Analysist 04', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'FixedAsset', N'Danh sách tài sản cố định', N'Fixed Asset', N'FF0010', N'Import_Excel_DanhSachTSCD.xls', N'EXEC AP8120 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'Ana05ID', N'MPT 05', N'Analysist 05', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'AG')



INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-WM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''V.VoucherGroupID = ''''99''''''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'VoucherNo', N'Số phiếu kiểm kê', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'VoucherDate', N'Ngày kiểm kê', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'{CheckValidVoucherDate}', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'EmployeeID', N'Người lập phiếu', N'Employee', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidEmployee}', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'WareHouseID', N'Mã kho', N'Ware House', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidWareHouse} @ObligeCheck = 1', 1, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'Description', N'Diễn giải', N'Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'InventoryID', N'Mã hàng', N'Inventory', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''InventoryID'', @SQLFilter = ''TL.Disabled =  0'';{CheckDuplicateValue} @Param1 = ''VoucherNo''', 1, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'SourceNo', N'Lô tồn', N'Source No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'DebitAccountID', N'Tài khoản', N'Account ID', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID = ''''G05''''''', 1, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'AdjustQuantity', N'Số lượng điều chỉnh', N'Adjust Quantity', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'AdjustUnitPrice', N'Đơn giá điều chỉnh', N'Adjust Unit Price', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'AdjutsOriginalAmount', N'Thành tiền điều chỉnh', N'Adjust Original Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'StockTaking', N'Kiểm kê', N'Stock Taking', N'WF0018', N'Import_Excel_KiemKe.xls', N'EXEC AP8121 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'Notes', N'Ghi chú', N'Notes', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'L')
DELETE FROM A00065 WHERE ImportTransTypeID = 'DeliveryWareHouse'

INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-WM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'VoucherNo', N'Số chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'VoucherDate', N'Ngày chứng từ', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'RefNo01', N'Mã tham chiếu 1', N'Ref No 01', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'RefNo02', N'Mã tham chiếu 2', N'Ref No 02', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'ObjectID', N'Đối tượng', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'WareHouseID', N'Kho nhập', N'Ware House', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'InventoryTypeID', N'Loại mặt hàng', N'Inventory Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'EmployeeID', N'Người lập phiếu', N'Employee', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'ContactPerson', N'Người liên lạc', N'Contact Person', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'RDAddress', N'Địa chỉ giao hàng', N'RDAddress', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'Description', N'Diễn giải', N'Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'BarCode', N'Mã vạch', N'BarCode', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''BarCode'',  @SQLFilter = ''TL.Disabled =  0 AND DT.InventoryID = TL.InventoryID''', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'InventoryID', N'Mã hàng', N'Inventory', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''InventoryID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'UnitID', N'Đơn vị tính', N'Unit', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1304'', @Param2 = ''UnitID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'ReVoucherNo', N'Chứng từ nhập', N'ReVoucherNo', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'SourceNo', N'Lô nhập', N'Source No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'LimitDate', N'Hạn sử dụng', N'LimitDate', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'ConvertedQuantity', N'Số lượng xuất', N'Converted Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'ConvertedPrice', N'Đơn giá xuất', N'Converted Price', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'ActualQuantity', N'Số lượng xuất (ĐVT chuẩn)', N'Actual Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'UnitPrice', N'Đơn giá', N'Price', 
	N'', 80, 10, 1, N'DECIMAL(28,8)', N'', 1, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'OriginalAmount', N'Nguyên tệ', N'Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'DebitAccountID', N'TK Nợ', N'Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'CreditAccountID', N'TK Có', N'Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'Notes', N'Diễn giải', N'Notes', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'ActEndQty', N'Tồn cuối', N'End Quantity', 
	N'', 50, 50, 1, N'DECIMAL(28,8)', N'', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'Ana01ID', N'MPT 01', N'Analysist 01', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'Ana02ID', N'MPT 02', N'Analysist 02', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'Ana03ID', N'MPT 03', N'Analysist 03', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'Ana04ID', N'MPT 04', N'Analysist 04', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'Ana05ID', N'MPT 05', N'Analysist 05', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'Ana06ID', N'MPT 06', N'Analysist 06', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna06}', 0, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'Ana07ID', N'MPT 07', N'Analysist 07', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna07}', 0, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 37, N'Ana08ID', N'MPT 08', N'Analysist 08', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna08}', 0, N'AH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 38, N'Ana09ID', N'MPT 09', N'Analysist 09', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna09}', 0, N'AI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 39, N'Ana10ID', N'MPT 10', N'Analysist 10', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna10}', 0, N'AJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 40, N'PeriodID', N'Mã đối tượng THCP', N'Object collect Cost', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''MT1601'', @Param2 = ''PeriodID'', @SQLFilter = ''TL.Disabled =  0 AND TL.FromYear*100+TL.FromMonth <= RIGHT(DT.Period, 4)*100 + LEFT(DT.Period, 2) AND RIGHT(DT.Period, 4)*100 + LEFT(DT.Period, 2) <= TL.ToYear*100+TL.ToMonth''', 0, N'AK')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'DeliveryWareHouse', N'Xuất kho', N'Delivery WareHouse', N'WF0012', N'Import_Excel_PhieuXK.xls', N'EXEC AP8124 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 41, N'ProductID', N'Mã sản phẩm', N'Product', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AL')

DELETE FROM A00065 WHERE ImportTransTypeID = N'ReceiveWareHouse'

INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-WM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'VoucherNo', N'Số chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'VoucherDate', N'Ngày chứng từ', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'RefNo01', N'Mã tham chiếu 1', N'Ref No 01', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'RefNo02', N'Mã tham chiếu 2', N'Ref No 02', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'ObjectID', N'Đối tượng', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'WareHouseID', N'Kho nhập', N'Ware House', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'InventoryTypeID', N'Loại mặt hàng', N'Inventory Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'EmployeeID', N'Nguười lập phiếu', N'Employee', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'Description', N'Diễn giải', N'Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'BarCode', N'Mã vạch', N'BarCode', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''BarCode'',  @SQLFilter = ''TL.Disabled =  0 AND DT.InventoryID = TL.InventoryID''', 0, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'InventoryID', N'Mã hàng', N'Inventory', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''InventoryID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'UnitID', N'Đơn vị tính', N'Unit', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1304'', @Param2 = ''UnitID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'ActualQuantity', N'Số lượng', N'Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'UnitPrice', N'Đơn giá', N'Price', 
	N'', 80, 10, 1, N'DECIMAL(28,8)', N'', 1, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'OriginalAmount', N'Nguyên tệ', N'Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'SourceNo', N'Lô nhập', N'Source No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'LimitDate', N'Hạn sử dụng', N'LimitDate', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'DebitAccountID', N'TK Nợ', N'Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'CreditAccountID', N'TK Có', N'Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'Notes', N'Diễn giải', N'Notes', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'Ana01ID', N'MPT 01', N'Analysist 01', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'Ana02ID', N'MPT 02', N'Analysist 02', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'Ana03ID', N'MPT 03', N'Analysist 03', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'Ana04ID', N'MPT 04', N'Analysist 04', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'Ana05ID', N'MPT 05', N'Analysist 05', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'Ana06ID', N'MPT 06', N'Analysist 06', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna06}', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'Ana07ID', N'MPT 07', N'Analysist 07', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna07}', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'Ana08ID', N'MPT 08', N'Analysist 08', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna08}', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'Ana09ID', N'MPT 09', N'Analysist 09', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna09}', 0, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'Ana10ID', N'MPT 10', N'Analysist 10', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna10}', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'PeriodID', N'Mã đối tượng THCP', N'Object collect Cost', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''MT1601'', @Param2 = ''PeriodID'', @SQLFilter = ''TL.Disabled =  0 AND TL.FromYear*100+TL.FromMonth <= RIGHT(DT.Period, 4)*100 + LEFT(DT.Period, 2) AND RIGHT(DT.Period, 4)*100 + LEFT(DT.Period, 2) <= TL.ToYear*100+TL.ToMonth''', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'ProductID', N'Mã sản phẩm', N'Product', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AF')



--- Modify by Phuong Thao on 18/11/2015 : Bo sung thong tin don hang mua va thong tin Hoa Don mua hang
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'PONo', N'Số đơn hàng', N'PO No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 37, N'PEmployeeID', N'Người lập phiếu MH', N'PEmployeeID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 38, N'InvoiceNo', N'Số HĐ MH', N'InvoiceNo', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 39, N'Serial', N'Số Serial MH', N'Serial', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 40, N'CurrencyID', N'Loại tiền', N'CurrencyID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AK')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ReceiveWareHouse', N'Nhập kho', N'Receive WareHouse', N'WF0011', N'Import_Excel_PhieuNK.xls', N'EXEC AP8123 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 41, N'ExchangeRate', N'Tỷ giá', N'ExchangeRate', 
	N'', 80, 50, 1, N'DECIMAL(28,8)', N'', 0, N'AL')



DELETE FROM A00065 WHERE ImportTransTypeID = N'PurchaseInvoice'

INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-T''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'IsWareHouse', N'Xuất kho', N'IsWareHouse', 
	N'', 50, 10, 1, N'TINYINT', N'', 1, N'D3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'WareHouseVoucherTypeID', N'Loại chứng từ nhập kho', N'WareHouse Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 0, @SQLFilter = ''VoucherGroupID IN (''''99'''', ''''31'''')''', 0, N'D4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'VoucherNo', N'Số chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'VoucherDate', N'Ngày chứng từ', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'EmployeeID', N'Người lập phiếu', N'Employee', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'VDescription', N'Diễn giải chứng từ', N'Voucher Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'Serial', N'Số serial', N'Serial', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 0, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'InvoiceNo', N'Số hoá đơn', N'Invoice No', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'InvoiceDate', N'Ngày hoá đơn', N'Invoice Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'VATTypeID', N'Loại Hóa Đơn', N'VAT Type', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATType}', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'DueDate', N'Ngày đáo hạn', N'Due Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'CurrencyID', N'Loại tiền', N'Currency', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidCurrency} @ObligeCheck = 1', 1, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'ExchangeRate', N'Tỷ giá', N'Exchange Rate', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'ObjectID', N'Đối tượng', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'VATObjectID', N'Đối tượng VAT', N'VAT Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'PaymentTermID', N'Điều khoản thanh toán', N'Payment Term', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1208'', @Param2 = ''PaymentTermID'',  @SQLFilter = ''TL.Disabled =  0 ''', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'BDescription', N'Diễn giải hóa đơn', N'Batch Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'GTGTObjectID', N'Đối tượng', N'GTGT Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'GTGTDebitAccountID', N'TK Nợ Thuế GTGT', N'GTGT Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 0, @SQLFilter = ''A.GroupID <> ''''G00''''''', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'GTGTCreditAccountID', N'TK Có Thuế GTGT', N'GTGT Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 0, @SQLFilter = ''A.GroupID <> ''''G00''''''', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'InventoryID', N'Mã hàng', N'Inventory', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''InventoryID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'UnitID', N'Đơn vị tính', N'Unit', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1304'', @Param2 = ''UnitID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'Quantity', N'Số lượng', N'Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'UnitPrice', N'Đơn giá', N'Unit Price', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'DiscountRate', N'Tỷ lệ chiết khấu', N'Discount Rate', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'DiscountAmount', N'Thành tiền chiết khấu', N'Discount Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'OriginalAmount', N'Nguyên tệ quy đổi', N'Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'ConvertedAmount', N'Thành tiền quy đổi', N'Converted Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'DebitAccountID', N'TK Nợ', N'Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'CreditAccountID', N'TK Có', N'Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'VATGroupID', N'Nhóm thuế', N'VAT Group', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATGroup}', 0, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'TDescription', N'Diễn giải bút toán', N'Transaction Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'Ana01ID', N'MPT 01', N'Analysist 01', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 37, N'Ana02ID', N'MPT 02', N'Analysist 02', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 38, N'Ana03ID', N'MPT 03', N'Analysist 03', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 39, N'Ana04ID', N'MPT 04', N'Analysist 04', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'AH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 40, N'Ana05ID', N'MPT 05', N'Analysist 05', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'AI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 41, N'WareHouseImVoucherNo', N'Số chứng từ nhập kho', N'Ware House Import Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 42, N'WareHouseImVoucherDate', N'Ngày nhập kho', N'Ware House Import VoucherDate', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'AK')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 43, N'WareHouseIm', N'Kho nhập', N'Ware House Import', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AL')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 44, N'SourceNo', N'Lô nhập', N'Source No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1303'', @Param2 = ''WareHouseID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'AM')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 45, N'WHDescription', N'Diễn giải phiếu nhập', N'Ware House Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'AN')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 46, N'WHDebitAccountID', N'TK Nợ phiếu nhập', N'Ware House Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 0, @SQLFilter = ''A.GroupID <> ''''G00''''''', 0, N'AO')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseInvoice', N'Hóa đơn mua hàng', N'Purchase Invoice', N'AF0063', N'Import_Excel_HoaDonMH.xls', N'EXEC AP8126 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 47, N'WHCreditAccountID', N'TK Có phiếu nhập', N'Ware House Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 0, @SQLFilter = ''A.GroupID <> ''''G00''''''', 0, N'AP')
DELETE FROM A00065 WHERE ImportTransTypeID = N'SalesInvoice'

INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-WM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'IsWareHouse', N'Xuất kho', N'IsWareHouse', 
	N'', 50, 10, 1, N'TINYINT', N'', 1, N'D3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'WareHouseVoucherTypeID', N'Loại chứng từ xuất kho', N'WareHouse Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 0, @SQLFilter = ''''', 0, N'D4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'VoucherNo', N'Số chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'VoucherDate', N'Ngày chứng từ', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'EmployeeID', N'Người lập phiếu', N'Employee', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'VDescription', N'Diễn giải chứng từ', N'Voucher Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'Serial', N'Số serial', N'Serial', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 0, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'InvoiceNo', N'Số hoá đơn', N'Invoice No', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'InvoiceDate', N'Ngày hoá đơn', N'Invoice Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'VATTypeID', N'Loại Hóa Đơn', N'VAT Type', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATType}', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'DueDate', N'Ngày đáo hạn', N'Due Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'CurrencyID', N'Loại tiền', N'Currency', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidCurrency} @ObligeCheck = 1', 1, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'ExchangeRate', N'Tỷ giá', N'Exchange Rate', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'ObjectID', N'Đối tượng', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'VATObjectID', N'Đối tượng VAT', N'VAT Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'PaymentTermID', N'Điều khoản thanh toán', N'Payment Term', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1208'', @Param2 = ''PaymentTermID'',  @SQLFilter = ''TL.Disabled =  0 ''', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'BDescription', N'Diễn giải hóa đơn', N'Batch Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'GTGTObjectID', N'Đối tượng', N'GTGT Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'GTGTDebitAccountID', N'TK Nợ Thuế GTGT', N'GTGT Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 0, @SQLFilter = ''A.GroupID <> ''''G00''''''', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'GTGTCreditAccountID', N'TK Có Thuế GTGT', N'GTGT Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 0, @SQLFilter = ''A.GroupID <> ''''G00''''''', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'InventoryID', N'Mã hàng', N'Inventory', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''InventoryID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'UnitID', N'Đơn vị tính', N'Unit', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1304'', @Param2 = ''UnitID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'Quantity', N'Số lượng', N'Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'UnitPrice', N'Đơn giá', N'Unit Price', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 1, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'DiscountRate', N'Tỷ lệ chiết khấu', N'Discount Rate', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'DiscountAmount', N'Thành tiền chiết khấu', N'Discount Amount', 
	N'', 80, 20, 1, N'DECIMAL(28,8)', N'', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'OriginalAmount', N'Nguyên tệ quy đổi', N'Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'ConvertedAmount', N'Thành tiền quy đổi', N'Converted Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'VATGroupID', N'Nhóm thuế', N'VAT Group', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVATGroup}', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'DebitAccountID', N'TK Nợ', N'Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'CreditAccountID', N'TK Có', N'Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'TDescription', N'Diễn giải bút toán', N'Transaction Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'Ana01ID', N'MPT 01', N'Analysist 01', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 37, N'Ana02ID', N'MPT 02', N'Analysist 02', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 38, N'Ana03ID', N'MPT 03', N'Analysist 03', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 39, N'Ana04ID', N'MPT 04', N'Analysist 04', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'AH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 40, N'Ana05ID', N'MPT 05', N'Analysist 05', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'AI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 41, N'WareHouseExVoucherNo', N'Số chứng từ xuất kho', N'Ware House Export Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 42, N'WareHouseExVoucherDate', N'Ngày xuất kho', N'Ware House Export VoucherDate', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'AK')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 43, N'WareHouseImVoucherNo', N'Số chứng từ nhập kho', N'Ware House Import Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AL')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 44, N'WareHouseEx', N'Kho xuất', N'Ware House Export', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1303'', @Param2 = ''WareHouseID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'AM')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 45, N'SourceNo', N'Lô xuất', N'Source No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AN')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 46, N'WHContactPerson', N'Người liên lạc phiếu xuất', N'Ware House Contact Person', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'AO')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 47, N'WHRDAddress', N'Địa chỉ giao hàng phiếu xuất', N'Ware House RDAddress', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'AP')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 48, N'WHDescription', N'Diễn giải phiếu xuất', N'Ware House Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'AQ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 49, N'WHDebitAccountID', N'TK Nợ phiếu xuất', N'Ware House Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 0, @SQLFilter = ''A.GroupID <> ''''G00''''''', 0, N'AR')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesInvoice', N'Hóa đơn bán hàng', N'Sales Invoice', N'AF0066', N'Import_Excel_HoaDonBH.xls', N'EXEC AP8125 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 50, N'WHCreditAccountID', N'TK Có phiếu xuất', N'Ware House Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 0, @SQLFilter = ''A.GroupID <> ''''G00''''''', 0, N'AS')
DELETE FROM A00065 WHERE ImportTransTypeID = N'PurchaseOrder'

------------------------- DON HANG MUA
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Period', N'Kỳ kế toán', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-OP''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'PurchaseNo', N'Phiếu mua hàng', N'Purchase No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'PurchaseDate', N'Ngày phiếu mua', N'Purchase Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'ContractNo', N'Số hợp đồng', N'Contract No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'ContractDate', N'Ngày ký HĐ', N'Contract Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'CurrencyID', N'Loại tiền', N'Currency', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidCurrency} @ObligeCheck = 1', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'ExchangeRate', N'Tỷ giá', N'Exchange Rate', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'ClassifyID', N'Phân loại đơn hàng', N'Classify', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0058', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'Status', N'Tình trạng', N'Status', 
	N'', 50, 1, 1, N'TINYINT', N'', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'MasterShipDate', N'Ngày giao hàng', N'Ship Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'InventoryTypeID', N'Loại mặt hàng', N'Inventory Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'EmployeeID', N'Người theo dõi', N'Employee', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'Description', N'Diễn giải', N'Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'ObjectID', N'Nhà cung cấp', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'TaxID', N'Mã số thuế', N'Tax', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'DueDate', N'Ngày đáo hạn', N'Due Date', 
	N'', 80, 10, 2, N'DATETIME', N'', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'OrderAddress', N'Địa chỉ', N'OrderAddress', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'ReceivedAddress', N'Địa chỉ nhận hàng', N'Received Address', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'Transport', N'Phương tiện vận chuyển', N'Transport', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'PaymentTermID', N'Điều kiện thanh toán', N'Payment Term', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'Varchar01', N'Tên điều kiện thanh toán', N'Parameter 01', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'PaymentID', N'Phương thức thanh toán', N'Payment', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'Varchar02', N'Tên phương thức thanh toán', N'Parameter 02', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'POAna01ID', N'Mã phân tích đơn hàng 01', N'', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''OT1002'', @Param2 = ''AnaID'',  @SQLFilter = ''TL.Disabled =  0 AND TL.AnaTypeID = ''''P01''''''', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'POAna02ID', N'Mã phân tích đơn hàng 02', N'', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''OT1002'', @Param2 = ''AnaID'',  @SQLFilter = ''TL.Disabled =  0 AND TL.AnaTypeID = ''''P02''''''', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'POAna03ID', N'Mã phân tích đơn hàng 03', N'', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''OT1002'', @Param2 = ''AnaID'',  @SQLFilter = ''TL.Disabled =  0 AND TL.AnaTypeID = ''''P03''''''', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'POAna04ID', N'Mã phân tích đơn hàng 04', N'', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''OT1002'', @Param2 = ''AnaID'',  @SQLFilter = ''TL.Disabled =  0 AND TL.AnaTypeID = ''''P04''''''', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'POAna05ID', N'Mã phân tích đơn hàng 05', N'', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''OT1002'', @Param2 = ''AnaID'',  @SQLFilter = ''TL.Disabled =  0 AND TL.AnaTypeID = ''''P05''''''', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'BarCode', N'Mã vạch', N'BarCode', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''BarCode'',  @SQLFilter = ''TL.Disabled =  0 AND DT.InventoryID = TL.InventoryID''', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'InventoryID', N'Mã hàng', N'Inventory', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''InventoryID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'UnitID', N'Đơn vị tính', N'Unit', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1304'', @Param2 = ''UnitID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'ConvertedQuantity', N'Số lượng', N'Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'ConvertedSaleprice', N'Đơn giá', N'Price', 
	N'', 80, 10, 1, N'DECIMAL(28,8)', N'', 1, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'OrderQuantity', N'Số lượng (ĐVT chuẩn)', N'Order Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 37, N'PurchasePrice', N'Đơn giá (ĐVT chuẩn)', N'Purchase Price', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'AH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 38, N'OriginalAmount', N'Nguyên tệ', N'Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'AI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 39, N'ConvertedAmount', N'Quy đổi', N'Converted Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'AJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 40, N'DiscountPercent', N'% Chiết khấu', N'Discount Percent', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AK')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 41, N'DiscountOriginalAmount', N'Chiết khấu nguyên tệ', N'Discount Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AL')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 42, N'DiscountConvertedAmount', N'Chiết khấu', N'Discount Converted Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AM')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 43, N'VATPercent', N'%Thuế GTGT', N'VAT Percent', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AN')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 44, N'VATOriginalAmount', N'Thuế GTGT nguyên tệ', N'VAT Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AO')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 45, N'VATConvertedAmount', N'Thuế GTGT', N'VAT Converted Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AP')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 46, N'ImTaxPercent', N'%Thuế nhập khẩu', N'Im Tax Percent', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AQ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 47, N'ImTaxOriginalAmount', N'Thuế nhập khẩu nguyên tệ', N'Im Tax Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AR')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 48, N'ImTaxConvertedAmount', N'Thuế nhập khẩu', N'Im Tax Converted Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AS')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 49, N'IsPicking', N'Giữ chỗ', N'IsPicking', 
	N'', 50, 1, 1, N'TINYINT', N'', 0, N'AT')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 50, N'WareHouseID', N'Kho giữ chỗ', N'Ware House', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AU')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 51, N'Finish', N'Hoàn tất', N'Finish', 
	N'', 50, 1, 1, N'TINYINT', N'', 0, N'AV')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 52, N'Ana01ID', N'Khoản mục 1', N'Ana01ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'AW')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 53, N'Ana02ID', N'Khoản mục 2', N'Ana02ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'AX')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 54, N'Ana03ID', N'Khoản mục 3', N'Ana03ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'AY')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 55, N'Ana04ID', N'Khoản mục 4', N'Ana04ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'AZ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 56, N'Ana05ID', N'Khoản mục 5', N'Ana05ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'BA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 57, N'Ana06ID', N'Khoản mục 6', N'Ana06ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna06}', 0, N'BB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 58, N'Ana07ID', N'Khoản mục 7', N'Ana07ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna07}', 0, N'BC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 59, N'Ana08ID', N'Khoản mục 8', N'Ana08ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna08}', 0, N'BD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 60, N'Ana09ID', N'Khoản mục 9', N'Ana09ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna09}', 0, N'BE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 61, N'Ana10ID', N'Khoản mục 10', N'Ana10ID', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValidAna10}', 0, N'BF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 62, N'Notes', N'Ghi chú 1', N'Notes', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 63, N'Notes01', N'Ghi chú 2', N'Notes01', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 64, N'Notes02', N'Ghi chú 3', N'Notes02', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 65, N'Notes03', N'Ghi chú 4', N'Notes03', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 66, N'Notes04', N'Ghi chú 5', N'Notes04', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BK')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 67, N'Notes05', N'Ghi chú 6', N'Notes05', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BL')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 68, N'Notes06', N'Ghi chú 7', N'Notes06', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BM')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 69, N'Notes07', N'Ghi chú 8', N'Notes07', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BN')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 70, N'Notes08', N'Ghi chú 9', N'Notes08', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BO')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 71, N'Notes09', N'Ghi chú 10', N'Notes09', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BP')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 72, N'DetailShipDate', N'Ngày giao hàng', N'DetailShipDate', 
	N'', 80, 10, 2, N'DATETIME', N'', 0, N'BQ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 73, N'StrParameter01', N'Tham số 01', N'StrParameter01', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BR')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 74, N'StrParameter02', N'Tham số 02', N'StrParameter02', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BS')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 75, N'StrParameter03', N'Tham số 03', N'StrParameter03', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BT')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 76, N'StrParameter04', N'Tham số 04', N'StrParameter04', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BU')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 77, N'StrParameter05', N'Tham số 05', N'StrParameter05', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BV')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 78, N'StrParameter06', N'Tham số 06', N'StrParameter06', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BW')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 79, N'StrParameter07', N'Tham số 07', N'StrParameter07', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BX')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 80, N'StrParameter08', N'Tham số 08', N'StrParameter08', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BY')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 81, N'StrParameter09', N'Tham số 09', N'StrParameter09', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'BZ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 82, N'StrParameter10', N'Tham số 10', N'StrParameter10', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'CA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 83, N'StrParameter11', N'Tham số 11', N'StrParameter11', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'CB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 84, N'StrParameter12', N'Tham số 12', N'StrParameter12', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'CC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 85, N'StrParameter13', N'Tham số 13', N'StrParameter13', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'CD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 86, N'StrParameter14', N'Tham số 14', N'StrParameter14', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'CE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 87, N'StrParameter15', N'Tham số 15', N'StrParameter15', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'CF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 88, N'StrParameter16', N'Tham số 16', N'StrParameter16', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'CG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 89, N'StrParameter17', N'Tham số 17', N'StrParameter17', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'CH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 90, N'StrParameter18', N'Tham số 18', N'StrParameter18', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'CI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 91, N'StrParameter19', N'Tham số 19', N'StrParameter19', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'CJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'PurchaseOrder', N'Đơn hàng mua', N'Purchase Order', N'OF0057', N'Import_Excel_DonHangMua.xls', N'EXEC AP8122 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 92, N'StrParameter20', N'Tham số 20', N'StrParameter20', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'CK')




----------------- Yêu cầu mua hàng
DELETE FROM A00065 WHERE ImportTransTypeID = N'OrderRequest'

INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Period', N'Kỳ kế toán', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-OP''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'RequestNo', N'Phiếu yêu cầu mua hàng', N'Request No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'RequestDate', N'Ngày phiếu yêu cầu', N'Request Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'ContractNo', N'Số hợp đồng', N'Contract No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'ContractDate', N'Ngày ký HĐ', N'Contract Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'CurrencyID', N'Loại tiền', N'Currency', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidCurrency} @ObligeCheck = 1', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'ExchangeRate', N'Tỷ giá', N'Exchange Rate', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'ClassifyID', N'Phân loại đơn hàng', N'Classify', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'Status', N'Tình trạng', N'Status', 
	N'', 50, 1, 1, N'TINYINT', N'', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'MasterShipDate', N'Ngày giao hàng', N'Ship Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'InventoryTypeID', N'Loại mặt hàng', N'Inventory Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'EmployeeID', N'Người theo dõi', N'Employee', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'Description', N'Diễn giải', N'Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'ObjectID', N'Nhà cung cấp', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'DueDate', N'Ngày đáo hạn', N'Due Date', 
	N'', 80, 10, 2, N'DATETIME', N'', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'OrderAddress', N'Địa chỉ', N'OrderAddress', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'ReceivedAddress', N'Địa chỉ nhận hàng', N'Received Address', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'Transport', N'Phương tiện vận chuyển', N'Transport', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'PaymentID', N'Phương thức thanh toán', N'Payment', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'POAna01ID', N'Mã phân tích đơn hàng 01', N'', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''OT1002'', @Param2 = ''AnaID'',  @SQLFilter = ''TL.Disabled =  0 AND TL.AnaTypeID = ''''P01''''''', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'POAna02ID', N'Mã phân tích đơn hàng 02', N'', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''OT1002'', @Param2 = ''AnaID'',  @SQLFilter = ''TL.Disabled =  0 AND TL.AnaTypeID = ''''P02''''''', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'POAna03ID', N'Mã phân tích đơn hàng 03', N'', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''OT1002'', @Param2 = ''AnaID'',  @SQLFilter = ''TL.Disabled =  0 AND TL.AnaTypeID = ''''P03''''''', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'POAna04ID', N'Mã phân tích đơn hàng 04', N'', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''OT1002'', @Param2 = ''AnaID'',  @SQLFilter = ''TL.Disabled =  0 AND TL.AnaTypeID = ''''P04''''''', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'POAna05ID', N'Mã phân tích đơn hàng 05', N'', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''OT1002'', @Param2 = ''AnaID'',  @SQLFilter = ''TL.Disabled =  0 AND TL.AnaTypeID = ''''P05''''''', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'InventoryID', N'Mã hàng', N'Inventory', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''InventoryID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'UnitID', N'Đơn vị tính', N'Unit', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1304'', @Param2 = ''UnitID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'ConvertedQuantity', N'Số lượng', N'Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'ConvertedSaleprice', N'Đơn giá', N'Price', 
	N'', 80, 10, 1, N'DECIMAL(28,8)', N'', 1, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'OrderQuantity', N'Số lượng (ĐVT chuẩn)', N'Order Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'RequestPrice', N'Đơn giá (ĐVT chuẩn)', N'Request Price', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'OriginalAmount', N'Nguyên tệ', N'Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'ConvertedAmount', N'Quy đổi', N'Converted Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'DiscountPercent', N'% Chiết khấu', N'Discount Percent', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'DiscountOriginalAmount', N'Chiết khấu nguyên tệ', N'Discount Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 37, N'DiscountConvertedAmount', N'Chiết khấu', N'Discount Converted Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 38, N'VATPercent', N'%Thuế GTGT', N'VAT Percent', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 39, N'VATOriginalAmount', N'Thuế GTGT nguyên tệ', N'VAT Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0073', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 40, N'VATConvertedAmount', N'Thuế GTGT', N'VAT Converted Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AK')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0074', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 41, N'DetailDescription', N'Diễn giải chi tiết', N'Detail Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'AL')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0075', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 42, N'Finish', N'Hoàn tất', N'Finish', 
	N'', 50, 1, 1, N'TINYINT', N'', 0, N'AM')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0076', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 43, N'Ana01ID', N'Khoản mục 1', N'Ana01ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AN')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0077', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 44, N'Ana02ID', N'Khoản mục 2', N'Ana02ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AO')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0078', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 45, N'Ana03ID', N'Khoản mục 3', N'Ana03ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AP')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0079', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 46, N'Ana04ID', N'Khoản mục 4', N'Ana04ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AQ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0080', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 47, N'Ana05ID', N'Khoản mục 5', N'Ana05ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AR')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0081', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 48, N'Ana06ID', N'Khoản mục 6', N'Ana06ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AS')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0082', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 49, N'Ana07ID', N'Khoản mục 7', N'Ana07ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AT')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0083', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 50, N'Ana08ID', N'Khoản mục 8', N'Ana08ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AU')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0084', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 51, N'Ana09ID', N'Khoản mục 9', N'Ana09ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AV')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0085', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 52, N'Ana10ID', N'Khoản mục 10', N'Ana10ID', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'', 0, N'AW')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0086', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 53, N'Notes', N'Ghi chú 1', N'Notes', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'AX')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0087', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 54, N'Notes01', N'Ghi chú 2', N'Notes01', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'AY')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'OrderRequest', N'Yêu cầu mua hàng', N'Order Request', N'OF0088', N'Import_Excel_YeuCauMuaHang.xls', N'EXEC AP8127 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 55, N'Notes02', N'Ghi chú 3', N'Notes02', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'AZ')

---------------------------->>>>>>>Tạm ứng


INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Advance', N'Tạm ứng', N'Advance', N'HF0181', N'Import_Excel_TamUng.xls', N'EXEC AP8128 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Advance', N'Tạm ứng', N'Advance', N'HF0181', N'Import_Excel_TamUng.xls', N'EXEC AP8128 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-HRM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Advance', N'Tạm ứng', N'Advance', N'HF0181', N'Import_Excel_TamUng.xls', N'EXEC AP8128 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'DepartmentID', N'Phòng ban', N'DepartmentID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Advance', N'Tạm ứng', N'Advance', N'HF0181', N'Import_Excel_TamUng.xls', N'EXEC AP8128 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'TeamID', N'Tổ nhóm', N'TeamID', 
	N'', 50, 10, 1, N'NVARCHAR(50)', N'', 0, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Advance', N'Tạm ứng', N'Advance', N'HF0181', N'Import_Excel_TamUng.xls', N'EXEC AP8128 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'EmployeeID', N'Nhân viên', N'EmployeeID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Advance', N'Tạm ứng', N'Advance', N'HF0181', N'Import_Excel_TamUng.xls', N'EXEC AP8128 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'AdvanceDate', N'Ngày tạm ứng', N'AdvanceDate', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Advance', N'Tạm ứng', N'Advance', N'HF0181', N'Import_Excel_TamUng.xls', N'EXEC AP8128 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'AdvanceAmount', N'Số tiền tạm ứng', N'AdvanceAmount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Advance', N'Tạm ứng', N'Advance', N'HF0181', N'Import_Excel_TamUng.xls', N'EXEC AP8128 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'Notes', N'Ghi chú', N'Notes', 
	N'', 50, 50, 0, N'NVARCHAR(250)', N'', 0, N'F')



----------------------------<<<<<<<<Tạm ứng

--------------------------->>>>>>>> Tạm ứng theo CMND

INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AdvanceCMND', N'Tạm ứng theo CMND', N'AdvanceCMND', N'HF0181', N'Import_Excel_TamUngCMND.xls', N'EXEC AP8129 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision} @Module = ''ASOFT-HRM''', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AdvanceCMND', N'Tạm ứng theo CMND', N'AdvanceCMND', N'HF0181', N'Import_Excel_TamUngCMND.xls', N'EXEC AP8129 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-HRM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AdvanceCMND', N'Tạm ứng theo CMND', N'AdvanceCMND', N'HF0181', N'Import_Excel_TamUngCMND.xls', N'EXEC AP8129 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'CMND', N'Mã CMND', N'CMND', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AdvanceCMND', N'Tạm ứng theo CMND', N'AdvanceCMND', N'HF0181', N'Import_Excel_TamUngCMND.xls', N'EXEC AP8129 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'AdvanceDate', N'Ngày tạm ứng', N'AdvanceDate', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AdvanceCMND', N'Tạm ứng theo CMND', N'AdvanceCMND', N'HF0181', N'Import_Excel_TamUngCMND.xls', N'EXEC AP8129 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'AdvanceAmount', N'Số tiền tạm ứng', N'AdvanceAmount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AdvanceCMND', N'Tạm ứng theo CMND', N'AdvanceCMND', N'HF0181', N'Import_Excel_TamUngCMND.xls', N'EXEC AP8129 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'Notes', N'Ghi chú', N'Notes', 
	N'', 50, 50, 0, N'NVARCHAR(250)', N'', 0, N'D')



---------------------------<<<<<<<<<Tạm ứng theo CMND
--------------------------->>>>>>>> Hồ sơ lương
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision} @Module = ''ASOFT-HRM''', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-HRM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'DepartmentID', N'Phòng ban', N'Department', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1102'', @Param2 = ''DepartmentID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'TeamID', N'Tổ nhóm', N'Team', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1101'', @Param2 = ''TeamID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'EmployeeID', N'Nhân viên', N'Employee', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1400'', @Param2 = ''EmployeeID'', @SQLFilter = ''''', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'TaxObjectID', N'Đối tượng thuế', N'Tax Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1011'', @Param2 = ''TaxObjectID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'BaseSalary', N'Lương cơ bản', N'Base Salary', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'InsuranceSalary', N'Lương BHXH', N'Insurance Salary', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'Salary01', N'Lương 1', N'Salary 1', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'Salary02', N'Lương 2', N'Salary 2', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'Salary03', N'Lương 3', N'Salary 3', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'SalaryCoefficient', N'Hệ số lương', N'Salary Coefficient', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'DutyCoefficient', N'Hệ số chức vụ', N'Duty Coefficient', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'TimeCoefficient', N'Hệ số thâm niên', N'Time Coefficient', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'C01', N'Hệ số 1', N'Coefficient 1', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'C02', N'Hệ số 2', N'Coefficient 2', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'C03', N'Hệ số 3', N'Coefficient 3', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'C04', N'Hệ số 4', N'Coefficient 4', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'C05', N'Hệ số 5', N'Coefficient 5', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'C06', N'Hệ số 6', N'Coefficient 6', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'C07', N'Hệ số 7', N'Coefficient 7', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'C08', N'Hệ số 8', N'Coefficient 8', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'C09', N'Hệ số 9', N'Coefficient 9', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'C10', N'Hệ số 10', N'Coefficient 10', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'C11', N'Hệ số 11', N'Coefficient 11', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'C12', N'Hệ số 12', N'Coefficient 12', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'C13', N'Hệ số 13', N'Coefficient 13', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'C14', N'Hệ số 14', N'Coefficient 14', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'C15', N'Hệ số 15', N'Coefficient 15', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'C16', N'Hệ số 16', N'Coefficient 16', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'C17', N'Hệ số 17', N'Coefficient 17', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'C18', N'Hệ số 18', N'Coefficient 18', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'C19', N'Hệ số 19', N'Coefficient 19', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'C20', N'Hệ số 20', N'Coefficient 20', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'C21', N'Hệ số 21', N'Coefficient 21', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'C22', N'Hệ số 22', N'Coefficient 22', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 37, N'C23', N'Hệ số 23', N'Coefficient 23', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 38, N'C24', N'Hệ số 24', N'Coefficient 24', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 39, N'C25', N'Hệ số 25', N'Coefficient 25', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AK')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 40, N'IsJobWage', N'Là lương khoán', N'Is Job Wage', 
	N'', 50, 10, 1, N'TINYINT', N'', 0, N'AL')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalaryRecord', N'Hồ sơ lương', N'Salary Record', N'HF0141', N'Import_Excel_HoSoLuong.xls', N'EXEC AP8131 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 41, N'IsPiecework', N'Là lương SP', N'Is Piece work', 
	N'', 50, 10, 1, N'TINYINT', N'', 0, N'AM')
---------------------------<<<<<<<< Hồ sơ lương
--------------------------->>>>>>>> Chấm công theo công trình
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeeping', N'Chấm công theo công trình', N'Project TimeKeeping', N'HF0265', N'Import_Excel_ChamCongTheoCongTrinh.xls', N'EXEC AP8132 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision} @Module = ''ASOFT-HRM''', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeeping', N'Chấm công theo công trình', N'Project TimeKeeping', N'HF0265', N'Import_Excel_ChamCongTheoCongTrinh.xls', N'EXEC AP8132 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-HRM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeeping', N'Chấm công theo công trình', N'Project TimeKeeping', N'HF0265', N'Import_Excel_ChamCongTheoCongTrinh.xls', N'EXEC AP8132 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'ProjectID', N'Công trình', N'Project', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1120'', @Param2 = ''ProjectID'', @SQLFilter = ''''', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeeping', N'Chấm công theo công trình', N'Project TimeKeeping', N'HF0265', N'Import_Excel_ChamCongTheoCongTrinh.xls', N'EXEC AP8132 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'PeriodID', N'Kỳ lương', N'Salary Period', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT6666'', @Param2 = ''PeriodID'', @SQLFilter = ''''', 0, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeeping', N'Chấm công theo công trình', N'Project TimeKeeping', N'HF0265', N'Import_Excel_ChamCongTheoCongTrinh.xls', N'EXEC AP8132 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'BeginDate', N'Ngày bắt đầu', N'Begin Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeeping', N'Chấm công theo công trình', N'Project TimeKeeping', N'HF0265', N'Import_Excel_ChamCongTheoCongTrinh.xls', N'EXEC AP8132 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'EndDate', N'Ngày kết thúc', N'End Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeeping', N'Chấm công theo công trình', N'Project TimeKeeping', N'HF0265', N'Import_Excel_ChamCongTheoCongTrinh.xls', N'EXEC AP8132 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'EmployeeID', N'Mã nhân viên', N'Employee ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1400'', @Param2 = ''EmployeeID'', @SQLFilter = ''''', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeeping', N'Chấm công theo công trình', N'Project TimeKeeping', N'HF0265', N'Import_Excel_ChamCongTheoCongTrinh.xls', N'EXEC AP8132 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'DepartmentID', N'Mã phòng ban', N'Department ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1102'', @Param2 = ''DepartmentID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeeping', N'Chấm công theo công trình', N'Project TimeKeeping', N'HF0265', N'Import_Excel_ChamCongTheoCongTrinh.xls', N'EXEC AP8132 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'TeamID', N'Mã tổ nhóm', N'Team ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1101'', @Param2 = ''TeamID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeeping', N'Chấm công theo công trình', N'Project TimeKeeping', N'HF0265', N'Import_Excel_ChamCongTheoCongTrinh.xls', N'EXEC AP8132 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'AbsentTypeID', N'Loại công', N'Absent Type ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1013'', @Param2 = ''AbsentTypeID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeeping', N'Chấm công theo công trình', N'Project TimeKeeping', N'HF0265', N'Import_Excel_ChamCongTheoCongTrinh.xls', N'EXEC AP8132 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'AbsentAmount', N'Số công', N'Absent Amounts', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'I')
---------------------------<<<<<<<< Chấm công theo công trình

--------------------------->>>>>>>> Phụ cấp theo công trình
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision} @Module = ''ASOFT-HRM''', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-HRM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'ProjectID', N'Công trình', N'Project', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1120'', @Param2 = ''ProjectID'', @SQLFilter = ''''', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'EmployeeID', N'Mã nhân viên', N'Employee ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1400'', @Param2 = ''EmployeeID'', @SQLFilter = ''''', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'DepartmentID', N'Mã phòng ban', N'Department ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1102'', @Param2 = ''DepartmentID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'TeamID', N'Mã tổ nhóm', N'Team ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1101'', @Param2 = ''TeamID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'BaseSalary', N'Lương cơ bản', N'Base Salary', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'Salary01', N'Lương 1', N'Salary 1', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'Salary02', N'Lương 2', N'Salary 2', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'Salary03', N'Lương 3', N'Salary 3', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'SalaryCoefficient', N'Hệ số lương', N'Salary Coefficient', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'DutyCoefficient', N'Hệ số chức vụ', N'Duty Coefficient', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'TimeCoefficient', N'Hệ số thâm niên', N'Time Coefficient', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'C01', N'Hệ số 1', N'Coefficient 1', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'C02', N'Hệ số 2', N'Coefficient 2', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'C03', N'Hệ số 3', N'Coefficient 3', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'C04', N'Hệ số 4', N'Coefficient 4', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'C05', N'Hệ số 5', N'Coefficient 5', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'C06', N'Hệ số 6', N'Coefficient 6', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'C07', N'Hệ số 7', N'Coefficient 7', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'C08', N'Hệ số 8', N'Coefficient 8', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'C09', N'Hệ số 9', N'Coefficient 9', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'C10', N'Hệ số 10', N'Coefficient 10', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'C11', N'Hệ số 11', N'Coefficient 11', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'C12', N'Hệ số 12', N'Coefficient 12', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'C13', N'Hệ số 13', N'Coefficient 13', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'C14', N'Hệ số 14', N'Coefficient 14', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'C15', N'Hệ số 15', N'Coefficient 15', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'C16', N'Hệ số 16', N'Coefficient 16', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'C17', N'Hệ số 17', N'Coefficient 17', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'C18', N'Hệ số 18', N'Coefficient 18', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'C19', N'Hệ số 19', N'Coefficient 19', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'C20', N'Hệ số 20', N'Coefficient 20', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'C21', N'Hệ số 21', N'Coefficient 21', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'C22', N'Hệ số 22', N'Coefficient 22', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'C23', N'Hệ số 23', N'Coefficient 23', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 37, N'C24', N'Hệ số 24', N'Coefficient 24', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectAllowances', N'Phụ cấp theo công trình', N'Project Allowances', N'HF0266', N'Import_Excel_PhuCapTheoCongTrinh.xls', N'EXEC AP8134 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 38, N'C25', N'Hệ số 25', N'Coefficient 25', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'AJ')
---------------------------<<<<<<<< Phụ cấp theo công trình

--------------------------->>>>>>>> Quét dữ liệu chấm công
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ScanTimeRecordData', N'Quét dữ liệu chấm công', N'ScanTimeRecordData', N'HF0197', N'Import_Excel_Quetdulieuchamcong.xls', N'EXEC AP8135 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'DivisionID', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision} @Module = ''ASOFT-HRM''', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ScanTimeRecordData', N'Quét dữ liệu chấm công', N'ScanTimeRecordData', N'HF0197', N'Import_Excel_Quetdulieuchamcong.xls', N'EXEC AP8135 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-HRM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ScanTimeRecordData', N'Quét dữ liệu chấm công', N'ScanTimeRecordData', N'HF0197', N'Import_Excel_Quetdulieuchamcong.xls', N'EXEC AP8135 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'AbsentCardNo', N'Mã số thẻ', N'AbsentCardNo', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1407'', @Param2 = ''AbsentCardNo'', @SQLFilter = ''''', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ScanTimeRecordData', N'Quét dữ liệu chấm công', N'ScanTimeRecordData', N'HF0197', N'Import_Excel_Quetdulieuchamcong.xls', N'EXEC AP8135 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'AbsentDate', N'Ngày chấm công', N'AbsentDate', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ScanTimeRecordData', N'Quét dữ liệu chấm công', N'ScanTimeRecordData', N'HF0197', N'Import_Excel_Quetdulieuchamcong.xls', N'EXEC AP8135 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'InAbsentTime', N'Giờ vào', N'InAbsentTime', 
	N'', 80, 10, 2, N'DATETIME', N'', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ScanTimeRecordData', N'Quét dữ liệu chấm công', N'ScanTimeRecordData', N'HF0197', N'Import_Excel_Quetdulieuchamcong.xls', N'EXEC AP8135 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'OutAbsentTime', N'Giờ ra', N'OutAbsentTime', 
	N'', 80, 10, 2, N'DATETIME', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ScanTimeRecordData', N'Quét dữ liệu chấm công', N'ScanTimeRecordData', N'HF0197', N'Import_Excel_Quetdulieuchamcong.xls', N'EXEC AP8135 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'MachineCode', N'Máy chấm công', N'MachineCode', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ScanTimeRecordData', N'Quét dữ liệu chấm công', N'ScanTimeRecordData', N'HF0197', N'Import_Excel_Quetdulieuchamcong.xls', N'EXEC AP8135 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'ShiftCode', N'Ca', N'ShiftCode', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ScanTimeRecordData', N'Quét dữ liệu chấm công', N'ScanTimeRecordData', N'HF0197', N'Import_Excel_Quetdulieuchamcong.xls', N'EXEC AP8135 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'InputMethod', N'Phương pháp chấm công', N'InputMethod', 
	N'', 80, 50, 1, N'TINYINT', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ScanTimeRecordData', N'Quét dữ liệu chấm công', N'ScanTimeRecordData', N'HF0197', N'Import_Excel_Quetdulieuchamcong.xls', N'EXEC AP8135 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'Notes', N'Ghi chú', N'Notes', 
	N'', 200, 250, 0, N'NVARCHAR(250)', N'', 0, N'H')
---------------------------<<<<<<<< Quét dữ liệu chấm công

--------------------------->>>>>>>> Quét dữ liệu chấm công công trình theo ca
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeepingShift', N'Chấm công theo công trình theo ca', N'Project TimeKeeping Shift', N'HF0198', N'Import_Excel_ChamCongTheoCongTrinhTheoCa.xls', N'EXEC AP8136 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision} @Module = ''ASOFT-HRM''', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeepingShift', N'Chấm công theo công trình theo ca', N'Project TimeKeeping Shift', N'HF0198', N'Import_Excel_ChamCongTheoCongTrinhTheoCa.xls', N'EXEC AP8136 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-HRM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeepingShift', N'Chấm công theo công trình theo ca', N'Project TimeKeeping Shift', N'HF0198', N'Import_Excel_ChamCongTheoCongTrinhTheoCa.xls', N'EXEC AP8136 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'AbsentCardNo', N'Mã số thẻ', N'Absent CardNo', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1407'', @Param2 = ''AbsentCardNo'', @SQLFilter = ''''', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeepingShift', N'Chấm công theo công trình theo ca', N'Project TimeKeeping Shift', N'HF0198', N'Import_Excel_ChamCongTheoCongTrinhTheoCa.xls', N'EXEC AP8136 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'ProjectID', N'Công trình', N'Project', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1120'', @Param2 = ''ProjectID'', @SQLFilter = ''''', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeepingShift', N'Chấm công theo công trình theo ca', N'Project TimeKeeping Shift', N'HF0198', N'Import_Excel_ChamCongTheoCongTrinhTheoCa.xls', N'EXEC AP8136 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'AbsentDate', N'Ngày chấm công', N'Absent Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeepingShift', N'Chấm công theo công trình theo ca', N'Project TimeKeeping Shift', N'HF0198', N'Import_Excel_ChamCongTheoCongTrinhTheoCa.xls', N'EXEC AP8136 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'ShiftCode', N'Mã ca làm việc', N'Shift Code', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''''', 1, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeepingShift', N'Chấm công theo công trình theo ca', N'Project TimeKeeping Shift', N'HF0198', N'Import_Excel_ChamCongTheoCongTrinhTheoCa.xls', N'EXEC AP8136 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'AbsentTime', N'Giờ công', N'Absent Time', 
	N'', 80, 50, 1, N'TINYINT', N'', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeepingShift', N'Chấm công theo công trình theo ca', N'Project TimeKeeping Shift', N'HF0198', N'Import_Excel_ChamCongTheoCongTrinhTheoCa.xls', N'EXEC AP8136 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'PeriodID', N'Kỳ lương', N'Salary Period', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT6666'', @Param2 = ''PeriodID'', @SQLFilter = ''''', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'ProjectTimeKeepingShift', N'Chấm công theo công trình theo ca', N'Project TimeKeeping Shift', N'HF0198', N'Import_Excel_ChamCongTheoCongTrinhTheoCa.xls', N'EXEC AP8136 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'Notes', N'Ghi chú', N'Notes', 
	N'', 200, 250, 0, N'NVARCHAR(250)', N'', 0, N'G')
	
---------------------------<<<<<<<< Quét dữ liệu chấm công công trình theo ca

--------------------------->>>>>>>> Import số dư đầu kỳ
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-WM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'VoucherNo', N'Số chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'VoucherDate', N'Ngày chứng từ', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'ObjectID', N'Đối tượng', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'WareHouseID', N'Kho nhập', N'Ware House', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'InventoryTypeID', N'Loại mặt hàng', N'Inventory Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'EmployeeID', N'Nguười lập phiếu', N'Employee', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'Description', N'Diễn giải', N'Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'BarCode', N'Mã vạch', N'BarCode', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''BarCode'',  @SQLFilter = ''TL.Disabled =  0 AND DT.InventoryID = TL.InventoryID''', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'InventoryID', N'Mã hàng', N'Inventory', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''InventoryID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'UnitID', N'Đơn vị tính', N'Unit', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1304'', @Param2 = ''UnitID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0011', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'Parameter01', N'Dày', N'Parameter01', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0012', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'Parameter02', N'Rộng', N'Parameter02', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0013', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'Parameter03', N'Dài', N'Parameter03', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0014', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'Parameter04', N'Đường kính', N'Parameter04', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'ActualQuantity', N'Số lượng', N'Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'ConvertedQuantity', N'Số lượng quy đổi', N'Converted Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'UnitPrice', N'Đơn giá', N'Price', 
	N'', 80, 10, 1, N'DECIMAL(28,8)', N'', 1, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'OriginalAmount', N'Nguyên tệ', N'Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'MarkQuantity', N'Số lượng Mark', N'MarkQuantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'SourceNo', N'Lô nhập', N'Source No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'LimitDate', N'Hạn sử dụng', N'LimitDate', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'DebitAccountID', N'TK Nợ', N'Debit Account', 
	N'', 50, 50, 1, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'CreditAccountID', N'TK Có', N'Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'Notes', N'Diễn giải', N'Notes', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'Ana01ID', N'MPT 01', N'Analysist 01', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'Ana02ID', N'MPT 02', N'Analysist 02', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'Ana03ID', N'MPT 03', N'Analysist 03', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'Ana04ID', N'MPT 04', N'Analysist 04', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'Ana05ID', N'MPT 05', N'Analysist 05', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'Ana06ID', N'MPT 06', N'Analysist 06', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna06}', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'Ana07ID', N'MPT 07', N'Analysist 07', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna07}', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'Ana08ID', N'MPT 08', N'Analysist 08', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna08}', 0, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'Ana09ID', N'MPT 09', N'Analysist 09', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna09}', 0, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 37, N'Ana10ID', N'MPT 10', N'Analysist 10', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna10}', 0, N'AH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 38, N'PeriodID', N'Mã đối tượng THCP', N'Object collect Cost', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''MT1601'', @Param2 = ''PeriodID'', @SQLFilter = ''TL.Disabled =  0 AND TL.FromYear*100+TL.FromMonth <= RIGHT(DT.Period, 4)*100 + LEFT(DT.Period, 2) AND RIGHT(DT.Period, 4)*100 + LEFT(DT.Period, 2) <= TL.ToYear*100+TL.ToMonth''', 0, N'AI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'Balance_Stock', N'Số dư hàng tồn kho', N'Balance Stock', N'WF0010', N'Import_Excel_SDDKHangTonKho.xls', N'EXEC AP8130 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 39, N'ProductID', N'Mã sản phẩm', N'Product', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AJ')
---------------------------<<<<<<<< Import số dư đầu kỳ
------->>>>> Import Bảng giá bán [Customize Index: 36 - Sài Gòn Petro]
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'C3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'ID', N'Mã số', N'PriceList', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'Description', N'Diễn giải', N'Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'FromDate', N'Từ ngày', N'From Date', 
	N'dd/mm/yyyy', 50, 10, 2, N'DATETIME', N'', 1, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'ToDate', N'Đến ngày', N'To Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'OID', N'Nhóm đối tượng', N'Object Group', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 0, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'InventoryTypeID', N'Loại mặt hàng', N'Inventory Type', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'CurrencyID', N'Loại tiền', N'Currency', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidCurrency} @ObligeCheck = 1', 1, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'IsConvertedPrice', N'Tính giá theo tiền quy đổi', N'Caculate converted SalePrice', 
	N'', 50, 10, 1, N'TINYINT', N'', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'InheritID', N'Mã số kế thừa', N'Inherit PriceList', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'InventoryID', N'Mã hàng', N'Inventory', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''InventoryID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'UnitID', N'Đơn vị tính', N'Unit', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1304'', @Param2 = ''UnitID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'ConvertedUnitPrice', N'Đơn giá', N'ConvertedUnitPrice', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'ConvertedMinPrice', N'Giá tối thiểu', N'ConvertedMinPrice', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'ConvertedMaxPrice', N'Giá tối đa', N'ConvertedMaxPrice', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'UnitPrice', N'Đơn giá (ĐVT Chuẩn)', N'Unit Price', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'MinPrice', N'Giá tối thiểu (ĐVT Chuẩn)', N'Min Price', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'MaxPrice', N'Giá tối đa (ĐVT Chuẩn)', N'Max Price', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'DiscountPercent', N'% Chiết khấu', N'Discount Percent', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'DiscountAmount', N'Chiết khấu', N'Discount Amount', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'SaleOffPercent01', N'% Giảm giá 1', N'Sale Off Percent 1', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'SaleOffAmount01', N'Giảm giá 1', N'Sale Off Amount 1', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'SaleOffPercent02', N'% Giảm giá 2', N'Sale Off Percent 2', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'SaleOffAmount02', N'Giảm giá 2', N'Sale Off Amount 2', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'SaleOffPercent03', N'% Giảm giá 3', N'Sale Off Percent 3', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'SaleOffAmount03', N'Giảm giá 3', N'Sale Off Amount 3', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'SaleOffPercent04', N'% Giảm giá 4', N'Sale Off Percent 4', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'SaleOffAmount04', N'Giảm giá 4', N'Sale Off Amount 4', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'SaleOffPercent05', N'% Giảm giá 5', N'Sale Off Percent 5', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'SaleOffAmount05', N'Giảm giá 5', N'Sale Off Amount 5', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'Notes', N'Ghi chú', N'Notes', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'Notes01', N'Ghi chú 1', N'Notes 01', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesPrice', N'Bảng giá bán', N'Sales PriceList', N'OF0020', N'Import_Excel_BangGiaBan.xls', N'EXEC AP8137 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'Notes02', N'Ghi chú 2', N'Notes 02', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'AF')
-------<<<<< Import Bảng giá bán [Customize Index: 36 - Sài Gòn Petro]
-------<<<<< Import Bảng Phân Ca
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0035', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-HRM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'EmployeeID', N'Mã nhân viên', N'EmployeeID', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT2400'', @Param2 = ''EmployeeID'', @SQLFilter = ''TL.TranYear = RIGHT(DT.Period, 4) AND TL.TranMonth = LEFT(DT.Period, 2)''', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'FullName', N'Tên nhân viên', N'FullName', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'D01', N'1', N'1', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'D02', N'2', N'2', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'D03', N'3', N'3', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'D04', N'4', N'4', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'D05', N'5', N'5', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'D06', N'6', N'6', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'D07', N'7', N'7', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'D08', N'8', N'8', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'D09', N'9', N'9', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'D10', N'10', N'10', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'D11', N'11', N'11', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'D12', N'12', N'12', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'D13', N'13', N'13', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'D14', N'14', N'14', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'D15', N'15', N'15', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'D16', N'16', N'16', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'D17', N'17', N'17', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'D18', N'18', N'18', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'D19', N'19', N'19', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'D20', N'20', N'20', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'D21', N'21', N'21', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'D22', N'22', N'22', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'D23', N'23', N'23', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'D24', N'24', N'24', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'D25', N'25', N'25', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'D26', N'26', N'26', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'D27', N'27', N'27', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'D28', N'28', N'28', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'D29', N'29', N'29', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0034', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'D30', N'30', N'30', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0035', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'D31', N'31', N'31', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''HT1020'', @Param2 = ''ShiftID'', @SQLFilter = ''TL.Disabled =  0''', 0, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'AssignShift', N'Bảng phân ca', N'AssignedTheShiftList', N'HF0036', N'Import_Excel_BangPhanCa.xls', N'EXEC AP8138 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'Notes', N'Ghi chú', N'Notes', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'AH')
-------<<<<< Import Bảng Phân Ca
-------<<<<< Import Đơn hàng bán
DELETE FROM A00065 WHERE ImportTransTypeID = N'SalesOrder'
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'NVARCHAR(50)', N'{CheckValidPeriod} @Module = ''ASOFT-OP''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''V.VoucherGroupID IN (''''42'''',''''99'''')''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'VoucherNo', N'Số đơn hàng', N'Voucher No', 
	N'dd/mm/yyyy', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'OrderDate', N'Ngày đơn hàng', N'Order Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'ContractNo', N'Số hợp đồng', N'Contract No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'ContractDate', N'Ngày ký HĐ', N'Contract Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'CurrencyID', N'Loại tiền', N'CurrencyID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidCurrency} @ObligeCheck = 1', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'ExchangeRate', N'Tỷ giá', N'Exchange Rate', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'ClassifyID', N'Phân loại đơn hàng', N'ClassifyID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'OrderStatus', N'Tình trạng', N'OrderStatus', 
	N'', 80, 10, 1, N'TINYINT', N'', 0, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'ShipDate', N'Ngày giao hàng
(Master)', N'Ship Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'InventoryTypeID', N'Loại mặt hàng', N'Inventory Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'EmployeeID', N'Người theo dõi', N'EmployeeID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'SalesManID', N'Người bán hàng', N'SalesManID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'Notes', N'Diễn giải', N'Notes', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'ObjectID', N'Mã khách hàng', N'ObjectID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'PriceListID', N'Bảng giá', N'PriceListID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'VATObjectID', N'Đối tượng VAT', N'VATObjectID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'Address', N'Địa chỉ', N'Address', 
	N'', 80, 250, 0, N'NVARCHAR(250)', N'', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'VatNo', N'Mã số thuế', N'VatNo', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'Contact', N'Người liên hệ', N'Contact', 
	N'', 110, 250, 0, N'NVARCHAR(100)', N'', 0, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'DeliveryAddress', N'Địa chỉ giao hàng', N'Delivery Address', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'PaymentTermID', N'Phương tiện vận chuyển', N'PaymentTermID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'Transport', N'Phương tiện vận chuyển', N'Transport', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'PaymentID', N'PTTT', N'PaymentID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'BarCode', N'Mã vạch', N'BarCode', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'InventoryID', N'Mã sản phẩm', N'InventoryID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''InventoryID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'UnitID', N'Đơn vị tính', N'UnitID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''AT1304'', @Param2 = ''UnitID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'ConvertedQuantity', N'Số lượng', N'ConvertedQuantity', 
	N'', 80, 50, 1, N'DECIMAL(28,8)', N'', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'ConvertedSalePrice', N'Đơn giá', N'ConvertedSalePrice', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'OrderQuantity', N'Số lượng 
(ĐVT chuẩn)', N'OrderQuantity', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'SalePrice', N'Đơn giá 
(ĐVT chuẩn)', N'SalePrice', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'OriginalAmount', N'Nguyên tệ', N'OriginalAmount', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'ConvertedAmount', N'Quy đổi', N'ConvertedAmount', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'DiscountPercent', N'% Chiết khấu', N'DiscountPercent', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 37, N'DiscountOriginalAmount', N'Chiết khấu 
nguyên tệ', N'DiscountOriginalAmount', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 38, N'DiscountConvertedAmount', N'Chiết khấu', N'DiscountConvertedAmount', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 39, N'VATPercent', N'%Thuế GTGT', N'VATPercent', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 40, N'VATOriginalAmount', N'Thuế GTGT 
nguyên tệ', N'VATOriginalAmount', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AK')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 41, N'VATConvertedAmount', N'Thuế GTGT', N'VATConvertedAmount', 
	N'', 80, 30, 1, N'DECIMAL(28,8)', N'', 0, N'AL')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 42, N'Finish', N'Hoàn tất', N'Finish', 
	N'', 80, 10, 1, N'TINYINT', N'', 0, N'AM')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 43, N'Description', N'Diễn giải mặt hàng', N'Description', 
	N'', 110, 250, 0, N'NVARCHAR(250)', N'', 0, N'AN')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 44, N'Ana01ID', N'Khoản mục 1', N'Ana01ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'AO')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 45, N'Ana02ID', N'Khoản mục 2', N'Ana02ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'AP')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 46, N'Ana03ID', N'Khoản mục 3', N'Ana03ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'AQ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 47, N'Ana04ID', N'Khoản mục 4', N'Ana04ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'AR')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 48, N'Ana05ID', N'Khoản mục 5', N'Ana05ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'AS')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 49, N'Ana06ID', N'Khoản mục 6', N'Ana06ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna06}', 0, N'AT')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 50, N'Ana07ID', N'Khoản mục 7', N'Ana07ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna07}', 0, N'AU')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 51, N'Ana08ID', N'Khoản mục 8', N'Ana08ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna08}', 0, N'AV')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 52, N'Ana09ID', N'Khoản mục 9', N'Ana09ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna09}', 0, N'AW')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 53, N'Ana10ID', N'Khoản mục 10', N'Ana10ID', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna10}', 0, N'AX')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 54, N'nvarchar01', N'SD - Tham số 1', N'nvarchar01', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'AY')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 55, N'nvarchar02', N'SD - Tham số 2', N'nvarchar02', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'AZ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 56, N'nvarchar03', N'SD - Tham số 3', N'nvarchar03', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 57, N'nvarchar04', N'SD - Tham số 4', N'nvarchar04', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 58, N'nvarchar05', N'SD - Tham số 5', N'nvarchar05', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 59, N'nvarchar06', N'SD - Tham số 6', N'nvarchar06', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 60, N'nvarchar07', N'SD - Tham số 7', N'nvarchar07', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 61, N'nvarchar08', N'SD - Tham số 8', N'nvarchar08', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 62, N'nvarchar09', N'SD - Tham số 9', N'nvarchar09', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 63, N'nvarchar10', N'SD - Tham số 10', N'nvarchar10', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 64, N'Varchar01', N'SD - Tham số 11', N'Varchar01', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 65, N'Varchar02', N'SD - Tham số 12', N'Varchar02', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 66, N'Varchar03', N'SD - Tham số 13', N'Varchar03', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BK')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 67, N'Varchar04', N'SD - Tham số 14', N'Varchar04', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BL')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 68, N'Varchar05', N'SD - Tham số 15', N'Varchar05', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BM')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 69, N'Varchar06', N'SD - Tham số 16', N'Varchar06', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BN')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 70, N'Varchar07', N'SD - Tham số 17', N'Varchar07', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BO')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 71, N'Varchar08', N'SD - Tham số 18', N'Varchar08', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BP')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 72, N'Varchar09', N'SD - Tham số 19', N'Varchar09', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BQ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'SalesOrder', N'Đơn hàng bán', N'Sales Order', N'OF0031', N'Import_Excel_DonHangBan.xls', N'EXEC AP8139 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 73, N'Varchar10', N'SD - Tham số 20', N'Varchar10', 
	N'', 80, 50, 0, N'NVARCHAR(100)', N'', 0, N'BR')
-------<<<<< Import Đơn hàng bán
---- Import Hồ sơ nhân viên - tuyển dụng
---- Import Hồ sơ nhân viên - tuyển dụng
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',1,N'DivisionID',N'Đơn vị',N'Division',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValidDivision}',1,N'C3',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',2,N'EmployeeID',N'Mã số nhân viên',N'EmployeeID',N'',80,50,0,N'NVARCHAR(50)',N'',1,N'A',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',3,N'S1',N'PL1',N'S1',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1104'', @Param2 = ''S'', @SQLFilter = ''TL.Disabled =  0 AND TL.STypeID = ''''E01''''''',0,N'B',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',4,N'S2',N'PL2',N'S2',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1104'', @Param2 = ''S'', @SQLFilter = ''TL.Disabled =  0 AND TL.STypeID = ''''E02''''''',0,N'C',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',5,N'S3',N'PL3',N'S3',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1104'', @Param2 = ''S'', @SQLFilter = ''TL.Disabled =  0 AND TL.STypeID = ''''E03''''''',0,N'D',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',6,N'LastName',N'Họ',N'LastName',N'',80,50,0,N'NVARCHAR(50)',N'',1,N'E',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',7,N'MiddleName',N'Tên đệm',N'MiddleName',N'',80,50,0,N'NVARCHAR(50)',N'',1,N'F',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',8,N'FirstName',N'Tên',N'FirstName',N'',80,50,0,N'NVARCHAR(50)',N'',1,N'G',1)

-- Dòng Thay đổi (Thinh 23/07/2015)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',9,N'EmployeeStatus',N'Tình trạng',N'EmployeeStatus',N'',80,10,1,N'TINYINT',N'',1,N'H',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',10,N'DepartmentID',N'Phòng ban',N'DepartmentID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''AT1102'', @Param2 = ''DepartmentID'', @SQLFilter = ''TL.Disabled =  0''',1,N'I',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',11,N'PayableAccountID',N'TK phải trả cho nhân viên',N'PayableAccountID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''AT1005'', @Param2 = ''AccountID'', @SQLFilter = ''TL.Disabled =  0 AND TL.GroupID=''''G04'''' and TL.IsNotShow = 0''',0,N'J',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',12,N'ExpenseAccountID',N'TK chi phí lương',N'ExpenseAccountID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''AT1005'', @Param2 = ''AccountID'', @SQLFilter = ''TL.Disabled =  0 AND TL.GroupID=''''G06'''' and TL.IsNotShow = 0''',0,N'K',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',13,N'PerInTaxID',N'TK Thuế TNCN',N'PerInTaxID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''AT1005'', @Param2 = ''AccountID'', @SQLFilter = ''TL.Disabled =  0 AND TL.GroupID=''''G04'''' and TL.IsNotShow = 0''',0,N'L',1)

INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',14,N'ShortName',N'Tên tắt',N'ShortName',N'',80,50,0,N'NVARCHAR(50)',N'',0,N'M',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',15,N'Alias',N'Bí Danh',N'Alias',N'',80,50,0,N'NVARCHAR(50)',N'',0,N'N',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',16,N'Birthday',N'Ngày sinh',N'Birthday',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'O',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',17,N'BornPlace',N'Nơi sinh',N'BornPlace',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'P',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',18,N'NativeCountry',N'Nguyên quán',N'NativeCountry',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'Q',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',19,N'CountryID',N'Quốc tịch',N'CountryID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''AT1001'', @Param2 = ''CountryID'', @SQLFilter = ''TL.Disabled =  0''',1,N'R',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',20,N'ReligionID',N'Dân tộc',N'ReligionID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1002'', @Param2 = ''ReligionID'', @SQLFilter = ''TL.Disabled =  0''',0,N'S',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',21,N'EthnicID',N'Tôn giáo',N'EthnicID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1001'', @Param2 = ''EthnicID'', @SQLFilter = ''TL.Disabled =  0''',0,N'T',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',22,N'IsMale',N'Giới tính',N'IsMale',N'',80,10,1,N'TINYINT',N'',0,N'U',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',23,N'IsSingle',N'Tình trạng gia đình',N'IsSingle',N'',80,10,1,N'TINYINT',N'',0,N'V',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',24,N'HealthStatus',N'Tĩnh trạng sức khoẻ',N'HealthStatus',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'W',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',25,N'PermanentAddress',N'Địa chỉ thường trú',N'PermanentAddress',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'X',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',26,N'TemporaryAddress',N'Địa chỉ tạm trú',N'TemporaryAddress',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'Y',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',27,N'HomePhone',N'Số điện thoại',N'HomePhone',N'',110,110,0,N'NVARCHAR(100)',N'',0,N'Z',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',28,N'HomeFax',N'Fax',N'HomeFax',N'',110,110,0,N'NVARCHAR(100)',N'',0,N'AA',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',29,N'MobiPhone',N'Điện thoại di động',N'MobiPhone',N'',110,110,0,N'NVARCHAR(100)',N'',0,N'AB',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',30,N'Email',N'Email',N'Email',N'',110,110,0,N'NVARCHAR(100)',N'',0,N'AC',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',31,N'IdentifyCardNo',N'Số CMND',N'IdentifyCardNo',N'',80,50,0,N'NVARCHAR(50)',N'',0,N'AD',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',32,N'IdentifyDate',N'Ngày cấp CMND',N'IdentifyDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'AE',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',33,N'IdentifyPlace',N'Nơi cấp CMND',N'IdentifyPlace',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'AF',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',34,N'IdentifyCityID',N'Tỉnh/TP cấp CMND',N'IdentifyCityID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''AT1002'', @Param2 = ''CityID'', @SQLFilter = ''TL.Disabled =  0''',0,N'AG',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',57,N'PassportNo',N'Số hộ chiếu',N'PassportNo',N'',80,50,0,N'NVARCHAR(50)',N'',0,N'AH',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',59,N'PassportDate',N'Ngày cấp Hộ chiếu',N'PassportDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'AI',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',60,N'PassportEnd',N'Ngày hết hạn',N'PassportEnd',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'AJ',1)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',61,N'Notes',N'Ghi chú',N'Notes',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'AK',1)

INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',35,N'RecruitPlace',N'Nơi tuyển dụng',N'RecruitPlace',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'B',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',36,N'RecruitDate',N'Ngày tuyển dụng',N'RecruitDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'C',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',37,N'Experience',N'Kinh nghiệm',N'Experience',N'',110,110,0,N'NVARCHAR(100)',N'',0,N'D',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',38,N'CompanyDate',N'Ngày vào công ty',N'CompanyDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'E',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',39,N'WorkDate',N'Ngày vào làm',N'WorkDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'F',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',40,N'MidEmployeeID',N'Người giới thiệu',N'MidEmployeeID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1400'', @Param2 = ''EmployeeID'', @SQLFilter = ''TL.EmployeeStatus <> 9''',0,N'G',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',41,N'DutyID',N'Chức vụ',N'DutyID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1102'', @Param2 = ''DutyID'', @SQLFilter = ''TL.Disabled =  0''',0,N'H',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',42,N'TitleID',N'Chức danh',N'TitleID',N'',80,10,0,N'VARCHAR(50)',N'',0,N'I',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',43,N'TaxObjectID',N'Đối tượng thuế',N'TaxObjectID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1011'', @Param2 = ''TaxObjectID'', @SQLFilter = ''TL.Disabled =  0''',0,N'J',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',44,N'LoaCondID',N'Đối tượng nghỉ phép',N'LoaCondID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT2806'', @Param2 = ''LoaCondID'', @SQLFilter = ''TL.Disabled =  0''',0,N'K',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',45,N'SalaryLevel',N'Bậc lương',N'SalaryLevel',N'',80,50,0,N'VARCHAR(50)',N'',0,N'L',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',46,N'SalaryLevelDate',N'Ngày nâng bậc lương',N'SalaryLevelDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'M',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',47,N'TimeCoefficient',N'Hệ số thâm niên',N'TimeCoefficient',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'N',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',48,N'DutyCoefficient',N'Hệ số chức vụ',N'DutyCoefficient',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'O',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',49,N'SalaryCoefficient',N'Hệ số lương',N'SalaryCoefficient',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'P',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',50,N'Notes',N'Ghi chú',N'Notes',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'P',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',51,N'SuggestSalary',N'Lương đề nghị',N'SuggestSalary',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'R',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',52,N'BaseSalary',N'Lương cơ bản',N'BaseSalary',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'S',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',53,N'InsuranceSalary',N'Lương BHXH',N'InsuranceSalary',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'T',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',54,N'Salary01',N'Lương 1',N'Salary01',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'U',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',55,N'Salary02',N'Lương 2',N'Salary02',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'V',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',56,N'Salary03',N'Lương 3',N'Salary03',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'W',2)

INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',58,N'TeamID',N'Tổ nhóm',N'TeamID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1101'', @Param2 = ''TeamID'', @SQLFilter = ''TL.Disabled =  0''',0,N'X',2)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',62,N'EducationLevelID',N'Trình độ học vấn',N'EducationLevelID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1005'', @Param2 = ''EducationLevelID'', @SQLFilter = ''TL.Disabled =  0''',0,N'B',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',63,N'PoliticsID',N'Trình độ chính trị',N'PoliticsID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1010'', @Param2 = ''PoliticsID'', @SQLFilter = ''TL.Disabled =  0''',0,N'C',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',64,N'Language1ID',N'Ngoại ngữ 1',N'Language1ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1006'', @Param2 = ''LanguageID'', @SQLFilter = ''TL.Disabled =  0''',0,N'D',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',65,N'LanguageLevel1ID',N'Cấp độ ngoại ngữ 1',N'LanguageLevel1ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1007'', @Param2 = ''LanguageLevelID'', @SQLFilter = ''TL.Disabled =  0''',0,N'E',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',66,N'Language2ID',N'Ngoại ngữ 2',N'Language2ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1006'', @Param2 = ''LanguageID'', @SQLFilter = ''TL.Disabled =  0''',0,N'F',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',67,N'LanguageLevel2ID',N'Cấp độ ngoại ngữ 2',N'LanguageLevel2ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1007'', @Param2 = ''LanguageLevelID'', @SQLFilter = ''TL.Disabled =  0''',0,N'G',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',68,N'Language3ID',N'Ngoại ngữ 3',N'Language3ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1006'', @Param2 = ''LanguageID'', @SQLFilter = ''TL.Disabled =  0''',0,N'H',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',69,N'LanguageLevel3ID',N'Cấp độ ngoại ngữ 3',N'LanguageLevel3ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1007'', @Param2 = ''LanguageLevelID'', @SQLFilter = ''TL.Disabled =  0''',0,N'I',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',70,N'SchoolID',N'Mã trường',N'SchoolID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1003'', @Param2 = ''SchoolID'', @SQLFilter = ''TL.Disabled =  0''',0,N'J',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',71,N'MajorID',N'Ngành học',N'MajorID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1004'', @Param2 = ''MajorID'', @SQLFilter = ''TL.Disabled =  0''',0,N'K',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',72,N'TypeID',N'Loại hình đào tạo',N'TypeID',N'',80,10,1,N'TINYINT',N'',0,N'L',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',73,N'FromMonth',N'Từ tháng',N'FromMonth',N'',80,30,1,N'INT',N'',0,N'M',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',74,N'FromYear',N'Từ năm',N'FromYear',N'',80,30,1,N'INT',N'',0,N'N',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',75,N'ToMonth',N'Đến tháng',N'ToMonth',N'',80,30,1,N'INT',N'',0,N'O',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',76,N'ToYear',N'Đến năm',N'ToYear',N'',80,30,1,N'INT',N'',0,N'P',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',77,N'Description',N'Diễn giải',N'Description',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'Q',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',78,N'Notes',N'Ghi chú',N'Notes',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'R',3)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',79,N'SoInsuranceNo',N'Số sổ BHXH',N'SoInsuranceNo',N'',80,50,0,N'NVARCHAR(50)',N'',0,N'B',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',80,N'SoInsurBeginDate',N'Ngày đóng BHXH',N'SoInsurBeginDate',N'',80,10,2,N'DATETIME',N'',0,N'C',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',81,N'HeInsuranceNo',N'Số thẻ BHYT',N'HeInsuranceNo',N'',80,50,0,N'NVARCHAR(50)',N'',0,N'D',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',82,N'HFromDate',N'Từ ngày',N'HFromDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'E',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',83,N'HToDate',N'Đến ngày',N'HToDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'F',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',84,N'HospitalID',N'Bệnh viện đăng ký KCB',N'HospitalID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1009'', @Param2 = ''HospitalID'', @SQLFilter = ''TL.Disabled =  0''',0,N'G',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',85,N'Height',N'Chiều cao (m)',N'Height',N'',110,110,0,N'NVARCHAR(100)',N'',0,N'H',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',86,N'Weight',N'Trọng lượng (kg)',N'Weight',N'',110,110,0,N'NVARCHAR(100)',N'',0,N'I',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',87,N'BloodGroup',N'Nhóm máu',N'BloodGroup',N'',110,110,0,N'NVARCHAR(100)',N'',0,N'J',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',88,N'Hobby',N'Ghi chú',N'Hobby',N'',110,110,0,N'NVARCHAR(100)',N'',0,N'K',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',89,N'BankID',N'Mã ngân hàng',N'BankID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1008'', @Param2 = ''BankID'', @SQLFilter = ''TL.Disabled =  0''',0,N'L',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',90,N'BankAccountNo',N'Số tài khoản',N'BankAccountNo',N'',80,50,0,N'NVARCHAR(50)',N'',0,N'M',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',91,N'PersonalTaxID',N'Mã số thuế TNCN',N'PersonalTaxID',N'',80,50,0,N'NVARCHAR(50)',N'',0,N'N',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',92,N'ArmyEndDate',N'Ngày nhập ngũ',N'ArmyEndDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'O',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',93,N'ArmyJoinDate',N'Ngày xuất ngủ',N'ArmyJoinDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'P',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',94,N'ArmyLevel',N'Quân hàm',N'ArmyLevel',N'',110,110,0,N'NVARCHAR(100)',N'',0,N'Q',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',95,N'AssociationID',N'Mã đoàn thể',N'AssociationID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1103'', @Param2 = ''AssociationID'', @SQLFilter = ''TL.Disabled =  0''',0,N'R',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',96,N'StartDate',N'Ngày tham gia',N'StartDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'S',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',97,N'EndDate',N'Ngày kết thúc',N'EndDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'T',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',98,N'JoinPlace',N'Nơi tham gia',N'JoinPlace',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'U',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',99,N'AssociationNo',N'Số thẻ',N'AssociationNo',N'',80,50,0,N'NVARCHAR(50)',N'',0,N'V',4)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',100,N'FatherName',N'Họ và tên cha',N'FatherName',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'B',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',101,N'FatherYear',N'Năm sinh',N'FatherYear',N'',80,30,1,N'INT',N'',0,N'C',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',102,N'FatherJob',N'Nghề nghiệp',N'FatherJob',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'D',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',103,N'FatherAddress',N'Địa chỉ',N'FatherAddress',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'E',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',104,N'FatherNote',N'Ghi chú',N'FatherNote',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'F',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',105,N'IsFatherDeath',N'Mất',N'IsFatherDeath',N'',80,10,1,N'TINYINT',N'',0,N'G',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',106,N'MotherName',N'Họ và tên mẹ',N'MotherName',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'H',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',107,N'MotherYear',N'Năm sinh',N'MotherYear',N'',80,30,1,N'INT',N'',0,N'I',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',108,N'MotherJob',N'Nghề nghiệp',N'MotherJob',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'J',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',109,N'MotherAddress',N'Địa chỉ',N'MotherAddress',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'K',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',110,N'MotherNote',N'Ghi chú',N'MotherNote',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'L',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',111,N'IsMotherDeath',N'Mất',N'IsMotherDeath',N'',80,10,1,N'TINYINT',N'',0,N'M',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',112,N'SpouseName',N'Họ và tên vợ/chồng',N'SpouseName',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'N',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',113,N'SpouseYear',N'Năm sinh',N'SpouseYear',N'',80,30,1,N'INT',N'',0,N'O',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',114,N'SpouseJob',N'Nghề nghiệp',N'SpouseJob',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'P',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',115,N'SpouseAddress',N'Địa chỉ',N'SpouseAddress',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'Q',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',116,N'SpouseNote',N'Ghi chú',N'SpouseNote',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'R',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',117,N'IsSpouseDeath',N'Mất',N'IsSpouseDeath',N'',80,10,1,N'TINYINT',N'',0,N'S',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',118,N'RelationType',N'Loại quan hệ',N'RelationType',N'',80,10,1,N'TINYINT',N'',0,N'T',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',119,N'RelationName',N'Tên người liên hệ',N'RelationName',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'U',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',120,N'RelationDate',N'Ngày sinh',N'RelationDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'V',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',121,N'RelationAddress',N'Địa chỉ',N'RelationAddress',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'W',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',122,N'RelationPhone',N'Số điện thoại',N'RelationPhone',N'',110,110,0,N'NVARCHAR(100)',N'',0,N'X',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',123,N'Notes',N'Ghi chú',N'Notes',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'Y',5)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',124,N'C01',N'Hệ số C01',N'C01',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'B',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',125,N'C02',N'Hệ số C02',N'C02',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'C',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',126,N'C03',N'Hệ số C03',N'C03',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'D',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',127,N'C04',N'Hệ số C04',N'C04',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'E',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',128,N'C05',N'Hệ số C05',N'C05',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'F',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',129,N'C06',N'Hệ số C06',N'C06',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'G',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',130,N'C07',N'Hệ số C07',N'C07',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'H',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',131,N'C08',N'Hệ số C08',N'C08',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'I',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',132,N'C09',N'Hệ số C09',N'C09',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'J',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',133,N'C10',N'Hệ số C10',N'C10',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'K',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',134,N'C11',N'Hệ số C11',N'C11',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'L',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',135,N'C12',N'Hệ số C12',N'C12',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'M',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',136,N'C13',N'Hệ số C13',N'C13',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'N',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',137,N'C14',N'Hệ số C14',N'C14',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'O',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',138,N'C15',N'Hệ số C15',N'C15',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'P',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',139,N'C16',N'Hệ số C16',N'C16',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'Q',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',140,N'C17',N'Hệ số C17',N'C17',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'R',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',141,N'C18',N'Hệ số C18',N'C18',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'S',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',142,N'C19',N'Hệ số C19',N'C19',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'T',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',143,N'C20',N'Hệ số C20',N'C20',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'U',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',144,N'C21',N'Hệ số C21',N'C21',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'V',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',145,N'C22',N'Hệ số C22',N'C22',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'W',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',146,N'C23',N'Hệ số C23',N'C23',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'X',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',147,N'C24',N'Hệ số C24',N'C24',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'Y',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',148,N'C25',N'Hệ số C25',N'C25',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'Z',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',149,N'Target01ID',N'Chỉ tiêu 01',N'Target01ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1014'', @Param2 = ''TargetID'', @SQLFilter = ''TL.Disabled =  0 AND TL.TargetTypeID =''''T01''''''',0,N'AA',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',150,N'TargetAmount01',N'Chỉ số 01',N'TargetAmount01',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'AB',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',151,N'Target02ID',N'Chỉ tiêu 02',N'Target02ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1014'', @Param2 = ''TargetID'', @SQLFilter = ''TL.Disabled =  0 AND TL.TargetTypeID =''''T02''''''',0,N'AC',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',152,N'TargetAmount02',N'Chỉ số 02',N'TargetAmount02',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'AD',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',153,N'Target03ID',N'Chỉ tiêu 03',N'Target03ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1014'', @Param2 = ''TargetID'', @SQLFilter = ''TL.Disabled =  0 AND TL.TargetTypeID =''''T03''''''',0,N'AE',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',154,N'TargetAmount03',N'Chỉ số 03',N'TargetAmount03',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'AF',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',155,N'Target04ID',N'Chỉ tiêu 04',N'Target04ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1014'', @Param2 = ''TargetID'', @SQLFilter = ''TL.Disabled =  0 AND TL.TargetTypeID =''''T04''''''',0,N'AG',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',156,N'TargetAmount04',N'Chỉ số 04',N'TargetAmount04',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'AH',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',157,N'Target05ID',N'Chỉ tiêu 05',N'Target05ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1014'', @Param2 = ''TargetID'', @SQLFilter = ''TL.Disabled =  0 AND TL.TargetTypeID =''''T05''''''',0,N'AI',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',158,N'TargetAmount05',N'Chỉ số 05',N'TargetAmount05',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'AJ',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',159,N'Target06ID',N'Chỉ tiêu 06',N'Target06ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1014'', @Param2 = ''TargetID'', @SQLFilter = ''TL.Disabled =  0 AND TL.TargetTypeID =''''T06''''''',0,N'AK',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',160,N'TargetAmount06',N'Chỉ số 06',N'TargetAmount06',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'AL',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',161,N'Target07ID',N'Chỉ tiêu 07',N'Target07ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1014'', @Param2 = ''TargetID'', @SQLFilter = ''TL.Disabled =  0 AND TL.TargetTypeID =''''T07''''''',0,N'AM',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',162,N'TargetAmount07',N'Chỉ số 07',N'TargetAmount07',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'AN',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',163,N'Target08ID',N'Chỉ tiêu 08',N'Target08ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1014'', @Param2 = ''TargetID'', @SQLFilter = ''TL.Disabled =  0 AND TL.TargetTypeID =''''T08''''''',0,N'AO',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',164,N'TargetAmount08',N'Chỉ số 08',N'TargetAmount08',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'AP',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',165,N'Target09ID',N'Chỉ tiêu 09',N'Target09ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1014'', @Param2 = ''TargetID'', @SQLFilter = ''TL.Disabled =  0 AND TL.TargetTypeID =''''T09''''''',0,N'AQ',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',166,N'TargetAmount09',N'Chỉ số 09',N'TargetAmount09',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'AR',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',167,N'Target10ID',N'Chỉ tiêu 10',N'Target10ID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1014'', @Param2 = ''TargetID'', @SQLFilter = ''TL.Disabled =  0 AND TL.TargetTypeID =''''T10''''''',0,N'AS',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',168,N'TargetAmount10',N'Chỉ số 10',N'TargetAmount10',N'',80,50,1,N'DECIMAL(28,8)',N'',0,N'AT',6)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',169,N'FromDate',N'Từ ngày',N'FromDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'B',7)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',170,N'ToDate',N'Đến ngày',N'ToDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'C',7)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',171,N'ResidentAddress',N'Địa chỉ lưu trú',N'ResidentAddress',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'D',7)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',172,N'Notes',N'Ghi chú',N'Notes',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'E',7)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',173,N'D01',N'Ngày 01',N'D01',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'B',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',174,N'D02',N'Ngày 02',N'D02',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'C',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',175,N'D03',N'Ngày 03',N'D03',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'D',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',176,N'D04',N'Ngày 04',N'D04',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'E',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',177,N'D05',N'Ngày 05',N'D05',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'',0,N'F',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',178,N'N01',N'Ghi chú 1',N'N01',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'G',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',179,N'N02',N'Ghi chú 2',N'N02',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'H',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',180,N'N03',N'Ghi chú 3',N'N03',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'I',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',181,N'N04',N'Ghi chú 4',N'N04',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'J',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',182,N'N05',N'Ghi chú 5',N'N05',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'K',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',183,N'N06',N'Ghi chú 6',N'N06',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'L',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',184,N'N07',N'Ghi chú 7',N'N07',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'M',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',185,N'N08',N'Ghi chú 8',N'N08',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'N',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',186,N'N09',N'Ghi chú 9',N'N09',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'O',8)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'EmployeeFileID',N'Hồ sơ nhân viên',N'Employee File',N'HF0081',N'Import_Excel_HoSoNhanVien.xls',N'EXEC AP8140 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML,@SType = @SType',187,N'N10',N'Ghi chú 10',N'N10',N'',110,250,0,N'NVARCHAR(250)',N'',0,N'P',8)---- Import Hồ sơ nhân viên - tuyển dụng

---- Import Hồ sơ nhân viên - tuyển dụng


--- INSERT Chấm công Chi Dinh
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAssign',N'Chấm Công Theo Sản Phẩm Chỉ Định',N'Produce Assign',N'HF0088',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8141 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',1,N'DivisionID',N'Đơn vị',N'Division',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValidDivision}',1,N'B3',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAssign',N'Chấm Công Theo Sản Phẩm Chỉ Định',N'Produce Assign',N'HF0088',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8141 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',2,N'Period',N'Kỳ kế toán',N'Period',N'',80,7,0,N'NVARCHAR(50)',N'{CheckValidPeriod} @Module = ''ASOFT-OP''',1,N'B4',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAssign',N'Chấm Công Theo Sản Phẩm Chỉ Định',N'Produce Assign',N'HF0088',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8141 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',3,N'TimesID',N'Lần Chấm Công',N'TimesID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1019'', @Param2 = ''TimesID'', @SQLFilter = ''TL.Disabled =  0''',1,N'A',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAssign',N'Chấm Công Theo Sản Phẩm Chỉ Định',N'Produce Assign',N'HF0088',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8141 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',4,N'EmployeeID',N'Nhân Viên ',N'EmployeeID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1400'', @Param2 = ''EmployeeID'', @SQLFilter = ''TL.EmployeeStatus <> 9''',1,N'B',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAssign',N'Chấm Công Theo Sản Phẩm Chỉ Định',N'Produce Assign',N'HF0088',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8141 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',5,N'DepartmentID',N'Phòng Ban',N'DepartmentID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1400'', @Param2 = ''EmployeeID'', @SQLFilter = ''TL.EmployeeStatus <> 9''',1,N'C',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAssign',N'Chấm Công Theo Sản Phẩm Chỉ Định',N'Produce Assign',N'HF0088',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8141 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',6,N'TeamID',N'Tổ',N'TeamID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''AT1102'', @Param2 = ''DepartmentID'', @SQLFilter = ''TL.Disabled =  0''',0,N'D',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAssign',N'Chấm Công Theo Sản Phẩm Chỉ Định',N'Produce Assign',N'HF0088',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8141 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',7,N'ProductID',N'Sản Phẩm',N'ProductID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1101'', @Param2 = ''TeamID'', @SQLFilter = ''TL.Disabled =  0''',1,N'E',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAssign',N'Chấm Công Theo Sản Phẩm Chỉ Định',N'Produce Assign',N'HF0088',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8141 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',8,N'Quantity',N'Số Lượng',N'Quantity',N'',80,30,1,N'DECIMAL(28,8)',N'',1,N'F',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAssign',N'Chấm Công Theo Sản Phẩm Chỉ Định',N'Produce Assign',N'HF0088',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8141 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',9,N'TrackingDate',N'Ngày Làm Việc',N'TrackingDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'{CheckValidVoucherDate}',1,N'G',0)
--- INSERT Chấm công phân bổ
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAllocate',N'Chấm Công Theo Sản Phẩm Phân Bổ',N'Produce Allocate',N'HF0099',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8142 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',1,N'DivisionID',N'Đơn vị',N'Division',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValidDivision}',1,N'B3',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAllocate',N'Chấm Công Theo Sản Phẩm Phân Bổ',N'Produce Allocate',N'HF0099',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8142 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',2,N'Period',N'Kỳ kế toán',N'Period',N'',80,7,0,N'NVARCHAR(50)',N'{CheckValidPeriod} @Module = ''ASOFT-OP''',1,N'B4',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAllocate',N'Chấm Công Theo Sản Phẩm Phân Bổ',N'Produce Allocate',N'HF0099',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8142 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',3,N'TimesID',N'Lần Chấm Công',N'TimesID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1019'', @Param2 = ''TimesID'', @SQLFilter = ''TL.Disabled =  0''',1,N'A',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAllocate',N'Chấm Công Theo Sản Phẩm Phân Bổ',N'Produce Allocate',N'HF0099',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8142 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',4,N'DepartmentID',N'Phòng Ban',N'DepartmentID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''AT1102'', @Param2 = ''DepartmentID'', @SQLFilter = ''TL.Disabled =  0''',1,N'B',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAllocate',N'Chấm Công Theo Sản Phẩm Phân Bổ',N'Produce Allocate',N'HF0099',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8142 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',5,N'TeamID',N'Tổ',N'TeamID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1101'', @Param2 = ''TeamID'', @SQLFilter = ''TL.Disabled =  0''',1,N'C',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAllocate',N'Chấm Công Theo Sản Phẩm Phân Bổ',N'Produce Allocate',N'HF0099',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8142 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',6,N'ProductID',N'Sản Phẩm',N'ProductID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1015'', @Param2 = ''ProductID'', @SQLFilter = ''TL.Disabled =  0''',1,N'D',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAllocate',N'Chấm Công Theo Sản Phẩm Phân Bổ',N'Produce Allocate',N'HF0099',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8142 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',7,N'Quantity',N'Số Lượng',N'Quantity',N'',80,30,1,N'DECIMAL(28,8)',N'',1,N'E',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'ProduceAllocate',N'Chấm Công Theo Sản Phẩm Phân Bổ',N'Produce Allocate',N'HF0099',N'Import_Excel_SanPhamChiDinh.xls',N'EXEC AP8142 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',8,N'TrackingDate',N'Ngày Làm Việc',N'TrackingDate',N'dd/mm/yyyy',80,10,2,N'DATETIME',N'{CheckValidVoucherDate}',1,N'F',0)

--- INSERT CHAM CÔNG  NGÀY
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingDate',N'Chấm Công theo Ngày',N'TimeKeeping Date',N'HF0218',N'Import_Excel_ChamCongNgay.xls',N'EXEC AP8143 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',1,N'DivisionID',N'Đơn vị',N'Division',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValidDivision}',1,N'B3',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingDate',N'Chấm Công theo Ngày',N'TimeKeeping Date',N'HF0218',N'Import_Excel_ChamCongNgay.xls',N'EXEC AP8143 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',2,N'Period',N'Kỳ kế toán',N'Period',N'',80,7,0,N'NVARCHAR(50)',N'{CheckValidPeriod} @Module = ''ASOFT-HRM''',1,N'B4',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingDate',N'Chấm Công theo Ngày',N'TimeKeeping Date',N'HF0218',N'Import_Excel_ChamCongNgay.xls',N'EXEC AP8143 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',3,N'EmployeeID',N'Nhân Viên',N'EmployeeID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1400'', @Param2 = ''EmployeeID'', @SQLFilter = ''''',1,N'A',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingDate',N'Chấm Công theo Ngày',N'TimeKeeping Date',N'HF0218',N'Import_Excel_ChamCongNgay.xls',N'EXEC AP8143 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',4,N'FromAbsentDate',N'Ngày Bắt Đầu Chấm Công',N'FromAbsentDate',N'dd/mm/yyyy',80,50,2,N'DATETIME',N'{CheckValidVoucherDate}',1,N'B',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingDate',N'Chấm Công theo Ngày',N'TimeKeeping Date',N'HF0218',N'Import_Excel_ChamCongNgay.xls',N'EXEC AP8143 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',5,N'ToAbsentDate',N'Ngày Kết Thúc Chấm Công',N'ToAbsentDate',N'dd/mm/yyyy',80,50,2,N'DATETIME',N'{CheckValidVoucherDate}',1,N'C',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingDate',N'Chấm Công theo Ngày',N'TimeKeeping Date',N'HF0218',N'Import_Excel_ChamCongNgay.xls',N'EXEC AP8143 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',6,N'AbsentTypeID',N'Loại Công',N'AbsentTypeID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1013'', @Param2 = ''AbsentTypeID'', @SQLFilter = ''TL.Disabled =  0 AND ISMONTH = 0''',1,N'D',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingDate',N'Chấm Công theo Ngày',N'TimeKeeping Date',N'HF0218',N'Import_Excel_ChamCongNgay.xls',N'EXEC AP8143 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',7,N'AbsentAmount',N'Hệ Số Công',N'AbsentAmount',N'',80,30,1,N'DECIMAL(28,8)',N'',1,N'E',0)
--- INSERT CHAM CONG THÁNG
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingMonth',N'Chấm Công theo Tháng',N'TimeKeeping Month',N'HF0234',N'Import_Excel_ChamCongThang.xls',N'EXEC AP8144 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',1,N'DivisionID',N'Đơn vị',N'Division',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValidDivision}',1,N'B3',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingMonth',N'Chấm Công theo Tháng',N'TimeKeeping Month',N'HF0234',N'Import_Excel_ChamCongThang.xls',N'EXEC AP8144 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',2,N'Period',N'Kỳ kế toán',N'Period',N'',80,7,0,N'NVARCHAR(50)',N'{CheckValidPeriod} @Module = ''ASOFT-HRM''',1,N'B4',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingMonth',N'Chấm Công theo Tháng',N'TimeKeeping Month',N'HF0234',N'Import_Excel_ChamCongThang.xls',N'EXEC AP8144 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',3,N'PeriodID',N'Kỳ Lương',N'PeriodID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT6666'', @Param2 = ''PeriodID'', @SQLFilter = ''''',1,N'B5',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingMonth',N'Chấm Công theo Tháng',N'TimeKeeping Month',N'HF0234',N'Import_Excel_ChamCongThang.xls',N'EXEC AP8144 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',4,N'EmployeeID',N'Nhân Viên',N'EmployeeID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1400'', @Param2 = ''EmployeeID'', @SQLFilter = ''''',1,N'A',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingMonth',N'Chấm Công theo Tháng',N'TimeKeeping Month',N'HF0234',N'Import_Excel_ChamCongThang.xls',N'EXEC AP8144 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',5,N'AbsentTypeID',N'Loại Công',N'AbsentTypeID',N'',80,50,0,N'NVARCHAR(50)',N'{CheckValueInTableList} @Param1 = ''HT1013'', @Param2 = ''AbsentTypeID'', @SQLFilter = ''TL.Disabled =  0 AND ISMONTH = 1''',1,N'B',0)
INSERT INTO A00065(ImportTransTypeID,ImportTransTypeName,ImportTransTypeNameEng,ScreenID,TemplateFileName,ExecSQL,OrderNum,ColID,ColName,ColNameEng,InputMask,ColWidth,ColLength,ColType,ColSQLDataType,CheckExpression,IsObligated,DataCol,SType) VALUES( N'TimeKeepingMonth',N'Chấm Công theo Tháng',N'TimeKeeping Month',N'HF0234',N'Import_Excel_ChamCongThang.xls',N'EXEC AP8144 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID,
  @XML = @XML',6,N'AbsentAmount',N'Hệ Số Công',N'AbsentAmount',N'',80,30,1,N'DECIMAL(28,8)',N'',1,N'C',0)


--- Modify by Phuong Thao on 18/11/2015: IMPORT PHIEU XUAT VAN CHUYEN NOI BO
DELETE FROM A00065 WHERE ImportTransTypeID = N'TransferWareHouse'

INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 1, N'DivisionID', N'Đơn vị', N'Division', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidDivision}', 1, N'B3')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 2, N'Period', N'Kỳ kế toán', N'Period', 
	N'', 80, 7, 0, N'VARCHAR(10)', N'{CheckValidPeriod} @Module = ''ASOFT-WM''', 1, N'B4')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 3, N'VoucherTypeID', N'Loại chứng từ', N'Voucher Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValidVoucherType} @ObligeCheck = 1, @SQLFilter = ''''', 1, N'B5')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 4, N'VoucherNo', N'Số chứng từ', N'Voucher No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'A')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 5, N'VoucherDate', N'Ngày chứng từ', N'Voucher Date', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 1, N'B')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 6, N'RefNo01', N'Mã tham chiếu 1', N'Ref No 01', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'C')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 7, N'RefNo02', N'Mã tham chiếu 2', N'Ref No 02', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'D')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 8, N'ObjectID', N'Đối tượng', N'Object', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'E')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 9, N'WareHouseID2', N'Kho xuất', N'Out Ware House', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'F')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 10, N'WareHouseID', N'Kho nhập', N'In Ware House', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'G')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 11, N'InventoryTypeID', N'Loại mặt hàng', N'Inventory Type', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 1, N'H')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 12, N'EmployeeID', N'Người lập phiếu', N'Employee', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'I')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 13, N'Description', N'Diễn giải', N'Description', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'J')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 14, N'BarCode', N'Mã vạch', N'BarCode', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''BarCode'',  @SQLFilter = ''TL.Disabled =  0 AND DT.InventoryID = TL.InventoryID''', 0, N'K')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 15, N'InventoryID', N'Mã hàng', N'Inventory', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1302'', @Param2 = ''InventoryID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'L')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 16, N'UnitID', N'Đơn vị tính', N'Unit', 
	N'', 80, 50, 0, N'NVARCHAR(250)', N'{CheckValueInTableList} @Param1 = ''AT1304'', @Param2 = ''UnitID'', @SQLFilter = ''TL.Disabled =  0''', 1, N'M')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 17, N'ReVoucherNo', N'Chứng từ nhập', N'ReVoucherNo', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'N')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 18, N'SourceNo', N'Lô nhập', N'Source No', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'O')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 19, N'LimitDate', N'Hạn sử dụng', N'LimitDate', 
	N'dd/mm/yyyy', 80, 10, 2, N'DATETIME', N'', 0, N'P')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 20, N'ConvertedQuantity', N'Số lượng xuất', N'Converted Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'Q')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 21, N'ConvertedPrice', N'Đơn giá', N'Converted Price', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 0, N'R')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 22, N'ActualQuantity', N'Số lượng xuất (ĐVT chuẩn)', N'Actual Quantity', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'S')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 23, N'UnitPrice', N'Đơn giá (ĐVT chuẩn)', N'Price', 
	N'', 80, 10, 1, N'DECIMAL(28,8)', N'', 1, N'T')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 24, N'OriginalAmount', N'Nguyên tệ', N'Original Amount', 
	N'', 50, 20, 1, N'DECIMAL(28,8)', N'', 1, N'U')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 25, N'DebitAccountID', N'TK Nợ', N'Debit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'V')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 26, N'CreditAccountID', N'TK Có', N'Credit Account', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAccount} @ObligeCheck = 1, @SQLFilter = ''A.GroupID <> ''''G00''''''', 1, N'W')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 27, N'Notes', N'Diễn giải', N'Notes', 
	N'', 110, 50, 0, N'NVARCHAR(250)', N'', 0, N'X')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 28, N'ActEndQty', N'Tồn cuối', N'End Quantity', 
	N'', 50, 50, 1, N'DECIMAL(28,8)', N'', 0, N'Y')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 29, N'Ana01ID', N'MPT 01', N'Analysist 01', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna01}', 0, N'Z')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 30, N'Ana02ID', N'MPT 02', N'Analysist 02', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna02}', 0, N'AA')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 31, N'Ana03ID', N'MPT 03', N'Analysist 03', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna03}', 0, N'AB')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 32, N'Ana04ID', N'MPT 04', N'Analysist 04', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna04}', 0, N'AC')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 33, N'Ana05ID', N'MPT 05', N'Analysist 05', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna05}', 0, N'AD')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 34, N'Ana06ID', N'MPT 06', N'Analysist 06', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna06}', 0, N'AE')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 35, N'Ana07ID', N'MPT 07', N'Analysist 07', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna07}', 0, N'AF')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 36, N'Ana08ID', N'MPT 08', N'Analysist 08', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna08}', 0, N'AG')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 37, N'Ana09ID', N'MPT 09', N'Analysist 09', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna09}', 0, N'AH')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 38, N'Ana10ID', N'MPT 10', N'Analysist 10', 
	N'', 50, 50, 0, N'NVARCHAR(50)', N'{CheckValidAna10}', 0, N'AI')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 39, N'PeriodID', N'Mã đối tượng THCP', N'Object collect Cost', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'{CheckValueInTableList} @Param1 = ''MT1601'', @Param2 = ''PeriodID'', @SQLFilter = ''TL.Disabled =  0 AND TL.FromYear*100+TL.FromMonth <= RIGHT(DT.Period, 4)*100 + LEFT(DT.Period, 2) AND RIGHT(DT.Period, 4)*100 + LEFT(DT.Period, 2) <= TL.ToYear*100+TL.ToMonth''', 0, N'AJ')
INSERT INTO A00065(ImportTransTypeID, ImportTransTypeName, ImportTransTypeNameEng, ScreenID, TemplateFileName, ExecSQL, OrderNum, ColID, ColName, ColNameEng, 
	InputMask, ColWidth, ColLength, ColType, ColSQLDataType, CheckExpression, IsObligated, DataCol)
VALUES (N'TransferWareHouse', N'Xuất vận chuyển nội bộ', N'Transfer WareHouse', N'WF0013', N'Import_Excel_PhieuXVCNB.xls', N'EXEC AP8145 @DivisionID = @DivisionID, @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @XML = @XML', 40, N'ProductID', N'Mã sản phẩm', N'Product', 
	N'', 80, 50, 0, N'NVARCHAR(50)', N'', 0, N'AK')


