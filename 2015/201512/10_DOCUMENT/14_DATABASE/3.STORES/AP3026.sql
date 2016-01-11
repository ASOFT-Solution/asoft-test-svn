/****** Object:  StoredProcedure [dbo].[AP3026]    Script Date: 07/29/2010 09:04:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3026] 
as
declare @sSQL as nvarchar(4000) 
set @sSQL='
Select  VoucherID, 
	BatchID,
	Serial,
	InvoiceNo,
	InvoiceDate,
 	CurrencyID,
	Sum(ConvertedAmount)  as TurnOverAmount,
	Sum(TaxConvertedAmount) TaxAmount, DivisionID
	From AV3024
	Group By VoucherID,
		 BatchID,
		 Serial,
		 InvoiceNo,
		 InvoiceDate,
	 	 CurrencyID ,Duedate, DivisionID'

If not exists (Select top 1 1 From SysObjects Where name = 'AV3026' and Xtype ='V')
	Exec ('Create view AV3026 	--Created by AP3026
			as '+ @sSQL)
Else
	Exec ('Alter view AV3026 	--Created by AP3026
			as '+ @sSQL)
						