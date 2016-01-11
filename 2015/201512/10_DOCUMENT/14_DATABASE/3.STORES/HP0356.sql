IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0356]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0356]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by Hoàng Vũ	Date: 07/07/2015
---Store MP2017 thay thế View MQ2221 và phân bổ sung thêm quyền xem dữ liệu của người
--- Purpose: Load Detail kế thừa đơn hàng sản xuất từ phiếu giao giao việc
--- EXEC HP0356 'AS', 'MP2dd82d64-8bd7-479c-b1e7-50456db257e2'',''MP5cb92ac1-1565-439f-9120-8443019d3071'',''MP662362af-501c-4c32-b94f-c267bc7f2754', ''

CREATE PROCEDURE [dbo].[HP0356] 
(
	@DivisionID nvarchar(50),
	@VoucherID nvarchar(Max),
	@UserID nvarchar(50)
	
)
AS

Declare @sSQL01 AS varchar(max),
		@sSQL02 AS varchar(max),
		@sWHERE AS VARCHAR(MAX)
				
SET @sSQL01 =' Select Distinct convert(bit,0) as Choose, x.DivisionID, x.VoucherID, x.TransactionID, x.IsPhase, x.IsJob, x.IsResult
					, x.TranMonth, x.TranYear, x.VoucherTypeID, x.VoucherNo, x.VoucherDate
					, x.ObjectID, AT1202.ObjectName
					, x.DepartmentID, AT1102.DepartmentName
					, x.TeamID, HT1101.TeamName
					, x.EmployeeID, AT1103.FullName as EmployeeName
					, x.HRMEmployeeID, HT1400.LastName+ '' ''+ HT1400.MiddleName+'' ''+HT1400.FirstName as HRMEmployeeName
					, x.WareHouseID, AT1303.WareHouseName
					, x.ProductID as InventoryID, AT1302.InventoryName, x.UnitID, x.ExtraID, AT1311.ExtraName
					, x.Quantity, x.InheritedQuantity, x.RemainQuantity
					, x.Description
					, x.Note, x.Orders, x.Ana01ID, x.Ana02ID, x.Ana03ID, x.Ana04ID, x.Ana05ID
					, x.Ana06ID, x.Ana07ID, x.Ana08ID, x.Ana09ID, x.Ana10ID
					, x.CreateDate, x.CreateUserID, x.LastModifyUserID, x.LastModifyDate
					From 
							(Select M.DivisionID, M.VoucherID, M.TranMonth, M.TranYear, M.IsPhase, M.IsJob, M.IsResult
									, M.VoucherNo, M.VoucherDate, M.DepartmentID, M.TeamID
									, M.EmployeeID, M.KCSEmployeeID, D.HRMEmployeeID
									, M.Description, M.VoucherTypeID, ExtraID
									, M.WareHouseID, M.ObjectID, M.CreateDate, M.CreateUserID, M.LastModifyUserID, M.LastModifyDate
									, D.TransactionID, D.InventoryID, D.ProductID, D.UnitID
									, D.Quantity
									, isnull((Select Sum(isnull(Quantity,0)) From HT0287 Where HT0287.InheritTransactionID = D.TransactionID),0) 
									As InheritedQuantity
									, D.Quantity - isnull((Select Sum(isnull(Quantity,0)) From HT0287 
															Where HT0287.InheritTransactionID = D.TransactionID),0) As RemainQuantity
									, D.Note, D.Orders, D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID
									, D.Ana06ID, D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID'

SET @sSQL02 =' 		From MT0810 M inner join MT1001 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
							) x left join AT1103 on x.DivisionID = AT1103.DivisionID and x.EmployeeID = AT1103.EmployeeID
								left join HT1400 on x.DivisionID = HT1400.DivisionID and x.HRMEmployeeID = HT1400.EmployeeID
								Left join AT1303 on x.DivisionID = AT1303.DivisionID and x.WareHouseID = AT1303.WareHouseID
								Left join AT1102 on x.DivisionID = AT1102.DivisionID and x.DepartmentID = AT1102.DepartmentID
								Left join AT1202 on x.DivisionID = AT1202.DivisionID and x.ObjectID = AT1202.ObjectID
								Left join HT1101 on x.DivisionID = HT1101.DivisionID and x.TeamID = HT1101.TeamID
								Left join AT1311 on x.DivisionID = AT1311.DivisionID and x.ExtraID = AT1311.ExtraID
								Left join AT1302 on x.DivisionID = AT1302.DivisionID and x.ProductID = AT1302.InventoryID
								
					Where x.RemainQuantity>0 and x.VoucherID in ('''+ @VoucherID+''') and x.DivisionID = '''+ @DivisionID+'''
					 Order by x.VoucherDate, x.VoucherNo, x.Orders'		

EXEC(@sSQL01+@sSQL02)
print @sSQL01
print @sSQL02



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
