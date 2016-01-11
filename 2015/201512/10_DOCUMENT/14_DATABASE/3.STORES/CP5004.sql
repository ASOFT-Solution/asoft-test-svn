/****** Object:  StoredProcedure [dbo].[CP5004]    Script Date: 07/29/2010 15:09:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



--------Date:4/12/2006
--------Nguyen Thi Thuy Tuyen
--------Load edit  cho man hinh thay the thiet bi
-------Last Edit 10/06/2007  
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/
ALTER PROCEDURE  [dbo].[CP5004]
			@DivisionID nVarchar (50),
			@TransactionID nVarchar(50)
as
 Declare @sSQL nVarchar (4000)
Set @sSQL = '

SELECT 
	CT5002.DivisionID,
	CT5002.Orders, 
	CT5002.TransactionID, 
	CT5002.VoucherNo, 
	CT5002.VoucherID, 
	CT5002.RevokeInventoryID, 
	AT1302.InventoryName as RevokeInventoryName,
	CT5002.RevokeQuantity, 
	CT5002.RevokeSerial, 
	CT5002.ReplaceInventoryID,
	T02.InventoryName as ReplaceInventoryName,
	CT5002.ReplaceQuantity, 
	CT5002.ReplaceSerial, 
	CT5002.Notes,
	Isnull (CT5001.SubQuantity,CT4001.ActualQuantity) as SubQuantity


From CT5002
	Inner Join  AT1302  on AT1302.InventoryID = CT5002.RevokeInventoryID and AT1302.DivisionID = CT5002.DivisionID
	Inner Join  AT1302 T02 on T02.InventoryID = CT5002.ReplaceInventoryID and T02.DivisionID = CT5002.DivisionID
	Inner Join  CT4002 on CT4002.VoucherNo =CT5002.VoucherNo and CT4002.DivisionID =CT5002.DivisionID
	left Join  CT5001 on CT5001.TRansactionID = CT5002.TransactionID and CT5001.DivisionID = CT5002.DivisionID
	left Join  CT4001 on CT4001.TRansactionID = CT5002.TransactionID and CT4001.DivisionID = CT5002.DivisionID
Where  CT4002.DivisionID = ''' +@DivisionID+'''  and
	CT4002.TransactionID = ''' + @TransactionID+''' 
	
	 '

---Print  @sSQL

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'CV5004')
	Exec('Create View CV5004 ---tao boi CP5004
		 as '+@sSQL)
Else
	Exec('Alter View CV5004 ---tao boi CP5004
		 as '+@sSQL)