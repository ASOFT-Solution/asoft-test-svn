/****** Object:  StoredProcedure [dbo].[CP4002]    Script Date: 07/29/2010 14:12:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





---------Date: 7/11/2006
--------Nguyen Thi Thuy Tuyen
--------Lay du lieu in bao cao nhat ky dich vu
------Last  Edit 12-03-2006 Lay truong VoucherTypeID
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[CP4002]
			@TransactionID nVarchar (50)

as
 Declare @sSQL  nVarchar (4000)
	
Set @sSQL = '
Select 
	CT4002.TranMonth, 
	CT4002.TranYear, 
	CT4002.DivisionID, 
	CT4002.WMFileID, 
	CT4000.WMFileName, 
	CT4000.ObjectID,
	AT1202.ObjectName,
	AT1202.Address,
	AT1202.Fax,
	AT1202.Email,
	AT1202.Tel, 
	CT4000.Contact ,
	CT4000.ContractNo,
	CT4002.TransactionID, 
	CT4002.CaseID, 
	CT4002.TaskID, 
	CT4002.InventoryID, 
	AT1302.InventoryName,
	CT4002.Serial,
	CT4002.UnitID, 
	CT5000.HostID, 
	CT5000.Hostname, 
	CT5000.Version, 
	CT5000.Patch,
	CT4002.EmployeeID, 
	AT1103.FullName as EmployeeName,
	CT4000. ServiceTypeID,
	CT1001. ServiceTypeName,
	CT4002.ErrorStatusID, 
	CT2001.ErrorStatusName,
	CT4002.ErrorLevelID, 
	CT2002.ErrorLevelName,
	CT4002.ErrorTypeID, 
	CT2003.ErrorTypeName,
	CT4002.FileLog, 
	CT4002.ErrorIssueID,
	CT2004.ErrorIssueName, 
	CT4002.Repair, 
	CT4002.Signature01, 
	CT4002.IsTest, 
	CT4002.FixDate, 
	CT4002.StartTime, 
	CT4002.EndTime, 
	CT4002.MonitorTime, 
	CT4002.FixNextDate, 
	CT4002.Signature02, 
	CT4002.Notes01, 
	CT4002.Notes02, 
	CT4002.Notes03, 
	CT4002.Notes04, 
	CT4002.Notes05,
	CT4000.Site,
	CT4002.RequestNo, 
	CT4002.ReVoucherID, 
	CT4002.Finish, 
	-----CT2008.StatusName,
	CT4002.TimelinessID, 
	CT2005.TimelinessName,
	CT4002.MannerID, 
	CT2006.MannerName,
	CT4002.QualityID,
	CT2007.QualityName,
	CT4002.VoucherTypeID,
	CT4002.IsReplace
From CT4002
	Left Join CT4000 on CT4000.WMFileID = CT4002.WMFileID and CT4000.DivisionID = CT4002.DivisionID
	
	Left Join AT1302 on AT1302.InventoryID = CT4002.InventoryID and AT1302.DivisionID = CT4002.DivisionID
	Left Join CT5000  on CT5000.InventoryID = CT4002.InventoryID and CT5000.DivisionID = CT4002.DivisionID
				And CT5000.Serial = CT4002.Serial 
	Left Join AT1103 on AT1103.EmployeeID = CT4002.EmployeeID and 
				And AT1103.DivisionID = CT4002.DivisionID
	Left Join AT1202 on AT1202.ObjectID = CT4000.ObjectID and AT1202.DivisionID = CT4000.DivisionID
	
	Left Join CT1001  on CT1001.ServiceTypeID = CT4000.ServiceTypeID and CT1001.DivisionID = CT4000.DivisionID
	Left Join CT2001  on CT2001.ErrorStatusID = CT4002.ErrorStatusID and CT2001.DivisionID = CT4002.DivisionID
	Left Join CT2002  on CT2002.ErrorLevelID = CT4002.ErrorLevelID and CT2002.DivisionID = CT4002.DivisionID
	Left Join CT2004  on CT2004.ErrorIssueID = CT4002.ErrorIssueID and CT2004.DivisionID = CT4002.DivisionID 
	Left Join CT2003  on CT2003.ErrorTypeID = CT4002.ErrorTypeID and CT2003.DivisionID = CT4002.DivisionID 
	left  Join CT2005 on CT2005.TimelinessID = CT4002.TimelinessID and CT2005.DivisionID = CT4002.DivisionID
	left  Join CT2006 on CT2006.MannerID = CT4002.MannerID and CT2006.DivisionID = CT4002.DivisionID
	left Join CT2007 on CT2007.QualityID = CT4002.QualityID and CT2007.DivisionID = CT4002.DivisionID
	
Where  CT4002.TransactionID = ''' +@TransactionID+ '''

'
---Print @sSQL
If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'CV4002')
	Exec('Create View CV4002 ---tao boiCP4002
		 as '+@sSQL)
Else
	Exec('Alter View CV4002 ---tao boi  CP4002
		 as '+@sSQL)