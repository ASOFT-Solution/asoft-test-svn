/****** Object:  StoredProcedure [dbo].[AP3004]    Script Date: 07/29/2010 09:20:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----- In but toan hoa hong
----- Created by Bao Anh, Date 01/12/2009

/********************************************
'* Edited by: [GS] [Hoàng Phước] [28/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3004] @DivisionID as nvarchar(50),
				@VoucherID as nvarchar(50)
	
 AS
Declare @sSQL as nvarchar(max);

Set @sSQL =N'
Select 	VoucherID, AT9000.DivisionID, TranMonth, TranYear, Orders,
	VoucherTypeID, VoucherNo, VoucherDate, Serial, InvoiceNo, InvoiceDate, VATTypeID, DueDate,
	VDescription,
	TDescription,
	BDescription,
	CreditAccountID, DebitAccountID, AT9000.ObjectID, AT1202.ObjectName,
	AT9000.CurrencyID, ExchangeRate,
	AT9000.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1304. UnitName,
	CommissionPercent,
	ConvertedAmount,
	OriginalAmount,
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID
From AT9000 Left join AT1202 on AT9000.ObjectID = AT1202.ObjectID And AT9000.DivisionID = AT1202.DivisionID
	         Left join AT1302 on AT9000.InventoryID = AT1302.InventoryID And AT9000.DivisionID = AT1302.DivisionID
	         Left join AT1304 on AT9000.UnitID = AT1304.UnitID And AT9000.DivisionID = AT1304.DivisionID
 
Where TransactionTypeID = ''T54'' and
	AT9000.DivisionID = '''+@DivisionID+''' and
	VoucherID ='''+@VoucherID+''' 
'

If Not Exists (Select 1 From sysObjects Where Name ='AV3054')
	Exec ('Create view AV3054 as '+@sSQL)
Else
	Exec( 'Alter view AV3054 as '+@sSQL)