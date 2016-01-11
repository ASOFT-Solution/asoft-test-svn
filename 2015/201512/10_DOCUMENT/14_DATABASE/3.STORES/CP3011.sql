/****** Object:  StoredProcedure [dbo].[CP3011]    Script Date: 07/29/2010 14:09:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----------NguyenThuyTuyen
-------19/12/2006
-----Lay du lieu cho man hinh lich su lam viec
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/


ALTER PROCEDURE 	 [dbo].[CP3011] @DivisionID as nvarchar(50),
					@WMFileID as nVarchar(50)					
 AS

 Declare @sSQL nVarchar (4000)

Set @sSQL ='
Select 
	CT4002.VoucherNo, 
	CT4002.TranMonth, CT4002.TranYear, 
	CT4002.DivisionID, CT4002.WMFileID,
	CT4000.WMFileName,CT4000.ContractNo,CT4000.ObjectID,CT4000.ObjectName,
	 CT4000.ServiceTypeID, CT1001.ServiceTypeName,
	CT4000.StartDate, CT4000.EndDate,
	 CT4002.TransactionID, 
	CT4002.CaseID, CT4002.TaskID,
	CT4002.InventoryID,AT1302.InventoryName, CT4002.Serial, 
	CT4002.UnitID, 
	AT1103.FullName as EmployeeName,
	CT4002.ErrorStatusID, CT2001.ErrorStatusName,
	CT4002.ErrorLevelID,CT2002.ErrorLevelName, 
	CT4002.ErrorTypeID, CT4002.FileLog,
	CT4002.ErrorIssueID, CT4002.Repair, 
	CT4002.Signature01, CT4002.IsTest, CT4002.FixDate, 
	CT4002.StartTime, CT4002.EndTime, CT4002.MonitorTime, CT4002.FixNextDate, 
	CT4002.Signature02, CT4002.Notes01, CT4002.Notes02, CT4002.Notes03, CT4002.Notes04, CT4002.Notes05, 
	CT4002.IsReplace
From CT4002
	Left   Join CT4000 on CT4000.WMFileID = CT4002.WMFileID and CT4000.DivisionID = CT4002.DivisionID
	Inner Join AT1302 on AT1302.InventoryID = CT4002.InventoryID and AT1302.DivisionID = CT4002.DivisionID
	Left Join CT2001 on CT2001.ErrorStatusID = CT4002.ErrorstatusID and CT2001.DivisionID = CT4002.DivisionID
	Inner Join CT2002 on CT2002.ErrorLevelID =CT4002.ErrorLevelID and CT2002.DivisionID =CT4002.DivisionID
	Left  join CT1001 on CT1001.ServiceTypeID =  CT4000.ServiceTypeID and CT1001.DivisionID =  CT4000.DivisionID
	Left Join AT1103 on AT1103.EmployeeID = CT4002.EmployeeID
			and AT1103.DivisionID = CT4002.DivisionID

Where CT4002.DivisionID = '''+@DivisionID+''' and
	CT4002.WMFileID = '''+@WMFileID+'''

'
---Print @sSQL
If  not exists  (Select  top 1 1 From SysObjects Where Xtype ='V' and Name ='CV3011')
	Exec( ' Create View CV3011 as '  +@sSQL ) ---tao boi store CV3011
Else
	Exec('  Alter View CV3011 as  ' +@sSQL) ----Tao boi store CV3011