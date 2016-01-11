IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0302_ST]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV0302_ST]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------ Created By on 14/10/2015 by Phuong Thao : Bo sung ket theo khoan muc (Customize Sieu Thanh)
  
CREATE VIEW [dbo].[AV0302_ST] AS   
  
SELECT   '' AS GiveUpID,   
  T9.VoucherID AS VoucherID,  
  T9.CreditAccountID,   
  T9.BatchID,    
  T9.TableID,  T9.DivisionID,T9.TranMonth, T9.TranYear,  
  T9.ObjectID, A.ObjectName,    
  T9.CurrencyID, T9.CurrencyIDCN,  
  ExchangeRate, ExchangeRateCN,  
  VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,  
  VDescription, VDescription AS BDescription,   
  T9.PaymentID, T9.DueDays, T9.DueDate,      
  ISNULL(T3.GivedOriginalAmount, 0) AS GivedOriginalAmount,    
  ISNULL(T3.GivedConvertedAmount,0) AS GivedConvertedAmount,  
  (isnull(T9.OriginalAmount,0)) AS OriginalAmount, STATUS,   
  (isnull(T9.OriginalAmountCN,0)) AS OriginalAmountCN,  
  (isnull(T9.ConvertedAmount,0)) AS ConvertedAmount,   
  ISNULL(T9.Ana01ID,'') AS Ana01ID, ISNULL(T9.AnaName01,'') AS AnaName01,   
  ISNULL(T9.Ana02ID,'') AS Ana02ID, ISNULL(T9.AnaName02,'') AS AnaName02,  
  ISNULL(T9.Ana03ID,'') AS Ana03ID, ISNULL(T9.AnaName03,'') AS AnaName03,  
  ISNULL(T9.Ana04ID,'') AS Ana04ID, ISNULL(T9.AnaName04,'') AS AnaName04,  
  ISNULL(T9.Ana05ID,'') AS Ana05ID, ISNULL(T9.AnaName05,'') AS AnaName05,  
  ISNULL(T9.Ana06ID,'') AS Ana06ID, ISNULL(T9.AnaName06,'') AS AnaName06,  
  ISNULL(T9.Ana07ID,'') AS Ana07ID, ISNULL(T9.AnaName07,'') AS AnaName07,  
  ISNULL(T9.Ana08ID,'') AS Ana08ID, ISNULL(T9.AnaName08,'') AS AnaName08,  
  ISNULL(T9.Ana09ID,'') AS Ana09ID, ISNULL(T9.AnaName09,'') AS AnaName09,  
  ISNULL(T9.Ana10ID,'') AS Ana10ID, ISNULL(T9.AnaName10,'') AS AnaName10

FROM  
(
	SELECT	'' AS GiveUpID, VoucherID AS VoucherID,  
			CreditAccountID, BatchID, TableID, DivisionID,TranMonth, TranYear,  
			ObjectID, ObjectName, CurrencyID, CurrencyIDCN,  
			ExchangeRate, ExchangeRateCN,  VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,  
			VDescription, VDescription AS BDescription,   
			PaymentID, DueDays,DueDate, sum(isnull(OriginalAmount,0)) AS OriginalAmount, STATUS,   
			sum(isnull(OriginalAmountCN,0)) AS OriginalAmountCN,  
			sum(isnull(ConvertedAmount,0)) AS ConvertedAmount,   
			ISNULL(Ana01ID,'') AS Ana01ID, AnaName01,   
			ISNULL(Ana02ID,'') AS Ana02ID, AnaName02, 
			ISNULL(Ana03ID,'') AS Ana03ID, AnaName03,   
			ISNULL(Ana04ID,'') AS Ana04ID, AnaName04,  
			ISNULL(Ana05ID,'') AS Ana05ID, AnaName05,
			ISNULL(Ana06ID,'') AS Ana06ID, AnaName06,   
			ISNULL(Ana07ID,'') AS Ana07ID, AnaName07, 
			ISNULL(Ana08ID,'') AS Ana08ID, AnaName08,   
			ISNULL(Ana09ID,'') AS Ana09ID, AnaName09,  
			ISNULL(Ana10ID,'') AS Ana10ID, AnaName10 
	From AV0312_ST
	Group by    VoucherID, CreditAccountID,   BatchID,  TableID,  DivisionID,TranMonth, TranYear,  
				ObjectID, ObjectName,CurrencyID, CurrencyIDCN,  ExchangeRate, ExchangeRateCN,  
				VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,  
				VDescription, PaymentID, DueDays, DueDate,  STATUS,
				ISNULL(Ana01ID,''), AnaName01,   
				ISNULL(Ana02ID,''), AnaName02, 
				ISNULL(Ana03ID,''), AnaName03,   
				ISNULL(Ana04ID,''), AnaName04,  
				ISNULL(Ana05ID,''), AnaName05,
				ISNULL(Ana06ID,''), AnaName06,   
				ISNULL(Ana07ID,''), AnaName07, 
				ISNULL(Ana08ID,''), AnaName08,   
				ISNULL(Ana09ID,''), AnaName09,  
				ISNULL(Ana10ID,''), AnaName10  
	  ) T9   
