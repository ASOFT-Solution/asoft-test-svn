IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP2010]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP2010]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Hiển thị danh sách phiếu giao việc
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create by Hoàng Vũ : 12/02/2015
---- 
-- <Example>
---- 
--- EXEC MP2010 'AS','2',2014,2,2014,'2014/02/01','2014/02/28',0,'%','%','%','%','((''''))', '((0 = 0))','((''''))', '((0 = 0))','NV000'
CREATE PROCEDURE [dbo].[MP2010] 
(
	@DivisionID nvarchar(50),
	@FromMonth int,
    @FromYear int,
    @ToMonth int,
    @ToYear int,  
    @FromDate as datetime,
    @ToDate as Datetime,
    @IsDate as tinyint, ----0 theo ky, 1 theo ngày
	@ObjectID AS NVARCHAR(50) = '',
	@LaborID AS NVARCHAR(50) = '',
	@OrderID AS NVARCHAR(50) = '',
	@ProductID AS NVARCHAR(50) = '',
	@ConditionVT nvarchar(max),
	@IsUsedConditionVT nvarchar(20),
	@ConditionOB nvarchar(max),
	@IsUsedConditionOB nvarchar(20),
	@UserID AS VARCHAR(50) = ''
	
)
AS

Declare @sSQL1 AS varchar(max),
		@sSQL2 AS varchar(max),
		
		@DivisionWhere AS VARCHAR(MAX),
		@sWHERE AS VARCHAR(MAX)
	
----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS NVARCHAR(MAX),
		@sWHEREPer AS NVARCHAR(MAX)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM MT0000 WHERE DivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = MT2007.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = MT2007.CreateUserID '
		SET @sWHEREPer = ' AND (MT2007.CreateUserID = AT0010.UserID
								OR  MT2007.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		
			
SET @sWHERE = ''

IF @ObjectID IS NOT NULL AND @ObjectID <> '' AND @ObjectID <> '%'
BEGIN
	SET @sWHERE = @sWHERE + N'	AND MT2007.ObjectID = '''+@ObjectID+'''	'
END


IF @OrderID IS NOT NULL AND @OrderID <> '' AND @OrderID <> '%'
BEGIN
	SET @sWHERE = @sWHERE + N'	AND S.SOrderID = '''+@OrderID+'''	'
END

IF @ProductID IS NOT NULL AND @ProductID <> '' AND @ProductID <> '%'
BEGIN
	SET @sWHERE = @sWHERE + N'	AND P.SOrderID = '''+@ProductID+'''	'
END


IF @LaborID IS NOT NULL AND @LaborID <> '' AND @LaborID <> '%'
BEGIN
	SET @sWHERE = @sWHERE + N'	AND MT2007.LaborID = '''+@LaborID+'''	'
END

SET @DivisionWhere = ' WHERE	MT2007.DivisionID = ''' + @DivisionID + ''' '

IF @IsDate = 0
	Set  @DivisionWhere = @DivisionWhere + '
		And (MT2007.TranMonth + MT2007.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +  cast(@ToMonth + @ToYear*100 as nvarchar(50))  + ')'
else
	Set  @DivisionWhere = @DivisionWhere + '
		And (MT2007.VoucherDate  Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''')'

SET @sSQL1 ='SELECT	DISTINCT MT2007.DivisionID
				, MT2007.VoucherID, MT2007.TranMonth, MT2007.TranYear
				, MT2007.VoucherTypeID, MT2007.VoucherDate, MT2007.VoucherNo, MT2007.RefNo01
				, MT2007.RefNo02, MT2007.RefNo03, MT2007.RefNo04, MT2007.RefNo05
				, MT2007.ObjectID, AT1202.ObjectName
				, MT2007.LaborID, A03.FullName as LaborName
				, MT2007.EmployeeID, AT1103.Fullname as EmployeeName
				, MT2007.InventoryTypeID, (Case When MT2007.InventoryTypeID = ''%'' then N''All'' else AT1301.InventoryTypeName end) as InventoryTypeName
				, MT2007.Description, MT2007.OrderStatus, MT2007.SOrderID
				, MT2007.CreateUserID, (Case When MT2007.CreateUserID = ''ASOFTADMIN'' Then N''ASOFTADMIN'' Else A01.FullName end ) as CreateUserName
				, MT2007.LastModifyUserID, (Case When MT2007.CreateUserID = ''ASOFTADMIN'' Then N''ASOFTADMIN'' Else A02.FullName end) as LastModifyUserName
				, MT2007.LastModifyDate, MT2007.CreateDate
				, S.SVoucherNo, PVoucherNo
			 From MT2007 INNER JOIN MT2008 ON MT2007.DivisionID = MT2008.DivisionID and MT2007.VoucherID = MT2008.VoucherID
						 LEFT JOIN AT1202 ON MT2007.DivisionID = AT1202.DivisionID AND AT1202.ObjectID = MT2007.ObjectID 
						 LEFT JOIN AT1103 A03 ON A03.DivisionID = MT2007.DivisionID AND A03.EmployeeID = MT2007.LaborID 
						 LEFT JOIN AT1103 ON AT1103.DivisionID = MT2007.DivisionID AND AT1103.EmployeeID = MT2007.EmployeeID 
						 LEFT JOIN AT1103 A02 ON A02.DivisionID = MT2007.DivisionID AND A02.EmployeeID = MT2007.LastModifyUserID 
						 LEFT JOIN AT1103 A01 ON A01.DivisionID = MT2007.DivisionID AND A01.EmployeeID = MT2007.CreateUserID 
						 LEFT JOIN AT1301 ON AT1301.DivisionID = MT2007.DivisionID AND AT1301.InventoryTypeID = MT2007.InventoryTypeID 
						 --Lấy đơn hàng sản xuất
						 LEFT JOIN ( Select OT2001.DivisionID, 
											OT2001.SOrderID, 
											OT2002.TransactionID, 
											OT2001.VoucherNo as PVoucherNo,
											OT2002.RefSOrderID,
											OT2002.RefSTransactionID
									 From OT2001 INNER JOIN OT2002 
									 ON OT2001.DivisionID = OT2002.DivisionID and OT2001.SOrderID = OT2002.SOrderID and OT2001.OrderType = 1
								   ) P on P.DivisionID = MT2008.DivisionID and P.SOrderID = MT2008.InheritVoucherID and P.TransactionID = MT2008.InheritTransactionID 
						  -- Lấy đơn hàng bán
						  LEFT JOIN ( Select OT2001.DivisionID, 
											OT2001.SOrderID, 
											OT2001.VoucherNo as SVoucherNo
									 From OT2001 
									 Where OT2001.OrderType = 0
								   ) S on S.DivisionID = P.DivisionID and P.RefSOrderID = S.SOrderID '
	
SET @sSQL2 =  @sSQL1 + ' ' + @sSQLPer + ' ' + @DivisionWhere + ' ' + @sWHEREPer + ' ' + @sWHERE + 
				' AND (ISNULL(MT2007.ObjectID, ''#'') IN (' + @ConditionOB + ') Or ' + @IsUsedConditionOB + ') 
				AND (ISNULL(MT2007.VoucherTypeID, ''#'') IN (' + @ConditionVT + ') Or ' + @IsUsedConditionVT + ')'
				+ ' Order by MT2007.VoucherDate, MT2007.VoucherNo'

EXEC(@sSQL2)
Print @sSQL2

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON