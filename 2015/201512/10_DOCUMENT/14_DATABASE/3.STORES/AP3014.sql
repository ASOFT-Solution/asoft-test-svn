/****** Object:  StoredProcedure [dbo].[AP3014]    Script Date: 08/04/2010 11:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


------ Created by Nguyen Van Nhan, Date 25/09/2003.
------ Purpose: In phieu Mua hang

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3014] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@VoucherID as nvarchar(50)
 AS

Declare @sSQL1 as nvarchar(4000),
	@sSQL2 as nvarchar(4000)

Set @sSQL1=N'
Select  TransactionID,
	VoucherID,
	BatchID,
	AT9000.VoucherDate,
	VoucherTypeID, VoucherNo,
	Serial, InvoiceNo, InvoiceDate,
	AT9000.OriginalAmount, AT9000.ConvertedAmount,
	AT9000.CurrencyID, ExchangeRate,
	AT9000.InventoryID,
	At1302.InventoryName,
	AT1302.UnitID,
	VDescription, BDescription, TDescription, AT9000.DivisionID'

Set @sSQL2=N'	
From AT9000 Left join AT1302 on AT1302.InventoryID = AT9000.InventoryID and AT1302.DivisionID = AT9000.DivisionID
	         
Where AT9000.DivisionID = '''+@DivisionID+''' and
	TranMonth = '+str(@TranMonth)+' and
	TranYear = '+str(@TranYear)+' and
	VoucherID ='''+@VoucherID+''' and
	TransactionTypeID in (''T04'', ''T14'') '
--print @sSQL1+@sSQL2

If Not Exists (Select 1 From sysObjects Where Name ='AV3014')
	Exec ('Create view AV3014 as '+@sSQL1+@sSQL2)
Else
	Exec( 'Alter view AV3014 as '+@sSQL1+@sSQL2)