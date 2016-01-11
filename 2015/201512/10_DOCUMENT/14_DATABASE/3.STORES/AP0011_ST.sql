IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0011_ST]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0011_ST]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by: Khanh Van
---- Date: 23/09/2013
---- Purpose: Cai thien toc do man hinh giai tru cong no phai thu
---- Modify by Phuong Thao on 07/10/2015: Chinh sua lai cach luu bang AT0302
---- Exec AP0011 'STH', '%', '13611'

CREATE PROCEDURE [dbo].[AP0011_ST] 
		@DivisionID nvarchar(50),
		@ObjectID nvarchar(50),
		@AccountID nvarchar(50)


			
AS  
  
Declare @sqlSelect as nvarchar(4000) =N'',  
  @sqlSelect1 as nvarchar(4000) =N'',  
  @sqlSelect2 as nvarchar(4000) =N'',  
    @sqlSelect3 as nvarchar(4000) =N'', 
  @sqlExec as nvarchar(4000) =N'',  
  @sqlExec1 as nvarchar(4000) =N'',  
  @sqlExec2 as nvarchar(4000) =N''  
  
Set @sqlExec = N'   
SELECT '''' as Dem, '''' AS GiveUpID, AT9000.VoucherID, BatchID, TableID, AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear,  
  (CASE WHEN TransactionTypeID = ''T99'' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) AS ObjectID,   
  CreditAccountID, AT9000.CurrencyID, CurrencyIDCN,  
  (CASE WHEN TransactionTypeID = ''T99'' THEN B.ObjectName ELSE A.ObjectName  END)  AS  ObjectName,  
  SUM(ISNULL(OriginalAmount,0)) AS OriginalAmount,  
  SUM(ISNULL(ConvertedAmount,0)) AS ConvertedAmount,   
  SUM(ISNULL(OriginalAmountCN,0)) AS OriginalAmountCN,   
  SUM(isnull(VATOriginalAmount,0))as VATOriginalAmount,  
  Sum(isnull(VATConvertedAmount,0)) as VATConvertedAmount,  
  MAX(AT9000.TransactionTypeID) AS TransactionTypeID,  
  AT9000.ExchangeRate, ExchangeRateCN, STATUS, AT9000.VoucherTypeID, AT9000.VoucherNo, VoucherDate,  
  Isnull(InvoiceDate,VoucherDate) AS InvoiceDate, InvoiceNo, Serial,  
  VDescription, VDescription AS BDescription, VDescription AS CDescription, AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate,    
  AT9000.Ana01ID,   
  AT9000.Ana02ID,   
  AT9000.Ana03ID,   
  AT9000.Ana04ID,   
  AT9000.Ana05ID,  
  AT9000.Ana06ID,   
  AT9000.Ana07ID,   
  AT9000.Ana08ID,   
  AT9000.Ana09ID,   
  AT9000.Ana10ID,    
  A01.AnaName AS AnaName01,  
  A02.AnaName AS AnaName02,  
  A03.AnaName AS AnaName03,  
  A04.AnaName AS AnaName04,  
  A05.AnaName AS AnaName05,  
  A06.AnaName AS AnaName06,  
  A07.AnaName AS AnaName07,  
  A08.AnaName AS AnaName08,  
  A09.AnaName AS AnaName09,  
  A10.AnaName AS AnaName10,  
  AT9000.Parameter01,  
  AT9000.Parameter02,  
  AT9000.Parameter03,  
  AT9000.Parameter04,  
  AT9000.Parameter05,  
  AT9000.Parameter06,  
  AT9000.Parameter07,  
  AT9000.Parameter08,  
  AT9000.Parameter09,  
  AT9000.Parameter10,  
  OT2001.SOrderID, OT2001.OrderDate, OT2001.ClassifyID,  
  (CASE WHEN TransactionTypeID = ''T99'' THEN  B.O01ID ELSE A.O01ID END) AS O01ID ,  
  (CASE WHEN TransactionTypeID = ''T99'' THEN  B.O02ID ELSE A.O02ID END) AS O02ID ,  
  (CASE WHEN TransactionTypeID = ''T99'' THEN  B.O03ID ELSE A.O03ID END) AS O03ID ,  
  (CASE WHEN TransactionTypeID = ''T99'' THEN  B.O04ID ELSE A.O04ID END) AS O04ID ,  
  (CASE WHEN TransactionTypeID = ''T99'' THEN  B.O05ID ELSE A.O05ID END) AS O05ID ,  
  T01.AnaName AS O01Name,   
  T02.AnaName AS O02Name,  
  T03.AnaName AS O03Name,  
  T04.AnaName AS O04Name,  
  T05.AnaName AS O05Name'  
