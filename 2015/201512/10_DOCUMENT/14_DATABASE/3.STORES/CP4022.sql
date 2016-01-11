/****** Object:  StoredProcedure [dbo].[CP4022]    Script Date: 07/29/2010 14:54:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---------Date: 21/12/2006
--------Nguyen Thi Thuy Tuyen
--------In Thay the thiet bi
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[CP4022]
			@DivisionID nVarchar (50),
			@VoucherNo nVarchar(50)

as
 Declare @sSQL  nVarchar (4000)
	
Set @sSQL = '
Select 
	CT5002.DivisionID,
	CT5002.Orders, 
	CT5002.TransactionID, 
	CT5002.VoucherNo, 
	CT4002.FixDate,
	CT5002.VoucherID, 
	CT5002.RevokeInventoryID, 
	A.InventoryName as  RevokeInventoryName,
	CT5002.RevokeQuantity, 
	CT5002.RevokeSerial, 
	CT5002.ReplaceInventoryID,
	B.InventoryName as  ReplaceInventoryName, 
	CT5002.ReplaceQuantity, 
	CT5002.ReplaceSerial, 
	CT5002.Notes
	

From CT5002 
	left Join CT4002 on CT4002.VoucherNo = CT5002.VoucherNo and CT4002.DivisionID = CT5002.DivisionID
	left Join AT1302  A  on A.InventoryID = CT5002.RevokeInventoryID and A.DivisionID = CT5002.DivisionID
	left Join AT1302  B on B.InventoryID = CT5002.ReplaceInventoryID and B.DivisionID = CT5002.DivisionID
	
Where CT5002.VoucherNo ='''+ @VoucherNo +'''
        and CT4002.DivisionID ='''+ @DivisionID +'''
	

'
---Print @sSQL
If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'CV4022')
	Exec('Create View CV4022 ---tao boiCP4022
		 as '+@sSQL)
Else
	Exec('Alter View CV4022 ---tao boi  CP4022
		 as '+@sSQL)