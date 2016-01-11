
/****** Object:  View [dbo].[OV2906]    Script Date: 12/16/2010 15:13:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---View chet so sanh so luong giua Don hang san xuat va lap du tru chi phi san xuat
---Thuy Tuyen
---09/12/2009

 ALTER VIEW [dbo].[OV2906]
as
Select OT2001.DivisionID, TranMonth, TranYear,
	OT2002.SOrderID, OT2001.OrderStatus, TransactionID,
	OT2002.InventoryID, OrderQuantity,  
	case when OT2002.Finish = 1 then NULL else isnull(OT2002.OrderQuantity,0) - isnull(ActualQuantity, 0) end as EndQuantity
	
From OT2002 inner join OT2001 on OT2002.SOrderID = OT2001.SOrderID
	left join 	(Select OT2201.DivisionID, MOTransactionID,
			ProductID, sum(OT2202.ProductQuantity) As ActualQuantity
		From OT2202 inner join OT2201 on OT2201.EstimateID = OT2202.EstimateID
		Where isnull(OT2202.MOTransactionID,'') <>''
		Group by OT2201.DivisionID,  ProductID,MOTransactionID) as G  --- (co nghia la Nhan hang)
		on 	OT2001.DivisionID = G.DivisionID and
			OT2002.TransactionID = G.MOTransactionID
where OrderType = 1

GO


