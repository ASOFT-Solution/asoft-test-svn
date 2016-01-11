IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0027]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0027]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Hiển thị danh sách đơn hàng bán
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 30/09/2013 by Bảo Anh
---- 
---- Modified on 28/02/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
---- Modified on 04/08/2014 by Bảo Anh : Bo sung lọc theo MPT8 (Sinolife)
---- Modified on 15/06/2015 by Hoàng Vũ : Bo sung lọc theo OrderTypeID (phân loại đơn hàng bán và đơn hàng điều chỉnh) (Secoin)
---- Modified by Tiểu Mai on 04/01/2016: Bổ sung trường DiscountSalesAmount
-- <Example>
---- 
--- EXEC OP0027 'AS','1',2013,12,2015,'01/01/2013','31/12/2015',1,0,0,'%','%','((''''))', '((0 = 0))','((''''))', '((0 = 0))',1,'OT2002.InventoryID like ''HHLY034%''', '1'

--- EXEC OP0027 'AS',1,2013,12,2015,'01/01/2013','12/31/2015',0,0,0,'%','%','((''''))', '((0 = 0))','((''''))', '((0 = 0))',1,'OT2002.InventoryID like ''%%''', 1

CREATE PROCEDURE [dbo].[OP0027] 
(
	@DivisionID nvarchar(50),
	@FromMonth int,
    @FromYear int,
    @ToMonth int,
    @ToYear int,  
    @FromDate as datetime,
    @ToDate as Datetime,
    @IsDate as tinyint, ----0 theo ky, 1 theo ngày
	@IsPrinted AS INT = 0,	--- 0 : Không check
							--- 1 : Check đã in
							--- 2 : Check chưa in
	@Status AS INT = '',
	@ObjectID AS NVARCHAR(50) = '',
	@VoucherTypeID AS NVARCHAR(50) = '',
	@ConditionVT nvarchar(max),
	@IsUsedConditionVT nvarchar(20),
	@ConditionOB nvarchar(max),
	@IsUsedConditionOB nvarchar(20),
	@IsServer AS INT = 0,	--0 : Tim kiem Master
							-- 1 : Tim kiem Detail
	@StrWhere AS NVARCHAR(4000) = '', --Dieu kien tim kiem tren luoi
	@UserID AS VARCHAR(50) = '',
	@Ana08ID AS VARCHAR(50) = '', --- Customize cho Sinolife
	@OrderTypeID AS int = ''-- Null hay '': Tất cả
							-- 0 : Đơn hàng bán
							-- 1 : Đơn hàng bán điều chỉnh
)
AS

Declare @sSQL1 AS varchar(max),
		@sSQL2 AS varchar(max),
		@sSQL AS varchar(max),
		@DivisionWhere AS VARCHAR(MAX),
		@sWHERE AS VARCHAR(MAX)

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
			
SET @sWHERE = ''

IF @IsPrinted IS NOT NULL AND @IsPrinted = 1
BEGIN
	SET @sWHERE = @sWHERE + N' AND ISNULL(OT2001.IsPrinted, 0) = 1 '
END

IF @IsPrinted IS NOT NULL AND @IsPrinted = 2 
BEGIN
	SET @sWHERE = @sWHERE + N' AND ISNULL(OT2001.IsPrinted, 0) = 0 '
END

IF @ObjectID IS NOT NULL AND @ObjectID <> '' AND @ObjectID <> '%'
BEGIN
	SET @sWHERE = @sWHERE + N'	AND OT2001.ObjectID = '''+@ObjectID+'''	'
END

IF  @OrderTypeID IS NOT NULL
BEGIN
	SET @sWHERE = @sWHERE + N'	AND Isnull(OT2001.OrderTypeID,0) = ' + STR(@OrderTypeID) + ' '
END

IF @Status IS NOT NULL
BEGIN
	SET @sWHERE = @sWHERE + N'	AND Isnull(OT2001.OrderStatus,0) = ' + STR(@Status) + ' '
END

IF @VoucherTypeID IS NOT NULL AND @VoucherTypeID <> '' AND @VoucherTypeID <> '%'
BEGIN
	SET @sWHERE = @sWHERE + N'	AND OT2001.VoucherTypeID = '''+@VoucherTypeID+''' '
END

SET @DivisionWhere = ' WHERE	OT2001.DivisionID = ''' + @DivisionID + ''' '

IF @IsDate = 0
	Set  @DivisionWhere = @DivisionWhere + '
		And (OT2001.TranMonth + OT2001.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +  cast(@ToMonth + @ToYear*100 as nvarchar(50))  + ')'
else
	Set  @DivisionWhere = @DivisionWhere + '
		And (OT2001.OrderDate  Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''')'

