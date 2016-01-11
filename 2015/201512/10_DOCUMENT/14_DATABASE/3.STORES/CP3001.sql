/****** Object:  StoredProcedure [dbo].[CP3001]    Script Date: 07/30/2010 10:22:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
----------NguyenThuyTuyen
-------19/12/2006
-----Lay du lieu cho man hinh bao cao lich su lam viec

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[CP3001] @DivisionID as nvarchar(20),
				@ToMonth as int ,
				@ToYear as int,
				@FromMonth as int ,
				@FromYear as int					
 AS

 Declare @sSQL nvarchar(4000)

Set @sSQL ='
Select
	CT5003.VoucherID, 
	CT5003.VoucherTypeID, 
	CT5003.RequestNo, 
	CT5003.WMFileID, 
	Isnull (CT5003.WMFileName,CT4000.WMFileName) as WMFileName,  
	CT5003.ObjectID, 
	Isnull (CT5003.ObjectName,AT1202.ObjectName) as ObjectName, 
	CT5003.Address, 
	CT5003.Contactor, 
	CT5003.Mobile, 
	CT5003.Email, 
	CT5003.PositionMan,
	CT5003.RecordMan,
	T02.FullName as RecordManName,
	CT5003.AssignMan, 
	T01.FullName as AssignManName,
	CT5003.PerformMan, 
	CT5003.PerformManName,
	CT5003.RecordDate, 
	CT5003.PerformDate, 
	CT5003.PerFormTime, 
	CT5003.InventoryID, 
	AT1302.InventoryName,
	CT5003.Serial, 
	CT5003.Place, 
	CT5003.RecordStatus, 
	CT5003.Notes, 
	CT5003.WProducer, 
	CT5003.WCompany, 
	CT5003.Timelimit, 
	CT5003.IsUpDateName, 
	CT5003.IsSystem, 
	CT5003.Status, 
	CT5003.TranMonth, 
	CT5003.TranYear, 
	CT5003.DivisionID,
	CT4000.ContractNo, 
	CT4000.StartDate, 
	CT4000.EndDate,
	CT1001.ServiceTypeName,
	CT5003.Disabled
From CT5003
inner Join CT4000 on  CT4000.WMFileID = CT5003.WMFileID and CT4000.DivisionID = CT5003.DivisionID
left Join AT1202 on AT1202.ObjectID = CT4000.ObjectID and AT1202.DivisionID = CT4000.DivisionID 
left Join AT1302 on AT1302.InventoryID = CT5003.InventoryID and AT1302.DivisionID = CT5003.DivisionID 
left  Join AT1103 T01 on T01.EmployeeID = CT5003.AssignMan
		and T01.DivisionID = CT5003.DivisionID
left  Join AT1103 T02 on T02.EmployeeID = CT5003.AssignMan
		and T02.DivisionID = CT5003.DivisionID
Left Join CT1001 on CT1001.ServiceTypeID = CT4000.ServiceTypeID and CT1001.DivisionID = CT4000.DivisionID
Where CT5003.DivisionID = '''+@DivisionID+''' and
CT5003.Tranmonth + CT5003.TranYear *100 between ( '+str(@ToMonth)+' + '+str(@ToYear)+' *100)    and  ('+str(@FromMonth)+' + '+str(@FromYear)+' *100 )
	
'  
		
---Print @sSQL
If  not exists  (Select  top 1 1 From SysObjects Where Xtype ='V' and Name ='CV3001')
	Exec( ' Create View CV3001 as '  +@sSQL ) ---tao boi store CV3001
Else
	Exec('  Alter View CV3001 as  ' +@sSQL) ----Tao boi store CV3001