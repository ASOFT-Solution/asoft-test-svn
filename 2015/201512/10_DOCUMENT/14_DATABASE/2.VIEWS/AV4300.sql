IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV4300]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV4300]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


----- Created by Nguyen Van Nhan, View chet
----- Edit by: Dang Le Bao Quynh; Date: 14/10/2009
----- Purpose: Them truong DueDate
---- Modified on 28/10/2011 by Le Thi Thu Hien : Bo sung cot RefVoucherNo
---- Modified on 24/11/2011 by Le Thi Thu Hien : Bo sung 5 khoan muc

CREATE VIEW [dbo].[AV4300] AS 
SELECT 	DivisionID, VoucherID, BatchID, TransactionID,
	ISNULL(TransactionTypeID,'') AS TransactionTypeID,
	DebitAccountID AS AccountID, 
	ISNULL(CreditAccountID,'') AS CorAccountID, 
	Case When TransactionTypeID in ('T64','T65') Then 'C' Else 'D' End AS D_C, 
	--'D' AS D_C,
	DebitAccountID, ISNULL(CreditAccountID,'') AS CreditAccountID, 
	VoucherDate,  VoucherTypeID, VoucherNo, 
	InvoiceDate, ISNULL(InvoiceNo,'') AS InvoiceNo,
	ISNULL(Serial,'') AS Serial, 
	DueDate,
	ROUND(ConvertedAmount,2)  AS ConvertedAmount , 
	ROUND(OriginalAmount,2) AS OriginalAmount ,
	ROUND(ISNULL(ImTaxOriginalAmount,0),2) AS ImTaxOriginalAmount,
	ROUND(ISNULL(ImTaxConvertedAmount,0),2) AS ImTaxConvertedAmount,
	CurrencyID, ExchangeRate, 
	ROUND(ConvertedAmount,2) AS SignAmount, 
	OriginalAmount AS OSignAmount, 
	TranMonth, TranYear,  
	CreateUserID,
	VDescription, BDescription,TDescription,
	Case when ISNULL(ObjectID,'') = '' and TransactionTypeID ='T99' then CreditObjectID else ObjectID end AS ObjectID ,  
	VATObjectID, 
	VATNo, VATObjectName, 
	'' AS ObjectAddress, 
	 VATTypeID,   VATGroupID  ,
	ROUND(ISNULL(Quantity,0),2) AS Quantity,
	RefVoucherNo,
	AT9000.Ana01ID, AT9000.Ana02ID, AT9000.Ana03ID, AT9000.Ana04ID , AT9000.Ana05ID,
	AT9000.Ana06ID, AT9000.Ana07ID, AT9000.Ana08ID, AT9000.Ana09ID , AT9000.Ana10ID
	
FROM AT9000
WHERE DebitAccountID IS NOT NULL AND DebitAccountID <> ''

UNION ALL
SELECT 	DivisionID,   VoucherID, BatchID, TransactionID,
	ISNULL(TransactionTypeID,'') AS TransactionTypeID,
	CreditAccountID AS AccountID, 
	ISNULL(DebitAccountID,'') AS CorAccountID, 
	CASE WHEN TransactionTypeID in ('T64','T65') THEN 'D' ELSE 'C' END AS D_C, 
	--'C' AS D_C, 
	ISNULL(DebitAccountID,'') AS DebitAccountID, 
	CreditAccountID, 
	VoucherDate,  VoucherTypeID, VoucherNo, 
	InvoiceDate, ISNULL(InvoiceNo,'') AS InvoiceNo,
	ISNULL(Serial,'') AS Serial, 
	DueDate,
	ROUND(ConvertedAmount,2) AS ConvertedAmount , 
	ROUND(OriginalAmount,2) AS OriginalAmount, 
	ROUND (ISNULL(ImTaxOriginalAmount,0),2) AS ImTaxOriginalAmount,
	ROUND (ISNULL(ImTaxConvertedAmount,0),2) AS ImTaxConvertedAmount,
	CurrencyID, ExchangeRate, 
	ROUND(ConvertedAmount,2)*-1 AS SignAmount, OriginalAmount*-1 AS OSignAmount, 	
	TranMonth, TranYear, 
	CreateUserID,
	VDescription, BDescription,TDescription,
	Case when ISNULL(CreditObjectID,'') <> '' and TransactionTypeID = 'T99'  then CreditObjectID else ObjectID end AS ObjectID ,
	VATObjectID,  
	VATNo, VATObjectName, ' ' AS ObjectAddress, 
	VATTypeID,  VATGroupID	,
	ROUND(ISNULL(Quantity,0),2) AS Quantity,
	RefVoucherNo,
	AT9000.Ana01ID, AT9000.Ana02ID, AT9000.Ana03ID, AT9000.Ana04ID , AT9000.Ana05ID,
	AT9000.Ana06ID, AT9000.Ana07ID, AT9000.Ana08ID, AT9000.Ana09ID , AT9000.Ana10ID
	
FROM AT9000
WHERE CreditAccountID IS NOT NULL AND CreditAccountID <> ''


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

