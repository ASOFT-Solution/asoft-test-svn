
/****** Object:  View [dbo].[OV2905]    Script Date: 12/16/2010 15:12:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---View chet so sanh so luong giua yeu cau mua hang va don hang mua
---Thuy Tuyen
---22/05/2007.09/09/2009
-- Last Edit , Thuy Tuyen.. date:30/11/2009
 ALTER VIEW [dbo].[OV2905]
as
Select OT3101.DivisionID, TranMonth, TranYear,
	OT3102.ROrderID, OT3101.OrderStatus, TransactionID,
	OT3102.InventoryID, OrderQuantity,  ----OT3001.OrderQuantity as ActualQuantity, 
	case when OT3102.Finish = 1 then NULL else isnull(OT3102.OrderQuantity,0) - isnull(ActualQuantity, 0) end as EndQuantity,
	case when OT3102.Finish = 1 then NULL else isnull(OT3102.ConvertedQuantity,0) - isnull(ActualCQuantity, 0) end as EndCQuantity

From OT3102 inner join OT3101 on OT3102.ROrderID = OT3101.ROrderID
	left join 	(Select OT3001.DivisionID, OT3002.ROrderID, isnull (OT3002.RefTransactionID,'' ) as RefTransactionID,
			InventoryID, sum(OT3002.OrderQuantity) As ActualQuantity, Sum(Isnull(ConvertedQuantity,0)) As ActualCQuantity
		From OT3002 inner join OT3001 on OT3001.POrderID = OT3002.POrderID
		Where isnull (OT3002.RefTransactionID,'' ) <> ' '
		Group by OT3001.DivisionID, OT3002.ROrderID, InventoryID,OT3002.RefTransactionID) as G  --- (co nghia la Nhan hang)
		on 	OT3101.DivisionID = G.DivisionID and
			----OT3102.ROrderID = G.ROrderID and
			OT3102.InventoryID = G.InventoryID and
			OT3102.TransactionID = isnull(G.RefTransactionID,'')

GO


