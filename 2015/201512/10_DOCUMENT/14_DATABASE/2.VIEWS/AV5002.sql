IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV5002]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV5002]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by Tieu Mai, on 06/11/2015
--- Purpose: View dung in so cai theo quy cach hang hoa


CREATE VIEW [dbo].[AV5002] --view chet in so cai
AS
SELECT 	AT9000.DivisionID, AT9000.VoucherID, AT9000.TableID, AT9000.BatchID, AT9000.TransactionID,  
		CASE WHEN TransactionTypeID ='T14' then 'T04' else  TransactionTypeID End as TransactionTypeID,
		DebitAccountID AS AccountID, 
		isnull(CreditAccountID,'') AS CorAccountID, 
		'D' AS D_C, 
		DebitAccountID, 
		isnull(CreditAccountID,'') AS CreditAccountID, 
		AT9000.VoucherDate,  
		AT9000.VoucherTypeID, AT9000.VoucherNo, 
		InvoiceDate, 
		isnull(InvoiceNo,'') as InvoiceNo, isnull(Serial,'') as Serial, 
		AT9000.InventoryID,
		Quantity,
		ConvertedAmount, 
		OriginalAmount, 
		AT9000.CurrencyID, 
		ExchangeRate, ConvertedAmount as  SignAmount, 
		OriginalAmount as OSignAmount, 
		--ReportingAmount as SignReporting,
		AT9000.TranMonth, AT9000.TranYear,  
		AT9000.CreateUserID, AT9000.CreateDate,
		VDescription, BDescription, TDescription,
		AT9000.ObjectID,  VATObjectID, AT9000.VATNo, AT9000.VATObjectName, AT1202.ObjectName as Object_Address, 
		VATTypeID, VATGroupID,
		Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
		T1.AnaName as AnaName01, T2.AnaName as AnaName02, T3.AnaName as AnaName03, T4.AnaName as AnaName04, T5.AnaName as AnaName05,
		T6.AnaName as AnaName06, T7.AnaName as AnaName07, T8.AnaName as AnaName08, T9.AnaName as AnaName09, T10.AnaName as AnaName10,
		ProductID, AT9000.Orders ,
		AT9000.SenderReceiver, Isnull(AT9000.Status,0) as Status, AT2006.RefNo01, AT2006.RefNo02,AT9000.SRDivisionName,AT9000.SRAddress,
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID 

FROM		AT9000
		LEFT JOIN	AT1202 ON AT9000.ObjectID = AT1202.ObjectID AND AT9000.DivisionID = AT1202.DivisionID
		LEFT join AT2006 on AT9000.VoucherID= AT2006.VoucherID and AT9000.DivisionID = AT2006.DivisionID
		left join AT1011	T1 on T1.AnaID = AT9000.Ana01ID And T1.AnaTypeID= 'A01' AND T1.DivisionID = AT9000.DivisionID
		left join AT1011	T2 on T2.AnaID = AT9000.Ana02ID And T2.AnaTypeID= 'A02' AND T2.DivisionID = AT9000.DivisionID
		left join AT1011	T3 on T3.AnaID = AT9000.Ana03ID And T3.AnaTypeID= 'A03' AND T3.DivisionID = AT9000.DivisionID
		left join AT1011	T4 on T4.AnaID = AT9000.Ana04ID And T4.AnaTypeID= 'A04' AND T4.DivisionID = AT9000.DivisionID
		left join AT1011	T5 on T5.AnaID = AT9000.Ana05ID And T5.AnaTypeID= 'A05' AND T5.DivisionID = AT9000.DivisionID
		left join AT1011	T6 on T6.AnaID = AT9000.Ana01ID And T6.AnaTypeID= 'A06' AND T6.DivisionID = AT9000.DivisionID
		left join AT1011	T7 on T7.AnaID = AT9000.Ana02ID And T7.AnaTypeID= 'A07' AND T7.DivisionID = AT9000.DivisionID
		left join AT1011	T8 on T8.AnaID = AT9000.Ana03ID And T8.AnaTypeID= 'A08' AND T8.DivisionID = AT9000.DivisionID
		left join AT1011	T9 on T9.AnaID = AT9000.Ana04ID And T9.AnaTypeID= 'A09' AND T9.DivisionID = AT9000.DivisionID
		left join AT1011	T10 on T10.AnaID = AT9000.Ana05ID And T10.AnaTypeID= 'A10' AND T10.DivisionID = AT9000.DivisionID
		LEFT JOIN WT8899	O99 ON O99.DivisionID = AT9000.DivisionID AND O99.VoucherID = AT9000.VoucherID AND O99.TransactionID = AT9000.TransactionID
