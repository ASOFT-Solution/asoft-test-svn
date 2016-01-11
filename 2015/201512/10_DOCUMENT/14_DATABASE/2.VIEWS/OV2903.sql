
/****** Object:  View [dbo].[OV2903]    Script Date: 12/16/2010 15:11:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Created by: Vo Thanh Huong, date : 10/05/2005
--Purpose: So luong du tru va so luong hang da xuat (view chet)

ALTER VIEW [dbo].[OV2903] as 
---Lay so luong don hang ban
Select OT2201.DivisionID, OT2201.TranMonth, OT2201.TranYear,OT2201.EstimateID,  OT2201.OrderStatus, TransactionID, 
	OT2203.MaterialID , MaterialQuantity ,  ActualQuantity, 
	isnull(MaterialQuantity, 0) - isnull(ActualQuantity, 0) as EndQuantity
From OT2203 inner join OT2201 on OT2203.EstimateID = OT2201.EstimateID
	left join 	(Select AT2006.DivisionID, AT2007.OrderID, 
			InventoryID, sum(ActualQuantity) As ActualQuantity
		From AT2007 inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID
		Where isnull(AT2007.OrderID,'') <>'' and
			KindVoucherID in (2,4,6,8) 
		Group by AT2006.DivisionID, AT2007.OrderID, InventoryID) as G  --- (co nghia la Giao  hang)
		on 	OT2201.DivisionID = G.DivisionID and
			OT2201.EstimateID = G.OrderID and
			OT2203.MaterialID = G.InventoryID

GO


