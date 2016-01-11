
/****** Object:  View [dbo].[AV4202]    Script Date: 12/28/2010 15:02:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---Text                                                                                                                                                                                                                                                            
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 


-----View chet
----- Phuc vu cong no
---- Modified by on 15/10/2014 by Huỳnh Tấn Phú : Bổ sung điều kiện lọc theo 10 mã phân tích. 0022751: [VG] In số dư đầu kỳ lên sai dẫn đến số dư cuối kỳ sai. 

ALTER VIEW [dbo].[AV4202] as 	
SELECT 	ObjectID,  		---- PHAT SINH NO
		CurrencyIDCN,VoucherDate, InvoiceDate, DueDate,
		AT9000.DivisionID, DebitAccountID AS AccountID, InventoryID,
		SUM(isnull(ConvertedAmount,0)) AS ConvertedAmount, 
		sum(isnull(OriginalAmountCN,0)) AS OriginalAmount,
		TranMonth,TranYear, 
		CreditAccountID AS CorAccountID,   -- tai khoan doi ung
		'D' AS D_C, TransactionTypeID
		,Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID	
FROM AT9000 inner join AT1005 on AT1005.AccountID = AT9000.DebitAccountID and AT1005.DivisionID = AT9000.DivisionID
WHERE DebitAccountID IS NOT NULL and AT1005.GroupID  in ('G03', 'G04')
GROUP BY ObjectID, Ana01ID, CurrencyIDCN, VoucherDate, InvoiceDate, DueDate, AT9000.DivisionID, DebitAccountID, 
	TranMonth, TranYear, CreditAccountID, TransactionTypeID, InventoryID
	,Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID	
UNION ALL
------------------- So phat sinh co, lay am
SELECT				---- PHAT SINH CO 
	(Case when TransactionTypeID ='T99' then CreditObjectID else ObjectID end) as ObjectID, 
	CurrencyIDCN,VoucherDate, InvoiceDate, DueDate,
	AT9000.DivisionID, CreditAccountID AS AccountID, InventoryID,
	SUM(isnull(ConvertedAmount,0)*-1) AS ConvertedAmount, 
	sum(isnull(OriginalAmountCN,0)*-1) AS OriginalAmount,
	TranMonth, TranYear, 
	DebitAccountID AS CorAccountID, 
	'C' AS D_C, TransactionTypeID
	,Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID	 
FROM AT9000 inner join AT1005 on AT1005.AccountID = AT9000.CreditAccountID and AT1005.DivisionID = AT9000.DivisionID
WHERE CreditAccountID IS NOT NULL  and AT1005.GroupID in ('G03', 'G04')
GROUP BY (Case when TransactionTypeID ='T99' then CreditObjectID else ObjectID end), Ana01ID,
	CurrencyIDCN, VoucherDate, InvoiceDate, DueDate, AT9000.DivisionID, CreditAccountID, 
	TranMonth, TranYear, DebitAccountID, TransactionTypeID, InventoryID,
	Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID	

GO


