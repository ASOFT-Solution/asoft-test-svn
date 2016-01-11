IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0312_ST]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV0312_ST]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- <Summary>
---- Customize Sieu Thanh
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 16/10/2015 by Phuong Thao : Customize Sieu Thanh: Giai tru theo phong ban (Ma phan tich)
----

-- <Example>
----



CREATE VIEW [dbo].[AV0312_ST] AS

SELECT	'' AS GiveUpID, AT9000.VoucherID, BatchID, TableID, AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear,
		(CASE WHEN TransactionTypeID = 'T99' THEN AT9000.CreditObjectID ELSE AT9000.ObjectID END) AS ObjectID, 
		CreditAccountID, AT9000.CurrencyID, CurrencyIDCN,
		(CASE WHEN TransactionTypeID = 'T99' THEN B.ObjectName ELSE A.ObjectName  END)  AS  ObjectName,
		SUM(ISNULL(OriginalAmount,0)) AS OriginalAmount,
		SUM(ISNULL(ConvertedAmount,0)) AS ConvertedAmount, 
		SUM(ISNULL(OriginalAmountCN,0)) AS OriginalAmountCN,	
		SUM(isnull(VATOriginalAmount,0))as VATOriginalAmount,
		Sum(isnull(VATConvertedAmount,0)) as VATConvertedAmount,
		AT9000.TransactionTypeID,
		AT9000.ExchangeRate, ExchangeRateCN, STATUS, AT9000.VoucherTypeID, AT9000.VoucherNo, VoucherDate,
		Isnull(InvoiceDate,VoucherDate) AS InvoiceDate, InvoiceNo, Serial,
		VDescription, VDescription AS BDescription, VDescription AS CDescription, AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate, 	
		AT9000.Ana01ID AS Ana01ID, 
		AT9000.Ana02ID AS Ana02ID, 
		AT9000.Ana03ID AS Ana03ID, 
		AT9000.Ana04ID AS Ana04ID, 
		AT9000.Ana05ID AS Ana05ID,
		AT9000.Ana06ID As Ana06ID, 
		AT9000.Ana07ID As Ana07ID, 
		AT9000.Ana08ID As Ana08ID, 
		AT9000.Ana09ID As Ana09ID, 
		AT9000.Ana10ID As Ana10ID,  
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
		MAX(AT9000.Parameter01) AS Parameter01,
		MAX(AT9000.Parameter02) AS Parameter02,
		MAX(AT9000.Parameter03) AS Parameter03,
		MAX(AT9000.Parameter04) AS Parameter04,
		MAX(AT9000.Parameter05) AS Parameter05,
		MAX(AT9000.Parameter06) AS Parameter06,
		MAX(AT9000.Parameter07) AS Parameter07,
		MAX(AT9000.Parameter08) AS Parameter08,
		MAX(AT9000.Parameter09) AS Parameter09,
		MAX(AT9000.Parameter10) AS Parameter10,
		MAX(OT2001.SOrderID) AS SOrderID, MAX(OT2001.OrderDate) AS OrderDate, OT2001.ClassifyID,
		(CASE WHEN TransactionTypeID = 'T99' THEN  B.O01ID ELSE A.O01ID END) AS O01ID ,
		(CASE WHEN TransactionTypeID = 'T99' THEN  B.O02ID ELSE A.O02ID END) AS O02ID ,
		(CASE WHEN TransactionTypeID = 'T99' THEN  B.O03ID ELSE A.O03ID END) AS O03ID ,
		(CASE WHEN TransactionTypeID = 'T99' THEN  B.O04ID ELSE A.O04ID END) AS O04ID ,
		(CASE WHEN TransactionTypeID = 'T99' THEN  B.O05ID ELSE A.O05ID END) AS O05ID ,
		T01.AnaName AS O01Name, 
		T02.AnaName AS O02Name,
		T03.AnaName AS O03Name,
		T04.AnaName AS O04Name,
		T05.AnaName AS O05Name
