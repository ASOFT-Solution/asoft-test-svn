IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV4303]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV4303]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Dang Le Bao Quynh.
----- Created Date 24/05/2007.
----- Purpose: View chet, loc du lieu phuc vu cong tac bao cao quan tri dang 3 
---- Modified on 24/10/2012 by Lê Thị Thu Hiền : Bổ sung Join DivisionID
---- Modified on 18/03/2014 by Lê Thị Thu Hiền : Bổ sung Ana06 den An10
---- Modified by Bảo Anh on 11/06/2015: Sửa cách lấy trường Quarter

CREATE VIEW [dbo].[AV4303]
AS

SELECT 	T90.DivisionID, VoucherID, BatchID, TransactionID, isnull(TransactionTypeID,'') AS TransactionTypeID, 
		isnull(VoucherTypeID,'') AS VoucherTypeID,
		DebitAccountID AS AccountID, isnull(CreditAccountID, '') AS CorAccountID, 'D' AS D_C, 
		ConvertedAmount, OriginalAmount, OriginalAmountCN, CurrencyIDCN, 
		T90.CurrencyID, ExchangeRate, 
		ConvertedAmount AS SignAmount, OriginalAmount AS SignOriginal,
		T90.Quantity AS Quantity, T90.Quantity AS SignQuantity, 
		TranMonth, TranYear, VoucherNo, VoucherDate, Serial, InvoiceNo, InvoiceDate, DueDate, VATTypeID,
		isnull(TDescription, isnull(BDescription,VDescription)) AS Description, isnull(VDescription,'') AS VDescription,
		T90.UnitPrice, T90.CommissionPercent, T90.DiscountRate, 
		T90.CreateUserID,
		T90.ObjectID,
		T90.InventoryID, T90.UnitID,
		T90.PeriodID,
		isnull(Ana01ID,'') AS Ana01ID,isnull(AnaName,'') AS AnaName01, 
		isnull(Ana02ID,'') AS Ana02ID, isnull(Ana03ID,'') AS Ana03ID ,  isnull(Ana04ID,'') AS Ana04ID ,  isnull(Ana05ID,'') AS Ana05ID ,
		isnull(Ana06ID,'') AS Ana06ID, isnull(Ana07ID,'') AS Ana07ID ,  isnull(Ana08ID,'') AS Ana08ID ,  isnull(Ana09ID,'') AS Ana09ID , isnull(Ana10ID,'') AS Ana10ID ,
		isnull(O01ID,'') AS O01ID, isnull(O02ID,'') AS O02ID, isnull(O03ID,'') AS O03ID, isnull(O04ID,'') AS O04ID, isnull(O05ID,'') AS O05ID, 
		isnull(I01ID,'') AS I01ID, isnull(I02ID,'') AS I02ID, isnull(I03ID,'') AS I03ID, isnull(I04ID,'') AS I04ID, isnull(I05ID,'') AS I05ID, 
		isnull(T02.S1,'') AS CO1ID,isnull(T02.S2,'') AS CO2ID,isnull(T02.S3,'') AS CO3ID,
		isnull(T03.S1,'') AS CI1ID,isnull(T03.S2,'') AS CI2ID, isnull(T03.S3,'') AS CI3ID,		
		'AA'  AS BudgetID, T90.OrderID,
		(Case When  T90.TranMonth <10 then '0'+rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) 
		Else rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) End) AS MonthYear,

		--('0'+ ltrim(rtrim(Case when T90.TranMonth %3 = 0 then T90.TranMonth/3  Else T90.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(T90.TranYear)))
		--)  AS Quarter ,
		(select Quarter from AV9999 Where DivisionID = T90.DivisionID and TranMonth = T90.TranMonth and TranYear = T90.TranYear) as Quarter,

		str(T90.TranYear) AS Year,
		T90.VATGroupID,
		T10.VATRate

FROM AT9000  T90 	
left join AT1202 T02 on T02.ObjectID = T90.ObjectID AND T02.DivisionID = T90.DivisionID
left join AT1302 T03 on T03.InventoryID = T90.InventoryID AND T03.DivisionID = T90.DivisionID			
Left join AT1011 T01 on T01.AnaID = T90.Ana01ID  And T01.AnaTypeID = 'A01'	AND T01.DivisionID = T90.DivisionID 	
Left join AT1010 T10 on T10.VATGroupID = T90.VATGroupID AND T10.DivisionID = T90.DivisionID
WHERE DebitAccountID IS NOT NULL AND DebitAccountID <> ''

