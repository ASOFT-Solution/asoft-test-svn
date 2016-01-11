
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AQ02601]'))
DROP VIEW [dbo].[AQ02601]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--- Created by: Khanh Van , date : 11/03/2013
--- Purpose: Trả ra các phiếu số dư công nợ đầu kỳ, phiếu tổng hợp với số tiền còn lại sau khi kế thừa lập phiếu thu

CREATE VIEW [dbo].[AQ02601] as

Select AT9000.DivisionID, AT9000.VoucherID, AT9000.TransactionID,
(isnull(OriginalAmount, 0) - isnull(OriginalAmountPT,0)) as EndOriginalAmount,
(isnull(ConvertedAmount, 0) - isnull(ConvertedAmountPT,0)) as EndConvertedAmount
FROM(
(Select 
	AT9000.DivisionID, TranMonth, TranYear, VoucherID, BatchID,Invoiceno, TransactionID, TransactionTypeID,(CASE WHEN (TransactionTypeID = 'T99' and CreditAccountID in (Select AccountID From AT1005 Where GroupID ='G03' and  IsObject =1 and AT9000.DivisionID= AT1005.DivisionID)) THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) AS ObjectID,(Case when CreditAccountID in (Select AccountID From AT1005 Where GroupID ='G03' and  IsObject =1 and AT9000.DivisionID= AT1005.DivisionID)then CreditAccountID else DebitAccountID end) as DebitAccountID,
	isnull(Sum(AT9000.OriginalAmount), 0)  as OriginalAmount,
	isnull(Sum(AT9000.ConvertedAmount), 0)  as ConvertedAmount
From AT9000 
Where TransactionTypeID in ('T00','T99','T01','T21','T02','T22') and (CASE WHEN TransactionTypeID in ('T01','T21') THEN AT9000.CreditAccountID ELSE DebitAccountID END)  in (Select AccountID From AT1005 Where GroupID ='G03' and  IsObject =1 and AT9000.DivisionID= AT1005.DivisionID)
Group by AT9000.DivisionID, TranMonth, TranYear, VoucherID, BatchID,Invoiceno, TransactionID, TransactionTypeID, AT9000.CreditObjectID , AT9000.ObjectID , AT9000.DebitAccountID, CreditAccountID)  AT9000

Left join (
	Select AT9000.DivisionID, AT9000.TVoucherID, TBatchID, sum(AT9000.OriginalAmount) As OriginalAmountPT, (Case when CreditAccountID in (Select AccountID From AT1005 Where GroupID ='G03' and  IsObject =1 and AT9000.DivisionID= AT1005.DivisionID)then CreditAccountID else DebitAccountID end) as CreditaccountID,sum(AT9000.ConvertedAmount) As ConvertedAmountPT,InvoiceNo, (CASE WHEN (TransactionTypeID = 'T99' and CreditAccountID in (Select AccountID From AT1005 Where GroupID ='G03' and  IsObject =1 and AT9000.DivisionID= AT1005.DivisionID)) THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) AS ObjectID
	From AT9000 
	Where TransactionTypeID in ('T01','T21','T99','T02','T22') and ISNULL(TVoucherID,'')<>''
		Group by DivisionID, TVoucherID,TBatchID, InvoiceNo, TransactionTypeID,CreditObjectID ,ObjectID ,CreditAccountID,DebitAccountID ) K  on AT9000.DivisionID = K.DivisionID and AT9000.VoucherID = K.TVoucherID 
	and AT9000.BatchID = K.TBatchID and AT9000.ObjectID= K.ObjectID and CreditAccountID = DebitAccountID and AT9000.InvoiceNo = K.InvoiceNo)








GO


