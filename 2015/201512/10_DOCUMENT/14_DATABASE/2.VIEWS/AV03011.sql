IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AV03011]'))
DROP VIEW [dbo].[AV03011]
GO



/****** Object:  View [dbo].[AV0301]    Script Date: 08/12/2013 11:17:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[AV03011] AS

SELECT A.GiveUpID, A.VoucherID, A.BatchID, A.TableID, A.DivisionID, A.TranMonth, A.TranYear,
	A.ObjectID, A.DebitAccountID, A.CurrencyID, A.CurrencyIDCN, A.ObjectName, 
			A.Ana01ID, A.Ana02ID,A.Ana03ID, A.Ana04ID,A.Ana05ID, A.OriginalAmount + A.VATOriginalAmount  as OriginalAmount,  A.ConvertedAmount + A.VATConvertedAmount  as ConvertedAmount, A.OriginalAmountCN + A.VATOriginalAmount  as OriginalAmountCN,  
		Isnull(T3.GivedOriginalAmount,0) as GivedOriginalAmount,		
	Isnull(T3.GivedConvertedAmount,0)as GivedConvertedAmount,
	A.ExchangeRate,A.ExchangeRateCN,
	A.VoucherTypeID, A.VoucherNo, A.VoucherDate, A.InvoiceDate, A.InvoiceNo, A.Serial,
	A.VDescription, A.BDescription, A.Status,
	A.PaymentID, A.DueDays, A.DueDate
From( SELECT '' AS GiveUpID, VoucherID, BatchID, TableID, AT9000.DivisionID, TranMonth, TranYear,
	AT9000.ObjectID, DebitAccountID, AT9000.CurrencyID, CurrencyIDCN, AT1202.ObjectName, (select Max(IsMultiTax) from AT9000 T90 where T90.DivisionID=AT9000.DivisionID and T90.VoucherID=AT9000.VoucherID) as IsMultiTax,TransactionTypeID,	isnull(AT9000.Ana01ID,'')as Ana01ID, isnull(AT9000.Ana02ID,'')as Ana02ID,
			isnull(AT9000.Ana03ID,'')as Ana03ID,isnull(AT9000.Ana04ID,'')as Ana04ID,isnull(AT9000.Ana05ID,'')as Ana05ID,	Sum(isnull(OriginalAmount,0))as OriginalAmount,  SUM(ISNULL(VATOriginalAmount,0))as VATOriginalAmount,	Sum(isnull(ConvertedAmount,0))as ConvertedAmount,  SUM(ISNULL(VATConvertedAmount,0))as VATConvertedAmount, Sum(isnull(OriginalAmountCN,0)) as OriginalAmountCN, 
	ExchangeRate, ExchangeRateCN,
	VoucherTypeID, VoucherNo, VoucherDate, InvoiceDate, InvoiceNo, Serial,
	VDescription, VDescription AS BDescription, 0 AS Status,
	AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate
FROM AT9000 
Left join AT1202 on AT1202.ObjectID = AT9000.ObjectID and AT1202.DivisionID = AT9000.DivisionID
WHERE DebitAccountID in (Select AccountID From AT1005 Where GroupID ='G03' and  IsObject =1) 
Group by VoucherID, BatchID, TableID, AT9000.DivisionID, TranMonth, TranYear,
	AT9000.ObjectID, DebitAccountID, AT9000.CurrencyID, CurrencyIDCN, AT1202.ObjectName, 
	AT9000.Ana01ID, AT9000.Ana02ID,AT9000.Ana03ID, AT9000.Ana04ID,AT9000.Ana05ID,
	ExchangeRate, ExchangeRateCN,	VoucherTypeID, VoucherNo, VoucherDate, InvoiceDate, InvoiceNo, Serial,
	VDescription, AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate,TransactionTypeID )A

LEFT JOIN	(SELECT isnull(T03.ConvertedAmount,0) AS GivedConvertedAmount,
					isnull(T03.OriginalAmount,0) AS GivedOriginalAmount,
					T03.ObjectID, T03.DebitVoucherID,T03.DebitBatchID,T03.AccountID,
					T03.DivisionID
					
			 FROM	AT0303 T03 
         	 
			 )T3
	ON		T3.ObjectID = A.ObjectID  and
			T3.DebitVoucherID = A.VoucherID AND
			T3.DebitBatchID = A.BatchID AND
			T3.AccountID = A.DebitAccountID AND
			T3.DivisionID = A.DivisionID
			and T3.GivedConvertedAmount = A.ConvertedAmount+A.VATConvertedAmount
			and T3.GivedOriginalAmount = A.OriginalAmount + A.VATOriginalAmount
where  TransactionTypeID <>'T14'


