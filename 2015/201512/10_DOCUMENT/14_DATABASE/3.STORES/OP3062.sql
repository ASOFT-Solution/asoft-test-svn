IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3062]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3062]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- In bao cao Tong hop Don hang ban
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create ON 15/03/2006 by Vo Thanh Huong
---- 
---- Modified ON 30/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
---- Modified ON 11/12/2012 by Le Thi Thu Hien : Sua dieu kien @Condition
---- Modified on 03/10/2013 by Thanh Sơn: thêm 5 MPT nghiệp vụ, 5 MPT đối tượng, 5 MPT mặt hàng
---- Modified ON 11/02/2014 by Le Thi Thu Hien : Bo sung tach chuoi vi dai qua
---- Modified on 02/03/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
-- <Example>
---- EXEC OP3062 'SAS',1,1,2013,1,2013,'01-01-2013','02-01-2013','','',1,'',''

CREATE PROCEDURE [dbo].[OP3062] 
    @DivisionID NVARCHAR(50),
    @IsDate TINYINT,
    @FromMonth INT,
    @FromYear INT,
    @ToMonth INT,
    @ToYear INT,	
    @FromDate DATETIME,
    @ToDate DATETIME,
    @FromObject NVARCHAR(20),
    @ToObject NVARCHAR(20),
    @OrderStatus INT,
    @UserID As nvarchar(50),
	@UserGroupID As nvarchar(50)
AS
DECLARE 
    @sSQL NVARCHAR(max),
    @sSQL1 NVARCHAR(max),
    @sSQL2 NVARCHAR(max),
    @sPeriod NVARCHAR(max), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20),
    @Condition NVARCHAR(MAX),
    @CustomerName INT,
    @sSQL3 NVARCHAR(200) = '',
    @sSQL4 NVARCHAR(100) = ''

SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)
IF @CustomerName = 20 --- Customize Sinolife
BEGIN
	SET @sSQL3 = 'LEFT JOIN AT1202 AT1202_1 ON AT1202_1.DivisionID = OT2001.DivisionID AND AT1202_1.ObjectID = OT2001.SalesManID'
	SET @sSQL4 = 'AT1202_1.ObjectName'
END
ELSE 
BEGIN
	SET @sSQL3 = 'LEFT JOIN AT1103 AT1103_2 ON AT1103_2.DivisionID = OT2001.DivisionID AND AT1103_2.EmployeeID = OT2001.SalesManID'
	SET @sSQL4 = 'AT1103_2.FullName'
END	

----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS NVARCHAR(MAX),
		@sWHEREPer AS NVARCHAR(MAX)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM OT0001 WHERE DivisionID = @DivisionID AND IsPermissionView = 1 ) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = OT2001.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = OT2001.CreateUserID '
		SET @sWHEREPer = ' AND (OT2001.CreateUserID = AT0010.UserID
								OR  OT2001.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		
If @UserID<>''
EXEC AP1409 @DivisionID,'ASOFTOP','VT','VT',@UserID,@UserGroupID,0,@Condition OUTPUT