Set @sqlExec1 = N'  
into #AV0312  
FROM AT9000    
LEFT JOIN AT1202  A ON A.ObjectID = AT9000.ObjectID AND A.DivisionID = AT9000.DivisionID  
LEFT JOIN AT1202  B ON B.ObjectID = AT9000.CreditObjectID AND B.DivisionID = AT9000.DivisionID   
INNER JOIN AT1005 ON AT1005.AccountID = AT9000.CreditAccountID AND GroupID =''G03'' AND  IsObject =1
 AND AT1005.DivisionID = AT9000.DivisionID  
LEFT JOIN AT1011 A01 ON A01.AnaID = AT9000.Ana01ID AND A01.AnaTypeID =''A01'' AND A01.DivisionID = AT9000.DivisionID  
LEFT JOIN AT1011 A02 ON A02.AnaID = AT9000.Ana02ID AND A02.AnaTypeID =''A02'' AND A02.DivisionID = AT9000.DivisionID  
LEFT JOIN AT1011 A03 ON A03.AnaID = AT9000.Ana03ID AND A03.AnaTypeID =''A03'' AND A03.DivisionID = AT9000.DivisionID  
LEFT JOIN AT1011 A04 ON A04.AnaID = AT9000.Ana04ID AND A04.AnaTypeID =''A04'' AND A04.DivisionID = AT9000.DivisionID  
LEFT JOIN AT1011 A05 ON A05.AnaID = AT9000.Ana05ID AND A05.AnaTypeID =''A05'' AND A05.DivisionID = AT9000.DivisionID  
LEFT JOIN AT1011 A06 ON A06.AnaID = AT9000.Ana06ID AND A06.AnaTypeID =''A06'' AND A06.DivisionID = AT9000.DivisionID  
LEFT JOIN AT1011 A07 ON A07.AnaID = AT9000.Ana07ID AND A07.AnaTypeID =''A07'' AND A07.DivisionID = AT9000.DivisionID  
LEFT JOIN AT1011 A08 ON A08.AnaID = AT9000.Ana08ID AND A08.AnaTypeID =''A08'' AND A08.DivisionID = AT9000.DivisionID  
LEFT JOIN AT1011 A09 ON A09.AnaID = AT9000.Ana09ID AND A09.AnaTypeID =''A09'' AND A09.DivisionID = AT9000.DivisionID  
LEFT JOIN AT1011 A10 ON A10.AnaID = AT9000.Ana10ID AND A10.AnaTypeID =''A10'' AND A10.DivisionID = AT9000.DivisionID  
LEFT JOIN  OT2001 ON OT2001.SOrderID = AT9000.OrderID and OT2001.DivisionID = AT9000.DivisionID   
LEFT JOIN AT1015  T01 ON T01.DivisionID = AT9000.DivisionID and T01.AnaID =  (CASE WHEN TransactionTypeID =''T99'' THEN  B.O01ID ELSE A.O01ID END)  AND T01.AnaTypeID = ''O01''   
LEFT JOIN AT1015  T02 ON T02.DivisionID = AT9000.DivisionID and T02.AnaID =  (CASE WHEN TransactionTypeID =''T99'' THEN  B.O02ID ELSE A.O02ID END)  AND T02.AnaTypeID = ''O02''  
LEFT JOIN AT1015  T03 ON T03.DivisionID = AT9000.DivisionID and T03.AnaID =  (CASE WHEN TransactionTypeID =''T99'' THEN  B.O03ID ELSE A.O03ID END) AND T03.AnaTypeID = ''O03''  
LEFT JOIN AT1015  T04 ON T04.DivisionID = AT9000.DivisionID and T04.AnaID =  (CASE WHEN TransactionTypeID =''T99'' THEN  B.O04ID ELSE A.O04ID END) AND T04.AnaTypeID = ''O04''  
LEFT JOIN AT1015  T05 ON T05.DivisionID = AT9000.DivisionID and T05.AnaID =  (CASE WHEN TransactionTypeID =''T99'' THEN  B.O05ID ELSE A.O05ID END)  AND T05.AnaTypeID = ''O05'''  
Set @sqlExec2 = N'  
Where AT9000.DivisionID = '''+@DivisionID+''' and (CASE WHEN TransactionTypeID = ''T99'' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END)like ('''+@ObjectID+''') and CreditAccountID like ('''+@AccountID+''')  
GROUP BY AT9000.VoucherID, BatchID, TableID, AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear, -- AT9000.TransactionTypeID,  
  (CASE WHEN TransactionTypeID =''T99'' THEN  AT9000.CreditObjectID ELSE AT9000.ObjectID END),  
  CreditAccountID, AT9000.CurrencyID, CurrencyIDCN,   
  (CASE WHEN TransactionTypeID =''T99'' THEN  B.ObjectName  ELSE A.ObjectName  END),  
  AT9000.ExchangeRate, ExchangeRateCN, STATUS, AT9000.VoucherTypeID, AT9000.VoucherNo, VoucherDate,  
  InvoiceDate, InvoiceNo, Serial, VDescription, VDescription, VDescription, AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate,   
  OT2001.ClassifyID,  
  (CASE WHEN TransactionTypeID =''T99'' THEN  B.O01ID ELSE A.O01ID END)  ,  
  (CASE WHEN TransactionTypeID =''T99'' THEN  B.O02ID ELSE A.O02ID END)  ,  
  (CASE WHEN TransactionTypeID =''T99'' THEN  B.O03ID ELSE A.O03ID END)  ,  
  (CASE WHEN TransactionTypeID =''T99'' THEN  B.O04ID ELSE A.O04ID END)  ,  
  (CASE WHEN TransactionTypeID =''T99'' THEN  B.O05ID ELSE A.O05ID END) ,  
  T01.AnaName , T02.AnaName ,T03.AnaName ,T04.AnaName ,T05.AnaName,AT9000.Ana01ID,   
  AT9000.Ana02ID,   
  AT9000.Ana03ID,   
  AT9000.Ana04ID,   
  AT9000.Ana05ID,  
  AT9000.Ana06ID,   
  AT9000.Ana07ID,   
  AT9000.Ana08ID,   
  AT9000.Ana09ID,   
  AT9000.Ana10ID,    
  A01.AnaName,  
  A02.AnaName,  
  A03.AnaName,  
  A04.AnaName,  
  A05.AnaName,  
  A06.AnaName,  
  A07.AnaName,  
  A08.AnaName,  
  A09.AnaName,  
  A10.AnaName,  
  AT9000.Parameter01,  
  AT9000.Parameter02,  
  AT9000.Parameter03,  
  AT9000.Parameter04,  
  AT9000.Parameter05,  
  AT9000.Parameter06,  
  AT9000.Parameter07,  
  AT9000.Parameter08,  
  AT9000.Parameter09,  
  AT9000.Parameter10,  
  OT2001.SOrderID, OT2001.OrderDate, OT2001.ClassifyID  
  '  
  Set @sqlSelect3 = N' 
  
  Select Count(BatchID) as Dem, VoucherID, BatchID, DivisionID 
  Into #Temp
  from #AV0312 group by DivisionID,VoucherID, BatchID
  select * from #Temp
  
  Update A
  set A.Dem = B.Dem
From #AV0312 A inner join #Temp B on A.DivisionID = B.DivisionID and A.VoucherID = B.VoucherID and A.BatchID =B.BatchID
  '
Set @sqlSelect = N'  
Delete AT0302  
WHERE DivisionID = '''+@DivisionID+''' and ObjectID like ('''+@ObjectID+''') and CreditAccountID like ('''+@AccountID+''')  
Insert into AT0302 (GiveUpID, VoucherID, BatchID,  TableID, DivisionID,TranMonth,TranYear,  
    ObjectID, CreditAccountID, CurrencyID, CurrencyIDCN,  
    ObjectName, OriginalAmount,ConvertedAmount,  
    OriginalAmountCN, GivedOriginalAmount,  GivedConvertedAmount,   ExchangeRate, ExchangeRateCN,  
    VoucherTypeID, VoucherNO, VoucherDate,  InvoiceDate,InvoiceNo, Serial,  
    VDescription,BDescription,  Status,   PaymentID, DueDays, DueDate)  
SELECT GiveUpID, VoucherID, BatchID,  TableID, DivisionID,TranMonth,TranYear,  
	ObjectID, CreditAccountID, CurrencyID, CurrencyIDCN,  
	ObjectName , MAX(OriginalAmount) AS OriginalAmount, MAX(ConvertedAmount) AS ConvertedAmount,  
	MAX(OriginalAmountCN) AS OriginalAmountCN,
	SUM(GivedOriginalAmount) AS GivedOriginalAmount,
	SUM(GivedConvertedAmount) AS GivedConvertedAmount,  ExchangeRate, ExchangeRateCN,  
	VoucherTypeID, VoucherNO, VoucherDate,  InvoiceDate,InvoiceNo, Serial,  
	VDescription,BDescription,  Status, PaymentID , DueDays, DueDate
FROM 
    (
    SELECT GiveUpID, VoucherID, BatchID,  TableID, DivisionID,TranMonth,TranYear,  
    ObjectID, CreditAccountID, CurrencyID, CurrencyIDCN,  
    ObjectName , OriginalAmount, ConvertedAmount,  
    OriginalAmountCN,GivedOriginalAmount,GivedConvertedAmount,  ExchangeRate, ExchangeRateCN,  
    VoucherTypeID, VoucherNO, VoucherDate,  InvoiceDate,InvoiceNo, Serial,  
    VDescription,BDescription,  Status, PaymentID , DueDays, DueDate  
    From  
      '  
  
Set @sqlSelect1 = N'  

	(SELECT   '''' AS GiveUpID,   
	  T9.VoucherID AS VoucherID,  
	  T9.CreditAccountID,   
	  T9.BatchID,    
	  T9.TableID,  T9.DivisionID,T9.TranMonth, T9.TranYear,  
	  T9.ObjectID, T9.ObjectName,    
	  T9.CurrencyID, T9.CurrencyIDCN,  
	  ExchangeRate, ExchangeRateCN,  
	  VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,  
	  VDescription, VDescription AS BDescription,   
	  T9.PaymentID, T9.DueDays, T9.DueDate,      
	  ISNULL(T3.GivedOriginalAmount, 0) AS GivedOriginalAmount,    
	  ISNULL(T3.GivedConvertedAmount,0) AS GivedConvertedAmount,  
	  Isnull(T9.OriginalAmount,0) AS OriginalAmount, STATUS,   
	  Isnull(T9.OriginalAmountCN,0) AS OriginalAmountCN,  
	  Isnull(T9.ConvertedAmount,0) AS ConvertedAmount,   
	  T9.Ana01ID, T9.AnaName01,   
	  T9.Ana02ID, T9.AnaName02,  
	  T9.Ana03ID, T9.AnaName03,  
	  T9.Ana04ID, T9.AnaName04,  
	  T9.Ana05ID, T9.AnaName05  
	FROM  (SELECT  Dem, '''' AS GiveUpID, VoucherID AS VoucherID,    
	  CreditAccountID, BatchID, TableID, DivisionID,TranMonth, TranYear,    
	  ObjectID, ObjectName, CurrencyID, CurrencyIDCN,    
	  ExchangeRate, ExchangeRateCN,  VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,    
	  VDescription, VDescription AS BDescription,     
	  PaymentID, DueDays,DueDate, sum(isnull(OriginalAmount,0)) AS OriginalAmount, STATUS,     
	  sum(isnull(OriginalAmountCN,0)) AS OriginalAmountCN,    
	  sum(isnull(ConvertedAmount,0)) AS ConvertedAmount,     
	  max(Ana01ID) as Ana01ID, max(AnaName01) as AnaName01,     
	  max(Ana02ID) as Ana02ID, max(AnaName02) as AnaName02,   
	  max(Ana03ID) as Ana03ID, max(AnaName03) as AnaName03,     
	  max(Ana04ID) as Ana04ID, max(AnaName04) as AnaName04,    
	  max(Ana05ID) as Ana05ID, max(AnaName05) as AnaName05
	   From #AV0312  
	  Where TransactionTypeID IN (''T24'', ''T34'',''T99'')   
	 Group by    Dem, VoucherID, CreditAccountID,   BatchID,  TableID,  DivisionID,TranMonth, TranYear,    
	  ObjectID, ObjectName,CurrencyID, CurrencyIDCN,  ExchangeRate, ExchangeRateCN,    
	  VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,    
	  VDescription, PaymentID, DueDays, DueDate,  STATUS    
	  )  T9   
	 LEFT JOIN (SELECT sum(isnull(T03.ConvertedAmount,0)) AS GivedConvertedAmount,  
	 sum(isnull(T03.OriginalAmount,0)) AS GivedOriginalAmount,  
	 T03.ObjectID, T03.CreditVoucherID,T03.CreditBatchID,T03.AccountID, T03.CreditTableID, T03.DivisionID  
	 FROM AT0303 T03  
	 Where DivisionID = '''+@DivisionID+''' and ObjectID like ('''+@ObjectID+''') and AccountID like ('''+@AccountID+''')  
	 Group by T03.ObjectID, T03.CreditVoucherID,T03.CreditBatchID,T03.AccountID,  T03.CreditTableID, T03.DivisionID  
  
	)T3  
	 ON			T3.ObjectID = T9.ObjectID
			AND	T3.AccountID = T9.CreditAccountID 
			AND	T3.DivisionID = T9.DivisionID   
			AND	T3.CreditVoucherID = T9.VoucherID 
			AND	T3.CreditBatchID = T9.BatchID 		 
			AND T3.CreditTableID = T9.TableID
     
	inner join 
		(select Isnull(Max(IsMultiTax),0) as IsMultiTax, DivisionID, VoucherID, MAX(transactiontypeID) as TransactionTypeID 
		from AT9000    
		Where DivisionID = '''+@DivisionID+''' and (CASE WHEN TransactionTypeID = ''T99'' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END)like ('''+@ObjectID+''') and CreditAccountID like ('''+@AccountID+''') and TransactionTypeID IN (''T24'', ''T34'',''T99'')  
		Group by DivisionID, VoucherID) T90   ON T9.VoucherID = T90.VoucherID  

	Where  IsMultiTax=0  
'  
  
Set @sqlSelect2 = N'  
	union all  
	SELECT   '''' AS GiveUpID,   
	  T9.VoucherID AS VoucherID,  
	  T9.CreditAccountID,   
	  T9.BatchID,    
	  T9.TableID,  T9.DivisionID,T9.TranMonth, T9.TranYear,  
	  T9.ObjectID, T9.ObjectName,    
	  T9.CurrencyID, T9.CurrencyIDCN,  
	  ExchangeRate, ExchangeRateCN,  
	  VoucherTypeID, VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,  
	  VDescription, VDescription AS BDescription,   
	  T9.PaymentID, T9.DueDays, T9.DueDate,      
	  ISNULL(T3.GivedOriginalAmount, 0) AS GivedOriginalAmount,    
	  ISNULL(T3.GivedConvertedAmount,0) AS GivedConvertedAmount,  
	  Isnull(T9.OriginalAmount,0)+Isnull(T9.VaTOriginalAmount,0) AS OriginalAmount, STATUS,   
	  Isnull(T9.OriginalAmountCN,0)+Isnull(T9.VaTOriginalAmount,0) AS OriginalAmountCN,  
	  Isnull(T9.ConvertedAmount,0)+Isnull(T9.VatConvertedAmount,0) AS ConvertedAmount,   
	  T9.Ana01ID, T9.AnaName01,   
	  T9.Ana02ID, T9.AnaName02,  
	  T9.Ana03ID, T9.AnaName03,  
	  T9.Ana04ID, T9.AnaName04,  
	  T9.Ana05ID, T9.AnaName05  
	FROM  #AV0312 T9   
	 LEFT JOIN (SELECT (isnull(T03.ConvertedAmount,0)) AS GivedConvertedAmount,  
	 (isnull(T03.OriginalAmount,0)) AS GivedOriginalAmount,  
	 T03.ObjectID, T03.CreditVoucherID,T03.CreditBatchID,T03.AccountID,  
	 T03.DivisionID  
	 FROM AT0303 T03  
	 Where DivisionID = '''+@DivisionID+''' and ObjectID like ('''+@ObjectID+''') and AccountID like ('''+@AccountID+''')  
  
	)T3  
	 ON  T3.CreditVoucherID = T9.VoucherID AND  
	   T3.CreditBatchID = T9.BatchID   
	   and  (Case when Dem >1 then T3.GivedConvertedAmount else T9.ConvertedAmount+T9.VatConvertedAmount  end) = T9.ConvertedAmount+T9.VatConvertedAmount  
	   and (Case when Dem >1 then T3.GivedOriginalAmount else T9.OriginalAmount+T9.VaTOriginalAmount end)= T9.OriginalAmount+T9.VaTOriginalAmount       
	inner join 
		(select Isnull(Max(IsMultiTax),0) as IsMultiTax, DivisionID, VoucherID 
		from AT9000    
		Where DivisionID = '''+@DivisionID+''' and (CASE WHEN TransactionTypeID = ''T99'' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END)like ('''+@ObjectID+''') and CreditAccountID like ('''+@AccountID+''')  
		Group by DivisionID, VoucherID) T90  ON T9.VoucherID = T90.VoucherID  

	Where (IsMultiTax =1 and  TransactionTypeID not IN (''T34'')) or   
			(TransactionTypeID not IN (''T24'',''T34'',''T99'') and IsMultiTax=0) 
	) A
) T
GROUP BY GiveUpID, VoucherID, BatchID,  TableID, DivisionID,TranMonth,TranYear,  
		ObjectID, CreditAccountID, CurrencyID, CurrencyIDCN,  
		ObjectName ,  ExchangeRate, ExchangeRateCN,  
		VoucherTypeID, VoucherNO, VoucherDate,  InvoiceDate,InvoiceNo, Serial,  
		VDescription,BDescription,  Status, PaymentID , DueDays, DueDate
'  
 
 --Print @sqlExec
 --Print @sqlExec1
 --Print @sqlExec2
 --Print @sqlSelect3
 --Print @sqlSelect
 --Print @sqlSelect1
 --Print @sqlSelect2
Exec(@sqlExec + @sqlExec1 + @sqlExec2 +  @sqlSelect3+  @sqlSelect +  @sqlSelect1 +  @sqlSelect2)  
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
