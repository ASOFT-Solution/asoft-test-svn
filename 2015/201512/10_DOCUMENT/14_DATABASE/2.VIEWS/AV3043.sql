
/****** Object:  View [dbo].[AV3043]    Script Date: 12/16/2010 15:04:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER VIEW [dbo].[AV3043] as 
Select 	VoucherID, AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear, 
	VoucherTypeID, VoucherNo, VoucherDate,
	VDescription,
	'' as InvoiceNoList,
	'' as CreditAccountID,
	DebitAccountID as AccountID, 
	AT9000.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress,
	RefNo01, RefNo02, DebitBankAccountID, AT1016.BankName, AT1016.BankAccountNo,
	AT1101.Address as DivisionAddress,
	Sum(ConvertedAmount) as ConvertedAmount,
	Sum(OriginalAmount) as OriginalAmount,
	Case When AT1202.IsUpdateName = 1 Then VATObjectAddress Else AT1202.Address End As ObjectAddress
	
From AT9000 
	Left join AT1202 on AT9000.ObjectID = AT1202.ObjectID
	Left join AT1016 on AT1016.BankAccountID = AT9000.DebitBankAccountID
	Left join AT1101 on AT1101.DivisionID = AT9000.DivisionID

Where TransactionTypeID ='T21' and
	AT9000.DivisionID = '1' and
	VoucherID ='10' 
Group by VoucherID, AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear, 
	VoucherTypeID, VoucherNo, VoucherDate, DebitBankAccountID,
	AT1016.BankName, AT1016.BankAccountNo, VDescription, DebitAccountID, 
	AT9000.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress, RefNo01, RefNo02,
	AT1101.Address,
	Case When AT1202.IsUpdateName = 1 Then VATObjectAddress Else AT1202.Address End

GO


