/****** Object:  StoredProcedure [dbo].[AP3096]    Script Date: 07/29/2010 10:50:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by B.Anh, Date: 05/08/2009
---- Purpose: Lay du lieu ra man hinh truy van phieu xuat kho ban hang
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3096] 	@DivisionID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int,
					@ConnID nvarchar(50) =''
					

 AS
Declare @sSQL as nvarchar(4000)


Set @ssQL='


Select  AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear,
	AT9000.VoucherID, AT9000.BatchID,	  
	AT9000.VoucherDate, AT9000.VoucherNo, AT9000.Serial, AT9000.InvoiceNo,
	AT9000.VoucherTypeID,
	AT9000.VATTypeID, AT9000.InvoiceDate,
	AT9000.VDescription,
	AT9000.BDescription,
	AT9000.CurrencyID,
	AT9000.ExchangeRate,
	Sum ( Case when AT9000.TransactionTypeID =''T40'' then AT9000.OriginalAmount else 0 end ) as OriginalAmount,
	Sum ( Case when AT9000.TransactionTypeID =''T40'' then AT9000.ConvertedAmount else 0 end ) as ConvertedAmount,

	AT9000.ObjectID,
	(Case when AT1202.IsUpdateName = 0 then AT1202.ObjectName else AT9000.VATObjectName End) as  ObjectName,
	DueDate,
	--Ltrim(Rtrim(OrderID)) as OrderID,
	isnull(IsStock,0) as IsStock, 
	isnull((Select sum(ConvertedAmount)  From AT9000 C Where C.VoucherID = AT9000.VoucherID and TransactionTypeID =''T54''),0)  as CommissionAmount,
	Sum ( Case when TransactionTypeID =''T41'' then ConvertedAmount else 0 end ) as TaxAmount
	
From AT9000 inner join AT1202 on AT1202.ObjectID = AT9000.ObjectID and AT1202.DivisionID = AT9000.DivisionID
Where TransactionTypeID in (''T40'',''T41'') and 
	Left(AT9000.VoucherID,2) = ''AV'' and 
	AT9000.TableID in ( ''AT9000'') and

	AT9000.DivisionID ='''+@DivisionID+''' and
	AT9000.TranMonth ='+Str(@TranMonth)+' and
	AT9000.TranYear ='+Str(@TranYear)+'  


Group by  AT9000.DivisionID, AT9000.TranMonth, AT9000.TranYear,
	AT9000.VoucherID, AT9000.BatchID,	  
	AT9000.VoucherDate, AT9000.VoucherNo, AT9000.Serial, AT9000.InvoiceNo,
	AT9000.VoucherTypeID, AT9000.VATTypeID, AT9000.InvoiceDate,
	AT9000.VDescription,
	AT9000.BDescription,
	AT9000.CurrencyID,
	AT9000.ExchangeRate,	
	AT9000.ObjectID,
	ObjectName,
	DueDate,
	--OrderID,
	AT1202.IsUpdateName, AT9000.VATObjectName,
	isnull(IsStock,0) '


---Print @sSQL

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name =  'AV3096' + @ConnID )
	Exec('Create View AV3096' +@ConnID + ' as '+@ssql)
Else
	Exec('Alter View AV3096'+ @ConnID +' as '+@ssql)
