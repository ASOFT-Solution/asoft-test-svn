IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AQ2903]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AQ2903]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Created by: Bao Anh, date : 21/12/2009
--Edit by: Hoàng vũ, on 11/08/2015 --Bổ sung trường EndConvertedQuantity để sử lý cho khách hàng Secoin
--Purpose: So luong SO va so luong hang xuat kho (view tinh)

CREATE VIEW [dbo].[AQ2903] as
Select OT2001.DivisionID, TranMonth, TranYear, OT2002.SOrderID,  OT2001.OrderStatus, TransactionID, OT2001.Duedate, OT2001.Shipdate,
	OT2002.InventoryID, Isnull(OrderQuantity,0) as OrderQuantity  ,Isnull( ActualQuantity,0) as ActualQuantity, OT2001.PaymentTermID,AT1208.Duedays,
	case when OT2002.Finish = 1 then NULL else isnull(OrderQuantity, 0)- isnull(ActualQuantity, 0) end as EndQuantity, 0 as EndConvertedQuantity,
 ( isnull(OriginalAmount,0) - isnull(ActualOriginalAmount,0 ))  as EndOriginalAmount
From OT2002 inner join OT2001 on OT2002.SOrderID = OT2001.SOrderID
	left join AT1208 on AT1208.PaymentTermID = OT2001.PaymentTermID 	
	left join (Select AT2007.DivisionID, AT2007.OrderID, OTransactionID,
		InventoryID, sum(ActualQuantity) As ActualQuantity, sum(isnull(OriginalAmount,0)) as ActualOriginalAmount
		From AT2007 inner join AT2006 on AT2007.VoucherID = AT2006.VoucherID
		Where isnull(AT2007.OrderID,'') <>'' and AT2006.KindVoucherID = 2
		Group by AT2007.DivisionID, AT2007.OrderID, InventoryID, OTransactionID) as G  --- (co nghia la Giao  hang)
		on 	OT2001.DivisionID = G.DivisionID and
			OT2002.SOrderID = G.OrderID and
			OT2002.InventoryID = G.InventoryID and
			OT2002.TransactionID = G.OTransactionID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
