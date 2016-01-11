
/****** Object: View [dbo].[AQ2904] Script Date: 02/16/2011 12:03:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Created by: Bao Anh, date : 24/12/2009
--Purpose: So luong PO va so luong hang nhap kho (view tinh)

ALTER VIEW [dbo].[AQ2904] as
SELECT 
OT3001.DivisionID, 
OT3001.TranMonth, 
OT3001.TranYear, 
OT3001.POrderID, 
OT3001.OrderStatus, 
OT3001.Duedate, 
OT3001.Shipdate,
OT3001.PaymentTermID,

AT1208.Duedays,

OT3002.TransactionID, 
OT3002.InventoryID, 
ISNULL(OT3002.ConvertedQuantity, 0) AS ConvertedQuantity,
ISNULL(OT3002.OrderQuantity, 0) AS OrderQuantity,
ISNULL(G.ActualConvertedQuantity, 0) AS ActualConvertedQuantity, 
ISNULL(G.ActualQuantity, 0) AS ActualQuantity, 

CASE WHEN OT3002.Finish = 1 THEN 0 ELSE ISNULL(OT3002.ConvertedQuantity, 0)- ISNULL(G.ActualConvertedQuantity, 0) END AS EndConvertedQuantity,
CASE WHEN OT3002.Finish = 1 THEN 0 ELSE ISNULL(OT3002.OrderQuantity, 0)- ISNULL(G.ActualQuantity, 0) END AS EndQuantity,
CASE WHEN OT3002.Finish = 1 THEN 0 ELSE ISNULL(OT3002.OriginalAmount, 0) - ISNULL(G.ActualOriginalAmount, 0) END AS EndOriginalAmount,
CASE WHEN OT3002.Finish = 1 THEN 0 ELSE ISNULL(OT3002.ConvertedAmount, 0) - ISNULL(G.ActualConvertedAmount, 0) END AS EndConvertedAmount

FROM OT3002 
INNER JOIN OT3001 ON OT3001.POrderID = OT3002.POrderID AND OT3001.DivisionID = OT3002.DivisionID 
LEFT JOIN AT1208 ON AT1208.PaymentTermID = OT3001.PaymentTermID AND AT1208.DivisionID = OT3002.DivisionID
LEFT JOIN 
(
SELECT 
AT2007.DivisionID, 
AT2007.OrderID, 
AT2007.OTransactionID,
AT2007.InventoryID, 
SUM(ISNULL(AT2007.ConvertedQuantity, 0)) AS ActualConvertedQuantity, 
SUM(ISNULL(AT2007.ActualQuantity, 0)) AS ActualQuantity, 
SUM(ISNULL(AT2007.OriginalAmount, 0)) AS ActualOriginalAmount, 
SUM(ISNULL(AT2007.ConvertedAmount, 0)) AS ActualConvertedAmount
FROM AT2007 
INNER JOIN AT2006 ON AT2007.VoucherID = AT2006.VoucherID AND AT2007.DivisionID = AT2006.DivisionID
WHERE AT2006.KindVoucherID = 1
AND ISNULL(AT2007.OrderID, '') <> ''
GROUP BY AT2007.DivisionID, AT2007.OrderID, InventoryID, OTransactionID
) AS G --- (co nghia la Giao hang)
ON G.OrderID = OT3002.POrderID AND G.OTransactionID = OT3002.TransactionID 
AND G.InventoryID = OT3002.InventoryID AND G.DivisionID = OT3002.DivisionID

GO