FROM AT9000 	
LEFT JOIN AT1202  A ON A.ObjectID = AT9000.ObjectID AND A.DivisionID = AT9000.DivisionID
LEFT JOIN AT1202  B ON B.ObjectID = AT9000.CreditObjectID AND B.DivisionID = AT9000.DivisionID 
INNER JOIN AT1005 ON AT1005.AccountID = AT9000.CreditAccountID AND GroupID ='G03' AND  IsObject =1 AND AT1005.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 A01 ON A01.AnaID = AT9000.Ana01ID AND A01.AnaTypeID ='A01' AND A01.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 A02 ON A02.AnaID = AT9000.Ana02ID AND A02.AnaTypeID ='A02' AND A02.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 A03 ON A03.AnaID = AT9000.Ana03ID AND A03.AnaTypeID ='A03' AND A03.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 A04 ON A04.AnaID = AT9000.Ana04ID AND A04.AnaTypeID ='A04' AND A04.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 A05 ON A05.AnaID = AT9000.Ana05ID AND A05.AnaTypeID ='A05' AND A05.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 A06 ON A06.AnaID = AT9000.Ana06ID AND A06.AnaTypeID ='A06' AND A06.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 A07 ON A07.AnaID = AT9000.Ana07ID AND A07.AnaTypeID ='A07' AND A07.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 A08 ON A08.AnaID = AT9000.Ana08ID AND A08.AnaTypeID ='A08' AND A08.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 A09 ON A09.AnaID = AT9000.Ana09ID AND A09.AnaTypeID ='A09' AND A09.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 A10 ON A10.AnaID = AT9000.Ana10ID AND A10.AnaTypeID ='A10' AND A10.DivisionID = AT9000.DivisionID

LEFT JOIN  OT2001 ON OT2001.SOrderID = AT9000.OrderID	and OT2001.DivisionID = AT9000.DivisionID	
LEFT JOIN AT1015  T01 ON T01.DivisionID = AT9000.DivisionID	and T01.AnaID =  (CASE WHEN TransactionTypeID ='T99' THEN  B.O01ID ELSE A.O01ID END)  AND T01.AnaTypeID = 'O01' 
LEFT JOIN AT1015  T02 ON T02.DivisionID = AT9000.DivisionID	and T02.AnaID =  (CASE WHEN TransactionTypeID ='T99' THEN  B.O02ID ELSE A.O02ID END)  AND T02.AnaTypeID = 'O02'
LEFT JOIN AT1015  T03 ON T03.DivisionID = AT9000.DivisionID	and T03.AnaID =  (CASE WHEN TransactionTypeID ='T99' THEN  B.O03ID ELSE A.O03ID END) AND T03.AnaTypeID = 'O03'
LEFT JOIN AT1015  T04 ON T04.DivisionID = AT9000.DivisionID	and T04.AnaID =  (CASE WHEN TransactionTypeID ='T99' THEN  B.O04ID ELSE A.O04ID END) AND T04.AnaTypeID = 'O04'
LEFT JOIN AT1015  T05 ON T05.DivisionID = AT9000.DivisionID	and T05.AnaID =  (CASE WHEN TransactionTypeID ='T99' THEN  B.O05ID ELSE A.O05ID END)  AND T05.AnaTypeID = 'O05'
GROUP BY AT9000.VoucherID, BatchID, TableID, AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear,AT9000.TransactionTypeID,
		(CASE WHEN TransactionTypeID ='T99' THEN  AT9000.CreditObjectID ELSE AT9000.ObjectID END),
		CreditAccountID, AT9000.CurrencyID, CurrencyIDCN, 
		(CASE WHEN TransactionTypeID ='T99' THEN  B.ObjectName  ELSE A.ObjectName  END),
		AT9000.ExchangeRate, ExchangeRateCN, STATUS, AT9000.VoucherTypeID, AT9000.VoucherNo, VoucherDate,
		InvoiceDate, InvoiceNo, Serial, VDescription, VDescription, VDescription, AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate, 
		OT2001.ClassifyID,
		(CASE WHEN TransactionTypeID ='T99' THEN  B.O01ID ELSE A.O01ID END)  ,
		(CASE WHEN TransactionTypeID ='T99' THEN  B.O02ID ELSE A.O02ID END)  ,
		(CASE WHEN TransactionTypeID ='T99' THEN  B.O03ID ELSE A.O03ID END)  ,
		(CASE WHEN TransactionTypeID ='T99' THEN  B.O04ID ELSE A.O04ID END)  ,
		(CASE WHEN TransactionTypeID ='T99' THEN  B.O05ID ELSE A.O05ID END) ,
		T01.AnaName , T02.AnaName ,T03.AnaName ,T04.AnaName ,T05.AnaName
		, OT2001.ClassifyID,
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
		A01.AnaName,
		A02.AnaName,
		A03.AnaName,
		A04.AnaName,
		A05.AnaName,
		A06.AnaName,
		A07.AnaName,
		A08.AnaName,
		A09.AnaName,
		A10.AnaName






GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

