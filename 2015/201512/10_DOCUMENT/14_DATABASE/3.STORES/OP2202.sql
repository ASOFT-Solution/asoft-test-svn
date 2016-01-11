
/****** Object:  StoredProcedure [dbo].[OP2202]    Script Date: 12/16/2010 11:40:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




---Createdby: Vo Thanh Huong, date: 28/12/2004
---purpose: Tinh du tru nguyen vat lieu
---Date: Thuy Tuyen, 10/11/2009. Thêm  truong ObjectID, periodID
-- Edit: Tuyen, date : 18/11/2009. them truong Orderstatus
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP2202]  @DivisionID nvarchar(50),
				@ApportionType int, --0 - Dinh muc nguyen vat lieu Asoft-M, 1- Dinh muc ton kho Asoft-T, 2- Khong su dung dinh muc
				@EstimateID nvarchar(50)
AS
DECLARE @sSQL nvarchar(max),
	@cur cursor,
	@ProductID nvarchar(50),
	@ApportionID nvarchar(50),
	@ProductQuantity decimal (28,8),
	@WareHouseID nvarchar(50),
	@sWhere nvarchar(4000),
	@Is621 tinyint,
	@Is622 tinyint,
	@Is627 tinyint 

Select @WareHouseID = WareHouseID From OT2201  Where DivisionID = @DivisionID and EstimateID = @EstimateID

Set @sSQL = 'Select DivisionID, EDetailID, ProductID, Orders as POrders,  ApportionID,  ProductQuantity, SOrderID, MOrderID, EstimateID
From OT2202
Where DivisionID = ''' + @DivisionID + ''' and EstimateID = ''' + @EstimateID + ''''

If exists (Select Top 1 1 From sysObjects  Where XType = 'V' and Name = 'OV2203')
	Drop view OV2203
EXEC('Create view OV2203   ---tao boi OP2202
		as ' + @sSQL)

If  @ApportionType = 0   ---DINH MUC M
Begin
Select @Is621 = isnull(Is621,0), @Is622 = isnull(Is622, 0), @Is627 = isnull(Is627,0)  From OT0001 Where TypeID= 'ES'
Select @Is621= isnull(@Is621,0), @Is622 = isnull(@Is622, 0), @Is627 = isnull(@Is627,0)

If @Is621 = 0 and @Is622 = 0 and @Is627 = 0
	Set @sWhere = ''
ELSE
	BEGIN
	Set @sWhere = '  and  T00.ExpenseID  in (' + case when @Is621 = 1 then  '''COST001'','  else '' end + 
			case when @Is622 = 1 then '''COST002'',' else '' end +
			case when @Is627 = 1 then '''COST003'',' else '' end 
	Set @sWhere  =  left(@sWhere, len(@sWhere) - 1) + ')'
	END	
				
Set @sSQL = '
Select ''' + @DivisionID + ''' as DivisionID, ''' + @EstimateID  + ''' as EstimateID, 
	OV2203.EDetailID, T00.MaterialID, OT2201.TranMonth, OT2201.TranYear,  OT2201.ObjectID,AT1202.ObjectName, OT2201.PeriodID,
	AT1302.InventoryName as MaterialName, T00.MaterialUnitID as UnitID, '''' as MDescripton, 
	OV2203.ProductID, 
	OV2203.ProductQuantity,
	isnull(T00.QuantityUnit,0)	* OV2203.ProductQuantity as MaterialQuantity,
	isnull(T00.ConvertedUnit,0) * OV2203.ProductQuantity as ConvertedAmount, 
	isnull(T00.ConvertedUnit,0) as ConvertedUnit,
	isnull(T00.QuantityUnit,0) as QuantityUnit,
	isnull(T00.MaterialPrice,0) as MaterialPrice,	
	T00.ExpenseID, 
	T00.MaterialTypeID,  
	MT0699.UserName as MaterialTypeName,
	''' + isnull(@WareHouseID, '') + ''' as WareHouseID,
	CASE WHEN  ''' + Isnull(@WareHouseID, '') + '''  = ''''  THEN 0 else 1 end as IsPicking, 
	POrders , OT2201.OrderStatus
From MT1603 T00  inner join MT1602   on T00.ApportionID = MT1602.ApportionID And T00.DivisionID = MT1602.DivisionID
	inner join OV2203  on OV2203.ApportionID = T00.ApportionID and  T00.ProductID = OV2203.ProductID And T00.DivisionID = OV2203.DivisionID
	left  join AT1302  on AT1302.InventoryID = T00.MaterialID And AT1302.DivisionID = T00.DivisionID
	inner join OT2201  on OT2201.EstimateID = ''' + @EstimateID + ''' and OT2201.DivisionID = ''' + @DivisionID + ''' And T00.DivisionID = OT2201.DivisionID
	left join MT0699 on MT0699.MaterialTypeID = T00.MaterialTypeID And MT0699.DivisionID = T00.DivisionID
	Left join AT1202 on AT1202.ObjectID = OT2201.ObjectID And AT1202.DivisionID = OT2201.DivisionID
Where isnull(T00.ConvertedUnit,0) + isnull(T00.QuantityUnit,0) > 0  ' + 
	@sWhere  

End
Else IF @ApportionType = 1 --DINH MUC T
Set @sSQL = '
Select  ''' + @DivisionID + ''' as DivisionID, ''' + @EstimateID  + ''' as EstimateID, EDetailID, T00.ItemID as MaterialID, 
	OT2201.TranMonth, OT2201.TranYear,  
	AT1302.InventoryName as MaterialName, 
	T00.ItemUnitID as UnitID, '''' as MDescripton, OV2203.ProductID,  OT2201.ObjectID,AT1202.ObjectName,OT2201.PeriodID,
	OV2203.ProductQuantity, 
	case when isnull(T00.InventoryQuantity, 0) = 0 then 0 else 
	isnull(T00.ItemQuantity,0) * isnull(OV2203.ProductQuantity,0)/ T00.InventoryQuantity end  as MaterialQuantity ,  
	NULL as ConvertedAmount,			
	NULL as ConvertedUnit,
	case when isnull(T00.InventoryQuantity, 0)   = 0 then 0 else isnull(T00.ItemQuantity,0)/T00.InventoryQuantity end as QuantityUnit,
	NULL as MaterialPrice, 
	''COST001'' as ExpenseID, 
	NULL as MaterialTypeID,
	NULL as MaterialTypeName,
	''' + isnull(@WareHouseID, '') + ''' as WareHouseID,
	CASE WHEN  ''' + Isnull(@WareHouseID, '') + '''  = ''''  THEN 0 else 1 end as IsPicking, OV2203.POrders, OT2201.OrderStatus
From AT1326 T00 	inner join OV2203  on OV2203.ApportionID = T00.KITID and  OV2203.ProductID =  T00.InventoryID And OV2203.DivisionID =  T00.DivisionID
	inner join AT1302  on AT1302.InventoryID = T00.ItemID And AT1302.DivisionID = T00.DivisionID
	inner join OT2201  on OT2201.EstimateID = ''' + @EstimateID + ''' and OT2201.DivisionID = ''' + @DivisionID + ''' And T00.DivisionID = OT2201.DivisionID
	Left join AT1202 on AT1202.ObjectID = OT2201.ObjectID And AT1202.DivisionID = OT2201.DivisionID
Where isnull(T00.ItemID,'''') <> ''''' 

ELSE -- KHONG SU DUNG DINH MUC
BEGIN
Set @sSQL = '
Select  ''' + @DivisionID + ''' as DivisionID, ''' + @EstimateID  + ''' as EstimateID, EDetailID, T00.ItemID as MaterialID, 
	OT2201.TranMonth, OT2201.TranYear,  
	AT1302.InventoryName as MaterialName, 
	T00.ItemUnitID as UnitID, '''' as MDescripton, OV2203.ProductID,  OT2201.ObjectID,AT1202.ObjectName,OT2201.PeriodID,
	OV2203.ProductQuantity, 
	case when isnull(T00.InventoryQuantity, 0) = 0 then 0 else 
	isnull(T00.ItemQuantity,0) end  as MaterialQuantity ,  
	NULL as ConvertedAmount,			
	NULL as ConvertedUnit,
	case when isnull(T00.InventoryQuantity, 0)   = 0 then 0 else isnull(T00.ItemQuantity,0)/T00.InventoryQuantity end as QuantityUnit,
	NULL as MaterialPrice, 
	''COST001'' as ExpenseID, 
	NULL as MaterialTypeID,
	NULL as MaterialTypeName,
	''' + isnull(@WareHouseID, '') + ''' as WareHouseID,
	CASE WHEN  ''' + Isnull(@WareHouseID, '') + '''  = ''''  THEN 0 else 1 end as IsPicking, OV2203.POrders, OT2201.OrderStatus, T00.SOrderID, T00.MOrderID
From OT1326 T00 	inner join OV2203  on OV2203.EstimateID = T00.EstimateID and isnull(OV2203.SOrderID,'''') = isnull(T00.SOrderID,'''') and isnull(OV2203.MOrderID, '''') = isnull(T00.MOrderID, '''') and  OV2203.ProductID =  T00.InventoryID And OV2203.DivisionID =  T00.DivisionID
	inner join AT1302  on AT1302.InventoryID = T00.ItemID And AT1302.DivisionID = T00.DivisionID
	inner join OT2201  on OT2201.EstimateID = ''' + @EstimateID + ''' and OT2201.DivisionID = ''' + @DivisionID + ''' And T00.DivisionID = OT2201.DivisionID
	Left join AT1202 on AT1202.ObjectID = OT2201.ObjectID And AT1202.DivisionID = OT2201.DivisionID
Where isnull(T00.ItemID,'''') <> ''''' 
END
--print @sSQL

If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2202')
	Drop view OV2202
EXEC('Create view OV2202 ---tao boi OP2202
		as ' + @sSQL)