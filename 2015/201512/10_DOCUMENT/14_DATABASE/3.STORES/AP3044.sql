/****** Object:  StoredProcedure [dbo].[AP3044]    Script Date: 07/29/2010 10:11:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----- In chi phi mua hang
----- Created by Bao Anh, Date 11/03/2008
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3044] @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)
	
 AS
Declare @sSQL as nvarchar(4000)

Set @sSQL ='
Select 	VoucherID, AT9000.DivisionID, TranMonth, TranYear, 
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
Where TransactionTypeID = ''T23'' and
	AT9000.DivisionID = '''+@DivisionID+''' and
	VoucherID ='''+@VoucherID+''' 
'


--print @sSQL

If Not Exists (Select 1 From sysObjects Where Name ='AV3064')
	Exec ('Create view AV3064 as '+@sSQL)
Else
	Exec( 'Alter view AV3064 as '+@sSQL)