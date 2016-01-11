SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-----Created by Van Nhan, Date 24/05/2007
---- View chet: Truy van but toan ngoài bang
ALTER VIEW [dbo].[AV9004] AS 
SELECT 
TransactionTypeID,
TransactionID, 
AT9004.DivisionID, 
TranMonth, 
TranYear, 
VoucherDate, 
VoucherTypeID, 
VoucherNo, 
VoucherID, 
CASE WHEN D_C ='D' THEN AT9004.AccountID ELSE '' END AS DebitAccountID, 
CASE WHEN D_C ='C' THEN AT9004.AccountID ELSE '' END AS CreditAccountID, 
AT9004.AccountID AS AccountID,
AT9004.ObjectID,
AT1202.ObjectName,
AT9004.InventoryID, 
InventoryName,
D_C, 
AT9004.CurrencyID, 
ExchangeRate, 
Quantity, 
UnitPrice, 
OriginalAmount, 
ConvertedAmount, 
VDescription, 
TDescription,
CASE WHEN D_C ='D' THEN OriginalAmount ELSE - OriginalAmount END AS SignOriginalAmount,
CASE WHEN D_C ='D' THEN ConvertedAmount ELSE - ConvertedAmount END AS SignConvertedAmount, 
AT9004.CreateUserID
FROM AT9004
LEFT JOIN AT1302 ON AT1302.DivisionID = AT9004.DivisionID AND AT1302.InventoryID = AT9004.InventoryID
LEFT JOIN AT1202 ON AT1202.DivisionID = AT9004.DivisionID AND AT1202.ObjectID = AT9004.ObjectID

GO


