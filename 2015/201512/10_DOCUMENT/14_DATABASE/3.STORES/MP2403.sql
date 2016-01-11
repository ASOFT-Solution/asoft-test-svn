/****** Object:  StoredProcedure [dbo].[MP2403]    Script Date: 08/02/2010 10:09:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 25/11/2004
---purpose: In cac thanh pham du toan 

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP2403]  @DivisionID nvarchar(50),
				@EstimateID nvarchar(50)
AS
Declare @sSQL nvarchar(4000) 

Set @sSQL =
'Select VoucherNo, VoucherDate,  InheritType, SOrderID, PlanID, ApportionType,
	T01.DepartmentID, DepartmentName, T01.EmployeeID, FullName, 
	ApportionID, Description, PDescription,  LinkNo, T00.Orders, 
	ProductID, InventoryName as ProductName, UnitName, ProductQuantity,
	T00.DivisionID
From MT2102 T00 inner join MT2101 T01 on T00.EstimateID = T01.EstimateID and T00.DivisionID = T01.DivisionID
	inner join AT1302 T02 on T02.InventoryID = T00.ProductID and T00.DivisionID = T02.DivisionID
	inner join AT1304 T03 on T03.UnitID = T02.UnitID and T03.DivisionID = T02.DivisionID
	left join AT1102 T04 on T04.DepartmentID = T01.DepartmentID  and T04.DivisionID = T01.DivisionID
	left join AT1103 T05 on T05.EmployeeID = T01.EmployeeID and T05.DivisionID = T01.DivisionID
Where T01.DivisionID = ''' + @DivisionID + ''' and 
	T00.EstimateID = ''' + @EstimateID + '''' 

If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV2404')
	Drop view MV2404
EXEC('Create view MV2404 ---tao boi MP2403
		as ' + @sSQL)