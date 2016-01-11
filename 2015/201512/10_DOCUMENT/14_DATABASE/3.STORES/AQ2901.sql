IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AQ2901]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AQ2901]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Created by: Thuy Tuyen, date : 11/05/2008
--Purpose: So luong SO va so luong hang  lap hoa don ban hang (view chet)
--Last edit: Thuy Tuyen  date: 10/10/2009
--Edit by:  Thuy Tuyen, date 26/03/2009, them truong G.OrderID as T9OrderID
--Edit by:  Quốc Tuấn, date 07/01/2015, them truong EndConvertedQuantity
CREATE VIEW [dbo].[AQ2901] as 
---Lay so luong don hang ban
Select OT2001.DivisionID, TranMonth, TranYear, OT2002.SOrderID,  OT2001.OrderStatus, TransactionID, OT2001.Duedate, OT2001.Shipdate,
	OT2002.InventoryID, Isnull(OrderQuantity,0) as OrderQuantity  ,Isnull( ActualQuantity,0) as ActualQuantity, OT2001.PaymentTermID,AT1208.Duedays,
	case when OT2002.Finish = 1 then NULL else isnull(OrderQuantity, 0)- isnull(ActualQuantity, 0) end as EndQuantity, G.OrderID as T9OrderID,
	case when OT2002.Finish = 1 then NULL else isnull(ConvertedQuantity, OrderQuantity)- isnull(ActualConvertedQuantity, 0) end as EndConvertedQuantity,
 ( isnull(OriginalAmount,0) - isnull(ActualOriginalAmount,0 ))  as EndOriginalAmount
From OT2002 inner join OT2001 ON OT2001.DivisionID = OT2002.DivisionID AND OT2002.SOrderID = OT2001.SOrderID
	left join AT1208 ON AT1208.DivisionID = OT2001.DivisionID AND AT1208.PaymentTermID = OT2001.PaymentTermID 	
	
	left join 	(Select AT9000.DivisionID, AT9000.OrderID, OTransactionID,
			InventoryID, sum(Quantity) As ActualQuantity, sum(isnull(OriginalAmount,0)) as ActualOriginalAmount,
			SUM(isnull(ConvertedQuantity,Quantity)) As ActualConvertedQuantity
		From AT9000 
	          	 WHERE TransactionTypeID ='T04' AND isnull(AT9000.OrderID,'') <>''
		Group by AT9000.DivisionID, AT9000.OrderID, InventoryID, OTransactionID) as G  --- (co nghia la Giao  hang)
		on 	OT2001.DivisionID = G.DivisionID AND OT2002.SOrderID = G.OrderID and
			OT2002.InventoryID = G.InventoryID AND OT2002.TransactionID = G.OTransactionID
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
