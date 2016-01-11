/****** Object:  View [dbo].[AV7410]    Script Date: 12/16/2010 14:53:09 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


--View chet???

ALTER VIEW [dbo].[AV7410]  As 
Select DivisionID, VoucherDate, VoucherNo, TDescription, DebitAccountID, CreditAccountID, Sum(ConvertedAmount) as ConvertedAmount
From AT9000
Where 	(VoucherDate between '05/01/2006' and '05/01/2006') and
	DivisionID ='NHT' and
	TransactionTypeID in (Select TransactionID From AT7612 Where ReportCode ='BC001')
Group by DivisionID, VoucherDate, VoucherNo, TDescription, DebitAccountID, CreditAccountID


GO


