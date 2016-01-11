
/****** Object:  StoredProcedure [dbo].[OP2307]    Script Date: 12/16/2010 13:30:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




---Created by: Vo Thanh Huong, date: 28/12/2005
---purpose:  IN BAO CAO DU TRU NGUYEN VAN LIEU BAO BI IN
---Edit by : Nguyen Quoc Huy
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[OP2307]  	@DivisionID nvarchar(50)
					

AS
DECLARE @sSQL nvarchar(4000)

Set  @sSQL = '
Select  OT2201.DivisionID,
		OT2201.VoucherTypeID,
		OT2201.VoucherNo,
		OT2201.VoucherDate,
		OT2201.SOrderID,
		OT2201.EstimateID,
		OT2201.Description as TDescription,
		OT2201.EmployeeID,
		AT1103.FullName,	
		OT2201.DepartmentID,
		AT1102.DepartmentName,
		OT2202.ProductID,
		OT2202.PDescription,
		AT1302.InventoryName as ProductName,
		OT2202.UnitID as PUnitID, 	
		OT2002.OrderQuantity as SOrderQuantity,
		OT2202.ProductQuantity,
		OT2203.MaterialID,
		AT1302_M.InventoryName as MaterialName,
		AT1302_M.S1,
		AT1302_M.S2,
		AT1302_M.S3,
		OT2203.MaterialQuantity, 
		OT2203.MDescription,
		OT2203.Orders, 
		OT2203.WareHouseID,
		OT2203.UnitID as MUnitID,
		OT2203.Num01,--Ton kho
		OT2203.Num02 --So luong bu hao,
		
From OT2203 inner join OT2202 on OT2203.EDetailID = OT2202.EDetailID 
		inner join OT2201 on OT2201.EstimateID = OT2202.EstimateID
		inner join AT1302 on AT1302.InventoryID = OT2202.ProductID
		inner join AT1302 AT1302_M on AT1302_M.InventoryID = OT2203.MaterialID
		left join OT2002 on OT2002.SOrderID = OT2201.SOrderID and OT2202.ProductID = OT2002.InventoryID
		left join AT1103 on OT2201.EmployeeID = AT1103.EmployeeID and AT1103.DivisionID = ''' + @DivisionID + '''
		left join AT1102 on AT1102.DepartmentID = OT2201.DepartmentID  and AT1102.DivisionID = ''' + @DivisionID + '''
Where OT2201.DivisionID = ''' + @DivisionID + ''''


If not exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2307' )
	EXEC('Create view OV2307  ---tao boi OP2307
			as ' + @sSQL)
ELSE
	EXEC('Alter view OV2307  ---tao boi OP2307
			as ' + @sSQL)