IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV4302]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV4302]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Van Nhan and Thuy Tuyen.
---- Created Date 31/07/2006.
----- Purpose: View chet hien thi so lieu phan bo theo dang No, Co de phuc vu cho cac sbao cao quan tri
---Last Edit Thuy Tuyen 8/10/2007 Lay ma phan tich 4,5
---- Modified on 24/10/2012 by Lê Thị Thu Hiền : Bổ sung Join DivisionID

CREATE VIEW [dbo].[AV4302] AS 
SELECT 	T90.DivisionID, VoucherID, BatchID, 
		TransactionID, isnull(TransactionTypeID,'') AS TransactionTypeID, 
		isnull(VoucherTypeID,'') AS VoucherTypeID,
		DebitAccountID AS AccountID,
		 isnull(CreditAccountID, '') AS CorAccountID, 'D' AS D_C, 
		ConvertedAmount, OriginalAmount, OriginalAmount as OriginalAmountCN, T90.CurrencyID as CurrencyIDCN, 
		T90.CurrencyID, ExchangeRate, 
		ConvertedAmount AS SignAmount, OriginalAmount AS SignOriginal,
		T90.Quantity as Quantity, T90.Quantity as SignQuantity, 
		TranMonth, TranYear, VoucherNo, VoucherDate, Serial, InvoiceNo, InvoiceDate, null as DueDate,
		Description, Description as VDescription,
		0 as UnitPrice, 0 as CommissionPercent, 0 as DiscountRate, 
		T90.CreateUserID,
		T90.ObjectID,
		T90.InventoryID, T90.UnitID,
		null as PeriodID,
		isnull(Ana01ID,'') as Ana01ID, isnull(Ana02ID,'') as Ana02ID, isnull(Ana03ID,'') as Ana03ID , isnull(Ana04ID,'') as Ana04ID, isnull(Ana05ID,'') as Ana05ID ,
		isnull(Ana06ID,'') as Ana06ID, isnull(Ana07ID,'') as Ana07ID, isnull(Ana08ID,'') as Ana08ID , isnull(Ana09ID,'') as Ana09ID, isnull(Ana10ID,'') as Ana10ID ,
		isnull(O01ID,'') as O01ID, isnull(O02ID,'') as O02ID, isnull(O03ID,'') as O03ID, isnull(O04ID,'') as O04ID, isnull(O05ID,'') as O05ID, 
		isnull(I01ID,'') as I01ID, isnull(I02ID,'') as I02ID, isnull(I03ID,'') as I03ID, isnull(I04ID,'') as I04ID, isnull(I05ID,'') as I05ID, 
		isnull(T02.S1,'') as CO1ID,isnull(T02.S2,'') as CO2ID,isnull(T02.S3,'') as CO3ID,
		isnull(T03.S1,'') as CI1ID,isnull(T03.S2,'') as CI2ID, isnull(T03.S3,'') as CI3ID,		
		'AA'  AS BudgetID, null as OrderID,
		(Case When  T90.TranMonth <10 then '0'+rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) 
		Else rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) End) as MonthYear,
		('0'+ ltrim(rtrim(Case when T90.TranMonth %3 = 0 then T90.TranMonth/3  Else T90.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(T90.TranYear)))
		)  as Quarter ,
		str(T90.TranYear) as Year

FROM AT9001  T90 	
left join AT1202 T02 on T02.ObjectID = T90.ObjectID AND T02.DivisionID = T90.DivisionID
left join AT1302 T03 on T03.InventoryID = T90.InventoryID AND T03.DivisionID = T90.DivisionID			
WHERE DebitAccountID IS NOT NULL AND DebitAccountID <> ''
UNION ALL
SELECT 	T90.DivisionID, VoucherID, BatchID, TransactionID, isnull(TransactionTypeID,'') AS TransactionTypeID, 
	isnull(VoucherTypeID,'') AS VoucherTypeID,
	CreditAccountID AS AccountID, isnull(DebitAccountID,'') AS CorAccountID, 'C' AS D_C,  
	ConvertedAmount, OriginalAmount, OriginalAmount as OriginalAmountCN, T90.CurrencyID as CurrencyIDCN, 
	T90.CurrencyID, ExchangeRate, ConvertedAmount*-1 AS SignAmount, OriginalAmount*-1 AS SignOriginal,
	T90.Quantity as Quantity, -T90.Quantity as SignQuantity, 
	TranMonth, TranYear, VoucherNo, VoucherDate, Serial, InvoiceNo, InvoiceDate, null as DueDate,
	Description, Description as VDescription,
	0 as UnitPrice,  0 as CommissionPercent, 0 as DiscountRate,
	T90.CreateUserID,
	T90.ObjectID,
	T90.InventoryID,T90.UnitID,
	null as PeriodID,
	isnull(Ana01ID,'') as Ana01ID, isnull(Ana02ID,'') as Ana02ID, isnull(Ana03ID,'') as Ana03ID, isnull(Ana04ID,'') as Ana04ID, isnull(Ana05ID,'') as Ana05ID ,	
	isnull(Ana06ID,'') as Ana06ID, isnull(Ana07ID,'') as Ana07ID, isnull(Ana08ID,'') as Ana08ID , isnull(Ana09ID,'') as Ana09ID, isnull(Ana10ID,'') as Ana10ID ,
	isnull(O01ID,'') as O01ID, isnull(O02ID,'') as O02ID, isnull(O03ID,'') as O03ID, isnull(O04ID,'') as O04ID, isnull(O05ID,'') as O05ID, 
	isnull(I01ID,'') as I01ID, isnull(I02ID,'') as I02ID, isnull(I03ID,'') as I03ID, isnull(I04ID,'') as I04ID, isnull(I05ID,'') as I05ID, 
	isnull(T02.S1,'') as CO1ID,isnull(T02.S2,'') as CO2ID,isnull(T02.S3,'') as CO3ID,
	isnull(T03.S1,'') as CI1ID,isnull(T03.S2,'') as CI2ID, isnull(T03.S3,'') as CI3ID,
	'AA'  AS BudgetID, null as OrderID,
	(Case When  T90.TranMonth <10 then '0'+rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) 
	Else rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) End) as MonthYear,
	('0'+ ltrim(rtrim(Case when T90.TranMonth %3 = 0 then T90.TranMonth/3  Else T90.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(T90.TranYear)))
	)  as Quarter ,
	str(T90.TranYear) as Year
FROM AT9001  T90 	
left join AT1202 T02 on T02.ObjectID = T90.ObjectID AND T02.DivisionID = T90.DivisionID  
left join AT1302 T03 on T03.InventoryID = T90.InventoryID AND T03.DivisionID = T90.DivisionID
WHERE CreditAccountID IS NOT NULL AND CreditAccountID <> ''

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

