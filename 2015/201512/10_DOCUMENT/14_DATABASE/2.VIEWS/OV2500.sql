
/****** Object:  View [dbo].[OV2500]    Script Date: 12/16/2010 15:06:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- View chet
ALTER VIEW [dbo].[OV2500] as 

---------------------

Select 	Isnull(OV2401.DivisionID, OT2008.DivisionID) as DivisionID,
	isnull(OV2401.WareHouseID, OT2008.WareHouseID) as WareHouseID,
	isnull(OV2401.InventoryID, OT2008.InventoryID) as InventoryID,
	Sum(isnull(DebitQuantity,0)) -Sum(isnull(CreditQuantity,0)) as EndQuantity,
	SQuantity,PQuantity
	
From OV2401 Full join OV2008 OT2008  on OT2008.WareHouseID = OV2401.WareHouseID and
				OT2008.InventoryID = OV2401.InventoryID	  
Group by OV2401.WareHouseID, OT2008.WareHouseID, OV2401.InventoryID, OT2008.InventoryID,SQuantity,PQuantity,OV2401.DivisionID, OT2008.DivisionID

GO


