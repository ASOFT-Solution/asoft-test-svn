
/****** Object:  View [dbo].[OV2902]    Script Date: 12/16/2010 15:11:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by: Vo Thanh Huong, date : 28/04/2005
--Purpose: So luong dat hang va so luong hang da nhan (view chet)
---Last edit: Thuy Tuyen date 10/04/2009

ALTER VIEW [dbo].[OV2902] as 
---Lay so luong don hang ban
Select OT3001.DivisionID, TranMonth, TranYear,OT3002.POrderID, OT3001.OrderStatus, TransactionID,
	OT3002.InventoryID, OrderQuantity, AdjustQuantity, ActualQuantity,
	---isnull(OrderQuantity, 0)- isnull(AdjustQuantity, 0) - isnull(ActualQuantity, 0) as EndQuantity
( case when OT3002.Finish = 1 then 0   else (  Case When AT1302.IsStocked = 0 then   isnull(OrderQuantity, 0) - isnull(AdjustQuantity,0) - isnull(ActualQuantityHD,0) 
else isnull(OrderQuantity, 0) - isnull(AdjustQuantity,0) -isnull(ActualQuantity,0) end) end ) as EndQuantity
From OT3002
 inner join OT3001 on OT3002.POrderID = OT3001.POrderID And OT3002.DivisionID = OT3001.DivisionID
Inner join AT1302 on AT1302.InventoryID = OT3002.InventoryID And AT1302.DivisionID = OT3002.DivisionID
left join 	(Select AT2006.DivisionID, AT2007.OrderID, OTransactionID, InventoryID, sum(ActualQuantity) As ActualQuantity
		From AT2007 inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID And AT2006.DivisionID = AT2007.DivisionID
		Where isnull(AT2007.OrderID,'') <>'' and 	KindVoucherID in (1,3,5,7,9 ) 
		Group by AT2006.DivisionID, AT2007.OrderID, InventoryID,OTransactionID) as G  --- (co nghia la Nhan hang)
		on 	OT3001.DivisionID = G.DivisionID and	OT3002.POrderID = G.OrderID and OT3002.InventoryID = G.InventoryID and OT3002.TransactionID = G.OTransactionID
Left join  (-- Lap phieu mua hàng  doi voi nhung mat hang AT1302.IsStocked = 0)
	Select AT9000.DivisionID, AT9000.OrderID, OTransactionID, InventoryID, sum(Quantity) As ActualQuantityHD
	From AT9000  
	Where isnull(AT9000.OrderID,'') <>'' and TransactionTypeID ='T03' 
	Group by AT9000.DivisionID, AT9000.OrderID, InventoryID, OTransactionID
	) as K  on OT3001.DivisionID = K.DivisionID and OT3002.POrderID = K.OrderID and OT3002.InventoryID = K.InventoryID and
			OT3002.TransactionID = K.OTransactionID

GO


