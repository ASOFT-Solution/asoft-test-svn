/****** Object:  View [dbo].[AV4203]    Script Date: 01/25/2011 11:21:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------View chet
------Create By : Dang Le Bao Quynh; Date 04/07/2008
------Purpose: Phuc vu bao cao chi tiet cong no phai thu theo ma phan tich 1

ALTER VIEW [dbo].[AV4203] as 	


SELECT     ObjectID, Ana01ID, CurrencyIDCN, VoucherDate, InvoiceDate, DueDate, AT9000.DivisionID, DebitAccountID AS AccountID, InventoryID, 
                      SUM(isnull(ConvertedAmount, 0)) AS ConvertedAmount, SUM(isnull(OriginalAmountCN, 0)) AS OriginalAmount, TranMonth, TranYear, 
                      CreditAccountID AS CorAccountID, 'D' AS D_C, TransactionTypeID
FROM         AT9000 INNER JOIN
                      AT1005 ON AT1005.AccountID = AT9000.DebitAccountID and AT1005.DivisionID = AT9000.DivisionID
WHERE     DebitAccountID IS NOT NULL AND AT1005.GroupID IN ('G03', 'G04')
GROUP BY ObjectID, Ana01ID, CurrencyIDCN, VoucherDate, InvoiceDate, DueDate, AT9000.DivisionID, DebitAccountID, TranMonth, TranYear, CreditAccountID, 
                      TransactionTypeID, InventoryID
UNION ALL
SELECT     (CASE WHEN TransactionTypeID = 'T99' THEN CreditObjectID ELSE ObjectID END) AS ObjectID, Ana01ID, CurrencyIDCN, VoucherDate, InvoiceDate, 
                      DueDate, AT9000.DivisionID, CreditAccountID AS AccountID, InventoryID, SUM(isnull(ConvertedAmount, 0) * - 1) AS ConvertedAmount, 
                      SUM(isnull(OriginalAmountCN, 0) * - 1) AS OriginalAmount, TranMonth, TranYear, DebitAccountID AS CorAccountID, 'C' AS D_C, TransactionTypeID
FROM         AT9000 INNER JOIN
                      AT1005 ON AT1005.AccountID = AT9000.CreditAccountID and AT1005.DivisionID = AT9000.DivisionID
WHERE     CreditAccountID IS NOT NULL AND AT1005.GroupID IN ('G03', 'G04')
GROUP BY (CASE WHEN TransactionTypeID = 'T99' THEN CreditObjectID ELSE ObjectID END), Ana01ID, CurrencyIDCN, VoucherDate, InvoiceDate, DueDate, 
                      AT9000.DivisionID, CreditAccountID, TranMonth, TranYear, DebitAccountID, TransactionTypeID, InventoryID
GO


