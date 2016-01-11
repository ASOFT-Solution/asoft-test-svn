
/****** Object:  StoredProcedure [dbo].[OP2305]    Script Date: 12/16/2010 16:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



--VAN HUNG
--Created by: VO THANH HUONG, date: 13/12/2005
--purpose: LAY SO LIEU CHO MAN HINH TRUY VAN DU TRU NVL
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[OP2305]  	@DivisionID nvarchar(50),
					 @FromMonth int,
					 @FromYear int,
					 @ToMonth int,
					 @ToYear int

AS
DECLARE @sSQL nvarchar(4000)


Set @sSQL = '
Select  OT2201.EstimateID, 
		OT2201.DivisionID, 
		OT2201.TranMonth, 
		OT2201.TranYear, 
		OT2201.VoucherTypeID, 
		OT2201.VoucherNo, 
		OT2201.VoucherDate, 
		OT2201.Status, 
		OT2201.SOrderID, 
		OT2201.ApportionType, 
		OT2201.DepartmentID, 
		OT2201.EmployeeID, 	
		OT2201.InventoryTypeID, 
		OT2201.Description, 
		OT2201.CreateUserID, 
		OT2201.CreateDate, 
		OT2201.LastModifyUserID, 
		OT2201.LastModifyDate, 
		OT2201.WareHouseID, 
		OT2201.OrderStatus, 
		OT2201.IsPicking, 
		OT2201.FileType, 
		cast(OT2201.OrderStatus as nvarchar(50)) + ''-'' +  OV1001.Description  as OrderStatusName

From OT2201 left join OV1001 on OV1001.TypeID = ''ES'' and OV1001.OrderStatus = OT2201.OrderStatus  	
Where OT2201.DivisionID = ''' + @DivisionID + ''' and 
	TranMonth + TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' + 
	cast(@ToMonth + @ToYear*100 as nvarchar(50)) 
print @sSQL
IF not exists (Select Top 1 1 From sysObjects Where XType ='V' and Name = 'OV2305')
	EXEC('Create view OV2305 --tao boi OP2305
			as ' + @sSQL)
ELSE 
	EXEC('Alter  view OV2305 --tao boi OP2305
			as ' + @sSQL)

Set @sSQL = '
Select 		OT2203.TransactionID, 
		OT2203.EstimateID, 
		OT2203.EDetailID, 
		OT2203.DivisionID, 
		OT2203.TranMonth, 
		OT2203.TranYear, 
		OT2201.VoucherTypeID, 
		OT2201.VoucherNo, 
		OT2201.VoucherDate, 
		OT2201.Status, 
		OT2201.SOrderID, 
		OT2201.DepartmentID, 
		AT1102.DepartmentName,
		OT2201.EmployeeID, 
		AT1103.FullName,
		OT2201.InventoryTypeID, 
		OT2201.Description, 
		OT2201.CreateUserID, 
		OT2201.CreateDate, 
		OT2201.LastModifyUserID, 
		OT2201.LastModifyDate, 
		OT2201.WareHouseID as WareHouseID1, 
		OT2201.OrderStatus, 
		OV1001.Description as OrderStatusName,
		OT2201.FileType,
		
		OT2202.ProductID, 
		AT1302.InventoryName as ProductName,
		OT2202.ProductQuantity,
		OT2202.Orders as POrders,  
		OT2202.UnitID as PUnitID,		
		OT2203.MaterialID, 
		AT1302_M.InventoryName as MaterialName,
		OT2203.MaterialQuantity, 
		0 as StockQuantity,
		OT2203.MDescription, 
		OT2203.Orders, 
		OT2203.WareHouseID, 
		OT2203.IsPicking, 		
		OT2203.UnitID as MUnitID, 
		OT2203.Num01,
		OT2203.Num02,
		AT1302_M.I01ID, AT1302_M.I02ID,
		AT1302_M.S1, AT1302_M.S2, AT1302_M.S3
From OT2203 inner join OT2201 on OT2201.EstimateID = OT2203.EstimateID
		inner join OT2202 on OT2202.EDetailID = OT2203.EDetailID
		inner join AT1302 on AT1302.InventoryID = OT2202.ProductID 
		inner join AT1302 AT1302_M on AT1302_M.InventoryID = OT2203.MaterialID
		left join OV1001 on OV1001.TypeID = ''MO'' and  OV1001.OrderStatus = OT2201.OrderStatus
		left join AT1103 on AT1103.EmployeeID = 	OT2201.EmployeeID
		left join AT1102 on AT1102.DivisionID = OT2201.DivisionID and AT1102.DepartmentID = OT2201.DepartmentID 
Where OT2203.DivisionID = ''' + @DivisionID + ''' and 
		OT2203.TranMonth + OT2203.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +
		cast(@ToMonth + @ToYear*100 as nvarchar(50)) 	


IF not exists (Select Top 1 1 From sysObjects Where XType ='V' and Name = 'OV2315')
	EXEC('Create view OV2315 --tao boi OP2305
			as ' + @sSQL)
ELSE 
	EXEC('Alter  view OV2315 --tao boi OP2305
			as ' + @sSQL)