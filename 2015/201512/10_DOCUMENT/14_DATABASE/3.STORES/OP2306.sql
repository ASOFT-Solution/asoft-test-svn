
/****** Object:  StoredProcedure [dbo].[OP2306]    Script Date: 12/16/2010 13:28:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



---VAN HUNG
---Created by: Vo Thanh Huong, date: 13/12/2005
---purpose: TINH DU TRU NVL BAO BI IN
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[OP2306]  @DivisionID nvarchar(50),
				 @OrderID nvarchar(50)

AS
DECLARE @sSQL nvarchar(4000)

Set @sSQL = '
Select  OT2002.DivisionID,
		OT2002.TransactionID as EDetailID, OT2002.Orders as POrders,
		OT2002.InventoryID as ProductID, 
		AT1302_P.InventoryName as ProductName,
		OT2002.OrderQuantity as ProductQuantity,
		OT2002.UnitID as PUnitID,
		OT1305.MaterialID as MaterialID,
		AT1302.Inventoryname as MaterialName,	
		AT1302.UnitID as MUnitID,	
		OT2002.OrderQuantity/ case when isnull(OT1305.Num06,0) = 0 then 1 else  OT1305.Num06 end as Num01,
		0 as Num02,
		OT2002.OrderQuantity/ case when isnull(OT1305.Num06,0) = 0 then 1 else  OT1305.Num06 end as MaterialQuantity,
		0 as StockQuantity,
		OT2002.OrderQuantity/ case when isnull(OT1305.Num06,0) = 0 then 1 else  OT1305.Num06 end as LackQuantity, 
		'''' as MDescription, 
		AT1302.S1 as I01ID, AT1302.S3 as I02ID	
From OT2002  	left join OT1305 on OT1305.FileID = OT2002.FileID and OT1305.ProductID = OT2002.InventoryID 
		left  join AT1302 on AT1302.InventoryID = OT1305.MaterialID 
		left  join AT1302  AT1302_P on AT1302_P.InventoryID = OT2002.InventoryID
		left join (Select InventoryID, Sum(DebitQuantity - CreditQuantity) as EndQuantity
			From OV2350
			Group by InventoryID) OV2350 on OV2350.InventoryID = OT1305.MaterialID
Where OT2002.SOrderID = ''' + @OrderID + ''''

IF  not exists (Select TOP 1 1 From sysObjects Where XType = 'V' and Name = 'OV2306')
	EXEC('Create view OV2306 --tao boi OP2306
			as ' +  @sSQL)
ELSE
	EXEC('Alter view OV2306 --tao boi OP2306
			as ' +  @sSQL)