WHERE		DebitAccountID IS NOT NULL AND DebitAccountID <> ''

UNION ALL
SELECT 	AT9000.DivisionID, AT9000.VoucherID, AT9000.TableID, AT9000.BatchID, AT9000.TransactionID, Case When TransactionTypeID ='T14' then 'T04' else  TransactionTypeID End as TransactionTypeID,
		CreditAccountID AS AccountID, 
		isnull(DebitAccountID,'') AS CorAccountID, 'C' AS D_C, 
		isnull(DebitAccountID,'') as DebitAccountID, 
		CreditAccountID, 
		AT9000.VoucherDate,  AT9000.VoucherTypeID, AT9000.VoucherNo, 
		InvoiceDate, isnull(InvoiceNo,'') as InvoiceNo, isnull(Serial,'') as Serial, 
		AT9000.InventoryID,
		Quantity,
		ConvertedAmount , 
		OriginalAmount, 
		AT9000.CurrencyID, 
		ExchangeRate, (ConvertedAmount)*-1 AS SignAmount, OriginalAmount*-1 as OSignAmount, 		
		AT9000.TranMonth, AT9000.TranYear, 
		AT9000.CreateUserID, AT9000.CreateDate,		
		VDescription, BDescription, TDescription,
		AT9000.ObjectID,  VATObjectID, AT9000.VATNo, AT9000.VATObjectName, AT1202.ObjectName as Object_Address, 
		VATTypeID,   VATGroupID,
		Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
		T1.AnaName as AnaName01, T2.AnaName as AnaName02, T3.AnaName as AnaName03, T4.AnaName as AnaName04, T5.AnaName as AnaName05,
		T6.AnaName as AnaName06, T7.AnaName as AnaName07, T8.AnaName as AnaName08, T9.AnaName as AnaName09, T10.AnaName as AnaName10,
		ProductID, AT9000.Orders ,
		AT9000.SenderReceiver, Isnull(AT9000.Status,0) as Status, AT2006.RefNo01, AT2006.RefNo02,AT9000.SRDivisionName,AT9000.SRAddress,
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		
FROM		AT9000
		LEFT JOIN	AT1202 ON AT9000.ObjectID = AT1202.ObjectID AND AT9000.DivisionID = AT1202.DivisionID
		LEFT join AT2006 on AT9000.VoucherID= AT2006.VoucherID and AT9000.DivisionID = AT2006.DivisionID
		left join AT1011	T1 on T1.AnaID = AT9000.Ana01ID And T1.AnaTypeID= 'A01' AND T1.DivisionID = AT9000.DivisionID
		left join AT1011	T2 on T2.AnaID = AT9000.Ana02ID And T2.AnaTypeID= 'A02' AND T2.DivisionID = AT9000.DivisionID
		left join AT1011	T3 on T3.AnaID = AT9000.Ana03ID And T3.AnaTypeID= 'A03' AND T3.DivisionID = AT9000.DivisionID
		left join AT1011	T4 on T4.AnaID = AT9000.Ana04ID And T4.AnaTypeID= 'A04' AND T4.DivisionID = AT9000.DivisionID
		left join AT1011	T5 on T5.AnaID = AT9000.Ana05ID And T5.AnaTypeID= 'A05' AND T5.DivisionID = AT9000.DivisionID
		left join AT1011	T6 on T6.AnaID = AT9000.Ana01ID And T6.AnaTypeID= 'A06' AND T6.DivisionID = AT9000.DivisionID
		left join AT1011	T7 on T7.AnaID = AT9000.Ana02ID And T7.AnaTypeID= 'A07' AND T7.DivisionID = AT9000.DivisionID
		left join AT1011	T8 on T8.AnaID = AT9000.Ana03ID And T8.AnaTypeID= 'A08' AND T8.DivisionID = AT9000.DivisionID
		left join AT1011	T9 on T9.AnaID = AT9000.Ana04ID And T9.AnaTypeID= 'A09' AND T9.DivisionID = AT9000.DivisionID
		left join AT1011	T10 on T10.AnaID = AT9000.Ana05ID And T10.AnaTypeID= 'A10' AND T10.DivisionID = AT9000.DivisionID
		LEFT JOIN WT8899	O99 ON O99.DivisionID = AT9000.DivisionID AND O99.VoucherID = AT9000.VoucherID AND O99.TransactionID = AT9000.TransactionID
WHERE		CreditAccountID IS NOT NULL AND CreditAccountID <> ''




GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

