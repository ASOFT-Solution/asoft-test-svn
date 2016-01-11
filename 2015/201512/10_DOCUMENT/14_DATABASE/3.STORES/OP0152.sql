IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0152]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0152]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load dữ liệu Master màn hình truy vấn OF0138- Duyệt đơn hàng bán lần 2 [Customize LAVO]
-- <History>
---- Create on 05/12/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
OP0152 @DivisionID = 'CTY', @OrderStatus = NULL, @ObjectID = '%', @VoucherTypeID ='%', @IsDate = 0, @IsPrinted=0,
@FromDate='2014-12-05 00:00:00',@ToDate='2014-12-05 00:00:00',@FromMonth=11,@FromYear=2014,@ToMonth=11,@ToYear=2014,
@ConditionVT=N'('''')',@IsUsedConditionVT=N' (0=0) ',@ConditionOB=N'('''')',@IsUsedConditionOB=N' (0=0)'
 */

CREATE PROCEDURE [dbo].[OP0152]  
		@DivisionID NVARCHAR(50),
		@FromDate DATETIME,
		@ToDate DATETIME,
		@FromMonth INT,
		@FromYear INT,
		@ToMonth INT,
		@ToYear INT,
		@IsDate TINYINT, -- = 1: Theo ngày, = 0: Theo kỳ
		@IsPrinted TINYINT, -- = 0: Chưa in, =1: Đã in, Null: Tất cả
		@OrderStatus TINYINT, -- Tình trạng đơn hàng
		@ObjectID NVARCHAR(50),
		@VoucherTypeID NVARCHAR(50), 
		@ConditionVT NVARCHAR(MAX), -- phân quyền chứng từ
		@IsUsedConditionVT NVARCHAR(50),
		@ConditionOB NVARCHAR(MAX), -- phân quyền đối tượng
		@IsUsedConditionOB NVARCHAR(50)
 AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sSQL2 NVARCHAR(MAX),
		@sSQL3 NVARCHAR(MAX),
		@sWhere NVARCHAR(MAX),
		@Where1 NVARCHAR(MAX)

SET @sWhere = ''
	IF @IsPrinted IS NOT NULL
	SET @sWhere = @sWhere + ' 
	AND ISNULL(OT21.IsPrinted,0) = '+LTRIM(@IsPrinted)+' '
	IF @ObjectID IS NOT NULL AND @ObjectID != ''
	SET @sWhere = @sWhere + ' 
	AND ISNULL(OT21.ObjectID,'''') LIKE '''+@ObjectID+''' '
	IF @OrderStatus IS NOT NULL
	SET @sWhere = @sWhere + ' 
	AND OT21.OrderStatus = '+LTRIM(@OrderStatus)+' '
	IF @VoucherTypeID IS NOT NULL AND @VoucherTypeID != ''
	SET @sWhere = @sWhere + ' 
	AND OT21.VoucherTypeID LIKE '''+@ObjectID+''' '
	IF LTRIM(@IsDate) = 1	SET @sWHERE = @sWHERE + '
	AND CONVERT(VARCHAR(10),OT21.OrderDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
	IF LTRIM(@IsDate) = 0	SET @sWHERE = @sWHERE + '
	AND (OT21.TranYear*12 + OT21.TranMonth) BETWEEN '+LTRIM((@FromYear*12 + @FromMonth))+' AND '+LTRIM((@ToYear*12 + @ToMonth))+' '
SET @sWhere = @sWhere +	'
	AND (ISNULL(OT21.ObjectID, ''#'') IN ('+@ConditionOB+') OR '+@IsUsedConditionOB+') 
	AND (ISNULL(OT21.VoucherTypeID, ''#'') IN ('+@ConditionVT+') OR '+@IsUsedConditionVT+') '


Set @sSQL1 =N'
SELECT OT21.SOrderID, ISNULL(OT21.IsConfirm01,0) AS IsConfirm01,
       CASE WHEN ISNULL(OT21.IsConfirm01,0) = 0 THEN N''Chưa chấp nhận''
			WHEN ISNULL(OT21.IsConfirm01,0) = 1 THEN N''Xác nhận''
		    WHEN ISNULL(OT21.IsConfirm01,0) = 2 THEN N''Từ chối''
		    END AS IsConfirm01Name, 
       OT21.ConfDescription01, ISNULL(OT21.IsConfirm02,0) AS IsConfirm02,
       CASE WHEN ISNULL(OT21.IsConfirm02,0) = 0 THEN N''Chưa chấp nhận''
			WHEN ISNULL(OT21.IsConfirm02,0) = 1 THEN N''Xác nhận''
		    WHEN ISNULL(OT21.IsConfirm02,0) = 2 THEN N''Từ chối''
		    END AS IsConfirm02Name,
       OT21.ConfDescription02, OT21.VoucherNo, OT21.OrderDate, ISNULL(OT21.ImpactLevel,0) AS ImpactLevel, 
	   CASE WHEN ISNULL(OT21.ImpactLevel,0) = 0 THEN N''Bình thường''
		    WHEN ISNULL(OT21.ImpactLevel,0) = 1 THEN N''Khẩn 1''
		    WHEN ISNULL(OT21.ImpactLevel,0) = 2 THEN N''Khẩn 2''
		    WHEN ISNULL(OT21.ImpactLevel,0) = 3 THEN N''Khẩn 3''
		    END AS ImpactLevelName,
	   OT21.OrderStatus, OV11.[Description] AS OrderStatusName, OV11.EDescription AS EOrderStatusName,
	   OT21.ObjectID, ISNULL(OT21.ObjectName,AT02.ObjectName) AS ObjectName,	   
       OT21.DeliveryAddress, OT21.CurrencyID, OT21.ExchangeRate, OT21.InventoryTypeID, OT21.IsInherit,
	   OT21.Ana01ID, 
	   OT21.Ana02ID, 
	   OT21.Ana03ID, 
	   OT21.Ana04ID, 
	   OT21.Ana05ID, 
	   '''' AS Ana01Name,
	   '''' AS Ana02Name,
	   '''' AS Ana03Name,
	   '''' AS Ana04Name,
	   '''' AS Ana05Name 
FROM OT2001 OT21
LEFT JOIN AT1202 AT02 ON AT02.DivisionID = OT21.DivisionID AND AT02.ObjectID = OT21.ObjectID
LEFT JOIN OV1001 OV11 ON OV11.DivisionID = OT21.DivisionID AND OV11.OrderStatus = OT21.OrderStatus AND OV11.TypeID = ''SO''
WHERE OT21.DivisionID = '''+@DivisionID+''' AND OT21.OrderType = 0 AND ISNULL(OT21.IsConfirm01,0) = 1
	  -- Chỉ các phiếu chưa kế thừa sang hoá đơn bán hàng
	--AND (SELECT COUNT(AT90.OrderID) FROM AT9000 AT90 WHERE AT90.DivisionID = OT21.DivisionID AND AT90.OrderID = OT21.SOrderID) = 0
'+@sWhere+'
ORDER BY OT21.ImpactLevel DESC, OT21.SOrderID, OT21.VoucherNo, OT21.OrderDate 
'
EXEC (@sSQL1)
PRINT (@sSQL1)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON