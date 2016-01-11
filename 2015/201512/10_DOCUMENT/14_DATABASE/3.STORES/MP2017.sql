IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP2017]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP2017]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by Hoàng Vũ	Date: 07/07/2015
---Store MP2017 thay thế View MQ2221 và phân bổ sung thêm quyền xem dữ liệu của người
--- Purpose: Load master kế thừa đơn hàng sản xuất từ phiếu giao giao việc
--- Edit by Hoàng Vũ	Date: 05/08/2015; Kiểm tra trường hợp đơn hàng sản xuất đã duyệt hay chấp nhận thì load lên
--- EXEC MP2017 'AS', 'DHSX_BD_01_2014_0005'', ''DHSX_BD_01_2014_0007'', ''DHSX_BD_01_2014_0008', 1,2014,12,2014,'2014-01-01','2014-12-12',0, 'AsoftAdmin'

CREATE PROCEDURE [dbo].[MP2017] 
(
	@DivisionID nvarchar(50),
	@VoucherID nvarchar(50),
	@FromMonth int,
    @FromYear int,
    @ToMonth int,
    @ToYear int,  
    @FromDate as datetime,
    @ToDate as Datetime,
    @IsDate as tinyint, ----0 theo ky, 1 theo ngày
	@UserID nvarchar(50)
)
AS

Declare @sSQL AS varchar(max),
		@DivisionWhere AS VARCHAR(MAX),
		@sWHERE AS VARCHAR(MAX)
			
	
----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS NVARCHAR(MAX),
		@sWHEREPer AS NVARCHAR(MAX)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM MT0000 WHERE DivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = x.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = x.CreateUserID '
		SET @sWHEREPer = ' AND (x.CreateUserID = AT0010.UserID
								OR  x.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		
SET @DivisionWhere = ''
IF @IsDate = 0
	Set  @DivisionWhere = @DivisionWhere + '
		And (x.TranMonth + x.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +  cast(@ToMonth + @ToYear*100 as nvarchar(50))  + ')'
else
	Set  @DivisionWhere = @DivisionWhere + '
		And (x.OrderDate  Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''')'
			
SET @sSQL =' Select Distinct convert(bit,0) as Choose, x.DivisionID, x.SOrderID, x.RefOrderID, x.RefSOrderID, x.VoucherTypeID, x.VoucherNo, x.OrderDate, x.Notes
					, x.ReVoucherNo, x.PeriodID, x.PeriodName, x.ObjectID, x.ObjectName, x.DepartmentID, x.DepartmentName, x.EmployeeID
					, x.EmployeeName, x.InventoryTypeID, x.TranMonth, x.TranYear, x.CreateUserID, x.CreateDate, x.LastModifyUserID, x.LastModifyDate
			  From 
					(Select OT2001.DivisionID,
						OT2001.SOrderID, OT2002.RefOrderID, OT2002.RefSOrderID,
						OT2001.VoucherTypeID, OT2001.VoucherNo, OT2001.OrderDate, OT2001.Notes, OT2001.VoucherNo as ReVoucherNo,
						OT2001.PeriodID, MT1601.Description As PeriodName, 
						OT2001.ObjectID, Case When AT1202.IsUpdateName = 1 Then OT2001.ObjectName Else AT1202.ObjectName End As ObjectName, 
						OT2001.DepartmentID, AT1102.DepartmentName, 
						OT2001.EmployeeID, AT1103.FullName As EmployeeName, 
						OT2001.InventoryTypeID, OT2001.TranMonth, OT2001.TranYear, 
						OT2002.OrderQuantity,
						isnull((Select Sum(isnull(Quantity,0)) From MT2008 Where MT2008.InheritTransactionID = OT2002.TransactionID),0) As InheritedQuantity,
						OT2002.OrderQuantity - isnull((Select Sum(isnull(Quantity,0)) 
													   From MT2008 Where MT2008.InheritTransactionID = OT2002.TransactionID),0) As RemainQuantity,
						OT2001.CreateUserID, OT2001.CreateDate, OT2001.LastModifyUserID, OT2001.LastModifyDate
					From OT2001 
						Inner join OT2002 On OT2001.SOrderID = OT2002.SOrderID and OT2001.DivisionID = OT2002.DivisionID
						Left Join AT1202 On OT2001.ObjectID = AT1202.ObjectID and OT2001.DivisionID = AT1202.DivisionID
						Left Join AT1102 On OT2001.DepartmentID = AT1102.DepartmentID And OT2001.DivisionID = AT1102.DivisionID
						Left Join AT1103 On OT2001.EmployeeID = AT1103.EmployeeID And OT2001.DivisionID = AT1103.DivisionID
						Left Join MT1601 On OT2001.PeriodID = MT1601.PeriodID and OT2001.DivisionID = MT1601.DivisionID

			    WHERE	OT2001.DivisionID = '''+@DivisionID+''' And OT2001.OrderType = 1 and OT2001.OrderStatus = 1 And (MT1601.IsDistribute = 0 or MT1601.IsDistribute is null)

) x ' + 
@sSQLPer+ '
Where x.RemainQuantity>0 '+ @sWHEREPer+
' Order by x.OrderDate, x.VoucherNo
'	

EXEC(@sSQL)
print @sSQL

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