UNION ALL


SELECT 	T90.DivisionID, VoucherID, BatchID, TransactionID, isnull(TransactionTypeID,'') AS TransactionTypeID, 
	isnull(VoucherTypeID,'') AS VoucherTypeID,
	CreditAccountID AS AccountID, isnull(DebitAccountID,'') AS CorAccountID, 'C' AS D_C,  
	ConvertedAmount, OriginalAmount, OriginalAmountCN, CurrencyIDCN, 
	T90.CurrencyID, ExchangeRate, ConvertedAmount*-1 AS SignAmount, OriginalAmount*-1 AS SignOriginal,
	T90.Quantity AS Quantity, -T90.Quantity AS SignQuantity, 
	TranMonth, TranYear, VoucherNo, VoucherDate, Serial, InvoiceNo, InvoiceDate, DueDate, VATTypeID,
	isnull(TDescription, isnull(BDescription,VDescription)) AS Description, isnull(VDescription,'') AS VDescription,
	T90.UnitPrice, T90.CommissionPercent, T90.DiscountRate,
	T90.CreateUserID,
	Case When T90.TransactionTypeID ='T99' then CreditObjectID else T90.ObjectID end AS ObjectID,
	T90.InventoryID,T90.UnitID,
	T90.PeriodID,
	isnull(Ana01ID,'') AS Ana01ID, isnull(AnaName,'') AS AnaName01,     isnull(Ana02ID,'') AS Ana02ID, isnull(Ana03ID,'') AS Ana03ID, isnull(Ana04ID,'') AS Ana04ID ,  isnull(Ana05ID,'') AS Ana05ID ,
	isnull(Ana06ID,'') AS Ana06ID, isnull(Ana07ID,'') AS Ana07ID ,  isnull(Ana08ID,'') AS Ana08ID ,  isnull(Ana09ID,'') AS Ana09ID , isnull(Ana10ID,'') AS Ana10ID ,
	isnull(O01ID,'') AS O01ID, isnull(O02ID,'') AS O02ID, isnull(O03ID,'') AS O03ID, isnull(O04ID,'') AS O04ID, isnull(O05ID,'') AS O05ID, 
	isnull(I01ID,'') AS I01ID, isnull(I02ID,'') AS I02ID, isnull(I03ID,'') AS I03ID, isnull(I04ID,'') AS I04ID, isnull(I05ID,'') AS I05ID, 
	isnull(T02.S1,'') AS CO1ID,isnull(T02.S2,'') AS CO2ID,isnull(T02.S3,'') AS CO3ID,
	isnull(T03.S1,'') AS CI1ID,isnull(T03.S2,'') AS CI2ID, isnull(T03.S3,'') AS CI3ID,
	'AA'  AS BudgetID, T90.OrderID,
	(Case When  T90.TranMonth <10 then '0'+rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) 
	Else rtrim(ltrim(str(T90.TranMonth)))+'/'+ltrim(Rtrim(str(T90.TranYear))) End) AS MonthYear,
	
	--('0'+ ltrim(rtrim(Case when T90.TranMonth %3 = 0 then T90.TranMonth/3  Else T90.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(T90.TranYear)))
	--)  AS Quarter ,
	(select Quarter from AV9999 Where DivisionID = T90.DivisionID and TranMonth = T90.TranMonth and TranYear = T90.TranYear) as Quarter,

	str(T90.TranYear) AS Year,
	T90.VATGroupID,
	T10.VATRate

FROM AT9000  T90 	
left join AT1202 T02 on T02.ObjectID = (case When T90.TransactionTypeID ='T99'  then T90.CreditObjectID Else T90.ObjectID End) AND T02.DivisionID = T90.DivisionID
left join AT1302 T03 on T03.InventoryID = T90.InventoryID AND T03.DivisionID = T90.DivisionID
Left join AT1011 T01 on T01.AnaID = T90.Ana01ID  And T01.AnaTypeID = 'A01'	 AND T01.DivisionID = T90.DivisionID	
Left join AT1010 T10 on T10.VATGroupID = T90.VATGroupID AND T10.DivisionID = T90.DivisionID
WHERE CreditAccountID IS NOT NULL AND CreditAccountID <> ''

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON