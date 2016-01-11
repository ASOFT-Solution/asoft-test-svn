/****** Object:  StoredProcedure [dbo].[MP2404]    Script Date: 08/02/2010 10:11:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong, date 25/11/2004
---purpose: In ket qua du toan

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP2404] @DivisionID nvarchar(50),				
				@EstimateID nvarchar(50),
				@IsDetail tinyint
AS
DECLARE @sSQL nvarchar(4000)

Set @sSQL =  
'Select T00.EDetailID, VoucherNo, VoucherDate,  SOrderID,  ApportionType,
	T01.DepartmentID, DepartmentName, T01.EmployeeID, FullName, 
	ApportionID, Description, PDescription ,  LinkNo,  T00.Orders, 
	'''' as  InventoryID , '''' as  InventoryName , '''' as  InventoryUnitName, 0 as InventoryQuantity ,
	T00.ProductID , InventoryName as ProductName, UnitName as  ProductUnitName, ProductQuantity ,
	1 as Parts, T00.DivisionID
From MT2102 T00 inner join MT2101 T01 on T00.EstimateID = T01.EstimateID And T00.DivisionID = T01.DivisionID
	inner join AT1302 T02 on T02.InventoryID = T00.ProductID And T02.DivisionID = T00.DivisionID
	inner join AT1304 T03 on T03.UnitID = T02.UnitID And T03.DivisionID = T02.DivisionID
	left join AT1102 T04 on T04.DepartmentID = T01.DepartmentID and T04.DivisionID = T01.DivisionID
	left join AT1103 T05 on T05.EmployeeID = T01.EmployeeID And T05.DivisionID = T01.DivisionID
Where T01.DivisionID = ''' + @DivisionID + ''' and 
	T00.EstimateID = ''' + @EstimateID + '''
Union
Select '''' as EDetailID,  '''' as VoucherNo, '''' as VoucherDate,  '''' as SOrderID,  '''' as ApportionType,
	'''' as DepartmentID, '''' as DepartmentName, '''' as EmployeeID, '''' as FullName, '''' as ApportionID, 
	'''' as Description, ''''  PDescription,  '''' as LinkNo, 0 as Orders,
	'''' as  InventoryID, '''' as  InventoryName, '''' as  InventoryUnitName, 0 as InventoryQuantity ,
	'''' as ProductID , '''' as ProductName, '''' as ProductUnitName, 0 as ProductQuantity ,
	2 as Parts, ''' + @DivisionID+ ''' as DivisionID
Union '

Set @sSQL = 
@sSQL +  case when @IsDetail = 1 then  'Select T00.EDetailID, VoucherNo, VoucherDate, SOrderID,  ApportionType,
	T01.DepartmentID, DepartmentName, T01.EmployeeID, FullName, '''' as ApportionID, 
	Description, MDescription as PDescription, '''' as  LinkNo, T00.Orders, 
	MaterialID  as InventoryID, InventoryName,  UnitName as InventoryUnitName, MaterialQuantity as InventoryQuantity,  
	T06.ProductID , '''' as ProductName, '''' as ProductUnitName, 0 as ProductQuantity ,	3 as Parts
	,T00.DivisionID
From MT2103 T00 inner join MT2101 T01 on T00.EstimateID = T01.EstimateID And T00.DivisionID = T01.DivisionID
	inner join AT1302 T02 on T02.InventoryID = T00.MaterialID And T02.DivisionID = T00.DivisionID
	inner join AT1304 T03 on T03.UnitID = T02.UnitID And T03.DivisionID = T02.DivisionID
	left join AT1102 T04 on T04.DepartmentID = T01.DepartmentID  and T04.DivisionID = T01.DivisionID
	left join AT1103 T05 on T05.EmployeeID = T01.EmployeeID And T05.DivisionID = T01.DivisionID
	inner join MT2102 T06 on T06.EDetailID = T00.EDetailID And T06.DivisionID = T00.DivisionID
Where 		T01.DivisionID = ''' + @DivisionID + ''' and
	T01.EstimateID = ''' + @EstimateID + ''''
else 
'Select  '''' as  EDetailID, VoucherNo, VoucherDate, SOrderID,  ApportionType,
	T01.DepartmentID, DepartmentName, T01.EmployeeID, FullName, '''' as ApportionID, 
	Description, MDescription as PDescription, '''' as  LinkNo, 0 as Orders, 
	MaterialID as InventoryID, InventoryName ,  UnitName as InventoryUnitName, sum(isnull(MaterialQuantity, 0)) as InventoryQuantity,
	'''' as ProductID , '''' as ProductName, '''' as ProductUnitName, 0 as ProductQuantity ,
	3 as Parts,
	T00.DivisionID
From MT2103 T00 inner join MT2101 T01 on T00.EstimateID = T01.EstimateID And T00.DivisionID = T01.DivisionID
	inner join AT1302 T02 on T02.InventoryID = T00.MaterialID And T02.DivisionID = T00.DivisionID
	inner join AT1304 T03 on T03.UnitID = T02.UnitID And T03.DivisionID = T02.DivisionID
	left join AT1102 T04 on T04.DepartmentID = T01.DepartmentID  and T04.DivisionID = T01.DivisionID	
	left join AT1103 T05 on T05.EmployeeID = T01.EmployeeID And T05.DivisionID = T01.DivisionID
Where 		T01.DivisionID = ''' + @DivisionID + ''' and
	T01.EstimateID = ''' + @EstimateID + '''
Group by   VoucherNo, VoucherDate, SOrderID,  ApportionType,
	T01.DepartmentID, DepartmentName, T01.EmployeeID, FullName,
	Description, MDescription , 
	MaterialID , InventoryName,  UnitName, T00.DivisionID'	
end

If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV2406')
	Drop view MV2406
EXEC('Create view MV2406 --tao boi MP2404
		as  ' + @sSQL)