SET @sPeriod = CASE WHEN @IsDate = 1 
THEN ' AND CONVERT(DATETIME, CONVERT(VARCHAR(10), OT2001.OrderDate, 101), 101) BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + '''' 
ELSE ' AND OT2001.TranMonth + OT2001.TranYear * 100 BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText END

SET @sSQL = '
SELECT 	OT2001.DivisionID,
OT2001.SOrderID, 
OT2001.VoucherTypeID, 
OT2001.VoucherNo, 
OT2001.OrderDate, 
OT2001.ContractNo, 
OT2001.ContractDate, 
OT2001.ClassifyID, 
OT2001.OrderType, 
OT2001.ObjectID, 
OT2001.DeliveryAddress, 
OT2001.Notes, 
OT2001.Disabled, 
OT2001.OrderStatus, 
OT2001.QuotationID, 
OT2001.CreateDate, 
OT2001.CreateUserID, 
OT2001.LastModifyUserID, 
OT2001.LastModifyDate, 
OT2002.Ana01ID, 
OT2002.Ana02ID, 
OT2002.Ana03ID, 
OT2002.Ana04ID, 
OT2002.Ana05ID, 
OT2002.Ana06ID, 
OT2002.Ana07ID, 
OT2002.Ana08ID, 
OT2002.Ana09ID, 
OT2002.Ana10ID, 
OT1002_1.AnaName AS Ana01Name,
OT1002_2.AnaName AS Ana02Name,
OT1002_3.AnaName AS Ana03Name,
OT2001.CurrencyID, 
AT1004.CurrencyName,
OT2001.ExchangeRate, 
OT2001.InventoryTypeID, 
OT2001.TranMonth, 
OT2001.TranYear, 
OT2001.EmployeeID, 
AT1103.FullName,
OT2001.Transport, 
OT2001.PaymentID, 
CASE WHEN ISNULL(OT2001.ObjectName, '''') <> '''' THEN OT2001.ObjectName ELSE AT1202.ObjectName END AS ObjectName,
CASE WHEN ISNULL(OT2001.VatNo, '''') <> '''' THEN OT2001.VATNo ELSE AT1202.VATNo END AS VATNo,
CASE WHEN ISNULL(OT2001.Address, '''') <> '''' THEN OT2001.Address ELSE AT1202.Address END AS Address,'
SET @sSQL1  = '
AT1202.Tel,
AT1202.Fax,
AT1202.Email,
AT1202.O01ID,
AT1202.O02ID,
AT1202.O03ID,
AT1202.O04ID,
AT1202.O05ID,
AT1302.I01ID,
AT1302.I02ID,
AT1302.I03ID,
AT1302.I04ID,
AT1302.I05ID,
OT2001.IsPeriod, 
OT2001.IsPlan, 
OT2001.DepartmentID, 
OT2001.SalesManID, 
'+@sSQL4+' AS SalesManName,
OT2001.ShipDate, 
OT2001.InheritSOrderID, 
OT2001.DueDate, 
OT2001.PaymentTermID, 
OV1001.Description AS OrderStatusName,
OV1001.EDescription AS EOrderStatusName,
OriginalAmount = (SELECT SUM(ISNULL(OriginalAmount, 0)) FROM OT2002 WHERE OT2002.SOrderID = OT2001.SOrderID),
ConvertedAmount = (SELECT SUM(ISNULL(ConvertedAmount, 0)) FROM OT2002 WHERE OT2002.SOrderID = OT2001.SOrderID),
VATOriginalAmount = (SELECT SUM(ISNULL(VATOriginalAmount, 0)) FROM OT2002 WHERE OT2002.SOrderID = OT2001.SOrderID),
VATConvertedAmount = (SELECT SUM(ISNULL(VATConvertedAmount, 0)) FROM OT2002 WHERE OT2002.SOrderID = OT2001.SOrderID),
DiscountOriginalAmount = (SELECT SUM(ISNULL(DiscountOriginalAmount, 0)) FROM OT2002 WHERE OT2002.SOrderID = OT2001.SOrderID),
DiscountConvertedAmount = (SELECT SUM(ISNULL(DiscountConvertedAmount, 0)) FROM OT2002 WHERE OT2002.SOrderID = OT2001.SOrderID),
CommissionCAmount = (SELECT SUM(ISNULL(CommissionCAmount, 0)) FROM OT2002 WHERE OT2002.SOrderID = OT2001.SOrderID),
CommissionOAmount = (SELECT SUM(ISNULL(CommissionOAmount, 0)) FROM OT2002 WHERE OT2002.SOrderID = OT2001.SOrderID)
'
SET @sSQL2 = '
FROM OT2001 
LEFT JOIN OV1001 ON OV1001.DivisionID = OT2001.DivisionID AND OV1001.OrderStatus = OT2001.OrderStatus AND OV1001.TypeID = ''SO''
LEFT JOIN AT1202 ON AT1202.DivisionID = OT2001.DivisionID AND AT1202.ObjectID = OT2001.ObjectID
LEFT JOIN AT1103 ON AT1103.DivisionID = OT2001.DivisionID AND AT1103.FullName = OT2001.EmployeeID 
'+@sSQL3+'
LEFT JOIN OT1002 OT1002_1 ON OT1002_1.DivisionID = OT2001.DivisionID AND OT1002_1.AnaID = OT2001.Ana01ID AND OT1002_1.AnaTypeID = ''S01'' 
LEFT JOIN OT1002 OT1002_2 ON OT1002_2.DivisionID = OT2001.DivisionID AND OT1002_2.AnaID = OT2001.Ana02ID AND OT1002_2.AnaTypeID = ''S02''
LEFT JOIN OT1002 OT1002_3 ON OT1002_3.DivisionID = OT2001.DivisionID AND OT1002_3.AnaID = OT2001.Ana03ID AND OT1002_3.AnaTypeID = ''S03''
LEFT JOIN AT1004 ON AT1004.DivisionID = OT2001.DivisionID AND AT1004.CurrencyID = OT2001.CurrencyID 
LEFT JOIN OT2002 ON OT2002.DivisionID = OT2001.DivisionID AND OT2002.SOrderID = OT2001.SOrderID
LEFT JOIN AT1302 ON AT1302.DivisionID = OT2002.DivisionID AND AT1302.InventoryID = OT2002.InventoryID
'+@sSQLPer+'
WHERE OT2001.DivisionID LIKE ''' + @DivisionID + ''' 
'+@sWHEREPer+'
AND OT2001.OrderType = 0      -- 0: Đơn hàng bán      1: Đơn hàng sản xuất
AND OT2001.ObjectID BETWEEN ''' + @FromObject + ''' AND ''' + @ToObject + ''' 
AND OT2001.OrderStatus LIKE ' + CASE WHEN @OrderStatus = - 1 THEN '''%''' ELSE CAST(@OrderStatus AS NVARCHAR(1)) END + @sPeriod 
+ Case When @UserID<>'' AND ISNULL (@Condition, '') <> '' Then ' AND isnull(OT2001.VoucherTypeID,''#'') In ' + @Condition Else '' End

-- PRINT(@sSQL)
IF EXISTS(SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'OV3062')
    DROP VIEW OV3062
EXEC('CREATE VIEW OV3062 -- Tạo bởi OP3062
        AS ' + @sSQL + @sSQL1 + @sSQL2)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON