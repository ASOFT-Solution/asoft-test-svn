SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


---- Created by Nguyen Van Nhan, Date 11/11/2005
---- Purpose: Dung de truy van Phieu ban hang theo bo

ALTER VIEW [dbo].[AV6066] as
Select  AT9000.DivisionID, TranMonth, TranYear,
	VoucherID, BatchID,	  
	VoucherDate,VoucherNo, Serial, InvoiceNo,
	VoucherTypeID,
	VATTypeID, InvoiceDate,
	VDescription,
	BDescription,
	AT9000.CurrencyID,
	ExchangeRate,
	Sum(isnull(OriginalAmount,0)) as OriginalAmount,
	Sum(Isnull(ConvertedAmount,0)) as ConvertedAmount,
	AT9000.ObjectID,
	(Case when AT1202.IsUpdateName = 0 then AT1202.ObjectName else VATObjectName End) as  ObjectName,
	DueDate,
	OrderID,
	isnull(IsStock,0) as IsStock, 	
	Sum ( Case when TransactionTypeID ='T14' then ConvertedAmount else 0 end ) as TaxAmount,
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,	AT9000.CreateUserID
	
From AT9000 inner join AT1202 on AT1202.ObjectID = AT9000.ObjectID And AT1202.DivisionID = AT9000.DivisionID
Where TransactionTypeID in ('T04', 'T14') and TableID in ('MT1603' , 'AT1326')

Group by  AT9000.DivisionID, TranMonth, TranYear,
	VoucherID, BatchID,	  
	VoucherDate,VoucherNo, Serial, InvoiceNo,
	VoucherTypeID, VATTypeID, InvoiceDate,
	VDescription,
	BDescription,
	AT9000.CurrencyID,
	ExchangeRate,	
	AT9000.ObjectID,
	ObjectName,
	DueDate,
	OrderID,AT1202.IsUpdateName, VATObjectName,
	isnull(IsStock,0),
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, AT9000.CreateUserID

GO


