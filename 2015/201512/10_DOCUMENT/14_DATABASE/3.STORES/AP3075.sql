/****** Object:  StoredProcedure [dbo].[AP3075]    Script Date: 07/29/2010 10:48:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



----- In phieu chi qua ngan hang: Mau so 2
----- Date 10/11/2007
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
---- Modified by Thanh Thịnh on 05/08/2015: Thêm 4 Trường Theo yêu cầu của CAR(Vu) CreditBankAccountNo, CreditBankAccountID, DebitBankAccountNo và DebitBankAccountID
'********************************************/

ALTER PROCEDURE [dbo].[AP3075] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)
	
 AS
Declare @sSQL as nvarchar(4000),
	@AT9000Cursor as cursor,
	@InvoiceNo as nvarchar(50),
	@Serial as nvarchar(50),
	@InvoiceNoList as nvarchar(500),
	@DebitAccountList as nvarchar(500),
	@DebitAccountID  as nvarchar(50),
	@CreditAccountList as nvarchar(500),
	@CreditAccountID  as nvarchar(50),
	@InvoiceDate nvarchar(10)

Set @sSQL ='
Select 	VoucherID, AT9000.DivisionID, TranMonth, TranYear, 
	Orders, VoucherTypeID, VoucherNo, VoucherDate,
	VDescription,
	TDescription,
	BDescription,
	CreditAccountID,
	DebitAccountID, 
	AT9000.CurrencyID, ExchangeRate,
	SenderReceiver, SRDivisionName, SRAddress,
	RefNo01, RefNo02, 
	--FullName,
	---ChiefAccountant,
	ConvertedAmount,
	 OriginalAmount,
	 CreditBankAccountID,
	 CRE.BankAccountNo [CreditBankAccountNo],
	 DebitBankAccountID,
	 DEB.BankAccountNo [DebitBankAccountNo]
	
From AT9000 
LEFT JOIN AT1016 CRE
	ON AT9000.CreditBankAccountID = CRE.BankAccountID AND AT9000.DivisionID = CRE.DivisionID
LEFT JOIN AT1016 DEB
	ON AT9000.DebitBankAccountID = DEB.BankAccountID AND AT9000.DivisionID = DEB.DivisionID
Where TransactionTypeID = ''T22'' and
	AT9000.DivisionID = '''+@DivisionID+''' and
	VoucherID ='''+@VoucherID+''' 
'


--print @sSQL

If Not Exists (Select 1 From sysObjects Where Name ='AV3075')
	Exec ('Create view AV3075 as '+@sSQL)
Else
	Exec( 'Alter view AV3075 as '+@sSQL)
