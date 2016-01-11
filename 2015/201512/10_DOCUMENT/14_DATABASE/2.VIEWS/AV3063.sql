
/****** Object:  View [dbo].[AV3063]    Script Date: 12/16/2010 15:06:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--- View: truy van but toan nhap kho mua hang
--- Date: 25/07/2009

ALTER VIEW [dbo].[AV3063] as 
Select
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
	VDescription as Description,
	AT9000.ObjectID,
	--ObjectName,
	(Case when AT1202.IsUpdateName = 0 then AT1202.ObjectName else VATObjectName End) as  ObjectName,
	RefNo01,
	RefNo02,
	--OrderID,
	VATTypeID,
	WareHouseID = (Select WareHouseID From AT2006 WHere VoucherID =AT9000.ReVoucherID),
	Status,
	IsStock,
	Sum(isnull(ImTaxOriginalAmount,0)) as ImTaxOriginalAmount,
	Sum(Isnull(ImTaxConvertedAmount,0)) as ImTaxConvertedAmount,
	Sum(isnull(OriginalAmount,0)) as OriginalAmount,
	Sum(Isnull(ConvertedAmount,0)) as ConvertedAmount		
	
From AT9000 Left join AT1202 on AT1202.ObjectID = AT9000.ObjectID
Where TransactionTypeID ='T30'
Group by 
	AT9000.DivisionID,
	VoucherID, 
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
	--ObjectName,
	AT1202.IsUpdateName, AT1202.ObjectName, VATObjectName,
	--OrderID,
	VATTypeID,
	AT9000.ReVoucherID,
	Status,
	IsStock,RefNo01,RefNo02

GO


