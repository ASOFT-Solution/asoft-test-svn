SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


---Tao view load master man hinh truy van but toan nhap khau
-- Dates: 30/06/2008
--- Thuy Tuyen

ALTER VIEW [dbo].[AV3037]
AS

SELECT 
T9.VoucherNo AS BHVoucherNo,
AT9000.VoucherID,
AT9000.VoucherNO, 
AT9000.VoucherDate,
AT9000.TRanMonth, 
AT9000.TranYear, 
AT9000.VoucherTypeID, 
AT9000.BDescription, 
AT9000.DivisionID,
SUM(ConvertedAmount) AS ConvertedAmount, 
SUM(OriginalAmount) AS OriginalAmount, 
AT9000.VATTypeID, 
AT9000.InvoiceDate,
AT9000.Serial, 
AT9000.InvoiceNo,
AT9000.ObjectID, 
AT1202.ObjectNAme, 
AT9000.CurrencyID, 
AT9000.EXchangerate,
AT9000.CreateUserID
FROM AT9000 
LEFT JOIN AT1202 ON AT1202.DivisionID = AT9000.DivisionID AND AT1202.ObjectID = AT9000.ObjectID
INNER JOIN (SELECT DISTINCT VoucherID, VoucherNO, DivisionID FROM AT9000 WHERE AT9000.TransactionTypeID IN ('T03') AND AT9000.TableID = 'AT9000' ) AS T9
    ON T9.DivisionID = AT9000.DivisionID AND T9.VoucherID = AT9000.VoucherID 
WHERE AT9000.TransactionTypeID IN ('T33') AND AT9000.TableID = 'AT9000' 
GROUP BY 
T9.VoucherNo, AT9000.VoucherID,AT9000.VoucherNO, AT9000.VoucherDate,
AT9000.VoucherTypeID,AT9000.BDescription,AT9000.TRanMonth, AT9000.TranYear, 
AT9000.Serial, AT9000.VoucherTypeID, AT9000.InvoiceNo,AT9000.ObjectID, AT1202.ObjectNAme, AT9000.CurrencyID
, AT9000.EXchangerate, AT9000.DivisionID, AT9000. VATTypeID, AT9000.InvoiceDate, AT9000.CreateUserID

GO


