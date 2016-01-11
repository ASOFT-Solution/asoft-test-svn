SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


---- Created by Nguyen Quoc Huy, Date 18/05/2004
---- Purpose: Dung de truy van but toan hang ban tra lai
---- Edit by B.Anh, date 15/10/2009	Bo sung them truong hop thuong doanh so
---- Edit by Thiên Huỳnh, date 24/01/2013: Where thêm DivisionID
---- Edit by Khanh Van, date 03/09/2013: lấy max anaid để không bị double dòng khi hiển thị lên danh mục

ALTER VIEW [dbo].[AV3019] as 
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
	AT9000.ObjectID,
	ObjectName,
	VATTypeID,
	WareHouseID = (Select WareHouseID From AT2006 WHere VoucherID =AT9000.VoucherID And DivisionID =  AT9000.DivisionID),
	Status,
	IsStock,
	--AT9000.CreateDate, AT9000.CreateUserID, AT9000.LastModifyDate, AT9000.LastModifyUserID,
	Sum(isnull(ImTaxOriginalAmount,0)) as ImTaxOriginalAmount,
	Sum(Isnull(ImTaxConvertedAmount,0)) as ImTaxConvertedAmount,
	---Sum(isnull(OriginalAmount,0)) as OriginalAmount,
	---Sum(Isnull(ConvertedAmount,0)) as ConvertedAmount,
	Sum ( Case when TransactionTypeID in ('T24') then OriginalAmount else Case When TransactionTypeID in ('T74') then -OriginalAmount else 0 end end) as OriginalAmount,
	Sum ( Case when TransactionTypeID in ('T24') then ConvertedAmount else Case When TransactionTypeID in ('T74') then -ConvertedAmount else 0 end end) as ConvertedAmount,

	max(Ana01ID) as Ana01ID, Max(Ana02ID) as Ana02ID, Max(Ana03ID) as Ana03ID, Max(Ana04ID) as Ana04ID, Max(Ana05ID)as Ana05ID, AT9000.CreateUserID		
	
From AT9000 Left join AT1202 on AT1202.ObjectID = AT9000.ObjectID And AT1202.DivisionID = AT9000.DivisionID
Where TransactionTypeID in ('T24','T74')
Group by 
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
	IsStock, AT9000.CreateUserID

GO


