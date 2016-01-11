/****** Object: View [dbo].[AV3092] Script Date: 12/30/2010 10:28:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--- Created by B.Anh, date 20/07/2009
--- Purpose: Loc ra cac phieu tam thu - chi

ALTER VIEW [dbo].[AV3092] AS 

SELECT 
     VoucherTypeID, 
     TransactionTypeID,
     VoucherNo,
     VoucherDate, 
     DebitAccountID,
     VoucherID,
     TransactionID,
     BatchID,
     CreditAccountID, 
     ExchangeRate, 
     OriginalAmount ,
     ConvertedAmount, 
     InvoiceDate, 
     DueDate, 
     (CASE WHEN AT9010.TransactionTypeID = 'T11' AND AT9010.CurrencyIDCN <> 'VND' THEN AT9010.CurrencyIDCN ELSE AT9010.CurrencyID END) AS CurrencyID,
     VATTypeID, 
     AT9010.VATGroupID, 
     Serial, 
     InvoiceNo, 
     Orders, 
     AT9010.EmployeeID,
     AT9010.ObjectID, 
     (CASE WHEN isnull(AT1202.IsUpdateName,0) <> 0 THEN VATObjectName ELSE AT1202.ObjectName END) AS ObjectName,
     RefNo01, 
     RefNo02,
     VDescription, 
     BDescription,
     TDescription,
     Quantity,
     AT9010.InventoryID , 
     AT9010.UnitID, 
     Status , 
     IsAudit,
     AT9010.CreateDate, 
     AT9010.CreateUserID , 
     AT9010.LastModifyDate , 
     AT9010.LastModifyUserID,
     AT9010.DivisionID, 
     TranMonth, 
     TranYear,
     SenderReceiver, 
     SRAddress, 
     SRDivisionName,
     C.IsObject AS CIsObject, 
     D.IsObject AS DIsObject,
     isnull(AT1202.IsUpdateName,0) AS IsUpdateName,
     AT9010.VATObjectName,
     AT9010.VATObjectAddress,
     (CASE WHEN isnull(AT1202.IsUpdateName,0) <> 0 THEN AT9010.VATNo ELSE AT1202.VATNo END) AS VATNo,
     AT9010.CurrencyIDCN,
     AT9010.ExchangeRateCN,
     AT9010.OriginalAmountCN,
     AT9010.Ana01ID,
     AT9010.Ana02ID,
     AT9010.Ana03ID,
     AT9010.Ana04ID,
     AT9010.Ana05ID,
     AT9010.Ana06ID,
     AT9010.Ana07ID,
     AT9010.Ana08ID,
     AT9010.Ana09ID,
     AT9010.Ana10ID,
     AT9010.OrderID,
     AT9010.PeriodID,
     M01.Description AS PeriodName,
     AT9010.ProductID,
     AT02.InventoryName AS ProductName,
     AT9010.InvoiceCode, AT9010.InvoiceSign
From AT9010
     LEFT JOIN AT1202       ON AT1202.DivisionID = AT9010.DivisionID    AND AT9010.ObjectID = AT1202.ObjectID
    INNER JOIN AT1005 D     ON D.DivisionID = AT9010.DivisionID         AND D.AccountID = AT9010.DebitAccountID
    INNER JOIN AT1005 C     ON C.DivisionID = AT9010.DivisionID         AND C.AccountID = AT9010.CreditAccountID
     LEFT JOIN MT1601 M01   ON M01.DivisionID = AT9010.DivisionID       AND M01.PeriodID = AT9010.PeriodID
     LEFT JOIN AT1302 AT02  ON AT02.DivisionID = AT9010.DivisionID      AND AT02.InventoryID = AT9010.ProductID

Where TransactionTypeID in ('T01','T02')

GO


