IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0032]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0032]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by : Thuy Tuyen
---- Date : 26/05/2009
---- Purpose: Loc ra cac don hang ban cho man hinh duyet don hang ban
----Edit Thuy Tuyen, date 22/10/2009
---- Date: 2/11/2009 , lay truong IsConfirmName, 25/01/2009
---- Edit Tan Phu, date 12/09/2012
---- Purpose: Cải thiện tốc độ xử lý 
---- ---and OT2001.SOrderID  not in (select distinct isnull(OrderID,'''')  from AT9000 )--chi cac phieu chua ke thua sang hoa  don  ban hang 
----    thay thế = and (select COUNT(OrderID)  from AT9000 where AT9000.DivisionID = OT2001.DivisionID and AT9000.OrderID = OT2001.SOrderID) = 0 --chi cac phieu chua ke thua sang hoa  don  ban hang 
---- Modified on 11/10/2012 by Lê Thị Thu Hiền : Bổ sung WHERE điều kiện nếu là Thuận Lợi
---- Modified on 21/01/2013 by Lê Thị Thu Hiền : Bổ sung điều kiện lọc master
---- Modified on 01/10/2013 by Bảo Anh: Sửa tên store từ OP0033 thành OP0032 và chỉ load dữ liệu lưới master (cải thiện tốc độ)
---- Modified on 27/10/2013 by Bảo Anh: Bổ sung Orderby

CREATE PROCEDURE [dbo].[OP0032]  
				@DivisionID nvarchar(50),
				@ObjectID nvarchar (50),
				@FromMonth  int,
				@FromYear int,
				@ToMonth int,
				@ToYear int ,
				@IsCheck TINYINT,
				@IsPeriod TINYINT = 0,
				@FromDate DATETIME = '',
				@ToDate DATETIME = '',
				@Status TINYINT = 0,
				@VoucherTypeID NVARCHAR(50) = '',
				@IsPrinted TINYINT = 0,
				@ConditionVT nvarchar(max),
				@IsUsedConditionVT nvarchar(20),
				@ConditionOB nvarchar(max),
				@IsUsedConditionOB nvarchar(20), 
				@UserID  nvarchar(50)
 AS
Declare @sSQL1 AS nvarchar(4000),
		@sSQL2 AS nvarchar(4000),
		@sSQL3 AS nvarchar(4000),
		@sWhere AS nvarchar(max),
		@Where1 AS NVARCHAR(4000)

SET @Where1 = ''
SET @sWHERE = ''


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

IF @Status IS NOT NULL
BEGIN
	SET @sWHERE = @sWHERE + N'	AND OT2001.OrderStatus = ' + STR(@Status) + ' '
END

IF @VoucherTypeID IS NOT NULL AND @VoucherTypeID <> '' AND @VoucherTypeID <> '%'
BEGIN
	SET @sWHERE = @sWHERE + N'	AND OT2001.VoucherTypeID = '''+@VoucherTypeID+''' '
END

If @IsCheck  = 1
 Set @sWhere = @sWHERE + ''
Else
 Set @sWhere = @sWHERE + ' AND  OT2001.IsConfirm = 0 '

IF @IsPeriod = 1
	SET @sWhere = @sWhere +	'
	AND OT2001.TranMonth + OT2001.TranYear * 100 BETWEEN '+str(@FromMonth)+' + '+str(@Fromyear)+' *100 and  '+str(@ToMonth)+' + '+str(@Toyear)+' *100 '
ELSE
	SET @sWhere = @sWhere + '
	AND CONVERT(varchar(10),OT2001.OrderDate,101) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,101)+''' AND '''+CONVERT (VARCHAR(10),@ToDate,101)+''' '

SET @sWhere = @sWhere +	
	' And (ISNULL(OT2001.ObjectID, ''#'') IN (' + @ConditionOB + ') Or ' + @IsUsedConditionOB + ') 
	And (ISNULL(OT2001.VoucherTypeID, ''#'') IN (' + @ConditionVT + ') Or ' + @IsUsedConditionVT + ')'

	----- Buoc  1 : Tra ra thong tin Master View OV0033 ( De load truy van)
CREATE TABLE #TAM
(	CustomerName  INT,
	ImportExcel  INT)
	
INSERT INTO #TAM
EXEC AP4444		

IF EXISTS ( SELECT TOP 1 1 FROM #TAM WHERE CustomerName = 12)
SET @where1 = N' AND OT2001.VoucherTypeID NOT LIKE ''BL%'''

Set @sSQL1 =N' 
SELECT OT2001.SOrderID, 
		OT2001.VoucherNo, 
		OT2001.OrderDate, 
		OT2001.ContractNo, 
		OT2001.CurrencyID, 
		OT2001.ExchangeRate,  
		OT2001.ObjectID,  
		isnull(OT2001.ObjectName, AT1202.ObjectName)   AS ObjectName,
		ConvertedAmount = (Select Sum(isnull(ConvertedAmount,0)- isnull(DiscountConvertedAmount,0) +
		isnull(VATConvertedAmount, 0))  From OT2002 Where OT2002.SOrderID = OT2001.SOrderID And OT2002.DivisionID = OT2001.DivisionID),
		OriginalAmount = (Select Sum(isnull(OriginalAmount,0)- isnull(DiscountOriginalAmount,0) +
		isnull(VAToriginalAmount, 0))  From OT2002 Where OT2002.SOrderID = OT2001.SOrderID And OT2002.DivisionID = OT2001.DivisionID),
		OT2001.OrderStatus, 
		OV1001.Description AS OrderStatusName, 
		OV1001.EDescription AS EOrderStatusName,
		'''' AS Ana01ID, 
		'''' AS Ana02ID, 
		'''' AS Ana03ID, 
		'''' AS Ana04ID, 
		'''' AS Ana05ID, 
		'''' AS Ana01Name, 
		'''' AS Ana02Name, 
		'''' AS Ana03Name, 
		'''' AS Ana04Name, 
		'''' AS Ana05Name,
		OT2001.IsInherit,
		OT2001.IsConfirm,
		OT1102.Description AS  IsConfirmName,
		OT1102.EDescription AS EIsConfirmName,
		OT2001.DEscriptionConfirm'
		
Set @sSQL2 =N' 
From OT2001 
LEFT JOIN AT1202 on AT1202.ObjectID = OT2001.ObjectID And AT1202.DivisionID = OT2001.DivisionID
LEFT JOIN OT1101 OV1001  on OV1001.OrderStatus = OT2001.OrderStatus And OV1001.DivisionID = OT2001.DivisionID and OV1001.TypeID = case when OT2001.OrderType <> 1 then ''SO'' else 
						''MO'' end 
LEFT JOIN OT1102 on OT1102.Code = OT2001.IsConfirm  And OT1102.DivisionID = OT2001.DivisionID and  OT1102.TypeID = ''SO'' '
+@sSQLPer + '
Where  OT2001.DivisionID = ''' + @DivisionID + ''' And OT2001.OrderType = 0		
		and OT2001.ObjectID like '''+ @ObjectID+'''
		and (select COUNT(OrderID)  from AT9000 
			where AT9000.DivisionID = OT2001.DivisionID and AT9000.OrderID = OT2001.SOrderID) = 0 --chi cac phieu chua ke thua sang hoa  don  ban hang, PXK
	    and (select COUNT(M.SOrderID)  from OT2001 M inner join OT2002 D on M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID and M.OrderType = 1 
			where D.DivisionID = OT2001.DivisionID and (D.InheritVoucherID = OT2001.SOrderID or D.RefSOrderID = OT2001.SOrderID)
			) = 0 --chi cac phieu chua ke thua sang đơn hàng sản xuất
			' + @sWHEREPer + '
'

EXEC ('SELECT * FROM (' + @sSQL1 + @sSQL2 + @sWhere + @Where1 + ') A ORDER BY OrderDate, VoucherNo')
print @sSQL1
print @sSQL2
print @sWhere
print @Where1