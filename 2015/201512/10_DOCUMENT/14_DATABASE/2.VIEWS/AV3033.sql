/****** Object: View [dbo].[AV3033] Script Date: 12/16/2010 15:03:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---View chet: truy van but toan mua hang
--- Last Edit by Thiên Huỳnh: Lấy Kho xuất trường hợp Lập phiếu Mua hàng Kế thừa Từ Phiếu nhập kho:

ALTER VIEW [dbo].[AV3033] AS 

SELECT
AT9000.DivisionID,
AT9000.VoucherID, 
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
VDescription AS Description,
AT9000.ObjectID,
ObjectName,
DH.OrderID,
VATTypeID,
--WareHouseID = (SELECT WareHouseID FROM AT2006 WHERE VoucherID = AT9000.VoucherID AND DivisionID = AT9000.DivisionID),
WareHouseID = (SELECT WareHouseID FROM AT2006 
		WHERE VoucherID = (case when ISNULL(WOrderID, '') = '' then AT9000.VoucherID else AT9000.WOrderID end) 
		AND DivisionID = AT9000.DivisionID),
Status,
--IsStock,
(Case when ISNULL(WOrderID, '') = '' Then IsStock Else 1 End) As IsStock,
SUM(ISNULL(DiscountAmount, 0)) AS DiscountAmount,
SUM(ISNULL(ImTaxOriginalAmount, 0)) AS ImTaxOriginalAmount,
SUM(ISNULL(ImTaxConvertedAmount, 0)) AS ImTaxConvertedAmount,
SUM(ISNULL(OriginalAmount, 0)) AS OriginalAmount,
SUM(ISNULL(ConvertedAmount, 0)) AS ConvertedAmount, AT9000.CreateUserID 

FROM AT9000 
LEFT JOIN AT1202 ON AT1202.DivisionID = AT9000.DivisionID AND AT1202.ObjectID = AT9000.ObjectID
INNER JOIN (
	select DivisionID, VoucherID, 
		case isnull(OrderID,'') when '' then '' else SUBSTRING(OrderID,1,LEN(OrderID)-1) end as OrderID
		From(
		SELECT p1.DivisionID, p1.VoucherID, 
		( SELECT OrderID + ','
		FROM (select Distinct OrderID, VoucherID, DivisionID From AT9000) as p2
		WHERE p2.VoucherID = p1.VoucherID and p2.DivisionID = p1.DivisionID
		ORDER BY VoucherID
		FOR XML PATH('') ) AS OrderID
		FROM AT9000 p1
		GROUP BY VoucherID, DivisionID
		) as a
	) as DH ON DH.DivisionID =AT9000.DivisionID and DH.VoucherID=AT9000.VoucherID 
WHERE TransactionTypeID = 'T03'

GROUP BY 
AT9000.DivisionID,
AT9000.VoucherID, 
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
DH.OrderID,
VATTypeID,
Status,
IsStock,
WOrderID, AT9000.CreateUserID

GO


