IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3054]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3054]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





--Created by Nguyen Quoc Huy
--Date 05/10/2005
--Purpose:Hang ban tra lai
--Last Edit ThuyTuyen Them truong AT9000.DiscountRate,27/03/2007
---- SQL 1 -- tra ra doanh so
-- Edited by: [GS] [Tố Oanh] [29/07/2010]
--Edit by: Mai Duyen, date 17/10/2014
--Purpose: bo sung them field AT1202.O01ID,AT1202.O02ID,AT1202.O03ID,AT1202.O04ID,AT1202.O05ID,AT1202.Note,AT1202.Note1 (KH Thuận Lợi)
---------------------------------------------------------

CREATE procedure [dbo].[AP3054] @DivisionID as nvarchar(50),@sSQLWhere as nvarchar(4000) 
as 
Declare @sSQL as nvarchar(4000)
Declare @SQLL as nvarchar(4000)
Set @sSQL='
Select 	VoucherID, BatchID,  Serial, InvoiceNo, InvoiceDate, AT9000.CurrencyID, AT9000.ObjectID, ObjectName, BDescription,
	Sum(OriginalAmount) as OriginalAmount,
	Sum(ConvertedAmount) as ConvertedAmount,
	 0 as TaxConvertedAmount,
	AT9000.VoucherNo,
	AT9000.VoucherDate,
	AT9000.DiscountRate, AT9000.DivisionID,
	AT1202.O01ID,AT1202.O02ID,AT1202.O03ID,AT1202.O04ID,AT1202.O05ID,AT1202.Note,AT1202.Note1
From AT9000 left join AT1202 on AT9000.ObjectID=AT1202.ObjectID and AT9000.DivisionID=AT1202.DivisionID
Where TransactionTypeID =''T24''
           and  AT9000.DivisionID='''+@DivisionID+''' and '+@sSQLWhere+'
Group By VoucherID, BatchID, Serial, InvoiceNo, InvoiceDate,AT9000.CurrencyID, AT9000.ObjectID,ObjectName,BDescription,AT9000.VoucherNo,
	AT9000.VoucherDate,AT9000.DiscountRate, AT9000.DivisionID,
	AT1202.O01ID,AT1202.O02ID,AT1202.O03ID,AT1202.O04ID,AT1202.O05ID,AT1202.Note,AT1202.Note1
Union All
---- SQL 2 tra ra thue
Select 	  VoucherID, BatchID,  Serial, InvoiceNo, InvoiceDate,AT9000.CurrencyID,  AT9000.ObjectID,ObjectName,BDescription,
	0 as OriginalAmount,
	0 as ConvertedAmount,	
	Sum(ConvertedAmount)  as TaxConvertedAmount,
	AT9000.VoucherNo,
	AT9000.VoucherDate,
	0 as DiscountRate, AT9000.DivisionID,
	AT1202.O01ID,AT1202.O02ID,AT1202.O03ID,AT1202.O04ID,AT1202.O05ID,AT1202.Note,AT1202.Note1
From AT9000  left join AT1202 on AT9000.ObjectID=AT1202.ObjectID and AT9000.DivisionID=AT1202.DivisionID
Where TransactionTypeID =''T34''
           and AT9000.DivisionID='''+@DivisionID+''' and '+@sSQLWhere+'
 Group  By VoucherID, BatchID, Serial, InvoiceNo, InvoiceDate, AT9000.CurrencyID, AT9000.ObjectID,ObjectName,BDescription, AT9000.VoucherNo,
	AT9000.VoucherDate, AT9000.DivisionID,
	AT1202.O01ID,AT1202.O02ID,AT1202.O03ID,AT1202.O04ID,AT1202.O05ID,AT1202.Note,AT1202.Note1
'
If not Exists (Select top 1 1 From SysObjects Where Xtype ='V' and name ='AV3054')
	 Exec ('Create view AV3054 as '  +@sSQL)
Else
	Exec ('Alter view AV3054 as '+@sSQL)	


--print @sSQL
Set @SQLL='Select  VoucherID, 
		BatchID,
		Serial,
		InvoiceNo,
		InvoiceDate,
 		CurrencyID,ObjectID,ObjectName ,
		Sum(OriginalAmount) as OriginalAmount,
		BDescription,
		Sum(ConvertedAmount) as TurnOverAmount,
		Sum(TaxConvertedAmount) as TaxAmount,
		VoucherNo,
		VoucherDate,
		DiscountRate, DivisionID,
		O01ID,O02ID,O03ID,O04ID,O05ID,Note,Note1
	From AV3054
		Group By VoucherID,
		 BatchID,
		 Serial,
		 InvoiceNo,
		 InvoiceDate,
	 	 CurrencyID, ObjectID,ObjectName ,  BDescription, VoucherNo, DiscountRate,
		VoucherDate, DivisionID,
		O01ID,O02ID,O03ID,O04ID,O05ID,Note,Note1 '

--print @SQLL
If not exists (Select top 1 1 From SysObjects Where name = 'AV3056' and Xtype ='V')
	 Exec('Create view AV3056 as '+@SQLL) 
Else
	Exec ('Alter view AV3056 as '+@SQLL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

