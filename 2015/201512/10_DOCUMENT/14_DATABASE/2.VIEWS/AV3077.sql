SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----- CREATED BY Nguyen Van Nhan.
----- CREATED DATE 07/03/2004
------Edit by Nguyen Quoc Huy, Date: 28/03/2007
---- View chet: sử dụng cho màn hình bút toán tổng hợp
--Last edit by Thiên Huỳnh on 28/05/2012: Bổ sung CreditVATNo
--Last Edit by Thiên Huỳnh on 10/05/2012 : Bổ sung 5 Khoản mục
-- Edit by Khánh Vân on 21/06/2013: Bổ sung TVoucherID, TBatchID
---- Modified on 06/03/2015 by Lê Thị Hạnh: Bổ sung IsPOCost chi phí mua hàng

ALTER VIEW [dbo].[AV3077] AS 
SELECT VoucherID, BatchID, AT9000.TransactionID,  TableID,             
	AT9000.DivisionID, TranMonth, TranYear, TransactionTypeID,
   	AT9000.CurrencyID, AT9000.ObjectID,AT9000.InvoiceCode,AT9000.InvoiceSign,
   	(Case When AT1202.IsUpdateName <> 0  then  VATObjectName else AT1202.ObjectName end) as ObjectName,
	(Case When AT1202.IsUpdateName <> 0  then  AT9000.VATNo else AT1202.VATNo end) as VATNo,
	Isnull(AT1202.IsUpdateName,0) as IsUpdateName,
	AT9000.CreditObjectID,
	(Case When AT02.IsUpdateName <> 0  then  AT9000.CreditObjectName else AT02.ObjectName end) as CreditObjectName,
	(Case When AT02.IsUpdateName <> 0  then  AT9000.CreditVATNo else AT02.VATNo end) as CreditVATNo,
	Isnull(AT02.IsUpdateName,0) as IsUpdateNameCredit,
	VATObjectID, VATObjectAddress, DebitAccountID, CreditAccountID, 
	ExchangeRate, UnitPrice, OriginalAmount, ConvertedAmount, 
	ImTaxOriginalAmount, ImTaxConvertedAmount, 
	ExpenseOriginalAmount, ExpenseConvertedAmount, 
	IsStock, VoucherDate, InvoiceDate, VoucherTypeID, VATTypeID, AT9000.VATGroupID,
    VoucherNo, Serial, InvoiceNo, Orders, At9000.EmployeeID, SenderReceiver, SRDivisionName, SRAddress, 
    RefNo01, RefNo02, VDescription, BDescription, TDescription, 
    Quantity, AT9000.InventoryID, AT9000.UnitID,
    Status, IsAudit, AT9000.IsCost,	
    Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
    AT9000.OrderID, AT9000.PeriodID, M01.Description as PeriodName,	ExpenseID, MaterialTypeID, 
    AT9000.ProductID, AT03.InventoryName as ProductName, 
    OriginalAmountCN, ExchangeRateCN, CurrencyIDCN, DueDays, DueDate, TVoucherID, TBatchID,
	(Select  Top 1 TransactionTypeID from AT9000 A where A.VoucherID = AT9000.TVoucherID and A.BatchID=AT9000.TBatchID and A.DivisionID = AT9000.DivisionID) as TTransactionTypeID,
	ISNULL(AT9000.IsPOCost,0) AS IsPOCost, ISNULL(AT9000.IsInheritFA,0) IsInheritFA,
	AT9000.InheritVoucherID,AT9000.InheritTableID, AT9000.InheritTransactionID,AT9000.ReTransactionID
FROM AT9000 Left join AT1202 on AT1202.ObjectID = AT9000.ObjectID And AT1202.DivisionID = AT9000.DivisionID
		Left join AT1202 as AT02  on AT02.ObjectID = AT9000.CreditObjectID And AT02.DivisionID = AT9000.DivisionID
		Left Join MT1601 M01 on M01.PeriodID = AT9000.PeriodID and M01.DivisionID = AT9000.DivisionID
		Left Join AT1302 as AT03 on  AT03.InventoryID = AT9000.ProductID And AT03.DivisionID = AT9000.DivisionID


