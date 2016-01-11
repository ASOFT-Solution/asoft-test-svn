/****** Object:  View [dbo].[AV3055]    Script Date: 12/16/2010 15:05:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

-- Notes:	 View chet.
-- Purpose:	Dung de truy van phieu so du theo tai khoan.
--- Last Updated by Nguyen Van Nhan, Date 28/07/2004

ALTER VIEW [dbo].[AV3055] as 
Select 	 VoucherID,	BatchID,	TransactionID,        TableID,
	 AT9000.DivisionID,           TranMonth ,  TranYear ,     AT9000.CurrencyID ,          AT9000.ObjectID,     ObjectName,
	 DebitAccountID ,     CreditAccountID,     ExchangeRate  ,       OriginalAmount ,
	 DebitBankAccountID, CreditBankAccountID, 	
     	 ConvertedAmount,                VoucherDate,                 InvoiceDate, DueDate, 
               VoucherTypeID,         VoucherNo,            Serial  ,             InvoiceNo,            
	 Orders, VDescription as Description,
	VDescription,BDescription ,TDescription,        
	TransactionTypeID,
	AT9000.EmployeeID,
	 Status,               IsAudit, AT9000.CreateDate,                  AT9000.CreateUserID,         AT9000.LastModifyDate,              AT9000.LastModifyUserID,
	D.IsObject as IsObjectD,
     	C.IsObject as IsObjectC,
	E.FullName,
	AT9000.Ana01ID,
	AT9000.Ana02ID,
	AT9000.Ana03ID,
	AT9000.Ana04ID,
	AT9000.Ana05ID,
	AT9000.Ana06ID,
	AT9000.Ana07ID,
	AT9000.Ana08ID,
	AT9000.Ana09ID,
	AT9000.Ana10ID

From AT9000 	left join AT1202 on AT1202.ObjectID = AT9000.ObjectID and AT1202.DivisionID = AT9000.DivisionID
		left join AT1005 D on D.AccountID = At9000.DebitAccountID and D.DivisionID = At9000.DivisionID
		Left join AT1005 C on C.AccountID = At9000.CreditAccountID and C.DivisionID = At9000.DivisionID
		left join AT1103 E on AT9000.EmployeeID=E.EmployeeID and E.DivisionID=AT9000.DivisionID

Where  TransactionTypeID ='T00' and
	--TableID ='AT9000'	
	VoucherID not in (Select VoucherID From AT2017)

GO


