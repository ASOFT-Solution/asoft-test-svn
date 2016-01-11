
/****** Object:  View [dbo].[AV1703]    Script Date: 12/16/2010 14:52:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- Create by: Dang Le Bao Quynh; Date: 23/04/2007
---- Purpose:  View chet loc du lieu chi tiet cho khai bao phan bo 

ALTER VIEW [dbo].[AV1703] as 

Select VoucherID,VoucherNo,VoucherDate,VDescription, 
	DebitAccountID as AccountID,
	TranMonth, TranYear, DivisionID,
	ObjectID,Serial,InvoiceNo,InvoiceDate,
	Sum(ConvertedAmount) as ConvertedAmount,
	'D' as D_C
From AT9000
Where DebitAccountID in (Select AccountID From AT0006 Where D_C = 'D')
Group  by VoucherID,VoucherNo,VoucherDate,VDescription, 	TranMonth, TranYear, DivisionID, DebitAccountID, ObjectID,Serial,InvoiceNo,InvoiceDate
Union All
Select VoucherID,VoucherNo,VoucherDate,VDescription, 
	CreditAccountID as AccountID,
	TranMonth, TranYear, DivisionID,
	ObjectID,Serial,InvoiceNo,InvoiceDate,
	Sum(ConvertedAmount) as ConvertedAmount,
	'C' as D_C
From AT9000
Where CreditAccountID in (Select AccountID From AT0006 Where D_C = 'C')
Group  by VoucherID,VoucherNo,VoucherDate,VDescription, 	TranMonth, TranYear, DivisionID, CreditAccountID,ObjectID,Serial,InvoiceNo,InvoiceDate

GO


