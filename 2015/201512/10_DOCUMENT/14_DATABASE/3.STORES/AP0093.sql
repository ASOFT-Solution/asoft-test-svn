IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0093]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0093]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Truy vấn hóa đơn bán hàng thay cho AV3066
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 23/09/2013 by Khanh Van
---- 
---- Modified on 05/03/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
---- Modified on 13/06/2014 by Le Thi Thu Hien : Bỏ where TableID
---- Modified on 01/07/2014 by Le Thi Thu Hien : Bổ sung 1 số thông tin
---- Modified on 05/05/2015 by Thanh Sơn : Bổ sung  Order by
---- Modified on 17/11/2015 by Quốc Tuấn : Sửa lại tính số lần in
-- <Example>
---- 
-- <Summary>

CREATE PROCEDURE AP0093
			@DivisionID NVARCHAR(50),
			@TranMonth INT,
			@TranYear INT,
			@FromDate DATETIME,
			@ToDate DATETIME,
			@ConditionVT NVARCHAR(1000),
			@IsUsedConditionVT NVARCHAR(1000),
			@ConditionAC NVARCHAR(1000),
			@IsUsedConditionAC NVARCHAR(1000),
			@ConditionOB NVARCHAR(1000),
			@IsUsedConditionOB NVARCHAR(1000),
			@ObjectID NVARCHAR(50),
			@UserID VARCHAR(50) = ''
AS	
DECLARE @sSQL NVARCHAR(MAX),
		@sSQLFrom NVARCHAR(MAX),
		@sWhere NVARCHAR(MAX),
		@sGroup NVARCHAR(MAX)
		
----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer NVARCHAR(1000),
		@sWHEREPer NVARCHAR(1000)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1 ) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = A00.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = A00.CreateUserID '
		SET @sWHEREPer = ' AND (A00.CreateUserID = AT0010.UserID
								OR  A00.CreateUserID = '''+@UserID+''') '		
	END
-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		
SET @sSQL = N'
SELECT  A00.DivisionID, A00.TranMonth, A00.TranYear, A00.VoucherID, A00.BatchID, A00.ReVoucherID, A00.ReTableID,
	A00.VoucherDate, A00.VoucherNo, A00.Serial, A00.InvoiceNo, (SELECT COUNT(VoucherID) FROM AT1112 A12 WHERE A12.DivisionID=A00.DivisionID AND A12.VoucherID=A00.VoucherID) PrintedTimes,
	A00.VoucherTypeID, A00.VATTypeID, A00.InvoiceDate, A00.VDescription, A00.CurrencyID, A00.ExchangeRate,
	SUM(CASE WHEN A00.TransactionTypeID IN (''T04'') THEN OriginalAmount 
		ELSE CASE WHEN A00.TransactionTypeID IN (''T64'') THEN -OriginalAmount ELSE 0 END END) OriginalAmount,
	SUM(CASE WHEN TransactionTypeID IN (''T04'') THEN ConvertedAmount
		ELSE CASE WHEN TransactionTypeID IN (''T64'') THEN -ConvertedAmount ELSE 0 END END) ConvertedAmount,
	A00.ObjectID, A02.ObjectName, A02.VATNo, A02.[Address], A02.CityID, AT1002.CityName,
	A00.VATObjectID, (CASE WHEN A.IsUpdateName = 0 THEN A.ObjectName ELSE A00.VATObjectName END) VATObjectName,
	A00.DueDate, '''' OrderID, ISNULL(A00.IsStock, 0) IsStock, 
	ISNULL((SELECT SUM(ConvertedAmount) FROM AT9000 C WHERE C.VoucherID = A00.VoucherID AND C.TransactionTypeID =''T54''), 0) CommissionAmount,
	SUM(ISNULL(DiscountAmount, 0)) DiscountAmount, SUM(CASE WHEN TransactionTypeID = ''T14'' THEN ConvertedAmount ELSE 0 END) TaxAmount,
	SUM(CASE WHEN A00.TransactionTypeID = ''T14'' THEN OriginalAmount ELSE 0 END) TaxOriginalAmount, --Tiền thuế quy đổi 
	MIN(A11.AnaName) Ana01Name, A06.WareHouseID, A00.CreateUserID
FROM AT9000 A00
	LEFT JOIN AT2006 A06 ON A06.DivisionID = A00.DivisionID AND A06.VoucherID = A00.VoucherID
	LEFT JOIN AT1202 A02 ON A02.DivisionID = A00.DivisionID AND A02.ObjectID = A00.ObjectID
	LEFT JOIN AT1202 A ON A.DivisionID = A00.DivisionID AND A.ObjectID = A00.VATObjectID  
	LEFT JOIN AT1002 ON AT1002.DivisionID = A02.DivisionID AND AT1002.CityID = A02.CityID  
	LEFT JOIN AT1011 A11 ON A11.DivisionID = A00.DivisionID AND A11.AnaID = A00.Ana01ID AND A11. AnaTypeID = ''A01''  '

SET @sWhere = N'
WHERE A00.TransactionTypeID IN (''T04'', ''T14'',''T64'') --and TableID in ( ''AT9000'')    
	AND A00.DivisionID = '''+@DivisionID+'''
	AND	A00.TranMonth = '+CONVERT(NVARCHAR(2),@TranMonth)+' AND A00.TranYear = '+CONVERT(NVARCHAR(4),@TranYear)+'
	AND	(ISNULL(A00.VoucherTypeID,''#'') IN '+@ConditionVT+' OR '+@IsUsedConditionVT+')
	AND	(ISNULL(A00.DebitAccountID,''#'') IN '+@ConditionAC+' OR '+@IsUsedConditionAC+')
	AND	(ISNULL(A00.CreditAccountID,''#'') IN '+@ConditionAC+' OR '+@IsUsedConditionAC+')
	AND	(ISNULL(A00.ObjectID,''#'')  IN '+@ConditionOB+' OR '+@IsUsedConditionOB+')
	AND A00.VoucherDate BETWEEN '''+CONVERT(NVARCHAR(10), @FromDate, 21)+''' AND '''+CONVERT(NVARCHAR(10), @ToDate, 21)+'''
	AND A00.ObjectID LIKE ('''+@ObjectID+''')
'+@sWHEREPer+''
	
SET @sGroup = N'
GROUP BY A00.DivisionID, A00.TranMonth, A00.TranYear, A00.VoucherID, A00.BatchID, A00.ReVoucherID, A00.ReTableID,
	A00.VoucherDate, A00.VoucherNo, A00.Serial, A00.InvoiceNo, A00.VoucherTypeID, A00.VATTypeID, A00.InvoiceDate,
	A00.VDescription, A00.CurrencyID, A00.ExchangeRate, A00.ObjectID, A02.ObjectName, A02.VATNo, A02.[Address],
	A02.CityID, AT1002.CityNAme, A00.DueDate, A02.IsUpdateName, A00.VATObjectName, ISNULL(IsStock, 0),
	A00.VATObjectID, A.ObjectName, A.IsUpdateName, A00.CreateUserID, A06.WareHouseID
ORDER BY A00.DivisionID, A00.VoucherDate, A00.VoucherTypeID, A00.VoucherNo'
	
--PRINT(@sSQL)
--PRINT(@sSQLFrom)
--PRINT(@sSQLPer)
--PRINT(@sWhere)
--PRINT(@sWHEREPer)
--PRINT(@sGroup)

EXEC(@sSQL+ @sSQLPer + @sWhere + @sGroup)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
