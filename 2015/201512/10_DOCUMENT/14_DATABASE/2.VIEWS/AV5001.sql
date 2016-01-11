IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV5001]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV5001]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--View chet len nhat ky so cai
--Created by Nguyen Thi Ngoc Minh
---- Modified on 09/11/2011 by Le Thi Thu Hien : Khong lay du lieu * ma lay tung truong 

CREATE VIEW [dbo].[AV5001] AS
SELECT	DivisionID, VoucherID ,  TableID, BatchID, TransactionID, 
		TransactionTypeID, AccountID,CorAccountID, 
		D_C, 
		DebitAccountID, CreditAccountID, 
		VoucherDate, 
		VoucherTypeID, VoucherNo , 
		InvoiceDate, InvoiceNo, Serial, 
		InventoryID,
		Quantity,
		ConvertedAmount, OriginalAmount, 
		CurrencyID, ExchangeRate, SignAmount, OSignAmount, 
		TranMonth, TranYear,  
		CreateUserID,CreateDate, VDescription, BDescription, 
		TDescription, ObjectID,  VATObjectID, VATNo, 
		VATObjectName, Object_Address, 
		VATTypeID, VATGroupID,
		Ana01ID, Ana02ID, Ana03ID, ProductID 
FROM	AV5000
WHERE	ConvertedAmount <> 0
UNION ALL
SELECT '' AS DivisionID, VoucherID = (select top 1 voucherid from av7460) , 'AT9000' as TableID, '' AS BatchID, '' as TransactionID, 
	'' AS TransactionTypeID, AccountID,'' AS CorAccountID, 
	'D' AS D_C, 
	'' AS DebitAccountID, '' AS CreditAccountID, 
	VoucherDate = (select top 1 VoucherDate from av7460), 
	'' AS VoucherTypeID, VoucherNo = (select top 1 VoucherNo from av7460), 
	getdate() as InvoiceDate, '' AS InvoiceNo, '' AS Serial, 
	'' as InventoryID,
	0 as Quantity,
	0 as ConvertedAmount, 0 as OriginalAmount, 
	'' AS CurrencyID, 0 as ExchangeRate, 0 as SignAmount, 0 as OSignAmount, 
	Month(getdate()) as TranMonth, Year(getdate()) as TranYear,  
	'' AS CreateUserID, getdate() as CreateDate, '' AS VDescription, '' AS BDescription, 
	'' AS TDescription, '' AS ObjectID,  '' AS VATObjectID, '' AS VATNo, 
	'' AS VATObjectName, '' AS Object_Address, 
	'' AS VATTypeID, '' AS VATGroupID,
	 '' AS Ana01ID, '' AS Ana02ID, '' AS Ana03ID, '' AS ProductID
FROM AT1005 
WHERE AccountID in (Select AccountID from AV5000 where D_C = 'C' and ConvertedAmount <> 0 and VoucherID in (Select VoucherID from AV7460))
UNION ALL
SELECT '' AS DivisionID, VoucherID = (select top 1 voucherid from av7460) ,  'AT9000' as TableID,  '' AS BatchID, '' as TransactionID, 
	'' AS TransactionTypeID, AccountID,'' AS CorAccountID, 
	'C' AS D_C, 
	'' AS DebitAccountID, '' AS CreditAccountID, 
	VoucherDate = (select top 1 VoucherDate from av7460), 
	'' AS VoucherTypeID, VoucherNo = (select top 1 VoucherNo from av7460), 
	getdate() as InvoiceDate, '' AS InvoiceNo, '' AS Serial, 
	'' as InventoryID,
	0 as Quantity,
	0 as ConvertedAmount, 0 as OriginalAmount, 
	'' AS CurrencyID, 0 as ExchangeRate, 0 as SignAmount, 0 as OSignAmount, 
	Month(getdate()) as TranMonth, Year(getdate()) as TranYear,  
	'' AS CreateUserID, getdate() as CreateDate, '' AS VDescription, '' AS BDescription, 
	'' AS TDescription, '' AS ObjectID,  '' AS VATObjectID, '' AS VATNo, 
	'' AS VATObjectName, '' AS Object_Address, 
	'' AS VATTypeID, '' AS VATGroupID,
	 '' AS Ana01ID, '' AS Ana02ID, '' AS Ana03ID, '' AS ProductID
FROM AT1005 
WHERE AccountID in (Select ACcountID from av5000 where D_C = 'D' and ConvertedAmount <> 0 and VoucherID in (Select VoucherID from AV7460))

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

