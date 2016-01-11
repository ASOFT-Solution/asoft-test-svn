IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[SP2002]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[SP2002]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Đổ nguồn cho màn hình đề xuất sửa / xóa phiếu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 20/09/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 15/10/2012 by Lê Thị Thu Hiền : Bổ sung xử lý 
---- Modified on 10/08/2015 by Hoàng vũ : Bổ sung phân quyền xem dữ liệu của người khác
-- <Example>
---- EXEC SP2002 'AS', 1, 2012, 'ADMIN', 0, NULL, NULL, 1, '', '', 'T'
--EXEC SP2002 'AS', 1, 2012, 'ADMIN', 0, NULL, NULL, 1, '', '', 'OP'
--EXEC SP2002 'AS', 1, 2012, 'ADMIN', 0, NULL, NULL, 1, '', '', 'M'
--EXEC SP2002 'AS', 1, 2012, 'ADMIN', 0, NULL, NULL, 1, '', '', 'WM'
----

CREATE PROCEDURE SP2002
( 
	@DivisionID AS NVARCHAR(50),
	@TranMonth AS INT,
	@TranYear AS INT,
	@UserID AS NVARCHAR(50),
	@IsDate AS TINYINT,
	@FromDate AS DATETIME,
	@ToDate AS DATETIME,
	@IsApproved AS TINYINT,
	@VoucherNo AS NVARCHAR(50),
	@RequestVoucherNo AS NVARCHAR(50),
	@ModuleID AS NVARCHAR(50)

	
) 
AS 
DECLARE @sSQL AS NVARCHAR(4000),
		@sSQL1 AS NVARCHAR(4000),
		@sSQL2 AS NVARCHAR(4000),
		@sSQL3 AS NVARCHAR(4000),
		@sSQL4 AS NVARCHAR(4000),
		@sSQL5 AS NVARCHAR(4000),
		@sSQL6 AS NVARCHAR(4000),
		@sWHERE AS NVARCHAR(4000)
SET @sSQL = ''
SET @sSQL1 = ''
SET @sSQL2 = ''
SET @sSQL3 = ''
SET @sSQL4 = ''

	
	----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
		DECLARE @sSQLPer AS NVARCHAR(MAX),
				@sWHEREPer AS NVARCHAR(MAX)
		SET @sSQLPer = ''
		SET @sWHEREPer = ''		

		IF EXISTS (SELECT TOP 1 1 FROM MT0000 WHERE DivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
			BEGIN
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = ST2002.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = ST2002.CreateUserID '
				SET @sWHEREPer = ' AND (ST2002.CreateUserID = AT0010.UserID
										OR  ST2002.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		


------------->>> Điều kiện lọc 
SET @sWHERE = ''
IF @IsDate = 1
SET @sWHERE = N'
		AND		CONVERT(Nvarchar(10),ST2002.VoucherDate,103) BETWEEN '''+CONVERT(Nvarchar(10),@FromDate,103)+''' AND '''+CONVERT(Nvarchar(10),@ToDate,103)+'''
'
IF @IsApproved = 1
SET @sWHERE = @sWHERE + N'
		AND		ST2002.IsApproved = 1
'
IF @IsApproved = 2
SET @sWHERE = @sWHERE + N'
		AND		ST2002.IsApproved = 0
'
IF @VoucherNo <> '' AND @VoucherNo IS NOT NULL
SET @sWHERE = @sWHERE + N'
		AND		ST2002.VoucherNo LIKE ''%'+@VoucherNo+'%''
'
IF @RequestVoucherNo <> '' AND @RequestVoucherNo IS NOT NULL
SET @sWHERE = @sWHERE + N'
		AND		ST2002.RequestVoucherNo LIKE ''%'+@RequestVoucherNo+'%''
'
-------------<<<<<< Điều kiện lọc 


-------- Module T
IF @ModuleID = 'T'
BEGIN
SET @sSQL = N'

SELECT 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName AS EmployeeName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description] AS RequestTransactionTypeName,
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
MAX(AT9000.VoucherTypeID) AS RequestVoucherTypeID,
MAX(AT9000.TranMonth) AS RequestTranMonth,		
MAX(AT9000.TranYear) AS RequestTranYear,
MAX(AT9000.VoucherDate) AS RequestVoucherDate, 
MAX(AT9000.DebitAccountID) AS DebitAccountID, 
MAX(AT9000.CreditAccountID) AS CreditAccountID, 
MAX(AT9000.ConvertedAmount) AS ConvertedAmount, 
NULL AS BudgetType,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
FROM ST2002 ST2002
LEFT JOIN SV2002 SV2002 ON SV2002.TransactionTypeID = ST2002.RequestTransactionTypeID
LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = ST2002.DivisionID AND AT1103.EmployeeID = ST2002.EmployeeID
INNER JOIN AT9000 AT9000 ON AT9000.DivisionID = ST2002.DivisionID AND AT9000.VoucherID = ST2002.RequestVoucherID
' + @sSQLPer +'
WHERE	ST2002.DivisionID = '''+@DivisionID+'''
		AND ST2002.ModuleID LIKE '''+@ModuleID+'''
		'+@sWHERE+''+ @sWHEREPer+ '
GROUP BY 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description],
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
'
----------- Ngân sách
set @sSQL1 = '
UNION ALL

SELECT 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName AS EmployeeName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description] AS RequestTransactionTypeName,
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
MAX(AT9090.VoucherTypeID) AS RequestVoucherTypeID,
MAX(AT9090.TranMonth) AS RequestTranMonth,		
MAX(AT9090.TranYear) AS RequestTranYear,
MAX(AT9090.VoucherDate) AS RequestVoucherDate, 
MAX(AT9090.DebitAccountID) AS DebitAccountID, 
MAX(AT9090.CreditAccountID) AS CreditAccountID, 
MAX(AT9090.ConvertedAmount) AS ConvertedAmount,  
MAX(AT9090.BudgetType) AS BudgetType,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
FROM ST2002 ST2002
LEFT JOIN SV2002 SV2002 ON SV2002.TransactionTypeID = ST2002.RequestTransactionTypeID
LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = ST2002.DivisionID AND AT1103.EmployeeID = ST2002.EmployeeID
INNER JOIN AT9090 AT9090 ON AT9090.DivisionID = ST2002.DivisionID AND AT9090.VoucherID = ST2002.RequestVoucherID
' + @sSQLPer +'
WHERE	ST2002.DivisionID = '''+@DivisionID+'''
		AND ST2002.ModuleID LIKE '''+@ModuleID+'''
		'+@sWHERE+'	'+ @sWHEREPer+ '	

GROUP BY 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description],
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
'
--------------Tạm thu chi
SET @sSQL3 = N'
UNION ALL
SELECT 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName AS EmployeeName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description] AS RequestTransactionTypeName,
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
MAX(AT9010.VoucherTypeID) AS RequestVoucherTypeID,
MAX(AT9010.TranMonth) AS RequestTranMonth,		
MAX(AT9010.TranYear) AS RequestTranYear,
MAX(AT9010.VoucherDate) AS RequestVoucherDate, 
MAX(AT9010.DebitAccountID) AS DebitAccountID, 
MAX(AT9010.CreditAccountID) AS CreditAccountID, 
MAX(AT9010.ConvertedAmount) AS ConvertedAmount, 
NULL AS BudgetType,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
FROM ST2002 ST2002
LEFT JOIN SV2002 SV2002 ON SV2002.TransactionTypeID = ST2002.RequestTransactionTypeID
LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = ST2002.DivisionID AND AT1103.EmployeeID = ST2002.EmployeeID
INNER JOIN AT9010 AT9010 ON AT9010.DivisionID = ST2002.DivisionID AND AT9010.VoucherID = ST2002.RequestVoucherID
' + @sSQLPer +'
WHERE	ST2002.DivisionID = '''+@DivisionID+'''
		AND ST2002.ModuleID LIKE '''+@ModuleID+'''
		'+@sWHERE+''+ @sWHEREPer+ '
GROUP BY 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description],
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
'
END 
----------->>> Module OP
IF @ModuleID = 'OP'
BEGIN

----------- Đơn hàng mua
set @sSQL = '
SELECT 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName AS EmployeeName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description] AS RequestTransactionTypeName,
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
MAX(OT3001.VoucherTypeID) AS RequestVoucherTypeID,
MAX(OT3001.TranMonth) AS RequestTranMonth,		
MAX(OT3001.TranYear) AS RequestTranYear,
MAX(OT3001.OrderDate) AS RequestVoucherDate, 
NULL AS DebitAccountID, 
NULL AS CreditAccountID, 
0 AS ConvertedAmount,  
NULL AS BudgetType,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
FROM ST2002 ST2002
LEFT JOIN SV2002 SV2002 ON SV2002.TransactionTypeID = ST2002.RequestTransactionTypeID
LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = ST2002.DivisionID AND AT1103.EmployeeID = ST2002.EmployeeID
INNER JOIN OT3001 OT3001 ON OT3001.DivisionID = ST2002.DivisionID AND OT3001.POrderID = ST2002.RequestVoucherID
' + @sSQLPer +'
WHERE	ST2002.DivisionID = '''+@DivisionID+'''
		AND ST2002.ModuleID LIKE '''+@ModuleID+'''
		'+@sWHERE+'	'+ @sWHEREPer+ '

GROUP BY 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description],
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
'
----------- Chào giá
set @sSQL1 = '
UNION ALL

SELECT 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName AS EmployeeName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description] AS RequestTransactionTypeName,
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
MAX(OT2101.VoucherTypeID) AS RequestVoucherTypeID,
MAX(OT2101.TranMonth) AS RequestTranMonth,		
MAX(OT2101.TranYear) AS RequestTranYear,
MAX(OT2101.QuotationDate) AS RequestVoucherDate, 
NULL AS DebitAccountID, 
NULL AS CreditAccountID, 
0 AS ConvertedAmount,  
NULL AS BudgetType,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
FROM ST2002 ST2002
LEFT JOIN SV2002 SV2002 ON SV2002.TransactionTypeID = ST2002.RequestTransactionTypeID
LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = ST2002.DivisionID AND AT1103.EmployeeID = ST2002.EmployeeID
INNER JOIN OT2101 OT2101 ON OT2101.DivisionID = ST2002.DivisionID AND OT2101.QuotationID = ST2002.RequestVoucherID
' + @sSQLPer +'
WHERE	ST2002.DivisionID = '''+@DivisionID+'''
		AND ST2002.ModuleID LIKE '''+@ModuleID+'''
		'+@sWHERE+'	'+ @sWHEREPer+ '

GROUP BY 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description],
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
'

----------- Đơn hàng bán
set @sSQL2 = '
UNION ALL

SELECT 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName AS EmployeeName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description] AS RequestTransactionTypeName,
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
MAX(OT2001.VoucherTypeID) AS RequestVoucherTypeID,
MAX(OT2001.TranMonth) AS RequestTranMonth,		
MAX(OT2001.TranYear) AS RequestTranYear,
MAX(OT2001.OrderDate) AS RequestVoucherDate, 
NULL AS DebitAccountID, 
NULL AS CreditAccountID, 
0 AS ConvertedAmount,  
NULL AS BudgetType,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
FROM ST2002 ST2002
LEFT JOIN SV2002 SV2002 ON SV2002.TransactionTypeID = ST2002.RequestTransactionTypeID
LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = ST2002.DivisionID AND AT1103.EmployeeID = ST2002.EmployeeID
INNER JOIN OT2001 OT2001 ON OT2001.DivisionID = ST2002.DivisionID AND OT2001.SOrderID = ST2002.RequestVoucherID
' + @sSQLPer +'
WHERE	ST2002.DivisionID = '''+@DivisionID+'''
		AND ST2002.ModuleID LIKE '''+@ModuleID+'''
		'+@sWHERE+'	'+ @sWHEREPer+ '

GROUP BY 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description],
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
'

----------- Yêu cầu mua hàng
set @sSQL3 = '
UNION ALL

SELECT 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName AS EmployeeName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description] AS RequestTransactionTypeName,
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
MAX(OT3101.VoucherTypeID) AS RequestVoucherTypeID,
MAX(OT3101.TranMonth) AS RequestTranMonth,		
MAX(OT3101.TranYear) AS RequestTranYear,
MAX(OT3101.OrderDate) AS RequestVoucherDate, 
NULL AS DebitAccountID, 
NULL AS CreditAccountID, 
0 AS ConvertedAmount,  
NULL AS BudgetType,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
FROM ST2002 ST2002
LEFT JOIN SV2002 SV2002 ON SV2002.TransactionTypeID = ST2002.RequestTransactionTypeID
LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = ST2002.DivisionID AND AT1103.EmployeeID = ST2002.EmployeeID
INNER JOIN OT3101 OT3101 ON OT3101.DivisionID = ST2002.DivisionID AND OT3101.ROrderID = ST2002.RequestVoucherID
' + @sSQLPer +'
WHERE	ST2002.DivisionID = '''+@DivisionID+'''
		AND ST2002.ModuleID LIKE '''+@ModuleID+'''
		'+@sWHERE+'	'+ @sWHEREPer+ '

GROUP BY 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description],
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
'

END
--------------Module WM
----------- Nhập kho - Xuất kho - Chuyển kho
IF @ModuleID = 'WM'
BEGIN

set @sSQL = '
SELECT 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName AS EmployeeName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description] AS RequestTransactionTypeName,
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
MAX(AT2006.VoucherTypeID) AS RequestVoucherTypeID,
MAX(AT2006.TranMonth) AS RequestTranMonth,		
MAX(AT2006.TranYear) AS RequestTranYear,
MAX(AT2006.VoucherDate) AS RequestVoucherDate, 
NULL AS DebitAccountID, 
NULL AS CreditAccountID, 
0 AS ConvertedAmount,  
NULL AS BudgetType,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
FROM ST2002 ST2002
LEFT JOIN SV2002 SV2002 ON SV2002.TransactionTypeID = ST2002.RequestTransactionTypeID
LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = ST2002.DivisionID AND AT1103.EmployeeID = ST2002.EmployeeID
INNER JOIN AT2006 AT2006 ON AT2006.DivisionID = ST2002.DivisionID AND AT2006.VoucherID = ST2002.RequestVoucherID AND AT2006.KindVoucherID IN(1,2,3)
' + @sSQLPer +'
WHERE	ST2002.DivisionID = '''+@DivisionID+'''
		AND ST2002.ModuleID LIKE '''+@ModuleID+'''
		'+@sWHERE+'	'+ @sWHEREPer+ '	
		AND ST2002.FormID <> ''WF0014''

GROUP BY 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description],
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
'

----------- Xuất kho theo bộ
set @sSQL1 = '
UNION ALL

SELECT 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName AS EmployeeName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description] AS RequestTransactionTypeName,
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
MAX(AT2026.VoucherTypeID) AS RequestVoucherTypeID,
MAX(AT2026.TranMonth) AS RequestTranMonth,		
MAX(AT2026.TranYear) AS RequestTranYear,
MAX(AT2026.VoucherDate) AS RequestVoucherDate, 
NULL AS DebitAccountID, 
NULL AS CreditAccountID, 
0 AS ConvertedAmount,  
NULL AS BudgetType,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
FROM ST2002 ST2002
LEFT JOIN SV2002 SV2002 ON SV2002.TransactionTypeID = ST2002.RequestTransactionTypeID
LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = ST2002.DivisionID AND AT1103.EmployeeID = ST2002.EmployeeID
INNER JOIN AT2026 AT2026 ON AT2026.DivisionID = ST2002.DivisionID AND AT2026.VoucherID = ST2002.RequestVoucherID
' + @sSQLPer +'
WHERE	ST2002.DivisionID = '''+@DivisionID+'''
		AND ST2002.ModuleID LIKE '''+@ModuleID+'''
		'+@sWHERE+'	'+ @sWHEREPer+ '

GROUP BY 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description],
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
'
----------- Phiếu kiểm kê
set @sSQL2 = '
UNION ALL

SELECT 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName AS EmployeeName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description] AS RequestTransactionTypeName,
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
MAX(AT2036.VoucherTypeID) AS RequestVoucherTypeID,
MAX(AT2036.TranMonth) AS RequestTranMonth,		
MAX(AT2036.TranYear) AS RequestTranYear,
MAX(AT2036.VoucherDate) AS RequestVoucherDate, 
NULL AS DebitAccountID, 
NULL AS CreditAccountID, 
0 AS ConvertedAmount,  
NULL AS BudgetType,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
FROM ST2002 ST2002
LEFT JOIN SV2002 SV2002 ON SV2002.TransactionTypeID = ST2002.RequestTransactionTypeID
LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = ST2002.DivisionID AND AT1103.EmployeeID = ST2002.EmployeeID
INNER JOIN AT2036 AT2036 ON AT2036.DivisionID = ST2002.DivisionID AND AT2036.VoucherID = ST2002.RequestVoucherID
' + @sSQLPer +'
WHERE	ST2002.DivisionID = '''+@DivisionID+'''
		AND ST2002.ModuleID LIKE '''+@ModuleID+'''
		'+@sWHERE+'	'+ @sWHEREPer+ '

GROUP BY 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description],
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
'
	
END
--------------Module M
IF @ModuleID = 'M'
BEGIN

----------- Kết quả sản xuất 
set @sSQL = N'
SELECT 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName AS EmployeeName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description] AS RequestTransactionTypeName,
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
MAX(MT0810.VoucherTypeID) AS RequestVoucherTypeID,
MAX(MT0810.TranMonth) AS RequestTranMonth,		
MAX(MT0810.TranYear) AS RequestTranYear,
MAX(MT0810.VoucherDate) AS RequestVoucherDate, 
NULL AS DebitAccountID, 
NULL AS CreditAccountID, 
0 AS ConvertedAmount,  
NULL AS BudgetType,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
FROM ST2002 ST2002
LEFT JOIN SV2002 SV2002 ON SV2002.TransactionTypeID = ST2002.RequestTransactionTypeID
LEFT JOIN AT1103 AT1103 ON AT1103.DivisionID = ST2002.DivisionID AND AT1103.EmployeeID = ST2002.EmployeeID
INNER JOIN MT0810 MT0810 ON MT0810.DivisionID = ST2002.DivisionID AND MT0810.VoucherID = ST2002.RequestVoucherID
' + @sSQLPer +'
WHERE	ST2002.DivisionID = '''+@DivisionID+'''
		AND ST2002.ModuleID LIKE '''+@ModuleID+'''
		'+@sWHERE+'	'+ @sWHEREPer+ '

GROUP BY 
ST2002.ModuleID,		
ST2002.DivisionID,		ST2002.TranMonth,		ST2002.TranYear,
ST2002.RequestID,		ST2002.FormID,
ST2002.VoucherTypeID,	ST2002.VoucherNo,		ST2002.VoucherDate,
ST2002.EmployeeID,		AT1103.FullName,
ST2002.RequestDescription,
ST2002.RequestTransactionTypeID, SV2002.[Description],
ST2002.RequestVoucherID,
ST2002.RequestVoucherNo,
ST2002.IsApproved,
ST2002.CreateUserID,ST2002.CreateDate,ST2002.LastModifyUserID,ST2002.LastModifyDate 
'
	
END

PRINT(@sSQL)
PRINT(@sSQL1)
PRINT(@sSQL2)
PRINT(@sSQL3)


EXEC(@sSQL + @sSQL1 + @sSQL2 +@sSQL3)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
