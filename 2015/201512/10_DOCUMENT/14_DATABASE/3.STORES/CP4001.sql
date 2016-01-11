/****** Object:  StoredProcedure [dbo].[CP4001]    Script Date: 07/29/2010 14:13:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO





----------Date: 31/10/2006
--------Nguyen Thi Thuy Tuyen
--------Lay du lieu co man hinh truy van Ho so bao hanh bao tri
-----Las5t Edt 10/06/2007
----Edit by Nguyen Quoc Huy, Date 02/08/2008
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[CP4001]
			@DivisionID nVarchar (50)

as
 Declare @sSQL1 nVarchar (4000),
	@sSQL2 nVarchar (4000)
------------Tao Master -----
Set @sSQL1 = '
Select
	CT00.S1,
	CT00.S2,
	CT00.S3,
	WMFileID, 
	WMFileName, 
	WMFileDate, 
	ReVoucherID, 
	CT00.ReVoucherNo,
	
	CT00.DivisionID, 
	CT00.TranMonth, 
	CT00.TranYear, 
	CT00.ObjectID, 
	isnull (CT00.ObjectName, AT1202.ObjectName)as ObjectName,  
	CT00.Contact, CT00.PhoneNumber,
	Site, 
	CT00.EmployeeID, 
	AT1103.fullName as EmployeeName,
	SupContractNo, 
	SupContractDate, 
	SupStartDate, 
	SupEndDate, 
	CT00.InvoiceNo,
	CT00.ContractNo, 
	CT00.ContractDate, 
	StartDate, 
	CT00.EndDate, 
	CT00.ServiceTypeID, 
	ServiceTypeName,
	CT00.ServiceLevelID, 
	ServiceLevelName,
	ToPay, 
	Features, 
	Description,
	CT00.Disabled,
	CT00.InventoryTypeID,
	CT00.CObjectID,
	T02.ObjectName AS CObjectName,
	CT00.IsUpdateName
	
From CT4000  CT00 left Join AT1202 On AT1202.ObjectID = CT00.ObjectID and AT1202.DivisionID = CT00.DivisionID
		 left Join AT1202 T02 on T02.ObjectID = CT00.CObjectID and T02.DivisionID = CT00.DivisionID
		 Left Join CT1001 on CT1001.ServiceTypeID = CT00.ServiceTypeID and CT1001.DivisionID = CT00.DivisionID
		 Left Join CT1002 on CT1002.ServiceLevelID = CT00.ServiceLevelID and CT1002.DivisionID = CT00.DivisionID
		 left join AT1103 on AT1103.EmployeeID = CT00.EmployeeID and AT1103.DivisionID = CT00.DivisionID 
		
Where  CT00.DivisionID = ''' +@DivisionID+ '''

'
----Print @sSQL1
If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'CV4001')
	Exec('Create View CV4001 ---tao boiCP4001
		 as '+@sSQL1)
Else
	Exec('Alter View CV4001 ---tao boi  CP4001
		 as '+@sSQL1)

---------------------Tao Detai -----------------------------------

Set @sSQL2 ='
select 
	CT01.WMFileID, 
	CT01.TransactionID, 
	CT01.ReTransactionID,
	CT01.Orders, 
	CT01.InventoryID, 
	AT1302.InventoryName,
	CT01.UnitID, 
	AT1304.UnitName,
	CT01.ActualQuantity, 
	CT01.UnitPrice, 
	CT01.ConvertedAmount, 
	CT01.Serial,
	CT01.StartDate, 
	CT01.EndDate, 
	CT01.Notes, 
	CT01.TranMonth, 
	CT01.TranYear, 
	CT01.DivisionID,
	AT1302.InventoryTypeID,
	CT01.Ana01ID,
	CT01.Ana02ID,
	CT01.Ana03ID,
	CT01.Ana04ID,
	CT01.Ana05ID,
	CT01.IsSystem,
	0 as IsUsed,
CT01.Disabled
From CT4001 CT01 
	Left Join  AT1302 on  AT1302.InventoryID = CT01.InventoryID and AT1302.DivisionID = CT01.DivisionID 
	left join AT1304 on AT1304.UnitID = CT01.UnitID and AT1304.DivisionID = CT01.DivisionID
Where CT01. DivisionID = ''' +@DivisionID+ '''
 and CT01.TransactionID  not in ( Select VoucherID From CT5001)
Union
select 
	CT01.WMFileID, 
	CT01.TransactionID, 
	CT01.ReTransactionID,
	CT01.Orders, 
	CT01.InventoryID, 
	AT1302.InventoryName,
	CT01.UnitID, 
	AT1304.UnitName,
	CT01.ActualQuantity, 
	CT01.UnitPrice, 
	CT01.ConvertedAmount, 
	CT01.Serial,
	CT01.StartDate, 
	CT01.EndDate, 
	CT01.Notes, 
	CT01.TranMonth, 
	CT01.TranYear, 
	CT01.DivisionID,
	AT1302.InventoryTypeID,
	CT01.Ana01ID,
	CT01.Ana02ID,
	CT01.Ana03ID,
	CT01.Ana04ID,
	CT01.Ana05ID,
	CT01.IsSystem,
	1 as IsUsed,
CT01.Disabled
From CT4001 CT01 
	Left Join  AT1302 on  AT1302.InventoryID = CT01.InventoryID and AT1302.DivisionID = CT01.DivisionID 
	left join AT1304 on AT1304.UnitID = CT01.UnitID and AT1304.DivisionID = CT01.DivisionID
Where CT01. DivisionID = ''' +@DivisionID+ '''
 and CT01.TransactionID  in ( Select VoucherID From CT5001)


'


If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'CV4011')
	Exec('Create View CV4011 ---tao boi CP4001
		 as '+@sSQL2)
Else
	Exec('Alter View CV4011 ---tao boi CP4001
		 as '+@sSQL2)