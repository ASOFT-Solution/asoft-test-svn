IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV1111]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV1111]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- View chet xu ly truong hop So tien gui ngan hang
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 12/12/2007 by Van  Nhan
---- 
---- Modified on 13/08/2008 by Van NHan
---- Modified on 29/12/2008 by Nguyen Quoc Huy
---- Modified on 31/01/2012 by Le Thi Thu Hien : Bo sung them tieu chi lay CurrencyID,ExchangeRate,OriginalAmount,SignOriginalAmount ben Co, cho nhung but toan chuyen khoan ngan hang
---- Modified on 24/05/2013 by Lê Thị Thu Hiền : Bổ sung 10 khoản mục Ana
---- Modified on 08/10/2015 by Tieu Mai: Sửa tiền hạch toán theo thiết lập đơn vị-chi nhánh

-- <Example>
---- 


CREATE View AV1111 AS 
Select   AT9000.DivisionID,
		AT9000.TranMonth,
		AT9000.TranYear,
		CreditBankAccountID as BankAccountID,
		CreditAccountID as AccountID, 
		CreditAccountID,
		DebitAccountID,
	--	AT1016.CurrencyID,
		Case when TransactionTypeID='T16' then CurrencyIDCN else AT9000.CurrencyID End as CurrencyID,
		Case when TransactionTypeID='T16' then ExchangeRateCN else AT9000.ExchangeRate End as ExchangeRate,
		Case when TransactionTypeID='T16' then OriginalAmountCN else OriginalAmount End as OriginalAmount,	
		ConvertedAmount,
		-Case when TransactionTypeID='T16' then OriginalAmountCN else OriginalAmount End as SignOriginalAmount,	
		-ConvertedAmount as SignConvertedAmount,
		VoucherDate,
		VoucherNo,
		VoucherID,
		ObjectID,
		VoucherTypeID
		VDescription,
		TDescription,
		BDescription,
		TransactionTypeID,
		'C' as D_C,
		Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
		AT9000.Ana06ID,	AT9000.Ana07ID,	AT9000.Ana08ID,AT9000.Ana09ID,AT9000.Ana10ID	 
From AT9000 	
left join AT1016 on AT1016.BankAccountID = AT9000.CreditBankAccountID AND AT1016.DivisionID = AT9000.DivisionID
Where isnull(CreditBankAccountID,'') <>'' 
Union ALL
Select   AT9000.DivisionID,
		AT9000.TranMonth,
		AT9000.TranYear,
		DebitBankAccountID as BankAccountID,
		DebitAccountID as AccountID, 
		CreditAccountID,
		DebitAccountID,
		AT1016.CurrencyID,
		AT9000.ExchangeRate,
		--CurrencyID as CurrencyID,
		Case when AT1016.CurrencyID = (select   top 1 BasecurrencyID from AT1101) then ConvertedAmount else OriginalAmount end as OriginalAmount,
		--OriginalAmount as OriginalAmount,	
		ConvertedAmount,
		---OriginalAmount as SignOriginalAmount,	
		Case when AT1016.CurrencyID = (select  top  1  BasecurrencyID from AT1101)  then ConvertedAmount else OriginalAmount end as SignOriginalAmount,
		ConvertedAmount as SignConvertedAmount,

		VoucherDate,
		VoucherNo,
		VoucherID,
		ObjectID,
		VoucherTypeID
		VDescription,
		TDescription,
		BDescription,
		TransactionTypeID,
		'D' as D_C,
		Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
		AT9000.Ana06ID,	AT9000.Ana07ID,	AT9000.Ana08ID,AT9000.Ana09ID,AT9000.Ana10ID 
From AT9000 	
left join AT1016 on AT1016.BankAccountID = AT9000.DebitBankAccountID AND AT1016.DivisionID = AT9000.DivisionID
Where  isnull(DebitBankAccountID,'')<>''



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

