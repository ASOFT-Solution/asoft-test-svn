
/****** Object:  View [dbo].[OV2901]    Script Date: 12/16/2010 15:08:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by: Vo Thanh Huong, date : 28/04/2005
--Purpose: So luong dat hang va so luong hang da giao (view chet)
--Edit by : Thuy Tuyen , date  27/08/2009, date 12/09/2008
--Edit by: Thuy Tuyen,  date: 22/04/2010, them phan chuyen kho
ALTER VIEW [dbo].[OV2901] as 
---Lay so luong don hang ban
Select OT2001.DivisionID, TranMonth, TranYear, OT2002.SOrderID,  OT2001.OrderStatus, TransactionID, OT2001.Duedate, OT2001.Shipdate,
	OT2002.InventoryID, OrderQuantity, ActualQuantity, OT2001.PaymentTermID,AT1208.Duedays,
	 case when OT2002.Finish = 1 then NULL else (  Case When  Isnull (AT1302.IsStocked,0) = 0  then 0 else  isnull(OrderQuantity, 0)- isnull(ActualQuantity, 0) end)end as EndQuantity
From OT2002 inner join OT2001 on OT2002.SOrderID = OT2001.SOrderID and OT2002.DivisionID = OT2001.DivisionID
	         Inner Join AT1302 on AT1302.InventoryID = OT2002.InventoryID and AT1302.DivisionID = OT2002.DivisionID 	
	    left join AT1208 on AT1208.PaymentTermID = OT2001.PaymentTermID and AT1208.DivisionID = OT2001.DivisionID
	left join 	(Select AT2006.DivisionID, AT2007.OrderID, OTransactionID,
			InventoryID, sum(ActualQuantity) As ActualQuantity
		From AT2007 inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID
		Where isnull(AT2007.OrderID,'') <>'' and
			KindVoucherID in (2,4,6,8,3 ) 
		Group by AT2006.DivisionID, AT2007.OrderID, InventoryID, OTransactionID) as G  --- (co nghia la Giao  hang)
		on 	OT2001.DivisionID = G.DivisionID and
			OT2002.SOrderID = G.OrderID and
			OT2002.InventoryID = G.InventoryID and
			OT2002.TransactionID = G.OTransactionID

GO