SET @sSQL1 =' 
SELECT	DISTINCT OT2001.DivisionID,
		OT2001.SOrderID, 
		OT2001.VoucherTypeID, 
		AV2001.Name as OrderTypeID,
		OT2001.VoucherNo,
		OT2001.OrderDate, 
		OT2001.ContractNo, 
		OT2001.ContractDate,
		OT2001.CurrencyID,
		OT2001.ExchangeRate,  
		OT2001.PaymentID,
		OT2001.ObjectID,  
		ISNULL(OT2001.ObjectName, AT1202.ObjectName)   AS ObjectName, 
		OT2001.DeliveryAddress, 
		OT2001.ClassifyID, 
		ClassifyName,
		OT2001.EmployeeID,  
		AT1103.FullName,
		ConvertedAmount = (SELECT Sum(ISNULL(ConvertedAmount,0)- ISNULL(DiscountConvertedAmount,0)- ISNULL(CommissionCAmount,0) +
		ISNULL(VATConvertedAmount, 0))  FROM OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
		OriginalAmount = (SELECT Sum(ISNULL(OriginalAmount,0)- ISNULL(DiscountOriginalAmount,0) - ISNULL(CommissionOAmount, 0) +
		ISNULL(VAToriginalAmount, 0))  FROM OT2002 Where OT2002.SOrderID = OT2001.SOrderID),
		OT2001.Notes, 
		OT2001.Disabled, 
		OT2001.OrderStatus, 
		OV1001.LanguageID AS OrderStatusName, 
		OV1001.EDescription AS EOrderStatusName, 
		OT2001.Ana01ID, 
		OT2001.Ana02ID, 
		OT2001.Ana03ID, 
		OT2001.Ana04ID, 
		OT2001.Ana05ID, 
		OT1002_1.AnaName AS Ana01Name, 
		OT1002_2.AnaName AS Ana02Name, 
		OT1002_3.AnaName AS Ana03Name, 
		OT1002_4.AnaName AS Ana04Name, 
		OT1002_5.AnaName AS Ana05Name, 
		OT2001.ShipDate, 
		OT2001.DueDate,		
		OT1102.Description AS  IsConfirm,
		OT1102.EDescription AS EIsConfirm,
		OT2001.DescriptionConfirm,
		OT2001.IsPrinted,
		Isnull(OT2001.DiscountSalesAmount,0) as DiscountSalesAmount'

SET @sSQL2 ='
FROM OT2001 

LEFT JOIN AT1202 ON OT2001.DivisionID = AT1202.DivisionID AND AT1202.ObjectID = OT2001.ObjectID 
LEFT JOIN OT1002 OT1002_1 ON OT1002_1.DivisionID = OT2001.DivisionID AND OT1002_1.AnaID = OT2001.Ana01ID AND OT1002_1.AnaTypeID = ''S01''
LEFT JOIN OT1002 OT1002_2 ON OT1002_2.DivisionID = OT2001.DivisionID AND OT1002_2.AnaID = OT2001.Ana02ID AND OT1002_2.AnaTypeID = ''S02''
LEFT JOIN OT1002 OT1002_3 ON OT1002_3.DivisionID = OT2001.DivisionID AND OT1002_3.AnaID = OT2001.Ana03ID AND OT1002_3.AnaTypeID = ''S03''
LEFT JOIN OT1002 OT1002_4 ON OT1002_4.DivisionID = OT2001.DivisionID AND OT1002_4.AnaID = OT2001.Ana04ID AND OT1002_4.AnaTypeID = ''S04''
LEFT JOIN OT1002 OT1002_5 ON OT1002_5.DivisionID = OT2001.DivisionID AND OT1002_5.AnaID = OT2001.Ana05ID AND OT1002_5.AnaTypeID = ''S05''
LEFT JOIN AT1103 ON AT1103.DivisionID = OT2001.DivisionID AND AT1103.EmployeeID = OT2001.EmployeeID 

LEFT JOIN OT1001 ON OT2001.DivisionID = OT1001.DivisionID AND OT1001.ClassifyID = OT2001.ClassifyID AND OT1001.TypeID = ''SO''
LEFT JOIN OT1101 OV1001  ON  OT2001.DivisionID = OV1001.DivisionID AND  OV1001.OrderStatus = OT2001.OrderStatus AND OV1001.TypeID = case when OT2001.OrderType <> 1 then ''SO'' else ''MO'' end 
LEFT JOIN OT1102 ON OT2001.DivisionID = OT1102.DivisionID AND OT1102.Code = OT2001.IsConfirm AND OT1102.TypeID = ''SO''
Left join AV2001 on AV2001.ID = OT2001.OrderTypeID
'

--Print 	@sSQL1
--Print 	@sSQL2

SET @sSQL2 =  @sSQL2 + @sSQLPer + ' ' + @DivisionWhere + @sWHEREPer +' 
	AND OT2001.OrderType <> 1 ' + @sWHERE + ' 
	AND (ISNULL(OT2001.ObjectID, ''#'') IN (' + @ConditionOB + ') Or ' + @IsUsedConditionOB + ') 
	AND (ISNULL(OT2001.VoucherTypeID, ''#'') IN (' + @ConditionVT + ') Or ' + @IsUsedConditionVT + ')'

IF @IsServer = 1
	SET @sSQL = 'SELECT DISTINCT A.*
	FROM (' + @sSQL1 + @sSQL2 + ') A 
	INNER JOIN OT2002 ON OT2002.SOrderID = A.SOrderID AND OT2002.DivisionID = A.DivisionID
	LEFT JOIN AT1302 ON AT1302.InventoryID= OT2002.InventoryID AND AT1302.DivisionID = OT2002.DivisionID
	WHERE ' + @StrWhere + ' 
	ORDER BY OrderDate, VoucherNo'
ELSE IF @Ana08ID <> ''
	SET @sSQL = 'SELECT DISTINCT A.*
	FROM (' + @sSQL1 + @sSQL2 + ') A 
	INNER JOIN OT2002 ON OT2002.SOrderID = A.SOrderID AND OT2002.DivisionID = A.DivisionID
	WHERE Isnull(OT2002.Ana08ID,'''') = ''' + @Ana08ID + '''
	ORDER BY OrderDate, VoucherNo'
ELSE
	SET @sSQL = 'SELECT * FROM (' + @sSQL1 + @sSQL2 + ') A ' + ' 
	             ORDER BY OrderDate, VoucherNo'
	
--PRINT @sSQL
EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON