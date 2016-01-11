
/****** Object:  View [dbo].[AV3016]    Script Date: 12/16/2010 14:59:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----- Created by Nguyen Van Nhan, Date 26/11/2003.
----- Purpose: Loc ra tat ca cac but toan thue nhap khau
ALTER VIEW [dbo].[AV3016] as 
Select 	VoucherID,     BatchID,TransactionID,       TableID ,
        	DivisionID,       TranMonth,	TranYear,	TransactionTypeID,
	CurrencyID,        ObjectID,
	VATNo,	VATObjectID,        VATObjectName,	VATObjectAddress,
   	DebitAccountID,       CreditAccountID,      
	ExchangeRate,	UnitPrice,
	OriginalAmount, ConvertedAmount,
	ImTaxOriginalAmount,	ImTaxConvertedAmount,  ExpenseOriginalAmount, ExpenseConvertedAmount,
	VoucherDate,    InvoiceDate ,   VoucherTypeID,
	VATTypeID,    VATGroupID,           VoucherNo ,           Serial,
	InvoiceNo,      Orders, EmployeeID,           SenderReceiver,	 SRDivisionName, 
	SRAddress, RefNo01,RefNo02 , VDescription ,	 BDescription,  TDescription,
	Quantity,InventoryID,          UnitID,               Status ,              IsAudit, IsCost ,Ana01ID ,             Ana02ID ,             Ana03ID,
             CreateDate,                  CreateUserID ,        LastModifyDate ,
             LastModifyUserID ,    OriginalAmountCN,      ExchangeRateCN ,       CurrencyIDCN,         DueDays,     PaymentID ,           DueDate                      
From AT9000
Where TransactionTypeID='T33'

GO


