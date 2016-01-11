/****** Object:  StoredProcedure [dbo].[AP3036]    Script Date: 07/29/2010 10:12:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----- In  thue nhap khau
----- Created by Thuy Tuyen, 
----Date 01/07/2008

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3036]  @DivisionID as nvarchar(50),
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
Where TransactionTypeID = ''T33'' and
	AT9000.DivisionID = '''+@DivisionID+''' and
	VoucherID ='''+@VoucherID+''' 
'


--print @sSQL

If Not Exists (Select 1 From sysObjects Where Name ='AV3036')
	Exec ('Create view AV3036 as '+@sSQL) -- tao boi store AP3036
Else
	Exec( 'Alter view AV3036  as '+@sSQL)--- -- tao boi store AP3036