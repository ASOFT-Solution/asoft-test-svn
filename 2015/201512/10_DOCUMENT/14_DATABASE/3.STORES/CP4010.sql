/****** Object:  StoredProcedure [dbo].[CP4010]    Script Date: 08/04/2010 10:14:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--------Date: 2/11/2006
--------Cearter:Nguyen Thi Thuy Tuyen
--------Lay du lieu phieu ban hang tra ra man hinh lap ho so bao hanh bao tri
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[CP4010]
			@DivisionID nvarchar (50),
			@VoucherID nvarchar (50)


as
 Declare @sSQL nvarchar (4000)
Set @sSQL = '
Select   
	AT2007.DivisionID,
	AT2007.TransactionID,
	AT2006.VoucherNo,
	VoucherDate,
	AT2007.VoucherID,
	null as InvoiceNo,
	null as InvoiceDate,
	AT2007.UnitID,
	AT2007.InventoryID,
	AT1302.InventoryName,
	AT2007.ActualQuantity as Quantity,
	AT2006.ObjectID,
	AT1202.ObjectName,
	 null as TransactionTypeID,
	AT2007.Notes as TDescription,
	AT2006.Description as contractNo
From AT2007	
	 Inner Join AT2006 on AT2006.VoucherID = AT2007.VoucherID and AT2006.DivisionID = AT2007.DivisionID
	 Left Join AT1302 on AT1302.InventoryID = AT2007.InventoryID and AT1302.DivisionID = AT2007.DivisionID
	 Left Join AT1202 on AT1202.ObjectID = AT2006.ObjectID and AT1202.DivisionID = AT2006.DivisionID
Where
AT2006.DivisionID = ''' +@DivisionID+''' and
 AT2006.VoucherID ='''+@VoucherID+''' 

'

---Print @sSQL
If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'CV4010')
	Exec('Create View CV4010 ---tao boi CP4010
		 as '+@sSQL)
Else
	Exec('Alter View CV4010 ---tao boi CP4010
		 as '+@sSQL)
