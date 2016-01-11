/****** Object:  StoredProcedure [dbo].[AP3722]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Nguyen Quoc Huy, Date: 28/04/2008
---- Purpose: Lay du lieu ke thua  phieu nhap kho mua hang.
---- Chi cho ke thua 1 lan cho phieu mua hang nhap kho, neu ke thua nhieu lan thi khong phan bo duoc chi phi mua hang.
---- Mua dich vu thi ke thua duoc nhieu lan.

/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
ALTER PROCEDURE  [dbo].[AP3722] 	@DivisionID as nvarchar(50),
					@FromMonth as int,
					@FromYear as int,
					@ToMonth as int,
					@ToYear as int,
					@isStock as int
 

 AS
Declare @sSQL as nvarchar(4000),
  	@sTimeWhere01  as nvarchar(200),
	@sTimeWhere02  as nvarchar(200)

Set @sTimeWhere01 = '(OT3001.TranMonth + OT3001.TranYear*100 Between ('+str(@FromMonth)+' + '+str(@FromYear)+'*100) and ('+str(@ToMonth)+' + '+str(@ToYear)+'*100))  '
Set @sTimeWhere02 = '(AT9000.TranMonth + AT9000.TranYear*100 Between ('+str(@FromMonth)+' + '+str(@FromYear)+'*100) and ('+str(@ToMonth)+' + '+str(@ToYear)+'*100))  '


If @isStock = 1
Set @ssQL='
	Select 	VoucherID,
		null as TransactionID, 
		0 as Choose,
		VoucherNo,
		VoucherDate,
		Description,
		AT2006.ObjectID,
		ObjectName,
		WareHouseID,
		RefNo01,RefNo02 ,
		AT2006.DivisionID
	From AT2006  
		left join AT1202 on AT1202.ObjectID = AT2006.ObjectID and AT1202.DivisionID = AT2006.DivisionID 

	Where  	AT2006.DivisionID ='''+@DivisionID+''' and
		TranMonth ='+Str(@FromMonth)+' and
		TranYear ='+Str(@FromYear)+'  and
		AT2006.KindVoucherID in (15) and 
		VoucherID not in (Select isnull(ReVoucherID,'''') From AT9000 
					Where TransactionTypeID =''T30'' and DivisionID ='''+@DivisionID+''' And TranMonth ='+Str(@FromMonth)+'  And TranYear = '+Str(@FromYear)+') 
'

-----Ket hop voi cac don hang dich vu VoucherTypeID =POS
Else

Set @ssQL='
	Select 	distinct
		OT3001.PorderID as VoucherID, 
		OT3002.TransactionID, 
		0 as Choose, 
		OT3001.VoucherNo, 
		OT3001.OrderDate as VoucherDate, 
		OT3001.Description, 
		OT3001.ObjectID,  
		AT1202.ObjectName, 
		'''' as WareHouseID,
        OT3001.DivisionID

	From OT3001 
		Left join AT1202 on AT1202.ObjectID = OT3001.ObjectID and AT1202.DivisionID = OT3001.DivisionID   
		Left join OT3002 on OT3001.PorderID = OT3002.PorderID and OT3001.DivisionID = OT3002.DivisionID
	Where 	VoucherTypeID =''POS'' and ' + @sTimeWhere01 + ' and
		OT3001.DivisionID ='''+@DivisionID+''' and 
		----OT3001.POrderID  not in (Select isnull(ReVoucherID,'''') From AT9000 Where TransactionTypeID =''T30'' and DivisionID ='''+@DivisionID+'''  and ' + @sTimeWhere01 + ')
		-----OT3002.TransactionID  not in (Select isnull(ReTransactionID,'''') From AT9000 Where TransactionTypeID =''T30'' and DivisionID ='''+@DivisionID+'''  and ' + @sTimeWhere01 + ')
		(( Round(OT3002.OrderQuantity,0) - (select isnull(sum(isnull(Quantity,0)),0) from AT9000 Where AT9000.InventoryID = OT3002.InventoryID and OT3002.TransactionID = AT9000.ReTransactionID  ))>=1
			or ( OT3001.OrderStatus = 1 ))


'
-- and ' + @sTimeWhere + ')

--Print @sSQL

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'AV3722')
	Exec('Create View AV3722 as '+@ssql)

Else
	Exec('Alter View AV3722 as '+@ssql)
GO