LEFT JOIN 
	(SELECT	sum(isnull(T03.ConvertedAmount,0)) AS GivedConvertedAmount,  
			sum(isnull(T03.OriginalAmount,0)) AS GivedOriginalAmount,  
			T03.ObjectID, T03.CreditVoucherID,T03.CreditBatchID, T03.CreditTableID,
			T03.AccountID,  T03.DivisionID,
			ISNULL(T03.Ana01ID,'') AS Ana01ID, ISNULL(T03.Ana02ID,'') AS Ana02ID, ISNULL(T03.Ana03ID,'') AS Ana03ID, ISNULL(T03.Ana04ID,'') AS Ana04ID, ISNULL(T03.Ana05ID,'') AS Ana05ID,
			ISNULL(T03.Ana06ID,'') AS Ana06ID, ISNULL(T03.Ana07ID,'') AS Ana07ID, ISNULL(T03.Ana08ID,'') AS Ana08ID, ISNULL(T03.Ana09ID,'') AS Ana09ID, ISNULL(T03.Ana10ID,'') AS Ana10ID
	FROM	AT0303 T03  
	Group by	T03.ObjectID, T03.CreditVoucherID,T03.CreditBatchID,T03.AccountID,  
				T03.DivisionID , T03.CreditTableID,
				ISNULL(T03.Ana01ID,''), ISNULL(T03.Ana02ID,''), ISNULL(T03.Ana03ID,''), ISNULL(T03.Ana04ID,''), ISNULL(T03.Ana05ID,''),
				ISNULL(T03.Ana06ID,''), ISNULL(T03.Ana07ID,''), ISNULL(T03.Ana08ID,''), ISNULL(T03.Ana09ID,''), ISNULL(T03.Ana10ID,'')  
	)T3  
	ON  T3.ObjectID = T9.ObjectID  
	AND T3.CreditVoucherID = T9.VoucherID 
	AND T3.CreditBatchID = T9.BatchID 
	AND T3.CreditTableID = T9.TableID 
	AND T3.AccountID = T9.CreditAccountID 
	AND T3.DivisionID = T9.DivisionID  	
	AND ISNULL(T3.Ana01ID,'') = ISNULL(T9.Ana01ID,'')
	AND ISNULL(T3.Ana02ID,'') = ISNULL(T9.Ana02ID,'')
	AND ISNULL(T3.Ana03ID,'') = ISNULL(T9.Ana03ID,'')
	AND ISNULL(T3.Ana04ID,'') = ISNULL(T9.Ana04ID,'')
	AND ISNULL(T3.Ana05ID,'') = ISNULL(T9.Ana05ID,'')
	AND ISNULL(T3.Ana06ID,'') = ISNULL(T9.Ana06ID,'')
	AND ISNULL(T3.Ana07ID,'') = ISNULL(T9.Ana07ID,'')
	AND ISNULL(T3.Ana08ID,'') = ISNULL(T9.Ana08ID,'')
	AND ISNULL(T3.Ana09ID,'') = ISNULL(T9.Ana09ID,'')
	AND ISNULL(T3.Ana10ID,'') = ISNULL(T9.Ana10ID,'')
	
INNER JOIN AT1005   
	ON   AT1005.AccountID = T9.CreditAccountID and  
	AT1005.GroupID='G03'  
	AND AT1005.DivisionID = T9.DivisionID  
LEFT JOIN AT1202 A   
	ON  A.ObjectID =  T9.ObjectID  
	AND A.DivisionID = T9.DivisionID  
     
inner join (select Isnull(Max(IsMultiTax),0) as IsMultiTax, DivisionID, VoucherID, MAX(transactiontypeID) as TransactionTypeID 
			from AT9000  Group by DivisionID, VoucherID) T90   ON T9.DivisionID = T90.DivisionID and T9.VoucherID = T90.VoucherID  
Where T90.TransactionTypeID IN ('T24', 'T34', 'T99') and IsMultiTax=0  
    
union all  

SELECT		'' AS GiveUpID,   
			T9.VoucherID AS VoucherID,  
			T9.CreditAccountID,   
			T9.BatchID,    
			T9.TableID,  T9.DivisionID,T9.TranMonth, T9.TranYear,  
			T9.ObjectID, A.ObjectName,    
			T9.CurrencyID, T9.CurrencyIDCN,  
			ExchangeRate, ExchangeRateCN,  
			VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,  
			VDescription, VDescription AS BDescription,   
			T9.PaymentID, T9.DueDays, T9.DueDate,      
			ISNULL(T3.GivedOriginalAmount, 0) AS GivedOriginalAmount,    
			ISNULL(T3.GivedConvertedAmount,0) AS GivedConvertedAmount,  
			(isnull(T9.OriginalAmount,0)) AS OriginalAmount, STATUS,   
			(isnull(T9.OriginalAmountCN,0)) AS OriginalAmountCN,  
			(isnull(T9.ConvertedAmount,0)) AS ConvertedAmount,   
			T9.Ana01ID, T9.AnaName01,   
			T9.Ana02ID, T9.AnaName02,
			T9.Ana03ID, T9.AnaName03,   
			T9.Ana04ID, T9.AnaName04,  
			T9.Ana05ID, T9.AnaName05,
			T9.Ana06ID, T9.AnaName06,   
			T9.Ana07ID, T9.AnaName07,
			T9.Ana08ID, T9.AnaName08,   
			T9.Ana09ID, T9.AnaName09,  
			T9.Ana10ID, T9.AnaName10
FROM (
SELECT  '' AS GiveUpID, VoucherID AS VoucherID,  
			CreditAccountID, BatchID, TableID, DivisionID,TranMonth, TranYear,  
			ObjectID, ObjectName, CurrencyID, CurrencyIDCN,  
			ExchangeRate, ExchangeRateCN,  VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,  
			VDescription, VDescription AS BDescription,   
			PaymentID, DueDays,DueDate, sum(isnull(OriginalAmount,0)+isnull(VaTOriginalAmount,0)) AS OriginalAmount, STATUS,   
			sum(isnull(OriginalAmountCN,0)+isnull(VaTOriginalAmount,0)) AS OriginalAmountCN,  
			sum(isnull(ConvertedAmount,0)+isnull(VatConvertedAmount,0)) AS ConvertedAmount,  
			ISNULL(Ana01ID,'') AS Ana01ID, AnaName01,   
			ISNULL(Ana02ID,'') AS Ana02ID, AnaName02, 
			ISNULL(Ana03ID,'') AS Ana03ID, AnaName03,   
			ISNULL(Ana04ID,'') AS Ana04ID, AnaName04,  
			ISNULL(Ana05ID,'') AS Ana05ID, AnaName05,
			ISNULL(Ana06ID,'') AS Ana06ID, AnaName06,   
			ISNULL(Ana07ID,'') AS Ana07ID, AnaName07, 
			ISNULL(Ana08ID,'') AS Ana08ID, AnaName08,   
			ISNULL(Ana09ID,'') AS Ana09ID, AnaName09,  
			ISNULL(Ana10ID,'') AS Ana10ID, AnaName10 
FROM  AV0312_ST 
Group by    VoucherID, CreditAccountID,   BatchID,  TableID,  DivisionID,TranMonth, TranYear,  
				ObjectID, ObjectName,CurrencyID, CurrencyIDCN,  ExchangeRate, ExchangeRateCN,  
				VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,  
				VDescription, PaymentID, DueDays, DueDate,  STATUS ,
				ISNULL(Ana01ID,''), AnaName01,   
				ISNULL(Ana02ID,''), AnaName02, 
				ISNULL(Ana03ID,''), AnaName03,   
				ISNULL(Ana04ID,''), AnaName04,  
				ISNULL(Ana05ID,''), AnaName05,
				ISNULL(Ana06ID,''), AnaName06,   
				ISNULL(Ana07ID,''), AnaName07, 
				ISNULL(Ana08ID,''), AnaName08,   
				ISNULL(Ana09ID,''), AnaName09,  
				ISNULL(Ana10ID,''), AnaName10
) T9   
LEFT JOIN (SELECT	SUM((isnull(T03.ConvertedAmount,0)) )AS GivedConvertedAmount,  
					SUM((isnull(T03.OriginalAmount,0))) AS GivedOriginalAmount,  
					T03.ObjectID, T03.CreditVoucherID,T03.CreditBatchID, T03.CreditTableID,
					T03.AccountID,  T03.DivisionID,  
					ISNULL(T03.Ana01ID,'') AS Ana01ID, ISNULL(T03.Ana02ID,'') AS Ana02ID, ISNULL(T03.Ana03ID,'') AS Ana03ID, ISNULL(T03.Ana04ID,'') AS Ana04ID, ISNULL(T03.Ana05ID,'') AS Ana05ID,
					ISNULL(T03.Ana06ID,'') AS Ana06ID, ISNULL(T03.Ana07ID,'') AS Ana07ID, ISNULL(T03.Ana08ID,'') AS Ana08ID, ISNULL(T03.Ana09ID,'') AS Ana09ID, ISNULL(T03.Ana10ID,'') AS Ana10ID
			FROM AT0303 T03    
			Group by	T03.ObjectID, T03.CreditVoucherID,T03.CreditBatchID,T03.AccountID,  
						T03.DivisionID , T03.CreditTableID,
						ISNULL(T03.Ana01ID,''), ISNULL(T03.Ana02ID,''), ISNULL(T03.Ana03ID,''), ISNULL(T03.Ana04ID,''), ISNULL(T03.Ana05ID,''),
						ISNULL(T03.Ana06ID,''), ISNULL(T03.Ana07ID,''), ISNULL(T03.Ana08ID,''), ISNULL(T03.Ana09ID,''), ISNULL(T03.Ana10ID,'') 
			)T3  
				ON  T3.ObjectID = T9.ObjectID  and  
				T3.CreditVoucherID = T9.VoucherID AND  
				T3.CreditBatchID = T9.BatchID AND  
				T3.CreditTableID = T9.TableID AND
				T3.AccountID = T9.CreditAccountID AND  
				T3.DivisionID = T9.DivisionID
				AND ISNULL(T3.Ana01ID,'') = ISNULL(T9.Ana01ID,'')
				AND ISNULL(T3.Ana02ID,'') = ISNULL(T9.Ana02ID,'')
				AND ISNULL(T3.Ana03ID,'') = ISNULL(T9.Ana03ID,'')
				AND ISNULL(T3.Ana04ID,'') = ISNULL(T9.Ana04ID,'')
				AND ISNULL(T3.Ana05ID,'') = ISNULL(T9.Ana05ID,'')
				AND ISNULL(T3.Ana06ID,'') = ISNULL(T9.Ana06ID,'')
				AND ISNULL(T3.Ana07ID,'') = ISNULL(T9.Ana07ID,'')
				AND ISNULL(T3.Ana08ID,'') = ISNULL(T9.Ana08ID,'')
				AND ISNULL(T3.Ana09ID,'') = ISNULL(T9.Ana09ID,'')
				AND ISNULL(T3.Ana10ID,'') = ISNULL(T9.Ana10ID,'')  	   
INNER JOIN AT1005   
				ON AT1005.AccountID = T9.CreditAccountID and  
				AT1005.GroupID='G03'  
				AND AT1005.DivisionID = T9.DivisionID  
LEFT JOIN AT1202 A   
				ON  A.ObjectID =  T9.ObjectID  
				AND A.DivisionID = T9.DivisionID       
inner join (select Isnull(Max(IsMultiTax),0) as IsMultiTax, DivisionID, VoucherID, MAX(transactiontypeID) as TransactionTypeID 
			from AT9000  Group by DivisionID, VoucherID) T90  ON T9.DivisionID = T90.DivisionID and T9.VoucherID = T90.VoucherID  
WHERE  (IsMultiTax =1 and  T90.TransactionTypeID not IN ('T34')) or (T90.TransactionTypeID not IN ('T24','T34', 'T99') and IsMultiTax=0)  

  

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

