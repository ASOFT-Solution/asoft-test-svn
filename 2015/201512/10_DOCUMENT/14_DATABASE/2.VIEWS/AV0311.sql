/****** Object:  View [dbo].[AV0311]    Script Date: 01/18/2011 16:21:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--View chet
--Purpose Ph¸t sinh c«ng nî ph¶i thu (B¸o c¸o)
--Last Edit: Thuy Tuyen date 04/06/2008,18/06/2009 
-- last edit : Thuy Tuyen , them cac truong O Code, date 15/07/2009
---- Modified on 19/11/2012 by Thiên Huỳnh: Lấy Max Khoản mục, không Group By
---- Modified on 11/03/2013 by Le Thi Thu Hien : Bo sung them 1 so truong
----Modified on 05/03/2014 by Mai Duyen : Bo sung them 1 so truong phuc vu cho bao cao King Com

ALTER VIEW [dbo].[AV0311] as
SELECT	'' As GiveUpID,  AT9000.VoucherID, BatchID,  TableID, AT9000.DivisionID,AT9000.TranMonth,AT9000.TranYear,
		AT9000.ObjectID, DebitAccountID, AT1005.AccountName as DebitAccountName,
		AT9000.CurrencyID, CurrencyIDCN, 
		AT1202.ObjectName,
		Sum(isnull(OriginalAmount,0)) as OriginalAmount,Sum(isnull(ConvertedAmount,0)) as ConvertedAmount, 
		Sum(isnull(OriginalAmountCN,0)) as OriginalAmountCN,	
		AT9000.ExchangeRate, ExchangeRateCN,
		AT9000.VoucherTypeID, AT9000.VoucherNO, VoucherDate,Isnull (InvoiceDate, VoucherDate) as InvoiceDate  ,InvoiceNo, Serial,
		VDescription, VDescription as BDescription, Status,
		BDescription as CDescription,
		AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate,
		MAX(AT9000.Ana01ID) AS Ana01ID, 
		MAX(AT9000.Ana02ID) AS Ana02ID, 
		MAX(AT9000.Ana03ID) AS Ana03ID, 
		MAX(AT9000.Ana04ID) AS Ana04ID, 
		MAX(AT9000.Ana05ID) AS Ana05ID,
		Max(AT9000.Ana06ID) As Ana06ID, 
		Max(AT9000.Ana07ID) As Ana07ID, 
		Max(AT9000.Ana08ID) As Ana08ID, 
		Max(AT9000.Ana09ID) As Ana09ID, 
		Max(AT9000.Ana10ID) As Ana10ID,  
		MAX(A01.AnaName) AS AnaName01,
		MAX(A02.AnaName) AS AnaName02,
		MAX(A03.AnaName) AS AnaName03,
		MAX(A04.AnaName) AS AnaName04,
		MAX(A05.AnaName) AS AnaName05,
		MAX(A06.AnaName) AS AnaName06,
		MAX(A07.AnaName) AS AnaName07,
		MAX(A08.AnaName) AS AnaName08,
		MAX(A09.AnaName) AS AnaName09,
		MAX(A10.AnaName) AS AnaName10,
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

	OT2001.SOrderID, OT2001.OrderDate,OT2001.ClassifyID,
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID,AT1202.O04ID, AT1202.O05ID,
	
	T01.AnaName as O01Name, T02.AnaName as O02Name,T03.AnaName as O03Name,T04.AnaName as O04Name,T05.AnaName as O05Name,
	Max(OT2001.SalesManID) as SalesManID,MAX(AT9000.PaymentTermID) AS PaymentTermID,MAX(OT2001.VoucherNo) as SOrderNo,
	MAX(isnull(TDescription, isnull(BDescription,VDescription))) as [Description], T02.AnaName as SalesMan

FROM AT9000 	
Left join AT1202 on AT1202.ObjectID = AT9000.ObjectID and AT1202.DivisionID = AT9000.DivisionID
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
inner  join AT1005 on AT1005.AccountID = AT9000.DebitAccountID and  AT1005.DivisionID = AT9000.DivisionID  and GroupID ='G03' and  IsObject =1
left join  OT2001 on OT2001.SOrderID = AT9000.OrderID and OT2001.DivisionID = AT9000.DivisionID
Left Join AT1015  T01 on T01.AnaID = AT1202.O01ID and T01.DivisionID = AT1202.DivisionID  and T01.AnaTypeID = 'O01' 
Left Join AT1015  T02 on T02.AnaID = AT1202.O02ID and T02.DivisionID = AT1202.DivisionID  and T02.AnaTypeID = 'O02'
Left Join AT1015  T03 on T03.AnaID = AT1202.O03ID and T03.DivisionID = AT1202.DivisionID  and T03.AnaTypeID = 'O03'
Left Join AT1015  T04 on T04.AnaID = AT1202.O04ID and T04.DivisionID = AT1202.DivisionID  and T04.AnaTypeID = 'O04'
Left Join AT1015  T05 on T05.AnaID = AT1202.O05ID and T05.DivisionID = AT1202.DivisionID  and T05.AnaTypeID = 'O05'

Group by AT9000. VoucherID,BatchID,  TableID,AT9000.DivisionID,At9000.TranMonth,AT9000.TranYear,
	AT9000.ObjectID, DebitAccountID, AT1005.AccountName, AT9000.CurrencyID,
	CurrencyIDCN, AT1202.ObjectName, AT9000.ExchangeRate,ExchangeRateCN,
	AT9000.VoucherTypeID, AT9000.VoucherNO, VoucherDate,InvoiceDate,InvoiceNo, Serial,
	VDescription, Status ,--AT1011.AnaName,
	AT9000.PaymentID, AT9000.DueDays, AT9000.DueDate, --AT9000.Ana01ID, 
	 BDescription,OT2001.SOrderID, OT2001.OrderDate,OT2001.ClassifyID,
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID,AT1202.O04ID, AT1202.O05ID,
	T01.AnaName , T02.AnaName ,T03.AnaName ,T04.AnaName ,T05.AnaName
GO


