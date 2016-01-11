/****** Object:  StoredProcedure [dbo].[CP5000]    Script Date: 07/29/2010 15:04:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


----------Date: 31/10/2006
--------Nguyen Thi Thuy Tuyen
--------Lay du lieu co man hinh truy van thiet bi he thong
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/
ALTER PROCEDURE  [dbo].[CP5000]
			@DivisionID nVarchar (50)

as
 Declare @sSQL1 nVarchar (4000),
	@sSQL2 nVarchar (4000)
------------Tao Master -----
Set @sSQL1 = '
Select 
	CT5000.VoucherID,
	CT5000.WMfileID,
	CT4000.WMFileName,
	CT5000.InventoryID, 
	AT1302.InventoryName,
	AT1301.InventoryTypeID,
	AT1301.InventoryTypeName,
	CT5000.Serial, 
	CT5000.Hostname, 
	CT5000.Version, 
	CT5000.Patch, 
	CT5000.HostID, 
	CT5000.TranMonth,
	CT5000.TranYear,
	CT5000.Description, 
	CT5000.CreateDate, 
	CT5000.CreateUserID, 
	CT5000.LastModifyDate, 
	CT5000.LastModifyUserID, 
	CT5000.Disabled,
	CT5000.DivisionID
From CT5000
	Inner Join CT4000 on CT4000.WMFileID = CT5000.WMFileID and CT4000.DivisionID = CT5000.DivisionID
	Left Join AT1302 on AT1302.InventoryID = CT5000.InventoryID and AT1302.DivisionID = CT5000.DivisionID
	Inner Join AT1301  on AT1301.InventoryTypeID =AT1302.InventoryTypeID and AT1301.DivisionID =AT1302.DivisionID
Where  CT4000.DivisionID = ''' +@DivisionID+ '''

'
----Print @sSQL1
If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'CV5000')
	Exec('Create View CV5000 ---tao boiCP5000
		 as '+@sSQL1)
Else
	Exec('Alter View CV5000 ---tao boi  CP5000
		 as '+@sSQL1)

---------------------Tao Detai -----------------------------------

Set @sSQL2 ='
Select 
	CT5001.DivisionID,
	CT5001.VoucherID,
	CT5001.TransactionID, 
	CT5001.Orders,
	CT5001.SubInventoryID, 
	AT1302.InventoryName as SubInventoryName,
	CT5001.UnitID, 
	AT1304.UnitName,
	CT5001.SubQuantity, 
	CT5001.SubSerial, 
	CT5001.SubStatus, 
	CV1001.Description as SubStatusName,
	CT5001.Notes 
From CT5001
	Left Join AT1302 on AT1302.InventoryID = CT5001.SubInventoryID and AT1302.DivisionID = CT5001.DivisionID
	Left Join AT1304 on AT1304.UnitID = CT5001.UnitID and AT1304.DivisionID = CT5001.DivisionID
	Left Join CV1001 on CV1001.Status = CT5001.SubStatus and CV1001.DivisionID = CT5001.DivisionID
			and TypeID =''SI''
'
If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'CV5001')
	Exec('Create View CV5001 ---tao boi CP5000
		 as '+@sSQL2)
Else
	Exec('Alter View CV5001 ---tao boi CP5000
		 as '+@sSQL2)