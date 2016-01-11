
/****** Object:  View [dbo].[OV2907]    Script Date: 12/16/2010 15:14:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---View chet so sanh so luong giua yeu cau mua hang va tinh du tru
---Thuy Tuyen
---29/12/2009

ALTER VIEW [dbo].[OV2907]
as
Select OT2201.DivisionID, OT2203.TranMonth, OT2203.TranYear,
	OT2203.EstimateID, OT2201.OrderStatus, TransactionID,
	OT2203.MaterialID, MaterialQuantity,  
	 isnull(OT2203.MaterialQuantity,0) - isnull(ActualQuantity, 0)  as EndQuantity
	---case when OT2203.Finish = 1 then NULL else isnull(OT2203.ConvertedQuantity,0) - isnull(ActualCQuantity, 0) end as EndCQuantity

From OT2203 inner join OT2201 on OT2203.EstimateID = OT2201.EstimateID
	left join 	(Select OT3101.DivisionID,  isnull (OT3102.RefTransactionID,'' ) as RefTransactionID,
				InventoryID, sum(OT3102.OrderQuantity) As ActualQuantity, Sum(Isnull(ConvertedQuantity,0)) As ActualCQuantity
			 From OT3102 inner join OT3101 on OT3101.ROrderID = OT3102.ROrderID
			 Where isnull (OT3102.RefTransactionID,'' ) <> ' '
			 Group by OT3101.DivisionID,  InventoryID,OT3102.RefTransactionID) as G  --- (co nghia la Nhan hang)
		on 	OT2201.DivisionID = G.DivisionID and
			OT2203.MaterialID = G.InventoryID and
			OT2203.TransactionID = isnull(G.RefTransactionID,'')

GO


