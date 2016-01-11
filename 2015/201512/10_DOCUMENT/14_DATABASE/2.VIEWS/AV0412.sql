/****** Object:  View [dbo].[AV0412]    Script Date: 01/18/2011 15:52:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



--View chet
--Purpose: giai tru cong no phai tra
-- last edit : Thuy Tuyen , them cac truong O Code, date 15/07/2009
ALTER VIEW [dbo].[AV0412] as 
SELECT Distinct '' As GiveUpID, VoucherID, BatchID,  TableID, AT9000.DivisionID,TranMonth,TranYear,
	(Case when TransactionTypeID ='T99' then  AT9000.CreditObjectID else AT9000.ObjectID end) As ObjectID , 
	CreditAccountID, AT1005.AccountName as CreditAccountName,
	AT9000.CurrencyID, CurrencyIDCN,
	(Case when TransactionTypeID ='T99' then  B.ObjectName  else AT1202.ObjectName   end)  as  ObjectName,
	Sum(isnull(OriginalAmount,0)) as OriginalAmount,Sum(isnull(ConvertedAmount,0)) as ConvertedAmount, 
	Sum(isnull(OriginalAmountCN,0)) as OriginalAmountCN,
	ExchangeRate, ExchangeRateCN,
	VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,
	VDescription, VDescription as BDescription,	0 as Status,
	AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate,
	 (Case when TransactionTypeID ='T99' then  B.O01ID else AT1202.O01ID end) as O01ID ,
	 (Case when TransactionTypeID ='T99' then  B.O02ID else AT1202.O02ID end) as O02ID  ,
	 (Case when TransactionTypeID ='T99' then  B.O03ID else AT1202.O03ID end) as O03ID ,
	 (Case when TransactionTypeID ='T99' then  B.O04ID else AT1202.O04ID end) as O04ID  ,
	 (Case when TransactionTypeID ='T99' then  B.O05ID else AT1202.O05ID end) as O05ID  ,

	T01.AnaName as O01Name, T02.AnaName as O02Name,T03.AnaName as O03Name,T04.AnaName as O04Name,T05.AnaName as O05Name

FROM AT9000  	Left join AT1202 on AT1202.ObjectID = AT9000.ObjectID and AT1202.DivisionID = AT9000.DivisionID
		left join AT1202  B on B.ObjectID = AT9000.CreditObjectID 
		Full join AT1005 on AT1005.AccountID = AT9000.CreditAccountID and AT1005.DivisionID = AT9000.DivisionID
		
		Left Join AT1015  T01 on T01.AnaID =  (Case when TransactionTypeID ='T99' then  B.O01ID else AT1202.O01ID end)  and T01.AnaTypeID = 'O01' 
		Left Join AT1015  T02 on T02.AnaID =  (Case when TransactionTypeID ='T99' then  B.O02ID else AT1202.O02ID end)  and T02.AnaTypeID = 'O02'
		Left Join AT1015  T03 on T03.AnaID =  (Case when TransactionTypeID ='T99' then  B.O03ID else AT1202.O03ID end) and T03.AnaTypeID = 'O03'
		Left Join AT1015  T04 on T04.AnaID =  (Case when TransactionTypeID ='T99' then  B.O04ID else AT1202.O04ID end) and T04.AnaTypeID = 'O04'
		Left Join AT1015  T05 on T05.AnaID =  (Case when TransactionTypeID ='T99' then  B.O05ID else AT1202.O05ID end)  and T05.AnaTypeID = 'O05'

		
WHERE CreditAccountID in (Select AccountID From AT1005 Where GroupID ='G04' and  IsObject =1)
Group by VoucherID,BatchID,  TableID,AT9000.DivisionID,TranMonth,TranYear,
	---AT9000.ObjectID, 
	CreditAccountID, AT1005.AccountName, AT9000.CurrencyID, CurrencyIDCN, ExchangeRate,ExchangeRateCN,
	(Case when TransactionTypeID ='T99' then  AT9000.CreditObjectID else AT9000.ObjectID end),
	(Case when TransactionTypeID ='T99' then  B.ObjectName  else AT1202.ObjectName  end),
	CreditObjectID,  
	VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,
	VDescription, ---Status,
	AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate,
	 (Case when TransactionTypeID ='T99' then  B.O01ID else AT1202.O01ID end)  ,
	 (Case when TransactionTypeID ='T99' then  B.O02ID else AT1202.O02ID end)  ,
	 (Case when TransactionTypeID ='T99' then  B.O03ID else AT1202.O03ID end)  ,
	 (Case when TransactionTypeID ='T99' then  B.O04ID else AT1202.O04ID end)  ,
	 (Case when TransactionTypeID ='T99' then  B.O05ID else AT1202.O05ID end) ,

	T01.AnaName , T02.AnaName ,T03.AnaName ,T04.AnaName ,T05.AnaName


GO


