
/****** Object:  StoredProcedure [dbo].[OP2406]    Script Date: 12/16/2010 13:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


---VAN HUNG
---Created by: Vo Thanh Huong, date: 13/12/2005
---purpose: TINH DU TRU NVL BAO BI THUNG
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[OP2406]  @DivisionID nvarchar(50),
				 @OrderID nvarchar(50)
AS
DECLARE @sSQL nvarchar(4000),
		@sSQLselect nvarchar(4000)
		

Set @sSQL = '
Select  OT2002.DivisionID, 
		OT2002.TransactionID as EDetailID,
		OT2002.Orders as POrders,  		
		OT2002.InventoryID as ProductID, 
		AT1302_P.InventoryName as ProductName,
		OT2002.OrderQuantity as ProductQuantity,	
		OT2002.UnitID as PUnitID,
		OT1305.MaterialID,
		AT1302.Inventoryname as MaterialName,	
		AT1302.S1 as I01ID, AT1302.S3 as I02ID,
		AT1302.UnitID as MUnitID,	
		isnull(cast( AT1302.S2 as decimal(18,4)),0)/1000 --he  so quy doi
		*Num12 --so lop
		*case when 	AT1302.S1   = OT1306.SMaterial01ID   then isnull(OT1306.C01,1) 
		else case when AT1302.S1 = OT1306.SMaterial02ID  then isnull(OT1306.C02,1) 
		else case when AT1302.S1 = OT1306.SMaterial03ID   and OT1305.Num11 = 1 then isnull(OT1306.C03,1) *isnull(OT1306.C05,1)
		else case when AT1302.S1 = OT1306.SMaterial03ID   and OT1305.Num11 <> 1 then isnull(OT1306.C04,1)
		else case when AT1302.S1 = 	OT1306.SMaterial04ID then  isnull(OT1306.C06,1) 
		end end end end end
		* isnull(Num08,0)/100 * isnull(Cal03,0) as  MaterialQuantity,		

	             isnull(OV2350.EndQuantity,0) as StockQuantity,
		
		case when (isnull(cast( AT1302.S2 as decimal(18,4)),0)/1000 --he  so quy doi
		*Num12 --so lop
		*case when 	AT1302.S1   = OT1306.SMaterial01ID   then isnull(OT1306.C01,1) 
		else case when AT1302.S1 = OT1306.SMaterial02ID  then isnull(OT1306.C02,1) 
		else case when AT1302.S1 = OT1306.SMaterial03ID   and OT1305.Num11 = 1 then isnull(OT1306.C03,1) *isnull(OT1306.C05,1)
		else case when  AT1302.S1 = OT1306.SMaterial03ID   and OT1305.Num11 <> 1 then isnull(OT1306.C04,1) 
		else case when AT1302.S1 = 	OT1306.SMaterial04ID then  isnull(OT1306.C06,1) 
		end end end end end
		* isnull(Num08,0)/100 * isnull(Cal03,0) -  isnull(OV2350.EndQuantity,0))>0 then 
		(isnull(cast( AT1302.S2 as decimal(18,4)),0)/1000 --he  so quy doi
		*Num12 --so lop
		*case when 	AT1302.S1   = OT1306.SMaterial01ID   then isnull(OT1306.C01,1) 
		else case when AT1302.S1 = OT1306.SMaterial02ID  then isnull(OT1306.C02,1) 
		else case when AT1302.S1 = OT1306.SMaterial03ID   and OT1305.Num11 = 1 then isnull(OT1306.C03,1) *isnull(OT1306.C05,1)
		else case when AT1302.S1 = OT1306.SMaterial03ID   and OT1305.Num11 <> 1 then isnull(OT1306.C04,1)
		else case when AT1302.S1 = 	OT1306.SMaterial04ID then  isnull(OT1306.C06,1) 
		end end end end end
		* isnull(Num08,0)/100 * isnull(Cal03,0) -  isnull(OV2350.EndQuantity,0))
		else NULL end as		 LackQuantity,
		'''' as MDescription, 	'	

	Set @sSQLselect = '	
		isnull(cast( AT1302.S2 as decimal(18,4)),0)/1000 --he  so quy doi
		*Num12 --so lop
		*case when AT1302.S1 = OT1306.SMaterial03ID   and OT1305.Num11 = 1 then isnull(OT1306.C05,1) else 1 end 
		* isnull(Num08,0)/100 * isnull(Cal03,0)   as Num01,		

		case when       AT1302.S1  = OT1306.SMaterial01ID then isnull(OT1306.C01,1) 
		else case when AT1302.S1 = OT1306.SMaterial02ID  then isnull(OT1306.C02,1) 
		else case when AT1302.S1  = OT1306.SMaterial03ID and OT1305.Num11 = 1 then isnull(OT1306.C03,1) 
		else  case when AT1302.S1  = OT1306.SMaterial03ID and OT1305.Num11 <> 1 then isnull(OT1306.C04,1) 
		else case when 	 AT1302.S1  = OT1306.SMaterial04ID then  isnull(OT1306.C06,1) 
		end end end end end as Num02				
 		
--From OT2002  	full join OT1305 on OT1305.FileID = OT2002.FileID and OT1305.ProductID = OT2002.InventoryID 		
--		inner  join AT1302 on AT1302.InventoryID = OT1305.MaterialID 
--		left join AT1302 AT1302_P on AT1302_P.InventoryID = OT2002.InventoryID
--		left join OT1306 on OT1306.C01 = OT1306.C01
--		left join (Select InventoryID, Sum(DebitQuantity - CreditQuantity) as EndQuantity
--			From OV2350
--			Group by InventoryID) OV2350 on OV23



From OT2002  	full join OT1305 on OT1305.FileID = OT2002.FileID and OT1305.ProductID = OT2002.InventoryID 		
		inner  join AT1302 on AT1302.InventoryID = OT1305.MaterialID 
		left join AT1302 AT1302_P on AT1302_P.InventoryID = OT2002.InventoryID
		left join OT1306 on OT1306.C01 = OT1306.C01
		left join (Select InventoryID, Sum(DebitQuantity - CreditQuantity) as EndQuantity
			From OV2350
			Group by InventoryID) OV2350 on OV2350.InventoryID = OT1305.MaterialID
Where OT2002.SOrderID = ''' + @OrderID + ''''


--PRINT @sSQL+ @sSQLselect

IF  not exists (Select TOP 1 1 From sysObjects Where XType = 'V' and Name = 'OV2406')
	EXEC('Create view OV2406 --tao boi OP2406
			as ' +  @sSQL + @sSQLselect)
ELSE
	EXEC('Alter view OV2406 --tao boi OP2406
			as ' +  @sSQL + @sSQLselect)