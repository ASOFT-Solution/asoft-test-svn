/****** Object:  StoredProcedure [dbo].[AP3723]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Nguyen Quoc Huy, Date: 30/08/2007
---- Purpose: Lay du lieu ke thua  phieu nhap kho mua hang.
---- Chi cho ke thua 1 lan cho phieu mua hang nhap kho, neu ke thua nhieu lan thi khong phan bo duoc chi phi mua hang.
---- Mua dich vu thi ke thua duoc nhieu lan.

/********************************************
'* Edited by: [GS] [My Tuyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3723] 	@DivisionID as nvarchar(50),
					@FromMonth as int,
					@FromYear as int,
					@ToMonth as int,
					@ToYear as int,
					@isStock as int,
					@VoucherIDList as nvarchar(2000) ,
					@TransactionIDList nvarchar(2000) =''

 AS
Declare @sSQL as nvarchar(4000),
  	@sTimeWhere  as nvarchar(200)


Set @sTimeWhere = '(OT3001.TranMonth + OT3001.TranYear*100 Between ('+str(@FromMonth)+' + '+str(@FromYear)+'*100) and ('+str(@ToMonth)+' + '+str(@ToYear)+'*100))  '


If @isStock = 1

Set @ssQL='
Select 		
	AT2006.ReDeTypeID,		
	AT2006.VoucherTypeID,		
	AT2006.VoucherNo,		
	AT2006.VoucherDate,		
	AT2006.RefNo01,
	AT2006.RefNo02,
	AT2006.RDAddress,
	AT2006.ContactPerson,
	AT1302.InventoryTypeID,
	AT2006.ObjectID,	
	AT2006.VATObjectName,	
	AT2006.WareHouseID ,
	AT2006.EmployeeID,	
	AT2007.TransactionID,        	
	AT2006.VoucherID,
       	AT2006.BatchID,
	AT2007.InventoryID,	
	AT1302.InventoryName,        	
	AT2007.UnitID,	
	AT2007.ActualQuantity,       	
	AT2007.UnitPrice,       	
	AT2007.OriginalAmount,      	
	AT2007.ConvertedAmount,     	
	AT2006.Description,	
	AT2007.DebitAccountID, 	
	AT2007.CreditAccountID,
	AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID,	AT2007.Ana04ID, AT2007.Ana05ID, 
	AT2007.Orders,    AT2007.Notes as Notes, AT2007.ConversionFactor,
	AT2007.OrderID,
	AT2007.ReSPVoucherID,        AT2007.ReSPTransactionID,
	AT1302.MethodID,
	AT1302.AccountID,
	AT1302.Specification,
	AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
    AT2007.DivisionID

	
From AT2007 	inner join AT1302 on AT1302.InventoryID =AT2007.InventoryID and AT1302.DivisionID =AT2007.DivisionID
		Left join AT1304 on AT1304.UnitID = AT2007.UnitID and AT1304.DivisionID = AT2007.DivisionID
		inner join AT2006 on AT2006.VoucherID =AT2007.VoucherID and AT2006.DivisionID =AT2007.DivisionID
		

Where  	AT2007.DivisionID ='''+@DivisionID+''' and
	AT2007.TranMonth ='+Str(@FromMonth)+' and
	AT2007.TranYear ='+Str(@FromYear)+'  and
	AT2006.KindVoucherID in (15) and 
	AT2007.VoucherID in (' + @VoucherIDList +' ) 
'
-----Ket hop voi cac don hang dich vu VoucherTypeID =POS
Else

Begin
If isnull(@TransactionIDList,'') =''
Set @ssQL='
Select 		
	null as ReDeTypeID,		
	OT3001.VoucherTypeID,		
	OT3001.VoucherNo,		
	OT3001.OrderDate as VoucherDate,		
	OT3001.ReceivedAddress as RDAddress,
	Null as ContactPerson,
	AT1302.InventoryTypeID,
	OT3001.ObjectID,	
	null as VATObjectName,	
	null as WareHouseID ,
	OT3001.EmployeeID,	
	OT3002.TransactionID,        	
	OT3001.POrderID as VoucherID,
       	OT3002.TransactionID as BatchID,
	OT3002.InventoryID,	
	AT1302.InventoryName,        	
	OT3002.UnitID,	
	(OT3002.OrderQuantity - (select isnull(sum(isnull(Quantity,0)),0) from AT9000 Where AT9000.InventoryID = OT3002.InventoryID and OT3002.TransactionID = AT9000.ReTransactionID )) as ActualQuantity,
	OT3002.PurchasePrice as UnitPrice,       	
	OT3002.OriginalAmount,      	
	OT3002.ConvertedAmount,     	
	OT3001.Description,	
	''6427'' as DebitAccountID, 	---Mac dinh cho phong thu mua --> len ke toan se sua lai
	''6427'' as CreditAccountID,
	OT3002.Ana01ID, OT3002.Ana02ID, OT3002.Ana03ID,	OT3002.Ana04ID, 
	OT3002.Ana05ID, 
	OT3002.Orders,    OT3002.Description as Notes,
	1 as ConversionFactor,
	OT3002.POrderID,
	OT3002.POrderID as ReSPVoucherID,        OT3002.TransactionID as ReSPTransactionID,
	AT1302.MethodID,
	AT1302.AccountID,
	AT1302.Specification,
	AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
    OT3002.DivisionID


From OT3002 	inner join AT1302 on AT1302.InventoryID =OT3002.InventoryID and AT1302.DivisionID =OT3002.DivisionID
		Left join AT1304 on AT1304.UnitID = OT3002.UnitID and AT1304.DivisionID = OT3002.DivisionID
		inner join OT3001 on OT3001.POrderID =OT3002.POrderID and OT3001.DivisionID =OT3002.DivisionID
		

Where  	OT3001.DivisionID ='''+@DivisionID+''' and '  + @sTimeWhere + ' and 
	OT3001.VoucherTypeID =''POS'' and
	OT3002.POrderID in  (' + @VoucherIDList +' )  and
	----OT3002.TransactionID  not in (Select isnull(ReTransactionID,'''') From AT9000 Where TransactionTypeID =''T30'' and DivisionID ='''+@DivisionID+''' )
	( Round(OT3002.OrderQuantity,0) - (select isnull(sum(isnull(Quantity,0)),0) from AT9000 Where AT9000.InventoryID = OT3002.InventoryID and OT3002.TransactionID = AT9000.ReTransactionID  ))>=1

'
Else

Set @ssQL='
Select 		
	null as ReDeTypeID,		
	OT3001.VoucherTypeID,		
	OT3001.VoucherNo,		
	OT3001.OrderDate as VoucherDate,		
	OT3001.ReceivedAddress as RDAddress,
	Null as ContactPerson,
	AT1302.InventoryTypeID,
	OT3001.ObjectID,	
	null as VATObjectName,	
	null as WareHouseID ,
	OT3001.EmployeeID,	
	OT3002.TransactionID,        	
	OT3001.POrderID as VoucherID,
       	OT3002.TransactionID as BatchID,
	OT3002.InventoryID,	
	AT1302.InventoryName,        	
	OT3002.UnitID,	
	(OT3002.OrderQuantity - (select isnull(sum(isnull(Quantity,0)),0) from AT9000 Where AT9000.InventoryID = OT3002.InventoryID and OT3002.TransactionID = AT9000.ReTransactionID )) as ActualQuantity,
	OT3002.PurchasePrice as UnitPrice,       	
	OT3002.OriginalAmount,      	
	OT3002.ConvertedAmount,     	
	OT3001.Description,	
	''6427'' as DebitAccountID, 	---Mac dinh cho phong thu mua --> len ke toan se sua lai
	''6427'' as CreditAccountID,
	OT3002.Ana01ID, OT3002.Ana02ID, OT3002.Ana03ID,	OT3002.Ana04ID, 
	OT3002.Ana05ID, 
	OT3002.Orders,    OT3002.Description as Notes,
	1 as ConversionFactor,
	OT3002.POrderID,
	OT3002.POrderID as ReSPVoucherID,        OT3002.TransactionID as ReSPTransactionID,
	AT1302.MethodID,
	AT1302.AccountID,
	AT1302.Specification,
	AT1302.Notes01, AT1302.Notes02, AT1302.Notes03,
    OT3002.DivisionID

From OT3002 	inner join AT1302 on AT1302.InventoryID =OT3002.InventoryID and AT1302.DivisionID =OT3002.DivisionID
		Left join AT1304 on AT1304.UnitID = OT3002.UnitID and AT1304.DivisionID = OT3002.DivisionID
		inner join OT3001 on OT3001.POrderID =OT3002.POrderID and OT3001.DivisionID =OT3002.DivisionID
		

Where  	OT3001.DivisionID ='''+@DivisionID+''' and '  + @sTimeWhere + ' and 
	OT3001.VoucherTypeID =''POS'' and
	OT3002.POrderID in  (' + @VoucherIDList +' )  and OT3002.TransactionID in (' + @TransactionIDList +' ) and
	----OT3002.TransactionID  not in (Select isnull(ReTransactionID,'''') From AT9000 Where TransactionTypeID =''T30'' and DivisionID ='''+@DivisionID+''' )
	( Round(OT3002.OrderQuantity,0) - (select isnull(sum(isnull(Quantity,0)),0) from AT9000 Where AT9000.InventoryID = OT3002.InventoryID and OT3002.TransactionID = AT9000.ReTransactionID  ))>=1


'

End

--print @ssql

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'AV3723')
	Exec('Create View AV3723 as '+@ssql)

Else
	Exec('Alter View AV3723 as '+@ssql)
GO
