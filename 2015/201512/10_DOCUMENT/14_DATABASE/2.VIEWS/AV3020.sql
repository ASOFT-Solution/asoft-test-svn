SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


---- Created BY Nguyen Quoc Huy, Date 18/05/2004
---- Purpose: Dung de truy van but toan hang ban tra lai

ALTER VIEW [dbo].[AV3020] AS 
SELECT
 AT9000.DivisionID,
 VoucherID, 
 TranMonth,
 TranYear,
 BatchID,
 VoucherTypeID,
 VoucherNo,
 VoucherDate,
 Serial,
 InvoiceNo,
 InvoiceDate,
 AT9000.CurrencyID,
 ExchangeRate,
 VDescription,
 AT9000.ObjectID,
 ObjectName,
 VATTypeID,
 WareHouseID = (SELECT WareHouseID FROM AT2006 WHERE VoucherID = AT9000.VoucherID AND DivisionID = AT9000.DivisionID),
 Status,
 IsStock,
 
 SUM(ISNULL(ImTaxOriginalAmount,0)) AS ImTaxOriginalAmount,
 SUM(ISNULL(ImTaxConvertedAmount,0)) AS ImTaxConvertedAmount,
 SUM(ISNULL(OriginalAmount,0)) AS OriginalAmount,
 SUM(ISNULL(ConvertedAmount,0)) AS ConvertedAmount ,
 AT9000.CreateUserID
FROM AT9000 LEFT JOIN AT1202 ON AT1202.DivisionID = AT9000.DivisionID AND AT1202.ObjectID = AT9000.ObjectID
WHERE TransactionTypeID = 'T25'
GROUP BY 
 AT9000.DivisionID,
 VoucherID, 
 --AT9000.CreateDate, AT9000.CreateUserID, AT9000.LastModifyDate, AT9000.LastModifyUserID,
 TranMonth,
 TranYear,
 BatchID,
 VoucherNo,VoucherTypeID,
 VoucherDate,
 Serial,
 InvoiceNo,
 InvoiceDate,
 AT9000.CurrencyID,
 ExchangeRate,
 VDescription,
 AT9000.ObjectID,
 ObjectName,
 VATTypeID,
 Status,
 IsStock,
 AT9000.CreateUserID
GO


