/****** Object:  StoredProcedure [dbo].[AP3073]    Script Date: 07/29/2010 10:43:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



----- In phieu thu qua ngan hang: Mau so 2
----- Date 10/11/2007
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3073] @DivisionID as nvarchar(50),
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
	Orders,
	VoucherTypeID, VoucherNo, VoucherDate,
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
	 OriginalAmount
	
From AT9000 
Where TransactionTypeID = ''T21'' and
	AT9000.DivisionID = '''+@DivisionID+''' and
	VoucherID ='''+@VoucherID+''' 
'


--print @sSQL

If Not Exists (Select 1 From sysObjects Where Name ='AV3073')
	Exec ('Create view AV3073 as '+@sSQL)
Else
	Exec( 'Alter view AV3073 as '+@sSQL)
