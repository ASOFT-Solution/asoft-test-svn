/****** Object:  StoredProcedure [dbo].[CP4003]    Script Date: 07/29/2010 14:15:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----------Date: 31/10/2006
--------Nguyen Thi Thuy Tuyen
--------In ho so bao hanh bao tri
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[CP4003]
			@DivisionID nVarchar (50),
			@TranMonth as int,
			@TranYear as int,
			@WMFileID nVarchar (50)


as
 Declare @sSQL nVarchar (4000)
Set @sSQL = '
Select
	CT00.WMFileID, 
	WMFileName, 
	WMFileDate, 
	ReVoucherID, 
	RevoucherNo,
	CT00.DivisionID, 
	CT00.TranMonth, 
	CT00.TranYear, 
	CT00.ObjectID, 
	isnull(CT00.ObjectName, AT1202.ObjectName)as ObjectName,  
	Contact, 
	Site, 
	CT00.EmployeeID, 
	AT1103.fullName as EmployeeName,
	SupContractNo, 
	SupContractDate, 
	--SupStartDate, 
	--SupEndDate, 
	CT00.InvoiceNo, 
	CT00.ContractDate,
	CT00.ContractNo, 
	CT00.StartDate, 
	CT00.EndDate, 
	---CT00.SystemID, 
	---CT1003.SystemName,
	CT00.ServiceTypeID, 
	ServiceTypeName,
	CT00.ServiceLevelID, 
	ServiceLevelName,
	ToPay, 
	Features, 
	Description,
	CT00.Disabled,
	CT01.TransactionID, 
	CT01.Orders, 
	CT01.InventoryID, 
	AT1302.InventoryName,
	CT01.UnitID, 
	AT1304.UnitName,
	CT01.ActualQuantity,
	CT01.Serial,
	CT01.Notes
		
From CT4000  CT00 
		left join CT4001 CT01 on CT01.WMFileID = CT00.WMFileID and CT01.DivisionID = CT00.DivisionID
		left Join AT1202 On AT1202.ObjectID = CT00.ObjectID and AT1202.DivisionID = CT00.DivisionID
		Left Join CT1001 on CT1001.ServiceTypeID = CT00.ServiceTypeID and CT1001.DivisionID = CT00.DivisionID
		Left Join CT1002 on CT1002.ServiceLevelID = CT00.ServiceLevelID and CT1002.DivisionID = CT00.DivisionID
		----Left Join CT1003 on CT1003.SystemID = CT00.SystemID
		left join AT1103 on AT1103.EmployeeID = CT00.EmployeeID and AT1103.DivisionID = CT00.DivisionID 
		left join AT1304 on AT1304.UnitID = CT01.UnitID and AT1304.DivisionID = CT01.DivisionID
		Left Join  AT1302 on  AT1302.InventoryID = CT01.InventoryID and AT1302.DivisionID = CT01.DivisionID 
Where  CT00.DivisionID = ''' +@DivisionID+''' and
	
	CT00.WMFileID ='''+@WMFileID+''' '

---Print @sSQL
If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'CV4003')
	Exec('Create View CV4003 ---tao boi CP4003
		 as '+@sSQL)
Else
	Exec('Alter View CV4003 ---tao boi CP4003
		 as '+@sSQL)